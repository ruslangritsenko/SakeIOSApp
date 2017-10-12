//
//  UserObject.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/22.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation
import KeychainSwift

class UserObject
{
    static var sharedInstance = UserObject()
    
    
    var authToken = ""
    var securityToken = ""
    
    var location: String
    
    var email: String
    var handle: String
    var language: String
    var password: String
    
    var points: Int
    
    var type: String
    
    
    
    var id: String
    
    var isActive = false
    var isConfirmed = false
    
    var userRank: String
    
    var motto: String
    
    
    
    var userAvatarURL: URL?
    
    var userSettings:UserSettingsObject? = nil
    
    
    init()
    {
        authToken = ""
        location = ""
        
        email = ""
        handle = ""
        language = ""
        password = ""
        userAvatarURL = nil
        
        points = 0
        isActive = false
        isConfirmed = false
        id = ""
        userRank = ""
        
        type = "U"
        
        motto = ""
    }
    
    init(json: [String:Any])
    {
        self.authToken = UserObject.sharedInstance.authToken
        self.securityToken = UserObject.sharedInstance.securityToken
        
        self.email = (json["email"] as? String) ?? ""
        self.handle = (json["hndl"] as? String) ?? ""
        self.language = (json["lang"] as? String) ?? ""
        self.password = (json["pwd"] as? String) ?? ""
        self.type = (json["type"] as? String) ?? ""
        self.points = (json["pnts"] as? Int) ?? 0
        
        self.id = (json["id"] as? String) ?? ""
        
        if let picString = json["pic"]as? String
        {
            self.userAvatarURL = URL(string: APIConstants.ImagesEndPoint + picString)
        }
        
        
        if let thisLocation = json["loc"]as? String
        {
            self.location = thisLocation
        }
        else
        {
            print("loc not found... defaulting")
            
            if let thisLocation = json["address"]as? String
            {
                print(thisLocation)
                self.location = thisLocation
            }
            else
            {
                print("no address")
                self.location = UserDefaults.standard.string(forKey: "location") ?? ""
            }
        }
        
        
        self.userRank = (json["userRank"] as? String) ?? ""
        
        if let thisBool = json["confirmed"] as? Bool
        {
            self.isConfirmed = thisBool
        }
        else if let thisInt = json["confirmed"] as? Int
        {
            if thisInt == 1
            {
                self.isConfirmed = true
            }
        }
        
        if let thisBool = json["active"] as? Bool
        {
            self.isConfirmed = thisBool
        }
        else if let thisInt = json["active"] as? Int
        {
            if thisInt == 1
            {
                self.isConfirmed = true
            }
        }
        
        self.motto = (json["motto"]as? String) ?? ""
        
    
    }
    
    
    class func getUserDefaults() -> UserObject?
    {
        print(UserDefaults.standard.string(forKey: "handle") as Any)
        if let handle = UserDefaults.standard.string(forKey: "handle")
        {
            
        
            let keychain = KeychainSwift()
            
            if let thisPassword = keychain.get("password")
            {
                let user = UserObject()
                user.password = thisPassword
                user.handle = handle
                user.language = (UserDefaults.standard.string(forKey: "language")) ?? "en"
                
                user.location = UserDefaults.standard.string(forKey: "location") ?? ""
                
                user.id = UserDefaults.standard.string(forKey: "userID") ?? ""
                user.location = UserDefaults.standard.string(forKey: "location") ?? ""
                
                if let thesePoints = UserDefaults.standard.object(forKey: "points")as? Int
                {
                    user.points = thesePoints
                }
                
                user.userAvatarURL = UserDefaults.standard.object(forKey: "userAvatarURL")as? URL
                
                user.userRank = (UserDefaults.standard.string(forKey: "userRank")) ?? ""
                
                user.type = (UserDefaults.standard.string(forKey: "type")) ?? ""
                
                let userSettings = UserSettingsObject()
                
                userSettings.autoSignInEnabled = (UserDefaults.standard.object(forKey: "autoSignInEnabled")as? Bool) ?? true
                userSettings.canSavePhotosToLibrary = (UserDefaults.standard.object(forKey: "canSavePhotosToLibrary")as? Bool) ?? false
                userSettings.shouldShowCommentsInSelectedLanguageOnly = (UserDefaults.standard.object(forKey: "shouldShowCommentsInSelectedLanguageOnly")as? Bool) ?? false
                
                user.userSettings = userSettings
                
                
                return user
            }
            else
            {
                return nil
            }
            
        }
        else
        {
            return nil
        }
    }
    
    class func setUserDefaults(user: UserObject)
    {
        let keychain = KeychainSwift()
        keychain.set(user.password, forKey: "password")
        
        UserDefaults.standard.set(user.email, forKey: "email")
        UserDefaults.standard.set(user.handle, forKey: "handle")
        UserDefaults.standard.set(user.language, forKey: "language")
        
        
        UserDefaults.standard.set(user.id, forKey: "userID")
        UserDefaults.standard.set(user.location, forKey: "location")
        UserDefaults.standard.set(user.points, forKey: "points")
        UserDefaults.standard.set(user.userRank, forKey: "userRank")
        UserDefaults.standard.set(user.type, forKey: "type")
        
        UserDefaults.standard.synchronize()
        print("all set")
    }
    
    func clearUserDefaultsAndKeyChain()
    {
        UserDefaults.standard.removeObject(forKey: "SavedUser")
        let keychain = KeychainSwift()
        keychain.clear()
    
    }
    
    class func setAvatarURL()
    {
        UserDefaults.standard.set(UserObject.sharedInstance.userAvatarURL, forKey: "userAvatarURL")
        UserDefaults.standard.synchronize()
    }
    
    class func setSettings()
    {
        if let theseUserSettings = UserObject.sharedInstance.userSettings
        {
            UserDefaults.standard.set(theseUserSettings.autoSignInEnabled, forKey: "autoSignInEnabled")
            UserDefaults.standard.set(theseUserSettings.canSavePhotosToLibrary, forKey: "canSavePhotosToLibrary")
            UserDefaults.standard.set(theseUserSettings.shouldShowCommentsInSelectedLanguageOnly, forKey: "shouldShowCommentsInSelectedLanguageOnly")
            
            UserDefaults.standard.synchronize()
        }
        else
        {
            print("error saving settings: UserSettingsObject was nil")
        }
    }

}
