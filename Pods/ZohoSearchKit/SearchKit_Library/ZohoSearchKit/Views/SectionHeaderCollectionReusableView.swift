//
//  SectionHeaderCollectionReusableView.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 29/06/18.
//

import UIKit

class SectionHeaderCollectionReusableView: UICollectionReusableView {
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
