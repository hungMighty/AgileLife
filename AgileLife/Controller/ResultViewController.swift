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
    
    var questionTemplate: QuestionTemplate = .easy
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
        guard let view = self.navigationController?.viewControllers.first
            as? HomeViewController else {
                return
        }
        
        self.navigationController?.popToViewController(view, animated: true)
    }
    
    @IBAction func restartTap(_ sender: Any) {
        guard let homeView = self.navigationController?.viewControllers.first
            as? HomeViewController else {
                return
        }
        
        guard var vcArray = self.navigationController?.viewControllers,
            let quizzView = UIStoryboard.viewController(
                fromIdentifier: QuizzViewController.className())
                as? QuizzViewController else {
                    return
        }
        
        quizzView.questionTemplate = self.questionTemplate
        vcArray = [homeView]
        vcArray.append(quizzView)
        self.navigationController?.setViewControllers(vcArray, animated: true)
    }
    
}
