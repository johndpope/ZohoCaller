//
//  WikiResultViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

class WikiResultViewCell: UITableViewCell {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var wikiName: UILabel!
    @IBOutlet weak var lastModifiedTime: UILabel!
    @IBOutlet weak var wikiAuthor: UILabel!
    
    // TODO: rename this item to wikiResult
    var searchResultItem: WikiResult? {
        didSet {
            guard let wikiResult = searchResultItem else {
                return
            }
            
            //set wiki name
            //wikiName?.text = item.wikiName
            
            //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                wikiName.text = wikiResult.wikiName
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(wikiResult.wikiName, into: wikiName)
                wikiName.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: wikiResult.wikiName, maxVisibleCharRange: maxVisibleCharRange)
            }
            
            //But this must not be done for all the cells. Rather it should be done once in awakeFromNib
            //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
            //wikiName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            wikiAuthor.text = wikiResult.authorDisplayName
            
            //set wiki last modified time
            lastModifiedTime.text = DateUtils.getDisaplayableDate(timestamp: wikiResult.lastModifiedTime)
            
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    //MARK: very important - all the settings of font, color and size must
    //happen only once. You must just set data values while rendering the cell.
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //set wiki image icon
        //one time operation for cell - as the icon is the same
        let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.WikiResultImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
        resultImageView.addSubview(imageView)
        
        if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
            if let wikiResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Wiki) {
                if let wikiNameField = wikiResultUIConfig.getFieldUIConfig(withIdentifier: "wikiName") {
                    wikiName.textColor = wikiNameField.fieldFontColor
                    wikiName.font = wikiName.font.withSize(CGFloat(wikiNameField.fieldFontSize))
                }
                
                if let wikiLMTimeField = wikiResultUIConfig.getFieldUIConfig(withIdentifier: "lastModTime") {
                    lastModifiedTime.textColor = wikiLMTimeField.fieldFontColor
                    lastModifiedTime.font = lastModifiedTime.font.withSize(CGFloat(wikiLMTimeField.fieldFontSize))
                }
                
                if let wikiAuthorField = wikiResultUIConfig.getFieldUIConfig(withIdentifier: "wikiAuthor") {
                    wikiAuthor.textColor = wikiAuthorField.fieldFontColor
                    wikiAuthor.font = wikiAuthor.font.withSize(CGFloat(wikiAuthorField.fieldFontSize))
                }
            }
        }
    }
    
    //so that image overlapping does not happen in case of cell reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        wikiName.text = nil
        wikiName.attributedText = nil
        wikiName.numberOfLines = 1
        
        wikiAuthor.numberOfLines = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
