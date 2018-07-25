//
//  CRMResultViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

//has to include some more details in the result cell as with the new build those will be available
//also as per the web ui - Deals should be rendered as Potentials
class CRMResultViewCell: UITableViewCell {
    @IBOutlet weak var resultImageView: UIImageView!
    @IBOutlet weak var resultTitle: UILabel!
    @IBOutlet weak var resultSubtitle: UILabel!
    @IBOutlet weak var moduleNameLabel: UILabel!
    @IBOutlet weak var textIconForModule: UILabel!
    
    var searchResultItem: CRMResult? {
        didSet {
            guard let crmResult = searchResultItem else {
                return
            }
            moduleNameLabel.text = crmResult.moduleName
            
            //find title and subtitle and then set
            var title = ""
            var subtitle = ""
            (title , subtitle) = crmResult.getCrmTitleAndSubTitle()
            //set crm result title
            //resultTitle?.text = item.company
            
            if title.isEmpty == false {
                //let searchQueryText = SearchResultsViewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
                //either search query text is empty or if it has been disabled then simply text will be set w/t highlighting
                if SearchResultsViewModel.ResultVC.trimmedSearchQuery.isEmpty || !ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
                    resultTitle.text = title
                }
                else {
                    let maxVisibleCharRange = ResultHighlighter.fit(title, into: resultTitle)
                    resultTitle.attributedText = ResultHighlighter.genSearchResultHighlightedString(with: SearchResultsViewModel.ResultVC.trimmedSearchQuery, targetString: title, maxVisibleCharRange: maxVisibleCharRange)
                }
            }
            else {
                resultTitle.text = ""
            }
            
            
            //setting font is needed as expand will not function as expected if font is not set. For first time expand is pressed.
            //resultTitle.font = UIFont.systemFont(ofSize: 18, weight: .regular)
            
            resultSubtitle.text = subtitle
            
            //set module specific icon
            let image:UIImage? = ResultIconUtils.getIconForCRMResult(crmResult: crmResult)
            if let image = image {
                resultImageView.isHidden =  false
                textIconForModule.isHidden = true
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 60, imageViewHeight: 60) //UIImageView.createCircularImageViewWithBorder(image: image)
                resultImageView.addSubview(imageView)
            }
            else {
                resultImageView.isHidden =  true
                textIconForModule.isHidden = false
                textIconForModule.text = SearchKitUtil.generateIconText(inputStr: crmResult.moduleName)
                textIconForModule.createCircularView()
                
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
        
        if let searchResultUIConfig = ZohoSearchKit.sharedInstance().searchKitConfig?.searchResultUIConfig {
            if let crmResultUIConfig = searchResultUIConfig.getServiceUIConfig(forServiceName: ZOSSearchAPIClient.ServiceNameConstants.Crm) {
                if let crmTitleField = crmResultUIConfig.getFieldUIConfig(withIdentifier: "crmTitle") {
                    resultTitle.textColor = crmTitleField.fieldFontColor
                    resultTitle.font = resultTitle.font.withSize(CGFloat(crmTitleField.fieldFontSize))
                }
                
                if let subtitleOneField = crmResultUIConfig.getFieldUIConfig(withIdentifier: "subtitleOne") {
                    resultSubtitle.textColor = subtitleOneField.fieldFontColor
                    resultSubtitle.font = resultSubtitle.font.withSize(CGFloat(subtitleOneField.fieldFontSize))
                }
                
                if let textIconField = crmResultUIConfig.getFieldUIConfig(withIdentifier: "iconText") {
                    textIconForModule.textColor = textIconField.fieldFontColor
                    textIconForModule.font = textIconForModule.font.withSize(CGFloat(textIconField.fieldFontSize))
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
        
        textIconForModule.isHidden = true
        textIconForModule.text = nil
        
        resultTitle.text = nil
        resultTitle.attributedText = nil
        resultTitle.numberOfLines = 1
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
