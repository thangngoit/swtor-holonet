//
//  ForumFragmentParser.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 15/06/15.
//  Copyright (c) 2015 Ivan Fabijanović. All rights reserved.
//

import UIKit

class ForumFragmentParser {
   
    let quoteClass = "quote"
    let spoilerClass = "spoiler"
    
    // MARK: - Public methods
    
    func fragmentsForNode(node: HTMLNode) -> Array<ForumFragmentBase> {
        var fragments = Array<ForumFragmentBase>()
        
        if let element = node as? HTMLElement {
            // Node is an element
            
            if element.hasClass(quoteClass) {
                // Quote
                fragments.append(self.quoteFragmentForElement(element))
                return fragments
            } else if element.hasClass(spoilerClass) {
                // Spoiler
                fragments.append(self.spoilerFragmentForElement(element))
                return fragments
            } else if element.tagName == "br" {
                // Line break
                fragments.append(self.lineBreakFragmentForElement(element))
            }
        }
        
        if node.children.count == 0 {
            // Leaf node
            if let text = self.textFragmentForNode(node) {
                fragments.append(text)
            }
        } else {
            // Node has children, continue down the tree
            for child in node.children {
                if let childNode = child as? HTMLNode {
                    fragments.extend(self.fragmentsForNode(childNode))
                }
            }
        }
        
        return fragments
    }
    
    // MARK: - Private methods

    private func quoteFragmentForElement(element: HTMLElement) -> ForumFragmentQuote {
        let title = element.firstNodeMatchingSelector(".\(quoteClass)-header")?.textContent ?? ""
        let body = element.firstNodeMatchingSelector(".\(quoteClass)-body")
        
        let bodyFragments = self.fragmentsForNode(body)
        
        return ForumFragmentQuote(title: title.stripNewLinesAndTabs().trimSpaces().collapseMultipleSpaces(), body: bodyFragments)
    }
    
    private func spoilerFragmentForElement(element: HTMLElement) -> ForumFragmentSpoiler {
        let body = element.firstNodeMatchingSelector(".\(spoilerClass)-body")
        
        let bodyFragments = self.fragmentsForNode(body)
        
        return ForumFragmentSpoiler(body: bodyFragments)
    }
    
    private func lineBreakFragmentForElement(element: HTMLElement) -> ForumFragmentLineBreak {
        return ForumFragmentLineBreak()
    }
    
    private func textFragmentForNode(node: HTMLNode) -> ForumFragmentText? {
        let text = node.textContent.stripNewLinesAndTabs().trimSpaces().collapseMultipleSpaces()
        return text.isEmpty ? nil : ForumFragmentText(value: text)
    }
    
}
