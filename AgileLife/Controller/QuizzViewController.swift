//
//  QuizzViewController.swift
//  AgileLife
//
//  Created by Tea Bee on 6/10/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit


class QuizzViewController: UIViewController {

    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var questionContainerView: UIView!
    @IBOutlet weak var questionLb: UILabel!
    @IBOutlet weak var numOfChoicesToSelectLb: LbWithBackground!
    
    @IBOutlet weak var choicesTable: UITableView!
    
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var nextBtnImage: UIImageView!
    @IBOutlet weak var tipImage: UIImageView!
    @IBOutlet weak var tipView: UIView!
    
    
    // Constraints
    @IBOutlet weak var nextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tipViewHeight: NSLayoutConstraint!
    
    
    // ViewControllers
    var tipViewController: TipViewController?
    
    // UI Objs
    var scoreBtn = UIButton()
    
    
    fileprivate var csv: CSwiftV?
    var questionTemplate: QuestionTemplate = .easy
    fileprivate var numOfQuestionsToBeLoaded = 0
    
    fileprivate var curQuestionData = [String]()
    fileprivate var curQuestionIndex = 0
    fileprivate var availableChoices = [String]()
    fileprivate var answerIndexes = [Int]()
    
    
    fileprivate var isMultipleChoice = false
    fileprivate var areAnswersBeingDisplayed: Bool = false
    fileprivate var selectedIndexes = [Int]()
    
    fileprivate var scores = 0
    
    // Width and Height
    fileprivate let nextViewNormalHeight: CGFloat = 60
    fileprivate let hintHeight: CGFloat = 200
    
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        csv = CSVLoader.readFrom(fileName: questionTemplate.name())
        numOfQuestionsToBeLoaded = questionTemplate.limit() ?? csv?.rows.count ?? 1
        loadNextQuestion()
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
        loadNextQuestion()
    }
    
    @objc func tapToShowTip() {
        guard let tipView = tipViewController, (tipView.textHint.isEmpty == false) else {
            return
        }
        
        view.layoutIfNeeded()
        if self.tipViewHeight.constant == 0 {
            self.tipViewHeight.constant = self.hintHeight
        } else {
            self.tipViewHeight.constant = 0
        }
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
}

// MARK: - Setup UI
extension QuizzViewController {
    
    fileprivate func setupUI() {
        // Right navigation item
        scoreBtn.setTitle("Score: 0", for: .normal)
        scoreBtn.isUserInteractionEnabled = false
        scoreBtn.setTitleColor(UIColor(red: 60, green: 136, blue: 246), for: .normal)
        
        let barButton = UIBarButtonItem.init(customView: scoreBtn)
        self.navigationItem.rightBarButtonItem = barButton
        
        // Progress bar for title
        progressView.progressTintColor = UIColor.green
        progressView.transform = CGAffineTransform(scaleX: 1, y: 4)
        
        // Question View
        questionContainerView.layer.masksToBounds = true
        questionContainerView.layer.cornerRadius = 15
        questionContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        // Answers Table
        choicesTable.showsVerticalScrollIndicator = false
        choicesTable.separatorStyle = .none
        choicesTable.backgroundColor = UIColor.clear
        choicesTable.estimatedRowHeight = 200
        choicesTable.rowHeight = UITableViewAutomaticDimension
        choicesTable.register(
            ChoiceCell.getNib(),
            forCellReuseIdentifier: ChoiceCell.className()
        )
        
        // Next View
        nextViewHeight.constant = 0
        nextView.roundCorners([.topLeft, .topRight], radius: 15)
        
        nextBtnImage.isUserInteractionEnabled = true
        tipImage.isUserInteractionEnabled = true
        
        nextBtnImage.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self, action: #selector(QuizzViewController.tapToContinue)
            )
        )
        tipImage.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self, action: #selector(QuizzViewController.tapToShowTip)
            )
        )
    }
    
    fileprivate func pulseTipIcon() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.duration = 0.7
        animation.repeatCount = Float.infinity
        animation.autoreverses = true
        animation.fromValue = 1.0
        animation.toValue = 0.7
        animation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        
        tipImage.layer.add(animation, forKey: "animateOpacity")
    }
    
}

// MARK: - UI Logic
extension QuizzViewController {
    
