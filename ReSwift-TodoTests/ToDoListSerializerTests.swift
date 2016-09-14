//
//  ToDoListSerializerTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftTodo

class ToDoListSerializerTests: XCTestCase {

    var serializer: ToDoListSerializer!

    override func setUp() {

        super.setUp()

        serializer = ToDoListSerializer()
    }

    func testSerialize_EmptyList_ReturnsEmptyString() {

        XCTAssertEqual(serializer.string(toDoList: ToDoList.empty), "")
    }

    func testSerialize_TitleOnly_ReturnsProjectTitleLine() {

        let list = ToDoList(title: "the Title", items: [])

        let result = serializer.string(toDoList: list)

        XCTAssertEqual(result, "the Title:\n")
    }

    func testSerialize_ItemsOnly_ReturnsListOfItems() {

        let items = [
            ToDo(title: "foo"),
            ToDo(title: "bar")
        ]
        let list = ToDoList(title: nil, items: items)

        let result = serializer.string(toDoList: list)

        XCTAssertEqual(result, "- foo\n- bar\n")
    }

    func testSerialize_TitleAndItems_ReturnsTitleAndListOfItems() {

        let items = [
            ToDo(title: "baz"),
            ToDo(title: "boz"),
            ToDo(title: "bizz")
        ]
        let list = ToDoList(title: "Project X", items: items)

        let result = serializer.string(toDoList: list)

        XCTAssertEqual(result, "Project X:\n- baz\n- boz\n- bizz\n")
    }

    func testSerialize_FinishedItemWithoutDate_AppendsDoneTag() {

        let items = [ToDo(title: "the item", completion: .finished(when: nil))]
        let list = ToDoList(title: nil, items: items)

        let result = serializer.string(toDoList: list)

        XCTAssertEqual(result, "- the item @done\n")
    }

    func testSerialize_FinishedItemWithDate_AppendsDoneTagWithDate() {

        let date = NSCalendar.autoupdatingCurrentCalendar().dateFromISOComponents(year: 2012, month: 11, day: 10)
        let items = [ToDo(title: "an item", completion: .finished(when: date))]
        let list = ToDoList(title: nil, items: items)

        let result = serializer.string(toDoList: list)

        XCTAssertEqual(result, "- an item @done(2012-11-10)\n")
    }

    func testSerialize_UnfinishedItemWithTags_AppendsTagsSortedAlphabetically() {

        let items = [ToDo(title: "an item", tags: Set(arrayLiteral: "foo", "bar"))]
        let list = ToDoList(title: nil, items: items)

        let result = serializer.string(toDoList: list)

        XCTAssertEqual(result, "- an item @bar @foo\n")
    }

    func testSerialize_FinishedItemWithTags_AppendsTagsSortedAlphabeticallyBeforeDoneTag() {

        let items = [ToDo(title: "ze item", completion: .finished(when: nil), tags: Set(arrayLiteral: "zar", "kar"))]
        let list = ToDoList(title: nil, items: items)

        let result = serializer.string(toDoList: list)

        XCTAssertEqual(result, "- ze item @kar @zar @done\n")
    }
}
