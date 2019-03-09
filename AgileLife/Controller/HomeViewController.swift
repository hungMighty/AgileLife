//
//  ViewController.swift
//  AgileLife
//
//  Created by Tea Bee on 6/10/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var levelsTableView: UITableView!
    
    fileprivate var levels = [Level]()
    
    
    // MARK: - View Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Agile Cheetah"
        
        levelsTableView.register(
            LevelTableViewCell.getNib(), forCellReuseIdentifier: LevelTableViewCell.className()
        )
        
        levelsTableView.isScrollEnabled = false
        levelsTableView.separatorStyle = .none
        levelsTableView.tableFooterView = UIView()
        levelsTableView.backgroundColor = UIColor.clear
        
        levels.append(Level(value: 0, display: "Easy"))
        levels.append(Level(value: 1, display: "Medium"))
        levels.append(Level(value: 2, display: "Hard"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Actions


}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return levels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / CGFloat(levels.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let tableCell = tableView
            .dequeueReusableCell(withIdentifier: LevelTableViewCell.className(),
                                 for: indexPath)
            as? LevelTableViewCell else {
                return UITableViewCell()
        }
        
        tableCell.levelLb.text = levels[indexPath.row].display
        
        return tableCell
    }
    
}


// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? LevelTableViewCell else {
            return
        }
        
        cell.containerView.backgroundColor = UIColor.cyan
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? LevelTableViewCell else {
            return
        }
        
        cell.containerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let vc = UIStoryboard.viewController(
            fromIdentifier: QuizzViewController.className()) as? QuizzViewController else {
                return
        }
        
        vc.hidesBottomBarWhenPushed = true
        vc.questionTemplate = QuestionTemplate(index: indexPath.row)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


