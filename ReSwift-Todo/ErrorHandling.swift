//
//  ErrorHandling.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

func reportError(_ error: Error, function: String = #function, file: String = #file, line: Int = #line) {

    print("ERROR \(function) (\(file):\(line)): \(error)")
}
