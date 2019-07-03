//
//  ToDoListSerializer.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

extension String {

    func appended(_ other: String) -> String {

        return self + other
    }
}

extension Array {

    func appendedContentsOf<C : Collection>(_ newElements: C) -> [Element] where C.Iterator.Element == Element {

        var result = self
        result.append(contentsOf: newElements)
        return result
    }
}

enum SerializationError: Error {

    case cannotEncodeString
}

class ToDoListSerializer {

    init() { }

    lazy var dateConverter: DateConverter = DateConverter()

    func data(toDoList: ToDoList, encoding: String.Encoding = String.Encoding.utf8) -> Data? {

        return string(toDoList: toDoList).data(using: encoding)
    }

    func string(toDoList: ToDoList) -> String {

        guard !toDoList.isEmpty else { return "" }

        let title = toDoList.title.map { $0.appended(":") } ?? ""
        let items = toDoList.items.map(itemRepresentation)

        let lines = [title]
            .appendedContentsOf(items)
            .filter({ !$0.isEmpty }) // Remove empty title lines

        return lines.joined(separator: "\n").appended("\n")
    }

    fileprivate func itemRepresentation(_ item: ToDo) -> String {

        let body = "- \(item.title)"
        let tags = item.tags.sorted().map { "@\($0)" }
        let done: String? = {
            switch item.completion {
            case .unfinished: return nil
            case .finished(when: let date):
                guard let date = date else { return "@done" }

                let dateString = dateConverter.string(date: date)
                return "@done(\(dateString))"
            }
        }()

        return [body]
            .appendedContentsOf(tags)
            .appendedContentsOf([done].compactMap(identity)) // remove nil
            .joined(separator: " ")
    }
}

func identity<T>(_ value: T?) -> T? {
    return value
}
