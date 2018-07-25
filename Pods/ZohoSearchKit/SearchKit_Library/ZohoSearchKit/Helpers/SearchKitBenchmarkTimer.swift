//
//  SearchKitBenchmarkTimer.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 16/01/18.
//  Copyright © 2018 hemant kumar s. All rights reserved.
//

import Foundation

// Make sure the Timer is used during development debugging only not in the release app.
class SearchKitBenchmarkTimer {
    
    var startTime: DispatchTime?
    var endTime: DispatchTime?
    
    init() {
        start()
    }
    
    func start() {
        startTime = DispatchTime.now()
    }
    
    //Stop the timer and also return the time taken in millis
    func stop() -> Double {
        endTime = DispatchTime.now()
        return duration(devisor: 1_000_000)!
    }
    
    func stopAndTimeTakenInNanoSeconds() -> Double {
        endTime = DispatchTime.now()
        return duration(devisor: 1_000)!
    }
    
    func stopAndTimeTakenInSeconds() -> Double {
        endTime = DispatchTime.now()
        return duration(devisor: 1_000_000_000)!
    }
    
    func duration(devisor: Int64) -> Double? {
        if let endTime = endTime {
            let nanoTime = endTime.uptimeNanoseconds - (startTime?.uptimeNanoseconds)! //Difference in nano seconds (UInt64)
            let timeIntervalInMillis = Double(nanoTime) / Double(devisor) //divide to compute time taken in millis, or nanos or seconds
            return timeIntervalInMillis
        } else {
            return nil
        }
    }
}
