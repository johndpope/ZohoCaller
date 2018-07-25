//
//  BaseWebViewCalloutViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 12/03/18.
//

import UIKit

class BaseWebViewCalloutViewController: AbstractCalloutViewController {
    
    let activityIndicator = ActivityIndicatorUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.showActivityIndicator(uiView: self.view)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SearchResultsViewModel.searchWhenLoaded = false
    }
    
}

//UIWebViewDelegate to show and hide loading view
extension BaseWebViewCalloutViewController : UIWebViewDelegate {
    //this is not needed now as start animating is started in view did load
    func webViewDidStartLoad(_ :UIWebView){
        //indicatorView.startAnimating()
    }
    
    func webViewDidFinishLoad(_ :UIWebView){
        //indicatorView.stopAnimating()
        activityIndicator.hideActivityIndicator(uiView: self.view)
    }
    
//    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
//        //indicatorView.stopAnimating()
//        activityIndicator.hideActivityIndicator(uiView: self.view)
//    }
}
