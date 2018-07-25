//
//  SortByFilterCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 05/03/18.
//

import UIKit

class FilterVCSegmentedView: UITableViewCell {

    @IBOutlet weak var SortBySelector: UISegmentedControl!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    static var identifier: String {
        return String(describing: self)
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
 
}
