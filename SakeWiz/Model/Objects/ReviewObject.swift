//
//  ReviewObject.swift
//  SakeWiz
//
//  Created by TW welly on 6/12/17.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation

class ReviewObject {

    var id: String
    var likes: Int
    var rating: Double
    var reviewDic: [String:String]? = nil
    var userHandle: String
    var userID:String
    
    var userAddress: String
    
    var createdServerTime: Int = 0
    var updatedServerTime: Int = 0
    
    var creationTime: Date
    var updatedTime: Date
    
    var isSpecialUser: Bool = false
    
    var isAffiliate: Bool = false
    var affiliateLogoURL: URL? = nil
    
    var isLiked = false
    
    
    init()
    {
        id = ""
        likes = 0
        rating = 0
        reviewDic = nil
        userHandle = ""
        userID = ""
        userAddress = ""
        
        creationTime = Date()
        updatedTime = Date()
        
        isAffiliate = false
        affiliateLogoURL = nil
    
    }
    
    init(json:[String:Any])
    {
        id = (json["id"]as? String) ?? ""
        likes = (json["likes"]as? Int) ?? 0
        rating = (json["rate"]as? Double) ?? 0
        reviewDic = json["review"]as? [String:String]
        userHandle = (json["userHandle"]as? String) ?? ""
        userID = (json["userId"]as? String) ?? ""
        userAddress = (json["userAddress"]as? String) ?? ""
        
        if let liked = json["currentUserLiked"]as? Bool
        {
            isLiked = liked
        }
        
    
        if let thisCreated = json["created"]as? Int
        {
            createdServerTime = thisCreated
            creationTime = Date(timeIntervalSince1970: TimeInterval(thisCreated))
            
        }
        else
        {
            createdServerTime = 0
            creationTime = Date(timeIntervalSince1970: TimeInterval(createdServerTime))
        }
        
        if let thisUpdated = json["updated"]as? Int
        {
            updatedServerTime = thisUpdated
            updatedTime = Date(timeIntervalSince1970: TimeInterval(thisUpdated))
            
        }
        else
        {
            updatedServerTime = 0
            updatedTime = Date(timeIntervalSince1970: TimeInterval(updatedServerTime))
        }
        
        if let isAff = json["userAffltCode"]as? Int
        {
            if isAff == 1
            {
                isAffiliate = true
            }
        }
        
        if let thisURLString = json["affiliateLogoURL"]as? String
        {
            affiliateLogoURL = URL(string: APIConstants.ImagesEndPoint + thisURLString)
        }
    
    }
    
    class func currentLanguageForDic(reviewDic: [String:String]) -> String?
    {
        if let thisName = reviewDic[UserObject.sharedInstance.language]
        {
            return thisName
        }
        else
        {
            return reviewDic["en"]
        }
    }

}
