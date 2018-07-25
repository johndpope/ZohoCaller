//
//  CustomTextField.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 08/02/18.
//

import UIKit

class QueryVCSearchBar: UITextField {
    
    private var originalRect = CGRect.zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        originalRect = super.clearButtonRect(forBounds: bounds)
    
        self.leftViewMode = .always
        self.rightViewMode = .always
        changeServiceImge()

        if text != ""
        {
            currentRightViewMode = .clearButton
            addClearButton()
        }
        else
        {
            currentRightViewMode = .voiceSearch
            addVoiceSearchButton()
        }
    }
    enum RightViewType {
        case clearButton
        case voiceSearch
    }
    private var currentRightViewMode : RightViewType = .voiceSearch
    
    func addClearButton()
    {
        let clearButtonView = UIView()
        clearButtonView.frame = CGRect(x: 0 , y: 10, width: self.frame.height-20 , height:self.frame.height-20)
        
        let img:UIImage = UIImage(named: "searchsdk-close" , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        
        let imageView = UIImageView(image: img.imageWithInsets(insets: UIEdgeInsetsMake(5, 5, 5, 5)))
        imageView.frame = CGRect(x: 0, y: 3, width:clearButtonView.frame.width - 5 , height: clearButtonView.frame.height-5)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true;
        imageView.backgroundColor =  SearchKitConstants.ColorConstants.Clear_Button_BGColor
        imageView.layer.masksToBounds = false
        clearButtonView.addSubview(imageView)
        let guestures = UITapGestureRecognizer(target: self, action: #selector(self.isclearButtonTapped))
        clearButtonView.addGestureRecognizer(guestures)
        self.rightView = clearButtonView
         currentRightViewMode = .clearButton
    }
    func addVoiceSearchButton()
    {
        let clearButtonView = UIView()
        clearButtonView.frame = CGRect(x: 0 , y: 10, width: self.frame.height-20 , height:self.frame.height-20)
        
        let img:UIImage = UIImage(named: "searchsdk-mic" , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        
        let imageView = UIImageView(image: img.imageWithInsets(insets: UIEdgeInsetsMake(0, 0, 0, 0)))
        imageView.frame = CGRect(x: 0, y: 3, width:clearButtonView.frame.width - 5 , height: clearButtonView.frame.height-5)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true;
        imageView.backgroundColor =  .clear
        imageView.layer.masksToBounds = false
        clearButtonView.addSubview(imageView)
        let guestures = UITapGestureRecognizer(target: self, action: #selector(self.didVoiceSearchTapped))
        clearButtonView.addGestureRecognizer(guestures)
        self.rightView = clearButtonView
         currentRightViewMode = .voiceSearch
    }
    @objc func  didVoiceSearchTapped()
    {
        self.resignFirstResponder()
        let parentVC = self.getParentViewController()
        if #available(iOS 10.0, *) {
            let voiceSearchVC = ZOSVoiceSearchVC.vcInstanceFromStoryboard()
            let voiceVC_Y = UIScreen.main.bounds.height / 2 + 50
            let voiceVC_height = (UIScreen.main.bounds.height - UIScreen.main.bounds.height / 2 + 50)
            voiceSearchVC?.view.frame = CGRect(x: 0, y: voiceVC_Y , width: UIScreen.main.bounds.width, height: voiceVC_height)
            parentVC?.add(childViewController: voiceSearchVC!)
        } else {
            // Fallback on earlier versions
        }
    }
    public  func textDidChanged(newText  :String) {
        if newText != ""
        {
            if currentRightViewMode != .clearButton
            {
                    addClearButton()
            }
        }
        else
        {
            if currentRightViewMode != .voiceSearch
            {
                addVoiceSearchButton()
            }
        }
    }

    @objc func isclearButtonTapped()
    {
        addVoiceSearchButton()
        self.text = ""
        SearchResultsViewModel.QueryVC.suggestionPageSearchText = ""
        CloseNameLable()
        let ViewController = self.getParentViewController() as! SearchQueryViewController
        
        ViewController.searchContacts(searchString: SearchResultsViewModel.QueryVC.suggestionPageSearchText )
        ViewController.searchHistory(searchString: SearchResultsViewModel.QueryVC.suggestionPageSearchText )
        ViewController.searchSavedSearches(searchString:SearchResultsViewModel.QueryVC.suggestionPageSearchText )
    }
    @objc func serviceTapped()
    {
        let ViewController = self.getParentViewController() as! SearchQueryViewController
        SearchResultsViewModel.QueryVC.isSuggestionServiceIconTapped = true
        ViewController.suggestionTableView.reloadData()
        
        //Added to scroll to the selected service, as there was extra space if the service happends to be at the end.
        let cell = ViewController.suggestionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? ServiceSuggestionCell
        cell?.collectionView.scrollToItem(at: IndexPath(row :SearchResultsViewModel.selected_service ,section : 0), at: .init(rawValue: 0), animated: true)
        //scroll postion - .init(rawValue: 0) has been used so that selected service will be in center, I mean if is some padding it will be visible.Otherwise it cell padding
        //might not be visible
        cell?.collectionView.selectItem(at: IndexPath(row :SearchResultsViewModel.selected_service ,section : 0), animated: false, scrollPosition: .init(rawValue: 0))
    }
    func changeServiceImge()
    {
        // updating placeholder
        let currentServiceName = SearchResultsViewModel.UserPrefOrder[SearchResultsViewModel.selected_service].itemInfo.serviceName!
        if currentServiceName == ZOSSearchAPIClient.ServiceNameConstants.All
        {
            self.placeholder = "Search across Zoho"
        }
        else
        {
            self.placeholder = "Search..."
        }
        //service icon view
        let service_view = UIView(frame :CGRect(x: 0 , y: 10,width : self.frame.height-20 , height: self.frame.height-20))
        
        let img:UIImage =  ServiceIconUtils.getServiceSelectedStateIcon(serviceName: SearchResultsViewModel.UserPrefOrder[SearchResultsViewModel.selected_service].itemInfo.serviceName!)!
        let imageView = UIImageView.createCircularImageViewWithInsetForGradient(image: img, insetPadding: 5, imageViewWidth: self.frame.height-20, imageViewHeight: self.frame.height-20)
        
        //Setting gradient, will later export this code outside
        let colorTop =  SearchKitConstants.ColorConstants.SelectedServiceGradientTopColor.cgColor
        let colorBottom = SearchKitConstants.ColorConstants.SelectedServiceGradientBottomColor.cgColor
        
        let view = UIView(frame: imageView.frame)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = imageView.bounds
        gradientLayer.cornerRadius = (imageView.frame.width/2)
        view.layer.insertSublayer(gradientLayer, at: 0)
        service_view.addSubview(view)
        //setting gradient ends
        
        service_view.addSubview(imageView)
        
        let guestures = UITapGestureRecognizer(target: self, action: #selector(self.serviceTapped))
        service_view.addGestureRecognizer(guestures)
        
        //user icon if @mention selected
        //border less service image in the search bar
        let cimg : UIImage = UIImage(named: SearchKitConstants.ImageNameConstants.NoUserImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        let contact_view = UIView(frame: CGRect(x:self.frame.height-10 , y: 10, width: self.frame.height-20 , height: self.frame.height-20))
        let imageV = UIImageView(image: cimg.imageWithInsets(insets: UIEdgeInsetsMake( 5, 5, 5, 0)))
        imageV.frame = CGRect(x: 0, y: 0, width: contact_view.frame.width, height: contact_view.frame.height)
        
        imageV.maskCircle(anyImage: cimg)

        contact_view.addSubview(imageV)
        contact_view.layer.zPosition = ZpositionLevel.high.rawValue
        let guesture = UITapGestureRecognizer(target: self, action: #selector(self.contactTouched))
        contact_view.addGestureRecognizer(guesture)
        
        ZohoSearchKit.sharedInstance().getImagefor(zuid: SearchResultsViewModel.QueryVC.suggestionZUID!, completionHandler: { (img,error)  in
            if let contactImage =  img
            {
                performUIUpdatesOnMain {
                    imageV.image = contactImage
                }
            }
        })
        let customLeftView = UIView(frame: CGRect(x: 0, y: 0, width:self.frame.height + contact_view.frame.width - 10 , height: self.frame.height))
        
        customLeftView.addSubview(service_view)
        customLeftView.addSubview(contact_view)
        
        //        if SearchResultsViewModel.isContactSearch == false
        if SearchResultsViewModel.QueryVC.isAtMensionSelected == false
        {
            performUIUpdatesOnMain {
                service_view.frame = CGRect(x: service_view.frame.minX, y: service_view.frame.minY, width: service_view.frame.width + 10, height: service_view.frame.height)
                self.leftView = service_view
            }
        }
        else
        {
            performUIUpdatesOnMain {
                self.leftView =  customLeftView
            }
        }
        
    }
  
    //removing contact search from searchbar
    override func deleteBackward() {
        if (self.text == "" && SearchResultsViewModel.QueryVC.isAtMensionSelected == true)// SearchResultsViewModel.isContactSearch == true)
        {
            //            SearchResultsViewModel.isContactSearch = false
            SearchResultsViewModel.QueryVC.isAtMensionSelected = false
            serviceTapped()
            self.awakeFromNib()
            //            SearchResultsViewModel.ZUID = -1 //removes contact search
            SearchResultsViewModel.QueryVC.suggestionZUID = -1
          
        }
        
        super.deleteBackward()
        
    }
    // padding for contact icon
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        //        if SearchResultsViewModel.isContactSearch == true
        if SearchResultsViewModel.QueryVC.isAtMensionSelected == true
        {
            if let view = self.leftView {
                return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left:(view.frame.width) + 8 , bottom: 0, right: 0))
            }
            else {
                return super.textRect(forBounds: bounds)
            }
        }
        
        return super.textRect(forBounds: bounds)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        //        if SearchResultsViewModel.isContactSearch == true
        if SearchResultsViewModel.QueryVC.isAtMensionSelected == true
        {
            if let view = self.leftView {
                return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: view.frame.width + 8 , bottom: 0, right: 0))
            }
            else {
                return super.placeholderRect(forBounds: bounds)
            }
        }
        
        return super.placeholderRect(forBounds: bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        //        if SearchResultsViewModel.isContactSearch == true
        if SearchResultsViewModel.QueryVC.isAtMensionSelected == true
        {
            if let view = self.leftView {
                return UIEdgeInsetsInsetRect(bounds, UIEdgeInsets(top: 0, left: view.frame.width + 8 , bottom: 0, right: 0))
            }
            else {
                return super.editingRect(forBounds: bounds)
            }
        }
        return super.editingRect(forBounds: bounds)
    }
    //    //
    //    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
    //
    //        originalRect = CGRect(x: bounds.maxX - 50 , y: bounds.minY , width: 50 , height:50)
    //        return originalRect
    //    }
    
    /*    func AddContactIcon()
     {
     
     let cimg:UIImage = SearchResultsViewModel.contact_image
     //        let cimg:UIImage = UIImage(named:"searchsdk-cliq-single", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
     let contact_view = UIView(frame: CGRect(x:self.frame.height , y: 10, width: self.frame.height-20 , height: self.frame.height-20))
     
     let imageV = UIImageView(image: cimg.imageWithInsets(insets: UIEdgeInsetsMake(5, 5, 5, 5)))
     imageV.frame = CGRect(x: 0, y: 0, width: contact_view.frame.width, height: contact_view.frame.height)
     
     //make circle
     imageV.maskCircle(anyImage: cimg)
     //        imageV.layer.cornerRadius = contact_view.frame.height / 2;
     //        imageV.clipsToBounds = true;
     //        imageV.layer.masksToBounds = false
     imageV.backgroundColor = UIColor.white
     imageV.layer.zPosition = 999999
     
     //        contact_view.backgroundColor = UIColor.brown
     contact_view.addSubview(imageV)
     //        contact_view.backgroundColor = UIColor.white
     //        contact_view.layer.cornerRadius = contact_view.frame.size.width / 2
     //        contact_view.clipsToBounds = true
     //        contact_view.layer.masksToBounds = false
     //        contact_view.layer.zPosition = 999999
     let guesture = UITapGestureRecognizer(target: self, action: #selector(self.contactTouched))
     contact_view.addGestureRecognizer(guesture)
     
     self.leftView = contact_view
     
     
     
     }*/
    @objc func contactTouched(_ sender : UITapGestureRecognizer)
    {
        if SearchResultsViewModel.QueryVC.isNamelabledisplay == true
        {
            changeServiceImge()
            SearchResultsViewModel.QueryVC.isNamelabledisplay = false
            return
        }
        SearchResultsViewModel.QueryVC.isNamelabledisplay = true
        let expandedview : UIView = self.leftView!
        
        let max_width = CGFloat( self.frame.width / 2 - self.frame.height )
        
        var dynamic_width = max_width
        
        let string = SearchResultsViewModel.QueryVC.suggestionContactName
        let font = UIFont.systemFont(ofSize: 15)
        let name_width = string.size(OfFont: font).width
        if name_width > max_width
        {
            dynamic_width = max_width
        }
        else
        {
            dynamic_width = name_width
        }
        
        let name_padding : CGFloat = 4.0
        
        let nameLableView = UIView(frame : CGRect(x: expandedview.frame.width - ((expandedview.frame.height - 20) / 2) , y: 10, width: dynamic_width + ((expandedview.frame.height - 20) + name_padding ) , height: expandedview.frame.height - 20))
        //        nameLableView.backgroundColor = UIColor.gray
        nameLableView.backgroundColor =  SearchKitConstants.ColorConstants.AtMension_NameLabel_BackGround_Color//UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        let lable = UILabel(frame: CGRect(x:  nameLableView.frame.height / 2 + name_padding, y: 0, width: nameLableView.frame.width - (nameLableView.frame.height / 2 ) , height: nameLableView.frame.height))
        //        lable.text = "Manikandan"
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text  = SearchResultsViewModel.QueryVC.suggestionContactName
        //        lable.drawText(in: CGRect(x: 2 * self.frame.height / 2, y: 0, width: 0, height: 0))
        nameLableView.addSubview(lable)
        
        let srinkButton = UIView(frame : CGRect(x: expandedview.frame.width + nameLableView.frame.width - 2*( nameLableView.frame.height / 2), y:nameLableView.frame.minY, width: nameLableView.frame.height, height: nameLableView.frame.height))
        
        let img:UIImage = UIImage(named: "searchsdk-close" , in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
        
        let imageView = UIImageView(image: img.imageWithInsets(insets: UIEdgeInsetsMake(12, 12, 12, 12)))
        imageView.frame = CGRect(x: 0, y: 0, width:srinkButton.frame.width , height: srinkButton.frame.height)
        imageView.layer.cornerRadius = imageView.frame.size.width / 2
        imageView.clipsToBounds = true;
        //        imageView.backgroundColor = UIColor.gray
        imageView.backgroundColor =  SearchKitConstants.ColorConstants.AtMension_NameLabel_BackGround_Color//UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        imageView.layer.masksToBounds = false
        
        
        let guesture = UITapGestureRecognizer(target: self, action: #selector(self.CloseNameLable))
        srinkButton.addGestureRecognizer(guesture)
        srinkButton.addSubview(imageView)
        
        expandedview.frame = CGRect(x: 0, y: 0, width: expandedview.frame.width + nameLableView.frame.width , height: expandedview.frame.height)
        expandedview.addSubview(nameLableView)
        
        expandedview.addSubview(srinkButton)
        self.leftView = expandedview
        
    }
    @objc func CloseNameLable()
    {
        
        // closing contact search
        SearchResultsViewModel.QueryVC.isAtMensionSelected = false
        SearchResultsViewModel.QueryVC.isNamelabledisplay = false
        //        SearchResultsViewModel.isContactSearch = false
        //
        //        SearchResultsViewModel.ZUID = -1
        
        SearchResultsViewModel.QueryVC.suggestionZUID = -1
        serviceTapped()
        self.awakeFromNib()
        
        
    }
    //
    override func layoutSubviews() {
        super.layoutSubviews()
        if SearchResultsViewModel.QueryVC.isAtMensionSelected == true || text != ""
            //        if SearchResultsViewModel.isContactSearch == true || text != ""
        {
            self.rightViewMode = .always
        }
        else
        {
            self.rightViewMode = .always
        }
        
    }
    
    //    private func ClearImage() {
    //
    //
    //        for view in subviews  {
    //            if view is UIButton {
    //                let button = view as! UIButton
    //                clearButtonMode = .always
    //
    //                let img = UIImage(named: "searchsdk-clear", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
    //
    //                //normal image
    //                button.setImage(img, for: .normal)
    //                //  button.setImage(img, for: .highlighted)
    ////                clearButton = button
    //
    //            }
    //        }
    //
    //
    //    }
    
    
}


