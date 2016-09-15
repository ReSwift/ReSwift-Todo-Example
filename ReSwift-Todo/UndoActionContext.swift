//
//  UndoActionContext.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

/// Exposes getters to easily query for the current state when creating
/// an `UndoCommand`.
///
/// It would've worked without this type, reaching deep into `ToDoListState`.
/// But then we would end up with very tight coupling.
protocol UndoActionContext {

    var toDoListTitle: String? { get }

    func toDoTitle(toDoID toDoID: ToDoID) -> String?
    func toDoInList(toDoID toDoID: ToDoID) -> ToDoInList?
}

typealias ToDoInList = (toDo: ToDo, index: Int)
