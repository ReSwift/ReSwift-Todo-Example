//
//  ToDoListWindowController.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

protocol ToDoListWindowControllerDelegate: class {

    func toDoListWindowControllerDidLoad(controller: ToDoListWindowController)
    func toDoListWindowControllerWillClose(controller: ToDoListWindowController)
}

class ToDoListWindowController: NSWindowController {

    weak var delegate: ToDoListWindowControllerDelegate?

    convenience init() {

        self.init(windowNibName: String(ToDoListWindowController))
    }
}

extension ToDoListWindowController: DisplaysToDoList {

    func displayToDoList(toDoList: ToDoList) {

        
    }
}
