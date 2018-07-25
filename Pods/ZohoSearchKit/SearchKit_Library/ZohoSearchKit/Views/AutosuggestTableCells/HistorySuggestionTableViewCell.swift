//
//  HistorySuggestionTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 16/02/18.
//

import UIKit
import QuartzCore

protocol HistorySuggestionViewCellDelegate : class {
    func didTapAppendHistory(_ sender: HistorySuggestionTableViewCell)
}

class HistorySuggestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var searchQueryLabel: UILabel!
    @IBOutlet weak var appendButton: UIButton!
    @IBOutlet weak var mentionedUserSV: UIStackView!
    //so that we can set some max length for the label
    @IBOutlet weak var mentionUserSVWidth: NSLayoutConstraint!
    @IBOutlet weak var dummyLabel: UILabel!
    
    weak var delegate: HistorySuggestionViewCellDelegate?
    
    //MARK: very very important. Don't add as subviews for every cell, if the same image is used for all cells.
    //In case of History suggestion history icon is the same, then why add in all the rows in the table's section
    //because this will set for every table view cell, this will be set. So, please be very careful.
    var history: SearchHistory? {
        didSet {
            guard history != nil else {
                return
            }
            
            let searchQueryText = SearchResultsViewModel.QueryVC.suggestionPageSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
            if searchQueryText.isEmpty {
                //added in prepareForReuse
                searchQueryLabel.attributedText = nil
                searchQueryLabel.text = (history?.value(forKey: "search_query"))! as? String//history?.search_query
                //when we use Distinct in the query and we have Dictionary as return type. we can't use object
                //properties to fetch the value of the property. Use value for key
            }
            else {
                let maxVisibleCharRange = ResultHighlighter.fit((history?.value(forKey: "search_query"))! as! String, into: searchQueryLabel)
                searchQueryLabel.attributedText = ResultHighlighter.genAutosuggestHighlightedString(with: searchQueryText, targetString: (history?.value(forKey: "search_query"))! as! String, font: searchQueryLabel.font, maxVisibleCharRange: maxVisibleCharRange)
            }
            
            //mentioned user
            let mentionedZUID = (history?.value(forKey: "mention_zuid"))! as? Int64
            if mentionedZUID != -1 {
                mentionedUserSV.isHidden = false
                mentionUserSVWidth.constant = self.frame.width / 2
                userName.text = ((history?.value(forKey: "mention_contact_name")) as? String) ?? ""
                //so that some padding is added in the right side, without breaking the autokayout
                dummyLabel.text = "  "
                
                //set the name label of the mentiond user from the history object
                
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 0, imageViewWidth: 30, imageViewHeight: 30) //UIImageView.createCircularImageViewWithBorder(image: image, bgColor: UIColor.white)
                //so that after failure of image loading also image will be circular
                imageView.maskCircle(anyImage: image)
                
                userImageView.addSubview(imageView)
                
                //animate the image loading icon
                var loadImages: [UIImage] = []
                loadImages = UIImage.createImageArray(total: 4, imagePrefix: SearchKitConstants.ImageNameConstants.LoadingImagePrefix)
                imageView.animate(images: loadImages)
                
                ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                    //ZSSOKit.getOAuth2Token({ (token, error) in
                    if let oAuthToken = token {
                        let _ = ZOSSearchAPIClient.sharedInstance().getContactImage(mentionedZUID!, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                            if image == nil {
                                performUIUpdatesOnMain {
                                    let defImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                                    imageView.stopAnimate()
                                    imageView.image = defImage
                                    self.userImageView.maskCircle(anyImage: defImage)
                                }
                            }
                            else {
                                performUIUpdatesOnMain {
                                    //stop the loading image animation
                                    imageView.stopAnimate()
                                    //set new downloaded image to the image view withing above created border
                                    imageView.image = image
                                    self.userImageView.maskCircle(anyImage: image!)
                                }
                            }
                        })
                    }
                })
            }
        }
    }
    
    //stackview container background color
    private func pinBackground(_ view: UIView, to stackView: UIStackView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.insertSubview(view, at: 0)
        view.pin(to: stackView)
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
        
        //MARK: very very important. Don't add as subviews for every cell, if the same image is used for all cells.
        //In case of History suggestion history icon is the same, then why add in all the rows in the table's section
        let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.SearchHistoryImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 40, imageViewHeight: 40)
          imageView.changeTintColor(ThemeService.sharedInstance().theme.navigationBarBackGroundColor)
        historyImageView.addSubview(imageView)
        
        //chnage the background of the container stack view
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        view.layer.cornerRadius = 15
        pinBackground(view, to: mentionedUserSV)
    }
    
    override func prepareForReuse() {
        mentionedUserSV.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func didPressAppend(_ sender: UIButton) {
        delegate?.didTapAppendHistory(self)
    }
    
}
