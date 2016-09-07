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

        guard let firstLine = lines.first?.stringByTrimmingWhitespace()
            where firstLine.containsString(":")
            else { return ToDoList.empty }

        return ToDoList(title: firstLine.substringToIndex(firstLine.endIndex.predecessor()), items: [])
    }
}

extension Array {

    @warn_unused_result
    func split(take n: Index) -> (ArraySlice<Element>, ArraySlice<Element>) {

        return (prefixUpTo(n), dropFirst(n))
    }
}
