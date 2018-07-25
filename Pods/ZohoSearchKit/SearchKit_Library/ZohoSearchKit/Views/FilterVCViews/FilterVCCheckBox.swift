//
//  FilterVC_CheckBox_Header.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 16/04/18.
//

import UIKit
protocol CheckBoxDelegate {
    func didStatusChangedIn(checkBoxHeader : FilterVCCheckBox)
}
class FilterVCCheckBox: UITableViewHeaderFooterView {
    
    var delegate : CheckBoxDelegate?
    var section : Int = Int()
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var checkBox: CheckBox!
    var filterModule : FilterModule?{
        didSet{
            
            self.name.textColor = SearchKitConstants.ColorConstants.FilterVC_header_Text_Color
            self.name.text =  filterModule?.filterName //module.filterName!
            self.checkBox.status = filterModule?.CheckBoxSelectedStatus // module.CheckBoxSelectedStatus
        }
    }
    @objc func didCheckBoxtapped()
    {
        checkBox.status = !(checkBox.status!)
        delegate?.didStatusChangedIn(checkBoxHeader: self)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = SearchKitConstants.ColorConstants.FilterVC_TileHeaderView_BackGround_Color
        let tapRecogniture = UITapGestureRecognizer(target: self, action: #selector(didCheckBoxtapped))
        self.addGestureRecognizer(tapRecogniture)
        // Initialization code
    }
    static var identifier: String {
        return String(describing: self)
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
    
}
