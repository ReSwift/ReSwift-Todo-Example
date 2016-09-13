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

    let date: NSDate

    init(date: NSDate) {

        self.date = date
    }

    override func now() -> NSDate {

        return date
    }
}
