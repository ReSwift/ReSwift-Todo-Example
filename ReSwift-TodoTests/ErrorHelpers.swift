//
//  ErrorHelpers.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 07/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import XCTest

func expectNoError(_ block: () throws -> Void) {

    do {
        try block()
    } catch {
        XCTFail("block has thrown")
    }
}

func ignoreError(_ block: () throws -> Void) {

    do {
        try block()
    } catch {
        // no op
    }
}

enum TestError: Error {
    case irrelevantError
}

let irrelevantError = TestError.irrelevantError
