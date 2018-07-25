//
//  FieldUIConfig.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 19/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

class FieldUIConfig {
    private var _fieldFontColor = UIColor.black
    private var _fieldFontSize:Float = 18.0
    
    init?(fontColor: UIColor, fontSize: Float) {
        self._fieldFontColor = fontColor
        self._fieldFontSize = fontSize
    }
    
    var fieldFontColor: UIColor {
        get {
            return _fieldFontColor
        }
        set(newValue) {
            _fieldFontColor = newValue
        }
    }
    
    var fieldFontSize: Float {
        get {
            return _fieldFontSize
        }
        set(newValue) {
            _fieldFontSize = newValue
        }
    }
}
