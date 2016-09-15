//
//  PatchingResponder.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 15/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Cocoa

protocol PatchingResponderType: class {

    var referenceResponder: NSResponder! { get }

    func patchIntoResponderChain()
}

extension PatchingResponderType where Self : NSResponder {

    func patchIntoResponderChain() {

        let oldResponder = referenceResponder.nextResponder
        referenceResponder.nextResponder = self
        self.nextResponder = oldResponder
    }
}

/// `NSResponder` that upon `awakeFromNib()` puts itself into the
/// responder chain right before `referenceResponder`.
class PatchingResponder: NSResponder, PatchingResponderType {

    @IBOutlet var referenceResponder: NSResponder!

    override func awakeFromNib() {

        super.awakeFromNib()

        self.patchIntoResponderChain()
    }
}
