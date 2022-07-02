//
//  Options.swift
//  UnnaturalScrollWheels
//
//  Created by Theron Tjapkes on 7/25/20.
//  Copyright © 2020 Theron Tjapkes. All rights reserved.
//
import Cocoa
import Foundation
class Options {
    static let shared = Options()
    var firstLaunch: Bool = true
    var origAccel: Int32 = 45056
    var accel: Int32 = -1
    var showMenuBarIcon: Bool = true
    var invertVerticalScroll: Bool = true
    var invertHorizontalScroll: Bool = false
    var disableScrollAccel: Bool = true
    var scrollLines: Int64 = 3
    var alternateDetectionMethod: Bool = false
    var disableMouseAccel: Bool = false
    var launchAtLogin: Bool = false

    init() {
        if UserDefaults.standard.object(forKey: "FirstLaunch") == nil {
            UserDefaults.standard.set(firstLaunch, forKey: "FirstLaunch")
        }
        if UserDefaults.standard.object(forKey: "ShowMenuBarIcon") == nil {
            UserDefaults.standard.set(showMenuBarIcon, forKey: "ShowMenuBarIcon")
        }
        if UserDefaults.standard.object(forKey: "InvertVerticalScroll") == nil {
            UserDefaults.standard.set(invertVerticalScroll, forKey: "InvertVerticalScroll")
        }
        if UserDefaults.standard.object(forKey: "InvertHorizonalScroll") == nil {
            UserDefaults.standard.set(invertHorizontalScroll, forKey: "InvertHorizonalScroll")
        }
        if UserDefaults.standard.object(forKey: "DisableScrollAccel") == nil {
            UserDefaults.standard.set(disableScrollAccel, forKey: "DisableScrollAccel")
        }
        if UserDefaults.standard.object(forKey: "ScrollLines") == nil {
            UserDefaults.standard.set(scrollLines, forKey: "ScrollLines")
        }
        if UserDefaults.standard.object(forKey: "AlternateDetectionMethod") == nil {
            UserDefaults.standard.set(alternateDetectionMethod, forKey: "AlternateDetectionMethod")
        }
        if UserDefaults.standard.object(forKey: "DisableMouseAccel") == nil {
            UserDefaults.standard.set(disableMouseAccel, forKey: "DisableMouseAccel")
        }
        if UserDefaults.standard.object(forKey: "OriginalAccel") == nil {
            UserDefaults.standard.set(origAccel, forKey: "OriginalAccel")
        }
        if UserDefaults.standard.object(forKey: "LaunchAtLogin") == nil {
            UserDefaults.standard.set(launchAtLogin, forKey: "LaunchAtLogin")
        }
        loadOptions()
    }
    
    func loadOptions() {
        firstLaunch = UserDefaults.standard.bool(forKey: "FirstLaunch")
        showMenuBarIcon = UserDefaults.standard.bool(forKey: "ShowMenuBarIcon")
        invertVerticalScroll = UserDefaults.standard.bool(forKey: "InvertVerticalScroll")
        invertHorizontalScroll = UserDefaults.standard.bool(forKey: "InvertHorizontalScroll")
        disableScrollAccel = UserDefaults.standard.bool(forKey: "DisableScrollAccel")
        scrollLines = Int64(UserDefaults.standard.integer(forKey: "ScrollLines"))
        alternateDetectionMethod = UserDefaults.standard.bool(forKey: "AlternateDetectionMethod")
        disableMouseAccel = UserDefaults.standard.bool(forKey: "DisableMouseAccel")
        launchAtLogin = UserDefaults.standard.bool(forKey: "LaunchAtLogin")
    }
}
