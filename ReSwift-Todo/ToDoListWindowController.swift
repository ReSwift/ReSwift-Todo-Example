//
//  ToDoListWindowController.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

protocol ToDoListWindowControllerDelegate: class {

    func toDoListWindowControllerDidLoad(_ controller: ToDoListWindowController)
    func toDoListWindowControllerWillClose(_ controller: ToDoListWindowController)
}

protocol ToDoTableDataSourceType {

    var tableDataSource: NSTableViewDataSource { get }

    var selectedRow: Int? { get }
    var selectedToDo: ToDoViewModel? { get }
    var toDoCount: Int { get }

    func updateContents(toDoListViewModel viewModel: ToDoListViewModel)
    func toDoCellView(tableView: NSTableView, row: Int, owner: AnyObject) -> ToDoCellView?
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
    @IBOutlet var keyboardEventHandler: KeyboardEventHandler?

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
            tableView.dataSource = dataSource.tableDataSource
            keyboardEventHandler?.dataSource = dataSource
        }
    }

    var store: ToDoListStore? {

        didSet {
            keyboardEventHandler?.store = store
        }
    }

    convenience init() {

        self.init(windowNibName: "ToDoListWindowController")
    }

    fileprivate var didLoad = false {
        didSet {
            delegate?.toDoListWindowControllerDidLoad(self)
        }
    }

    override func awakeFromNib() {

        super.awakeFromNib()

        NotificationCenter.default.addObserver(self, selector: #selector(windowWillClose(_:)), name: NSNotification.Name.NSWindowWillClose, object: self.window)

        tableView.dataSource = self.dataSource.tableDataSource
        tableView.delegate = self

        keyboardEventHandler?.dataSource = self.dataSource
        keyboardEventHandler?.store = self.store
    }

    override func windowDidLoad() {

        super.windowDidLoad()

        didLoad = true
    }

    @IBAction func changeTitle(_ sender: AnyObject) {

        guard let textField = sender as? NSTextField else { return }

        let newName = textField.stringValue

        dispatchAction(RenameToDoListAction(renameTo: newName))
    }

    fileprivate func dispatchAction(_ action: Action) {

        store?.dispatch(action)
    }

    func windowWillClose(_ notification: Notification) {

        guard let sendingWindow = notification.object as? NSWindow
            , sendingWindow == self.window
            else { return }

        delegate?.toDoListWindowControllerWillClose(self)
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

    fileprivate func displayToDoTitle(viewModel: ToDoListViewModel) {

        titleTextField.stringValue = viewModel.title
    }

    fileprivate func updateTableDataSource(viewModel: ToDoListViewModel) {

        dataSource.updateContents(toDoListViewModel: viewModel)
        tableView.reloadData()
    }

    fileprivate func displaySelection(viewModel: ToDoListViewModel) {

        guard let selectedRow = viewModel.selectedRow else {
            tableView.selectRowIndexes(IndexSet(), byExtendingSelection: false)
            return
        }

        tableView.selectRowIndexes(IndexSet(integer: selectedRow), byExtendingSelection: false)
    }

    fileprivate func focusTableView() {

        self.window?.makeFirstResponder(tableView)
    }
}


// MARK: Cell creation & event handling

extension ToDoListWindowController: NSTableViewDelegate {

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {

        guard let cellView = dataSource.toDoCellView(tableView: tableView, row: row, owner: self)
            else { return nil }

        cellView.toDoItemChangeDelegate = self

        return cellView
    }

    func tableViewSelectionDidChange(_ notification: Notification) {

        let action: SelectionAction = {
            // "None" equals -1
            guard tableView.selectedRow >= 0 else { return .deselect }

            return .select(row: tableView.selectedRow)
        }()

        dispatchAction(action)
    }
}

extension ToDoListWindowController: ToDoItemChangeDelegate {

    func toDoItem(identifier: String, didChangeChecked checked: Bool) {

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

    func toDoItem(identifier: String, didChangeTitle title: String) {

        guard let toDoID = ToDoID(identifier: identifier)
            else { preconditionFailure("Invalid To-Do item identifier \(identifier).") }

        dispatchAction(ToDoAction.rename(toDoID, title: title))
    }
}

extension ToDoListWindowController: ToDoItemEditDelegate {

    func editItem(row: Int, insertText text: String?) {

        guard let cellView = self.tableView.view(atColumn: 0, row: row, makeIfNecessary: true) as? ToDoCellView,
            let textField = cellView.textField
            else { return }

        textField.selectText(self)

        guard let editor = textField.currentEditor(),
            let text = text
            else { return }

        editor.insertText(text)
    }
}
