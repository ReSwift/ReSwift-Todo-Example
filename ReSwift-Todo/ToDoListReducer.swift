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
    lazy var selectionReducer: SelectionReducer = SelectionReducer()

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

        state.selection = passActionToSelection(action, selectionState: state.selection)

        return state
    }

    func passActionToList(_ action: Action, toDoList: ToDoList) -> ToDoList {

        guard let action = action as? ToDoListAction else { return toDoList }

        return action.apply(oldToDoList: toDoList)
    }

    func passActionToItems(_ action: Action, toDoList: ToDoList) -> ToDoList {

        var toDoList = toDoList
        
        toDoList.items = toDoList.items.flatMap { toDoReducer.handleAction(action, state: $0) }
        
        return toDoList
    }

    func passActionToSelection(_ action: Action, selectionState: SelectionState) -> SelectionState {

        return selectionReducer.handleAction(action, state: selectionState)
    }
}
