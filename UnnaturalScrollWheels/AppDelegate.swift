//
//  AppDelegate.swift
//  UnnaturalScrollWheels
//
//  Created by Theron Tjapkes on 7/24/20.
//  Copyright © 2020 Theron Tjapkes. All rights reserved.
//

import Cocoa
import Foundation

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    private let statusItem = MenuBarItem.shared
    var prefsWindow: NSWindow?
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var openAtLoginItem: NSMenuItem?
    @IBOutlet weak var preferencesMenuItem: NSMenuItem?
    @IBOutlet weak var quitMenuItem: NSMenuItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if Options.shared.firstLaunch {
            UserDefaults.standard.set(false, forKey: "FirstLaunch")
        }
        self.statusItem.menu = self.menu
        refresh()
        if AXIsProcessTrusted() {
            ScrollInterceptor.shared.interceptScroll()
        } else {
            if Options.shared.firstLaunch{
                let alert = NSAlert()
                alert.messageText = NSLocalizedString("PermissionsTitle", comment: "")
                alert.informativeText = NSLocalizedString("PermissionsMessage", comment: "")
            } else {
                accessibilityAlert()
            }
            pollAccessibility()
        }
    }
    
    func applicationWillTerminate(_ anotification: Notification) {
        // Reset the mouse acceleration when application terminates
        Options.shared.disableMouseAccel = false
        disableMouseAccel()
    }
    
    func pollAccessibility() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if AXIsProcessTrusted() {
                ScrollInterceptor.shared.interceptScroll()
            } else {
                self.pollAccessibility()
            }
        }
    }
    
    func accessibilityAlert() {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("PermissionsTitle", comment: "")
        alert.informativeText = NSLocalizedString("PermissionsMessage", comment: "")
        alert.addButton(withTitle: NSLocalizedString("OpenPreferences", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
        if alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn {
            let options: NSDictionary = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String : true]
            AXIsProcessTrustedWithOptions(options)
            //NSWorkspace.shared.open(URL(string:"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!)
        }
        else {
            NSApp.terminate(self)
        }
    }
    
    func refresh() {
        Options.shared.loadOptions()
        statusItem.refreshVisibility()
        disableMouseAccel()
    }
    
    @IBAction func openAtLoginClicked(_ sender: Any) {
        let url = URL(string: "https://github.com/ther0n/UnnaturalScrollWheels/blob/master/RunAtLogin.md")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func preferencesClicked(_ sender: Any) {
        if AXIsProcessTrusted() {
            showPreferences()
        } else{
            accessibilityAlert()
        }
    }
    
    @IBAction func showAbout(_ sender: Any) {
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(sender)
    }
    
    func showPreferences() // called from menu item
    {
        if prefsWindow == nil
        {
            let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
            let controllerId = NSStoryboard.SceneIdentifier("Preferences")
            guard let controller = storyboard.instantiateController(withIdentifier: controllerId) as? NSWindowController else { return }
            guard let window = controller.window else { return }
            
            window.delegate = self
            window.center()
            prefsWindow = window
        }
        prefsWindow?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func windowWillClose(_ notification: Notification)
    {
        prefsWindow = nil
    }
    
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            showPreferences()
        }
        return true
    }
    
    func disableMouseAccel() {
        // Based on https://github.com/apsun/NoMouseAccel
        
        let client: IOHIDEventSystemClient = IOHIDEventSystemClientCreateSimpleClient(kCFAllocatorDefault)
        let mouseAccelerationType: CFString = kIOHIDMouseAccelerationType as NSString
        
        // Get the starting acceleration value
        var origAccel: Int32 = 0
        let originalAccelRef: CFTypeRef = IOHIDEventSystemClientCopyProperty(client, mouseAccelerationType)!
        CFNumberGetValue((originalAccelRef as! CFNumber), CFNumberType.sInt32Type, &origAccel)
        // Only save it if it's not -1 (acceleration off)
        if origAccel != -1 {
            Options.shared.origAccel = origAccel
            UserDefaults.standard.set(origAccel, forKey: "OriginalAccel")
        }
        if Options.shared.disableMouseAccel {
            Options.shared.accel = -1
        } else {
            Options.shared.accel = Options.shared.origAccel
        }
        // Set the mouse acceleration
        let accelNum: CFNumber = CFNumberCreate(kCFAllocatorDefault, CFNumberType.sInt32Type, &Options.shared.accel)
        IOHIDEventSystemClientSetProperty(client, mouseAccelerationType, accelNum)
    }
}

