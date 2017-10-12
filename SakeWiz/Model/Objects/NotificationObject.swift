//
//  NotificationObject.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/14.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation

class NotificationObject
{
    
    var notificationType = ""
    
    var id = ""
    var created = 0
    
    var timeStamp = Date()


    var notification: Any? = nil
    
    init()
    {
        notificationType = ""
        
        id = ""
        created = 0
        
        
        notification = nil
    }
    
    
    
    init?(json: [String:Any])
    {
        if let type = json["type"]as? String
        {
            notificationType = type
            
            id = (json["id"]as? String) ?? ""
            
            created = (json["created"]as? Int) ?? 0
            
            timeStamp = Date(timeIntervalSince1970: TimeInterval(created))
            
            notification = NotificationObject.stringToObjectType(type: type, json: json)
        
        }
        else
        {
            return nil
        }
    }
    
    class func stringToObjectType(type: String, json: [String:Any]) -> Any?
    {
        switch type {
        case "FOLLOWER_NOTIFICATION":
            return FollowerNotificationObject(json: json)
        case "LIKE_NOTIFICATION":
            return LikeNotificationObject(json: json)
        case "MANUAL_MATCH_NOTIFICATION":
            return nil
        default:
            return nil
        }
    }



}
