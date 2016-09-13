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

        let firstLine = lines.first?.stringByTrimmingWhitespaceAndNewline()

        func isProjectTitle(line: String) -> Bool {
            return line.characters.last == ":"
        }

        let title: String?
        let projectContent: ArraySlice<String>

        if let firstLine = firstLine
            where isProjectTitle(firstLine) {

            title = firstLine.substringToIndex(firstLine.endIndex.predecessor())
            projectContent = lines.dropFirst()
        } else {

            title = nil
            projectContent = lines.dropFirst(0)
        }

        let items = projectContent
            .filter {
                let line = $0.stringByTrimmingWhitespaceAndNewline()
                return !line.isEmpty && line.characters.first == "-"
            }.map { (line: String) -> ToDo in

                let itemTitle = line
                    .substringFromIndex(line.startIndex.successor())
                    .stringByTrimmingWhitespaceAndNewline()

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
