//
//  ToDoListActions.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

enum ToDoListAction: Action {

    case rename(String)
    case replaceList(ToDoList)
}
