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
    var invertVerticalScroll: Bool
    var invertHorizontalScroll: Bool
    var disableScrollAccel: Bool
    var scrollLines: Int64
    init() {
        if UserDefaults.standard.object(forKey: "InvertVerticalScroll") == nil {
            UserDefaults.standard.set(true, forKey: "InvertVerticalScroll")
        }
        if UserDefaults.standard.object(forKey: "InvertHorizonalScroll") == nil {
            UserDefaults.standard.set(true, forKey: "InvertHorizonalScroll")
        }
        if UserDefaults.standard.object(forKey: "DisableScrollAccel") == nil {
            UserDefaults.standard.set(false, forKey: "DisableScrollAccel")
        }
        if UserDefaults.standard.object(forKey: "ScrollLines") == nil {
            UserDefaults.standard.set(3, forKey: "ScrollLines")
        }
        invertVerticalScroll = UserDefaults.standard.bool(forKey: "InvertVerticalScroll")
        invertHorizontalScroll = UserDefaults.standard.bool(forKey: "InvertHorizontalScroll")
        disableScrollAccel = UserDefaults.standard.bool(forKey: "DisableScrollAccel")
        scrollLines = Int64(UserDefaults.standard.integer(forKey: "ScrollLines"))
    }

}
