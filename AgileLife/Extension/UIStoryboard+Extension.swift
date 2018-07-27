//
//  UIStoryboard+Extension.swift
//  AgileLife
//
//  Created by Tea Bee on 6/10/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import Foundation
import UIKit


extension UIStoryboard {
    
    static func viewController<T: UIViewController>(fromIdentifier identifier: String,
                                                    storyboard: String = "Main") -> T? {
        guard let view = UIStoryboard(name: storyboard, bundle: nil)
            .instantiateViewController(withIdentifier: identifier)
            as? T else {
                return nil
        }
        
        return view
    }
    
}
