//
//  ToDoListSerializer.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

extension String {

    func appended(other: String) -> String {

        return self + other
    }
}

extension Array {

    func appendedContentsOf<C : CollectionType where C.Generator.Element == Element>(newElements: C) -> [Element] {

        var result = self
        result.appendContentsOf(newElements)
        return result
    }
}

enum SerializationError: ErrorType {

    case cannotEncodeString
}

class ToDoListSerializer {

    init() { }

    lazy var dateConverter: DateConverter = DateConverter()
    
    func data(toDoList toDoList: ToDoList, encoding: NSStringEncoding = NSUTF8StringEncoding) -> NSData? {

        return string(toDoList: toDoList).dataUsingEncoding(encoding)
    }

    func string(toDoList toDoList: ToDoList) -> String {

        guard !toDoList.isEmpty else { return "" }

        let title = toDoList.title.map { $0.appended(":") } ?? ""
        let items = toDoList.items.map(itemRepresentation)

        let lines = [title]
            .appendedContentsOf(items)
            .filter({ !$0.isEmpty }) // Remove empty title lines

        return lines.joinWithSeparator("\n").appended("\n")
    }

    private func itemRepresentation(item: ToDo) -> String {

        let body = "- \(item.title)"
        let done: String? = {
            switch item.completion {
            case .unfinished: return nil
            case .finished(when: let date):
                guard let date = date else { return "@done" }

                let dateString = dateConverter.string(date: date)
                return "@done(\(dateString))"
            }
        }()

        return [body, done]
            .flatMap(identity) // remove nils
            .joinWithSeparator(" ")
    }
}

func identity<T>(value: T?) -> T? {
    return value
}
