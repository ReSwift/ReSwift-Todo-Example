//
//  ToDoListTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftTodo

class ToDoListTests: XCTestCase {

    func testEqualContent_WithDifferentTitles_ReturnsFalse() {

        let items = [ToDo(title: "irrelevant", completion: .finished(when: nil))]

        XCTAssertFalse(ToDoList(title: "a", items: items).hasEqualContent(ToDoList(title: "b", items: items)))
    }

    func testEqualContent_WithDifferentItems_ReturnsFalse() {

        let oneItems = [ToDo(title: "one", completion: .finished(when: nil))]
        let otherItems = [ToDo(title: "other", completion: .finished(when: nil))]

        XCTAssertFalse(ToDoList(title: "a", items: oneItems).hasEqualContent(ToDoList(title: "a", items: otherItems)))
    }

    func testEqualContent_With1ContentEqualItem_ReturnsTrue() {

        let oneItems = [ToDo(title: "same", completion: .finished(when: nil))]
        let otherItems = [ToDo(title: "same", completion: .finished(when: nil))]

        XCTAssertTrue(ToDoList(title: "a", items: oneItems).hasEqualContent(ToDoList(title: "a", items: otherItems)))
    }

    func testEqualContent_With1ContentEqualItemButDifferentCountsLeft_ReturnsFalse() {

        let oneItems = [
            ToDo(title: "same", completion: .finished(when: nil))
        ]
        let otherItems = [
            ToDo(title: "same", completion: .finished(when: nil)),
            ToDo(title: "other", completion: .finished(when: nil))
        ]

        XCTAssertFalse(ToDoList(title: "a", items: oneItems).hasEqualContent(ToDoList(title: "a", items: otherItems)))
    }

    func testEqualContent_With1ContentEqualItemButDifferentCountsRight_ReturnsFalse() {

        let oneItems = [
            ToDo(title: "same", completion: .finished(when: nil)),
            ToDo(title: "other", completion: .finished(when: nil))
        ]
        let otherItems = [
            ToDo(title: "same", completion: .finished(when: nil))
        ]

        XCTAssertFalse(ToDoList(title: "a", items: oneItems).hasEqualContent(ToDoList(title: "a", items: otherItems)))
    }

    func testEqualContent_WithContentEqualItemsPlusDifference_ReturnsFalse() {

        let oneItems = [
            ToDo(title: "same", completion: .finished(when: nil)),
            ToDo(title: "different", completion: .finished(when: nil))
        ]
        let otherItems = [
            ToDo(title: "same", completion: .finished(when: nil)),
            ToDo(title: "unlike", completion: .finished(when: nil))
        ]

        XCTAssertFalse(ToDoList(title: "a", items: oneItems).hasEqualContent(ToDoList(title: "a", items: otherItems)))
    }

    func testEqualContent_WithContentEqualDuplicateItems_ReturnsFalse() {

        let oneItems = [
            ToDo(title: "same", completion: .finished(when: nil)),
            ToDo(title: "same", completion: .finished(when: nil))
        ]
        let otherItems = [
            ToDo(title: "same", completion: .finished(when: nil)),
            ToDo(title: "unlike", completion: .finished(when: nil))
        ]

        XCTAssertFalse(ToDoList(title: "a", items: oneItems).hasEqualContent(ToDoList(title: "a", items: otherItems)))
    }


    // MARK: Adding items

    func testAppendItem_EmptyList_AddsItem() {

        let toDo = ToDo(title: "an item")
        var list = ToDoList.empty

        list.appendItem(toDo)

        let expectedList = ToDoList(title: nil, items: [toDo])
        XCTAssertEqual(list, expectedList)
    }

    func testAppendItem_ListWithItem_AddsItemToEnd() {

        let newToDo = ToDo(title: "new item")
        let existingToDo = ToDo(title: "existing item")
        var list = ToDoList(title: nil, items: [existingToDo])

        list.appendItem(newToDo)

        let expectedList = ToDoList(title: nil, items: [existingToDo, newToDo])
        XCTAssertEqual(list, expectedList)
        let wronglySortedList = ToDoList(title: nil, items: [newToDo, existingToDo])
        XCTAssertNotEqual(list, wronglySortedList)
    }

    func testInsertItem_EmptyList_At0_AddsItem() {

        let toDo = ToDo(title: "an item")
        var list = ToDoList.empty

        list.insertItem(toDo, atIndex: 0)

        let expectedList = ToDoList(title: nil, items: [toDo])
        XCTAssertEqual(list, expectedList)
    }

    func testInsertItem_EmptyList_AtNegativeValue_AddsItem() {

        let toDo = ToDo(title: "an item")
        var list = ToDoList.empty

        list.insertItem(toDo, atIndex: -123)

        let expectedList = ToDoList(title: nil, items: [toDo])
        XCTAssertEqual(list, expectedList)
    }

    func testInsertItem_EmptyList_At1000_AddsItem() {

        let toDo = ToDo(title: "an item")
        var list = ToDoList.empty

        list.insertItem(toDo, atIndex: 1000)

        let expectedList = ToDoList(title: nil, items: [toDo])
        XCTAssertEqual(list, expectedList)
    }

    func testInsertItem_ListWithItem_AtNegativeValue_AddsItemToBeginning() {

        let newToDo = ToDo(title: "new item")
        let existingToDo = ToDo(title: "existing item")
        var list = ToDoList(title: nil, items: [existingToDo])

        list.insertItem(newToDo, atIndex: -999)

        let expectedList = ToDoList(title: nil, items: [newToDo, existingToDo])
        XCTAssertEqual(list, expectedList)
        let wronglySortedList = ToDoList(title: nil, items: [existingToDo, newToDo])
        XCTAssertNotEqual(list, wronglySortedList)
    }

    func testInsertItem_ListWithItem_At0_AddsItemToBeginning() {

        let newToDo = ToDo(title: "new item")
        let existingToDo = ToDo(title: "existing item")
        var list = ToDoList(title: nil, items: [existingToDo])

        list.insertItem(newToDo, atIndex: 0)

        let expectedList = ToDoList(title: nil, items: [newToDo, existingToDo])
        XCTAssertEqual(list, expectedList)
        let wronglySortedList = ToDoList(title: nil, items: [existingToDo, newToDo])
        XCTAssertNotEqual(list, wronglySortedList)
    }

    func testInsertItem_ListWithItem_AtHighValue_AddsItemToEnd() {

        let newToDo = ToDo(title: "new item")
        let existingToDo = ToDo(title: "existing item")
        var list = ToDoList(title: nil, items: [existingToDo])

        list.insertItem(newToDo, atIndex: 123)

        let expectedList = ToDoList(title: nil, items: [existingToDo, newToDo])
        XCTAssertEqual(list, expectedList)
        let wronglySortedList = ToDoList(title: nil, items: [newToDo, existingToDo])
        XCTAssertNotEqual(list, wronglySortedList)
    }

    func testInsertItem_ListWith2Items_At1_AddsItemInBetween() {

        let newToDo = ToDo(title: "new item")
        let firstToDo = ToDo(title: "existing item")
        let secondToDo = ToDo(title: "another existing item")
        var list = ToDoList(title: nil, items: [firstToDo, secondToDo])

        list.insertItem(newToDo, atIndex: 1)

        let expectedList = ToDoList(title: nil, items: [firstToDo, newToDo, secondToDo])
        XCTAssertEqual(list, expectedList)
    }
}
