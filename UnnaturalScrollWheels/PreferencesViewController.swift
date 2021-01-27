//
//  PreferencesViewController.swift
//  UnnaturalScrollWheels
//
//  Created by Theron Tjapkes on 7/25/20.
//  Copyright © 2020 Theron Tjapkes. All rights reserved.
//

import Cocoa

class PreferencesViewController: NSViewController {
    @IBOutlet weak var invertVerticalScroll: NSButton?
    @IBOutlet weak var invertHorizontalScroll: NSButton?
    @IBOutlet weak var disableScrollAccel: NSButton?
    @IBOutlet weak var scrollLinesText: NSTextField?
    @IBOutlet weak var scrollLines: NSStepper?
    @IBOutlet weak var alternateDetectionMethod: NSButton?
    @IBOutlet weak var disableMouseAccel: NSButton?
    @IBOutlet weak var showMenuBarItem: NSButton?

    override func viewDidLoad() {
        super.viewDidLoad()
        invertVerticalScroll?.takeIntValueFrom(Options.shared.invertVerticalScroll)
        invertHorizontalScroll?.takeIntValueFrom(Options.shared.invertHorizontalScroll)
        disableScrollAccel?.takeIntValueFrom(Options.shared.disableScrollAccel)
        scrollLines?.takeIntValueFrom(Options.shared.scrollLines)
        scrollLinesText?.takeStringValueFrom(scrollLines?.integerValue)
        alternateDetectionMethod?.takeIntValueFrom(Options.shared.alternateDetectionMethod)
        disableMouseAccel?.takeIntValueFrom(Options.shared.disableMouseAccel)
        showMenuBarItem?.takeIntValueFrom(Options.shared.showMenuBarIcon)
    }
    
    func activate(){
        NSApplication.shared.activate(ignoringOtherApps: true)
    }
    
    @IBAction func scrollLinesStepperPressed(_ sender: Any) {
        scrollLinesText?.takeStringValueFrom(scrollLines?.integerValue)
    }
    
    @IBAction func openHelp(_ sender: Any) {
        let url = URL(string: "https://github.com/ther0n/UnnaturalScrollWheels/blob/master/README.md")!
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func applyPreferences(_ sender: Any) {
        UserDefaults.standard.set(invertVerticalScroll?.state == NSControl.StateValue.on, forKey: "InvertVerticalScroll")
        UserDefaults.standard.set(invertHorizontalScroll?.state == NSControl.StateValue.on, forKey: "InvertHorizontalScroll")
        UserDefaults.standard.set(disableScrollAccel?.state == NSControl.StateValue.on, forKey: "DisableScrollAccel")
        UserDefaults.standard.set(scrollLines?.integerValue, forKey: "ScrollLines")
        UserDefaults.standard.set(alternateDetectionMethod?.state == NSControl.StateValue.on, forKey: "AlternateDetectionMethod")
        UserDefaults.standard.set(disableMouseAccel?.state == NSControl.StateValue.on, forKey: "DisableMouseAccel")
        UserDefaults.standard.set(showMenuBarItem?.state == NSControl.StateValue.on, forKey: "ShowMenuBarIcon")
        Options.shared.loadOptions()
        dismissPreferences(self)
    }
    
    @IBAction func showMenuBarIconClicked(_ sender: Any) {
        Options.shared.showMenuBarIcon = !Options.shared.showMenuBarIcon
        UserDefaults.standard.set(Options.shared.showMenuBarIcon, forKey: "ShowMenuBarIcon")
        showMenuBarItem?.state = Options.shared.showMenuBarIcon ? NSControl.StateValue.on : NSControl.StateValue.off
        MenuBarItem.shared.refreshVisibility()
    }
    
    @IBAction func dismissPreferences(_ sender: Any) {
        self.view.window?.performClose(self)
    }
    
    
}
