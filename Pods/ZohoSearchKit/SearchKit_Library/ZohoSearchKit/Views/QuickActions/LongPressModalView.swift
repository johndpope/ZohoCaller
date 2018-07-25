//
//  LongPressModalView.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 24/01/18.
//

import UIKit
import AudioToolbox
//Extention of Table View Controller for showing Modal View(elevated cell on long press gesture on result cell)
extension TableViewController{
    //to extend support for GCRectMake beyond swift 3
    private func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    //Taped outside the Quick Action Modal view or Action collection view
    @objc func dismissQuickActionModalView()
    {
        //mark action dialog hidden
        //reset the table view cell to actual table view cell frame.
        //remove hidden view from the view which is marked with tag
        let parent = self.getParentViewController()
        self.hiddenView.isHidden=true
        self.buttonview.isHidden=true
        parent?.view.viewWithTag(100)?.removeFromSuperview()
        parent?.view.viewWithTag(200)?.removeFromSuperview()
        self.longPressedSearchResultCell.frame = self.restoreResultCellRect
        self.tableView.reloadRows(at: [self.indexPath!], with: .fade)
        longPressGestureDetected = false
    }
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        //MARK: This gesture handler is intentionally using began state instead of using .ended or .recognized
        //because if we use .ended then it will show the quick action dialog only when user releases the touch
        //that looks bad in terms of user experience, for our quick action dialog it should just pop out when we do long press
        //so that user can release his/her finger from the screen
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began {
            
            let touchPoint = longPressGestureRecognizer.location(in: self.tableView)
            //if let indexPath = tableView.indexPathForRow(at: touchPoint), let serviceName = self.itemInfo.serviceName
            if let indexPath = tableView.indexPathForRow(at: touchPoint)
            {
                //MARK: When long press is done on the header view, it must be ignored.
                let headerViewFrame = self.tableView.rectForHeader(inSection: indexPath.section)
                if headerViewFrame.contains(touchPoint) {
                    return
                }
                //MARK:- for vibration
                AudioServicesPlaySystemSound(1520)
                //hidden view for the quick action dialog
                hiddenView=UIView()
                hiddenView.isHidden=false
                let parentView = self.getParentViewController()
                hiddenView.frame = (parentView?.view.frame)!
                hiddenView.layer.zPosition = ZpositionLevel.high.rawValue
                hiddenView.backgroundColor=UIColor.black
                hiddenView.alpha=0.8 //for transparent
                hiddenView.tag=100
                hiddenView.translatesAutoresizingMaskIntoConstraints = false
                let gesture=UITapGestureRecognizer(target: self,action:#selector(TableViewController.dismissQuickActionModalView))
                hiddenView.addGestureRecognizer(gesture)
                longPressedSearchResultCell.isHidden = false
                longPressedSearchResultCell.layer.allowsGroupOpacity=false
                let bg=UIView()
                bg.backgroundColor=UIColor.white
                tableView.cellForRow(at: indexPath)?.selectedBackgroundView=bg
                longPressedSearchResultCell=tableView.cellForRow(at: indexPath)!
                self.indexPath = indexPath
                longPressedSearchResultCell.alpha=1
                let cell=tableView.cellForRow(at: indexPath)!
                //This line awake from nib is very important to call
                //as if not called height of different labels and fields will
                //not be perfect and will screw the expand cell logic which
                //is highly dependent on height and width. And because this only
                //we had written force font setting like below in cells
                //wikiName.font = UIFont.systemFont(ofSize: 18, weight: .regular)
                cell.awakeFromNib()
                //backup Table cell frame for restoration after hiding the quick action dialog
                restoreResultCellRect = cell.frame
                let cellFrame = cell.frame
                let cellframY =  cellFrame.minY
                longPressedSearchResultCell.frame = CGRectMake( cellFrame.minX, cellframY, cellFrame.width,cellFrame.height)
                longPressedSearchResultCell.frame = (longPressedSearchResultCell.superview?.convert(longPressedSearchResultCell.frame, to: parentView?.view))!
                //MARK:- handling Invisible modalview
                updateInvisibleModalViewFrame(longPressedSearchResultCell)
                expandResultCell(cell: longPressedSearchResultCell as! SearchResultCell)
                updateInvisibleModalViewFrame(longPressedSearchResultCell)
                //restore the model view from expanded. Expand and shrink feature need the modal dialog view frame
                restoreQuickActionModalViewRect = longPressedSearchResultCell.frame
                buttonview.isHidden=false
                buttonview = UIImageView()
                buttonview.isOpaque=true //NO Transparent
                buttonview.backgroundColor=UIColor.white
                buttonview.frame = CGRectMake(cellFrame.minX + cellFrame.width - 60 - 4 ,(longPressedSearchResultCell.frame.minY - 66), 60, 60  )
                let image:UIImage = UIImage(named: "searchsdk-close", in: ZohoSearchKit.frameworkBundle, compatibleWith: nil)!
                buttonview.maskCircle(anyImage: image)
                parentView?.view.addSubview(self.hiddenView)
//                self.modalView.layer.cornerRadius = 6
                parentView?.view.addSubview(self.longPressedSearchResultCell)
                longPressedSearchResultCell.layer.zPosition = ZpositionLevel.maximum.rawValue

                //Quick Action Options
                performUIUpdatesOnMain {
                    self.beginAppearanceTransition(true, animated: true)
                    
                    let quickActionOptions :LongPressQuickActions = {
                        let frame:CGRect = self.CGRectMake(0, self.buttonview.frame.minY, self.view.frame.width, self.buttonview.frame.height)
                        let quickActions = LongPressQuickActions(frame: frame,indexPath :indexPath  ,current_Table : self)
                        return quickActions
                    }()
                    quickActionOptions.tag = 200
                    //MARK:- Adding Pop uP Animation
                    let target = quickActionOptions.center
                    let start = CGPoint(x: target.x ,y: (target.y + quickActionOptions.frame.height))
                    quickActionOptions.center = start
                    parentView?.view.addSubview(quickActionOptions)
                    UIView.animate(withDuration: 0.33, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10, options: UIViewAnimationOptions(rawValue: 0), animations: {
                        quickActionOptions.center  = target
                    }, completion: { (completed) in
                    })
                    self.endAppearanceTransition()
                }
            }
        }
        longPressGestureDetected = true
    }
    private func updateInvisibleModalViewFrame(_ longPressedSearchResultCell :UIView)
     {
        let modalViewHeight = longPressedSearchResultCell.frame.maxY
        let ScreenHeight = UIScreen.main.bounds.maxY
        if modalViewHeight > ScreenHeight
        {
            let diff = modalViewHeight - ScreenHeight
            longPressedSearchResultCell.frame = CGRectMake(longPressedSearchResultCell.frame.minX,  longPressedSearchResultCell.frame.minY - diff, longPressedSearchResultCell.frame.width, longPressedSearchResultCell.frame.height)
        }
    }
    private func updateQuickActionCellFrame(resultCell: UITableViewCell, heightToBeIncreased: CGFloat) {
        resultCell.frame = CGRect(origin: CGPoint(x: resultCell.frame.minX, y: resultCell.frame.minY), size: CGSize(width: resultCell.frame.width, height: resultCell.frame.height + heightToBeIncreased))
        resultCell.awakeFromNib()
    }
    private func expandResultCell(cell :SearchResultCell ) -> Void {
        
        //TODO: These constants will be exported to Constants
        cell.resultTitle.numberOfLines = 4
        cell.resultSubtitle.numberOfLines = 2
        
        let subjectFieldHeight = computeHeightValueForLabel(label: cell.resultTitle, maxNumberOfLinesToDisplay: CGFloat(cell.resultTitle.numberOfLines), isHighlightingEnabledForField: true)
        let senderFieldHeight = computeHeightValueForLabel(label: cell.resultSubtitle, maxNumberOfLinesToDisplay: CGFloat(cell.resultSubtitle.numberOfLines), isHighlightingEnabledForField: false)
        
        updateQuickActionCellFrame(resultCell: cell, heightToBeIncreased: subjectFieldHeight + senderFieldHeight)
    }
    private func computeHeightValueForLabel(label: UILabel, maxNumberOfLinesToDisplay: CGFloat, isHighlightingEnabledForField: Bool) -> CGFloat {
        let singleLineHeight = label.font.lineHeight
        var height = label.frame.height
        //when even plain text is set, attributed text will not be nil. So, whether highlighting is enabled is not should be checked
        //here we are checking whether globally highlighting is enabled or not and also whether specific label field is equiped with highlighting
        if isHighlightingEnabledForField, ZohoSearchKit.sharedInstance().resultsHighlightingEnabled {
            //respective label frame width not the table view cell.
            height = (label.attributedText?.height(withConstrainedWidth: label.frame.width))!
        }
        else {
            height = label.text!.height(withConstrainedWidth: label.frame.width, font: label.font)
        }
        
        let numOfLines = floor(height/singleLineHeight)
        
        if numOfLines > maxNumberOfLinesToDisplay {
            height = maxNumberOfLinesToDisplay * singleLineHeight
        }
        else {
            height = singleLineHeight * numOfLines
        }
        
        //as one line height is already part of the cell frame height, so should be substracted from height to be increased
        height = height - singleLineHeight
        
        return height
    }

    //TODO: to be removed as code has been duplicated
    // resize the modal view frame with updated height needed to render max supported lines.
    // MARK: proper computaion is very very important, otherwise view might break on different devices
    private func resizeModalFrame(resultCell: UITableViewCell, maxNumOfLines: CGFloat, estimatedHeight: CGFloat, heightForSingleLine: CGFloat) {
        //this can be in common function other can be in one logic
        var height = estimatedHeight
        let numOfLines = floor(height/heightForSingleLine)
        
        if numOfLines > maxNumOfLines {
            height = maxNumOfLines * heightForSingleLine
        }
        else {
            height = heightForSingleLine * numOfLines
        }
        
        //as one line height is already part of the cell frame height, so should not be added
        height = height - heightForSingleLine
        
        resultCell.frame = CGRect(origin: CGPoint(x: resultCell.frame.minX, y: resultCell.frame.minY), size: CGSize(width: resultCell.frame.width, height: resultCell.frame.height + height))
        resultCell.awakeFromNib()
    }
}
