//
//  SearchResultsErrorMessage.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 05/07/18.
//

import Foundation
enum SearchResultErrorType {
    case noResults
    case noInterNet
    case unKnown
}
class SearchResultsErrorMessage : NibView{
    
    @IBOutlet weak var errorMessageView: UIImageView!
    
    @IBOutlet weak var errorMessageSubject: UILabel!
    
    @IBOutlet weak var retryButton: UIButton!
    func  awakefromNib(){
        super.awakeFromNib()
    }
    init(frame : CGRect,errorType : SearchResultErrorType) {
        super.init(frame : frame)
        configure(errorType: errorType)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func configure(errorType : SearchResultErrorType) {
        errorMessageSubject.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        switch errorType {
        case .noResults:
            errorMessageView.image = UIImage(named: "searchsdk-no-results", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            errorMessageSubject.text = "No results found. Try a different keyword"
            retryButton.isHidden = true
        case .noInterNet:
            errorMessageView.image = UIImage(named: "searchsdk-no-internet", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            errorMessageSubject.text = "You are not connected to the internet"
            retryButton.isHidden = false
        case .unKnown:
            errorMessageView.image = UIImage(named: "searchsdk-unknown-error", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
            errorMessageSubject.text = "Something went wrong"
            retryButton.isHidden = false
        }
    }
}
