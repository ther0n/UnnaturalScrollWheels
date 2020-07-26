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
    
    var statusItem: NSStatusItem?
    var prefsWindow: NSWindow?
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var showMenuBarItem: NSMenuItem?
    @IBOutlet weak var openAtLoginItem: NSMenuItem?
    @IBOutlet weak var preferencesMenuItem: NSMenuItem?
    @IBOutlet weak var aboutMenuItem: NSMenuItem?
    @IBOutlet weak var quitMenuItem: NSMenuItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        Options.shared.loadOptions()
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "⭥"
        showMenuBarItem?.state = Options.shared.showMenuBarIcon ? NSControl.StateValue.on : NSControl.StateValue.off
        if let menu = menu {
            statusItem?.menu = menu
        }
        showMenuBarIcon()
        ScrollInterceptor.shared.interceptScroll()
    }

    @IBAction func openAtLoginClicked(_ sender: Any) {
        let url = URL(string: "https://github.com/ther0n/UnnaturalScrollWheels/blob/master/RunAtLogin.md")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func showMenuBarIconClicked(_ sender: Any) {
        Options.shared.showMenuBarIcon = !Options.shared.showMenuBarIcon
        UserDefaults.standard.set(Options.shared.showMenuBarIcon, forKey: "ShowMenuBarIcon")
        showMenuBarItem?.state = Options.shared.showMenuBarIcon ? NSControl.StateValue.on : NSControl.StateValue.off
        showMenuBarIcon()
    }
    
    @IBAction func preferencesClicked(_ sender: Any) {
        showPreferences()
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
        statusItem?.length = NSStatusItem.variableLength
        prefsWindow?.makeKeyAndOrderFront(self)
        NSApp.activate(ignoringOtherApps: true)
    }

    func windowWillClose(_ notification: Notification)
    {
        prefsWindow = nil
        showMenuBarIcon()
    }
    
    func showMenuBarIcon() {
        if Options.shared.showMenuBarIcon {
            statusItem?.length = NSStatusItem.variableLength
        } else {
            statusItem?.length = 0.0
        }
    }
    
    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        if !flag {
            showPreferences()
        }
        return true
    }
}
