//
//  ForumFragmentLinkView.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 17/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentLinkView: UIButton, Themeable {

    // MARK: - Properties
    
    var url: NSURL!
    
    // MARK: - Init
    
    init() {
        super.init(frame: CGRectZero)
        
        self.registerTouch()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.registerTouch()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.registerTouch()
    }
    
    // MARK: - Tap
    
    func tapped(sender: UIButton) {
        UIApplication.sharedApplication().openURL(self.url)
    }
    
    private func registerTouch() {
        self.addTarget(self, action: "tapped:", forControlEvents: .TouchUpInside);
    }
    
    // MARK: - Themeable
    
    func applyTheme(theme: Theme) {
        self.titleLabel!.font = theme.contentFont
        self.setTitleColor(theme.contentTitle, forState: .Normal)
        self.backgroundColor = UIColor.clearColor()
    }

}
