//
//  DateConverter.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

extension NSCalendar {

    func dateFromISOComponents(year year: Int, month: Int, day: Int) -> NSDate? {

        // Without custom checks, "12-945-23" does work.
        guard (1...12).contains(month)
            && (1...31).contains(day)
            else { return nil }

        let components = NSDateComponents()
        components.year = year
        components.month = month
        components.day = day

        return self.dateFromComponents(components)
    }
}

class DateConverter {

    init() { }

    /// Expects `isoDateString` to start with `2016-09-13`
    /// (YYYY-MM-DD) and extracts these values.
    func date(isoDateString string: String, calendar: NSCalendar = NSCalendar.autoupdatingCurrentCalendar()) -> NSDate? {

        let parts = string.characters.split("-")
            .map(String.init)
            .flatMap { Int($0) }

        guard parts.count >= 3 else { return nil }

        return calendar.dateFromISOComponents(year: parts[0], month: parts[1], day: parts[2])
    }

    static var isoFormatter: NSDateFormatter = {

        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        return formatter
    }()

    func string(date date: NSDate) -> String {

        return DateConverter.isoFormatter.stringFromDate(date)
    }
}
