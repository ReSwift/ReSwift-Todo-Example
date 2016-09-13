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

        self.presenter = ToDoListPresenter(view: windowController)

        addWindowController(windowController)
    }

    
    // MARK: - Saving/Loading Data

    override class func autosavesInPlace() -> Bool {
        return true
    }

    lazy var importer: ToDoListImporter = ToDoListImporter()
    lazy var serializer: ToDoListSerializer = ToDoListSerializer()

    override func dataOfType(typeName: String) throws -> NSData {

        let list = store.state.toDoList

        guard let data = serializer.data(toDoList: list) else {
            // TODO: show saving error alert
            throw SerializationError.cannotEncodeString
        }

        return data
    }

    override func readFromURL(url: NSURL, ofType typeName: String) throws {

        let contents: ToDoList

        do {
            contents = try importer.importToDoList(url)
        } catch {
            // TODO: show error alert
            reportError(error)
            return
        }

        store.dispatch(ToDoListAction.replaceList(contents))
    }

}

extension ToDoDocument: ToDoListWindowControllerDelegate {

    func toDoListWindowControllerDidLoad(controller: ToDoListWindowController) {

        store.subscribe(presenter)
    }

    func toDoListWindowControllerWillClose(controller: ToDoListWindowController) {

        store.unsubscribe(presenter)
    }
}
