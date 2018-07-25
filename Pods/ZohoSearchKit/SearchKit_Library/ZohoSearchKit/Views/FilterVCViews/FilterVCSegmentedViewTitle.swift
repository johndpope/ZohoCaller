//
//  FilterVCSegmentedViewTitle.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 19/03/18.
//

import UIKit
protocol SegmentedHeaderDelegate {
    func didSortByFilterChangedfor(header : FilterVCSegmentedViewTitle)
}
class FilterVCSegmentedViewTitle: UITableViewHeaderFooterView  {
    var section : Int = Int()
    var delegate : SegmentedHeaderDelegate?
    @IBOutlet weak var SortBySelector: UISegmentedControl!
    var filterModule:FilterModule?{
        didSet{
            self.sectionTitle.text =  filterModule?.filterName // module.filterName!
            self.sectionTitle.textColor = SearchKitConstants.ColorConstants.FilterVC_header_Text_Color
            self.SortBySelector.selectedSegmentIndex = (filterModule?.sortBYFIlterSelectedIndex)! // module.sortBYFIlterSelectedIndex
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization cod
        SortBySelector.addTarget(self, action: #selector(sortbyChanged), for: .valueChanged)
    }
    @objc func sortbyChanged()
    {
        delegate?.didSortByFilterChangedfor(header: self)
    }
    @IBOutlet weak var sectionTitle: UILabel!
    
    static var identifier: String {
        return String(describing: self)
    }
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: ZohoSearchKit.frameworkBundle)
    }
}
