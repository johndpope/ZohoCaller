//
//  MVCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 08/02/18.
//

import UIKit

class ServiceSuggestionCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var label: UILabel!
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
    override func awakeFromNib() {
//        image.maskCircle(anyImage: UIImage(named: "searchsdk_service_all_blue" , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!)
        //first load the no user image and show loading icon
//        let img:UIImage = UIImage(named: "searchsdk_service_all_blue" , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
//        let imageView = UIImageView.createCircularImageViewWithBorder(image: img, bgColor: UIColor.white)
//        //so that after failure of image loading also image will be circular
//        imageView.maskCircle(anyImage: img)
//        
//        image.addSubview(imageView)
        
        super.awakeFromNib()
        // Initialization code
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image.image = nil
        let extSubviews = image.subviews
        for subView in extSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
    }

}
