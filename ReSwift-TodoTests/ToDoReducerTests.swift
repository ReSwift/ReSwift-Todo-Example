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
        let state = ToDo(title: "an item", completion: .finished(when: nil))

        let result = reducer.handleAction(SomeAction(), state: state)

        XCTAssertEqual(result, state)
    }

    func testHandleAction_WithCheckAction_UncheckedToDoWithDifferentID_ReturnsSameState() {

        let state = ToDo(title: "irrelevant", completion: .finished(when: nil))

        let result = reducer.handleAction(ToDoAction.check(ToDoID()), state: state)

        XCTAssertEqual(result, state)
    }

    func testHandleAction_WithCheckAction_UncheckedToDoWithSameID_ReturnsCheckedToDo() {

        let newDate = NSDate(timeIntervalSince1970: 12345)
        let clockDouble = ClockStub(date: newDate)
        let toDoID = ToDoID()
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completion: .unfinished)

        let result = reducer.handleAction(ToDoAction.check(toDoID), state: state, clock: clockDouble)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssert(result.isFinished)
            XCTAssert(result.finishedAt?.isEqualToDate(newDate) ?? false)
        }
    }

    func testHandleAction_WithCheckAction_CheckedToDoWithSameID_ReturnsCheckedToDoWithNewDate() {

        let newDate = NSDate(timeIntervalSince1970: 12345)
        let clockDouble = ClockStub(date: newDate)

        let toDoID = ToDoID()
        let oldDate = NSDate(timeIntervalSinceNow: 9876)
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completion: .finished(when: oldDate))

        let result = reducer.handleAction(ToDoAction.check(toDoID), state: state, clock: clockDouble)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.toDoID, toDoID)
            XCTAssertEqual(result.title, state.title)
            XCTAssert(result.isFinished)
            XCTAssert(result.finishedAt?.isEqualToDate(newDate) ?? false)
        }
    }
    
    func testHandleAction_WithUncheckAction_CheckedToDoWithDifferentID_ReturnsSameState() {

        let state = ToDo(title: "irrelevant", completion: .unfinished)

        let result = reducer.handleAction(ToDoAction.uncheck(ToDoID()), state: state)

        XCTAssertEqual(result, state)
    }

    func testHandleAction_WithUncheckAction_CheckedToDoWithSameID_ReturnsUncheckedToDo() {

        let toDoID = ToDoID()
        let state = ToDo(toDoID: toDoID, title: "irrelevant", completion: .finished(when: nil))

        let result = reducer.handleAction(ToDoAction.uncheck(toDoID), state: state)

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

        let result = reducer.handleAction(ToDoAction.uncheck(toDoID), state: state)

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

        let result = reducer.handleAction(ToDoAction.rename(ToDoID(), title: "new title!!1"), state: item)

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

        let result = reducer.handleAction(ToDoAction.rename(toDoID, title: newTitle), state: item)

        XCTAssertNotNil(result)
        if let result = result {
            XCTAssertEqual(result.title, newTitle)
        }
    }
}
