//
//  LbWithBackground.swift
//  AgileLife
//
//  Created by Ahri on 7/27/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import Foundation
import UIKit


class LbWithBackground: UILabel {
    
    let padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = themeColor
        self.textColor = UIColor.white
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 8
    }
    
    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: UIEdgeInsetsInsetRect(rect, padding))
    }
    
}

