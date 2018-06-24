//
//  IntExtension.swift
//  Restaurant
//
//  Created by Thu Le on 9/20/16.
//  Copyright © 2016 TechLove. All rights reserved.
//

import UIKit

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }

    static func randomInt(lowerBound: Int, upperBound: Int) -> Int {
        return lowerBound + Int(arc4random_uniform(UInt32(upperBound - lowerBound)))
    }
}

extension Double {
    func format(f: String) -> String {
        return String(format: "%\(f)f", self)
    }
}

struct Number {
    static let formatterWithSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var stringFormattedWithSeparator: String {
        return Number.formatterWithSeparator.string(from: self as! NSNumber) ?? ""
    }
}
