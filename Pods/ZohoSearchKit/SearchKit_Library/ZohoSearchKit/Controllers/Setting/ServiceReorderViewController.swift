//
//  ServiceReorderViewController.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 31/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import UIKit

//Will be opened from SearchSettingsViewController and this will just allow the user to change the order of the services that has to be searched.
class ServiceReorderViewController: ZSViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedServices: [String] = [String]()
    var nonSelectedServices: [String] = [String]()
    //not used anymore
    //fileprivate var itemsPerRow: CGFloat = 3
    //fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    
    static func vcInstanceFromStoryboard() -> ServiceReorderViewController? {
        let storyboard = UIStoryboard(name: "SearchKit_" + String(describing: ServiceReorderViewController.self), bundle: ZohoSearchKit.frameworkBundle)
        return storyboard.instantiateInitialViewController() as? ServiceReorderViewController
    }
    let EmptyCell = "Empty"
    func removeAllServiceFromSelectedServices()
    {
        var removedCount = 0
        for (i,service) in selectedServices.enumerated()
        {
            if service == ZOSSearchAPIClient.ServiceNameConstants.All
            {
                selectedServices.remove(at: i - removedCount)
                removedCount = removedCount + 1
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let removedService = UserPrefManager.getRemovedServiceListForUser()
        {
            nonSelectedServices = removedService
            var removeCount = 0
            //If User Closes the  App  Before ViewWIllDisappear get called there will be two Empty Cells So delete it.
            for (i,service) in nonSelectedServices.enumerated()
            {
                if service == EmptyCell
                {
                    nonSelectedServices.remove(at: i-removeCount)
                    removeCount = removeCount - 1
                }
                if service == ""
                {
                    nonSelectedServices.remove(at: i-removeCount)
                    removeCount = removeCount - 1
                }
            }
            nonSelectedServices.append(EmptyCell)
        }
        else
        {
            nonSelectedServices.removeAll()
            nonSelectedServices = [EmptyCell]
        }
        if let serviceOrder = UserPrefManager.getOrderedServiceListForUser() {
            selectedServices = serviceOrder
            //MARK:- we dont have to show all Tab in service reordering beacuse it is not  a service
           removeAllServiceFromSelectedServices()
        }
        else {
            selectedServices.removeAll()
            selectedServices.append(ZOSSearchAPIClient.ServiceNameConstants.All)
        }
        
        collectionView.register(ServiceReorderCollectionViewCell.nib, forCellWithReuseIdentifier: ServiceReorderCollectionViewCell.identifier)
        collectionView.register(SectionHeaderCollectionReusableView.nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: SectionHeaderCollectionReusableView.identifier)
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        longPressGesture.minimumPressDuration = 0.0
        collectionView.addGestureRecognizer(longPressGesture)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    func getEmptyCellIndexpath() -> IndexPath
    {
        for (i,service) in nonSelectedServices.enumerated()
        {
            if service == EmptyCell
            {
                return IndexPath(item: i, section: 1)
            }
        }
        return IndexPath(item: 0, section: 1)
    }
    var  sourceIndexPath : IndexPath?
    @objc func handleLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            if selectedIndexPath.section == 1
            {
                if getEmptyCellIndexpath().row != selectedIndexPath.row
                {
                    sourceIndexPath = selectedIndexPath
                    collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
                }
            }
            else //MARK:- TO Enable Service removing  if selectedIndexPath.row != 0
            {
                sourceIndexPath = selectedIndexPath
                collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
            }
        case .changed:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            if nonSelectedServices.count == 1
            {
                collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
                return
            }
            else if sourceIndexPath != nil && sourceIndexPath?.section == 0 && selectedIndexPath.section == 1 && selectedIndexPath.row == (nonSelectedServices.count)
                //MARK:- When Item is dragged from other section number of items in current section will inscrease so last item will be nonSelectedService.count
            {
                return
            }
            else if sourceIndexPath != nil && sourceIndexPath?.section == 1 && selectedIndexPath.section == 1 && selectedIndexPath.row == (nonSelectedServices.count - 1)
                //MARK:- When item is dragged with in section number of items will remain same
            {
                return
            }
            else
            {
                collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
            }
            
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }
    //
    //        override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    //            super.viewWillTransition(to: size, with: coordinator)
    //            guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
    //                return
    //            }
    //
    //            if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
    //                //here you can do the logic for the cell size if phone is in landscape
    //                itemsPerRow = 5
    //            } else {
    //                //logic if not landscape
    //                itemsPerRow = 3
    //            }
    //
    //            flowLayout.invalidateLayout()
    //        }
    
    @IBAction func didPressBack(_ sender: UIButton) {
        //self.dismiss(animated: false, completion: nil)
        
        //push model using settings vc wrapped into navigation view controller
        //ZohoSearchKit.sharedInstance().settingsViewController?.navigationController?.popViewController(animated: true)
        
        //push model using the application view controller
        ZohoSearchKit.sharedInstance().appViewController?.navigationController?.popViewController(animated: true)
    }
    
    //saving before closing the view controller
    
    override func viewDidDisappear(_ animated: Bool) {
        removeAllServiceFromSelectedServices()
        selectedServices.insert(ZOSSearchAPIClient.ServiceNameConstants.All, at: 0)
        UserPrefManager.setOrderedServiceListForUser(services: selectedServices)
        //MARK:- we should remove the empty cell which is in last position of removed services
        var removeCount = 0
        for (i,service) in nonSelectedServices.enumerated()
        {
            if service == EmptyCell
            {
                nonSelectedServices.remove(at: i-removeCount)
                removeCount = removeCount - 1
            }
        }
        //        nonSelectedServices.remove(at: nonSelectedServices.count - 1)
        UserPrefManager.setRemovedServiceListForUser(services: nonSelectedServices)
        
        // MARK:- now order of viewContrller and the number of viewcontroller's changed , SO reload the viewcontroller
        SearchResultsViewModel.isViewControllersAltered = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension ServiceReorderViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderCollectionReusableView.identifier, for: indexPath) as! SectionHeaderCollectionReusableView
            if indexPath.section == 0
            {
                headerView.titleLabel.text = "Selected Services"
            }
            else
            {
                headerView.titleLabel.text = "Removed Services"
            }
            return headerView
        default:
            break
        }
        return UICollectionReusableView()
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        //MARK:- To Enable remove service add number of section is 2
        // 1: - only service reordering
        // 2: to add removed services
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0
        {
            return selectedServices.count
        }
        else
        {
            return nonSelectedServices.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0
        {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceReorderCollectionViewCell.identifier, for: indexPath) as! ServiceReorderCollectionViewCell
            cell.serviceName = selectedServices[indexPath.row]
            cell.displayName = SearchKitUtil.getServiceDisplayName(serviceName: selectedServices[indexPath.row])
            cell.backgroundColor = .clear
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ServiceReorderCollectionViewCell.identifier, for: indexPath) as! ServiceReorderCollectionViewCell
            cell.serviceName = nonSelectedServices[indexPath.row]
            cell.displayName = SearchKitUtil.getServiceDisplayName(serviceName: nonSelectedServices[indexPath.row])
            if indexPath.row == nonSelectedServices.count - 1
            {
                cell.backgroundColor = .clear
            }
            else
            {
                cell.backgroundColor = .clear
            }
            return cell
        }
    }
}

