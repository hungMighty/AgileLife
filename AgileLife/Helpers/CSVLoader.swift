//
//  CSVLoader.swift
//  AgileLife
//
//  Created by Ahri on 6/24/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import Foundation


class CSVLoader {
    
    static func readFrom(fileName: String) -> CSwiftV? {
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: "csv") else {
            return nil
        }
        
        do {
            let csvString = try String(contentsOfFile: filepath, encoding: .utf8)
            let contents = CSwiftV(with: csvString)
            return contents
            
        } catch {
            print("File Read Error for file \(filepath)")
        }
        
        return nil
    }
    
}

