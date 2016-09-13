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

    lazy var tokenizer: ToDoLineTokenizer = ToDoLineTokenizer()

    func parse<T: SequenceType where T.Generator.Element == String>(stream stream: T) throws -> ToDoList {

        var tokens = stream.flatMap(tokenizer.token(text:))

        if let projectTitleIndex = tokens.indexOf(tokenIsProjectTitle)
            where projectTitleIndex > 0 {

            tokens = Array(tokens.dropFirst(projectTitleIndex - 1))
        }

        /// Makes `reduce` cancelable, sort of.
        var firstProjectFinished = false
        
        let toDoList: ToDoList = tokens.reduce(ToDoList()) { (memo: ToDoList, token: Token) -> ToDoList in

            guard !firstProjectFinished else { return memo }

            var toDoList = memo

            switch token {
            case .projectTitle(let title):
                guard toDoList.title == nil else {
                    firstProjectFinished = true
                    return toDoList
                }

                toDoList.title = title

            case .toDo(let toDo):
                toDoList.appendItem(toDo)

            case .comment:
                // TODO: add support for item comments
                break
            }

            return toDoList
        }

        return toDoList
    }
}

private func tokenIsProjectTitle(token: Token) -> Bool {

    guard case .projectTitle = token else { return false }

    return true
}

extension Array {

    @warn_unused_result
    func split(take n: Index) -> (ArraySlice<Element>, ArraySlice<Element>) {

        return (prefixUpTo(n), dropFirst(n))
    }
}
