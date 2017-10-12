//
//  FollowerNotificationObject.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/14.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation

class FollowerNotificationObject {


    var followerUserHandle = ""
    var followerUserId = ""
    var followerUserImg = ""
    var followerUserName = ""

    init(json: [String:Any])
    {
        followerUserHandle = (json["followerUserHandle"]as? String) ?? ""
        followerUserId = (json["followerUserId"]as? String) ?? ""
        followerUserImg = (json["followerUserImg"]as? String) ?? ""
        followerUserName = (json["followerUserName"]as? String) ?? ""
    }

}
