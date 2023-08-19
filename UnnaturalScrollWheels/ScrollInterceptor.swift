//
//  ScrollInterceptor.swift
//  UnnaturalScrollWheels
//
//  Created by Theron Tjapkes on 7/25/20.
//  Copyright © 2020 Theron Tjapkes. All rights reserved.
//

import Foundation
import CoreGraphics

class ScrollInterceptor {
    
    static let shared = ScrollInterceptor()
    
    // Where the magic happens
    let scrollEventCallback: CGEventTapCallBack = { (proxy: CGEventTapProxy, type: CGEventType, event: CGEvent, refcon) in
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
        var eventTap: CFMachPort?
        var runLoopSource: CFRunLoopSource?
        
        eventTap = CGEvent.tapCreate(
            tap: .cghidEventTap,
            place: .tailAppendEventTap,
            options: .defaultTap,
            // Mask to select only scroll wheel events
            eventsOfInterest: CGEventMask(1 << CGEventType.scrollWheel.rawValue),
            callback: scrollEventCallback,
            userInfo: nil
        )
        runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0)
        CFRunLoopAddSource(CFRunLoopGetCurrent(), runLoopSource, CFRunLoopMode.commonModes)
        CGEvent.tapEnable(tap: eventTap!, enable: true)
        CFRunLoopRun()
    }
}
