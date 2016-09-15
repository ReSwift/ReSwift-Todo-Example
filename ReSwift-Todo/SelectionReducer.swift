//
//  SelectionReducer.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import ReSwift

class SelectionReducer {

    init() { }

    func handleAction(action: Action, state: SelectionState) -> SelectionState {

        guard let action = action as? SelectionAction else { return state }

        switch action {
        case .deselect: return nil
        case .select(row: let row): return row
        }
    }
}
