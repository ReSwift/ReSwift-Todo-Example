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

    func toDoTitle(toDoID toDoID: ToDoID) -> String? {

        return state.toDoList.toDo(toDoID: toDoID)?.title
    }
}


extension UndoCommand {

    convenience init?(appAction: UndoableAction, context: UndoActionContext, dispatch: DispatchFunction) {

        guard let inverseAction = appAction.inverse(context: context)
            else { return nil }

        self.init(undoBlock: { dispatch(inverseAction.notUndoable) },
                  undoName: appAction.name,
                  redoBlock: { dispatch(appAction.notUndoable) })
    }
}

func undoMiddleware(undoManager undoManager: NSUndoManager) -> Middleware {

    func undoAction(action action: UndoableAction, state: ToDoListState, dispatch: DispatchFunction) -> UndoCommand? {

        let context = UndoableStateAdapter(toDoListState: state)

        return UndoCommand(appAction: action, context: context, dispatch: dispatch)
    }

    let undoMiddleware: Middleware = { dispatch, getState in
        return { next in
            return { action in

                // Pass already undone actions through
                if let undoneAction = action as? NotUndoable {
                    return next(undoneAction.action)
                }

                if let undoableAction = action as? UndoableAction where undoableAction.isUndoable,
                    let state = getState() as? ToDoListState,
                    dispatch = dispatch,
                    undo = undoAction(action: undoableAction, state: state, dispatch: dispatch) {

                    undo.register(undoManager: undoManager)
                }


                return next(action)
            }
        }
    }
    
    return undoMiddleware
}
