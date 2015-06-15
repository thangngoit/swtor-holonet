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
    
    private var buffer = Array<ForumFragmentBase>()
    
    // MARK: - Public methods
    
    func fragmentsForNode(node: HTMLNode) -> Array<ForumFragmentBase> {
        self.buffer = Array<ForumFragmentBase>()
        self.internalFragmentsForNode(node)
        return self.buffer
    }
    
    // MARK: - Private methods
    
    private func internalFragmentsForNode(node: HTMLNode) {
        if let element = node as? HTMLElement {
            // Node is an element
            
            if element.hasClass(quoteClass) {
                // Quote
                self.buffer.append(self.quoteFragmentForElement(element))
                return
            } else if element.hasClass(spoilerClass) {
                // Spoiler
                self.buffer.append(self.spoilerFragmentForElement(element))
                return
            } else if element.tagName == "br" {
                // Line break
                self.buffer.append(self.lineBreakFragmentForElement(element))
            } else if element.tagName == "a" {
                // Link
                if let link = self.linkFragmentForElement(element) {
                    self.buffer.append(link)
                    return
                }
            }
        }
        
        if node.children.count == 0 {
            // Leaf node
            if let text = self.textFragmentForNode(node) {
                if let lastFragment = self.buffer.last as? ForumFragmentText {
                    // Last fragment is also a text fragment, concat this one to it
                    lastFragment.concat(text)
                } else {
                    // Last fragment is not a text fragment, append this one
                    self.buffer.append(text)
                }
            }
        } else {
            // Node has children, continue down the tree
            for child in node.children {
                if let childNode = child as? HTMLNode {
                    self.internalFragmentsForNode(childNode)
                }
            }
        }
    }

    private func quoteFragmentForElement(element: HTMLElement) -> ForumFragmentQuote {
        let title = element.firstNodeMatchingSelector(".\(quoteClass)-header")?.textContent ?? ""
        let body = element.firstNodeMatchingSelector(".\(quoteClass)-body")
        
        let parser = ForumFragmentParser()
        let bodyFragments = parser.fragmentsForNode(body)
        
        return ForumFragmentQuote(title: title.stripNewLinesAndTabs().trimSpaces().collapseMultipleSpaces(), body: bodyFragments)
    }
    
    private func spoilerFragmentForElement(element: HTMLElement) -> ForumFragmentSpoiler {
        let body = element.firstNodeMatchingSelector(".\(spoilerClass)-body")
        
        let parser = ForumFragmentParser()
        let bodyFragments = parser.fragmentsForNode(body)
        
        return ForumFragmentSpoiler(body: bodyFragments)
    }
    
    private func lineBreakFragmentForElement(element: HTMLElement) -> ForumFragmentLineBreak {
        return ForumFragmentLineBreak()
    }
    
    private func linkFragmentForElement(element: HTMLElement) -> ForumFragmentLink? {
        let url = element.objectForKeyedSubscript("href") as? String
        let text = element.textContent
        
        return url != nil ? ForumFragmentLink(url: url!, text: text) : nil
    }
    
    private func textFragmentForNode(node: HTMLNode) -> ForumFragmentText? {
        let text = node.textContent.stripNewLinesAndTabs().trimSpaces().collapseMultipleSpaces()
        return text.isEmpty ? nil : ForumFragmentText(value: text)
    }
    
}
