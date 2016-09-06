//
//  ToDoListReducer.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

class ToDoListReducer: ReSwift.Reducer {

    init() { }

    lazy var toDoReducer: ToDoReducer = ToDoReducer()

    func handleAction(action: Action, state: ToDoListState?) -> ToDoListState {

        // Nil state is only relevant on first launch, so
        // return a demo list for starters.
        guard var state = state else {
            return ToDoListState()
        }

        state.toDoList = passActionToItems(action, toDoList: state.toDoList)

        return state
    }

    func passActionToItems(action: Action, toDoList: ToDoList) -> ToDoList {

        var toDoList = toDoList
        
        toDoList.items = toDoList.items.flatMap { toDoReducer.handleAction(action, state: $0) }
        
        return toDoList
    }
    
}
