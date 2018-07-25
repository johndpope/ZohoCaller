//
//  File.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 12/04/18.
//

import Foundation
extension UIView {
    /** Loads instance from nib with the same name. */
    func loadNib() -> UIView {
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: ZohoSearchKit.frameworkBundle)
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            
            fatalError("Could not load view from nib file.")
        }
        return view //nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}
