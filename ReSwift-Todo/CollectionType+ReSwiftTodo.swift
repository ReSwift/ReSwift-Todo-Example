//
//  CollectionType+ReSwiftTodo.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

extension CollectionType where Self.Index : Comparable {

    subscript (safe index: Self.Index) -> Self.Generator.Element? {
        return index < endIndex ? self[index] : nil
    }
}
