//
//  AutoAdjustFontClass.swift
//  SakeWiz
//
//  Created by TW welly on 5/28/17.
//  Copyright © 2017 TW welly. All rights reserved.
//

/*
 Designed with single-line UILabels in mind, this subclass 'resizes' the label's text (it changes the label's font size)
 everytime its size (frame) is changed. This 'fits' the text to the new height, avoiding undesired text cropping.
 Kudos to this Stack Overflow thread: bit.ly/setFontSizeToFillUILabelHeight
 */

import Foundation
import UIKit

class LabelWithAdaptiveTextHeight: UILabel {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        font = fontToFitHeight()
    }
    
    // Returns an UIFont that fits the new label's height.
    private func fontToFitHeight() -> UIFont {
        
        //var minFontSize: CGFloat = DISPLAY_FONT_MINIMUM // CGFloat 18
        var minFontSize: CGFloat = 10
        //var maxFontSize: CGFloat = DISPLAY_FONT_BIG     // CGFloat 67
        var maxFontSize: CGFloat = 50
        var fontSizeAverage: CGFloat = 0
        var textAndLabelHeightDiff: CGFloat = 0
        
        while (minFontSize <= maxFontSize) {
            
            fontSizeAverage = minFontSize + (maxFontSize - minFontSize) / 2
            
            // Abort if text happens to be nil
            guard let thisText = text else {
                break
            }
            guard thisText.characters.count > 0 else {
                break
            }
            
            if let labelText = text {
                let labelHeight = frame.size.height
                let testStringHeight = labelText.size(
                    attributes: [NSFontAttributeName: font.withSize(fontSizeAverage)]
                    ).height
                
                textAndLabelHeightDiff = labelHeight - testStringHeight
                
                if (fontSizeAverage == minFontSize || fontSizeAverage == maxFontSize) {
                    if (textAndLabelHeightDiff < 0) {
                        return font.withSize(fontSizeAverage - 1)
                    }
                    return font.withSize(fontSizeAverage)
                }
                
                if (textAndLabelHeightDiff < 0) {
                    maxFontSize = fontSizeAverage - 1
                    
                } else if (textAndLabelHeightDiff > 0) {
                    minFontSize = fontSizeAverage + 1
                    
                } else {
                    return font.withSize(fontSizeAverage)
                }
            }
        }
        return font.withSize(fontSizeAverage)
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        
        return boundingBox.height
    }
}
