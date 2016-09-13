//
//  ToDoReducer.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

class ToDoReducer {

    init() { }

    func handleAction(action: Action, state: ToDo?, clock: Clock = Clock()) -> ToDo? {

        guard let action = action as? ToDoAction, toDo = state
            else { return state }

        return handleToDoAction(action, toDo: toDo, clock: clock)
    }

    func handleToDoAction(action: ToDoAction, toDo: ToDo, clock: Clock) -> ToDo {

        var toDo = toDo

        switch action {
        case let .check(toDoID):
            guard toDo.toDoID == toDoID else { return toDo }
            toDo.completion = .finished(when: clock.now())

        case let .uncheck(toDoID):
            guard toDo.toDoID == toDoID else { return toDo }
            toDo.completion = .unfinished
        }
        
        return toDo
        
    }
}
