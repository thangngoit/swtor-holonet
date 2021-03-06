//
//  String.swift
//  SWTOR HoloNet
//
//  Created by Ivan Fabijanovic on 17/10/14.
//  Copyright (c) 2014 Ivan Fabijanović. All rights reserved.
//

import UIKit

extension String {

    // MARK: - Cleanup
    
    func stripNewLinesAndTabs() -> String {
        let withoutNewLines = self.stringByReplacingOccurrencesOfString("\n", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let withoutTabs = withoutNewLines.stringByReplacingOccurrencesOfString("\t", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return withoutTabs
    }

    func trimSpaces() -> String {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }
    
    func stripSpaces() -> String {
        return self.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    func collapseMultipleSpaces() -> String {
        return self.stringByReplacingOccurrencesOfString("[ ]+", withString: " ", options: NSStringCompareOptions.RegularExpressionSearch, range: nil)
    }
    
    func formatPostDate() -> String {
        var value = self.collapseMultipleSpaces()
        if let range = value.rangeOfString("| #", options: NSStringCompareOptions.LiteralSearch, range: nil, locale: nil) {
            value = value.substringToIndex(range.startIndex)
        }
        value = value.stringByReplacingOccurrencesOfString(" ,", withString: ",", options: NSStringCompareOptions.LiteralSearch, range: nil)
        return value.trimSpaces()
    }
    
    // MARK: - Substring
    
    func substringToIndex(index: Int) -> String {
        if index < 0 { return "" }
        if index >= count(self) { return self }
        
        return self.substringToIndex(advance(self.startIndex, index))
    }
    
    func substringFromIndex(index: Int) -> String {
        if index < 0 { return "" }
        if index > count(self) { return "" }
        
        return self.substringFromIndex(advance(self.startIndex, index))
    }
    
    func substringWithRange(range: Range<Int>) -> String {
        if range.startIndex < 0 { return "" }
        if range.endIndex < 0 { return "" }
        if range.startIndex > count(self) { return "" }
        if range.endIndex >= count(self) { return self.substringFromIndex(range.startIndex) }
        
        let start = advance(self.startIndex, range.startIndex)
        let end = advance(self.startIndex, range.endIndex)
        return self.substringWithRange(start..<end)
    }
   
}
