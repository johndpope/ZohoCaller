//
//  UIImage+ImageLoaders.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 14/06/18.
//

import Foundation
import Kingfisher
extension UIImageView
{
    func kfMakeCircularwithBorderandbgColor() {
        //MARK:- setting masktoBounds fix's corner radius issue
        self.layer.masksToBounds = true
        self.layer.cornerRadius =  self.frame.size.width / 2
        let bgColor = SearchKitConstants.ColorConstants.ResultImageBackgroundColor
        let  borderColor = SearchKitConstants.ColorConstants.ResultImageBorderColor
        self.backgroundColor = bgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = borderColor.cgColor
    }
    func loadPhotofor(imageName : String)
    {
        performUIUpdatesOnMain {
          
            let image:UIImage = UIImage(named: imageName, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            self.image = image.imageWithInsets(insets: UIEdgeInsetsMake(10, 10, 10, 10))
              self.kfMakeCircularwithBorderandbgColor()
        }
    }
    func kfloadPhotofor(photoURL : URL)
    {
      
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            
            if let oAuthToken = token {
                performUIUpdatesOnMain {
                    let modifier = AnyModifier { request in
                        var r = request
                        r.setValue("Zoho-oauthtoken "+oAuthToken, forHTTPHeaderField: "Authorization")
                        return r
                    }
                    let processor = RoundCornerImageProcessor(cornerRadius: self.frame.width)
                    let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
               
                    self.kf.setImage(with: photoURL, placeholder: image , options: [.requestModifier(modifier), .processor(processor)])
                     self.kfMakeCircularwithBorderandbgColor()
                }
            }
        })
    }
    func kfloadContactImagefor(zuid : Int64)
    {
        var parameters = [String: AnyObject]()
        parameters[ZOSSearchAPIClient.ContactsPhotoAPIParamKeys.FileSize] = ZOSSearchAPIClient.ContactsPhotoAPIParamValues.ContactImageFileSize.Thumb.rawValue as AnyObject
        parameters[ZOSSearchAPIClient.ContactsPhotoAPIParamKeys.PhotoType] = ZOSSearchAPIClient.ContactsPhotoAPIParamValues.ContactImageType.User.rawValue as AnyObject
        parameters[ZOSSearchAPIClient.ContactsPhotoAPIParamKeys.ContactID] = zuid as AnyObject
        
        let photoURL = ZOSSearchAPIClient.sharedInstance().contactsImageURLFromParameters(parameters);
        let request = NSMutableURLRequest(url: photoURL)
        self.kfloadPhotofor(photoURL: request.url!)
    }
}
