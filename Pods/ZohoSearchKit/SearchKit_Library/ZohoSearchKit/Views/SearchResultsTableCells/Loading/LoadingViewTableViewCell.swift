//
//  LoadingViewTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 13/03/18.
//

import UIKit

class LoadingViewTableViewCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
