//
//  DefaultServiceSelectionViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 31/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

//Will be opened from SearchSettingsViewController and this will just allow the user to change the default service to be searched.
class DefaultServiceSelectionViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var services: [String] = [String]()
    var defaultServiceName = "all"
    var scrollIndexPath = IndexPath()
    var selectedIndexPath: IndexPath?
    
    static func vcInstanceFromStoryboard() -> DefaultServiceSelectionViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: DefaultServiceSelectionViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? DefaultServiceSelectionViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultServiceName = UserPrefManager.getDefaultServiceForUser()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        
        if let serviceOrder = UserPrefManager.getOrderedServiceListForUser() {
            services = serviceOrder
        }
        else {
            services.removeAll()
            services.append("all")
        }
        
        let defaultServiceIndex = services.index(of: defaultServiceName)
        if defaultServiceIndex != nil {
            selectedIndexPath = IndexPath(row: services.startIndex.distance(to: defaultServiceIndex!), section: 0)
        }
        
        tableView.register(DefaultServiceTableViewCell.nib, forCellReuseIdentifier: DefaultServiceTableViewCell.identifier)
    }
    
    @IBAction func didPressBack(_ sender: UIButton) {
        //self.dismiss(animated: false, completion: nil)
        
        //push model using settings vc wrapped into navigation view controller
        //ZohoSearchKit.sharedInstance().settingsViewController?.navigationController?.popViewController(animated: true)
        
        //push model using the application view controller
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        performUIUpdatesOnMain {
            self.tableView.scrollToRow(at: self.selectedIndexPath!, at: UITableViewScrollPosition.top, animated: true)
        }
    }
    
    //saving before closing the view controller
    override func viewWillDisappear(_ animated: Bool) {
        UserPrefManager.setDefaultServiceForUser(serviceName: defaultServiceName)
    }
}

extension DefaultServiceSelectionViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DefaultServiceTableViewCell.identifier) as! DefaultServiceTableViewCell
        let serviceName = services[indexPath.row]
        cell.serviceName = serviceName
        cell.displayName = SearchKitUtil.getServiceDisplayName(serviceName: serviceName)
        cell.selectionStyle = .none
        
        //temp code
        if serviceName == defaultServiceName {
            cell.selectionSate = true
            performUIUpdatesOnMain {
                cell.setSelected(true, animated: false)
            }
        }
        else {
            cell.selectionSate = false
            //cell.setSelected(false, animated: false)
            performUIUpdatesOnMain {
                cell.setSelected(false, animated: false)
            }
        }
        
        //could be in cell
        let bgColorView = UIView()
        bgColorView.backgroundColor = SearchKitConstants.ColorConstants.SelectedServiceTableBGColor
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
}

extension DefaultServiceSelectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tableCell = tableView.cellForRow(at: indexPath) as! DefaultServiceTableViewCell
        //cell.selectionSate = true
        //cell.setSelected(true, animated: true)
        
        let oldSelectedIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        if let previousSelectedIndexPath = oldSelectedIndexPath {
            if let previousSelectedCell = tableView.cellForRow(at: previousSelectedIndexPath) as? DefaultServiceTableViewCell {
                performUIUpdatesOnMain {
                    previousSelectedCell.selectionSate = false
                    previousSelectedCell.selectedImageView.isHidden = true
                    previousSelectedCell.setSelected(false, animated: false)
                    previousSelectedCell.awakeFromNib()
                }
            }
            performUIUpdatesOnMain {
                tableView.reloadRows(at: [previousSelectedIndexPath], with: .fade)
            }
        }
        
        defaultServiceName = tableCell.serviceName!
        performUIUpdatesOnMain {
            tableCell.selectionSate = true
            tableCell.setSelected(true, animated: false)
            tableCell.awakeFromNib()
            
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
}

