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


}
