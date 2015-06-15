//
//  ForumFragmentLink.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 15/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentLink: ForumFragmentBase {
   
    let url: String
    let text: String
    
    override var description: String {
        return "LINK: \(self.text):(\(self.url))"
    }
    
    init(url: String, text: String) {
        self.url = url
        self.text = text
        super.init(type: .Link)
    }
    
}
