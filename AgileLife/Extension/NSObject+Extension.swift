//
//  NSObject+Extension.swift
//  AgileLife
//
//  Created by Tea Bee on 6/10/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import Foundation


extension NSObject {
    
    static func className() -> String {
        return String(describing: self)
    }
    
}
