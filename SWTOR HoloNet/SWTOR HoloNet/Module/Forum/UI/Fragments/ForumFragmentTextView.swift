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
        
        self.lineBreakMode = .ByTruncatingTail
        self.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.lineBreakMode = .ByTruncatingTail
        self.numberOfLines = 0
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.lineBreakMode = .ByTruncatingTail
        self.numberOfLines = 0
    }
    
    // MARK: - Public methods
    
    func sizeToFit(size: CGSize) {
        self.sizeToFit()
        
        if self.frame.size.height > size.height {
            // Too large, fit into remaining space
            self.frame.size = size
        }
    }
    
    // MARK: - Themeable
    
    func applyTheme(theme: Theme) {
        self.font = theme.contentFont
        self.backgroundColor = UIColor.clearColor()
        self.textColor = theme.contentText
    }

}
