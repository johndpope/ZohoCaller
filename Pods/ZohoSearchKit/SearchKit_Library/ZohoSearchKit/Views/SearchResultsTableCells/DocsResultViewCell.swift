//
//  DocsResultViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

class DocsResultViewCell: UITableViewCell {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var docName: UILabel!
    @IBOutlet weak var lastModifiedTime: UILabel!
    @IBOutlet weak var docAuthor: UILabel!
    
    var searchResultItem: DocsResult? {
        didSet {
            guard let docsResult = searchResultItem else {
                return
            }
            
            //set doc title
            //docName?.text = item.docName
            //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
            //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
            if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                docName.text = docsResult.docName
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit(docsResult.docName, into: docName)
                docName.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: docsResult.docName, maxVisibleCharRange: maxVisibleCharRange)
            }
            
            //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
            //docName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            
            docAuthor.text = docsResult.docAuthor
            
            //set document last modified time
            lastModifiedTime.text = DateUtils.getDisaplayableDate(timestamp: docsResult.lastModifiedTime)
            
            let image:UIImage = ResultIconUtils.getIconForDocsResult(docResult: docsResult)
            let imageView =  UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
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
            if let docsResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Documents) {
                if let docNameField = docsResultUIConfig.getFieldUIConfig(withIdentifier: "docName") {
                    docName.textColor = docNameField.fieldFontColor
                    docName.font = docName.font.withSize(CGFloat(docNameField.fieldFontSize))
                }
                
                if let lmTimeField = docsResultUIConfig.getFieldUIConfig(withIdentifier: "lmTime") {
                    lastModifiedTime.textColor = lmTimeField.fieldFontColor
                    lastModifiedTime.font = lastModifiedTime.font.withSize(CGFloat(lmTimeField.fieldFontSize))
                }
                
                if let docAuthorField = docsResultUIConfig.getFieldUIConfig(withIdentifier: "docAuthor") {
                    docAuthor.textColor = docAuthorField.fieldFontColor
                    docAuthor.font = docAuthor.font.withSize(CGFloat(docAuthorField.fieldFontSize))
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
        
        docName.attributedText = nil
        docName.numberOfLines = 1
        docName.text = nil
        
        docAuthor.numberOfLines = 1
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
