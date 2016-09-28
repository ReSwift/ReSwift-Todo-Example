//
//  KeyboardEventHandler.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

@objc protocol ToDoItemEditDelegate: class {

    func editItem(row: Int, insertText text: String?)
}

class KeyboardEventHandler: PatchingResponder {

    var store: ToDoListStore?
    var dataSource: ToDoTableDataSourceType!

    @IBOutlet weak var itemChangeDelegate: ToDoItemChangeDelegate?
    @IBOutlet weak var itemEditDelegate: ToDoItemEditDelegate?

    fileprivate func dispatchAction(_ action: Action) {

        store?.dispatch(action)
    }

    // MARK: Selection

    override func cancelOperation(_ sender: Any?) {

        dispatchAction(SelectionAction.deselect)
    }

    override func moveUp(_ sender: Any?) {

        let newRow: Int = {

            guard let selectedRow = dataSource.selectedRow
                , selectedRow > 0
                else  { return dataSource.toDoCount - 1 }

            return selectedRow - 1
        }()

        dispatchAction(SelectionAction.select(row: newRow))
    }

    override func moveDown(_ sender: Any?) {

        let newRow: Int = {

            guard let selectedRow = dataSource.selectedRow
                , selectedRow < (dataSource.toDoCount - 1)
                else  { return 0 }

            return selectedRow + 1
        }()

        dispatchAction(SelectionAction.select(row: newRow))
    }


    // MARK: Editing

    override func insertText(_ insertString: Any) {

        let string: String = {
            if let string = insertString as? String {
                return string
            } else if let attributedString = insertString as? NSAttributedString {
                return attributedString.string
            }

            return ""
        }()

        guard let selectedRow = dataSource.selectedRow
            else { super.insertText(insertString); return }

        guard string != " "
            else { toggleTask(row: selectedRow); return }

        editCell(row: selectedRow, insertText: string)
    }

    fileprivate func toggleTask(row: Int) {

        guard let toDo = self.dataSource.selectedToDo
            else { return }

        itemChangeDelegate?.toDoItem(
            identifier: toDo.identifier,
            didChangeChecked: !toDo.checked)
    }

    override func insertNewline(_ sender: Any?) {

        let targetRow: Int = {
            guard let selectedRow = dataSource.selectedRow
                else { return self.dataSource.toDoCount }

            return selectedRow + 1
        }()

        dispatchAction(InsertTaskAction(toDo: ToDo.empty, index: targetRow))
        dispatchAction(SelectionAction.select(row: targetRow))
    }

    override func insertTab(_ sender: Any?) {

        guard let selectedRow = dataSource.selectedRow
            else { return }

        editCell(row: selectedRow)
    }


    fileprivate func editCell(row: Int, insertText text: String? = nil) {

        itemEditDelegate?.editItem(row: row, insertText: text)
    }


    // MARK: Removal

    override func deleteForward(_ sender: Any?) {

        removeSelectedTask()
    }

    override func deleteBackward(_ sender: Any?) {
        
        removeSelectedTask()
    }
    
    fileprivate func removeSelectedTask() {
        
        guard let selectedToDo = dataSource.selectedToDo,
            let toDoID = ToDoID(identifier: selectedToDo.identifier)
            else { return }
        
        dispatchAction(RemoveTaskAction(toDoID: toDoID))
    }
}
