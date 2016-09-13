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

    func testParse_TextWithColon_ReturnsProjectTitle() {

        let result = tokenizer.token(text: "bar baz:")

        guard let token = result,
            case .projectTitle(let title) = token else {
                XCTFail("wrong case"); return
        }

        XCTAssertEqual(title, "bar baz")
    }

}
