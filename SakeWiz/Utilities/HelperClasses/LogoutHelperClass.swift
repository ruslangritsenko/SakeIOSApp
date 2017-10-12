//
//  LogoutHelperClass.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/26.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation

class LogoutHelperClass
{
    
    static let sharedInstance = LogoutHelperClass()
    
    var passedDelegate: LoggedOutProtocol?

    class func resetSharedInstance()
    {
        LogoutHelperClass.sharedInstance.passedDelegate = nil

    }

}
