//
//  ToDoListImporter.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

enum ImportError: ErrorType {

    case cannotPrepareStream
}

class ToDoListImporter {

    func importToDoList(URL: NSURL) throws -> ToDoList {

        let reader = try StreamReader(URL: URL, encoding: NSUTF8StringEncoding)

        defer { reader.close() }

        return try parse(stream: reader)
    }

    func importToDoList(text: String) throws -> ToDoList {

        let lines = text.characters
            .split(allowEmptySlices: true) { $0 == Character(String.newline) }
            .map(String.init)

        return try parse(stream: lines)
    }

    func parse<T: SequenceType where T.Generator.Element == String>(stream stream: T) throws -> ToDoList {

        // TODO: utilize stream-ness instead of making an array from it
        let lines = Array(stream)
        let projectContent = lines.split(take: 1)

        guard let firstLine = projectContent.0.first?.stringByTrimmingWhitespace()
            where firstLine.characters.last == ":"
            else { return ToDoList.empty }

        let title = firstLine.substringToIndex(firstLine.endIndex.predecessor())
        let items = projectContent.1
            .filter {
                let line = $0.stringByTrimmingWhitespace()
                return !line.isEmpty && line.characters.first == "-"
            }.map { (line: String) -> ToDo in

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