//layout simple
extension ServiceReorderViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 110, height: 110)
    }
    
    /*
     //for dynamic sizing of the cells. Not actually needed. We are using fixed size
     func collectionView(_ collectionView: UICollectionView,
     layout collectionViewLayout: UICollectionViewLayout,
     sizeForItemAt indexPath: IndexPath) -> CGSize {
     let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
     let availableWidth = view.frame.width - paddingSpace
     let widthPerItem = availableWidth / itemsPerRow
     
     return CGSize(width: widthPerItem, height: widthPerItem)
     }
     
     func collectionView(_ collectionView: UICollectionView,
     layout collectionViewLayout: UICollectionViewLayout,
     insetForSectionAt section: Int) -> UIEdgeInsets {
     return sectionInsets
     }
     
     func collectionView(_ collectionView: UICollectionView,
     layout collectionViewLayout: UICollectionViewLayout,
     minimumLineSpacingForSectionAt section: Int) -> CGFloat {
     return sectionInsets.left
     }
     */
    
    /*
     //as per orientation not needed
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
     var sizeArea = CGSize()
     if self.view.frame.size.width < self.view.frame.size.height {
     // That's Portrait, all iPhones
     let spacing = self.view.frame.size.width - 15
     let itemWidth = spacing / 3
     let itemHeight = itemWidth
     sizeArea = CGSize(width: 110, height: 110)
     } else {
     // That's Landscape
     let spacing = self.view.frame.size.width - 15
     let itemWidth = spacing / 4     // I understand you want to show 3
     let itemHeight = itemWidth      // May be have to check this
     sizeArea = CGSize(width: 110, height: 110)
     }
     return sizeArea
     }
     */
    
    
}

extension ServiceReorderViewController: UICollectionViewDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    func collectionView(_ collectionView: UICollectionView, canFocusItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var removedItem = String()
        if sourceIndexPath.section == 0
        {
            removedItem = selectedServices.remove(at: sourceIndexPath.item)
        }
        else
        {
            removedItem =  nonSelectedServices.remove(at: sourceIndexPath.item)
        }
        if destinationIndexPath.section == 0
        {
            selectedServices.insert(removedItem, at: destinationIndexPath.item)
        }
        else
        {
            nonSelectedServices.insert(removedItem, at: destinationIndexPath.item)
        }
        //        reArrangeServiceOrder(sourceIndex: sourceIndexPath.item, destinationIndex: destinationIndexPath.item)
    }
    
    //    private func reArrangeServiceOrder(sourceIndex: Int, destinationIndex: Int) -> Void {
    //        print("Before rearrange data: \(selectedServices)")
    //        //reorganise the data
    //        if destinationIndex > sourceIndex {
    //            //this means some service has been dragged from top to some place in bottom
    //            let replacement = selectedServices[sourceIndex]
    //            selectedServices[sourceIndex] = selectedServices[sourceIndex + 1]
    //            for index in sourceIndex + 1..<destinationIndex {
    //                selectedServices[index] = selectedServices[index + 1]
    //            }
    //            selectedServices[destinationIndex] = replacement
    //        }
    //        else {
    //            //this means some service has been dragged from bottom to some place in top
    //            let replacement = selectedServices[sourceIndex]
    //            selectedServices[sourceIndex] = selectedServices[sourceIndex - 1]
    //            for index in stride(from:sourceIndex - 1, to: destinationIndex, by: -1) {
    //                selectedServices[index] = selectedServices[index-1]
    //            }
    //            selectedServices[destinationIndex] = replacement
    //        }
    //        print("After rearrange data: \(selectedServices)")
    //    }
}
