//
//  ToDoID.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

struct ToDoID {

    let identifier: String

    init() {

        self.identifier = UUID().uuidString
    }

    init(UUID: Foundation.UUID) {

        self.identifier = UUID.uuidString
    }

    init?(identifier: String) {

        guard let UUID = UUID(uuidString: identifier) else {
            return nil
        }

        self.identifier = UUID.uuidString
    }
}

extension ToDoID: Equatable { }

func ==(lhs: ToDoID, rhs: ToDoID) -> Bool {

    return lhs.identifier == rhs.identifier
}

extension ToDoID: Hashable { }

extension ToDoID: CustomStringConvertible {

    var description: String { return identifier }
}
