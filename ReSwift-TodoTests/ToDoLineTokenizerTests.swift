//
//  ToDoLineTokenizerTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftTodo

class ToDoLineTokenizerTests: XCTestCase {

    var tokenizer: ToDoLineTokenizer!

    override func setUp() {

        super.setUp()

        tokenizer = ToDoLineTokenizer()
    }

    func testParse_EmptyString_ReturnsNil() {

        XCTAssertNil(tokenizer.token(text: ""))
    }

    func testParse_Newline_ReturnsNil() {

        XCTAssertNil(tokenizer.token(text: "\n"))
    }

    func testParse_TextString_ReturnsComment() {

        let text = "some - text : here!!1"

        let result = tokenizer.token(text: text)

        guard let token = result,
            case .comment(let comment) = token else {
            XCTFail("wrong case"); return
        }

        XCTAssertEqual(comment, text)
    }

    func testParse_DashedLine_ReturnsTodo() {

        let result = tokenizer.token(text: "- foo")

        guard let token = result,
            case .toDo(let toDo) = token else {
                XCTFail("wrong case"); return
        }

        let expectedToDo = ToDo(title: "foo")
        XCTAssert(toDo.hasEqualContent(expectedToDo))
    }

    func testParse_DashedLineWithTags_ReturnsTodo() {

        let result = tokenizer.token(text: "-    foo @fizz fazz  @buzz  ")

        guard let token = result,
            case .toDo(let toDo) = token else {
                XCTFail("wrong case"); return
        }

        XCTAssertEqual(toDo.title, "foo")
        XCTAssertEqual(toDo.tags, Set(arrayLiteral: "fizz", "buzz"))
        XCTAssertFalse(toDo.isFinished)
    }

    func testParse_DashedLineWithDoneTag_ReturnsFinishedTodo() {

        let result = tokenizer.token(text: "- le item @done  ")

        guard let token = result,
            case .toDo(let toDo) = token else {
                XCTFail("wrong case"); return
        }

        XCTAssertEqual(toDo.title, "le item")
        XCTAssert(toDo.tags.isEmpty)
        XCTAssert(toDo.isFinished)
    }

    func testParse_DashedLineWithDoneAndDate_ReturnsFinishedTodo() {

        let result = tokenizer.token(text: "- an item @done(2016-09-11) ")

        guard let token = result,
            case .toDo(let toDo) = token else {
                XCTFail("wrong case"); return
        }

        XCTAssertEqual(toDo.title, "an item")
        XCTAssert(toDo.tags.isEmpty)
        XCTAssert(toDo.isFinished)

        guard case .finished(when: let date) = toDo.completion else { return }

        let expectedDate = Calendar.autoupdatingCurrent.dateFromISOComponents(year: 2016, month: 9, day: 11)!
        XCTAssertEqual(date, expectedDate)
    }

    func testParse_TextWithColon_ReturnsProjectTitle() {

        let result = tokenizer.token(text: "bar baz:")

        guard let token = result,
            case .projectTitle(let title) = token else {
                XCTFail("wrong case"); return
        }

        XCTAssertEqual(title, "bar baz")
    }

}
