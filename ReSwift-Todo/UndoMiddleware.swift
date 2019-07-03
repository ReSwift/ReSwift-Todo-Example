//
//  UndoMiddleware.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

class UndoableStateAdapter: UndoActionContext {

    let state: ToDoListState

    init(toDoListState: ToDoListState) {

        self.state = toDoListState
    }

    var toDoListTitle: String? { return state.toDoList.title }

    func toDoTitle(toDoID: ToDoID) -> String? {

        return state.toDoList.toDo(toDoID: toDoID)?.title
    }

    func toDoInList(toDoID: ToDoID) -> ToDoInList? {

        guard let index = state.toDoList.indexOf(toDoID: toDoID),
            let toDo = state.toDoList.toDo(toDoID: toDoID)
            else { return nil }

        return (toDo, index)
    }
}

extension UndoCommand {

    convenience init?(appAction: UndoableAction, context: UndoActionContext, dispatch: @escaping DispatchFunction) {

        guard let inverseAction = appAction.inverse(context: context)
            else { return nil }

        self.init(undoBlock: { _ = dispatch(inverseAction.notUndoable) },
                  undoName: appAction.name,
                  redoBlock: { _ = dispatch(appAction.notUndoable) })
    }
}

func undoMiddleware(undoManager: UndoManager) -> Middleware<ToDoListState> {

    func undoAction(action: UndoableAction, state: ToDoListState, dispatch: @escaping DispatchFunction) -> UndoCommand? {

        let context = UndoableStateAdapter(toDoListState: state)

        return UndoCommand(appAction: action, context: context, dispatch: dispatch)
    }

    let undoMiddleware: Middleware<ToDoListState> = { dispatch, getState in
        return { next in
            return { action in

                // Pass already undone actions through
                if let undoneAction = action as? NotUndoable {
                    next(undoneAction.action)
                    return
                }

                if let undoableAction = action as? UndoableAction , undoableAction.isUndoable,
                    let state = getState(),
                    let undo = undoAction(action: undoableAction, state: state, dispatch: dispatch) {

                    undo.register(undoManager: undoManager)
                }


                next(action)
            }
        }
    }
    
    return undoMiddleware
}
