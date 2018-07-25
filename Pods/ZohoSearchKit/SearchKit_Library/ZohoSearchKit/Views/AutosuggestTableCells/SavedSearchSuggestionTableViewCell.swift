//
//  SavedSearchSuggestionTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 28/02/18.
//

import UIKit

class SavedSearchSuggestionTableViewCell: UITableViewCell {

    @IBOutlet weak var savedSearchImageView: UIImageView!
    @IBOutlet weak var savedSearchNameLabel: UILabel!
    
    var savedSearch: SavedSearches? {
        didSet {
            guard savedSearch != nil else {
                return
            }
            
            let searchQueryText = SearchResultsViewModel.QueryVC.suggestionPageSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if searchQueryText.isEmpty {
                savedSearchNameLabel.attributedText = nil
                savedSearchNameLabel.text = savedSearch?.saved_search_name
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit((savedSearch?.saved_search_name)!, into: savedSearchNameLabel)
                savedSearchNameLabel.attributedText = ResultHighlighter.genAutosuggestHighlightedString(with: searchQueryText, targetString: (savedSearch?.saved_search_name)!, font: savedSearchNameLabel.font, maxVisibleCharRange: maxVisibleCharRange)
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
        // Initialization code
        
        //same image for all the cells, so must be added only once as the subview
        let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.SavedSearchImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 40, imageViewHeight: 40)
        imageView.changeTintColor(ThemeService.sharedInstance().theme.navigationBarBackGroundColor)
        savedSearchImageView.addSubview(imageView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
