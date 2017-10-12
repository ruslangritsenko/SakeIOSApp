//
//  NSMutableAttributedStringExtensions.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/30.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation
import UIKit

extension NSMutableAttributedString{
    
    func setColorForText(_ textToFind: String, with color: UIColor) {
        let range = self.mutableString.range(of: textToFind, options: .caseInsensitive)
        if range.location != NSNotFound {
            addAttribute(NSForegroundColorAttributeName, value: color, range: range)
        }
    }
}
