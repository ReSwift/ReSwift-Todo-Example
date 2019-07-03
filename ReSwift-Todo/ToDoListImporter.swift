//
//  ToDoListImporter.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

enum ImportError: Error {

    case cannotUseDelimiter(String)
    case cannotPrepareStream(URL)
}

class ToDoListImporter {

    func importToDoList(url: URL) throws -> ToDoList {

        let reader = try StreamReader(url: url, encoding: .utf8)

        defer { reader.close() }

        return parse(stream: reader)
    }

    func importToDoList(text: String) throws -> ToDoList {

        let lines = text
            .split(omittingEmptySubsequences: false) { $0 == Character(String.newline) }
            .map(String.init)

        return parse(stream: lines)
    }

    lazy var tokenizer: ToDoLineTokenizer = ToDoLineTokenizer()

    func parse<T: Sequence>(stream: T) -> ToDoList where T.Iterator.Element == String {

        var tokens = stream.compactMap(tokenizer.token(text:))

        if let projectTitleIndex = tokens.index(where: tokenIsProjectTitle),
            projectTitleIndex > 0 {

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

private func tokenIsProjectTitle(_ token: Token) -> Bool {

    guard case .projectTitle = token else { return false }

    return true
}

extension Array {

    func split(take n: Index) -> (ArraySlice<Element>, ArraySlice<Element>) {

        return (prefix(upTo: n), dropFirst(n))
    }
}
