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
    @IBOutlet weak var nextBtnView: UIView!
    @IBOutlet weak var nextBtnViewHeight: NSLayoutConstraint!
    
    fileprivate var csv: CSwiftV?
    fileprivate var curQuestionRow = [String]()
    fileprivate var possibleAnswers = [String]()
    fileprivate var correctAnswerIndexes: [Int]?
    fileprivate var selectedIndexPaths: [IndexPath]?
    
    
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
        nextBtnViewHeight.constant = 0
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
        
        nextBtnViewHeight.constant = 0
        nextBtnView.roundCorners([.topLeft, .topRight], radius: 15)
        nextBtnView.addGestureRecognizer(UITapGestureRecognizer(
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
        parseCorrectAnswerIndexes()
        
        // Reload UI
        questionLb.text = curQuestionRow[CsvRow.question.rawValue]
        answersTable.reloadData(
            with: .simple(
                duration: 0.65, direction: .rotation3D(type: .doctorStrange),
                constantDelay: 0
            )
        )
        selectedIndexPaths = [IndexPath]()
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
    
    fileprivate func parseCorrectAnswerIndexes() {
        let strValues = curQuestionRow[CsvRow.correctResponse.rawValue]
            .split(separator: ",")
            .map{ String($0) }
        
        correctAnswerIndexes = [Int]()
        correctAnswerIndexes = strValues
            .compactMap{ Int($0) }.map { $0 - 1 }
    }
    
    fileprivate func handleCellSelection(selectedCell: AnswerCellTypeOne,
                                         at indexPath: IndexPath) {
        if self.selectedIndexPaths?.contains(indexPath) == false {
            self.selectedIndexPaths?.append(indexPath)
            
            if self.correctAnswerIndexes != nil &&
                self.correctAnswerIndexes!.count >= 2 {
                
                selectedCell.highlightForMulChoices(
                    color: UIColor(red: 80, green: 208, blue: 255)
                )
            }
        } else {
            selectedCell.highlightForMulChoices()
            if let index = selectedIndexPaths?.index(of: indexPath) {
                selectedIndexPaths?.remove(at: index)
            }
            return
        }
        
        guard let selectedCellIndexPaths = self.selectedIndexPaths,
            let correctAnswerIndexes = self.correctAnswerIndexes,
            selectedCellIndexPaths.count == correctAnswerIndexes.count else {
                return
        }
        
        for i in 0..<selectedCellIndexPaths.count {
            let curIndexPath = selectedCellIndexPaths[i]
            let selectedCell = self.answersTable.cellForRow(
                at: curIndexPath
            ) as! AnswerCellTypeOne
            
            var isCorrect: Bool
            if correctAnswerIndexes.contains(curIndexPath.row) {
                isCorrect = true
            } else {
                isCorrect = false
            }
            
            selectedCell.highlightForMulChoices()
            selectedCell.displayMark(isCorrect: isCorrect) {
                if i == selectedCellIndexPaths.count - 1 {
                    self.highlightAnswerCells()
                }
            }
        }
    }
    
    fileprivate func highlightAnswerCells() {
        guard let correctAnswerIndexes = self.correctAnswerIndexes,
            let selectedIndexPaths = self.selectedIndexPaths,
            correctAnswerIndexes.count == selectedIndexPaths.count else {
                return
        }
        
        correctAnswerIndexes.forEach {
            if let correctCell = self.answersTable.cellForRow(
                at: IndexPath(row: $0, section: 0)
                ) as? AnswerCellTypeOne {
                
                correctCell.highlight(isCorrect: true)
            }
        }
        
        nextBtnViewHeight.constant = 60
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
            let _ = self.correctAnswerIndexes else {
                
                randomizeQuestionAndReload()
                return
        }
        
        handleCellSelection(selectedCell: selectedCell, at: indexPath)
    }
    
}

