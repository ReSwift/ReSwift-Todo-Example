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

    func testDataSource_IsConnected() {

        XCTAssertNotNil(controller.dataSource)
    }

    // MARK: Displaying To Do List View Models

    func testDisplayList_ChangesTitleTextFieldContents() {

        let title = "The Title"
        let viewModel = ToDoListViewModel(title: title, items: [])
        let textFieldDouble = NSTextField()
        controller.titleTextField = textFieldDouble

        controller.displayToDoList(toDoListViewModel: viewModel)

        XCTAssertEqual(textFieldDouble.stringValue, title)
    }

    func testDisplayList_DelegatesToTableDataSource() {

        class TestDataSource: ToDoTableDataSourceType {

            private var tableDataSource: NSTableViewDataSource { return NullTableViewDataSource() }

            var didUpdateWith: ToDoListViewModel?
            private func updateContents(toDoListViewModel viewModel: ToDoListViewModel) {

                didUpdateWith = viewModel
            }
        }

        let dataSourceDouble = TestDataSource()
        let viewModel = ToDoListViewModel(title: "some title", items: [])
        controller.dataSource = dataSourceDouble

        controller.displayToDoList(toDoListViewModel: viewModel)

        XCTAssertNotNil(dataSourceDouble.didUpdateWith)
        if let value = dataSourceDouble.didUpdateWith {
            XCTAssertEqual(value, viewModel)
        }
    }

    func testDisplayList_ReloadsTable() {

        class TestTableView: NSTableView {

            var didReloadData = false
            private override func reloadData() {

                didReloadData = true
            }
        }

        let tableViewDouble = TestTableView()
        let viewModel = ToDoListViewModel(title: "irrelevant", items: [])
        controller.tableView = tableViewDouble

        controller.displayToDoList(toDoListViewModel: viewModel)

        XCTAssert(tableViewDouble.didReloadData)
    }
}

class NullTableViewDataSource: NSObject, NSTableViewDataSource { }
