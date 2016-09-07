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

    func stringByTrimmingWhitespace() -> String {

        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}
