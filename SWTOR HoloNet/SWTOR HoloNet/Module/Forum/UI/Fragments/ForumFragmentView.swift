//
//  ForumFragmentView.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 16/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentView: UIView, Themeable {

    private var theme: Theme?
    
    var fragments: Array<ForumFragmentBase>?
    var maxSize: CGFloat = 9999.0
    
    override func layoutSubviews() {
        if fragments == nil { return }
        
        let x: CGFloat = 15.0
        var y: CGFloat = 15.0
        let width: CGFloat = CGRectGetWidth(self.frame) - 30.0
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
            
            if fragment.type == .LineBreak {
                y += 10.0
            } else if let label = view as? ForumFragmentTextView {
                label.preferredMaxLayoutWidth = width
                label.frame = CGRectMake(x, y, width, remainingSpace)
                label.sizeToFit()
                
                remainingSpace -= label.frame.size.height
                y += label.frame.size.height
            }
            
            index++
        }
    }
    
    func applyTheme(theme: Theme) {
        self.theme = theme
        
        self.backgroundColor = UIColor.clearColor()
        for subview in self.subviews {
            if let themeable = subview as? Themeable {
                themeable.applyTheme(theme)
            }
        }
    }
    
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
