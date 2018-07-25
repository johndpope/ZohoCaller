//  TabBarCollectionViewCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 25/01/18.
//  Copyright © 2018 manikandan bangaru. All rights reserved.
//



import UIKit

class TabBarCollectionViewCell: UICollectionViewCell {

    @IBOutlet var label: UILabel!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        label.textColor = SearchKitConstants.ColorConstants.TabBarView_Non_SelectedCell_Text_Color
        label.backgroundColor =  SearchKitConstants.ColorConstants.TabBarView_BackGround_Color
    }
}
