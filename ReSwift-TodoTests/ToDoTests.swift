//
//  ToDoTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftTodo

class ToDoTests: XCTestCase {

    func testHasEqualContent_WithDifferentTitle_ReturnsFalse() {

        XCTAssertFalse(ToDo(title: "a", completed: false).hasEqualContent(ToDo(title: "b", completed: false)))
    }

    func testHasEqualContent_WithDifferentCompletionState_ReturnsFalse() {

        XCTAssertFalse(ToDo(title: "a", completed: false).hasEqualContent(ToDo(title: "a", completed: true)))
    }

    func testHasEqualContent_WithDifferentIDs_ReturnsTrue() {

        XCTAssertTrue(ToDo(toDoID: ToDoID(), title: "a", completed: false).hasEqualContent(ToDo(toDoID: ToDoID(), title: "a", completed: false)))
    }
}
