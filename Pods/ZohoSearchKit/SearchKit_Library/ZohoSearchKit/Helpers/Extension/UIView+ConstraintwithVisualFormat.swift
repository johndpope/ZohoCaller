//
//  UIView+ConstraintwithVisualFormat.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 13/02/18.
//

import UIKit

extension UIView {
    
    func addConstraintwithFormate(format : String ,views : UIView...){
        var viewsDictionary = [String : UIView]()
        
        for (index , view) in views.enumerated()
        {
            
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
        
    }
    
    
    
}
