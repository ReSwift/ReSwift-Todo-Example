//
//  RemoveIdempotentActionsMiddleware.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

/// Consumes some actions that don't change the state.
///
/// Admitted, this is not the most scalable and useful middleware
/// I could've come up with, but it serves to demonstrate
/// how you can interrupt the action handling chain.
let removeIdempotentActionsMiddleware: Middleware = { dispatch, getState in
    return { next in
        return { action in

            guard let state = getState() as? ToDoListState
                else { return next(action) }

            if let action = action as? RenameToDoListAction , action.newName == state.toDoList.title {

                print("Ignoring \(action)")

                return state
            } else if let action = action as? SelectionAction , action.selectionState == state.selection {

                print("Ignoring \(action)")

                return state
            }
            
            return next(action)
        }
    }
}
