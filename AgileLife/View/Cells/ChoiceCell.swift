//
//  ChoiceCell.swift
//  AgileLife
//
//  Created by Tea Bee on 6/11/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit


public let themeColor = UIColor(red: 50, green: 178, blue: 225)


enum HighlightOption {
    case selected
    case unselected
    case answer
}


class ChoiceCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var letterLb: UILabel!
    
    @IBOutlet weak var contentContainerView: UIView!
    @IBOutlet weak var contentLb: UILabel!
    
    @IBOutlet weak var markingView: UIView!
    @IBOutlet weak var markingIcon: UIImageView!
}

// MARK: Prepare UI
extension ChoiceCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        containerView.layer.backgroundColor = UIColor.clear.cgColor
        containerView.layer.masksToBounds = true
        containerView.layer.borderWidth = 2
        containerView.layer.cornerRadius = 8
        
        letterLb.textColor = UIColor.white
        
        contentContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        contentLb.backgroundColor = UIColor.clear
        contentLb.text = ""
        
        markingView.isHidden = true
        markingView.backgroundColor = UIColor.clear
        markingView.layer.masksToBounds = true
        markingView.layer.cornerRadius = 8
        markingIcon.contentMode = .scaleAspectFill
        
        highlight(option: .unselected)
    }
    
}

// MARK: UI Logic
extension ChoiceCell {
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        highlight(option: .unselected)
    }
    
    func highlight(option: HighlightOption) {
        switch option {
        case .answer:
            containerView.layer.borderColor = themeColor.cgColor
            letterLb.backgroundColor = themeColor
            contentContainerView.backgroundColor = UIColor(red: 223, green: 253, blue: 172)
            
        case .selected:
            containerView.layer.borderColor = UIColor(red: 161, green: 58, blue: 241).cgColor
            letterLb.backgroundColor = UIColor(red: 161, green: 58, blue: 241)
            contentContainerView.backgroundColor = UIColor.white
            
        case .unselected:
            containerView.layer.borderColor = themeColor.cgColor
            letterLb.backgroundColor = themeColor
            contentContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        }
    }
    
    func hideMarkView() {
        markingView.isHidden = true
    }
    
    func showMarkingIcon(isCorrect: Bool,
                     completion: @escaping () -> ()) {
        if isCorrect {
            markingIcon.image = #imageLiteral(resourceName: "ic_correct")
        } else {
            markingIcon.image = #imageLiteral(resourceName: "ic_incorrect")
        }
        
        markingView.isHidden = false
        UIView.animate(
            withDuration: 0.2,
            animations: {
                self.markingIcon.transform = CGAffineTransform(scaleX: 1.4, y: 1.4)
        },
            completion: { (isComplete) in
                UIView.animate(
                    withDuration: 0.2,
                    
                    animations: {
                        self.markingIcon.transform = CGAffineTransform.identity
                },
                    completion: { (isComplete) in
                        self.hideMarkView()
                        completion()
                })
        })
    }
    
}

