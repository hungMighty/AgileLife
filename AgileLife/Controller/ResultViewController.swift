//
//  ResultViewController.swift
//  AgileLife
//
//  Created by Ahri on 7/27/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit
import StoreKit
import Social


class ResultViewController: UIViewController {

    @IBOutlet weak var percentLb: UILabel!
    @IBOutlet weak var numOutOfLb: UILabel!
    @IBOutlet weak var shareAppBtn: RoundBtn!
    
    
    var questionTemplate: QuestionTemplate = .easy
    var totalQuestions = 0
    var numOfCorrectAnswers = 0
    
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UIApplication.shared.statusBarStyle = .lightContent
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.title = " "
        
        shareAppBtn.layer.cornerRadius = 8
        shareAppBtn.backgroundColor = UIColor(red: 224, green: 238, blue: 252)
        shareAppBtn.setTitleColor(UIColor.black, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let percentage = Int(CGFloat(numOfCorrectAnswers) / CGFloat(totalQuestions) * 100)
        
        percentLb.text = "\(percentage)%"
        numOutOfLb.text = "\(numOfCorrectAnswers) out of \(totalQuestions)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        CurSession.shared.popUpRatingMenu()
    }
    
    // MARK: - Actions
    @IBAction func backToMenuTap(_ sender: Any) {
        guard let view = self.navigationController?.viewControllers.first
            as? HomeViewController else {
                return
        }
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
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
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.setViewControllers(vcArray, animated: true)
    }
    
    @IBAction func shareAppTap(_ sender: Any) {
        
    }
    
}

// MARK: UI Logic
extension ResultViewController {
    
}

