//
//  ToDo.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 30/01/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

enum Completion {

    case unfinished
    case finished(when: Date?)

    var isFinished: Bool {

        switch self {
        case .unfinished: return false
        case .finished: return true
        }
    }

    var date: Date? {

        switch self {
        case .unfinished: return nil
        case .finished(when: let date): return date
        }
    }
}

struct ToDo {

    static var empty: ToDo { return ToDo(title: "New Task") }
    
    let toDoID: ToDoID
    var title: String
    var completion: Completion
    var tags: Set<String>

    var isFinished: Bool { return completion.isFinished }
    var finishedAt: Date? { return completion.date }

    init(toDoID: ToDoID = ToDoID(), title: String, tags: Set<String> = Set(), completion: Completion = .unfinished) {

        self.toDoID = toDoID
        self.title = title
        self.completion = completion
        self.tags = tags
    }
}

// MARK: ToDo (sub)type equatability

extension ToDo: Equatable {

    /// Equality check ignoring the `ToDoID`.
    func hasEqualContent(_ other: ToDo) -> Bool {

        return title == other.title && completion == other.completion && tags == other.tags
    }
}

func ==(lhs: ToDo, rhs: ToDo) -> Bool {

    return lhs.toDoID == rhs.toDoID && lhs.title == rhs.title && lhs.completion == rhs.completion && lhs.tags == rhs.tags
}

extension Completion: Equatable { }

func ==(lhs: Completion, rhs: Completion) -> Bool {

    switch (lhs, rhs) {
    case (.unfinished, .unfinished): return true
    case let (.finished(when: lDate), .finished(when: rDate)):
        return {
            switch (lDate, rDate) {
            case (.none, .none): return true
            case let (.some(lhs), .some(rhs)): return (lhs == rhs)
            default: return false
            }
            }()
    default: return false
    }
}
