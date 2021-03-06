//
//  ActionParser.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 10/03/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import Foundation

class ActionParser {
    
    // MARK: - Variables
    
    let userInfo: [NSObject: AnyObject]
    
    // MARK: - Init
    
    init(userInfo: [NSObject: AnyObject]) {
        self.userInfo = userInfo
    }
    
    // MARK: - Methods
    
    func getAlert() -> String? {
        if let aps = self.userInfo["aps"] as? [NSObject: AnyObject] {
            if let alert = aps["alert"] as? String {
                return alert
            }
        }
        return nil
    }
    
    func getString(key: String) -> String? {
        return self.userInfo[key] as? String
    }
    
}
