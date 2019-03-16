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
            self.PSMD.rawValue, self.PSME.rawValue
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
            return ""
        case .PSMA:
            return "Udemy Scrum Master (PSM1) Exam Prep - Pass on your FIRST try! - PT1 PSM1 Series 3"
        case .PSMB:
            return "Udemy Scrum Master (PSM1) Exam Prep - Pass on your FIRST try! - PT2 PSM1 Series 3"
        case .PSMC:
            return "Udemy Scrum Master (PSM1) Exam Prep - Pass on your FIRST try! - PT3 PSM1 Series 3"
        case .PSMD:
            return "Udemy Scrum Master (PSM1) Exam Prep - Pass on your FIRST try! - PT4 PSM1 Series 3"
        case .PSME:
            return "Udemy Scrum Master (PSM1) Exam Prep - Pass on your FIRST try! - PT5 PSM1 Series 3 (Random)"
        case .PSMF:
            return ""
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

