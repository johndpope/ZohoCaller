//
//  StickyServiceHeaderCellIOS9.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 10/04/18.
//

import UIKit

class StickyServiceHeaderCellIOS9: UITableViewCell {

    @IBOutlet weak var accountDisplayName: UILabel!
    
    var item: ServiceResultViewModel? {
        didSet {
            guard let item = item else {
                return
            }
            
            if item.searchResultsMetaData != nil {
                //TODO: These messages has to be updated as per design
                if item.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail {
                    accountDisplayName.text = "Mail Account - " + (item.searchResultsMetaData?.accountID)!
                }
                else if item.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Desk {
                    accountDisplayName.text = "Portal - " + (item.searchResultsMetaData?.accountDisplayName)!
                }
                else if item.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Connect {
                    accountDisplayName.text = "Network - " + (item.searchResultsMetaData?.accountDisplayName)!
                }
                else if item.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Wiki {
                    accountDisplayName.text = "Wiki - " + (item.searchResultsMetaData?.accountDisplayName)!
                }
            }
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
        self.contentView.backgroundColor = SearchKitConstants.ColorConstants.AllService_SectionsSeparatorView_BackGround_Color
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
