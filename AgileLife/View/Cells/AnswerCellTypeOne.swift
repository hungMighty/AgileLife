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
        
        answerLbContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        answerLb.backgroundColor = UIColor.clear
        answerLb.text = "Whale\n Whale\n Whale\n Whale\n"
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
