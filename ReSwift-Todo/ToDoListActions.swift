//
//  ToDoListActions.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

protocol ToDoListAction: Action {

    func apply(oldToDoList: ToDoList) -> ToDoList
}

// I modeled these actions each as its own struct. There's no
// particular reason except to show both enum-based actions
// and self-contained actions.
//
// The main benefit of this is `ReplaceToDoListAction` not
// having to implement `UndoableAction`. Using an enum[1],
// I'd have to conform to the protocol but return negative
// values all the time for a `replaceList` case. This here
// is easier to understand.
//
// [1]: I did in commit d9ca027ca171cd61785f135fd6c3ad5111396ba7

struct RenameToDoListAction: UndoableAction, ToDoListAction {

    let newName: String?

    init(renameTo newName: String?) {

        self.newName = newName
    }

    func apply(oldToDoList: ToDoList) -> ToDoList {

        var result = oldToDoList
        result.title = self.newName
        return result
    }

    var name: String { return "Rename Project" }
    var isUndoable: Bool { return true }

    func inverse(context: UndoActionContext) -> UndoableAction? {

        let oldName = context.toDoListTitle
        return RenameToDoListAction(renameTo: oldName)
    }
}

struct ReplaceToDoListAction: ToDoListAction {

    let newToDoList: ToDoList

    func apply(oldToDoList: ToDoList) -> ToDoList {

        return newToDoList
    }
}

struct InsertTaskAction: UndoableAction, ToDoListAction {

    let toDo: ToDo
    let index: Int

    func apply(oldToDoList: ToDoList) -> ToDoList {

        var result = oldToDoList
        result.insertItem(toDo, atIndex: index)
        return result
    }

    var isUndoable: Bool { return true }
    var name: String { return "Append Task" }

    func inverse(context: UndoActionContext) -> UndoableAction? {

        return RemoveTaskAction(toDoID: toDo.toDoID)
    }
}

struct RemoveTaskAction: UndoableAction, ToDoListAction {

    let toDoID: ToDoID

    func apply(oldToDoList: ToDoList) -> ToDoList {

        var result = oldToDoList
        result.removeItem(toDoID: toDoID)
        return result
    }

    var isUndoable: Bool { return true }
    var name: String { return "Remove Task" }

    func inverse(context: UndoActionContext) -> UndoableAction? {

        guard let removingToDo = context.toDoInList(toDoID: toDoID) else { return nil }

        return InsertTaskAction(toDo: removingToDo.toDo, index: removingToDo.index)
    }
}
