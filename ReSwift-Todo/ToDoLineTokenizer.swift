//
//  ToDoLineTokenizer.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

enum Token {
    case projectTitle(String)
    case toDo(ToDo)
    case comment(String)
}

class ToDoLineTokenizer {

    init() { }

    func token(text text: String) -> Token? {

        let text = text.stringByTrimmingWhitespace()

        guard !text.isEmpty else { return nil }

        if text.characters.first == "-" {
            return toDo(text: text)
        }

        if text.characters.last == ":" {
            return projectTitle(text: text)
        }

        return .comment(text)
    }

    private func toDo(text text: String) -> Token? {

        let itemTitle = text
            // strip dash
            .substringFromIndex(text.startIndex.successor())
            .stringByTrimmingWhitespace()

        return .toDo(ToDo(title: itemTitle))
    }

    private func projectTitle(text text: String) -> Token? {

        // Drop trailing colon
        let title = text.substringToIndex(text.endIndex.predecessor())

        return .projectTitle(title)
    }
}
