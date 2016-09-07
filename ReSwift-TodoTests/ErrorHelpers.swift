//
//  ErrorHelpers.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 07/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import XCTest

func expectNoError(@noescape block: () throws -> Void) {

    do {
        try block()
    } catch {
        XCTFail("block has thrown")
    }
}

func ignoreError(@noescape block: () throws -> Void) {

    do {
        try block()
    } catch {
        // no op
    }
}

enum TestError: ErrorType {
    case IrrelevantError
}

let irrelevantError = TestError.IrrelevantError
