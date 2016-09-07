//
//  ToDoListImporterTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftTodo

class ToDoListImporterTests: XCTestCase {

    var importer: ToDoListImporter!

    override func setUp() {

        super.setUp()

        importer = ToDoListImporter()
    }
    
    func testImportText_EmptyString_ReturnsEmptyList() {

        var maybeResult: ToDoList?

        expectNoError { 
            maybeResult = try importer.importToDoList("")
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        XCTAssertEqual(result, ToDoList.empty)
    }

    func testImportText_BogusString_ReturnsEmptyList() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList("something something")
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        XCTAssertEqual(result, ToDoList.empty)
    }

    func testImportText_ProjectTitle_ReturnsListWithTitle() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList("The Project:")
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        XCTAssertEqual(result, ToDoList(title: "The Project", items: []))
    }

    func testImportText_ProjectTitleAndDashedLines_ReturnsListWithTitleAndItems() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(
                "The Project:\n" +
                "- foo\n" +
                "- bar\n"
            )
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        let expectedList = ToDoList(title: "The Project", items: [ToDo(title: "foo"), ToDo(title: "bar")])
        XCTAssert(result.hasEqualContent(expectedList))
    }
}
