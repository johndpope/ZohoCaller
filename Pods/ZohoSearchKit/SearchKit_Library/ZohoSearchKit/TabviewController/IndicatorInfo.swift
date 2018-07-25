//  IndicatorInfo.swift
//  ButtonChildViewController
//
//  Created by manikandan bangaru on 25/01/18.
//  Copyright © 2018 manikandan bangaru. All rights reserved.
//


import UIKit

public struct IndicatorInfo{

    public var title: String?
    public var serviceName: String?
  //  public var result=SearchResultsViewModel()
//    public var image: UIImage?
//    public var highlightedImage: UIImage?
   // public var userInfo: Any?
    
    public init(title: String?,serviceName: String?) {
        self.serviceName = serviceName
         self.title = title
    }
    //we will use userinfo for storing result set of search query
    
    
//    public init(image: UIImage?, highlightedImage: UIImage? = nil, userInfo: Any? = nil) {
//    //        self.image = image
//        self.highlightedImage = highlightedImage
//    }
//
//    public init(title: String?, image: UIImage?, highlightedImage: UIImage? = nil, userInfo: Any? = nil) {
//      //        self.title = title
//        self.image = image
//        self.highlightedImage = highlightedImage
//    }
    
    
}

