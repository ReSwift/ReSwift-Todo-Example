//
//  ToDoStore.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

typealias ToDoListStore = Store<ToDoListState>

/// Generic action which can be dispatched. 
/// - Note: Use `UndoableAction` for most UI events instead.
typealias Action = ReSwift.Action
typealias UndoableAction = protocol<Action, Undoable>

func toDoListStore(undoManager undoManager: NSUndoManager) -> ToDoListStore {

    return ToDoListStore(
        reducer: ToDoListReducer(),
        state: nil,
        middleware: [
            loggingMiddleware
        ])
}
