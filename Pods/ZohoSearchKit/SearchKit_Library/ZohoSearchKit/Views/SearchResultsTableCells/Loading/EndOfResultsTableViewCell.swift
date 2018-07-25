//
//  EndOfResultsTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 21/03/18.
//

import UIKit

class EndOfResultsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var endOfResultLabel: UILabel!
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //to avoid separator line in last cell.
        self.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 0);
        endOfResultLabel.text = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.results.endofresults", defaultValue: "--- End of Search Results ---")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
