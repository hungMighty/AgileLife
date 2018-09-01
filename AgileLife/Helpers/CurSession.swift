//
//  CurSession.swift
//  AgileCheetah
//
//  Created by Ahri on 9/1/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import Foundation
import StoreKit


// MARK: Session Manager
class CurSession: NSObject {
    
    static let shared: CurSession = CurSession()
    
    fileprivate var userDefault: UserDefaults {
        return UserDefaults.standard
    }
    
    // Access Token
    private let numOfTimeUsesKey = "NumOfTimeUses"
    
    private var privateNumOfTimeUses: Int?
    fileprivate (set) var numOfTimeUses: Int {
        get {
            if self.privateNumOfTimeUses == nil {
                self.privateNumOfTimeUses = userDefault.integer(forKey: numOfTimeUsesKey)
            }
            
            if self.privateNumOfTimeUses == nil {
                return 0
            } else {
                return self.privateNumOfTimeUses!
            }
        }
        
        set(value) {
            privateNumOfTimeUses = value
            userDefault.set(value, forKey: numOfTimeUsesKey)
        }
    }
    
    
    // MARK: Init
    private override init() {
        super.init()
    }
    
    // MARK: Utility Functions
    
    func popUpRatingMenu() {
        numOfTimeUses = numOfTimeUses + 1
        
        print(numOfTimeUses)
        if numOfTimeUses == 1 || numOfTimeUses % 3 == 0 {
            if #available(iOS 10.3, *) {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
}

