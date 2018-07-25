//
//  UIImage+Animate.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 02/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func animate(images: [UIImage]) {
        self.animationImages = images
        //1.0 looks little slow, 0.5 seems a bit fast
        self.animationDuration = 0.6
        //has set some higher number of repeat count as it might take time to load the image
        self.animationRepeatCount = 20
        self.startAnimating()
    }
    
    func stopAnimate() {
        self.stopAnimating()
    }
}
