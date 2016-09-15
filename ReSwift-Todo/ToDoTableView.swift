//
//  ToDoTableView.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

class ToDoTableView: NSTableView {

    override func keyDown(theEvent: NSEvent) {

        // Consume keyDown to prevent interpretation here
        self.nextResponder?.interpretKeyEvents([theEvent])
    }
}
