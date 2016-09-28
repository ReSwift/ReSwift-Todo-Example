//
//  ClockStub.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
@testable import ReSwiftTodo

class ClockStub: Clock {

    let date: Date

    init(date: Date) {

        self.date = date
    }

    override func now() -> Date {

        return date
    }
}
