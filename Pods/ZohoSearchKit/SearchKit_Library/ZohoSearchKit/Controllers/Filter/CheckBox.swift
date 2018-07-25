//
//  File.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 16/04/18.
//
extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
}
import Foundation
class CheckBox : UIView{
    let tickImageView : UIImageView = {
        let imageV = UIImageView(frame: CGRect.zero)
        let tickIcon = UIImage(named: SearchKitConstants.ImageNameConstants.TickImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!.imageWithInsets(insets: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2))
        imageV.maskCircle(anyImage: tickIcon!)
        imageV.changeTintColor( SearchKitConstants.ColorConstants.FilterVC_CheckBox_Selection_TickColor)
        return imageV
    }()
    var status : Bool? {
        didSet{
            if status == true
            {
                if tickImageView.superview == nil
                {
                    self.addSubview(tickImageView)
                }
            }
            else
            {
                if tickImageView.superview != nil
                {
                    tickImageView.removeFromSuperview()
                }
            }
        }
    }
   
   func  setUp()
    {
        status = false
        let dist = min(self.frame.width, self.frame.height)
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: dist, height: dist)
        tickImageView.frame = self.frame
        self.backgroundColor = UIColor.white
        self.makeCircular()
        self.layer.borderWidth = 1
        self.layer.borderColor = SearchKitConstants.ColorConstants.FilterVC_CheckBox_BorderColor.cgColor
      
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       setUp()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
}
