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
}

extension ToDoListViewModel: Equatable { }

func ==(lhs: ToDoListViewModel, rhs: ToDoListViewModel) -> Bool {

    return lhs.title == rhs.title
}
