//
//  UIImage+ImageArrayForGif.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 02/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    static func createImageArray(total: Int, imagePrefix: String) -> [UIImage] {
        var imageArray: [UIImage] = []
        for imageCount in 0..<total {
            let imageName = "\(imagePrefix)-\(imageCount+1).png"
            //so that it loads framework images
            let image = UIImage(named: imageName, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            
            imageArray.append(image)
        }
        return imageArray
    }
}
