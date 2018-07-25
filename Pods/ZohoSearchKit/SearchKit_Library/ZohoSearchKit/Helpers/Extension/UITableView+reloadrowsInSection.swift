//
//  UITableView+reloadrowsInSection.swift
//  ZohoSearchKit
//
//  Created by manikandan bangaru on 28/03/18.
//

import UIKit
extension UITableView{
    
    func reloadRowsInSection(section: Int, oldCount:Int, newCount: Int){
        
        let maxCount = max(oldCount, newCount)
        let minCount = min(oldCount, newCount)
        
        var changed = [IndexPath]()
        
        for i in minCount..<maxCount {
            let indexPath = IndexPath(row: i, section: section)
            changed.append(indexPath)
        }
        
        var reload = [IndexPath]()
        for i in 0..<minCount{
            let indexPath = IndexPath(row: i, section: section)
            reload.append(indexPath)
        }
        
        performUIUpdatesOnMain {
            self.beginUpdates()
            //equalize number of nows in section before reloading
            if(newCount > oldCount){
                self.insertRows(at: changed, with: .none)
            }else if(oldCount > newCount){
                self.deleteRows(at: changed, with: .none)
            }
            self.reloadRows(at: reload, with: .none)
            self.endUpdates()
        }
        
    }
}
