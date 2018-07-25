//
//  ZOSLogger.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 18/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation

// Enum for showing the type of Log Types
enum LogEvent: String {
    case e = "[‼️]" // error
    case i = "[ℹ️]" // info
    case d = "[💬]" // debug
    case v = "[🔬]" // verbose
    case w = "[⚠️]" // warning
    case s = "[🔥]" // severe
}

// MARK: Make sure all the debug logs are wiped out from the production code, only error logs are logged.
class SearchKitLogger {
    
    //Date format to be printed the console
    static var dateFormat = "yyyy-MM-dd hh:mm:ssSSS"
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone.current
        return formatter
    }
    
    class func debugLog(message: String, filePath: String, lineNumber: Int, funcName: String) {
        SearchKitLogger.dLog(event: .d, message: message, filePath: filePath, line: lineNumber, funcName: funcName)
    }
    
    class func infoLog(message: String, filePath: String, lineNumber: Int, funcName: String) {
        SearchKitLogger.dLog(event: .i, message: message, filePath: filePath, line: lineNumber, funcName: funcName)
    }
    
    class func verboseLog(message: String, filePath: String, lineNumber: Int, funcName: String) {
        SearchKitLogger.dLog(event: .v, message: message, filePath: filePath, line: lineNumber, funcName: funcName)
    }
    
    class func warningLog(message: String, filePath: String, lineNumber: Int, funcName: String) {
        SearchKitLogger.eLog(event: .w, message: message, filePath: filePath, line: lineNumber, funcName: funcName)
    }
    
    class func errorLog(message: String, filePath: String, lineNumber: Int, funcName: String) {
        SearchKitLogger.eLog(event: .e, message: message, filePath: filePath, line: lineNumber, funcName: funcName)
    }
    
    class func severeLog(message: String, filePath: String, lineNumber: Int, funcName: String) {
        SearchKitLogger.eLog(event: .s, message: message, filePath: filePath, line: lineNumber, funcName: funcName)
    }
    
    class func dLog(event: LogEvent,
                   message: String,
                   filePath: String,
                   line: Int,
                   funcName: String) {
        /*
        #if DEBUG
            print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: filePath))]:\(line) \(funcName) ::: MESSAGE ::: \(message)")
        #endif
        */
        //Print debug logs only when enabled forcefully or set to auto and build is a development build.
        if ZohoSearchKit.sharedInstance().printDebugLog {
            print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: filePath))]:\(line) \(funcName) ::: MESSAGE ::: \(message)")
        }
    }
    
    
    /// By default eLog will be pribted even in the release app. Only debug log will have the conditional check.
    ///
    /// - Parameters:
    ///   - event: Type of the log message.
    ///   - message: Message to be logged
    ///   - filePath: Filepath of the Swift file from which the call has been made
    ///   - line: Line number from which the call has been made
    ///   - funcName: Function name from which the call has been made.
    class func eLog(event: LogEvent,
              message: String,
              filePath: String,
              line: Int,
              funcName: String) {
        
            print("\(Date().toString()) \(event.rawValue)[\(sourceFileName(filePath: filePath))]:\(line) \(funcName) ::: MESSAGE ::: \(message)")
    }
    
    private class func sourceFileName(filePath: String) -> String {
        let components = filePath.components(separatedBy: "/")
        return components.isEmpty ? "" : components.last!
    }
}

internal extension Date {
    func toString() -> String {
        return SearchKitLogger.dateFormatter.string(from: self as Date)
    }
}
