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

// A typealias will not work and only raise EXC_BAD_ACCESS exceptions. ¯\_(ツ)_/¯
protocol UndoableAction: Action, Undoable { }

func toDoListStore(undoManager: UndoManager) -> ToDoListStore {

    return ToDoListStore(
        reducer: toDoListReducer,
        state: nil,
        middleware: [
            removeIdempotentActionsMiddleware,
            loggingMiddleware,
            undoMiddleware(undoManager: undoManager)
        ])
}
