//
//  DatePickerView.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 12/04/18.
//

import Foundation
import UIKit

class DatePickerView: NibView {
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var fromAndToDateControll: UISegmentedControl!
    var filterModule = FilterModule()
    var datePickerType : DateRequiredType = .SpecificDate
    init(frame: CGRect , filtermodule : FilterModule,fromdate : Date , todate : Date , fromToselectedIndex : Int , datePickertype : DateRequiredType) {
        super.init(frame: frame)
        self.layer.zPosition = CGFloat.Magnitude.greatestFiniteMagnitude
        setup(fromdate: fromdate, todate: todate, fromtoSelectedIndex: fromToselectedIndex , filtermodule: filtermodule , datePickertype: datePickertype)
        makeRoundedCorner()

    }
    func makeRoundedCorner()
    {
        self.layer.cornerRadius = 8
        self.layer.borderWidth = 2
        self.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.layer.masksToBounds = true
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.layer.shadowRadius = 5
        self.layer.shadowOpacity = Float(0.25)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setup(fromdate : Date , todate : Date , fromtoSelectedIndex : Int ,filtermodule : FilterModule , datePickertype : DateRequiredType  )
    {
        self.filterModule = filtermodule
        self.datePickerType = datePickertype
        if datePickerType == .SpecificDate
        {
            fromAndToDateControll.isUserInteractionEnabled = false
            fromAndToDateControll.selectedSegmentIndex = 0 // zero will be selected segment for specific date
        }
        else
        {
            fromAndToDateControll.selectedSegmentIndex = fromtoSelectedIndex
            fromAndToDateControll.isUserInteractionEnabled = true
        }
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        fromDate = fromdate
        toDate = todate
        
        if fromtoSelectedIndex == 0
        {
            datePicker.date = fromdate
            datePicker.minimumDate = nil
            datePicker.maximumDate = tempToDate
        }
        else
        {
            datePicker.date = todate
            datePicker.minimumDate = tempToDate
            datePicker.maximumDate = Date()
        }
    }
    var fromDate : Date = Date()
    {
        didSet{
            tempFromDate = fromDate
            datePicker.date = fromDate
        }
    }
    var toDate  :Date = Date()
    {
        didSet{
            tempToDate = toDate
            datePicker.date = toDate
        }
    }
    var tempFromDate : Date = Date(){
        didSet{
            if datePickerType == .SpecificDate
            {
                tempToDate = tempFromDate
            }
            
            let Display_fromdate = Date.display_Formate.string(from: tempFromDate)
            fromAndToDateControll.setTitle("From : \(Display_fromdate)", forSegmentAt: 0)
        }
    }
    var tempToDate  :Date = Date(){
        didSet{
            let Display_todate = Date.display_Formate.string(from: tempToDate)
            fromAndToDateControll.setTitle("To : \(Display_todate)", forSegmentAt: 1)
        }
    }
    @IBAction func didCancelTapped(_ sender: UIButton) {
        tempFromDate = fromDate
        tempToDate = toDate
        var selectedID1 = String()
        var selectedID2 = String()
        if datePickerType == .CustomRange
        {
            selectedID1 = Date.serverDateFormate.string(from: self.tempFromDate)
            selectedID2 =  Date.serverDateFormate.string(from: self.tempToDate)
        }
        else if datePickerType == .SpecificDate
        {
            selectedID1 = Date.serverDateFormate.string(from: self.tempFromDate)
            selectedID2 =  selectedID1
        }
        performUIUpdatesOnMain {
            self.filterModule.filterServerKey = FilterConstants.Keys.DateFilterKeys.FROM_DATE
            self.filterModule.filterServerKey_2 = FilterConstants.Keys.DateFilterKeys.TO_DATE
            // MARK:- for specific date both should be same
            self.filterModule.selectedFilterServerValue = selectedID1
            self.filterModule.selectedFilterServerValue_2 = selectedID2
            //enabling user interation
            let parentVC = self.getParentViewController()
            for viewController in (parentVC?.childViewControllers)!
            {
                if viewController is FilterViewController
                {
                    let filterVC = viewController as! FilterViewController
                    filterVC.view.isUserInteractionEnabled = true
                    filterVC.tableView.reloadData()
                }
            }
            for view in (parentVC?.view.subviews)!
            {
                if view.tag == 1212 //datePickBaseView
                {
                    view.removeFromSuperview()
                }
            }
            self.removeFromSuperview()
        }
    }
    @IBAction  func didOkButtonTapped(_ sender: UIButton) {
        fromDate = tempFromDate
        toDate = tempToDate
        var selectedID1 = String()
        var selectedID2 = String()
        if datePickerType == .CustomRange
        {
            selectedID1 = Date.serverDateFormate.string(from: self.fromDate)
            selectedID2 =  Date.serverDateFormate.string(from: self.toDate)
        }
        else if datePickerType == .SpecificDate
        {
            selectedID1 = Date.serverDateFormate.string(from: self.fromDate)
            selectedID2 =  selectedID1
        }
        performUIUpdatesOnMain {
            self.filterModule.filterServerKey = FilterConstants.Keys.DateFilterKeys.FROM_DATE
            self.filterModule.filterServerKey_2 = FilterConstants.Keys.DateFilterKeys.TO_DATE
            // MARK:- for specific date both should be same
            self.filterModule.selectedFilterServerValue = selectedID1
            self.filterModule.selectedFilterServerValue_2 = selectedID2
            //enabling user interation
            let parentVC = self.getParentViewController()
            for viewController in (parentVC?.childViewControllers)!
            {
                if viewController is FilterViewController
                {
                    let filterVC = viewController as! FilterViewController
                    filterVC.view.isUserInteractionEnabled = true
                    filterVC.tableView.reloadData()
                }
            }
            for view in (parentVC?.view.subviews)!
            {
                if view.tag == 1212 //datePickBaseView
                {
                    view.removeFromSuperview()
                }
            }
            self.removeFromSuperview()
        }
    }
    @IBAction  func fromAndToSelectionChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
            datePicker.date = tempFromDate
            datePicker.minimumDate = nil
            datePicker.maximumDate = tempToDate
            
        }
        else{
            datePicker.date = tempToDate
            datePicker.minimumDate = tempFromDate
            datePicker.maximumDate = Date()
        }
    }
    @IBAction   func didDateChangedInDatePicker(_ sender: UIDatePicker) {
        if fromAndToDateControll.selectedSegmentIndex == 0 //  from Date
        {
            tempFromDate = sender.date
        }
        else{
            tempToDate = sender.date
        }
    }
}

