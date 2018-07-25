//
//  ToggleSettingsTableViewCell.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 26/02/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

enum ToggleSettingsType {
    case resultHighlight
    case pullToRefresh
}

protocol ToggleSettingsTableViewCellDelegate : class {
    func valueChanged(_ sender: ToggleSettingsTableViewCell)
}

class ToggleSettingsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var settingsNameLabel: UILabel!
    @IBOutlet weak var hintLabel: UILabel!
    @IBOutlet weak var settingsSwitch: UISwitch!
    
    weak var delegate: ToggleSettingsTableViewCellDelegate?
    
    var type: ToggleSettingsType?
    
    var switchedOn: Bool?
    {
        didSet
        {
            guard switchedOn != nil else
            {
                return
            }
            settingsSwitch.onTintColor = ThemeService.sharedInstance().theme.navigationBarBackGroundColor
            settingsSwitch.isOn = switchedOn!
        }
    }
    
    //later all the properties will be moved to separate model class
    var name: String? {
        didSet {
            guard name != nil else {
                return
            }
            
            settingsNameLabel.text = name
        }
    }
    
    var hint: String? {
        didSet {
            guard hint != nil else {
                return
            }
            
            hintLabel.text = hint
        }
    }
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.valueChanged(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
}
