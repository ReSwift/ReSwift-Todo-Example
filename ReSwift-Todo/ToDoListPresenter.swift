//
//  ToDoListPresenter.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 30/01/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

protocol DisplaysToDoList {

    func displayToDoList(toDoList: ToDoList)
}

class ToDoListPresenter {

    typealias View = DisplaysToDoList

    let view: View

    init(view: View) {

        self.view = view
    }
}

extension ToDoListPresenter: StoreSubscriber {

    func newState(state: ToDoListState) {

        view.displayToDoList(state.toDoList)
    }
}
