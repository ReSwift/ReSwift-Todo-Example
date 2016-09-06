//
//  ToDoReducerTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
import ReSwift
@testable import ReSwiftTodo

class ToDoReducerTests: XCTestCase {

    let reducer = ToDoReducer()

    func testHandleAction_WithUnsupportedActionAndNil_ReturnsNil() {

        struct SomeAction: Action { }

        XCTAssertNil(reducer.handleAction(SomeAction(), state: nil))
    }

    func testHandleAction_WithUnsupportedActionAndState_ReturnsState() {

        struct SomeAction: Action { }
        let state = ToDo(title: "an item", completed: true)

        let result = reducer.handleAction(SomeAction(), state: state)

        XCTAssertEqual(result, state)
    }

    func testHandleAction_WithCheckAction_UncheckedToDoWithDifferentID_ReturnsSameState() {

        let state = ToDo(title: "irrelevant", completed: true)

        let result = reducer.handleAction(ToDoAction.check(ToDoID()), state: state)

        XCTAssertEqual(result, state)
    }

    func testHandleAction_WithCheckAction_UncheckedToDoWithSameID_ReturnsCheckedToDo() {

        let toDoID = ToDoID()
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completed: false)

        let result = reducer.handleAction(ToDoAction.check(toDoID), state: state)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssert(result.completed)
        }
    }

    func testHandleAction_WithCheckAction_CheckedToDoWithSameID_ReturnsCheckedToDo() {

        let toDoID = ToDoID()
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completed: true)

        let result = reducer.handleAction(ToDoAction.check(toDoID), state: state)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssert(result.completed)
        }
    }
    
    func testHandleAction_WithUncheckAction_CheckedToDoWithDifferentID_ReturnsSameState() {

        let state = ToDo(title: "irrelevant", completed: false)

        let result = reducer.handleAction(ToDoAction.uncheck(ToDoID()), state: state)

        XCTAssertEqual(result, state)
    }

    func testHandleAction_WithUncheckAction_CheckedToDoWithSameID_ReturnsUncheckedToDo() {

        let toDoID = ToDoID()
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completed: true)

        let result = reducer.handleAction(ToDoAction.uncheck(toDoID), state: state)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssertFalse(result.completed)
        }
    }

    func testHandleAction_WithUncheckAction_UncheckedToDoWithSameID_ReturnsUncheckedToDo() {

        let toDoID = ToDoID()
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completed: false)

        let result = reducer.handleAction(ToDoAction.uncheck(toDoID), state: state)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssertFalse(result.completed)
        }
    }

}
