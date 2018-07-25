//
//  File.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 26/04/18.
//

import Foundation
class CallOutActionView: UIView {
    var quickActionStack: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        stackView.backgroundColor = .red
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    var empName = String()
    var  quickActionComponents = [DataLabelAndValue]()
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        self.layer.zPosition = ZpositionLevel.high.rawValue
        self.layer.cornerRadius = 15
        self.layer.borderWidth = 0.1
        self.layer.borderColor = UIColor.gray.cgColor
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    @objc func didPressedOn_Call(_ sender : UIButton)
        //last name should be same as empdetails
    {
        let phoneNumber = quickActionComponents.vauleFor(key: CallOutFeilds.mobile.rawValue )
        IntentActionHandler.makePhoneCall(phoneNumber: phoneNumber! )
    }
    @objc func didPressedOn_Email(_ sender : UIButton)
        //last name should be same as empdetails
    {
        let email = quickActionComponents.vauleFor(key: CallOutFeilds.email.rawValue )
        IntentActionHandler.sendNewMail(emailID: email! )
    }
    
    @objc func didPressedOn_Chat(_ sender : UIButton)
        // last name should be same as empdetails
    {
        let userZUID = quickActionComponents.vauleFor(key: CallOutFeilds.zuid.rawValue)
        ZohoAppsDeepLinkUtil.chatUsingCliq(zuid: Int(userZUID!)!, displayName: empName)
    }
    
    func createquickActionComponent(forKey : String , value : String) -> UIButton
    {
        var imgName = String()
        let component = UIButton()
        let key = CallOutFeilds(rawValue: forKey)
        switch key {
        case .email?:
//            img = UIImage(named: SearchKitConstants.ImageNameConstants.SendMailImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
            imgName = SearchKitConstants.ImageNameConstants.SendMailImage
            
            component.addTarget(self, action: #selector(didPressedOn_Email(_:)), for: .touchUpInside)
        case .mobile?:
//            img = UIImage(named: SearchKitConstants.ImageNameConstants.MakeCallImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
             imgName = SearchKitConstants.ImageNameConstants.MakeCallImage
            component.addTarget(self, action: #selector(didPressedOn_Call(_:)), for: .touchUpInside)
        case .zuid?:
//            img = UIImage(named:SearchKitConstants.ImageNameConstants.ChatWithTheUser, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
             imgName = SearchKitConstants.ImageNameConstants.ChatWithTheUser
            component.addTarget(self, action: #selector(didPressedOn_Chat(_:)), for: .touchUpInside)
            
        default:
            break
        }
//        component.setImage(img, for: .normal)
        component.isSelected = false
        component.setImageTintColor(imageName: imgName , tintColor: SearchKitConstants.ColorConstants.NavigationBar_BackGround_Color , for: .normal)
        component.setImageTintColor(imageName: imgName , tintColor: SearchKitConstants.ColorConstants.NavigationBar_BackGround_Color , for: .selected)
        component.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5)
        let componentHeight = self.frame.height
        component.heightAnchor.constraint(equalToConstant: componentHeight).isActive = true
        component.widthAnchor.constraint(equalToConstant: componentHeight).isActive = true
        return component
    }
    let stackViewSpacing : CGFloat = 10
    let stackviewInsetLeftConst : CGFloat = 20
    let stackviewInsetRightConst : CGFloat = 20
    var quickActionWidth :CGFloat = 0
    func setUpQuickActions()
    {
        
        var count : CGFloat = 0
        var totalComponentsWidth :CGFloat = 0
        for componentPair in quickActionComponents
        {
            let component : UIButton = createquickActionComponent(forKey: componentPair.dataLabel, value: componentPair.dataValue)
            quickActionStack.addArrangedSubview(component)
            totalComponentsWidth = totalComponentsWidth + self.frame.height
            count = count + 1
        }
        let stackViewWidth = totalComponentsWidth + ((count - 1) * stackViewSpacing)
        quickActionStack.spacing = stackViewSpacing
        self.addSubview(quickActionStack)
        if count == 0
        {
            quickActionWidth  = 0
        }
        else
        {
            quickActionWidth = stackViewWidth + stackviewInsetLeftConst + stackviewInsetRightConst
        }
        self.layoutSubviews() // MARK:- Important to update Width
        self.shadow()
        //        self.frame.size.width = quickActionWidth
        //        quickActionStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //        quickActionStack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        //        self.addConstraintwithFormate(format: "H:|-10-[v0]-10-|", views: quickActionStack)
        //        self.addConstraintwithFormate(format: "V:|-0-[v0]-0-|", views: quickActionStack)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame.size.width = quickActionWidth
        self.center.x = (self.superview?.center.x)!
        quickActionStack.frame.origin = CGPoint(x: stackviewInsetLeftConst, y: 0)
        
        
    }
    
}
