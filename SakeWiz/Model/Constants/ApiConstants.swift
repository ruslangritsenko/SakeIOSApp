//
//  ApiConstants.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/22.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation

struct APIConstants
{
    static let baseURL = "/"
    static let loginEndPoint = "user/login"
    static let newUserEndPoint = "user"
    static let DashboardEndPoint = "facade/user"
    static let ImagesEndPoint = ""
    static let NotificationsEndPoint = "facade/user/notifications"
    
    static let SearchPlaces = "search/places"
    static let SearchProducts = "search/products"
    static let SearchSuggestedPlaces = "search/suggest/places"
    static let SearchSuggestedProducts = "search/suggest/products"
    
    static let ProductDetailsEndPoint = "facade/product"
    static let ProductEndPoint = "product"
    
    static let ReviewsEndPoint = "reviews"
    
    
    
    static let LikeReviewEndPoint = "like/review"
    static let UnlikeReviewEndPoint = "unlike/review"
    

    static let system_user = ""
    static let user_creation_pass = ""
    
    
    struct ReviewEndpoints
    {
        
        static let ProductReviewEndpoint = "review/product"
    
    }
    
    struct ProductDetailsEndpoints
    {
        static let FavorEndpoint = "favour/product"
        static let UnfavorEndPoint = "unfavour/product"
    }
    
    struct ScanAndMatch
    {
        static let ScanEndpoint = "label/scan"
        static let MatchEndPoint = "match"
    }
    
    struct UserEndpoints
    {
        static let UserEndPoint = "user"
    }
    
    struct APIReturns
    {
        struct Login
        {
            
            static let email = "email"
            static let handle = "hndl"
            static let language = "lang"
            static let password = "pwd"
            static let type = "type"
            
        }
        
        
        struct New_User
        {
            struct ErrorCodes
            {
                static let Email_Already_Registered_Error = "C100"
                static let User_Handle_Aleardy_Taken_Error = "C101"
            }
        
        }
        
        static let AUTH_TOKEN = "x-auth-token"
        
        
        struct GenericErrorStrings {
            
            static let CANNOT_BE_DONE = NSLocalizedString("Could not be completed", comment: "")
            static let NO_NETWORK = NSLocalizedString("Please connect to the internet and try again", comment: "")
            
        }
    }
    
    

}
