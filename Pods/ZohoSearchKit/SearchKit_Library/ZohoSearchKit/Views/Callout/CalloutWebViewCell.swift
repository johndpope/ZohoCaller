//
//  CalloutWebViewCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 07/05/18.
//

import UIKit

class CalloutWebViewCell: UITableViewCell {

    @IBOutlet weak var CalloutWebView: UIWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
