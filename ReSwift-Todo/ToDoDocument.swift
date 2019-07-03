//
//  ToDoDocument.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 06/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

class ToDoDocument: NSDocument {

    // MARK: - Initialization

    lazy var store: ToDoListStore = toDoListStore(undoManager: self.undoManager!)

    var presenter: ToDoListPresenter!

    override func makeWindowControllers() {

        let windowController = ToDoListWindowController()
        windowController.delegate = self
        windowController.store = self.store

        self.presenter = ToDoListPresenter(view: windowController)

        addWindowController(windowController)
    }

    
    // MARK: - Saving/Loading Data

    override class var autosavesInPlace: Bool {
        return true
    }

    lazy var importer: ToDoListImporter = ToDoListImporter()
    lazy var serializer: ToDoListSerializer = ToDoListSerializer()

    override func data(ofType typeName: String) throws -> Data {

        let list = store.state.toDoList

        guard let data = serializer.data(toDoList: list) else {
            // TODO: show saving error alert
            throw SerializationError.cannotEncodeString
        }

        return data
    }

    override func read(from url: URL, ofType typeName: String) throws {

        let contents: ToDoList

        do {
            contents = try importer.importToDoList(url: url)
        } catch {
            // TODO: show error alert
            reportError(error)
            return
        }

        store.dispatch(ReplaceToDoListAction(newToDoList: contents))
    }

}

extension ToDoDocument: ToDoListWindowControllerDelegate {

    func toDoListWindowControllerDidLoad(_ controller: ToDoListWindowController) {

        store.subscribe(presenter)
    }

    func toDoListWindowControllerWillClose(_ controller: ToDoListWindowController) {

        store.unsubscribe(presenter)
    }
}
