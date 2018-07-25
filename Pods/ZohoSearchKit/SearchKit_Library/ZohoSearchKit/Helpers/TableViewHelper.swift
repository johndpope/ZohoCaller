//
//  TableViewHelper.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 03/04/18.
//

import Foundation
import UIKit

class TableViewHelper {
    
    class func emptySearchResults(viewController:UITableViewController) {
        let messageLabel = UILabel()
        //TODO: Use the I18N message for empty result set
        messageLabel.text = "No search results found! "
        messageLabel.textColor = SearchKitConstants.ColorConstants.Bold_Text_Color
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont.systemFont(ofSize: 17.0)
        messageLabel.sizeToFit()
        
        viewController.tableView.backgroundView = messageLabel;
        viewController.tableView.separatorStyle = .none;
    }
    class func SearchResultError(viewController:UITableViewController,errorType : SearchResultErrorType)
    {
        let errorView = SearchResultsErrorMessage(frame: viewController.view.frame, errorType: errorType)
        //TODO: Use the I18N message for empty result set
        errorView.sizeToFit()
        performUIUpdatesOnMain
            {
                viewController.tableView.backgroundView = errorView
        }
        viewController.tableView.separatorStyle = .none;
    }
    class func clearBackGroundView(viewController:UITableViewController) {
        let backView = UIView(frame: viewController.tableView.frame)
        backView.backgroundColor = .white
        
        performUIUpdatesOnMain {
            viewController.tableView.backgroundView = backView
        }
       
    }
    class func updateTableViewBGStatusAfterSearch(currentTableVC : TableViewController)
    {
        if let serviceName = currentTableVC.itemInfo.serviceName {
            if serviceName == ZOSSearchAPIClient.ServiceNameConstants.All {
                var sectionCount = 0
                for (_, item) in SearchResultsViewModel.serviceSections {
                    if item.searchResults.count > 0 {
                        sectionCount = sectionCount + 1
                    }
                }
                if sectionCount > 0
                {
                    TableViewHelper.clearBackGroundView(viewController: currentTableVC)
                }
                else
                {
                    TableViewHelper.SearchResultError(viewController: currentTableVC, errorType: .noResults)
                }
                
            }
            else {
                //return 1
                if let item = SearchResultsViewModel.serviceSections[currentTableVC.itemInfo.serviceName!], item.searchResults.count > 0 {
                    TableViewHelper.clearBackGroundView(viewController: currentTableVC)
                    
                }
                else {
                    TableViewHelper.SearchResultError(viewController: currentTableVC, errorType: .noResults)
                }
            }
        }
    }
    class func startActivityIndicator(currentTableVC : TableViewController,activityIndicator : ZOSActivityIndicatorView)
    {
          if currentTableVC.itemInfo.serviceName == ZOSSearchAPIClient.ServiceNameConstants.All {
             activityIndicator.startAnimating()
         }
        else
          {
            activityIndicator.startAnimating()
        }
    }
    class func stopActivityIndicatotor(activityIndicator : ZOSActivityIndicatorView)
    {
        activityIndicator.stopAnimating()
    }
    
    //Add other helper function like retry on error etc.
}
