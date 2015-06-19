//
//  ForumPostViewController.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 03/11/14.
//  Copyright (c) 2014 Ivan Fabijanović. All rights reserved.
//

import UIKit
import Parse

class ForumPostViewController: UIViewController, Injectable, Themeable {

    // MARK: - Properties
    
    var settings: Settings!
    var theme: Theme!
    var alertFactory: AlertFactory!
    
    var post: ForumPost!
    
    // MARK: - Outlets
    
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var devImageView: UIImageView!
    @IBOutlet var bodyScrollView: UIScrollView!
    @IBOutlet var bodyView: ForumFragmentView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        // Poor man's dependency injection, remove ASAP
        InstanceHolder.sharedInstance().inject(self)
        
        super.viewDidLoad()
        
        // Set user avatar image if URL is defined in the model
        if let url = self.post.avatarUrl {
            self.avatarImageView.hidden = false
            self.avatarImageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "Avatar"))
        } else {
            self.avatarImageView.hidden = true
        }
        
        // Set dev icon if post is marked as Bioware post
        if self.post.isBiowarePost {
            self.devImageView.hidden = false
            self.devImageView.sd_setImageWithURL(NSURL(string: self.settings.devTrackerIconUrl), placeholderImage: UIImage(named: "DevTrackerIcon"))
        } else {
            self.devImageView.hidden = true
        }
        
        self.dateLabel.text = self.post.postNumber != nil ? "\(self.post.date) | #\(self.post.postNumber!)" : self.post.date
        self.usernameLabel.text = post.username
        
        self.bodyView.fragments = post.body
        self.bodyView.setWidth(self.view.frame.size.width)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "bodyHeightChanged:", name: ForumFragmentViewHeightChanged, object: self.bodyView)
        
        self.applyTheme(self.theme)
        
#if !DEBUG && !TEST
        // Analytics
        PFAnalytics.trackEvent("forum", dimensions: ["type": "post"])
#endif
    }
    
    // MARK: - Orientation change
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.transitionToSize(size)
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    }
    
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        let viewSize = self.view.frame.size
        let newSize = CGSizeMake(viewSize.height, viewSize.width)
        
        self.transitionToSize(newSize)
        super.willRotateToInterfaceOrientation(toInterfaceOrientation, duration: duration)
    }
    
    private func transitionToSize(size: CGSize) {
        // Fade out -> in the body view for smooth transition when scrolling is necessary
        self.bodyView.alpha = 0
        UIView.animateWithDuration(0.5) {
            self.bodyView.alpha = 1
        }
        
        self.bodyView.setWidth(size.width)
    }
    
    // MARK: - Body height change
    
    func bodyHeightChanged(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            // Get the old and new height value
            let old = userInfo["old"] as! CGFloat
            let new = userInfo["new"] as! CGFloat
            
            if old == 0 { return }
            if old == new { return }
            
            // Calculate the ratio of new:old value
            let ratio = new/old
            
            // New scroll position should be the same in %
            let current = self.bodyScrollView.contentOffset.y
            let scrollTo = CGRectMake(0.0, floor(current * ratio), self.bodyScrollView.frame.size.width, self.bodyScrollView.frame.size.height)
            
            // Finally trigger scrolling
            self.bodyScrollView.scrollRectToVisible(scrollTo, animated: false)
        }
    }
    
    // MARK: - Themeable
    
    func applyTheme(theme: Theme) {
        self.view.backgroundColor = theme.contentBackground
        self.dateLabel.textColor = theme.contentText
        self.usernameLabel.textColor = theme.contentText
        self.bodyScrollView.indicatorStyle = theme.scrollViewIndicatorStyle
        self.bodyView.applyTheme(theme)
    }

}
