//
//  ToDoCellViewTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftTodo

class ToDoCellViewTests: XCTestCase {

    var view: ToDoCellView!

    override func setUp() {

        super.setUp()

        let windowController = ToDoListWindowController()
        forceLoadWindowController(windowController)
        view = windowController.tableView.makeViewWithIdentifier(ToDoCellView.reuseIdentifier, owner: nil) as! ToDoCellView
    }

    func testCheckbox_IsConnected() {

        XCTAssertNotNil(view.checkbox)
    }

    func testTitleTextField_IsConnected() {

        XCTAssertNotNil(view.titleTextField)
    }

}
