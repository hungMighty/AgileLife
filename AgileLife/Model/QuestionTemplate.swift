//
//  QuestionTemplate.swift
//  AgileCheetah
//
//  Created by Mighty on 1/31/19.
//  Copyright © 2019 TeaBee. All rights reserved.
//

import Foundation

enum QuestionTemplate: String {
    
    case easy, medium, hard, COMBO1, PSMA, PSMB, PSMC, PSMD, PSME, PSMF
    
    init(index: Int) {
        switch index {
        case 1:
            self = .medium
        case 2:
            self = .hard
        default:
            self = .easy
        }
    }
    
    static var storeProductIDs: Set<ProductIdentifier> {
        let productIdsSet: Set<ProductIdentifier> = [
            self.COMBO1.rawValue,
            self.PSMA.rawValue, self.PSMB.rawValue, self.PSMC.rawValue,
            self.PSMD.rawValue, self.PSME.rawValue, self.PSMF.rawValue
        ]
        return productIdsSet
    }
    
    func csvName() -> String {
        switch self {
        case .easy:
            return "Agile Cheetah - Easy"
        case .medium:
            return "Agile Cheetah - Medium"
        case .hard:
            return "Agile Cheetah - Hard"
        
        case .COMBO1:
            return "Udemy PSM1 Series 2"
        case .PSMA:
            return "Udemy PSM1 Series 2"
        case .PSMB:
            return "PT2 PSM1 Series 2"
        case .PSMC:
            return "PT3 PSM1 Series 2"
        case .PSMD:
            return "PT4 PSM1 Series 2"
        case .PSME:
            return "PT5 PSM1 Series 2"
        case .PSMF:
            return "PT6 PSM1 Series 2"
        }
    }
    
    func limit() -> Int? {
        switch self {
        case .easy:
            return nil
        case .medium:
            return nil
        case .hard:
            return nil
        default:
            return nil
        }
    }
    
    func backgroundImg() -> String {
        switch self {
        case .easy:
            return "background_cheetah1"
        case .medium:
            return "background_cheetah3"
        case .hard:
            return "background_cheetah4"
            
        default:
            return ""
        }
    }
    
}

