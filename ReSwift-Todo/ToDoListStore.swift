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

func documentStore(undoManager undoManager: NSUndoManager) -> ToDoListStore {

    return ToDoListStore(
        reducer: ToDoListReducer(),
        state: nil,
        middleware: [
            loggingMiddleware
        ])
}
