//
//  CSVComponents.swift
//  AgileLife
//
//  Created by Ahri on 6/24/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import Foundation


enum CsvRow: Int, CustomStringConvertible {
    case question = 0
    case type = 1
    case firstAnswerOpt = 2
    case lastAnswerOpt = 7
    case correctResponse = 8
    case explanation = 9
    
    var description: String {
        return String(self.rawValue)
    }
}

enum QuestionType: Int {
    case multiChoice = 0,
    multiSelect
}

struct Alphabet {
    
    fileprivate static let all = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    static func from(index: Int) -> String {
        guard index >= 0, index < Alphabet.all.count else {
            return ""
        }
        
        let indexInAlphabet = Alphabet.all.index(Alphabet.all.startIndex, offsetBy: index)
        return String(Alphabet.all[indexInAlphabet])
    }
    
}
