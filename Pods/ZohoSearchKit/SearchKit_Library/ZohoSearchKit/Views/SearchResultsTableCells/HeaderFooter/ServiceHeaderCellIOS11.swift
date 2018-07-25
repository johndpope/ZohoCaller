//
//  ServiceHeaderCellIOS11.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 02/04/18.
//

import UIKit

class ServiceHeaderCellIOS11: UITableViewHeaderFooterView {

    @IBOutlet weak var sectionSeparatorView: UIView!
    @IBOutlet weak var serviceDisplayName: UILabel!
    @IBOutlet weak var accountDisplayName: UILabel!
    weak var delegate: HeaderViewDelegate?
    var serviceName: String = ZOSSearchAPIClient.ServiceNameConstants.All
    
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
    }
    @IBAction func didTapViewAll(_ sender: UIButton) {
        delegate?.toggleSection(header: self, serviceName: serviceName)
    }
    
    
}
