//
//  ToDoReducer.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 05/02/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import ReSwift

func toDoReducer(_ action: Action, state: ToDo?, clock: Clock = Clock()) -> ToDo? {

    guard let action = action as? ToDoAction,
        let toDo = state
        else { return state }

    return handleToDoAction(action, toDo: toDo, clock: clock)
}

private func handleToDoAction(_ action: ToDoAction, toDo: ToDo, clock: Clock) -> ToDo {

    var toDo = toDo

    switch action {
    case let .check(toDoID):
        guard toDo.toDoID == toDoID else { return toDo }
        toDo.completion = .finished(when: clock.now())

    case let .uncheck(toDoID):
        guard toDo.toDoID == toDoID else { return toDo }
        toDo.completion = .unfinished

    case let .rename(toDoID, title: title):
        guard toDo.toDoID == toDoID else { return toDo }
        toDo.title = title
    }

    return toDo

}

