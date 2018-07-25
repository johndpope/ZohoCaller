//
//  SuggestionSectionHeaderCellIOS11.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 02/07/18.
//

import UIKit

class SuggestionSectionHeaderCellIOS11: UITableViewHeaderFooterView {

    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
