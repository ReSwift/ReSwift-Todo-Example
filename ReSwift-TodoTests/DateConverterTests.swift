//
//  DateConverterTests.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import XCTest
@testable import ReSwiftTodo

class DateConverterTests: XCTestCase {

    func testDate_EmptyString_ReturnsNil() {

        XCTAssertNil(DateConverter().date(isoDateString: ""))
    }

    func testDate_TextString_ReturnsNil() {

        XCTAssertNil(DateConverter().date(isoDateString: "asd"))
    }

    func testDate_StringWithDashed_ReturnsNil() {

        XCTAssertNil(DateConverter().date(isoDateString: "asd-foo-bar"))
    }

    func testDate_WeirdNumbers_ReturnsNil() {

        XCTAssertNil(DateConverter().date(isoDateString: "12-945-23"))
    }

    func testDate_ISODateString_ReturnsDate() {

        let expectedDate = NSCalendar.autoupdatingCurrentCalendar().dateFromISOComponents(year: 2015, month: 12, day: 24)!
        XCTAssert(
            DateConverter().date(isoDateString: "2015-12-24")?
                .isEqualToDate(expectedDate) ?? false)
    }
}
