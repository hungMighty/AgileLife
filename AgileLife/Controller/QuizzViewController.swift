//
//  QuizzViewController.swift
//  AgileLife
//
//  Created by Tea Bee on 6/10/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit


class QuizzViewController: UIViewController {

    @IBOutlet weak var tapToContinueView: UIView!
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLb: UILabel!
    @IBOutlet weak var answersTable: UITableView!
    
    fileprivate var csv: CSwiftV?
    fileprivate var curQuestionRow = [String]()
    fileprivate var possibleAnswers = [String]()
    fileprivate var correctAnswerIndex: Int?
    
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        csv = CSVLoader.readFrom(fileName: "PSPO-Open-Assessment-1")
        randomizeQuestionAndReload()
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
    
    @objc func tapToContinue() {
        tapToContinueView.isHidden = true
        view.sendSubview(toBack: tapToContinueView)
        randomizeQuestionAndReload()
    }
    
}

// MARK: - Setup UI
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
        
        tapToContinueView.isHidden = true
        self.view.sendSubview(toBack: tapToContinueView)
        tapToContinueView.addGestureRecognizer(UITapGestureRecognizer(
            target: self, action: #selector(QuizzViewController.tapToContinue))
        )
    }
    
}

// MARK: - UI Logic
extension QuizzViewController {
    
    fileprivate func randomizeQuestionAndReload() {
        guard let csv = self.csv else {
            return
        }
        
        let index = Int.randomInt(lowerBound: 0, upperBound: csv.rows.count)
        curQuestionRow = csv.rows[index]
        mapPossibleAnswers()
        
        if let index = Int(curQuestionRow[CsvRow.correctResponse.rawValue]) {
            correctAnswerIndex = index - 1
        }
        
        // Reload UI
        questionLb.text = curQuestionRow[CsvRow.question.rawValue]
        answersTable.reloadData(
            with: .simple(
                duration: 0.65, direction: .rotation3D(type: .doctorStrange),
                constantDelay: 0
            )
        )
    }
    
    fileprivate func mapPossibleAnswers() {
        possibleAnswers = [String]()
        
        for i in
            CsvRow.firstAnswerOpt.rawValue...CsvRow.lastAnswerOpt.rawValue {
                let answer = curQuestionRow[i]
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
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? AnswerCellTypeOne,
            let correctAnswerIndex = self.correctAnswerIndex else {
                
                randomizeQuestionAndReload()
                return
        }
        
        var isCorrect: Bool
        if correctAnswerIndex == indexPath.row {
            isCorrect = true
        } else {
            isCorrect = false
        }
        
        selectedCell.displayMark(isCorrect: isCorrect) {
            guard let correctAnswerIndex = self.correctAnswerIndex,
                let correctCell = tableView.cellForRow(
                    at: IndexPath(row: correctAnswerIndex, section: 0))
                    as? AnswerCellTypeOne else {
                        return
            }
            
            if isCorrect == false {
                selectedCell.highlight(isCorrect: false)
            }
            correctCell.highlight(isCorrect: true)
            self.tapToContinueView.isHidden = false
            self.view.bringSubview(toFront: self.tapToContinueView)
        }
    }
    
}

