//
//  ToDoState.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

struct ToDoListState: StateType {

    var toDoList: ToDoList = ToDoList.demoList()
    var selection: SelectionState = nil
}
