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

    static var dateConverter = DateConverter()

    init() { }

    func token(text: String) -> Token? {

        let text = text.stringByTrimmingWhitespaceAndNewline()

        guard !text.isEmpty else { return nil }

        if text.first == "-" {
            return toDo(text: text)
        }

        if text.last == ":" {
            return projectTitle(text: text)
        }

        return .comment(text)
    }

    fileprivate func toDo(text: String) -> Token? {

        // strip dash
        let cleanedLine = String(text[text.index(after: text.startIndex)...])
            .stringByTrimmingWhitespaceAndNewline()

        let words = cleanedLine.components(separatedBy: CharacterSet.whitespacesAndNewlines)

        let firstTag: Int? = words.index(where: wordIsTag)
        let lastTitleWordIndex = (firstTag ?? words.endIndex)
        let components = words.split(take: lastTitleWordIndex)

        let title = components.0.joined(separator: " ")
        let tagWords = components.1.filter(wordIsTag)
            .map { $0.dropFirst() } // Drop "@"
            .map(String.init)
        let result: (completion: Completion, tags: Set<String>) = separateTagsFromCompletion(tagWords)

        return .toDo(ToDo(title: title, tags: result.tags, completion: result.completion))
    }

    fileprivate func separateTagsFromCompletion(_ tagWords: [String]) -> (completion: Completion, tags: Set<String>) {

        var tags = Set(tagWords)
        let maybeDoneTag = tags.filter({ $0.hasPrefix("done") }).first

        guard let doneTag = maybeDoneTag
            else { return (.unfinished, tags) }

        tags.remove(doneTag)

        let date: Date? = {
            let dateRemainder = doneTag
                .replacingOccurrences(of: "done(", with: "")
                .replacingOccurrences(of: ")", with: "")
            return ToDoLineTokenizer.dateConverter
                .date(isoDateString: dateRemainder) as Date?
        }()

        return (.finished(when: date), tags)
    }

    fileprivate func projectTitle(text: String) -> Token? {

        // Drop trailing colon
        let title = String(text[..<text.index(before: text.endIndex)])

        return .projectTitle(title)
    }
}

private func wordIsTag(_ word: String) -> Bool {
    return word.first == "@"
}
