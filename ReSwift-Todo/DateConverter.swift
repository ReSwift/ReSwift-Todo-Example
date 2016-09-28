//
//  DateConverter.swift
//  ReSwift-Todo
//
//  Created by Christian Tietze on 13/09/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import Foundation

extension Calendar {

    func dateFromISOComponents(year: Int, month: Int, day: Int) -> Date? {

        // Without custom checks, "12-945-23" does work.
        guard (1...12).contains(month)
            && (1...31).contains(day)
            else { return nil }

        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day

        return self.date(from: components)
    }
}

class DateConverter {

    init() { }

    /// Expects `isoDateString` to start with `2016-09-13`
    /// (YYYY-MM-DD) and extracts these values.
    func date(isoDateString string: String, calendar: Calendar = Calendar.autoupdatingCurrent) -> Date? {

        let parts = string.characters.split(separator: "-")
            .map(String.init)
            .flatMap { Int($0) }

        guard parts.count >= 3 else { return nil }

        return calendar.dateFromISOComponents(year: parts[0], month: parts[1], day: parts[2])
    }

    static var isoFormatter: DateFormatter = {

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    func string(date: Date) -> String {

        return DateConverter.isoFormatter.string(from: date)
    }
}
