//
//  DashboardObject.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/24.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation

class DashboardObject {


    var favBarCount: Int
    var favSakeCount: Int
    var notificationCount: Int
    var followerCount: Int
    var favBreweryCount: Int
    var userProfileImageURL: String
    var labelCount: Int
    var sakeIdentified: Int
    var followingCount: Int
    var sakeUnidentified: Int
    var wizCredits: Int
    
    var recommendedProducts: Array<ProductObject>?




    init() {
        
        favBarCount = 0
        favSakeCount = 0
        notificationCount = 0
        followerCount = 0
        favBreweryCount = 0
        userProfileImageURL = ""
        labelCount = 0
        sakeIdentified = 0
        followingCount = 0
        sakeUnidentified = 0
        wizCredits = 0
        
        recommendedProducts = nil
    }
    
    init(json: [String:Any])
    {
        favBarCount = (json["favBarCount"]as? Int) ?? 0
        favSakeCount = (json["favSakeCount"]as? Int) ?? 0
        notificationCount = (json["notificationCount"]as? Int) ?? 0
        wizCredits = (json["wizPoints"]as? Int) ?? 0
        followerCount = (json["followerCount"]as? Int) ?? 0
        favBreweryCount = (json["favBreweryCount"]as? Int) ?? 0
        if let urlString = json["userProfileImg"]as? String
        {
            userProfileImageURL = APIConstants.ImagesEndPoint + urlString
        }
        else
        {
            userProfileImageURL = ""
        }
        labelCount = (json["labelCount"]as? Int) ?? 0
        sakeIdentified = (json["sakeIdentified"]as? Int) ?? 0
        followingCount = (json["followingCount"]as? Int) ?? 0
        sakeUnidentified = (json["sakeUnidentified"]as? Int) ?? 0
        
        
        if let productsArray = json["recommendedProducts"]as? Array<[String:Any]>, productsArray.count > 0
        {
            
            var newProducts = Array<ProductObject>()
            
            for product in productsArray
            {
                newProducts.append(ProductObject(json: product))
            }
            
            recommendedProducts = newProducts
        
        }
        else
        {
            recommendedProducts = nil
        }
    
    }









}
