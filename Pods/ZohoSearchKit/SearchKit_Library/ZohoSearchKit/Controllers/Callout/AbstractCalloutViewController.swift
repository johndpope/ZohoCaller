//
//  AbstractCalloutViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 12/03/18.
//

import UIKit

class AbstractCalloutViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        SearchResultsViewModel.searchWhenLoaded = false
    }
    
    func handleBackPress() {
        //when the callout is opened by present as modal
        //self.dismiss(animated: true, completion: nil)
        
        //when the callout is opened by pushing the vc
        //ZohoSearchKit.sharedInstance().searchViewController?.navigationController?.popViewController(animated: true)
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: true)
    }
    
}

extension AbstractCalloutViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
