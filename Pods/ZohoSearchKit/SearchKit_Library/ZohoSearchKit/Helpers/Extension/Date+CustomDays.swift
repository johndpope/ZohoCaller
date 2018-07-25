//
//  Date+CustomDays.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 12/04/18.
//

import Foundation
extension Date {
 static   var serverDateFormate : DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d-M-yyyy"
        return dateFormatter
    }
    static   var display_Formate : DateFormatter {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-yyyy"
        return dateFormatter
    }
   static var currentDay : Int {
        return Calendar.current.component(.day,  from: Date())
    }
  static  var currentMonth : Int {
        return Calendar.current.component(.day,  from: Date())
    }
  static  var today: String {
        return  Date.serverDateFormate.string(from: Date())
    }
 static   var yesterday: String {
        return  Date.serverDateFormate.string(from: Calendar.current.date(byAdding: .day, value: -1, to: noon)!)
    }
  static  var tomorrow: String {
        return Date.serverDateFormate.string(from:Calendar.current.date(byAdding: .day, value: 1, to: noon)!)
    }
  static  var Last7thday: String {
        return Date.serverDateFormate.string(from:Calendar.current.date(byAdding: .day, value: -7, to: noon)!)
    }
  static  var ThisMonthFirstDay: String {
        return Date.serverDateFormate.string(from:Calendar.current.date(byAdding: .day, value: -(currentDay-1), to: noon)!)
    }
static  var ThisYearFirstDay: String {
 
    let date = Date()
    let calendar = NSCalendar.current
    let thisYear = calendar.component(.year, from: date)
    return ("1-1-" + String(thisYear)) // This year first day 
    }
  static  var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: Date())!
    }
    var day: String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        return  dateFormatter.string(from: self)
    }
}
