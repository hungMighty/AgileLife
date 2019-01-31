//
//  QuestionTemplate.swift
//  AgileCheetah
//
//  Created by Mighty on 1/31/19.
//  Copyright © 2019 TeaBee. All rights reserved.
//

import Foundation

enum QuestionTemplate: Int {
    
    case easy = 0, medium, hard, psm1
    
    func name() -> String {
        switch self {
        case .easy:
            return "Agile Cheetah - Easy"
        case .medium:
            return "Agile Cheetah - Medium"
        case .hard:
            return "Agile Cheetah - Hard"
        case .psm1:
            return "PSM1"
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
    
    func background() -> String {
        switch self {
        case .easy:
            return "background_cheetah1"
        case .medium:
            return "background_cheetah3"
        case .hard:
            return "background_cheetah4"
        case .psm1:
            return ""
        }
    }
    
}

