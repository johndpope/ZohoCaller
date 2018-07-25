//
//  SearchSettingsViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 31/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

//Settings **listing** will be done in this view controller
//list like - service reorder, default service selection, saved search, search history, enable-disable search highlighting, enable disable pull to refresh, sync widget data
class SearchSettingsViewController: ZSViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    static func vcInstanceFromStoryboard() -> SearchSettingsViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: SearchSettingsViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? SearchSettingsViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Settings"
        //for settings vc as push model
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        //tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        
        tableView.register(DrillDownSettingsTableViewCell.nib, forCellReuseIdentifier: DrillDownSettingsTableViewCell.identifier)
        
        tableView.register(ToggleSettingsTableViewCell.nib, forCellReuseIdentifier: ToggleSettingsTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false , animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SearchResultsViewModel.searchWhenLoaded = false
        //not needed as viewWillAppear can be used for the same purpose, instead of using notification
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SettingsVCDismissed"), object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressBackButton(_ sender: UIButton) {
        //when presented modally
        //self.dismiss(animated: true, completion: nil)
        
        //when presented using push
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: true)
    }
}

extension SearchSettingsViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension SearchSettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                return "Service Settings"
            }
        case 1:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                return "App Settings"
            }
        case 2:
            if self.tableView(tableView, numberOfRowsInSection: section) > 0 {
                return "Results Settings"
            }
        default:
            return nil // when return nil no header will be shown
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    //remove unanted space from bottom of the tableview
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //currently each section has two options
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCell(withIdentifier: DrillDownSettingsTableViewCell.identifier) as! DrillDownSettingsTableViewCell
            
            if indexPath.row == 0 {
                cell.name = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.settings.reorderservice", defaultValue: "Service Reordering")
                cell.imageName = SearchKitConstants.ImageNameConstants.ServiceReorderImage
            }
            else if indexPath.row == 1 {
                cell.name = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.settings.defaultserviceselection", defaultValue: "Default Service Selection")
                cell.imageName = SearchKitConstants.ImageNameConstants.SelctionTickImage
            }
            
            return cell
        }
        else if (indexPath.section == 1) {
            let cell = tableView.dequeueReusableCell(withIdentifier: DrillDownSettingsTableViewCell.identifier) as! DrillDownSettingsTableViewCell
            
            if indexPath.row == 0 {
                cell.name = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.settings.recentsearches", defaultValue: "Search History")
                cell.imageName = SearchKitConstants.ImageNameConstants.SearchHistoryImage
            }
            else if indexPath.row == 1 {
                cell.name = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.settings.savedsearches", defaultValue: "Saved Searches")
                cell.imageName = SearchKitConstants.ImageNameConstants.SavedSearchImage
            }
            
            return cell
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ToggleSettingsTableViewCell.identifier) as! ToggleSettingsTableViewCell
            
            if indexPath.row == 0 {
                cell.name = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.settings.enablehighlighting", defaultValue: "Show Highlights")
                cell.hint = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.settings.enablehighlighting.hint", defaultValue: "Will highlight the matched words in results.")
                cell.type = ToggleSettingsType.resultHighlight
                cell.switchedOn = UserPrefManager.isResultHighlightingEnabled()
            }
            else if indexPath.row == 1 {
                cell.name = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.settings.enablepulltorefresh", defaultValue: "Pull to Refresh")
                cell.hint = SearchKitUtil.getLocalizedString(i18nKey: "searchkit.settings.enablepulltorefresh.hint", defaultValue: "Will enable pull to refresh in results page.")
                cell.type = ToggleSettingsType.pullToRefresh
                cell.switchedOn = UserPrefManager.isPullToRefreshEnabled()
            }
            
            //so that it will feel like setting option with uiswitch
            //does not allow any table cell click but the uiswicth will allow user
            //to toggle the settings
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.delegate = self
            return cell
        }
    }
}

//
extension SearchSettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        if section == 0 {
            if (indexPath.row == 0) {
                let settingsVC = ServiceReorderViewController.vcInstanceFromStoryboard()
                //present modally
                //                self.present(settingsVC!, animated: true, completion: nil)
                //push to the hidden navigation controller
                //self.navigationController?.pushViewController(settingsVC!, animated: true)
                ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(settingsVC!, animated: true)
            }
            else if (indexPath.row == 1) {
                let settingsVC = DefaultServiceSelectionViewController.vcInstanceFromStoryboard()
                //self.present(settingsVC!, animated: true, completion: nil)
                //self.navigationController?.pushViewController(settingsVC!, animated: true)
                ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(settingsVC!, animated: true)
            }
        }
            //search history and saved search
        else if section == 1 {
            if (indexPath.row == 0) {
                let settingsVC = SearchHistoryViewController.vcInstanceFromStoryboard()
                //self.present(settingsVC!, animated: true, completion: nil)
                //self.navigationController?.pushViewController(settingsVC!, animated: true)
                ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(settingsVC!, animated: true)
            }
            else if (indexPath.row == 1) {
                let settingsVC = SavedSearchViewController.vcInstanceFromStoryboard()
                //self.present(settingsVC!, animated: true, completion: nil)
                //self.navigationController?.pushViewController(settingsVC!, animated: true)
                ZohoSearchKit.sharedInstance().appViewController?.navigationController?.pushViewController(settingsVC!, animated: true)
            }
        }
        
        //deselect after operation
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//This delegate method is called when respective cell switch is toggled between on and of
//the latest state will be saved
extension SearchSettingsViewController: ToggleSettingsTableViewCellDelegate {
    func valueChanged(_ sender: ToggleSettingsTableViewCell) {
        if let type = sender.type {
            switch type {
            case .resultHighlight:
                UserPrefManager.setResultHighlightingEnabled(isEnabled: sender.settingsSwitch.isOn)
                ZohoSearchKit.sharedInstance().resultsHighlightingEnabled = sender.settingsSwitch.isOn
                break
            case .pullToRefresh:
                UserPrefManager.setPullToRefreshEnabled(isEnabled: sender.settingsSwitch.isOn)
                break
            }
        }
    }
}
