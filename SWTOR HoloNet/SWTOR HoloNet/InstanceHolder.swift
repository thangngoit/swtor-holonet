//
//  InstanceHolder.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 18/12/14.
//  Copyright (c) 2014 Ivan Fabijanović. All rights reserved.
//
//  Singleton class holding dependencies which should be injected
//  but Apple and Swift are making that part extra hard :) Remove
//  after introducing proper dependency injection.
//

import UIKit

class InstanceHolder {
    
    // MARK: - Properties
    
    let settings = Settings()
    let theme = Theme()
    
    // MARK: - Singleton
    
    struct Singleton {
        static var token: dispatch_once_t = 0
        static var instance: InstanceHolder?
    }
    
    class func sharedInstance() -> InstanceHolder {
        dispatch_once(&Singleton.token) {
            Singleton.instance = InstanceHolder()
        }
        return Singleton.instance!
    }
    
    // MARK: - Public methods
    
    func inject(var #controller: InjectableViewController) {
        controller.settings = self.settings
        controller.theme = self.theme
    }
    
}
