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

    // MARK: Table View Delegate

    func testCellView_DelegatesToDataSource() {

        let dataSourceDouble = TestDataSource()
        controller.dataSource = dataSourceDouble

        let tableView = NSTableView()
        let column = NSTableColumn(identifier: "irrelevant")
        let row = 123

        controller.tableView(tableView, viewFor: column, row: row)

        XCTAssertNotNil(dataSourceDouble.didRequestCellViewWith)
        if let values = dataSourceDouble.didRequestCellViewWith {
            // Note: column is not used
            XCTAssertEqual(values.row, row)
            XCTAssert(values.tableView === tableView)
            XCTAssert(values.owner === controller)
        }
    }


    // MARK: Displaying To Do List View Models

    func testDisplayList_ChangesTitleTextFieldContents() {

        let title = "The Title"
        let viewModel = ToDoListViewModel(title: title, items: [], selectedRow: nil)
        let textFieldDouble = NSTextField()
        controller.titleTextField = textFieldDouble

        controller.displayToDoList(toDoListViewModel: viewModel)

        XCTAssertEqual(textFieldDouble.stringValue, title)
    }

    func testDisplayList_DelegatesToTableDataSource() {

        let dataSourceDouble = TestDataSource()
        let viewModel = ToDoListViewModel(title: "some title", items: [], selectedRow: nil)
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
            fileprivate override func reloadData() {

                didReloadData = true
            }
        }

        let tableViewDouble = TestTableView()
        let viewModel = ToDoListViewModel(title: "irrelevant", items: [], selectedRow: nil)
        controller.tableView = tableViewDouble

        controller.displayToDoList(toDoListViewModel: viewModel)

        XCTAssert(tableViewDouble.didReloadData)
    }


    // MARK: - Collaborators

    class TestDataSource: NullToDoTableDataSource {

        var didUpdateWith: ToDoListViewModel?
        override func updateContents(toDoListViewModel viewModel: ToDoListViewModel) {

            didUpdateWith = viewModel
        }

        var testToDoCellView: ToDoCellView?
        var didRequestCellViewWith: (tableView: NSTableView, row: Int, owner: AnyObject)?
        override func toDoCellView(tableView: NSTableView, row: Int, owner: AnyObject) -> ToDoCellView? {

            didRequestCellViewWith = (tableView, row, owner)

            return testToDoCellView
        }
    }
}
