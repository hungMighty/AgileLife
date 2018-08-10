//
//  ResultViewController.swift
//  AgileLife
//
//  Created by Ahri on 7/27/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var percentLb: UILabel!
    @IBOutlet weak var numOutOfLb: UILabel!
    
    
    var totalQuestions = 0
    var numOfCorrectAnswers = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = " "
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let percentage = Int(CGFloat(numOfCorrectAnswers) / CGFloat(totalQuestions) * 100)
        
        percentLb.text = "\(percentage)%"
        numOutOfLb.text = "\(numOfCorrectAnswers) out of \(totalQuestions)"
    }
    
    @IBAction func backToMenuTap(_ sender: Any) {
        
    }
    
    @IBAction func restartTap(_ sender: Any) {
        
    }
    
}
