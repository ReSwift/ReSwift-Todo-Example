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

    // MARK: Unsupported Action

    func testReduce_NoTodoList_ReturnStateWithDemoList() {

        struct AnyAction: Action {}

        let result = toDoListReducer(action: AnyAction(), state: nil)

        XCTAssert(result.toDoList.hasEqualContent(ToDoList.demoList()))
    }


    // MARK: Renaming action

    func testReduce_Rename_ReturnsListWithNewName() {

        let newName = "a new name"
        let oldList = ToDoList(title: nil, items: [])
        let state = ToDoListState(toDoList: oldList, selection: nil)

        let result = toDoListReducer(action: RenameToDoListAction(renameTo: newName), state: state)

        XCTAssertEqual(result.toDoList.title, newName)
    }


    // MARK: Replacement action

    func testReduce_ReplaceAction_ReturnsStateWithNewList() {

        let newList = ToDoList(title: "new", items: [])
        let oldList = ToDoList(title: "old", items: [])
        let state = ToDoListState(toDoList: oldList, selection: nil)

        let result = toDoListReducer(action: ReplaceToDoListAction(newToDoList: newList), state: state)

        XCTAssert(result.toDoList.hasEqualContent(newList))
    }

}
