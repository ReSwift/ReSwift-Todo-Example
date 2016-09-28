//
//  UndoCommand.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

/// Encapsulates an undo-action as `undoBlock` with an optional `redoBlock` 
/// to create and forget about how to undo state changes. (As opposed to 
/// littering `performUndo` everywhere.)
///
/// If an undo command is used, its inversion is created if `redoBlock` is
/// present and overrides the default redo action.
class UndoCommand: NSObject {

    typealias Block = () -> Void

    let undoBlock: Block
    let undoName: String?
    let redoBlock: (Block)?

    init(undoBlock: @escaping Block, undoName: String? = nil, redoBlock: (Block)? = nil) {

        self.undoBlock = undoBlock
        self.undoName = undoName
        self.redoBlock = redoBlock
    }

    var inversion: UndoCommand? {

        guard let redoBlock = self.redoBlock else { return nil }

        // No need to pass a `undoName` as it will be associated with the current action.
        return UndoCommand(undoBlock: redoBlock, redoBlock: undoBlock)
    }

    func register(undoManager: UndoManager) {

        undoManager.registerUndo(action: self)

        // Don't overwrite the inferred name when undoing.
        if !undoManager.isUndoing,
            let undoName = self.undoName {

            undoManager.setActionName(undoName)
        }
    }
}

private extension UndoManager {

    func registerUndo(action: UndoCommand) {

        self.registerUndo(withTarget: self, selector: #selector(performUndo(_:)), object: action)
    }

    @objc func performUndo(_ action: UndoCommand) {

        action.undoBlock()

        if let inverted = action.inversion {
            registerUndo(action: inverted)
        }
    }
}
