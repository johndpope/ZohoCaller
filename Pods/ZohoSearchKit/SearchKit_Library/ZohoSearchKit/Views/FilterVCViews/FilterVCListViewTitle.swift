//
//  FilterHeaderTitleView.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 19/03/18.
//

import UIKit

class FilterVCListViewTitle: UITableViewHeaderFooterView {

    @IBOutlet weak var titleHeaderVIew: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var selectedFilterName: UILabel!
        @IBOutlet weak var dropAndUpArrowImage: UIImageView!
        @IBOutlet weak var sectionTitle: UILabel!
        
    @IBOutlet weak var selectedFilterView: UIView!
    var section: Int = 0
    
    weak var delegate: FilterSelectionDelegate?
    var filterModule : FilterModule?{
        didSet{
            self.sectionTitle.text = filterModule?.filterName // module.filterName!
            self.sectionTitle.textColor = SearchKitConstants.ColorConstants.FilterVC_header_Text_Color
            self.selectedFilterName.text =  filterModule?.selectedFilterName //module.selectedFilterName
            self.selectedFilterName.textColor = SearchKitConstants.ColorConstants.FilterVC_Content_Text_Color
            let dropDownStatus : Bool = ( filterModule?.filterViewType == .dropDownView ? (filterModule?.isDropViewExpanded)! : false)
            if dropDownStatus == false
            {
                self.dropAndUpArrowImage.image = UIImage(named: "searchsdk-filter-down", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)?.imageWithInsets(insets: UIEdgeInsetsMake(15, 15, 15, 15))
  
            }
            else
            {
                self.dropAndUpArrowImage.image = UIImage(named: "searchsdk-filter-up", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)?.imageWithInsets(insets: UIEdgeInsetsMake(15, 15, 15, 15))
            }
            //MARK:- Adding tint color for toggle arrow
            self.dropAndUpArrowImage.changeTintColor(SearchKitConstants.ColorConstants.FilterVC_ToggleArrow_TintColor)
        }
    }
    @objc  func didTapHeader() {
        delegate?.TitleHeaderTapped(section: section , offset: self.frame.origin)
    }
        override func awakeFromNib() {
            super.awakeFromNib()
            titleHeaderVIew.backgroundColor = SearchKitConstants.ColorConstants.FilterVC_TileHeaderView_BackGround_Color
            activityIndicator.isHidden = true
            // Initialization code
            let guesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapHeader))
            self.selectedFilterView.addGestureRecognizer(guesture)
        }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        activityIndicator.isHidden = true
    }
        
        static var identifier: String {
            return String(describing: self)
        }
        static var nib:UINib {
            return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
        }

    


}
