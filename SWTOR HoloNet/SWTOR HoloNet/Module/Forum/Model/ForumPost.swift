//
//  ForumPost.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 16/10/14.
//  Copyright (c) 2014 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumPost: Entity {
    
    // MARK: - Properties
    
    var avatarUrl: String?
    var username: String
    var date: String
    var postNumber: Int?
    var isBiowarePost: Bool
    var body: Array<ForumFragmentBase>
    var signature: String?
    
    // MARK: - Init
    
    init(id: Int, username: String, date: String, postNumber: Int?, isBiowarePost: Bool, body: Array<ForumFragmentBase>) {
        self.username = username
        self.date = date
        self.postNumber = postNumber
        self.isBiowarePost = isBiowarePost
        self.body = body
        super.init(id: id)
    }
   
}
