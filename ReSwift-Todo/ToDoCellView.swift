//
//  ToDoCellView.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import Cocoa

class ToDoCellView: NSTableCellView {

    static var reuseIdentifier: String { return "ToDoCell" }

    @IBOutlet var checkbox: NSButton!

    var titleTextField: NSTextField! {
        get { return textField }
        set { textField = newValue }
    }

    private(set) var viewModel: ToDoItemViewModel! {
        didSet {
            titleTextField.stringValue = viewModel.title
            checkbox.state = viewModel.checked ? NSOnState : NSOffState
        }
    }
}

extension ToDoCellView: DisplaysToDo {

    func showToDo(toDoViewModel viewModel: ToDoItemViewModel) {

        self.viewModel = viewModel
    }
}
