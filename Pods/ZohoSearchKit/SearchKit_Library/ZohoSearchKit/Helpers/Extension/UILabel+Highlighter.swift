//
//  UILabel+Highlighter.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 12/02/18.
//

import UIKit

//For this to work we will have to tage the text with <em> tags.
//This will be very useful when we have server highlighting code added
extension UILabel {
    var highlightedText: String {
        get {
            return attributedText!.string
        }
        set {
            attributedTextFromHtml(htmlText: newValue)
        }
    }
    
    private func attributedTextFromHtml(htmlText: String) {
        let text = NSMutableString(string: htmlText)
        let rangesOfAttributes = getRangeToHighlight(text: text)
        let attributedString = NSMutableAttributedString(string: String(text))
        
        let visRange = ResultHighlighter.fit(htmlText, into: self)
        for range in rangesOfAttributes {
            let color = highlightedTextColor ?? SearchKitConstants.ColorConstants.ResultHighlightColor
            //Highlight the word only when the word is in visible area of the screen, otherwise it will highligh the truncated dots ...
            if range.upperBound < visRange  {
                attributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: color, range: range)
            }
            
            //this alone will highlight last three dots when the text is truncated
            //attributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: color, range: range)
        }
        
        attributedText = attributedString
    }
    
    private func getRangeToHighlight(text: NSMutableString) -> [NSRange] {
        var rangesOfAttributes = [NSRange]()
        
        while true {
            let matchBegin = text.range(of: "<em>", options: .caseInsensitive)
            
            if matchBegin.location != NSNotFound {
                text.deleteCharacters(in: matchBegin)
                let firstCharacter = matchBegin.location
                
                let range = NSRange(location: firstCharacter, length: text.length - firstCharacter)
                let matchEnd = text.range(of: "</em>", options: .caseInsensitive, range: range)
                if matchEnd.location != NSNotFound {
                    text.deleteCharacters(in: matchEnd)
                    let lastCharacter = matchEnd.location
                    
                    rangesOfAttributes.append(NSRange(location: firstCharacter, length: lastCharacter - firstCharacter))
                }
            } else {
                break
            }
        }
        
        return rangesOfAttributes
    }
    
}
