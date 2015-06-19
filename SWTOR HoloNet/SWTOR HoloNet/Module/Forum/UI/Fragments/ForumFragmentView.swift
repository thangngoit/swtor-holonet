//
//  ForumFragmentView.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 16/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

let ForumFragmentViewHeightChanged = "ForumFragmentViewHeightChanged"

class ForumFragmentView: UIView, Themeable {

    // MARK: - Properties
    
    private var theme: Theme?
    private var shouldLayout = true
    
    private var widthConstraint: NSLayoutConstraint?
    private var heightConstraint: NSLayoutConstraint?
    
    var fragments: Array<ForumFragmentBase>?
    var maxSize: CGFloat = 99999.0
    var padding: CGFloat = 10.0
    
    // MARK: - Public methods
    
    func setWidth(value: CGFloat) {
        // Create a width constraint if it does not exist yet
        if self.widthConstraint == nil {
            self.widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
            self.addConstraint(self.widthConstraint!)
        }
        
        self.widthConstraint!.constant = value
        self.setNeedsLayout()
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        // If there are no fragments, there is nothing to layout
        if fragments == nil { return }
        
        // If layouting has been explicitly disabled, skip it but enable for future calls
        if !self.shouldLayout {
            self.shouldLayout = true
            return
        }
        
        let lineBreakSize: CGFloat = 10.0
        
        let x: CGFloat = self.padding
        var y: CGFloat = self.padding
        let width: CGFloat = CGRectGetWidth(self.frame) - (2*self.padding)
        
        var remainingSpace: CGFloat = self.maxSize - y
        var index = 0
        
        while (remainingSpace > 0) && (index < self.fragments!.count) {
            // Get a fragment
            let fragment = self.fragments![index]
            
            // Get a view for fragment
            var view = index < self.subviews.count ? self.subviews[index] as? UIView : nil
            
            // View for fragment does not exist yet, create it
            if view == nil {
                view = self.viewForFragment(fragment)
                self.addSubview(view!)
            }
            
            // Handle each fragment type
            if fragment.type == .LineBreak {
                // Line break, just add some space
                remainingSpace -= lineBreakSize
                y += lineBreakSize
            } else if let text = view as? ForumFragmentTextView {
                // Text, size the view
                text.frame = CGRectMake(x, y, width, 0)
                text.sizeToFit(CGSizeMake(width, remainingSpace))
                
                remainingSpace -= text.frame.size.height
                y += text.frame.size.height
            } else if let link = view as? ForumFragmentLinkView {
                // Link, size the view
                link.frame = CGRectMake(x, y, width, remainingSpace)
                link.sizeToFit()
                
                remainingSpace -= link.frame.size.height
                y += link.frame.size.height
            }
            
            index++
        }
        
        // Store current and new height values so they can be notified to observers
        let oldHeight = self.frame.size.height
        let newHeight = y + self.padding
        
        // Disable layouting because we need to set the height of this view
        // which will trigger a new layout pass
        self.shouldLayout = false
        
        if self.heightConstraint == nil {
            self.heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
            self.addConstraint(self.heightConstraint!)
        }
        
        self.heightConstraint!.constant = newHeight
        
        // Notify observers that view height has changed
        NSNotificationCenter.defaultCenter().postNotificationName(ForumFragmentViewHeightChanged, object: self, userInfo: ["old": oldHeight, "new": newHeight])
    }
    
    // MARK: - Themeable
    
    func applyTheme(theme: Theme) {
        self.theme = theme
        
        self.backgroundColor = UIColor.clearColor()
        
        for subview in self.subviews {
            if let themeable = subview as? Themeable {
                themeable.applyTheme(theme)
            }
        }
    }
    
    // MARK: - Private methods
    
    private func viewForFragment(fragment: ForumFragmentBase) -> UIView {
        let view: UIView
        
        switch fragment.type {
        case .Text:
            view = viewForTextFragment(fragment as! ForumFragmentText)
        case .LineBreak:
            view = UIView()
        case .Link:
            view = viewForLinkFragment(fragment as! ForumFragmentLink)
        case .Quote:
            view = UIView()
        case .Spoiler:
            view = UIView()
        }
        
        if let themeable = view as? Themeable {
            if let theme = self.theme {
                themeable.applyTheme(theme)
            }
        }
        
        return view
    }
    
    private func viewForTextFragment(fragment: ForumFragmentText) -> ForumFragmentTextView {
        let view = ForumFragmentTextView()
        view.text = fragment.value
        return view
    }
    
    private func viewForLinkFragment(fragment: ForumFragmentLink) -> UIButton {
        let view = ForumFragmentLinkView()
        view.setTitle(fragment.text, forState: .Normal)
        view.url = NSURL(string: fragment.url)
        return view
    }

}
