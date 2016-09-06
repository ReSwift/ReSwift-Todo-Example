//
//  ToDo.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 30/01/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

struct ToDo {

    let toDoID: ToDoID
    var title: String
    var completed: Bool

    init(toDoID: ToDoID = ToDoID(), title: String, completed: Bool = false) {

        self.toDoID = toDoID
        self.title = title
        self.completed = completed
    }
}

extension ToDo: Equatable {

    /// Equality check ignoring the `ToDoID`.
    func hasEqualContent(other: ToDo) -> Bool {

        return title == other.title && completed == other.completed
    }
}

func ==(lhs: ToDo, rhs: ToDo) -> Bool {

    return lhs.toDoID == rhs.toDoID && lhs.title == rhs.title && lhs.completed == rhs.completed
}
