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

    // MARK: - Import Text
    
    func testImportText_EmptyString_ReturnsEmptyList() {

        var maybeResult: ToDoList?

        expectNoError { 
            maybeResult = try importer.importToDoList(text: "")
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        XCTAssertEqual(result, ToDoList.empty)
    }

    func testImportText_BogusString_ReturnsEmptyList() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(text: "something something")
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        XCTAssertEqual(result, ToDoList.empty)
    }

    func testImportText_ProjectTitle_ReturnsListWithTitle() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(text: "The Project:")
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        XCTAssertEqual(result, ToDoList(title: "The Project", items: []))
    }

    func testImportText_ProjectTitleFollowedByTextLine_ReturnsListWithTitleAndItem() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(text: [
                "The Project:",
                "text",
                "- item"
                ].joined(separator: "\n")
            )
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        let expectedList = ToDoList(title: "The Project", items: [ToDo(title: "item")])
        XCTAssert(result.hasEqualContent(expectedList))
    }

    func testImportText_ProjectTitleFollowedByEmptyLine_ReturnsListWithTitleOnly() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(text: [
                "The Project:",
                "",
                "- item"
                ].joined(separator: "\n")
            )
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        let expectedList = ToDoList(title: "The Project", items: [ToDo(title: "item")])
        XCTAssert(result.hasEqualContent(expectedList))
    }

    func testImportText_ProjectTitleAndSeparatedDashedLines_ReturnsListWithTitleAndItems() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(text: [
                "Le Title:",
                "- fum",
                "",
                "- fam"
                ].joined(separator: "\n")
            )
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        let expectedList = ToDoList(title: "Le Title", items: [ToDo(title: "fum"), ToDo(title: "fam")])
        XCTAssert(result.hasEqualContent(expectedList))
    }

    func testImportText_ProjectTitleAndDashedLines_ReturnsListWithTitleAndItems() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(text: [
                "The Project:",
                "- foo",
                "- bar"
                ].joined(separator: "\n")
            )
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        let expectedList = ToDoList(title: "The Project", items: [ToDo(title: "foo"), ToDo(title: "bar")])
        XCTAssert(result.hasEqualContent(expectedList))
    }

    func testImportText_DashedLines_ReturnsListWithoutTitle() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(text: [
                "- boo",
                "- huu"
                ].joined(separator: "\n")
            )
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        let expectedList = ToDoList(title: nil, items: [ToDo(title: "boo"), ToDo(title: "huu")])
        XCTAssert(result.hasEqualContent(expectedList))
    }

    func testImportText_DashedLineWithTags_ReturnsListTaggedItem() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(text: [
                "- foo @bar @baz"
                ].joined(separator: "\n")
            )
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        let expectedList = ToDoList(title: nil, items: [ToDo(title: "foo", tags: Set(arrayLiteral: "bar", "baz"))])
        XCTAssert(result.hasEqualContent(expectedList))
    }

    // MARK: Import short.txt

    let shortFixtureURL: URL! = Bundle(for: ToDoListImporterTests.self).url(forResource: "short", withExtension: "txt")

    func testImportShort_ReturnsList() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(url: shortFixtureURL)
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        let expectedList = ToDoList(title: "Buy Groceries", items: [ToDo(title: "buy 2l milk"), ToDo(title: "buy 400g cheese")])
        XCTAssert(result.hasEqualContent(expectedList))
    }

    // MARK: Import complex.txt

    let complexFixtureURL: URL! = Bundle(for: ToDoListImporterTests.self).url(forResource: "complex", withExtension: "txt")

    func testImportComplex_ReturnsList() {

        var maybeResult: ToDoList?

        expectNoError {
            maybeResult = try importer.importToDoList(url: complexFixtureURL)
        }

        guard let result = maybeResult
            else { XCTFail("expected result"); return }

        let expectedList = ToDoList(
            title: "Run Errands",
            items: [
                ToDo(title: "buy 2l milk", tags: Set(arrayLiteral: "storeA")),
                ToDo(title: "buy 400g cheese", tags: Set(arrayLiteral: "storeA")),
                ToDo(title: "buy matches", tags: Set(arrayLiteral: "storeB"), completion: .finished(when: Calendar.autoupdatingCurrent.dateFromISOComponents(year: 2016, month: 9, day: 10)))
            ])
        XCTAssert(result.hasEqualContent(expectedList))
    }

}
