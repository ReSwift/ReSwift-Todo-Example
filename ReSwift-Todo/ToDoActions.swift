//
//  ToDoActions.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

enum ToDoAction: UndoableAction {
    
    case check(ToDoID)
    case uncheck(ToDoID)

    case rename(ToDoID, title: String)

    // MARK: Undoable

    var isUndoable: Bool { return true }

    var name: String {
        switch self {
        case .check: return "Finish Task"
        case .uncheck: return "Mark as Unfinished"
        case .rename: return "Rename Task"
        }
    }

    func inverse(context context: UndoActionContext) -> UndoableAction? {

        switch self {
        case .check(let toDoID):
            return ToDoAction.uncheck(toDoID)
        case .uncheck(let toDoID):
            return ToDoAction.check(toDoID)

        case .rename(let toDoID, title: _):
            guard let oldTitle = context.toDoTitle(toDoID: toDoID) else { return nil }
            return ToDoAction.rename(toDoID, title: oldTitle)
        }
    }
}
