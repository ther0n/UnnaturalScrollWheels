//
//  AppDelegate.swift
//  UnnaturalScrollWheels
//
//  Created by Theron Tjapkes on 7/24/20.
//  Copyright © 2020 Theron Tjapkes. All rights reserved.
//

import Cocoa
import Foundation
import IOKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    private let statusItem = MenuBarItem.shared
    var prefsWindow: NSWindow?
    @IBOutlet weak var menu: NSMenu?
    //@IBOutlet weak var showMenuBarItem: NSMenuItem?
    @IBOutlet weak var openAtLoginItem: NSMenuItem?
    @IBOutlet weak var preferencesMenuItem: NSMenuItem?
    @IBOutlet weak var quitMenuItem: NSMenuItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Options.shared.loadOptions()
        self.statusItem.menu = self.menu
        statusItem.refreshVisibility()
        ScrollInterceptor.shared.interceptScroll()
        disableMouseAccel()
    }

    @IBAction func openAtLoginClicked(_ sender: Any) {
        let url = URL(string: "https://github.com/ther0n/UnnaturalScrollWheels/blob/master/RunAtLogin.md")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func preferencesClicked(_ sender: Any) {
        showPreferences()
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
        if Options.shared.disableMouseAccel {
            // Based on https://github.com/apsun/NoMouseAccel
            let accelNum: CFNumber = CFNumberCreate(kCFAllocatorDefault, CFNumberType.sInt32Type, &Options.shared.accel)
            let client: IOHIDEventSystemClient = IOHIDEventSystemClientCreateSimpleClient(kCFAllocatorDefault)
            let mouseAccelerationType: CFString = kIOHIDMouseAccelerationType as NSString
            IOHIDEventSystemClientSetProperty(client, mouseAccelerationType, accelNum)
        }
    }
}
