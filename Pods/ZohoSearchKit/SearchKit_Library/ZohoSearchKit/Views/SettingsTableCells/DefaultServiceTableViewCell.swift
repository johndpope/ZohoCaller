//
//  DefaultServiceTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 27/02/18.
//

import UIKit

class DefaultServiceTableViewCell: UITableViewCell {

    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    var serviceName: String? {
        didSet {
            guard serviceName != nil else {
                return
            }
            
            if let image = ServiceIconUtils.getServiceIcon(serviceName: serviceName!) {
                let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: nil, insetPadding: 4, imageViewWidth: 40, imageViewHeight: 40)
                serviceImageView.addSubview(imageView)
            }
        }
    }
    
    var displayName: String? {
        didSet {
            guard displayName != nil else {
                return
            }
            
            serviceNameLabel.text = displayName
        }
    }
    
    var selectionSate: Bool? = false {
        didSet {
            guard selectionSate != nil else {
                return
            }
            
            if selectionSate! {
                selectedImageView.isHidden = false
                if let image = UIImage(named: SearchKitConstants.ImageNameConstants.SelctionTickImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil) {
                    let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 40, imageViewHeight: 40)
                    imageView.changeTintColor(SearchKitConstants.ColorConstants.NavigationBar_BackGround_Color)
                    selectedImageView.addSubview(imageView)
                }
                //self.isSelected = true
                self.setSelected(true, animated: false)
            }
            else {
                selectedImageView.isHidden = true
                self.setSelected(false, animated: false)
            }
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
        //let bgColorView = UIView()
        //bgColorView.backgroundColor = ColorConstants.SelectedServiceTableBGColor
        //self.selectedBackgroundView = bgColorView
    }
    
    override func prepareForReuse() {
        selectedImageView.isHidden = !selectionSate!
        
        serviceImageView.image = nil
        let extSubviews = serviceImageView.subviews
        for subView in extSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
        
        if !selectionSate! {
            selectedImageView.image = nil
            let extSubviews2 = selectedImageView.subviews
            for subView in extSubviews2 {
                if (subView is UIImageView) {
                    subView.removeFromSuperview()
                }
            }
        }
//        else {
//            self.setSelected(true, animated: false)
//        }
        
        //remove from subview the tick image otherwise it will be problem
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
