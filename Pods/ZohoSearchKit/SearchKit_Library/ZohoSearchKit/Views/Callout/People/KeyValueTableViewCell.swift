//
//  KeyValueTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 24/04/18.
//

import UIKit

class KeyValueTableViewCell: UITableViewCell {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var dataValue: UILabel!
    
    var keyValue: DataLabelAndValue? {
        didSet {
            guard let _ = keyValue else {
                return
            }
            
            dataLabel.text = keyValue?.dataLabel
            dataValue.text = keyValue?.dataValue
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
        
        dataLabel.textColor = SearchKitConstants.ColorConstants.PeopleDataLabelColor
        dataValue.textColor = SearchKitConstants.ColorConstants.PeopleDataValueColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
