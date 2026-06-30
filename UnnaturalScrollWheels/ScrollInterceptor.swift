//
//  ScrollInterceptor.swift
//  UnnaturalScrollWheels
//
//  Created by Theron Tjapkes on 7/25/20.
//  Copyright © 2020 Theron Tjapkes. All rights reserved.
//

import Foundation
import CoreGraphics
import AppKit

class ScrollInterceptor {

    static let shared = ScrollInterceptor()

    private let stateLock = NSLock()
    private var eventTap: CFMachPort?
    private var runLoopSource: CFRunLoopSource?
    private var runLoop: CFRunLoop?
    private var isIntercepting = false
    private var wakeObserver: NSObjectProtocol?

    // Where the magic happens
    let scrollEventCallback: CGEventTapCallBack = { (proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon) in
        // macOS disables the event tap when the callback takes too long, on
        // heavy input, and when the system wakes from sleep / low-battery
        // standby. When that happens the OS delivers one final event of type
        // .tapDisabledByTimeout / .tapDisabledByUserInput. If we don't re-enable
        // the tap here, scroll interception silently dies and the app appears
        // frozen until it is force quit and relaunched (issues #66, #97, #117).
        if type == .tapDisabledByTimeout || type == .tapDisabledByUserInput {
            ScrollInterceptor.shared.reEnableTap()
            return Unmanaged.passUnretained(event)
        }

        guard type == .scrollWheel else {
            return Unmanaged.passUnretained(event)
        }

        //        // Debugging
        //        // Usually 0 if scroll wheel unless Logitech Options or similar interferes
        //        print("Continuous: ", event.getIntegerValueField(.scrollWheelEventIsContinuous))
        //        // Undocumented values, but appear to only be non-zero for trackpads?
        //        print("MomentumPhase: ", event.getDoubleValueField(.scrollWheelEventMomentumPhase))
        //        print("ScrollCount: ", event.getDoubleValueField(.scrollWheelEventScrollCount))
        //        print("ScrollPhase: ", event.getDoubleValueField(.scrollWheelEventScrollPhase))

        var isWheel: Bool = true
        if !Options.shared.alternateDetectionMethod {
            // scrollWheelEventIsContinuous will be 0 for mice and 1 for trackpads
            // probably faster than the alternate detection method since only one comparison
            if event.getIntegerValueField(.scrollWheelEventIsContinuous) != 0 {
                isWheel = false
            }
        } else {
            // Undocumented values but seem to be non-zero only for trackpads
            if event.getIntegerValueField(.scrollWheelEventMomentumPhase) != 0 ||
                event.getDoubleValueField(.scrollWheelEventScrollCount) != 0.0 ||
                event.getDoubleValueField(.scrollWheelEventScrollPhase) != 0.0 {
                isWheel = false
            }
        }

        if isWheel {
            // Invert the scroll event
            if Options.shared.invertVerticalScroll {
                event.setIntegerValueField(
                    .scrollWheelEventDeltaAxis1, value: -event.getIntegerValueField(.scrollWheelEventDeltaAxis1))
            }
            if Options.shared.invertHorizontalScroll {
                event.setIntegerValueField(
                    .scrollWheelEventDeltaAxis2, value: -event.getIntegerValueField(.scrollWheelEventDeltaAxis2))
            }
            // Disable scroll acceleration
            if Options.shared.disableScrollAccel {
                event.setIntegerValueField(.scrollWheelEventDeltaAxis1, value: event.getIntegerValueField(.scrollWheelEventDeltaAxis1).signum() * Options.shared.scrollLines)
            }
        }
        // pass the event to the system
        return Unmanaged.passUnretained(event)
    }

    // Intercept scroll wheel events
    func interceptScroll() {
        stateLock.lock()
        guard !isIntercepting else {
            stateLock.unlock()
            return
        }
        isIntercepting = true
        stateLock.unlock()

        registerForWakeNotifications()

        DispatchQueue.global(qos: .userInteractive).async {
            guard let eventTap = CGEvent.tapCreate(
                tap: .cghidEventTap,
                place: .tailAppendEventTap,
                options: .defaultTap,
                // Mask to select only scroll wheel events
                eventsOfInterest: CGEventMask(1 << CGEventType.scrollWheel.rawValue),
                callback: self.scrollEventCallback,
                userInfo: nil
            ) else {
                // Tap creation can fail if accessibility permission was revoked.
                // Bail out cleanly instead of force-unwrapping and crashing.
                self.clearInterceptionState()
                return
            }

            guard let runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0) else {
                CFMachPortInvalidate(eventTap)
                self.clearInterceptionState()
                return
            }

            let runLoop = CFRunLoopGetCurrent()
            self.stateLock.lock()
            self.eventTap = eventTap
            self.runLoopSource = runLoopSource
            self.runLoop = runLoop
            self.stateLock.unlock()

            CFRunLoopAddSource(runLoop, runLoopSource, CFRunLoopMode.commonModes)
            CGEvent.tapEnable(tap: eventTap, enable: true)
            CFRunLoopRun()

            // Reached only when the run loop is stopped (e.g. during a restart).
            CFRunLoopRemoveSource(runLoop, runLoopSource, CFRunLoopMode.commonModes)
            CFMachPortInvalidate(eventTap)
            self.clearInterceptionState()
        }
    }

    /// Re-enables the existing tap. Called from the tap callback when macOS
    /// disables it, and from the wake-from-sleep notification. If the tap can
    /// no longer be revived it is torn down and recreated.
    func reEnableTap() {
        stateLock.lock()
        let tap = eventTap
        stateLock.unlock()

        guard let tap = tap else {
            // No tap yet (or it was torn down) — (re)start interception.
            restart()
            return
        }

        if !CGEvent.tapIsEnabled(tap: tap) {
            CGEvent.tapEnable(tap: tap, enable: true)
        }

        // If it still won't enable, the tap was invalidated during standby;
        // rebuild it from scratch.
        if !CGEvent.tapIsEnabled(tap: tap) {
            restart()
        }
    }

    /// Tears down the current run loop (if any) and creates a fresh tap.
    private func restart() {
        stateLock.lock()
        let loop = runLoop
        stateLock.unlock()

        if let loop = loop {
            // Causes CFRunLoopRun() in interceptScroll() to return and clean up,
            // which resets isIntercepting so the relaunch below can proceed.
            CFRunLoopStop(loop)
        }

        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 0.5) {
            self.interceptScroll()
        }
    }

    private func registerForWakeNotifications() {
        stateLock.lock()
        let alreadyRegistered = wakeObserver != nil
        stateLock.unlock()
        guard !alreadyRegistered else { return }

        let observer = NSWorkspace.shared.notificationCenter.addObserver(
            forName: NSWorkspace.didWakeNotification,
            object: nil,
            queue: nil
        ) { _ in
            // The HID subsystem can lag behind wake, so re-enable immediately
            // and again shortly after to cover the race.
            ScrollInterceptor.shared.reEnableTap()
            DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + 1.0) {
                ScrollInterceptor.shared.reEnableTap()
            }
        }

        stateLock.lock()
        wakeObserver = observer
        stateLock.unlock()
    }

    private func clearInterceptionState() {
        stateLock.lock()
        eventTap = nil
        runLoopSource = nil
        runLoop = nil
        isIntercepting = false
        stateLock.unlock()
    }
}
