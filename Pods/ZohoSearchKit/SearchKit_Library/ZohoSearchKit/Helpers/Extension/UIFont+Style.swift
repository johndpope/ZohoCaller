//
//  UIFont+Style.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 30/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit

//Extension for font to directly set different font style
extension UIFont {
    var bold: UIFont {
        return with(traits: .traitBold)
    }
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    }
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    }
    
    //uses - label.font.with(traits: [ .traitBold, .traitCondensed ])
    //to get font with given styles/traits
    func with(traits: UIFontDescriptorSymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }
}
