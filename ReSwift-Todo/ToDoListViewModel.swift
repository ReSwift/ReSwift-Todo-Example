//
//  ToDoListViewModel.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwiftz. All rights reserved.
//

import Foundation

struct ToDoListViewModel {

    let title: String
    let items: [ToDoViewModel]
    var itemCount: Int { return items.count }

    let selectedRow: Int?
    var selectedToDo: ToDoViewModel? {

        guard let selectedRow = selectedRow else { return nil }
        return items[safe: selectedRow]
    }
}

extension ToDoListViewModel: Equatable { }

func ==(lhs: ToDoListViewModel, rhs: ToDoListViewModel) -> Bool {

    return lhs.title == rhs.title
}
