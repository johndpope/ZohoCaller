//
//  DrillDownSettingsTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 26/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

class DrillDownSettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingsImageView: UIImageView!
    @IBOutlet weak var settingsNameLabel: UILabel!
    @IBOutlet weak var gotoImageView: UIImageView!
    
    //If nuber of properties needed gorws, this will be moved to separate model class
    var imageName: String? {
        didSet {
            guard imageName != nil else {
                return
            }
            
            if let image = UIImage(named: imageName!, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil) {
                let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 50, imageViewHeight: 50)
                imageView.changeTintColor(SearchKitConstants.ColorConstants.NavigationBar_BackGround_Color)
                settingsImageView.addSubview(imageView)
            }
            
        }
    }
    
    var name: String? {
        didSet {
            guard name != nil else {
                return
            }
            
            settingsNameLabel.text = name
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //common in all the cells. So, should be added only once.
        if let image = UIImage(named: SearchKitConstants.ImageNameConstants.GoForwardImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil) {
            let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: nil, insetPadding: 6, imageViewWidth: 30, imageViewHeight: 30)
            gotoImageView.addSubview(imageView)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
