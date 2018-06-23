//
//  LevelTableViewCell.swift
//  AgileLife
//
//  Created by Tea Bee on 6/10/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit

class LevelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var levelLb: UILabel!
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setup()
    }
    
    fileprivate func setup() {
        self.backgroundColor = UIColor.clear
        
        containerView.layer.masksToBounds = true
        containerView.layer.cornerRadius = 12
        containerView.layer.borderWidth = 2
        containerView.layer.borderColor = UIColor.lightGray.cgColor
        containerView.backgroundColor = UIColor.white.withAlphaComponent(0.5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.backgroundColor = UIColor.red
        } else {
            self.backgroundColor = UIColor.clear
        }
    }

}
