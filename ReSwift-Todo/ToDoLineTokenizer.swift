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

        let text = text.stringByTrimmingWhitespaceAndNewline()

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

        let cleanedLine = text
            // strip dash
            .substringFromIndex(text.startIndex.successor())
            .stringByTrimmingWhitespaceAndNewline()

        let words = cleanedLine.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        let firstTag: Int? = words.indexOf(wordIsTag)
        let lastTitleWordIndex = (firstTag ?? words.endIndex)
        let components = words.split(take: lastTitleWordIndex)

        let title = components.0.joinWithSeparator(" ")

        let tagWords = components.1.filter(wordIsTag)
            .map { $0.characters.dropFirst() } // Drop "@"
            .map(String.init)
        var tags = Set(tagWords)
        let completion: Completion
        if tags.contains("done") {
            tags.remove("done")
            completion = .finished(when: nil)
        } else {
            completion = .unfinished
        }

        return .toDo(ToDo(title: title, tags: tags, completion: completion))
    }

    private func projectTitle(text text: String) -> Token? {

        // Drop trailing colon
        let title = text.substringToIndex(text.endIndex.predecessor())

        return .projectTitle(title)
    }
}

private func wordIsTag(word: String) -> Bool {

    return word.characters.first == "@"
}
