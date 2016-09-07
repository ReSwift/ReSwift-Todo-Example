//
//  ToDoListImporter.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

class ToDoListImporter {

    func importToDoList(text: String) throws -> ToDoList {

        let lines = text.characters
            .split(allowEmptySlices: true) { $0 == Character(String.newline) }
            .map(String.init)

        let projectContent = lines.split(take: 1)

        guard let firstLine = projectContent.0.first?.stringByTrimmingWhitespace()
            where firstLine.containsString(":")
            else { return ToDoList.empty }

        let title = firstLine.substringToIndex(firstLine.endIndex.predecessor())
        let items = projectContent.1
            .filter { !$0.stringByTrimmingWhitespace().isEmpty }
            .map { (line: String) -> ToDo in

                let itemTitle = line
                    .substringFromIndex(line.startIndex.successor())
                    .stringByTrimmingWhitespace()

                return ToDo(title: itemTitle)
        }

        return ToDoList(title: title, items: items)
    }
}

extension Array {

    @warn_unused_result
    func split(take n: Index) -> (ArraySlice<Element>, ArraySlice<Element>) {

        return (prefixUpTo(n), dropFirst(n))
    }
}
