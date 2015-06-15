//
//  ForumFragmentText.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 15/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentText: ForumFragmentBase {
   
    let value: String
    let isBold: Bool
    let isItalic: Bool
    let isUnderline: Bool
    
    override var description: String {
        return "TEXT: \(self.value)"
    }
    
    init(value: String, isBold: Bool = false, isItalic: Bool = false, isUnderline: Bool = false) {
        self.value = value
        self.isBold = isBold
        self.isItalic = isItalic
        self.isUnderline = isUnderline
        super.init(type: .Text)
    }
    
}
