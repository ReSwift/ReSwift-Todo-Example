//
//  ToDoListWindowControllerTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftTodo

class ToDoListWindowControllerTests: XCTestCase {

    var controller: ToDoListWindowController!

    override func setUp() {

        super.setUp()

        let windowController = ToDoListWindowController()
        forceLoadWindowController(windowController)
        controller = windowController
    }

    func testTitleTextField_IsConnected() {

        XCTAssertNotNil(controller.titleTextField)
    }

    func testTableView_IsConnected() {

        XCTAssertNotNil(controller.tableView)
    }

    // MARK: Displaying To Do List View Models

    func testDisplayList_ChangesTitleTextFieldContents() {

        let title = "The Title"
        let viewModel = ToDoListViewModel(title: title)
        let textFieldDouble = NSTextField()
        controller.titleTextField = textFieldDouble

        controller.displayToDoList(toDoListViewModel: viewModel)

        XCTAssertEqual(textFieldDouble.stringValue, title)
    }
}
