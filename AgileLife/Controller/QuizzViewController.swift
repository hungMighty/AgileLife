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
    @IBOutlet weak var selectCountLb: LbWithBackground!
    
    @IBOutlet weak var answersTable: UITableView!
    
    @IBOutlet weak var nextView: UIView!
    @IBOutlet weak var nextBtnImage: UIImageView!
    @IBOutlet weak var tipImage: UIImageView!
    @IBOutlet weak var tipView: UIView!
    
    
    // Constraints
    @IBOutlet weak var nextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tipViewHeight: NSLayoutConstraint!
    
    
    // ViewControllers
    var tipViewController: TipViewController?
    
    
    fileprivate var csv: CSwiftV?
    var questionTemplate: QuestionTemplate = .easy
    fileprivate var loadingLimit = 0
    
    fileprivate var curQuestionIndex = 0
    fileprivate var curQuestionData = [String]()
    fileprivate var possibleAnswers = [String]()
    fileprivate var correctAnswerIndexes: [Int]?
    fileprivate var selectedIndexPaths: [IndexPath]?
    
    fileprivate var numOfCorrectAnswers = 0
    
    // Width and Height
    fileprivate let nextViewNormalHeight: CGFloat = 60
    fileprivate let hintHeight: CGFloat = 200
    
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        csv = CSVLoader.readFrom(fileName: questionTemplate.name())
        loadingLimit = questionTemplate.limit() ?? csv?.rows.count ?? 1
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
        guard let tipView = tipViewController,
            (tipView.textHint.isEmpty == false) else {
            
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
        // Progress bar for title
        progressView.progressTintColor = UIColor.green
        progressView.transform = CGAffineTransform(scaleX: 1, y: 4)
        
        // Question View
        questionContainerView.layer.masksToBounds = true
        questionContainerView.layer.cornerRadius = 15
        questionContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        // Answers Table
        answersTable.showsVerticalScrollIndicator = false
        answersTable.separatorStyle = .none
        answersTable.backgroundColor = UIColor.clear
        answersTable.estimatedRowHeight = 200
        answersTable.rowHeight = UITableViewAutomaticDimension
        answersTable.register(
            AnswerCellTypeOne.getNib(),
            forCellReuseIdentifier: AnswerCellTypeOne.className()
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
        guard let csv = self.csv, curQuestionIndex < loadingLimit else {
            
            if let view = UIStoryboard.viewController(
                fromIdentifier: ResultViewController.className())
                as? ResultViewController {
                
                view.totalQuestions = loadingLimit
                view.numOfCorrectAnswers = numOfCorrectAnswers
                view.questionTemplate = questionTemplate
                
                self.navigationController?.pushViewController(view, animated: true)
            }
            
            return
        }
        
        
        // Setup next question
        curQuestionData = csv.rows[curQuestionIndex]
        mapPossibleAnswers()
        parseCorrectAnswerIndexes()
        
        // Reload UI
        self.title = "\(curQuestionIndex + 1) / \(loadingLimit)"
        progressView.setProgress(
            Float(curQuestionIndex + 1) / Float(loadingLimit),
            animated: true
        )
        
        questionLb.text = curQuestionData[CsvRow.question.rawValue]
        
        answersTable.allowsSelection = true
        answersTable.reloadData(
            with: .simple(
                duration: 0.65, direction: .rotation3D(type: .doctorStrange),
                constantDelay: 0
            )
        )
        
        nextViewHeight.constant = 0
        tipViewHeight.constant = 0
        tipImage.layer.removeAllAnimations()
        
        let txtHint = curQuestionData[CsvRow.explanation.rawValue]
        if let view = tipViewController,
            txtHint.isEmpty == false {
            
            view.textHint = txtHint
            pulseTipIcon()
        }
        
        // Reset flags
        selectedIndexPaths = [IndexPath]()
        curQuestionIndex += 1
    }
    
    fileprivate func mapPossibleAnswers() {
        possibleAnswers = [String]()
        
        for i in CsvRow.firstAnswerOpt.rawValue...CsvRow.lastAnswerOpt.rawValue {
            let answer = curQuestionData[i]
            if answer.isEmpty == false {
                possibleAnswers.append(answer)
            }
        }
    }
    
    fileprivate func parseCorrectAnswerIndexes() {
        let strValues = curQuestionData[CsvRow.correctResponse.rawValue]
            .split(separator: ",")
            .map{ String($0) }
        
        correctAnswerIndexes = [Int]()
        correctAnswerIndexes = strValues
            .compactMap{ Int($0) }.map { $0 - 1 }
        
        let multipleText = correctAnswerIndexes != nil ?
            "Select \(correctAnswerIndexes!.count)" : ""
        selectCountLb.text = multipleText
    }
    
    fileprivate func handleCellSelection(selectedCell: AnswerCellTypeOne,
                                         at indexPath: IndexPath) {
        if self.selectedIndexPaths?.contains(indexPath) == false {
            self.selectedIndexPaths?.append(indexPath)
            
            if self.correctAnswerIndexes != nil &&
                self.correctAnswerIndexes!.count >= 2 {
                
                selectedCell.highlightForMulChoices(
                    color: UIColor.green
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
        
        answersTable.allowsSelection = false
        
        let isAllCorrect = selectedIndexPaths
            .filter{ correctAnswerIndexes.contains($0.row) }
            .count == correctAnswerIndexes.count
        if isAllCorrect {
            numOfCorrectAnswers += 1
        }
        
        correctAnswerIndexes.forEach {
            if let correctCell = self.answersTable.cellForRow(
                at: IndexPath(row: $0, section: 0)
                ) as? AnswerCellTypeOne {
                
                correctCell.highlight(isCorrect: true)
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
                
                loadNextQuestion()
                return
        }
        
        handleCellSelection(selectedCell: selectedCell, at: indexPath)
    }
    
}

