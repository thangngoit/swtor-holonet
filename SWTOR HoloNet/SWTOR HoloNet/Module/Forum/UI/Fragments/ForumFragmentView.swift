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
    
    // MARK: - Public methods
    
    func layout(size: CGSize) {
        // Create a width constraint if it does not exist yet
        if self.widthConstraint == nil {
            self.widthConstraint = NSLayoutConstraint(item: self, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
            self.addConstraint(self.widthConstraint!)
        }
        
        // Create a height constraint if it does not exist yet
        if self.heightConstraint == nil {
            self.heightConstraint = NSLayoutConstraint(item: self, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
            self.addConstraint(self.heightConstraint!)
        }
        
        // Just set a value for the width constraint
        // Height will be calculated when layouting subviews
        self.widthConstraint!.constant = size.width
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
        
        let margin: CGFloat = 10.0
        let lineBreakSize: CGFloat = 10.0
        
        let x: CGFloat = margin
        var y: CGFloat = margin
        let width: CGFloat = CGRectGetWidth(self.frame) - (2*margin)
        
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
            } else if let label = view as? ForumFragmentTextView {
                // Text, size the view
                label.frame = CGRectMake(x, y, width, remainingSpace)
                label.sizeToFit()
                
                remainingSpace -= label.frame.size.height
                y += label.frame.size.height
            }
            
            index++
        }
        
        // Store current and new height values so they can be notified to observers
        let oldHeight = self.frame.size.height
        let newHeight = y + margin
        
        // Disable layouting because we need to set the height of this view
        // which will trigger a new layout pass
        self.shouldLayout = false
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
            view = UIView()
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
        return UIButton()
    }

}
