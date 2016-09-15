//
//  Undoable.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

protocol Undoable {

    /// Name used for e.g. "Undo" menu items.
    var name: String { get }

    var notUndoable: NotUndoable { get }
    var isUndoable: Bool { get }

    func inverse(context context: UndoActionContext) -> UndoableAction?
}

extension Undoable where Self: UndoableAction {

    var notUndoable: NotUndoable {

        return NotUndoable(self)
    }
}
