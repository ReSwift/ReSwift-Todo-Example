//
//  ToDoListReducerTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 30/01/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
import ReSwift
@testable import ReSwiftTodo

class ToDoListReducerTests: XCTestCase {

    let reducer = ToDoListReducer()

    // MARK: Unsupported Action

    func testReduce_NoTodoList_ReturnStateWithDemoList() {

        struct AnyAction: Action {}

        let result = reducer.handleAction(AnyAction(), state: nil)

        XCTAssert(result.toDoList.hasEqualContent(ToDoList.demoList()))
    }

    func testReduce_NoTodoList_DoesntCallToDoReducer() {

        struct AnyAction: Action {}

        let toDoReducerDouble = TestToDoReducer()
        reducer.toDoReducer = toDoReducerDouble

        _ = reducer.handleAction(AnyAction(), state: nil)

        XCTAssertNil(toDoReducerDouble.didHandleActionWith)
    }

    func testReduce_WithTodoList_ForwardsItemToToDoReducer() {

        struct AnyAction: Action {}

        let toDoReducerDouble = TestToDoReducer()
        reducer.toDoReducer = toDoReducerDouble

        let toDo = ToDo(title: "irrelevant", completion: .unfinished)
        let list = ToDoList(title: "irrelevant", items: [toDo])
        let state = ToDoListState(toDoList: list)

        _ = reducer.handleAction(AnyAction(), state: state)

        XCTAssertNotNil(toDoReducerDouble.didHandleActionWith)
        if let values = toDoReducerDouble.didHandleActionWith {
            XCTAssertNotNil(values.action as? AnyAction)
            XCTAssertEqual(values.state, toDo)
        }
    }


    // MARK: Replacement action

    func testReduce_ReplaceAction_ReturnsStateWithNewList() {

        let newList = ToDoList(title: "new", items: [])
        let oldList = ToDoList(title: "old", items: [])
        let state = ToDoListState(toDoList: oldList)

        let result = reducer.handleAction(ToDoListAction.replaceList(newList), state: state)

        XCTAssert(result.toDoList.hasEqualContent(newList))
    }


    // MARK: - Doubles

    class TestToDoReducer: ToDoReducer {

        var testToDo: ToDo? = nil
        var didHandleActionWith: (action: Action, state: ToDo?)?
        override func handleAction(action: Action, state: ToDo?, clock: Clock = Clock()) -> ToDo? {

            didHandleActionWith = (action, state)

            return testToDo
        }
    }
}
