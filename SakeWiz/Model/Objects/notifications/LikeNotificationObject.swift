//
//  LikeNotificationObject.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/14.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation


class LikeNotificationObject {


    var commentId = ""
    
    //bar
    var likedBarId = ""
    var likedBarName = ""
    
    
    //brewery
    var likedBreweryId = ""
    var likedBreweryName = ""
    
    
    
    //product
    
    var likedProductId = ""
    var likedProductNameDic:[String:String]? = nil
    
    
    
    //user
    var likedUserHandle = ""
    var likedUserId = ""
    var likedUserImg = ""
    var likedUserName = ""
    
    var state = NotificationState.none
    

    
    init(json: [String:Any])
    {
    
        likedProductNameDic = json["likedProductName"]as? [String:String]
        
        commentId = (json["commentId"]as? String) ?? ""
        likedBarId = (json["likedBarId"]as? String) ?? ""
        likedBarName = (json["likedBarName"]as? String) ?? ""
        likedBreweryId = (json["likedBreweryId"]as? String) ?? ""
        likedBreweryName = (json["likedBreweryName"]as? String) ?? ""
        likedProductId = (json["likedProductId"]as? String) ?? ""
        
        likedUserHandle = (json["likedUserHandle"]as? String) ?? ""
        likedUserId = (json["likedUserId"]as? String) ?? ""
        likedUserImg = (json["likedUserImg"]as? String) ?? ""
        likedUserName = (json["likedUserName"]as? String) ?? ""
        
        
        if let _ = (json["likedUserId"]as? String)
        {
            state = .isUser
        
        }
        else if let _ = (json["likedBreweryId"]as? String)
        {
            state = .isBrewery
        
        }
        else if let _ = (json["likedBarId"]as? String)
        {
        
            state = .isBar
        }
    }
    
    enum NotificationState
    {
        case isUser
        case isBrewery
        case isProduct
        case isBar
        case none
    
    }

}
