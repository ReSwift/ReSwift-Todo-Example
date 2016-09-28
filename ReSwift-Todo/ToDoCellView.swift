//
//  ToDoCellView.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation
import Cocoa

@objc protocol ToDoItemChangeDelegate: class {

    func toDoItem(identifier: String, didChangeChecked checked: Bool)
    func toDoItem(identifier: String, didChangeTitle title: String)
}

class ToDoCellView: NSTableCellView {

    static var reuseIdentifier: String { return "ToDoCell" }

    @IBOutlet var checkbox: CheckBox!

    var titleTextField: NSTextField! {
        get { return textField }
        set { textField = newValue }
    }

    fileprivate(set) var viewModel: ToDoViewModel! {
        didSet {
            titleTextField.stringValue = viewModel.title
            checkbox.checked = viewModel.checked
        }
    }

    weak var toDoItemChangeDelegate: ToDoItemChangeDelegate?

    static func make(tableView: NSTableView, owner: AnyObject? = nil) -> ToDoCellView? {

        return tableView.make(withIdentifier: ToDoCellView.reuseIdentifier, owner: owner) as? ToDoCellView
    }

    @IBAction func checkboxChanged(_ sender: AnyObject) {

        toDoItemChangeDelegate?.toDoItem(
            identifier: viewModel.identifier,
            didChangeChecked: checkbox.checked)
    }

    @IBAction func renameItem(_ sender: AnyObject) {

        toDoItemChangeDelegate?.toDoItem(
            identifier: viewModel.identifier,
            didChangeTitle: titleTextField.stringValue)
    }
}

extension ToDoCellView: DisplaysToDo {

    func showToDo(toDoViewModel viewModel: ToDoViewModel) {

        self.viewModel = viewModel
    }
}
