//
//  ForumFragmentView.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 16/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentView: UIView, Themeable {

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
            } else if let label = view as? UILabel {
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
        self.backgroundColor = UIColor.clearColor()
    }
    
    private func viewForFragment(fragment: ForumFragmentBase) -> UIView {
        switch fragment.type {
        case .Text:
            return viewForTextFragment(fragment as! ForumFragmentText)
        case .LineBreak:
            return UIView()
        case .Link:
            return UIView()
        case .Quote:
            return UIView()
        case .Spoiler:
            return UIView()
        }
    }
    
    private func viewForTextFragment(fragment: ForumFragmentText) -> UILabel {
        let view = UILabel()
        view.textColor = UIColor.whiteColor()
        view.text = fragment.value
        view.lineBreakMode = .ByWordWrapping
        view.numberOfLines = 0
        return view
    }

}
