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

extension ToDoListViewModel {

    init(toDoList: ToDoList) {

        self.title = toDoList.title
    }
}

extension ToDoListPresenter: StoreSubscriber {

    func newState(state: ToDoListState) {

        let viewModel = ToDoListViewModel(toDoList: state.toDoList)

        view.displayToDoList(toDoListViewModel: viewModel)
    }
}
