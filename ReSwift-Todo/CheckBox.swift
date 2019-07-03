//
//  CheckBox.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

class CheckBox: NSButton {
    var checked: Bool {
        get { return state == .on }
        set { state = newValue ? .on : .off }
    }
}
