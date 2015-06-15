//
//  ForumFragmentSpoiler.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 15/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentSpoiler: ForumFragmentBase {
   
    let body: Array<ForumFragmentBase>
    
    override var description: String {
        return "SPOILER (\(self.body.count))"
    }
    
    init(body: Array<ForumFragmentBase>) {
        self.body = body
        super.init(type: .Quote)
    }
    
}
