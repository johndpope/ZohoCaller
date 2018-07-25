//
//  SeparatorLineCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 11/06/18.
//

import UIKit

class SeparatorLineCell: UITableViewCell {

    @IBOutlet weak var separatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
           separatorLine.backgroundColor = #colorLiteral(red: 0.9067421556, green: 0.9013521671, blue: 0.9108855724, alpha: 1)
        // Initialization code
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
