//
//  HistoryItemTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 26/02/18.
//

import UIKit

protocol HistoryListViewCellDelegate : class {
    func didTapDeleteHistoryItem(_ sender: HistoryItemTableViewCell)
}

class HistoryItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var historyImageView: UIImageView!
    @IBOutlet weak var searchQuery: UILabel!
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var mentionUserSV: UIStackView!
    @IBOutlet weak var mentionUserSVWidth: NSLayoutConstraint!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var dummyLabel: UILabel!
    
    weak var delegate: HistoryListViewCellDelegate?
    
    var history: SearchHistory? {
        didSet {
            guard history != nil else {
                return
            }
            
            searchQuery.text = history?.search_query
            //when we need to convert Int64 to Int value we use code as follows
            //time.text = DateUtils.getDisaplayableDate(timestamp: Int(truncatingIfNeeded: (history?.timestamp)!))
            time.text = DateUtils.getDisaplayableDate(timestamp: (history?.timestamp)!)
            
            //mentioned user
            let mentionedZUID = (history?.value(forKey: "mention_zuid"))! as? Int64
            if mentionedZUID != -1 {
                mentionUserSV.isHidden = false
                mentionUserSVWidth.constant = self.frame.width / 2
                userName.text = ((history?.value(forKey: "mention_contact_name")) as? String) ?? ""
                //so that some padding is added in the right side, without breaking the autolayout
                dummyLabel.text = "  "
                
                //set the name label of the mentiond user from the history object
                
                let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 0, imageViewWidth: 30, imageViewHeight: 30)
                imageView.maskCircle(anyImage: image)
                userImageView.addSubview(imageView)
                
                //animate the image loading icon
                var loadImages: [UIImage] = []
                loadImages = UIImage.createImageArray(total: 4, imagePrefix: SearchKitConstants.ImageNameConstants.LoadingImagePrefix)
                imageView.animate(images: loadImages)
                
                ZohoSearchKit.sharedInstance().getToken({ (token, error) in
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if let image = UIImage(named: SearchKitConstants.ImageNameConstants.SearchHistoryImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil) {
            let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 50, imageViewHeight: 50)
            imageView.changeTintColor(ThemeService.sharedInstance().theme.navigationBarBackGroundColor)
            historyImageView.addSubview(imageView)
        }
        
        //chnage the background of the container stack view
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        view.layer.cornerRadius = 15
        pinBackground(view, to: mentionUserSV)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //no need to clear the history image as same image view is there
        
        mentionUserSV.isHidden = true
        
        userImageView.image = nil
        let extSubviews = userImageView.subviews
        for subView in extSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    @IBAction func didPressDelete(_ sender: UIButton) {
        delegate?.didTapDeleteHistoryItem(self)
    }
}
