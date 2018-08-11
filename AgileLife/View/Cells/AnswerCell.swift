//
//  AnswerCell.swift
//  AgileLife
//
//  Created by Tea Bee on 6/11/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit


public let themeColor = UIColor(red: 80, green: 208, blue: 255)

class AnswerCell: UITableViewCell {

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
        
        containerView.layer.backgroundColor = UIColor.clear.cgColor
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 2
        containerView.layer.cornerRadius = 8
        
        answerSymbolLb.textColor = UIColor.white
        highlightForMulChoices()
        
        answerLbContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        answerLb.backgroundColor = UIColor.clear
        answerLb.text = ""
        
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
            correctIcon.image = #imageLiteral(resourceName: "ic_incorrect")
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
    
    func highlightForMulChoices(color: UIColor? = nil) {
        var borderColor = themeColor
        var contentColor = UIColor.white.withAlphaComponent(0.8)
        if let color = color {
            borderColor = color
            contentColor = UIColor.white
        }
        
        containerView.layer.borderColor = borderColor.cgColor
        answerSymbolLb.backgroundColor = borderColor
        answerLbContainerView.backgroundColor = contentColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        highlightForMulChoices()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
