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

        self.identifier = NSUUID().UUIDString
    }

    init(UUID: NSUUID) {

        self.identifier = UUID.UUIDString
    }

    init?(identifier: String) {

        guard let UUID = NSUUID(UUIDString: identifier) else {
            return nil
        }

        self.identifier = UUID.UUIDString
    }
}

extension ToDoID: Equatable { }

func ==(lhs: ToDoID, rhs: ToDoID) -> Bool {

    return lhs.identifier == rhs.identifier
}

extension ToDoID: Hashable {

    var hashValue: Int { return 189 &* identifier.hashValue }
}

extension ToDoID: CustomStringConvertible {

    var description: String { return identifier }
}
