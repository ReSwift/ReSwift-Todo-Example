//
//  SelectionActions.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

enum SelectionAction: Action {

    case deselect
    case select(row: Int)

    var selectionState: SelectionState {
        switch self {
        case .deselect: return nil
        case .select(row: let row): return row
        }
    }
}
