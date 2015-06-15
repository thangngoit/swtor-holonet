//
//  ForumFragmentBase.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 15/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentBase: Printable {
    
    let type: ForumFragmentType
    
    var description: String {
        return "FRAGMENT"
    }
    
    init(type: ForumFragmentType) {
        self.type = type
    }
    
}
