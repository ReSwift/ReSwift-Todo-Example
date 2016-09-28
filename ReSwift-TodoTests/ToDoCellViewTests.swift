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
        view = windowController.tableView.make(withIdentifier: ToDoCellView.reuseIdentifier, owner: nil) as! ToDoCellView
    }

    func testCheckbox_IsConnected() {

        XCTAssertNotNil(view.checkbox)
    }

    func testTitleTextField_IsConnected() {

        XCTAssertNotNil(view.titleTextField)
    }

    func testMake_DelegatesToTableView() {

        class TestTableView: NSTableView {

            var didMakeWith: (identifier: String, owner: Any?)?
            fileprivate override func make(withIdentifier identifier: String, owner: Any?) -> NSView? {

                didMakeWith = (identifier, owner)
                return nil
            }
        }

        let ownerDouble = NSObject()
        let tableViewDouble = TestTableView()

        _ = ToDoCellView.make(tableView: tableViewDouble, owner: ownerDouble)

        XCTAssertNotNil(tableViewDouble.didMakeWith)
        if let values = tableViewDouble.didMakeWith {
            XCTAssertEqual(values.identifier, ToDoCellView.reuseIdentifier)
            XCTAssert(values.owner as? NSObject === ownerDouble)
        }
    }
}
