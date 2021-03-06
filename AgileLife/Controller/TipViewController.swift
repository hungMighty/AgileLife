//
//  TipViewController.swift
//  AgileLife
//
//  Created by Ahri on 8/11/18.
//  Copyright © 2018 TeaBee. All rights reserved.
//

import UIKit


class TipViewController: UIViewController {

    @IBOutlet weak var hintTextView: UITextView!
    
    var textHint: String = "" {
        didSet {
            hintTextView.text = textHint
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

}

// MARK: - Setup UI
extension TipViewController {
    
    fileprivate func setupUI() {
        hintTextView.isEditable = false
        hintTextView.layer.cornerRadius = 8
        hintTextView.textContainerInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        hintTextView.layer.borderColor = UIColor.black.cgColor
        hintTextView.layer.borderWidth = 1.5
        hintTextView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
    }
    
}
