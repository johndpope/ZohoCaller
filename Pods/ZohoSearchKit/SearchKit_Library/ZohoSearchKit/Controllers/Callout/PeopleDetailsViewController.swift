//
//  PeopleDetailsViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 05/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

class PeopleDetailsViewController: AbstractCalloutViewController {
    
    @IBOutlet weak var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    let maxHeaderHeight: CGFloat = 220;
    let minHeaderHeight: CGFloat = 50;
    var previousScrollOffset: CGFloat = 0;
    
    @IBOutlet weak var peopleImageView: UIImageView!
    @IBOutlet weak var peopleNameLabel: UILabel!
    @IBOutlet weak var topNameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var openInAppButton: UIButton!
    
    var calloutData: PeopleCalloutData? {
        didSet {
            guard let _ = calloutData else {
                return
            }
        }
    }
    
    static func vcInstanceFromStoryboard() -> PeopleDetailsViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: PeopleDetailsViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? PeopleDetailsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(calloutData?.openInAppSupported)! {
            openInAppButton.isEnabled = false
            openInAppButton.isHidden = true
        }
        
        tableView?.delegate = self
        tableView?.dataSource = self
        tableView?.estimatedRowHeight = 150
        //for no unwanted lines
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        tableView?.register(PeopleCalloutCellWithAction.nib, forCellReuseIdentifier: PeopleCalloutCellWithAction.identifier)
        
        peopleNameLabel.numberOfLines = 2
        peopleNameLabel.text = calloutData?.title
        
        //setting empty top name title so that it does not appear in expanded case(first time)
        topNameLabel.text = ""
        
        //do we need to check if photo url is there or not
        
        if let imageURL = calloutData?.imageURL {
            
            //first load the no user image and show loading icon
            let image:UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: UIColor.white, insetPadding: 10, imageViewWidth: 120, imageViewHeight: 120) //UIImageView.createCircularImageViewWithBorderForCallout(image: image, bgColor: UIColor.white)
            //so that after failure of image loading also image will be circular
            imageView.maskCircle(anyImage: image)
            peopleImageView.addSubview(imageView)
            
            //animate the image loading icon
            var loadImages: [UIImage] = []
            loadImages = UIImage.createImageArray(total: 4, imagePrefix: SearchKitConstants.ImageNameConstants.LoadingImagePrefix)
            imageView.animate(images: loadImages)
            
            ZohoSearchKit.sharedInstance().getToken({ (token, error) in
                //ZSSOKit.getOAuth2Token({ (token, error) in
                if let oAuthToken = token {
                    let _ = ZOSSearchAPIClient.sharedInstance().getImageForURL(imageURL, oAuthToken: oAuthToken, completionHandlerForImage: { (image, error) in
                        if image == nil {
                            performUIUpdatesOnMain {
                                let defImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                                imageView.stopAnimate()
                                imageView.image = defImage
                                self.peopleImageView.maskCircle(anyImage: defImage)
                            }
                        }
                        else {
                            performUIUpdatesOnMain {
                                //stop the loading image animation
                                imageView.stopAnimate()
                                //set new downloaded image to the image view withing above created border
                                imageView.image = image
                                self.peopleImageView.maskCircle(anyImage: image!)
                            }
                        }
                    })
                }
            })
        }
        else if let imageName = calloutData?.imageName {
            let image = UIImage(named: imageName, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            let imageView = UIImageView.createCircularImageViewWithInset(image: image, bgColor: nil, insetPadding: 10, imageViewWidth: 120, imageViewHeight: 120) //UIImageView.createCircularImageViewWithBorderForCallout(image: image, bgColor: UIColor.white)
            imageView.maskCircle(anyImage: image)
            peopleImageView.addSubview(imageView)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.headerHeightConstraint.constant = self.maxHeaderHeight
        //self.nameTopConstraint.constant = -self.minHeaderHeight
    }
    
    @IBAction func didPressBackButton(_ sender: UIButton) {
        super.handleBackPress()
    }
    
    @IBAction func didPressOpenInApp(_ sender: UIButton) {
        if let calloutType = calloutData?.openInAppType {
            switch calloutType {
            case .People:
                ZohoAppsDeepLinkUtil.openInPeopleApp(emailID: (calloutData?.openInAppData["people_email"])!)
                break
            }
        }
    }
    
}

extension PeopleDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (calloutData?.keyValuePairs.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: PeopleCalloutCellWithAction.identifier, for: indexPath) as? PeopleCalloutCellWithAction {
            let rowData = calloutData?.keyValuePairs[indexPath.row]
            cell.rowData = rowData
            //so that line below the cell is now shown
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            
            return cell
        }
        
        return UIView() as! UITableViewCell
        
    }
}

//implementation of UIScrollViewDelegate which is already implemented by UITableViewDelegate
extension PeopleDetailsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //set the name text so that it appears to be animating from top to bottom
        //topNameLabel.text = calloutData?.title
        
        let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
        
        let absoluteTop: CGFloat = 0;
        let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
        
        let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
        let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
        
        if canAnimateHeader(scrollView) {
            
            // Calculate new header height
            var newHeight = self.headerHeightConstraint.constant
            if isScrollingDown {
                newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
            } else if isScrollingUp {
                newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
            }
            
            // Header needs to animate
            if newHeight != self.headerHeightConstraint.constant {
                self.headerHeightConstraint.constant = newHeight
                self.updateHeader()
                self.setScrollPosition(self.previousScrollOffset)
            }
            
            self.previousScrollOffset = scrollView.contentOffset.y
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewDidStopScrolling()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.scrollViewDidStopScrolling()
        }
    }
    
    func scrollViewDidStopScrolling() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let midPoint = self.minHeaderHeight + (range / 2)
        
        if self.headerHeightConstraint.constant > midPoint {
            self.expandHeader()
        } else {
            self.collapseHeader()
        }
    }
    
    func canAnimateHeader(_ scrollView: UIScrollView) -> Bool {
        // Calculate the size of the scrollView when header is collapsed
        let scrollViewMaxHeight = scrollView.frame.height + self.headerHeightConstraint.constant - minHeaderHeight
        
        // Make sure that when header is collapsed, there is still room to scroll
        return scrollView.contentSize.height > scrollViewMaxHeight
    }
    
    func collapseHeader() {
        topNameLabel.text = calloutData?.title
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.minHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func expandHeader() {
        
        self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.2, animations: {
            self.headerHeightConstraint.constant = self.maxHeaderHeight
            self.updateHeader()
            self.view.layoutIfNeeded()
        })
    }
    
    func setScrollPosition(_ position: CGFloat) {
        self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
    }
    
    func updateHeader() {
        let range = self.maxHeaderHeight - self.minHeaderHeight
        let openAmount = self.headerHeightConstraint.constant - self.minHeaderHeight
        let percentage = openAmount / range
        
        self.nameTopConstraint.constant = -openAmount + 10
        
        self.peopleImageView.alpha = percentage
        self.peopleNameLabel.alpha = percentage
    }
}
