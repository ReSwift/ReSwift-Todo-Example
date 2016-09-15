//
//  ToDoActions.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

enum ToDoAction: Action {
    
    case check(ToDoID)
    case uncheck(ToDoID)

    case rename(ToDoID, title: String)
}
