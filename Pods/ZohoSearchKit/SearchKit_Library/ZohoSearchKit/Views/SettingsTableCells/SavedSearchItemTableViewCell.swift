//
//  SavedSearchItemTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 27/02/18.
//

import UIKit

class SavedSearchItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var savedSearchIV: UIImageView!
    @IBOutlet weak var savedSearchName: UILabel!
    @IBOutlet weak var savedTime: UILabel!
    @IBOutlet weak var gotoImageView: UIImageView!
    
    var savedSearch: SavedSearches? {
        didSet {
            guard savedSearch != nil else {
                return
            }
            
            savedSearchName.text = savedSearch?.saved_search_name
            savedTime.text = DateUtils.getDisaplayableDate(timestamp: (savedSearch?.lmtime)!)
            
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //These images are fixed and should be added only once for the cell. Duplicate subviews will not be added.
        if let image = UIImage(named: SearchKitConstants.ImageNameConstants.SavedSearchImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil) {
            let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 50, imageViewHeight: 50)
              imageView.changeTintColor(ThemeService.sharedInstance().theme.navigationBarBackGroundColor)
            savedSearchIV.addSubview(imageView)
        }
        
        if let image = UIImage(named: SearchKitConstants.ImageNameConstants.GoForwardImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil) {
            let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: nil, insetPadding: 6, imageViewWidth: 30, imageViewHeight: 30)
              imageView.changeTintColor(ThemeService.sharedInstance().theme.navigationBarBackGroundColor)
            gotoImageView.addSubview(imageView)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
