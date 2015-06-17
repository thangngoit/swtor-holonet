//
//  ForumFragmentTextView.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 16/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentTextView: UILabel, Themeable {

    // MARK: - Init
    
    init() {
        super.init(frame: CGRectZero)
        
        self.lineBreakMode = .ByWordWrapping
        self.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.lineBreakMode = .ByWordWrapping
        self.numberOfLines = 0
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.lineBreakMode = .ByWordWrapping
        self.numberOfLines = 0
    }
    
    // MARK: - Themeable
    
    func applyTheme(theme: Theme) {
        self.font = theme.contentFont
        self.backgroundColor = UIColor.clearColor()
        self.textColor = theme.contentText
    }

}
