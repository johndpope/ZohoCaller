//
//  ResultHighlighter.swift
//  ZohoSearchKit
//
//  Created by hemant kumar s. on 14/02/18.
//

import Foundation

class ResultHighlighter {
    
    //can be marked private, should not be used from outside the SearchKit module
    
    //this can be further used when making bold bold font in case autosuggest
    static func genSearchResultHighlightedString(with searchTerm: String, targetString: String, maxVisibleCharRange: Int) -> NSAttributedString? {
        return generateAttributedString(with: searchTerm, targetString: targetString, maxVisibleCharRange: maxVisibleCharRange, attributeKey: NSAttributedStringKey.backgroundColor, attributeValue: SearchKitConstants.ColorConstants.ResultHighlightColor)
    }
    
    static func genAutosuggestHighlightedString(with searchTerm: String, targetString: String, font: UIFont, maxVisibleCharRange: Int) -> NSAttributedString? {
        return generateAttributedString(with: searchTerm, targetString: targetString, maxVisibleCharRange: maxVisibleCharRange, attributeKey: NSAttributedStringKey.font, attributeValue: font.bold) //UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.bold)
    }
    
    private static func generateAttributedString(with searchTerm: String, targetString: String, maxVisibleCharRange: Int, attributeKey: NSAttributedStringKey, attributeValue: Any) -> NSAttributedString? {
        let attributedString = NSMutableAttributedString(string: targetString)
        do {
            
            let range = NSRange(location: 0, length: targetString.utf16.count)
            
            /*
             //longest match, creating issue with reusable cell. On scroll each cell shows different behavior of showing longest match or token based match
             //and might also be because of the multiple attribute associated with the token. I mean longest match then token based match
             let regex = try NSRegularExpression(pattern: searchTerm, options: .caseInsensitive)
             //let range = NSRange(location: 0, length: targetString.utf16.count)
             for match in regex.matches(in: targetString, options: .withTransparentBounds, range: range) {
             //add highlighting attribute only when word is visible
             if (match.range.upperBound <= maxVisibleCharRange) {
             attributedString.addAttribute(attributeKey, value: attributeValue, range: match.range)
             }
             }
             */
            
            /*
            //old token based highlighting, which does not support wild card highlighting
            //token based match and highlighting
            let tokens = searchTerm.components(separatedBy: " ")
            for token in tokens {
                let regex = try NSRegularExpression(pattern: token, options: .caseInsensitive)
                for match in regex.matches(in: targetString, options: .withTransparentBounds, range: range) {
                    //add highlighting attribute only when word is visible
                    if (match.range.upperBound <= maxVisibleCharRange) {
                        attributedString.addAttribute(attributeKey, value: attributeValue, range: match.range)
                    }
                }
            }
            */
            
            //new token based match and highlighting - supports wild card highlighting
            let tokens = searchTerm.components(separatedBy: " ")
            for token in tokens {
                let newToken = getRegexFromWildCard(wildCard: token)
                let regex = try NSRegularExpression(pattern: newToken, options: .caseInsensitive)
                for match in regex.matches(in: targetString, options: .withTransparentBounds, range: range) {
                    let newRange = Range(match.range, in: targetString)
                    let matchedString = targetString.substring(with: newRange!)
                    let matchedTokens = matchedString.components(separatedBy: " ")
                    if matchedTokens.count > 0 {
                        //since matched word will always be the first word, we are taking the first word.
                        let firstMatchedWord = matchedTokens[0]
                        let firstWordRange = NSMakeRange(match.range.lowerBound, firstMatchedWord.count)
                        
                        //add highlighting attribute only when word is visible
                        if (match.range.upperBound <= maxVisibleCharRange || firstWordRange.upperBound <= maxVisibleCharRange) {
                            attributedString.addAttribute(attributeKey, value: attributeValue, range: firstWordRange)
                        }
                    }
                    
                }
            }
            
            return attributedString
        } catch _ {
            //Replace this logger with SearchKit logger
            NSLog("Error creating regular expresion")
            return nil
        }
    }
    
    //converts the wildcarded string to regex form so that we can use in regex match
    private static func getRegexFromWildCard(wildCard: String) -> String {
        var regexString = "";
        for char in wildCard {
            switch char {
            case "*":
                //match 0 or more characters.
                regexString.append(".*")
                break
            case "?":
                regexString.append(".")
                break
            default:
                regexString.append(char)
            }
        }
        
        return regexString
    }
    
    //this is error prone, in case of wiki it is retuning 0 sometimes
    static func fit(_ string: String, into label: UILabel) -> Int {
        let font: UIFont? = label.font
        let mode: NSLineBreakMode = label.lineBreakMode
        let labelWidth: CGFloat = label.frame.size.width
        let labelHeight: CGFloat = label.frame.size.height
        let sizeConstraint = CGSize(width: labelWidth, height: CGFloat.greatestFiniteMagnitude)
        let attributes = [NSAttributedStringKey.font: font]
        let attributedText = NSAttributedString(string: string, attributes: attributes as Any as? [NSAttributedStringKey : Any])
        let boundingRect: CGRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
        do {
            if boundingRect.size.height > labelHeight {
                var index: Int = 0
                var prev: Int
                let characterSet = CharacterSet.whitespacesAndNewlines
                repeat {
                    prev = index
                    if mode == .byCharWrapping {
                        index += 1
                    }
                    else {
                        index = (string as NSString).rangeOfCharacter(from: characterSet, options: [], range: NSRange(location: index + 1, length: string.count - index - 1)).location
                    }
                } while index != NSNotFound && index < string.count && ((string as NSString).substring(to: index).boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, attributes: attributes as Any as? [NSAttributedStringKey : Any], context: nil).size.height) <= labelHeight
                return prev
            }
        }
        return string.count
    }
}

