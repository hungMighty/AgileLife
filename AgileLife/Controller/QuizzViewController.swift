//
//  QuizzViewController.swift
//  AgileLife
//
//  Created by Tea Bee on 6/10/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit


class QuizzViewController: UIViewController {

    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLb: UILabel!
    @IBOutlet weak var answersTable: UITableView!
    
    
    var csv: CSwiftV?
    var curQuestionSet = [String]()
    var possibleAnswers = [String]()
    
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        csv = CSVLoader.readFrom(fileName: "PSPO-Open-Assessment-1")
        randomizeQuestion()
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

// MARK: - UI Logic
extension QuizzViewController {
    
    fileprivate func setupUI() {
        questionContainerView.layer.masksToBounds = true
        questionContainerView.layer.cornerRadius = 15
        questionContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        answersTable.showsVerticalScrollIndicator = false
        answersTable.separatorStyle = .none
        answersTable.backgroundColor = UIColor.clear
        answersTable.estimatedRowHeight = 200
        answersTable.register(AnswerCellTypeOne.getNib(),
                              forCellReuseIdentifier: AnswerCellTypeOne.className())
    }
    
    fileprivate func randomizeQuestion() {
        guard let csv = self.csv else {
            return
        }
        
        let index = Int.randomInt(lowerBound: 0, upperBound: csv.rows.count)
        curQuestionSet = csv.rows[index]
        mapAnswers()
        
        // Reload UI
        questionLb.text = curQuestionSet[CsvRow.question.rawValue]
        answersTable.reloadData(
            with: .simple(
                duration: 0.65, direction: .rotation3D(type: .doctorStrange),
                constantDelay: 0
            )
        )
    }
    
    fileprivate func mapAnswers() {
        possibleAnswers = [String]()
        
        for i in
            CsvRow.firstAnswerOpt.rawValue...CsvRow.lastAnswerOpt.rawValue {
                let answer = curQuestionSet[i]
                if answer.isEmpty == false {
                    possibleAnswers.append(answer)
                }
        }
    }
    
}

// MARK: - UITableViewDataSource
extension QuizzViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleAnswers.count
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
        
        cell.answerSymbolLb.text = Alphabet.from(index: indexPath.row)
        cell.answerLb.text = possibleAnswers[indexPath.row]
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension QuizzViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        randomizeQuestion()
    }
    
}

