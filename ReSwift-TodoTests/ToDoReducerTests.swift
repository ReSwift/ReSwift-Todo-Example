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

    func testHandleAction_WithUnsupportedActionAndNil_ReturnsNil() {

        struct SomeAction: Action { }

        XCTAssertNil(toDoReducer(SomeAction(), state: nil))
    }

    func testHandleAction_WithUnsupportedActionAndState_ReturnsState() {

        struct SomeAction: Action { }
        let state = ToDo(title: "an item", completion: .finished(when: nil))

        let result = toDoReducer(SomeAction(), state: state)

        XCTAssertEqual(result, state)
    }

    func testHandleAction_WithCheckAction_UncheckedToDoWithDifferentID_ReturnsSameState() {

        let state = ToDo(title: "irrelevant", completion: .finished(when: nil))

        let result = toDoReducer(ToDoAction.check(ToDoID()), state: state)

        XCTAssertEqual(result, state)
    }

    func testHandleAction_WithCheckAction_UncheckedToDoWithSameID_ReturnsCheckedToDo() {

        let newDate = Date(timeIntervalSince1970: 12345)
        let clockDouble = ClockStub(date: newDate)
        let toDoID = ToDoID()
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completion: .unfinished)

        let result = toDoReducer(ToDoAction.check(toDoID), state: state, clock: clockDouble)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssert(result.isFinished)
            XCTAssertEqual(result.finishedAt, newDate)
        }
    }

    func testHandleAction_WithCheckAction_CheckedToDoWithSameID_ReturnsCheckedToDoWithNewDate() {

        let newDate = Date(timeIntervalSince1970: 12345)
        let clockDouble = ClockStub(date: newDate)

        let toDoID = ToDoID()
        let oldDate = Date(timeIntervalSinceNow: 9876)
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completion: .finished(when: oldDate))

        let result = toDoReducer(ToDoAction.check(toDoID), state: state, clock: clockDouble)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssert(result.isFinished)
            XCTAssertEqual(result.finishedAt, newDate)
        }
    }
    
    func testHandleAction_WithUncheckAction_CheckedToDoWithDifferentID_ReturnsSameState() {

        let state = ToDo(title: "irrelevant", completion: .unfinished)

        let result = toDoReducer(ToDoAction.uncheck(ToDoID()), state: state)

        XCTAssertEqual(result, state)
    }

    func testHandleAction_WithUncheckAction_CheckedToDoWithSameID_ReturnsUncheckedToDo() {

        let toDoID = ToDoID()
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completion: .finished(when: nil))

        let result = toDoReducer(ToDoAction.uncheck(toDoID), state: state)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssertFalse(result.isFinished)
        }
    }

    func testHandleAction_WithUncheckAction_UncheckedToDoWithSameID_ReturnsUncheckedToDo() {

        let toDoID = ToDoID()
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completion: .unfinished)

        let result = toDoReducer(ToDoAction.uncheck(toDoID), state: state)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssertFalse(result.isFinished)
        }
    }

    func testHandleAction_WithRenameAction_ItemWithDifferentID_ReturnsSameItem() {

        let originalTitle = "old title"
        let item = ToDo(toDoID: ToDoID(), title: originalTitle)

        let result = toDoReducer(ToDoAction.rename(ToDoID(), title: "new title!!1"), state: item)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result, item)
        }
    }

    func testHandleAction_WithRenameAction_ItemWithSameID_ReturnsRenamedItem() {

        let originalTitle = "old title"
        let toDoID = ToDoID()
        let item = ToDo(toDoID: toDoID, title: originalTitle)
        let newTitle = "new title!!1"

        let result = toDoReducer(ToDoAction.rename(toDoID, title: newTitle), state: item)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.title, newTitle)
        }
    }
}
