//
//  RoundBtn.swift
//  AgileLife
//
//  Created by Ahri on 7/27/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import Foundation
import UIKit


class RoundBtn: UIButton {
    
    fileprivate let btnBackground = UIColor(red: 76, green: 163, blue: 218)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 4
        self.setTitleColor(UIColor.white, for: .normal)
        self.backgroundColor = btnBackground
    }
    
}
