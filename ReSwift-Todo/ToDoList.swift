//
//  ToDoList.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 30/01/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

struct ToDoList {

    static var empty: ToDoList { return ToDoList(title: "", items: []) }

    var title: String
    var items: [ToDo]
}

extension ToDoList {

    static func demoList() -> ToDoList {

        let toDos = [
            ToDo(title: "create a new list", completed: true),
            ToDo(title: "rename the list", completed: false),
            ToDo(title: "get productive", completed: false)
        ]

        return ToDoList(title: "Welcome!", items: toDos)
    }
}

extension ToDoList: Equatable {

    /// Equality check ignoring the `items`'s `ToDoID`s.
    func hasEqualContent(other: ToDoList) -> Bool {

        guard title == other.title else { return false }
        guard items.count == other.items.count else { return false }

        for toDo in items {

            guard other.items.contains({ $0.hasEqualContent(toDo) }) else {
                return false
            }
        }

        for toDo in other.items {

            guard items.contains({ $0.hasEqualContent(toDo) }) else {
                return false
            }
        }

        return true
    }
}

func ==(lhs: ToDoList, rhs: ToDoList) -> Bool {

    return lhs.title == rhs.title && lhs.items == rhs.items
}
