//
//  FilterFooterCell.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 23/04/18.
//

import Foundation
import UIKit
class FilterVCFooterView: UITableViewCell{
    @IBOutlet weak var fromDate: UILabel!
    @IBOutlet weak var toDate: UILabel!
    var section : Int = Int()
    var FilterViewController : FilterViewController?
    var dateType : DateRequiredType = .SpecificDate
    var currentSelection : String = String()
    var filterModule  : FilterModule?{
        didSet{
            if let  module = filterModule
            {
                let selectedFilter = module.selectedFilterName!
                self.currentSelection = selectedFilter
         
                if selectedFilter == FilterConstants.DisPlayValues.Date.CUSTOM_RANGE
                {
                    self.fromDate.text = "From :" + (module.selectedFilterServerValue ?? "")
                    self.toDate.text = "To :" + (module.selectedFilterServerValue_2 ?? "")
                    self.dateType = .CustomRange
                }
                else
                {
                    self.fromDate.text = "Selected Date"
                    self.toDate.text =  module.selectedFilterServerValue
                    self.dateType = .SpecificDate
                }
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDatePickerView))
        self.addGestureRecognizer(tapGesture)
    }
    @objc func showDatePickerView()
    {
        FilterViewController?.showDatePicker(fortype: self.dateType, filterModule: self.filterModule!, currentSelectionName: self.currentSelection, oldSlectionName: self.currentSelection)
    }
    static var identifier: String {
        return String(describing: self)
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
}
