//
//  ToDoActions.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

enum ToDoAction: Action {
    case Check(ToDoID)
    case Uncheck(ToDoID)
}
