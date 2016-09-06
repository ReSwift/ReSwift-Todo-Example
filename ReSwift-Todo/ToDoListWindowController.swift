//
//  ToDoListWindowController.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

class ToDoListWindowController: NSWindowController {

    convenience init() {

        self.init(windowNibName: String(ToDoListWindowController))
    }
}
