//
//  ServiceHeaderCellIOS9.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 01/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

protocol HeaderViewDelegate: class {
    //MARK: Using generic UIView instead of using ServiceHeaderCellIOS9 as we are using the same delegate for ServiceHeaderCellIOS9 and ServiceHeaderCellIOS11
    func toggleSection(header: UIView, serviceName: String)
}

//MARK: Important - Don't use UITableViewHeaderFooterView to subclass the header view class.
//it creates issue with width in iOS 9 and 10. So, we are using general UITableViewCell as a header view
class ServiceHeaderCellIOS9: UITableViewCell {
    
    var item: ServiceResultViewModel? {
        didSet {
            guard let item = item else {
                return
            }
            
            serviceDisplayName?.text = item.sectionTitle
            if item.searchResultsMetaData != nil {
                if item.serviceName == ZOSSearchAPIClient.ServiceNameConstants.Mail {
                    //serviceDisplayName?.text = item.sectionTitle + "- " + (item.searchResultsMetaData?.accountID)!
                    accountDisplayName.text = " - " + (item.searchResultsMetaData?.accountID)!
                }
                else {
                    //serviceDisplayName?.text = item.sectionTitle + " - " + (item.searchResultsMetaData?.accountDisplayName)!
                    accountDisplayName.text = " - " + (item.searchResultsMetaData?.accountDisplayName)!
                }
            }
            else {
                accountDisplayName?.text = ""
            }
            serviceName = item.serviceName
        }
    }
    
    @IBOutlet weak var serviceDisplayName: UILabel!
    @IBOutlet weak var accountDisplayName: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var sectionSeparatorView: UIView!
    
    var serviceName: String = ZOSSearchAPIClient.ServiceNameConstants.All
    
    weak var delegate: HeaderViewDelegate?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        sectionSeparatorView.backgroundColor = SearchKitConstants.ColorConstants.AllService_SectionsSeparatorView_BackGround_Color
        sectionSeparatorView.layer.zPosition = CGFloat.Magnitude.leastNormalMagnitude
        //this will increase the button click are, otherwise user will to click exactly on the button text which is bad for the user experience
        viewAllButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        let butttonTitle = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.results.viewall", defaultValue: "View All")
        viewAllButton.setTitle(butttonTitle, for: .normal)
    }
    
    @IBAction func didTapViewAll(_ sender: UIButton) {
        delegate?.toggleSection(header: self, serviceName: serviceName)
    }
    
}
