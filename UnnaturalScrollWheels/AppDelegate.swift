//
//  AppDelegate.swift
//  UnnaturalScrollWheels
//
//  Created by Theron Tjapkes on 7/24/20.
//  Copyright © 2020 Theron Tjapkes. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusItem: NSStatusItem?
    @IBOutlet weak var menu: NSMenu?
    @IBOutlet weak var preferencesMenuItem: NSMenuItem?
    @IBOutlet weak var aboutMenuItem: NSMenuItem?
    @IBOutlet weak var quitMenuItem: NSMenuItem?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem?.button?.title = "⭥"
        
        if let menu = menu {
            statusItem?.menu = menu
        }
        
        ScrollInterceptor.shared.interceptScroll()
    }
}
