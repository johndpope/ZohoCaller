//
//  FilterVCListView.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 01/03/18.
//

import UIKit

class FilterVCListView: UITableViewCell {
    @IBOutlet weak var NameLabel: UILabel!
    var indexPath  :IndexPath?
    @IBOutlet weak var SelectionImage: UIImageView!
    let tickIcon = UIImage(named: SearchKitConstants.ImageNameConstants.TickImage, in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!.imageWithInsets(insets: UIEdgeInsets(top: 12, left: 20, bottom: 12, right: 12))
    var filterModule : FilterModule?{
        didSet{
            if let module = filterModule
            {
                if indexPath != nil
                {
                    self.NameLabel.text = (module.searchResults![(indexPath?.row)!])
                }
                self.NameLabel.textColor = SearchKitConstants.ColorConstants.FilterVC_Content_Text_Color
                self.contentView.backgroundColor =  #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
                if module.selectedFilterName == self.NameLabel.text
                {
                    self.contentView.backgroundColor = SearchKitConstants.ColorConstants.SelectedServiceTableBGColor
                    self.NameLabel.textColor = SearchKitConstants.ColorConstants.FilterVC_Selected_Text_Color
                    self.SelectionImage.image = self.tickIcon
                    self.SelectionImage.image = self.SelectionImage.image?.withRenderingMode(.alwaysTemplate)
                    self.SelectionImage.tintColor = SearchKitConstants.ColorConstants.FilterVC_SelectedIndicator_TickImage_TintColor
                }
            }
        
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    static var identifier: String {
        return String(describing: self)
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        SelectionImage.image = nil
        let extSubviews = SelectionImage.subviews
        for subView in extSubviews {
            if (subView is UIImageView) {
                subView.removeFromSuperview()
            }
        }
    }
}
 
