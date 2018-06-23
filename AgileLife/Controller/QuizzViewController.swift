//
//  QuizzViewController.swift
//  AgileLife
//
//  Created by Tea Bee on 6/10/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit

class QuizzViewController: UIViewController {

    @IBOutlet weak var questionNumLb: UILabel!
    @IBOutlet weak var progressBarView: UIView!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var answersTable: UITableView!
    
    @IBOutlet weak var prevQuestionBtn: UIButton!
    @IBOutlet weak var nextQuestionBtn: UIButton!
    
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        progressBarView.layer.masksToBounds = true
        progressBarView.layer.cornerRadius = progressBarView.bounds.height / 2
        progressBarView.backgroundColor = UIColor.white
        
        questionContainerView.layer.masksToBounds = true
        questionContainerView.layer.cornerRadius = 15
        questionContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        answersTable.separatorStyle = .none
        answersTable.backgroundColor = UIColor.clear
        answersTable.estimatedRowHeight = 200
        answersTable.register(AnswerCellTypeOne.getNib(),
                              forCellReuseIdentifier: AnswerCellTypeOne.className())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IB Actions
    
    @IBAction func prevQuestionBtnTouch(_ sender: Any) {
    }
    
    @IBAction func nextQuestionBtnTouch(_ sender: Any) {
    }
    
}


// MARK: - UITableViewDataSource
extension QuizzViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView
            .dequeueReusableCell(withIdentifier: AnswerCellTypeOne.className(),
                                 for: indexPath)
            as? AnswerCellTypeOne else {
                return UITableViewCell()
        }
        
        cell.answerSymbolLb.text = "A"
        cell.answerLb.text = "Whale \nWhale"
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension QuizzViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        answersTable.reloadData(
            with: .simple(
                duration: 0.65, direction: .rotation3D(type: .doctorStrange),
                constantDelay: 0
            )
        )
    }
    
}

