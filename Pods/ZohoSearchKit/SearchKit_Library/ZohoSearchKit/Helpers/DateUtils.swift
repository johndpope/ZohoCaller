//
//  DateFormatter.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 28/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation

//For better perf, don't create the date formatter again and again.
private var cachedFormatters = [String : DateFormatter]()

extension DateFormatter {
    static func cached(withFormat format: String) -> DateFormatter {
        if let cachedFormatter = cachedFormatters[format] {
            return cachedFormatter
        }
        let formatter = DateFormatter()
        formatter.dateFormat = format
        cachedFormatters[format] = formatter
        return formatter
    }
}

class DateUtils {
    static func getDisaplayableDate(timestamp: Int64) -> String {
        var displayableDate = ""
        let calendar = Calendar.current
        //divided by 1000 as the Date object expects in seconds
        let date = Date(timeIntervalSince1970: Double(timestamp/1000))
        if (calendar.isDateInToday(date)) {
            //if today just display the time
            let dateformatter = DateFormatter.cached(withFormat: "h:mm a")
            displayableDate = dateformatter.string(from: date)
        }
        else {
            let currentDate = Date()
            let currentYear = calendar.component(.year, from: currentDate)
            let year = calendar.component(.year, from: date)
            if (year == currentYear) {
                let dateformatter = DateFormatter.cached(withFormat: "dd MMM")
                displayableDate = dateformatter.string(from: date)
            }
            else {
                let dateformatter = DateFormatter.cached(withFormat: "dd MMM, yyyy")
                displayableDate = dateformatter.string(from: date)
            }
            //let month = calendar.component(.month, from: date)
            //let day = calendar.component(.day, from: date)
        }
        return displayableDate
    }
}
