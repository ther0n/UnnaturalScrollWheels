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
    let appDelegate = NSApp.delegate as? AppDelegate
    
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
    
    @IBAction func invertHorizontalScrollClicked(_ sender: Any){
        Options.shared.invertHorizontalScroll = !Options.shared.invertHorizontalScroll
    }
    
    @IBAction func invertVerticalScrollClicked(_ sender: Any){
        Options.shared.invertVerticalScroll = !Options.shared.invertVerticalScroll
    }
    
    @IBAction func disableScrollAccelClicked(_ sender: Any){
        Options.shared.disableScrollAccel = !Options.shared.disableScrollAccel
    }
    
    @IBAction func scrollLinesStepperPressed(_ sender: Any) {
        scrollLinesText?.takeStringValueFrom(scrollLines?.integerValue)
        Options.shared.scrollLines = Int64(scrollLines!.integerValue)
    }
    
    @IBAction func alternateDetectionMethodClicked(_ sender: Any){
        Options.shared.alternateDetectionMethod = !Options.shared.alternateDetectionMethod
    }
    
    @IBAction func disableMouseAccelClicked(_ sender: Any){
        Options.shared.disableMouseAccel = !Options.shared.disableMouseAccel
        appDelegate?.disableMouseAccel()
    }
    
    @IBAction func showMenuBarItem(_ sender: Any) {
        Options.shared.showMenuBarIcon = !Options.shared.showMenuBarIcon
        MenuBarItem.shared.refreshVisibility()
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
        dismissPreferences(self)
    }
    
    @IBAction func dismissPreferences(_ sender: Any) {
        appDelegate?.refresh()
        self.view.window?.performClose(self)
    }
}
