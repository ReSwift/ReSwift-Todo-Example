//
//  ToDoList.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 30/01/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

struct ToDoList {

    static var empty: ToDoList { return ToDoList(title: nil, items: []) }

    var title: String?
    var items: [ToDo]

    var isEmpty: Bool {
        return (title?.isEmpty ?? true) && items.isEmpty
    }

    mutating func appendItem(toDo: ToDo) {

        items.append(toDo)
    }

    /// Always inserts `toDo` into the list: 
    ///
    /// - if `index` exceeds the bounds of the items collection,
    ///   it will be appended or prepended;
    /// - if `index` falls inside these bounds, it will be
    ///   inserted between existing elements.
    mutating func insertItem(toDo: ToDo, atIndex index: Int) {

        if index < 1 {
            items.insert(toDo, atIndex: 0)
        } else if index < items.count {
            items.insert(toDo, atIndex: index)
        } else {
            items.append(toDo)
        }
    }
}

extension ToDoList {

    init() {

        self.title = nil
        self.items = []
    }
    
    static func demoList() -> ToDoList {

        let toDos = [
            ToDo(title: "create a new list", completion: .finished(when: nil)),
            ToDo(title: "rename the list", completion: .unfinished),
            ToDo(title: "get productive", completion: .unfinished)
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
