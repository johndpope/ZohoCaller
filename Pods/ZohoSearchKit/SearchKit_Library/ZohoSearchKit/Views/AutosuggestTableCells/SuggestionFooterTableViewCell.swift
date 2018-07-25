//
//  SuggestionFooterTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 20/03/18.
//

import UIKit

protocol SuggestionViewMoreDelegate: class {
    func viewMoreTapped(header: SuggestionFooterTableViewCell)
}

class SuggestionFooterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var viewMoreButton: UIButton!
    
    var sectionType: SuggestionSectionTypes? {
        didSet {
            guard let _ = sectionType else {
                return
            }
            
            //any changes
        }
    }
    
    weak var delegate: SuggestionViewMoreDelegate?
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //this will increase the button click are, otherwise user will to click exactly on the button text which is bad for the user experience
        viewMoreButton.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        let butttonTitle = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.results.viewmore", defaultValue: "View more")
        viewMoreButton.setTitle(butttonTitle, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didPressViewMore(_ sender: UIButton) {
        delegate?.viewMoreTapped(header: self)
    }
}

enum SuggestionSectionTypes {
    case Contacts
    case RecentSearches
    case SavedSearches
}
