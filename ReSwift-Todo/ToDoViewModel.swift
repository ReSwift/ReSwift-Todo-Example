//
//  ToDoViewModel.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

protocol DisplaysToDo {

    func showToDo(toDoViewModel viewModel: ToDoViewModel)
}

struct ToDoViewModel {

    let identifier: String

    let title: String
    let checked: Bool
}
