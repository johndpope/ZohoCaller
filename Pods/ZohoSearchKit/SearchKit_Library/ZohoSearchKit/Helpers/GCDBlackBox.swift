//
//  GCDBlackBox.swift
//  ZohoSearchAppTwo
//
//  Created by hemant kumar s. on 18/12/17.
//  Copyright © 2017 hemant kumar s. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}

func runHighPriorityAsyncTask(_ updates: @escaping () -> Void)  {
    DispatchQueue.global(qos: .userInteractive).async {
        updates()
    }
}

func runNormalPriorityAsyncTask(_ updates: @escaping () -> Void)  {
    DispatchQueue.global(qos: .default).async {
        updates()
    }
}

func runBackgroundPriorityAsyncTask(_ updates: @escaping () -> Void)  {
    DispatchQueue.global(qos: .background).async {
        updates()
    }
}

func runLowPriorityAsyncTask(_ updates: @escaping () -> Void)  {
    DispatchQueue.global(qos: .utility).async {
        updates()
    }
}
