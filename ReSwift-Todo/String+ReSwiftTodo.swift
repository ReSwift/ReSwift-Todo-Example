//
//  String+ReSwiftTodo.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 07/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

extension String {

    static var newline: String { return "\n" }

    /// Removes surrounding whitespace and newline characters.
    func stringByTrimmingWhitespace() -> String {

        let characterSet = NSMutableCharacterSet()
        characterSet.formUnionWithCharacterSet(NSCharacterSet.whitespaceCharacterSet())
        characterSet.formUnionWithCharacterSet(NSCharacterSet.newlineCharacterSet())

        return stringByTrimmingCharactersInSet(characterSet)
    }
}
