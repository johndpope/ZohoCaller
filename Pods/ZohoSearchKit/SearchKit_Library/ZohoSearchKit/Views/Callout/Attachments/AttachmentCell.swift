//
//  AttachmentCells.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 11/05/18.
//

import UIKit

class AttachmentCell: UITableViewCell {

    @IBOutlet weak var attachmentImageView: UIImageView!
    
    @IBOutlet weak var downloadIconImageView: UIImageView!
    
    @IBOutlet weak var attachmentName: UILabel!
    
    @IBOutlet weak var attachmentSize: UILabel!
    var attURLParameters = [String:AnyObject]()
    var attachmentDetails :AttachmentData?{
        didSet{
            attachmentImageView.image = UIImage(named: (attachmentDetails?.imageName)!, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            downloadIconImageView.image = UIImage(named: SearchKitConstants.ImageNameConstants.AttachmentDownloadImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)?.imageWithInsets(insets: UIEdgeInsetsMake(5, 5, 5, 5))
            attachmentName.text = attachmentDetails?.name
            attachmentSize.text = attachmentDetails?.size
            attURLParameters = (attachmentDetails?.attURLParameters)!
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
