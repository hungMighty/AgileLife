//
//  AnswerCellTypeOne.swift
//  AgileLife
//
//  Created by Tea Bee on 6/11/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit


class AnswerCellTypeOne: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var answerSymbolLb: UILabel!
    @IBOutlet weak var answerLbContainerView: UIView!
    @IBOutlet weak var answerLb: UILabel!
    @IBOutlet weak var markView: UIView!
    @IBOutlet weak var correctIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        let themeColor = UIColor(red: 56, green: 184, blue: 231)
        
        containerView.layer.backgroundColor = UIColor.clear.cgColor
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = themeColor.cgColor
        containerView.layer.cornerRadius = 8
        
        answerSymbolLb.backgroundColor = themeColor
        answerSymbolLb.textColor = UIColor.white
        
        answerLbContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        
        answerLb.backgroundColor = UIColor.clear
        answerLb.text = "Whale\n Whale\n Whale\n Whale\n"
        
        markView.isHidden = true
        markView.backgroundColor = UIColor.clear
        markView.layer.masksToBounds = true
        markView.layer.cornerRadius = 8
        correctIcon.contentMode = .scaleAspectFill
    }
    
    func hideMarkView() {
        markView.isHidden = true
    }
    
    func displayMark(isCorrect: Bool,
                     animationComplete: @escaping () -> ()) {
        if isCorrect {
            correctIcon.image = #imageLiteral(resourceName: "ic_correct")
        } else {
            correctIcon.image = #imageLiteral(resourceName: "ic_red_mark")
        }
        
        markView.isHidden = false
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.correctIcon.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        },
            completion: { (isComplete) in
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self.correctIcon.transform = CGAffineTransform.identity
                }, completion: { (isComplete) in
                    self.hideMarkView()
                    animationComplete()
                })
        })
    }
    
    func highlight(isCorrect: Bool) {
        if isCorrect {
            answerLbContainerView.backgroundColor = UIColor(red: 223, green: 253, blue: 172)
        } else {
            answerLbContainerView.backgroundColor = UIColor(red: 255, green: 171, blue: 169)
        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        answerLbContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
