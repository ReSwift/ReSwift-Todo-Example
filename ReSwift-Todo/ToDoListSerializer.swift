//
//  ToDoListSerializer.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

extension String {

    func appended(other: String) -> String {

        return self + other
    }
}

extension Array {

    func appendedContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C) -> [Element] {

        var result = self
        result.appendContentsOf(newElements)
        return result
    }
}

class ToDoListSerializer {

    func string(toDoList toDoList: ToDoList) -> String {

        guard !toDoList.isEmpty else { return "" }

        let title = toDoList.title.map { $0.appended(":") } ?? ""
        let items = toDoList.items.map { "- \($0.title)" }

        let lines = [title]
            .appendedContentsOf(items)
            .filter({ !$0.isEmpty }) // Remove empty title lines

        return lines.joinWithSeparator("\n").appended("\n")
    }
}
