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

        var toDoList = state.toDoList
        toDoList = passActionToList(action, toDoList: toDoList)
        toDoList = passActionToItems(action, toDoList: toDoList)
        state.toDoList = toDoList

        return state
    }

    func passActionToList(action: Action, toDoList: ToDoList) -> ToDoList {

        guard let action = action as? ToDoListAction else { return toDoList }

        switch action {
        case .rename(let newName):

            var result = toDoList
            result.title = newName
            return result

        case .replaceList(let newList): return newList
        }
    }

    func passActionToItems(action: Action, toDoList: ToDoList) -> ToDoList {

        var toDoList = toDoList
        
        toDoList.items = toDoList.items.flatMap { toDoReducer.handleAction(action, state: $0) }
        
        return toDoList
    }
    
}
