//
//  ForumFragmentQuote.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 15/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentQuote: ForumFragmentBase {
   
    let title: String
    let body: Array<ForumFragmentBase>
    
    override var description: String {
        return "QUOTE: \(self.title) (\(self.body.count))"
    }
    
    init(title: String, body: Array<ForumFragmentBase>) {
        self.title = title
        self.body = body
        super.init(type: .Quote)
    }
    
}
