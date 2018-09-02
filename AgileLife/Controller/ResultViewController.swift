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
        
        CurSession.shared.popUpRatingMenu()
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
        var shareContents: [Any] = []
        
        shareContents.append("Ready to gain more Agile knowledge and challenge yourself with Agile Cheetah?\n")
        if let url = URL(string: "https://itunes.apple.com/us/app/agile-cheetah/id1429878591") {
            shareContents.append(url)
        }
        
        if shareContents.count == 0 { return }
        
        let copyLinkActivity = CopyLinkActivity()
        
        let activityView = UIActivityViewController(
            activityItems: shareContents, applicationActivities: [copyLinkActivity]
        )
        
        activityView.excludedActivityTypes = [
            .airDrop, .assignToContact, .saveToCameraRoll,
            .print, .copyToPasteboard,
            .addToReadingList, .openInIBooks,
            .postToVimeo, .postToWeibo, .postToFlickr,
        ]
        
        if let popover = activityView.popoverPresentationController {
            popover.barButtonItem = self.navigationItem.rightBarButtonItem
            popover.permittedArrowDirections = .up
        }
        
        activityView.completionWithItemsHandler = { (activity, success, items, error) in
        }
        
        self.present(activityView, animated: true, completion: nil)
    }
    
}

// MARK: UI Logic
extension ResultViewController {
    
}

