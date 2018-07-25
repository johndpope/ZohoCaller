//
//  ImageView+CircularView.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 02/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit

//UIImageView extension for creating circular image view with and without inset
extension UIImageView {
    //this is used when we obtain image from server like contact images and all.
    //where we don't have any padding or margin.
    //but we need border otherwise image will not look nice when there is a white background
    //usage:
    //let image:UIImage = UIImage(named: "searchsdk-nouser-image")!
    //self.docsImageView.maskCircle(anyImage: image) - pass instance of UIImage
    public func maskCircle(anyImage: UIImage) {
        self.contentMode = UIViewContentMode.scaleAspectFill
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = false
        self.clipsToBounds = true
        self.image = anyImage
    }
    
    //used when we have internal icons like mail read unread icon, crm icons
    //this will have some padding, margins and will be inset in circular view
    static func createCircularImageViewWithInset(image: UIImage, bgColor: UIColor? = nil, borderColor: UIColor? = nil, insetPadding: CGFloat, imageViewWidth: CGFloat, imageViewHeight: CGFloat) -> UIImageView {
        var bgColor = bgColor
        if (bgColor == nil) {
            bgColor = SearchKitConstants.ColorConstants.ResultImageBackgroundColor
        }
        
        var borderColor = borderColor
        if borderColor == nil {
            borderColor = SearchKitConstants.ColorConstants.ResultImageBorderColor
        }
        
        //for circular view padding in all side should be the same and also width and height of the image view should be the same
        let imageView = UIImageView(image: image.imageWithInsets(insets: UIEdgeInsetsMake(insetPadding, insetPadding, insetPadding, insetPadding)))
        imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        imageView.backgroundColor = bgColor //ColorConstants.ResultImageBackgroundColor
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = borderColor?.cgColor
        
        //make circle
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = true;
        imageView.layer.masksToBounds = false
        
        return imageView
    }
    
    static func createCircularImageViewWithInsetForGradient(image: UIImage, insetPadding: CGFloat, imageViewWidth: CGFloat, imageViewHeight: CGFloat) -> UIImageView {
        //set image inset
        let imageView = UIImageView(image: image.imageWithInsets(insets: UIEdgeInsetsMake(insetPadding, insetPadding, insetPadding, insetPadding)))
        imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        //in case of gradient color, we must not set border for the image and also no background color
        
        //make circle
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = true;
        imageView.layer.masksToBounds = false
        
        return imageView
    }
    
    static func createCircularImageViewWithInsetWithoutBorder(image: UIImage, bgColor: UIColor? = nil, insetPadding: CGFloat, imageViewWidth: CGFloat, imageViewHeight: CGFloat) -> UIImageView {
        var bgColor = bgColor
        if (bgColor == nil) {
            bgColor = SearchKitConstants.ColorConstants.ResultImageBackgroundColor
        }
        
        //for circular view padding in all side should be the same and also width and height of the image view should be the same
        let imageView = UIImageView(image: image.imageWithInsets(insets: UIEdgeInsetsMake(insetPadding, insetPadding, insetPadding, insetPadding)))
        imageView.frame = CGRect(x: 0, y: 0, width: imageViewWidth, height: imageViewHeight)
        
        //make circle
        imageView.layer.cornerRadius = imageView.frame.size.width / 2;
        imageView.clipsToBounds = true;
        imageView.layer.masksToBounds = false
        
        return imageView
    }
}
