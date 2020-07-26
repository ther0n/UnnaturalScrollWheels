//
//  Options.swift
//  UnnaturalScrollWheels
//
//  Created by Theron Tjapkes on 7/25/20.
//  Copyright © 2020 Theron Tjapkes. All rights reserved.
//
import Foundation
class Options {
    static let shared = Options()
    var showMenuBarIcon: Bool = true
    var invertVerticalScroll: Bool = true
    var invertHorizontalScroll: Bool = false
    var disableScrollAccel: Bool = true
    var scrollLines: Int64 = 3
    init() {
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
        loadOptions()
    }
    
    func loadOptions() {
        showMenuBarIcon = UserDefaults.standard.bool(forKey: "ShowMenuBarIcon")
        invertVerticalScroll = UserDefaults.standard.bool(forKey: "InvertVerticalScroll")
        invertHorizontalScroll = UserDefaults.standard.bool(forKey: "InvertHorizontalScroll")
        disableScrollAccel = UserDefaults.standard.bool(forKey: "DisableScrollAccel")
        scrollLines = Int64(UserDefaults.standard.integer(forKey: "ScrollLines"))
    }

}
