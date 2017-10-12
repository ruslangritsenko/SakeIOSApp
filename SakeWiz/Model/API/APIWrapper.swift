//
//  APIWrapper.swift
//  SakeWiz
//
//  Created by TW welly on 12/29/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import Foundation
import Alamofire
import SystemConfiguration


class API {
    
    fileprivate class func reauth(completionHandler: @escaping () -> Void, failure: @escaping (String?) -> Void)
    {
        if NetworkUtilities.isConnectedToInternet()
        {
            Alamofire.request(APIConstants.baseURL + APIConstants.loginEndPoint, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .authenticate(user: UserObject.sharedInstance.handle, password: UserObject.sharedInstance.password)
                .responseJSON { response in
                    debugPrint(response)
                    
                    if let thisResponse = response.response
                    {
                        switch thisResponse.statusCode
                        {
                        case 200:
                            if let AuthToken = thisResponse.allHeaderFields[APIConstants.APIReturns.AUTH_TOKEN] as? String
                            {
                                UserObject.sharedInstance.authToken = AuthToken
                                
                                print(response.result.value as Any)
                                
                                if let userJSON = response.result.value as? [String:Any]
                                {
                                    
                                    if let handle = userJSON[APIConstants.APIReturns.Login.handle]as? String, handle != APIConstants.system_user
                                    {
                                        print(handle)
                                        UserObject.sharedInstance = UserObject(json: userJSON)
                                        
                                        UserObject.setUserDefaults(user: UserObject.sharedInstance)
                                        
                                        
                                    }
                                    
                                }
                                
                                completionHandler()
                                
                            }
                            else
                            {
                                print("No Auth Token")
                                failure(nil)
                            }
                        case 401:
                            print("Forbidden")
                            failure("Invalid handle or password")
                        default:
                            print("Server Unavailable")
                            failure("Server Unavailable")
                        }
                        
                    }
                    else
                    {
                        print("no response from server")
                        failure("Server now undergoing maintainance".localized())
                    }
            }
            
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
    
    }

    public class func login(username: String, password: String, completionHandler: @escaping () -> Void, failure: @escaping (String?) -> Void)
    {
        
        if NetworkUtilities.isConnectedToInternet()
        {
            Alamofire.request(APIConstants.baseURL + APIConstants.loginEndPoint, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .authenticate(user: username, password: password)
                .responseJSON { response in
                    debugPrint(response)
                    
                    if let thisResponse = response.response
                    {
                        switch thisResponse.statusCode
                        {
                        case 200:
                            if let AuthToken = thisResponse.allHeaderFields[APIConstants.APIReturns.AUTH_TOKEN] as? String
                            {
                                UserObject.sharedInstance.authToken = AuthToken
                                
                                print(response.result.value as Any)
                                
                                if let userJSON = response.result.value as? [String:Any]
                                {
                                    
                                    if let handle = userJSON[APIConstants.APIReturns.Login.handle]as? String, handle != APIConstants.system_user
                                    {
                                        print(handle)
                                        UserObject.sharedInstance = UserObject(json: userJSON)
                                        
                                        UserObject.setUserDefaults(user: UserObject.sharedInstance)
                                        
                                        
                                    }
                                    
                                }
                                
                                completionHandler()
                                
                            }
                            else
                            {
                                print("No Auth Token")
                                failure(nil)
                            }
                        case 401:
                            print("Forbidden")
                            failure("Invalid handle or password")
                        default:
                            print("Server Unavailable")
                            failure("Server Unavailable")
                        }
                        
                    }
                    else
                    {
                        print("no response from server")
                        failure("Server now undergoing maintainance".localized())
                    }
            }
        
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
        
        }
        

    }
    
    public class func authenticate(username: String, password: String, completionHandler: @escaping () -> Void, failure: @escaping (String?) -> Void)
    {
        
        if NetworkUtilities.isConnectedToInternet()
        {
            Alamofire.request(APIConstants.baseURL + APIConstants.loginEndPoint, method: .post, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .authenticate(user: username, password: password)
                .responseJSON { response in
                    debugPrint(response)
                    
                    if let thisResponse = response.response
                    {
                        switch thisResponse.statusCode
                        {
                        case 200:
                            if let AuthToken = thisResponse.allHeaderFields[APIConstants.APIReturns.AUTH_TOKEN] as? String
                            {
                                UserObject.sharedInstance.authToken = AuthToken
                                
                                completionHandler()
                                
                            }
                            else
                            {
                                print("No Auth Token")
                                failure(nil)
                            }
                        default:
                            print("Server Unavailable")
                            failure("Server Unavailable")
                        }
                        
                    }
                    else
                    {
                        print("no response from server")
                        failure(nil)
                    }
            }
        }
        else
        {
            failure(nil)
        }
    }
    
    public class func newUser(user: UserObject, completionHandler: @escaping () -> Void, failure: @escaping (String) -> Void)
    {
        
        if NetworkUtilities.isConnectedToInternet()
        {
            user.authToken = UserObject.sharedInstance.authToken
            
            let params = [
                
                "email":user.email,
                "hndl":user.handle,
                "lang":user.language,
                "pwd":user.password
            ]
            
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            
            print("now creating profile")
            
            
            
            Alamofire.request(APIConstants.baseURL + APIConstants.newUserEndPoint, method: .put, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON(completionHandler: { response in
                    
                    debugPrint(response)
                    
                    if let responseData = response.response
                    {
                        switch responseData.statusCode
                        {
                        case 200:
                            
                            if let data = response.result.value as? [String:Any]
                            {
                                print(data)
                                
                                UserObject.sharedInstance = user
                                
                                UserObject.setUserDefaults(user: user)
                                
                                completionHandler()
                            }
                            else
                            {
                                NSLog("no json")
                                failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            }
                            
                        case 409:
                            if let codesData = response.result.value as? [String:Any]
                            {
                                if let codes = codesData["codes"] as? Array<String>
                                {
                                    for code in codes
                                    {
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                        {
                                            failure(NSLocalizedString("This email has already been registered", comment: ""))
                                            break
                                        }
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                        {
                                            failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                            break
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                }
                            }
                            else
                            {
                                failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                            }
                            
                        case 400:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        default:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        }
                        
                    }
                    else
                    {
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                    }
                    
                })
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
    }
    
    public class func getDashboard(completionHandler: @escaping (DashboardObject) -> Void, failure: @escaping (String?) -> Void)
    {
        
        if NetworkUtilities.isConnectedToInternet()
        {
            
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            Alamofire.request(APIConstants.baseURL + APIConstants.DashboardEndPoint, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .responseJSON(completionHandler: {response in
                    
                    debugPrint(response)
                    
                    if let responseData = response.response
                    {
                        switch responseData.statusCode
                        {
                        case 200:
                            
                            if let data = response.result.value as? [String:Any]
                            {
                                print(data)
                                completionHandler(DashboardObject(json: data))
                            }
                            else
                            {
                                NSLog("no json")
                                failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            }
                            
                        case 401:
                            reauth(completionHandler: {
                                getDashboard(completionHandler: {(dashboardObject) in completionHandler(dashboardObject)}, failure: {_ in })
                                
                            
                            }, failure: {someError in failure(someError)})
                            
                        case 409:
                            if let codesData = response.result.value as? [String:Any]
                            {
                                if let codes = codesData["codes"] as? Array<String>
                                {
                                    for code in codes
                                    {
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                        {
                                            failure(NSLocalizedString("This email has already been registered", comment: ""))
                                            break
                                        }
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                        {
                                            failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                            break
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                }
                            }
                            else
                            {
                                failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                            }
                            
                        case 400:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        default:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        }
                        
                    }
                    else
                    {
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                    }
                    
                    
                })
            
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
    }
    
    public class func getNotifications(notificaitonAmount: String, lastID: String?, completionHandler: @escaping (Array<NotificationObject>, String?) -> Void, failure: @escaping (String?) -> Void)
    {
        let headers = [
            
            "x-auth-token":UserObject.sharedInstance.authToken
        ]
        
        var urlString = APIConstants.baseURL + APIConstants.NotificationsEndPoint + "?size=\(notificaitonAmount)"
        
        if let lastid = lastID
        {
            urlString += "&lastId=\(lastid)"
        }
        
        if let urlencoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        {
            urlString = urlencoded
        }
        
        Alamofire.request(urlString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
            .responseJSON(completionHandler: {response in
    
                print(response)
                
                if let responseData = response.response
                {
                    switch responseData.statusCode
                    {
                    case 200:
                        
                        if let data = response.result.value as? [String:Any]
                        {
                            if let notifications = data["notifications"] as? Array<[String:Any]>
                            {
                                var returnArray = Array<NotificationObject>()
                                for notification in notifications
                                {
                                    if let thisnotification = NotificationObject(json: notification)
                                    {
                                        returnArray.append(thisnotification)
                                    }
                                }
                                
                                if returnArray.count > 0
                                {
                                    completionHandler(returnArray, nil)
                                }
                            
                            }
                        }
                        else
                        {
                            NSLog("no json")
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                        }
                        
                    case 401:
                        reauth(completionHandler: {
                        
                            getNotifications(notificaitonAmount: notificaitonAmount, lastID: lastID, completionHandler: {(notifications, someString) in
                                
                                completionHandler(notifications, someString)
                            
                            }, failure: {someError in failure(someError)})
                        
                        }, failure: {someError in failure("unauthed")})
                        
                    case 400:
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                        
                    default:
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                        
                    }
                    
                }
                else
                {
                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                }

        })
    }
    
    
    public class func searchPlaces(keyword:String)
    {
        let headers = [
            
            "x-auth-token":UserObject.sharedInstance.authToken
        ]
        
        let params = [
        
            "keyword":keyword
        ]
        
        Alamofire.request(APIConstants.baseURL + APIConstants.SearchPlaces, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON(completionHandler: {response in
            
                
                print(response)
            
            
            })
    }
    
    public class func searchProducts(keyword: String, page: String?, size: String?,filters: [String:Array<String>]?, sortOrder: String?, completionHandler: @escaping (Array<ProductObject>) -> Void, failure: @escaping (String?)->Void)
    {
        
        if NetworkUtilities.isConnectedToInternet()
        {
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            var params: [String:Any] = [
                
                "keyword":keyword
            ]
            
            if let types = filters?["types"]
            {
                params["types"] = types
            }
            if let filterWaters = filters?["filterWaters"]
            {
                params["filterWaters"] = filterWaters
            }
            if let pressAndSqueezes = filters?["pressAndSqueezes"]
            {
                params["pressAndSqueezes"] = pressAndSqueezes
            }
            
            var inverted = false
            if let sortString = sortOrder
            {
                var apiSortString = String()
                switch sortString {
                case "Highest Rated".localized():
                    apiSortString = "RATING"
                    inverted = true
                case "Lowest Rated".localized():
                    apiSortString = "RATING"
                case "Most Comments".localized():
                    apiSortString = "RELEVANCE"
                case "Least Comments".localized():
                    apiSortString = "RELEVANCE"
                    inverted = true
                case "Most Favored".localized():
                    apiSortString = "FAVOURED"
                case "Most Reviewed".localized():
                    apiSortString = "REVIEW_COUNT"
                    
                default:
                    apiSortString = ""
                }
                
                params["sortBy"] = apiSortString
            }
            
            
            
            var urlString = APIConstants.baseURL + APIConstants.SearchProducts
            
            if page != nil && size != nil
            {
                urlString = urlString + "?page=\(page!)&size=\(size!)"
            }
            
            
            print("now posting to: \(urlString)")
            print("with Keyword: \(keyword)")
            print("with Params: \(params)")
            
            Alamofire.request(urlString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .responseJSON(completionHandler: {response in
                    
                    print(response)
                    
                    if let responseData = response.response
                    {
                        switch responseData.statusCode
                        {
                        case 200:
                            
                            if let data = response.result.value as? [String:Any]
                            {
                                print(data)
                                
                                if let products = data["products"] as? Array<[String:Any]>
                                {
                                    var newProducts = Array<ProductObject>()
                                    for product in products
                                    {
                                        newProducts.append(ProductObject(json: product))
                                    }
                                    
                                    if inverted
                                    {
                                        print("is inverted")
                                        completionHandler(newProducts.reversed())
                                    }
                                    else
                                    {
                                        print("is not inverted")
                                        completionHandler(newProducts)
                                    }
                                    
                                }
                                
                                
                                
                                
                                //completionHandler(DashboardObject(json: data))
                            }
                            else
                            {
                                NSLog("no json")
                                failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            }
                            
                        case 401:
                            
                            reauth(completionHandler: {
                            
                                searchProducts(keyword: keyword, page: page, size: size, filters: filters, sortOrder: sortOrder, completionHandler: {(products) in completionHandler(products)}, failure: {someError in failure(someError)})
                            
                            
                            }, failure: {_ in failure("unauthed")})
                            
                            
                        case 409:
                            if let codesData = response.result.value as? [String:Any]
                            {
                                if let codes = codesData["codes"] as? Array<String>
                                {
                                    for code in codes
                                    {
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                        {
                                            failure(NSLocalizedString("This email has already been registered", comment: ""))
                                            break
                                        }
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                        {
                                            failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                            break
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                }
                            }
                            else
                            {
                                failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                            }
                            
                        case 400:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        default:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        }
                        
                    }
                    else
                    {
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                    }
                    
                    
                })
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
        
    }
    
    public class func searchSuggestedPlaces(completionHandler: @escaping (String) -> Void, failure: @escaping (String?)->Void)
    {
        if NetworkUtilities.isConnectedToInternet()
        {
            
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
    }
    
    public class func searchSuggestedProducts(completionHandler: @escaping (String) -> Void, failure: @escaping (String?)->Void)
    {
        if NetworkUtilities.isConnectedToInternet()
        {
        
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
    
    }
    
    public class func uploadPictureWith(image: UIImage, progressHandler: @escaping (Double)->Void, completionHandler: @escaping (String) -> Void, failure: @escaping (String?)->Void)
    {
        
        if NetworkUtilities.isConnectedToInternet()
        {
            var imageCompressionThreashold = CGFloat(1.0)
            //        var params: [String:Any] = [
            //
            //            "keyword":keyword
            //        ]
            
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            
            if let imageStuff: Data = UIImageJPEGRepresentation(image, 1.0)
            {
                
                let imageSize = imageStuff.count
                
                print("Original Image Size: \(imageSize / 1024) KB")
                
                if imageSize > 1048576
                {
                    let newCompressionRate = CGFloat(1048576) / CGFloat(imageSize)
                    
                    print(newCompressionRate)
                    
                    if let imgData: Data = UIImageJPEGRepresentation(image, newCompressionRate)
                    {
                        let imgSize = imgData.count
                        
                        imageCompressionThreashold = newCompressionRate
                        
                        print("New Image Size: \(imgSize / 1024) KB")
                    }
                }
            }
            
            
            
            
            
            if let imageData = UIImageJPEGRepresentation(image, imageCompressionThreashold)
            {
                Alamofire.upload(multipartFormData: {multipartFormData in
                    
                    //            for (key, value) in params
                    //            {
                    //                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
                    //            }
                    
                    
                    //multipartFormData.append(imageData, withName: "file")
                    multipartFormData.append(imageData, withName: "file", fileName: "swift_file.jpeg", mimeType: "image/jpeg")
                    
                }, usingThreshold:UInt64.init(), to: APIConstants.baseURL + APIConstants.ScanAndMatch.ScanEndpoint, method: .post, headers: headers, encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            
                            //Print progress
                            print(progress)
                            
                            progressHandler(progress.fractionCompleted)
                            
                        })
                        
                        upload.responseJSON { response in
                            debugPrint(response)
                          
                            
                            if let responseData = response.response
                            {
                                switch responseData.statusCode
                                {
                                case 200:
                                    
                                    if let json = response.result.value as? [String:Any]
                                    {
                                        if let id = json["id"]as? String
                                        {
                                            completionHandler(id)
                                        }
                                        
                                    }
                                    else
                                    {
                                        failure("no json")
                                    }
                                    
                                case 401:
                                    
                                    reauth(completionHandler: {
                                    
                                        uploadPictureWith(image: image, progressHandler: {thisProgress in progressHandler(thisProgress)}, completionHandler: {passedVar in completionHandler(passedVar)}, failure: {someError in failure(someError)})
                                        
                                        
                                    }, failure: {_ in failure("unauthed")})

                                case 500:
                                    failure("Internal Server Error".localized())
                                    
                                case 400:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                default:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                }
                                
                            }
                            else
                            {
                                failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            }
                            
                        }
                    case .failure(let encodingError):
                        print(encodingError)
                        failure(nil)
                    }
                })
            }
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
        
    }
    
    public class func checkImageProcessingStatus(ID: String, completionHandler: @escaping (Array<String>, String?) -> Void, failure: @escaping (String?)->Void)
    {
        if NetworkUtilities.isConnectedToInternet()
        {
        
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            Alamofire.request(APIConstants.baseURL + APIConstants.ScanAndMatch.ScanEndpoint + "/\(ID)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .responseJSON(completionHandler: {response in
                    
                    debugPrint(response)
                    
                    if let responseData = response.response
                    {
                        switch responseData.statusCode
                        {
                        case 200:
                            
                            if let data = response.result.value as? [String:Any]
                            {
                                print(data)
                                
                                if let matches = data["matches"]as? Array<String>
                                {
                                    completionHandler(matches, data["stat"]as? String)
                                }
                                
                            }
                            else
                            {
                                NSLog("no json")
                            }
                            
                        case 401:
                            reauth(completionHandler: {
                            
                                checkImageProcessingStatus(ID: ID, completionHandler: {(someArray, someString)in completionHandler(someArray,someString)}, failure: {someError in failure(someError)})
                            
                            }, failure: {someError in failure(someError)})
                            
                        case 409:
                            if let codesData = response.result.value as? [String:Any]
                            {
                                if let codes = codesData["codes"] as? Array<String>
                                {
                                    for code in codes
                                    {
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                        {
                                            failure(NSLocalizedString("This email has already been registered", comment: ""))
                                            break
                                        }
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                        {
                                            failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                            break
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                }
                            }
                            else
                            {
                                failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                            }
                            
                        case 400:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        default:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        }
                        
                    }
                    else
                    {
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                    }
                })
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
        
    }
    
    public class func getProductDetailsBy(ID: String, completionHandler: @escaping (ProductObject) -> Void, failure: @escaping (String?)->Void)
    {
        if NetworkUtilities.isConnectedToInternet()
        {
            
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            Alamofire.request(APIConstants.baseURL + APIConstants.ProductDetailsEndPoint + "/\(ID)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .responseJSON(completionHandler: {response in
                    
                    debugPrint(response)
                    
                    if let responseData = response.response
                    {
                        switch responseData.statusCode
                        {
                        case 200:
                            
                            if let data = response.result.value as? [String:Any]
                            {
                                print(data)
                                if let product = data["product"]as? [String:Any]
                                {
                                    completionHandler(ProductObject(json: product, userDic: data))
                                }
                                
                            }
                            else
                            {
                                NSLog("no json")
                            }
                            
                        case 401:
                            reauth(completionHandler: {
                            
                                getProductDetailsBy(ID: ID, completionHandler: {someProduct in completionHandler(someProduct)}, failure: {errorMessage in failure(errorMessage)})
                            
                            }, failure: {errorMessage in failure(errorMessage)})
                            
                        case 409:
                            if let codesData = response.result.value as? [String:Any]
                            {
                                if let codes = codesData["codes"] as? Array<String>
                                {
                                    for code in codes
                                    {
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                        {
                                            failure(NSLocalizedString("This email has already been registered", comment: ""))
                                            break
                                        }
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                        {
                                            failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                            break
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                }
                            }
                            else
                            {
                                failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                            }
                            
                        case 400:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        default:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        }
                        
                    }
                    else
                    {
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                    }
                })
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
        
    }
    
    public class func getProductBy(ID: String, completionHandler: @escaping (ProductObject) -> Void, failure: @escaping (String?)->Void)
    {
        if NetworkUtilities.isConnectedToInternet()
        {
            
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            Alamofire.request(APIConstants.baseURL + APIConstants.ProductEndPoint + "/\(ID)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .responseJSON(completionHandler: {response in
                    
                    debugPrint(response)
                    
                    if let responseData = response.response
                    {
                        switch responseData.statusCode
                        {
                        case 200:
                            
                            if let data = response.result.value as? [String:Any]
                            {
                                print(data)
                                completionHandler(ProductObject(json: data))

                                
                            }
                            else
                            {
                                NSLog("no json")
                            }
                            
                        case 401:
                            
                            reauth(completionHandler: {
                                
                                getProductBy(ID: ID, completionHandler: {someProduct in completionHandler(someProduct)}, failure: {errorMessage in failure(errorMessage)})
                                
                            }, failure: {errorMessage in failure(errorMessage)})
                            
                        case 409:
                            if let codesData = response.result.value as? [String:Any]
                            {
                                if let codes = codesData["codes"] as? Array<String>
                                {
                                    for code in codes
                                    {
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                        {
                                            failure(NSLocalizedString("This email has already been registered", comment: ""))
                                            break
                                        }
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                        {
                                            failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                            break
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                }
                            }
                            else
                            {
                                failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                            }
                            
                        case 400:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        default:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        }
                        
                    }
                    else
                    {
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                    }
                })
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
        
    }
    
    
    public class func getProductReviewsBy(ID: String, size: Int?, lastID: String?, completionHandler: @escaping (Array<ReviewObject>, Double?) -> Void, failure: @escaping (String?)->Void)
    {
        if NetworkUtilities.isConnectedToInternet()
        {
            
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            var urlParams = ""
            
            if let thisSize = size
            {
                
                if urlParams == ""
                {
                    urlParams += "?"
                }
                else
                {
                    urlParams += "&"
                }
                
                urlParams += "size=\(thisSize)"
            }
            
            if let thisLastID = lastID
            {
                if urlParams == ""
                {
                    urlParams += "?"
                }
                else
                {
                    urlParams += "&"
                }
                urlParams += "lastId=\(thisLastID)"
            
            }
            
            Alamofire.request(APIConstants.baseURL + APIConstants.ReviewsEndPoint + "/\(ID)", method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .responseJSON(completionHandler: {response in
                    
                    debugPrint(response)
                    
                    if let responseData = response.response
                    {
                        switch responseData.statusCode
                        {
                        case 200:
                            
                            if let data = response.result.value as? [String:Any]
                            {
                                print(data)
                                
                                let avgRate = data["avgRate"]as? Double
                                
                                var reviewsArray = Array<ReviewObject>()
                                
                                if let reviews = data["reviews"]as? Array<[String:Any]>
                                {
                                    for review in reviews
                                    {
                                        reviewsArray.append(ReviewObject(json: review))
                                    }
                                }
                                
                                completionHandler(reviewsArray, avgRate)
                                
                            }
                            else
                            {
                                NSLog("no json")
                            }
                            
                        case 401:
                            
                            reauth(completionHandler: {
                                
                                getProductReviewsBy(ID: ID, size: size, lastID: lastID, completionHandler: {someReview, someRate in completionHandler(someReview, someRate)}, failure: {errorMessage in failure(errorMessage)})
                                
                            }, failure: {errorMessage in failure(errorMessage)})
                            
                        case 409:
                            if let codesData = response.result.value as? [String:Any]
                            {
                                if let codes = codesData["codes"] as? Array<String>
                                {
                                    for code in codes
                                    {
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                        {
                                            failure(NSLocalizedString("This email has already been registered", comment: ""))
                                            break
                                        }
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                        {
                                            failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                            break
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                }
                            }
                            else
                            {
                                failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                            }
                            
                        case 400:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        default:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        }
                        
                    }
                    else
                    {
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                    }
                })
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
        
    }
    
    
    public class func likeReviewWith(EntityID: String, completionHandler: @escaping (Int?) -> Void, failure: @escaping (String?)->Void)
    {
        if NetworkUtilities.isConnectedToInternet()
        {
            
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            Alamofire.request(APIConstants.baseURL + APIConstants.LikeReviewEndPoint + "/\(EntityID)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .responseJSON(completionHandler: {response in
                    
                    debugPrint(response)
                    
                    if let responseData = response.response
                    {
                        switch responseData.statusCode
                        {
                        case 200:
                            if let data = response.result.value as? [String:Any]
                            {
                                print(data)
                                completionHandler(data["likes"]as? Int)
                                
                                
                            }
                            else
                            {
                                NSLog("no json")
                            }
                            
                        case 401:
                            
                            reauth(completionHandler: {
                                
                                likeReviewWith(EntityID: EntityID, completionHandler: {likes in
                                
                                    completionHandler(likes)
                                
                                }, failure: {errorMessage in failure(errorMessage)})
                                
                            }, failure: {errorMessage in failure(errorMessage)})
                            
                        case 409:
                            if let codesData = response.result.value as? [String:Any]
                            {
                                if let codes = codesData["codes"] as? Array<String>
                                {
                                    for code in codes
                                    {
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                        {
                                            failure(NSLocalizedString("This email has already been registered", comment: ""))
                                            break
                                        }
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                        {
                                            failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                            break
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                }
                            }
                            else
                            {
                                failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                            }
                            
                        case 400:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        default:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        }
                        
                    }
                    else
                    {
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                    }
                })
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
        
    }
    
    
    public class func unlikeReviewWith(EntityID: String, completionHandler: @escaping (Int?) -> Void, failure: @escaping (String?)->Void)
    {
        if NetworkUtilities.isConnectedToInternet()
        {
            
            let headers = [
                
                "x-auth-token":UserObject.sharedInstance.authToken
            ]
            
            Alamofire.request(APIConstants.baseURL + APIConstants.UnlikeReviewEndPoint + "/\(EntityID)", method: .post, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .responseJSON(completionHandler: {response in
                    
                    debugPrint(response)
                    
                    if let responseData = response.response
                    {
                        switch responseData.statusCode
                        {
                        case 200:
                            if let data = response.result.value as? [String:Any]
                            {
                                print(data)
                                
                                completionHandler(data["likes"]as? Int)

                                
                            }
                            else
                            {
                                NSLog("no json")
                            }
                            
                        case 401:
                            
                            reauth(completionHandler: {
                                
                                
                                
                            }, failure: {errorMessage in failure(errorMessage)})
                            
                        case 409:
                            if let codesData = response.result.value as? [String:Any]
                            {
                                if let codes = codesData["codes"] as? Array<String>
                                {
                                    for code in codes
                                    {
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                        {
                                            failure(NSLocalizedString("This email has already been registered", comment: ""))
                                            break
                                        }
                                        if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                        {
                                            failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                            break
                                        }
                                        
                                    }
                                }
                                else
                                {
                                    failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                }
                            }
                            else
                            {
                                failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                            }
                            
                        case 400:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        default:
                            failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            
                        }
                        
                    }
                    else
                    {
                        failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                    }
                })
        }
        else
        {
            failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
            
        }
        
    }
    
    class ReviewService
    {
        public class func submitProductReviewWith(productID: String, comment: String, rating: Double, completionHandler: @escaping (String?, Double?) -> Void, failure: @escaping (String?)->Void)
        {
            
            if NetworkUtilities.isConnectedToInternet()
            {
                
                let headers = [
                    
                    "x-auth-token":UserObject.sharedInstance.authToken
                ]
                let commentDic = [UserObject.sharedInstance.language:comment]
                
                let params = [
                
                    "comment":commentDic,
                    "rate":rating
                ] as [String : Any]
                
                let urlString = APIConstants.baseURL + APIConstants.ReviewEndpoints.ProductReviewEndpoint + "/\(productID)"
                var s = CharacterSet.urlQueryAllowed
                s.insert(charactersIn: "+&")
                
                if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s)
                {
                    Alamofire.request(encodedString, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                        .responseJSON(completionHandler: {response in
                            
                            debugPrint(response)
                            
                            if let responseData = response.response
                            {
                                switch responseData.statusCode
                                {
                                case 200:
                                    if let data = response.result.value as? [String:Any]
                                    {
                                        print(data)
                                        print(data["rate"]as? Double)
                                        
                                        completionHandler(data["id"]as? String, data["rate"]as? Double)
                                        
                                        
                                    }
                                    else
                                    {
                                        NSLog("no json")
                                    }
                                    
                                case 401:
                                    
                                    API.reauth(completionHandler: {
                                        
                                        submitProductReviewWith(productID: productID, comment: comment, rating: rating, completionHandler: {newID, newRating in completionHandler(newID, newRating)}, failure: {errorMessage in failure(errorMessage)})
                                        
                                    }, failure: {errorMessage in failure(errorMessage)})
                                    
                                case 409:
                                    if let codesData = response.result.value as? [String:Any]
                                    {
                                        if let codes = codesData["codes"] as? Array<String>
                                        {
                                            for code in codes
                                            {
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                                {
                                                    failure(NSLocalizedString("This email has already been registered", comment: ""))
                                                    break
                                                }
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                                {
                                                    failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                                    break
                                                }
                                                
                                            }
                                        }
                                        else
                                        {
                                            failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                        }
                                    }
                                    else
                                    {
                                        failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                    }
                                    
                                case 400:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                default:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                }
                                
                            }
                            else
                            {
                                failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            }
                        })
                }
                else
                {
                    failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
                    
                }
                }
                else
                {
                    print("Improper URL encoding")
                    failure(nil)
                }
        
        }
    
    }
    
    class ProductDetailsService
    {
        public class func unfavorProductWith(ID: String, completionHandler: @escaping () -> Void, failure: @escaping (String?)->Void)
        {
            if NetworkUtilities.isConnectedToInternet()
            {
                
                let headers = [
                    
                    "x-auth-token":UserObject.sharedInstance.authToken
                ]
                
                let urlString = APIConstants.baseURL + APIConstants.ProductDetailsEndpoints.UnfavorEndPoint + "/\(ID)"
                var s = CharacterSet.urlQueryAllowed
                s.insert(charactersIn: "+&")
                
                if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s)
                {
                    Alamofire.request(encodedString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                        .responseJSON(completionHandler: {response in
                            
                            debugPrint(response)
                            
                            if let responseData = response.response
                            {
                                switch responseData.statusCode
                                {
                                case 200:
                                    
                                    completionHandler()
                                    if let data = response.result.value as? [String:Any]
                                    {
                                        print(data)
                                        
                                        
                                    }
                                    else
                                    {
                                        NSLog("no json")
                                    }
                                    
                                case 401:
                                    
                                    API.reauth(completionHandler: {
                                        
                                        unfavorProductWith(ID: ID, completionHandler: {completionHandler()}, failure: {errorMessage in failure(errorMessage)})
                                        
                                    }, failure: {errorMessage in failure(errorMessage)})
                                    
                                case 409:
                                    if let codesData = response.result.value as? [String:Any]
                                    {
                                        if let codes = codesData["codes"] as? Array<String>
                                        {
                                            for code in codes
                                            {
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                                {
                                                    failure(NSLocalizedString("This email has already been registered", comment: ""))
                                                    break
                                                }
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                                {
                                                    failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                                    break
                                                }
                                                
                                            }
                                        }
                                        else
                                        {
                                            failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                        }
                                    }
                                    else
                                    {
                                        failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                    }
                                    
                                case 400:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                default:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                }
                                
                            }
                            else
                            {
                                failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            }
                        })
                }
                else
                {
                    failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
                    
                }
            }
            else
            {
                print("Improper URL encoding")
                failure(nil)
            }
        
        }
        
        public class func favorProductWith(ID: String, completionHandler: @escaping () -> Void, failure: @escaping (String?)->Void)
        {
            if NetworkUtilities.isConnectedToInternet()
            {
                
                let headers = [
                    
                    "x-auth-token":UserObject.sharedInstance.authToken
                ]
                
                let urlString = APIConstants.baseURL + APIConstants.ProductDetailsEndpoints.FavorEndpoint + "/\(ID)"
                var s = CharacterSet.urlQueryAllowed
                s.insert(charactersIn: "+&")
                
                if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s)
                {
                    Alamofire.request(encodedString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                        .responseJSON(completionHandler: {response in
                            
                            debugPrint(response)
                            
                            if let responseData = response.response
                            {
                                switch responseData.statusCode
                                {
                                case 200:
                                    
                                    completionHandler()
                                    if let data = response.result.value as? [String:Any]
                                    {
                                        print(data)
                                        
                                        
                                    }
                                    else
                                    {
                                        NSLog("no json")
                                    }
                                    
                                case 401:
                                    
                                    API.reauth(completionHandler: {
                                        
                                        favorProductWith(ID: ID, completionHandler: {completionHandler()}, failure: {errorMessage in failure(errorMessage)})
                                        
                                    }, failure: {errorMessage in failure(errorMessage)})
                                    
                                case 409:
                                    if let codesData = response.result.value as? [String:Any]
                                    {
                                        if let codes = codesData["codes"] as? Array<String>
                                        {
                                            for code in codes
                                            {
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                                {
                                                    failure(NSLocalizedString("This email has already been registered", comment: ""))
                                                    break
                                                }
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                                {
                                                    failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                                    break
                                                }
                                                
                                            }
                                        }
                                        else
                                        {
                                            failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                        }
                                    }
                                    else
                                    {
                                        failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                    }
                                    
                                case 400:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                default:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                }
                                
                            }
                            else
                            {
                                failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            }
                        })
                }
                else
                {
                    failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
                    
                }
            }
            else
            {
                print("Improper URL encoding")
                failure(nil)
            }
            
        }
    
    }
    
    class Match
    {
        public class func reportMatchWith(scanID: String, productID: String, completionHandler: @escaping () -> Void, failure: @escaping (String?)->Void)
        {
            
            if NetworkUtilities.isConnectedToInternet()
            {
                
                let headers = [
                    
                    "x-auth-token":UserObject.sharedInstance.authToken
                ]
                
                let urlString = APIConstants.baseURL + APIConstants.ScanAndMatch.ScanEndpoint + "/\(scanID)/" + APIConstants.ScanAndMatch.MatchEndPoint + "/\(productID)"
                var s = CharacterSet.urlQueryAllowed
                s.insert(charactersIn: "+&")
                
                if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s)
                {
                    Alamofire.request(encodedString, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                        .responseJSON(completionHandler: {response in
                            
                            debugPrint(response)
                            
                            if let responseData = response.response
                            {
                                switch responseData.statusCode
                                {
                                case 200:
                                    
                                    print("successfully reported")
                                    completionHandler()
                                    
                                case 401:
                                    
                                    API.reauth(completionHandler: {
                                        
                                        reportMatchWith(scanID: scanID, productID: productID, completionHandler: {completionHandler()}, failure: {errorString in failure(errorString)})
                                        
                                    }, failure: {errorMessage in failure(errorMessage)})
                                    
                                case 409:
                                    if let codesData = response.result.value as? [String:Any]
                                    {
                                        if let codes = codesData["codes"] as? Array<String>
                                        {
                                            for code in codes
                                            {
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                                {
                                                    failure(NSLocalizedString("This email has already been registered", comment: ""))
                                                    break
                                                }
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                                {
                                                    failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                                    break
                                                }
                                                
                                            }
                                        }
                                        else
                                        {
                                            failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                        }
                                    }
                                    else
                                    {
                                        failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                    }
                                    
                                case 400:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                default:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                }
                                
                            }
                            else
                            {
                                failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            }
                        })
                }
                else
                {
                    failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
                    
                }
            }
            else
            {
                print("Improper URL encoding")
                failure(nil)
            }
        
        }
    }
    
    class User
    {
        public class func getUserBy(userHandle: String, completionHandler: @escaping (UserObject) -> Void, failure: @escaping (String?)->Void)
        {
            if NetworkUtilities.isConnectedToInternet()
            {
                
                let headers = [
                    
                    "x-auth-token":UserObject.sharedInstance.authToken
                ]
                
                let urlString = APIConstants.baseURL + APIConstants.UserEndpoints.UserEndPoint + "/\(userHandle)"
                var s = CharacterSet.urlQueryAllowed
                s.insert(charactersIn: "+&")
                
                if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s)
                {
                    Alamofire.request(encodedString, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                        .responseJSON(completionHandler: {response in
                            
                            debugPrint(response)
                            
                            if let responseData = response.response
                            {
                                switch responseData.statusCode
                                {
                                case 200:
                                    if let data = response.result.value as? [String:Any]
                                    {
                                        print(data)
                                        
                                        completionHandler(UserObject(json: data))
                                        
                                    }
                                    else
                                    {
                                        failure("no json")
                                    }
                                    
                                case 401:
                                    
                                    API.reauth(completionHandler: {
                                        
                                        getUserBy(userHandle: userHandle, completionHandler: {user in completionHandler(user)}, failure: {errorMessage in failure(errorMessage)})
                                        
                                    }, failure: {errorMessage in failure(errorMessage)})
                                    
                                case 409:
                                    if let codesData = response.result.value as? [String:Any]
                                    {
                                        if let codes = codesData["codes"] as? Array<String>
                                        {
                                            for code in codes
                                            {
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.Email_Already_Registered_Error
                                                {
                                                    failure(NSLocalizedString("This email has already been registered", comment: ""))
                                                    break
                                                }
                                                if code == APIConstants.APIReturns.New_User.ErrorCodes.User_Handle_Aleardy_Taken_Error
                                                {
                                                    failure(NSLocalizedString("This user handle has already been taken", comment: ""))
                                                    break
                                                }
                                                
                                            }
                                        }
                                        else
                                        {
                                            failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                        }
                                    }
                                    else
                                    {
                                        failure(NSLocalizedString("Email or UserID have already been taken", comment: ""))
                                    }
                                    
                                case 400:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                default:
                                    failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                                    
                                }
                                
                            }
                            else
                            {
                                failure(NSLocalizedString(APIConstants.APIReturns.GenericErrorStrings.CANNOT_BE_DONE, comment: ""))
                            }
                        })
                }
                else
                {
                    failure(APIConstants.APIReturns.GenericErrorStrings.NO_NETWORK)
                    
                }
            }
            else
            {
                print("Improper URL encoding")
                failure(nil)
            }
        }
    
    }

}
