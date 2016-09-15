//
//  NullToDoTableDataSource.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa
@testable import ReSwiftTodo

class NullToDoTableDataSource: ToDoTableDataSourceType {

    var tableDataSource: NSTableViewDataSource { return NullTableViewDataSource() }

    var selectedRow: Int? { return nil }
    var selectedToDo: ToDoViewModel? { return nil }
    var toDoCount: Int { return 0 }

    func updateContents(toDoListViewModel viewModel: ToDoListViewModel) {
        // no op
    }

    func toDoCellView(tableView tableView: NSTableView, row: Int, owner: AnyObject) -> ToDoCellView? {

        return nil
    }
}

class NullTableViewDataSource: NSObject, NSTableViewDataSource { }
