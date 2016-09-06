//
//  ToDoCellView.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import Cocoa

class ToDoCellView: NSTableCellView {

    static let identifier = "ToDoCell"

    @IBOutlet var checkbox: NSButton!

    var titleTextField: NSTextField! {
        get { return textField }
        set { textField = newValue }
    }
}
