//
//  UIView+Extension.swift
//  AgileLife
//
//  Created by Tea Bee on 6/10/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import Foundation
import UIKit


extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle.main.loadNibNamed(String(describing: T.self),
                                        owner: self,
                                        options: nil)![0] as! T
    }
    
    class func getNib() -> UINib {
        let identifier = String(describing: self)
        let nib = UINib(nibName: String(describing: identifier), bundle: nil)
        return nib
    }
    
}
