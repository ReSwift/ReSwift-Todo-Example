//
//  ToDoList.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 30/01/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

struct ToDoList {

    static var empty: ToDoList { return ToDoList(title: nil, items: []) }

    var title: String?
    var items: [ToDo]

    var isEmpty: Bool {
        return (title?.isEmpty ?? true) && items.isEmpty
    }

    mutating func appendItem(_ toDo: ToDo) {

        items.append(toDo)
    }

    /// Always inserts `toDo` into the list: 
    ///
    /// - if `index` exceeds the bounds of the items collection,
    ///   it will be appended or prepended;
    /// - if `index` falls inside these bounds, it will be
    ///   inserted between existing elements.
    mutating func insertItem(_ toDo: ToDo, atIndex index: Int) {

        if index < 1 {
            items.insert(toDo, at: 0)
        } else if index < items.count {
            items.insert(toDo, at: index)
        } else {
            items.append(toDo)
        }
    }

    func indexOf(toDoID: ToDoID) -> Int? {

        return items.index(where: { $0.toDoID == toDoID })
    }

    func toDo(toDoID: ToDoID) -> ToDo? {

        guard let index = indexOf(toDoID: toDoID)
            else { return nil }

        return items[index]
    }

    mutating func removeItem(toDoID: ToDoID) {

        guard let index = indexOf(toDoID: toDoID)
            else { return }

        items.remove(at: index)
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
    func hasEqualContent(_ other: ToDoList) -> Bool {

        guard title == other.title else { return false }
        guard items.count == other.items.count else { return false }

        for toDo in items {

            guard other.items.contains(where: { $0.hasEqualContent(toDo) }) else {
                return false
            }
        }

        for toDo in other.items {

            guard items.contains(where: { $0.hasEqualContent(toDo) }) else {
                return false
            }
        }

        return true
    }
}

func ==(lhs: ToDoList, rhs: ToDoList) -> Bool {

    return lhs.title == rhs.title && lhs.items == rhs.items
}
