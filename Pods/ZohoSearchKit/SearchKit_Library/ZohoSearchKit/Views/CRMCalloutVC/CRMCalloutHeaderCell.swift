//
//  CRMCalloutHeaderCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 11/06/18.
//

import UIKit

class CRMCalloutHeaderCell: UITableViewHeaderFooterView {
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var crmModuleImageView: UIImageView!
    @IBOutlet weak var crmTitle: UILabel!
    @IBOutlet weak var separatorLine: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        performUIUpdatesOnMain {
            self.bgView.backgroundColor =  SearchKitConstants.ColorConstants.CalloutVC_HeaderView_BackgroundColor
            self.separatorLine.backgroundColor = SearchKitConstants.ColorConstants.SeparatorLine_BackGroundColor
        }
    }
   
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
