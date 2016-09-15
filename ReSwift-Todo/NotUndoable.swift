//
//  NotUndoable.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

/// Wrapper around an action to flag it as not undoable, like when it's 
/// already on the undo-stack.
struct NotUndoable: Action {

    let action: Action

    init(_ action: Action) {

        self.action = action
    }
}

extension NotUndoable: CustomStringConvertible {

    var description: String {
        return "NotUndoable for \(action)"
    }
}