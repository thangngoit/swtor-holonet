//
//  ForumFragmentText.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 15/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentText: ForumFragmentBase {
   
    private var internalValue: String
    
    var value: String {
        return self.internalValue
    }
    
    override var description: String {
        return "TEXT: \(self.value)"
    }
    
    init(value: String) {
        self.internalValue = value
        super.init(type: .Text)
    }
    
    func concat(fragment: ForumFragmentText) {
        self.internalValue = "\(self.internalValue) \(fragment.value)"
    }
    
}
