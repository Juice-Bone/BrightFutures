//
//  Semaphore.swift
//  BrightFutures
//
//  Created by Thomas Visser on 17/01/15.
//  Copyright (c) 2015 Thomas Visser. All rights reserved.
//

import Foundation

public enum TimeInterval {
    case Forever
    case In(NSTimeInterval)
}

/**
 * A tiny wrapper around dispatch_semaphore
 */
public class Semaphore {
    
    private var semaphore: dispatch_semaphore_t
    
    public init(value: Int) {
        self.semaphore = dispatch_semaphore_create(value)
    }
    
    public convenience init() {
        self.init(value: 1)
    }
    
    public func wait() {
        self.wait(.Forever)
    }
    
    public func wait(timeout: TimeInterval) {
        let dispatchTimeout: dispatch_time_t = {
            switch timeout {
            case .Forever:
                return DISPATCH_TIME_FOREVER
            case .In(let interval):
                return dispatch_time(DISPATCH_TIME_NOW, Int64(interval * NSTimeInterval(NSEC_PER_SEC)))
            }
        }()
        
        dispatch_semaphore_wait(self.semaphore, dispatchTimeout)
    }
    
    public func signal() {
        dispatch_semaphore_signal(self.semaphore)
    }
}