    fileprivate func loadNextQuestion() {
        guard let csv = self.csv, curQuestionIndex < numOfQuestionsToBeLoaded else {
            
            // Reach the end -> Show Result Scene
            if let view = UIStoryboard.viewController(
                fromIdentifier: ResultViewController.className())
                as? ResultViewController {
                
                view.questionTemplate = questionTemplate
                view.totalQuestions = numOfQuestionsToBeLoaded
                view.numOfCorrectAnswers = scores
                
                self.navigationController?.pushViewController(view, animated: true)
            }
            
            return
        }
        
        
        // Reset flags
        areAnswersBeingDisplayed = false
        selectedIndexes = [Int]()
        
        // Setup for next question
        curQuestionData = csv.rows[curQuestionIndex]
        mapAvailableChoices()
        parseAnswerIndexes()
        
        // Reload UI
        self.title = "\(curQuestionIndex + 1) / \(numOfQuestionsToBeLoaded)"
        progressView.setProgress(
            Float(curQuestionIndex + 1) / Float(numOfQuestionsToBeLoaded),
            animated: true
        )
        
        questionLb.text = curQuestionData[CsvRow.question.rawValue]
        
        let numOfChoicesToSelect = "Select \(answerIndexes.count)"
        numOfChoicesToSelectLb.text = numOfChoicesToSelect
        
        choicesTable.allowsSelection = true
        
        UIView.animate(withDuration: 0.2,
                       animations: {
                        self.choicesTable.scrollToRow(
                            at: IndexPath(row: 0, section: 0),
                            at: .top, animated: false
                        )
        }) { (isComplete) in
            self.choicesTable.reloadData(
                with: .simple(
                    duration: 0.65, direction: .rotation3D(type: .doctorStrange),
                    constantDelay: 0
                )
            )
        }

        
        nextViewHeight.constant = 0
        tipViewHeight.constant = 0
        tipImage.layer.removeAllAnimations()
        
        let txtHint = curQuestionData[CsvRow.explanation.rawValue]
        if let view = tipViewController,
            txtHint.isEmpty == false {
            
            view.textHint = txtHint
            pulseTipIcon()
        }
        
        // Index to next question
        curQuestionIndex += 1
    }
    
    fileprivate func mapAvailableChoices() {
        availableChoices = [String]()
        
        for i in CsvRow.firstAnswerOpt.rawValue...CsvRow.lastAnswerOpt.rawValue {
            let choice = curQuestionData[i]
            if choice.isEmpty == false {
                availableChoices.append(choice)
            }
        }
    }
    
    fileprivate func parseAnswerIndexes() {
        let strValues = curQuestionData[CsvRow.correctResponse.rawValue]
            .split(separator: ",").map{ String($0) }
        
        answerIndexes = [Int]()
        answerIndexes = strValues.compactMap{ Int($0) }.map { $0 - 1 }
        
        isMultipleChoice = false
        if answerIndexes.count > 1 {
            isMultipleChoice = true
        }
    }
    
    fileprivate func handleCellTap(cell: ChoiceCell,
                                   at indexPath: IndexPath) {
        
        // Add or remove currently Selected Cells
        if self.selectedIndexes.contains(indexPath.row)  {
            cell.highlight(option: .unselected)
            if let index = selectedIndexes.index(of: indexPath.row) {
                selectedIndexes.remove(at: index)
            }
            
            return
            
        } else {
            self.selectedIndexes.append(indexPath.row)
            
            if isMultipleChoice {
                cell.highlight(option: .selected)
            }
        }
        
        // Select enough -> Trigger marking process
        guard selectedIndexes.count == answerIndexes.count else {
            return
        }
        
        areAnswersBeingDisplayed = true
        choicesTable.allowsSelection = false
        
        selectedIndexes.enumerated().forEach { tuple in
            guard let cell = self.choicesTable.cellForRow(
                at: IndexPath(row: tuple.element, section: 0)) as? ChoiceCell else {
                    return
            }
            
            cell.highlight(option: .unselected)
            
            cell.showMarkingIcon(isCorrect: answerIndexes.contains(tuple.element)) {
                // Finish marking process
                if tuple.offset == self.selectedIndexes.count - 1 {
                    self.highlightAnswerCells()
                }
            }
        }
    }
    
    fileprivate func highlightAnswerCells() {
        let selectedCellsMatchAnswers = selectedIndexes
            .filter{ answerIndexes.contains($0) }
            .count == answerIndexes.count
        if selectedCellsMatchAnswers {
            scores += 1
            scoreBtn.setTitle("Score: \(scores)", for: .normal)
        }
        
        answerIndexes.forEach {
            if let cell = self.choicesTable.cellForRow(
                at: IndexPath(row: $0, section: 0)) as? ChoiceCell {
                
                cell.highlight(option: .answer)
            }
        }
        
        nextViewHeight.constant = nextViewNormalHeight
    }
    
}

// MARK: - Routers
extension QuizzViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tipView = segue.destination as? TipViewController {
            self.tipViewController = tipView
        }
    }
    
}

// MARK: - UITableViewDataSource
extension QuizzViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableChoices.count
    }
    
    func tableView(_ tableView: UITableView,
                   estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChoiceCell.className(), for: indexPath)
            as? ChoiceCell else {
                return UITableViewCell()
        }
        
        cell.letterLb.text = Alphabet.from(index: indexPath.row)
        cell.contentLb.text = availableChoices[indexPath.row]
        
        if areAnswersBeingDisplayed == false && selectedIndexes.contains(indexPath.row) {
            cell.highlight(option: .selected)
        }
        
        if areAnswersBeingDisplayed, answerIndexes.contains(indexPath.row) {
            cell.highlight(option: .answer)
        }
        
        return cell
    }
    
}

// MARK: - UITableViewDelegate
extension QuizzViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        guard let selectedCell = tableView.cellForRow(at: indexPath) as? ChoiceCell else {
            loadNextQuestion()
            return
        }
        
        handleCellTap(cell: selectedCell, at: indexPath)
    }
    
}

