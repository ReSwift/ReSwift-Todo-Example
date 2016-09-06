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

    @IBOutlet var checkbox: CheckBox!

    var titleTextField: NSTextField! {
        get { return textField }
        set { textField = newValue }
    }

    private(set) var viewModel: ToDoViewModel! {
        didSet {
            titleTextField.stringValue = viewModel.title
            checkbox.checked = viewModel.checked
        }
    }

    static func make(tableView tableView: NSTableView, owner: AnyObject? = nil) -> ToDoCellView? {

        return tableView.makeViewWithIdentifier(ToDoCellView.reuseIdentifier, owner: owner) as? ToDoCellView
    }
}

extension ToDoCellView: DisplaysToDo {

    func showToDo(toDoViewModel viewModel: ToDoViewModel) {

        self.viewModel = viewModel
    }
}
