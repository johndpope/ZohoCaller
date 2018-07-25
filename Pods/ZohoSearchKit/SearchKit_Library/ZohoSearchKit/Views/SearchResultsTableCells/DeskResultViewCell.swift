//
//  DeskResultViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

class DeskResultViewCell: UITableViewCell {
    
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var deskTitle: UILabel!
    @IBOutlet weak var creationTime: UILabel!
    @IBOutlet weak var subtitleOne: UILabel!
    @IBOutlet weak var subtitleTwo: UILabel!
    
    var searchResultItem: SupportResult? {
        didSet {
            guard let supportResult = searchResultItem else {
                return
            }
            
            //set Desk title
            //deskTitle?.text = item.title
            //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                deskTitle.text = supportResult.title!
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(supportResult.title!, into: deskTitle)
                deskTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: supportResult.title!, maxVisibleCharRange: maxVisibleCharRange)
            }
            
            //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
            //deskTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            
            subtitleOne.text = supportResult.subtitle1
            subtitleTwo.text = supportResult.subtitle2
            creationTime.text = DateUtils.getDisaplayableDate(timestamp: supportResult.createdTime)
            
            let image:UIImage = ResultIconUtils.getIconForDeskResult(deskResult: supportResult)
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
            resultImageView.addSubview(imageView)
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
        
        if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
            if let deskResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Desk) {
                if let deskTitleField = deskResultUIConfig.getFieldUIConfig(withIdentifier: "deskTitle") {
                    deskTitle.textColor = deskTitleField.fieldFontColor
                    deskTitle.font = deskTitle.font.withSize(CGFloat(deskTitleField.fieldFontSize))
                }
                
                if let creationTimeField = deskResultUIConfig.getFieldUIConfig(withIdentifier: "creationTime") {
                    creationTime.textColor = creationTimeField.fieldFontColor
                    creationTime.font = creationTime.font.withSize(CGFloat(creationTimeField.fieldFontSize))
                }
                
                if let subtitleOneField = deskResultUIConfig.getFieldUIConfig(withIdentifier: "subtitleOne") {
                    subtitleOne.textColor = subtitleOneField.fieldFontColor
                    subtitleOne.font = subtitleOne.font.withSize(CGFloat(subtitleOneField.fieldFontSize))
                }
                
                if let subtitleTwoField = deskResultUIConfig.getFieldUIConfig(withIdentifier: "subtitleTwo") {
                    subtitleTwo.textColor = subtitleTwoField.fieldFontColor
                    subtitleTwo.font = subtitleTwo.font.withSize(CGFloat(subtitleTwoField.fieldFontSize))
                }
            }
        }
    }
    
    //so that image overlapping does not happen in case of cell reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        resultImageView.image = nil
        let extSubviews = resultImageView.subviews
        for subView in extSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
        
        deskTitle.text = nil
        deskTitle.attributedText = nil
        deskTitle.numberOfLines = 1
        
        subtitleOne.numberOfLines = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

