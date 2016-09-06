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

    func numberOfRowsInTableView(tableView: NSTableView) -> Int {

        return viewModel?.itemCount ?? 0
    }
}

extension ToDoTableDataSource: ToDoTableDataSourceType {

    func updateContents(toDoListViewModel viewModel: ToDoListViewModel) {

        self.viewModel = viewModel
    }

    func toDoCellView(tableView tableView: NSTableView, row: Int, owner: AnyObject) -> ToDoCellView? {

        guard let cellViewModel = viewModel?.items[safe: row],
            cellView = ToDoCellView.make(tableView: tableView, owner: owner)
            else { return nil }

        cellView.showToDo(toDoViewModel: cellViewModel)

        return cellView
    }
}
