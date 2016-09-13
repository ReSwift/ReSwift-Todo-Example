//
//  ToDoListPresenter.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 30/01/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

class ToDoListPresenter {

    typealias View = DisplaysToDoList

    let view: View

    init(view: View) {

        self.view = view
    }
}

extension ToDoViewModel {

    init(toDo: ToDo) {

        self.identifier = toDo.toDoID.identifier
        self.title = toDo.title
        self.checked = toDo.isFinished
    }
}

extension ToDoListPresenter: StoreSubscriber {

    func newState(state: ToDoListState) {

        let itemViewModels = state.toDoList.items.map(ToDoViewModel.init)
        let viewModel = ToDoListViewModel(
            title: state.toDoList.title ?? "",
            items: itemViewModels)

        view.displayToDoList(toDoListViewModel: viewModel)
    }
}
