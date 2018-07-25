//
//  String+RemoveWhiteSpace.swift
//  JAnalytics
//
//  Created by hemant kumar s. on 09/02/18.
//

import Foundation

extension String {
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}
