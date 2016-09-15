//
//  ToDoListActions.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

enum ToDoListAction: UndoableAction {

    case rename(String?)
    case replaceList(ToDoList)

    // MARK: Undoable

    var name: String {

        switch self {
        case .rename: return "Rename Project"
        case .replaceList: return "Replace List"
        }
    }

    var isUndoable: Bool {

        switch self {
        case .rename: return true
        default: return false
        }
    }

    func inverse(context context: UndoActionContext) -> UndoableAction? {

        switch self {
        case .rename:
            let oldName = context.toDoListTitle
            return ToDoListAction.rename(oldName)

        default: return nil
        }
    }
}
