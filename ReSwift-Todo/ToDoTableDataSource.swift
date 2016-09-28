//
//  ToDoTableDataSource.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

class ToDoTableDataSource: NSObject {

    var viewModel: ToDoListViewModel?
}

extension ToDoTableDataSource: NSTableViewDataSource {

    func numberOfRows(in tableView: NSTableView) -> Int {

        return viewModel?.itemCount ?? 0
    }
}

extension ToDoTableDataSource: ToDoTableDataSourceType {

    var selectedRow: Int? { return viewModel?.selectedRow }
    var selectedToDo: ToDoViewModel? { return viewModel?.selectedToDo }
    var toDoCount: Int { return viewModel?.itemCount ?? 0 }
    
    func updateContents(toDoListViewModel viewModel: ToDoListViewModel) {

        self.viewModel = viewModel
    }

    func toDoCellView(tableView: NSTableView, row: Int, owner: AnyObject) -> ToDoCellView? {

        guard let cellViewModel = viewModel?.items[safe: row],
            let cellView = ToDoCellView.make(tableView: tableView, owner: owner)
            else { return nil }

        cellView.showToDo(toDoViewModel: cellViewModel)

        return cellView
    }
}
