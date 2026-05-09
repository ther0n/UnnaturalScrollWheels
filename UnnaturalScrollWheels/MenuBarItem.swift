//
//  MenuBarItem.swift
//  UnnaturalScrollWheels
//
//  Created by Theron Tjapkes on 1/26/21.
//  Copyright © 2021 Theron Tjapkes. All rights reserved.
//

import Foundation
import Cocoa

class MenuBarItem {

    static let shared = MenuBarItem()
    var statusItem: NSStatusItem?
    public var menu: NSMenu? {
        didSet {
            statusItem?.menu = menu
        }
    }

    public func refreshVisibility() {
        if Options.shared.showMenuBarIcon {
            add()
        } else {
            remove()
        }
    }

    private func add() {
        guard statusItem == nil else {
            statusItem?.menu = menu
            return
        }

        let newStatusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        newStatusItem.button?.title = "⭥"
        newStatusItem.menu = menu
        statusItem = newStatusItem
    }

    private func remove() {
        guard let statusItem = statusItem else { return }
        NSStatusBar.system.removeStatusItem(statusItem)
        self.statusItem = nil
    }
}
