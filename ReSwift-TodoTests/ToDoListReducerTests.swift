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

        let toDo = ToDo(title: "irrelevant", completed: false)
        let list = ToDoList(title: "irrelevant", items: [toDo])
        let state = ToDoListState(toDoList: list)

        _ = reducer.handleAction(AnyAction(), state: state)

        XCTAssertNotNil(toDoReducerDouble.didHandleActionWith)
        if let values = toDoReducerDouble.didHandleActionWith {
            XCTAssertNotNil(values.action as? AnyAction)
            XCTAssertEqual(values.state, toDo)
        }
    }

    class TestToDoReducer: ToDoReducer {

        var testToDo: ToDo? = nil
        var didHandleActionWith: (action: Action, state: ToDo?)?
        override func handleAction(action: Action, state: ToDo?) -> ToDo? {

            didHandleActionWith = (action, state)

            return testToDo
        }
    }
}
