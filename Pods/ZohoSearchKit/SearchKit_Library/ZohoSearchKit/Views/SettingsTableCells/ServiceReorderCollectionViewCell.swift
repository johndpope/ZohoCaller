//
//  ServiceReorderCollectionViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 27/02/18.
//

import UIKit

class ServiceReorderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var serviceImageView: UIImageView!
    @IBOutlet weak var serviceNameLabel: UILabel!
    
    //this is actual service name used for server communication
    var serviceName: String? {
        didSet {
            guard serviceName != nil else {
                return
            }
            
            if let image = ServiceIconUtils.getServiceIcon(serviceName: serviceName!) {
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60)
                serviceImageView.addSubview(imageView)
            }
            self.displayName = SearchKitUtil.getServiceDisplayName(serviceName: serviceName!)
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
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        serviceImageView.image = nil
        let extSubviews = serviceImageView.subviews
        for subView in extSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
    }

}
