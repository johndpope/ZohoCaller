//
//  PeopleCalloutCellWithAction.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 06/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

class PeopleCalloutCellWithAction: UITableViewCell {
    
    @IBOutlet weak var fieldLabel: UILabel!
    @IBOutlet weak var fieldDataLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var labelGap: NSLayoutConstraint!
    
    var rowData: RowData? {
        didSet {
            guard let row = rowData else {
                return
            }
            
            fieldLabel.text = row.rowLabelText
            fieldDataLabel.text = row.rowDataText
            
            switch row.dataType {
            case .Email:
                //need to renable the button as it is reusable cell
                actionButton.isEnabled = true
                actionButton.isHidden = false
                //button icon as Email
                if let image = UIImage(named: SearchKitConstants.ImageNameConstants.SendMailImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil) {
                    self.actionButton.setImage(image, for: .normal)
                }
            case .PhoneNumber:
                actionButton.isEnabled = true
                actionButton.isHidden = false
                //button icon for call using the CRM one right now
                if let image = UIImage(named: SearchKitConstants.ImageNameConstants.MakeCallImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil) {
                    actionButton.setImage(image, for: .normal)
                }
            case .RawData:
                //disable the button and also the icon
                actionButton.isEnabled = false
                actionButton.isHidden = true
            }
            
        }
    }
    
    @IBAction func actionButtonPressed(_ sender: UIButton) {
        if (rowData?.dataType == RowDataType.PhoneNumber) {
            let phoneNum = rowData?.rowDataText.replacingOccurrences(of: " ", with: "")
            IntentActionHandler.makePhoneCall(phoneNumber: phoneNum!)
        }
        else if (rowData?.dataType == RowDataType.Email) {
            IntentActionHandler.sendNewMail(emailID: (rowData?.rowDataText ?? ""))
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
        // Initialization code
        
        //to avoid multiline label padding issue
        //fieldDataLabel.lineBreakMode = .byWordWrapping
        //fieldDataLabel.numberOfLines = 0
        //labelGap.constant = 8
        
        //fieldDataLabel.preferredMaxLayoutWidth = fieldDataLabel.frame.width
        //label2.maxPreferredLayoutWidth = label2.frame.width
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //if need to clear any cached data in cell
    }
    
    //to test multiline label padding issue
    /*
     override func layoutSubviews() {
     super.layoutSubviews()
     contentView.layoutIfNeeded()
     
     //for label: UILabel in  {
     //if let label = fieldDataLabel {
     //fieldDataLabel?.preferredMaxLayoutWidth = (fieldDataLabel?.frame.width)!
     //fieldDataLabel.preferredMaxLayoutWidth = fieldDataLabel.bounds.size.width;
     //}
     //}
     }
     */
    
}
