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

    func updateContents(toDoListViewModel viewModel: ToDoListViewModel)
}

extension ToDoTableDataSourceType where Self: NSTableViewDataSource {

    var tableDataSource: NSTableViewDataSource {
        return self
    }
}

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

    lazy var dataSource: ToDoTableDataSourceType = ToDoTableDataSource()

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
    }

    override func windowDidLoad() {

        super.windowDidLoad()

        didLoad = true
    }

    func windowWillClose(notification: NSNotification) {

        guard let sendingWindow = notification.object as? NSWindow
            where sendingWindow == self.window
            else { return }

        delegate?.toDoListWindowControllerWillClose(self)
    }
}

protocol DisplaysToDoList {

    func displayToDoList(toDoListViewModel viewModel: ToDoListViewModel)
}

extension ToDoListWindowController: DisplaysToDoList {

    func displayToDoList(toDoListViewModel viewModel: ToDoListViewModel) {

        displayToDoTitle(viewModel: viewModel)
        updateTableDataSource(viewModel: viewModel)
    }

    private func displayToDoTitle(viewModel viewModel: ToDoListViewModel) {

        titleTextField.stringValue = viewModel.title
    }

    private func updateTableDataSource(viewModel viewModel: ToDoListViewModel) {

        dataSource.updateContents(toDoListViewModel: viewModel)
        tableView.reloadData()
    }
}
