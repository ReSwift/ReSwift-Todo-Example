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
}
