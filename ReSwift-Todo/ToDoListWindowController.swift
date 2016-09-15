//
//  ToDoListWindowController.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

protocol ToDoListWindowControllerDelegate: class {

    func toDoListWindowControllerDidLoad(controller: ToDoListWindowController)
    func toDoListWindowControllerWillClose(controller: ToDoListWindowController)
}

protocol ToDoTableDataSourceType {

    var tableDataSource: NSTableViewDataSource { get }

    var selectedRow: Int? { get }
    var toDoCount: Int { get }

    func updateContents(toDoListViewModel viewModel: ToDoListViewModel)
    func toDoCellView(tableView tableView: NSTableView, row: Int, owner: AnyObject) -> ToDoCellView?
}

extension ToDoTableDataSourceType where Self: NSTableViewDataSource {

    var tableDataSource: NSTableViewDataSource {
        return self
    }
}

// MARK: -

class ToDoListWindowController: NSWindowController {

    @IBOutlet var titleTextField: NSTextField!
    @IBOutlet var tableView: NSTableView!

    /// Changing the `delegate` while the window is displayed
    /// calls the `toDoListWindowControllerDidLoad` callback
    /// on the new `delegate`.
    weak var delegate: ToDoListWindowControllerDelegate? {
        didSet {
            guard didLoad else { return }

            delegate?.toDoListWindowControllerDidLoad(self)
        }
    }

    var dataSource: ToDoTableDataSourceType = ToDoTableDataSource() {

        didSet {
            tableView.setDataSource(dataSource.tableDataSource)
        }
    }

    var store: ToDoListStore?

    convenience init() {

        self.init(windowNibName: String(ToDoListWindowController))
    }

    private var didLoad = false {
        didSet {
            delegate?.toDoListWindowControllerDidLoad(self)
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(windowWillClose(_:)), name: NSWindowWillCloseNotification, object: self.window)

        tableView.setDataSource(self.dataSource.tableDataSource)
        tableView.setDelegate(self)
    }

    override func windowDidLoad() {

        super.windowDidLoad()

        didLoad = true
    }

    @IBAction func changeTitle(sender: AnyObject) {

        guard let textField = sender as? NSTextField else { return }

        let newName = textField.stringValue

        dispatchAction(RenameToDoListAction(renameTo: newName))
    }

    private func dispatchAction(action: Action) {

        store?.dispatch(action)
    }

    func windowWillClose(notification: NSNotification) {

        guard let sendingWindow = notification.object as? NSWindow
            where sendingWindow == self.window
            else { return }

        delegate?.toDoListWindowControllerWillClose(self)
    }
}

// MARK: - Keyboard shortcut handling

extension ToDoListWindowController {

    // MARK: Selection

    override func cancelOperation(sender: AnyObject?) {

        dispatchAction(SelectionAction.deselect)
    }

    override func moveUp(sender: AnyObject?) {

        let newRow: Int = {

            guard let selectedRow = dataSource.selectedRow
                where selectedRow > 0
                else  { return dataSource.toDoCount - 1 }

            return selectedRow - 1
        }()

        dispatchAction(SelectionAction.select(row: newRow))
    }

    override func moveDown(sender: AnyObject?) {

        let newRow: Int = {

            guard let selectedRow = dataSource.selectedRow
                where selectedRow < dataSource.toDoCount.predecessor()
                else  { return 0 }

            return selectedRow + 1
        }()

        dispatchAction(SelectionAction.select(row: newRow))
    }


    // MARK: Editing

    override func insertNewline(sender: AnyObject?) {

        let targetRow: Int = {
            guard let selectedRow = dataSource.selectedRow
                else { return self.dataSource.toDoCount }

            return selectedRow + 1
        }()

        dispatchAction(InsertTaskAction(toDo: ToDo.empty, index: targetRow))
        dispatchAction(SelectionAction.select(row: targetRow))
    }

}


// MARK: Displaying Data 

protocol DisplaysToDoList {

    func displayToDoList(toDoListViewModel viewModel: ToDoListViewModel)
}

extension ToDoListWindowController: DisplaysToDoList {

    func displayToDoList(toDoListViewModel viewModel: ToDoListViewModel) {

        displayToDoTitle(viewModel: viewModel)
        updateTableDataSource(viewModel: viewModel)
        displaySelection(viewModel: viewModel)

        focusTableView()
    }

    private func displayToDoTitle(viewModel viewModel: ToDoListViewModel) {

        titleTextField.stringValue = viewModel.title
    }

    private func updateTableDataSource(viewModel viewModel: ToDoListViewModel) {

        dataSource.updateContents(toDoListViewModel: viewModel)
        tableView.reloadData()
    }

    private func displaySelection(viewModel viewModel: ToDoListViewModel) {

        guard let selectedRow = viewModel.selectedRow else {
            tableView.selectRowIndexes(NSIndexSet(), byExtendingSelection: false)
            return
        }

        tableView.selectRowIndexes(NSIndexSet(index: selectedRow), byExtendingSelection: false)
    }

    private func focusTableView() {

        self.window?.makeFirstResponder(tableView)
    }
}


// MARK: Cell creation & event handling

extension ToDoListWindowController: NSTableViewDelegate {

    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let cellView = dataSource.toDoCellView(tableView: tableView, row: row, owner: self)
            else { return nil }

        cellView.toDoItemChangeDelegate = self

        return cellView
    }

    func tableViewSelectionDidChange(notification: NSNotification) {

        let action: SelectionAction = {
            // "None" equals -1
            guard tableView.selectedRow >= 0 else { return .deselect }

            return .select(row: tableView.selectedRow)
        }()

        dispatchAction(action)
    }
}

extension ToDoListWindowController: ToDoItemChangeDelegate {

    func toDoItem(identifier identifier: String, didChangeChecked checked: Bool) {

        guard let toDoID = ToDoID(identifier: identifier)
            else { preconditionFailure("Invalid To-Do item identifier \(identifier).") }

        let action: ToDoAction = {
            switch checked {
            case true:  return ToDoAction.check(toDoID)
            case false: return ToDoAction.uncheck(toDoID)
            }
        }()

        dispatchAction(action)
    }

    func toDoItem(identifier identifier: String, didChangeTitle title: String) {

        guard let toDoID = ToDoID(identifier: identifier)
            else { preconditionFailure("Invalid To-Do item identifier \(identifier).") }

        dispatchAction(ToDoAction.rename(toDoID, title: title))
    }
}
