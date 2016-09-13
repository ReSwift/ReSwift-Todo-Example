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

        XCTAssertFalse(ToDo(title: "a", completion: .unfinished).hasEqualContent(ToDo(title: "b", completion: .unfinished)))
    }

    func testHasEqualContent_WithDifferentCompletionState_ReturnsFalse() {

        XCTAssertFalse(ToDo(title: "a", completion: .unfinished).hasEqualContent(ToDo(title: "a", completion: .finished(when: nil))))
    }

    func testHasEqualContent_WithDifferentIDs_ReturnsTrue() {

        XCTAssertTrue(ToDo(toDoID: ToDoID(), title: "a", completion: .unfinished).hasEqualContent(ToDo(toDoID: ToDoID(), title: "a", completion: .unfinished)))
    }
}
