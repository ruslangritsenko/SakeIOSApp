//
//  UIDeviceExtensions.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/26.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    var isSimulator: Bool {
        #if IOS_SIMULATOR
            return true
        #else
            return false
        #endif
    }
}
