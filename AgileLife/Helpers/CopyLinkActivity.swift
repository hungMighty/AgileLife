//
//  CopyLinkActivity.swift
//  VietnamWorks
//
//  Created by Ahri on 6/25/18.
//  Copyright © 2018 Vietnamworks. All rights reserved.
//

import UIKit


class CopyLinkActivity: UIActivity {
    
    private var url = URL(string: "")
    
    override class var activityCategory: UIActivity.Category {
        return .action
    }
    
    override var activityType: UIActivity.ActivityType? {
        guard let bundleID = Bundle.main.bundleIdentifier else { return nil }
        return UIActivity.ActivityType(rawValue: bundleID + "\(CopyLinkActivity.className())")
    }
    
    override var activityTitle: String? {
        return "Copy Link"
    }
    
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "ic_copy_link")
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        for item in activityItems {
            if let _ = item as? URL {
                return true
            }
        }
        
        return false
    }
    
    override func prepare(withActivityItems activityItems: [Any]) {
        for item in activityItems {
            if let url = item as? URL {
                self.url = url
            }
        }
    }
    
    override func perform() {
        UIPasteboard.general.string = url?.absoluteString
        activityDidFinish(true)
    }
    
}

