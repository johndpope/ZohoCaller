//
//  CRMCalloutViewController.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 11/06/18.
//

import UIKit

class CRMCalloutViewController: AbstractCalloutViewController {
    static func vcInstanceFromStoryboard() -> CRMCalloutViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: CRMCalloutViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? CRMCalloutViewController
    }
    @objc  func moreButtonPressed(sender : UINavigationItem)
    {
        OpenServiceWithNativeApp.sharedInstance().selectedResultCellServiceName = ZOSSearchAPIClient.ServiceNameConstants.Crm
        OpenServiceWithNativeApp.sharedInstance().selectedServiceResult = self.crmResult
        OpenServiceWithNativeApp.sharedInstance().didPressMoreActionsOption(sender, currentViewcontroller: self)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        let rightButtonItem = UIBarButtonItem.init(
            title: nil,
            style: .done,
            target: self,
            action: #selector(moreButtonPressed)
        )
        rightButtonItem.image = UIImage(named: "searchsdk-more", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)
        self.navigationItem.rightBarButtonItem = rightButtonItem
        if crmResult != nil
        {
            // MARK:- should clear all data before fetching results
            resultDataPairs.removeAll()
            bussinessCardDataPairs.removeAll()
            searchAndLoadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBOutlet weak var tableView: UITableView!
    var titleNameKey = ""
    var titleNameValue = ""
    var bussinessCardDataPairs = [DataLabelAndValue]()
    var resultDataPairs = [DataLabelAndValue]()
    var crmResult : CRMResult?
    var activityIndicator : ZOSActivityIndicatorView?
    func configureTableView()
    {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(KeyValueTableViewCell.nib, forCellReuseIdentifier: KeyValueTableViewCell.identifier)
        tableView.register(CRMCalloutHeaderCell.nib, forHeaderFooterViewReuseIdentifier: CRMCalloutHeaderCell.identifier)
        tableView.register(SeparatorLineCell.nib,forCellReuseIdentifier:  SeparatorLineCell.identifier)
        tableView.register(CRMCalloutBussinessCardCell.nib, forCellReuseIdentifier: CRMCalloutBussinessCardCell.identifier)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}
extension CRMCalloutViewController : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if bussinessCardDataPairs.count > 0 || resultDataPairs.count > 0
        {
            return bussinessCardDataPairs.count +  resultDataPairs.count + 1
        }
        else
        {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
        {
            if indexPath.row < bussinessCardDataPairs.count
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: CRMCalloutBussinessCardCell.identifier) as! CRMCalloutBussinessCardCell
                cell.nameLabel.text = bussinessCardDataPairs[indexPath.row].dataLabel
                cell.valueLabel.text = bussinessCardDataPairs[indexPath.row].dataValue
                return cell
            }
            else if indexPath.row == bussinessCardDataPairs.count // separator line
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: SeparatorLineCell.identifier) as! SeparatorLineCell
                return cell
            }
            else
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: KeyValueTableViewCell.identifier) as! KeyValueTableViewCell
                cell.dataLabel.text = resultDataPairs[indexPath.row - bussinessCardDataPairs.count - 1].dataLabel
                cell.dataValue.text = resultDataPairs[indexPath.row - bussinessCardDataPairs.count - 1 ].dataValue
                return cell
            }
        }
        
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        //        if indexPath.row < bussinessCardDataPairs.count
        //        {
        //            return 35
        //        }
        //        else // extra fields
        //        {
        //            return 70
        //        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if bussinessCardDataPairs.count > 0 || resultDataPairs.count > 0
        {
            let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: CRMCalloutHeaderCell.identifier) as! CRMCalloutHeaderCell
            cell.crmTitle.text = titleNameValue
            let image:UIImage = ResultIconUtils.getIconForCRMResult(crmResult: crmResult!)!
            let imageView = UIImageView.createCircularImageViewWithInsetWithoutBorder(image: image, bgColor: nil, insetPadding: 4, imageViewWidth:  cell.crmModuleImageView.frame.width, imageViewHeight: cell.crmModuleImageView.frame.height)
            cell.crmModuleImageView.addSubview(imageView)
            return cell
        }
        else
        {
            return UIView()
        }
        
    }
    
    func searchAndLoadData()
    {
        guard self.tableView != nil else {
            return
        }
        performUIUpdatesOnMain {
            let backView = UIView(frame: self.tableView.frame)
            backView.backgroundColor = .white
            self.tableView.backgroundView = backView
            self.activityIndicator = ZOSActivityIndicatorView(containerView:self.tableView.backgroundView!)
            self.activityIndicator?.startAnimating()
        }
        ZohoSearchKit.sharedInstance().getToken({ (token, error) in
            if let oAuthToken = token {
                _ = ZOSSearchAPIClient.sharedInstance().getCRMCallout(oAuthToken: oAuthToken, entityID: Int64((self.crmResult?.entityID)!)!, crmMod: (self.crmResult?.moduleName)!, clickPosition: 0)
                {
                    (calloutDataResp, error) in
                    
                    if let modName = self.crmResult?.moduleName {
                        switch modName
                        {
                        case ZOSSearchAPIClient.CRMModulesNames.Accounts:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Accounts.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Contacts:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Contacts.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Leads:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Leads.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Campaigns:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Campaigns.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Potentials:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Potentials.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Solutions:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Solutions.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Notes:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Notes.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Tasks:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Tasks.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Events:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.events.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Calls:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Calls.Title
                        case ZOSSearchAPIClient.CRMModulesNames.Cases:
                            self.titleNameKey = ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.Cases.Title
                        default:
                            break
                        }
                    }
                    if let calloutDataResp = calloutDataResp {
                        if let impFeilds = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.ImportFeilds] as? [String:String] {
                            performUIUpdatesOnMain {
                                for feild in impFeilds
                                {
                                    if self.titleNameKey == feild.key
                                    {
                                        self.titleNameValue = feild.value
                                    }
                                    if feild.key.isEmpty == false && feild.value.isEmpty == false
                                    {
                                        let feildData = DataLabelAndValue(labelText: feild.key, valueText: feild.value )
                                        self.bussinessCardDataPairs.append(feildData)
                                    }
                                }
                            }
                        }
                    }
                    if let calloutDataResp = calloutDataResp {
                        if let extraFeilds = calloutDataResp[ZOSSearchAPIClient.CalloutResponseJSONKeys.CrmCallout.ExtraFeilds] as? [String:String] {
                            performUIUpdatesOnMain {
                                for feild in extraFeilds
                                {
                                    if self.titleNameKey == feild.key
                                    {
                                        self.titleNameValue = feild.value
                                    }
                                    if feild.key.isEmpty == false && feild.value.isEmpty == false
                                    {
                                        let feildData = DataLabelAndValue(labelText: feild.key, valueText: feild.value )
                                        self.resultDataPairs.append(feildData)
                                    }
                                    
                                }
                            }
                        }
                    }
                    performUIUpdatesOnMain {
                        self.activityIndicator?.stopAnimating()
                        self.tableView.reloadData()
                    }
                }
            }
        })
    }
}
