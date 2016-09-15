//
//  ToDoTableDataSourceTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftTodo

class ToDoTableDataSourceTests: XCTestCase {

    let irrelevantTableView = NSTableView()

    func testNumberOfRows_WithoutVM_Returns0() {

        let dataSource = ToDoTableDataSource()

        XCTAssertEqual(dataSource.numberOfRowsInTableView(irrelevantTableView), 0)
    }

    func testNumberOfRows_WithVM_ReturnsVMItemCount() {

        let dataSource = ToDoTableDataSource()
        let items = (0...3).map(String.init)
            .map { ToDoViewModel(identifier: $0, title: $0, checked: false) }
        let viewModel = ToDoListViewModel(title: "irrelevant", items: items, selectedRow: nil)

        dataSource.updateContents(toDoListViewModel: viewModel)

        XCTAssertEqual(dataSource.numberOfRowsInTableView(irrelevantTableView), items.count)
    }
}
