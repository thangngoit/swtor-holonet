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
    
    var alertFactory: AlertFactory
    
    let settings: Settings
    let theme: Theme
    let pushManager: PushManager
    
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
    
    class func initWithBundle(bundle: NSBundle) {
        dispatch_once(&Singleton.token) {
            Singleton.instance = InstanceHolder(bundle: bundle)
        }
    }
    
    // MARK: - Init
    
    init() {
        self.settings = Settings()
        self.theme = Theme()
        self.alertFactory = UIAlertFactory()
        let actionFactory = ActionFactory(alertFactory: self.alertFactory)
        self.pushManager = PushManager(alertFactory: self.alertFactory, actionFactory: actionFactory)
    }
    
    init(bundle: NSBundle) {
        self.settings = Settings(bundle: bundle)
        self.theme = Theme()
        self.alertFactory = UIAlertFactory()
        let actionFactory = ActionFactory(alertFactory: self.alertFactory)
        self.pushManager = PushManager(alertFactory: self.alertFactory, actionFactory: actionFactory)
    }
    
    // MARK: - Public methods
    
    func inject(var injectable: Injectable) {
        injectable.settings = self.settings
        injectable.theme = self.theme
        injectable.alertFactory = self.alertFactory
    }
    
}
