//
//  RecommendedProductObject.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/24.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation

class ProductObject {



    var acidity: String = ""
    var alcPerc: String = ""
    var aminoAcid: String = ""
    var isAvailableToPublic: Bool
    var brewYear:Int = 0
    var category: String = ""
    var createType: String = ""
    var filterWater: String = ""
    var id: String = ""
    var isInProduction:Bool
    var kakeRatio:String = ""
    var kojiRatio:String = ""
    var isLabelInDatabase: Bool
    var mainImageURLString: String = ""
    var sakeNameDic:[String:String]
    var sakeName: String = ""
    var pastorizeTankStorage: String = ""
    var pressAndSqueeze: String = ""
    var riceKake: String = ""
    var riceKoji: String = ""
    var type: String = ""
    var userID: String = ""
    var yeast: String = ""
    var smv: Int = 0
    
    var countryCd: String = ""
    var regionCd: String = ""
    
    var regionDic: [String:String]
    var countryDic: [String:String]
    
    var rating: Double = 0
    var reviewCount: Int = 0
    var likeCount: Int = 0
    
    var createTimeServer: Double
    var createTimeDate: Date
    
    var updatedTimeServer: Double
    var updatedTime: Date
    
    var reviews: Array<ReviewObject>? = nil
    
    
    //Detailed part
    
    var aromaObservation: [String:String]? = nil
    var flavorType:String? = nil
    var productImageStrings:Array<String>? = nil
    var longDescription: [String:String]? = nil
    var shortDescription: [String:String]? = nil
    var productSize: Int? = nil
    var sizeType:String? = nil
    var subRegionCd:String? = nil
    
    var tasteObservation: [String:String]? = nil
    var tempChilled: Int? = nil
    var tempHot: Int? = nil
    var tempRoom: Int? = nil
    var tempVHot: Int? = nil
    var tempWarm: Int? = nil
    
    var hasUserNote: Bool? = nil
    var userRating: Double? = nil
    var userReview: [String:String]? = nil
    var userHasFavored: Bool = false
    var totalRatings: Int? = nil
    var totalFavorites: Int? = nil
    
    var breweryName: [String:String]? = nil

    init()
    {
        acidity = ""
        alcPerc = ""
        isAvailableToPublic = false
        brewYear = 0
        category = ""
        createType = ""
        filterWater = ""
        id = ""
        isInProduction = false
        kakeRatio = ""
        kojiRatio = ""
        isLabelInDatabase = false
        mainImageURLString = ""
        sakeName = ""
        pastorizeTankStorage = ""
        pressAndSqueeze = ""
        riceKake = ""
        riceKoji = ""
        type = ""
        userID = ""
        yeast = ""
        smv = 0
        
        aminoAcid = ""
        
        countryCd = ""
        regionCd = ""
        
        sakeNameDic = [String:String]()
        regionDic = [String:String]()
        countryDic = [String:String]()
        
        likeCount = 0
        reviewCount = 0
        rating = 0
        
        createTimeServer = 0
        createTimeDate = Date()
        
        updatedTimeServer = 0
        updatedTime = Date()
        
        reviews = nil
    }
    
    
    init(json: [String:Any], userDic: [String:Any]? = nil)
    {
        
        acidity = String(describing: json["acidity"]as? Double ?? 0)
        alcPerc = String(describing: json["alcPerc"]as? Double ?? 0)
        aminoAcid = (json["aminoAcid"]as? String) ?? ""
        
        if let thisString = json["avlToPublic"]as? String
        {
            if thisString == "1"
            {
                isAvailableToPublic = true
            }
            else
            {
                isAvailableToPublic = false
            }
        }
        else
        {
            isAvailableToPublic = false
        }
        
        
        brewYear = (json["brewYear"]as? Int) ?? 0
        
        category = (json["category"]as? String) ?? ""
        createType = (json["createType"]as? String) ?? ""
        filterWater = (json["filterWater"]as? String) ?? ""
        id = (json["id"]as? String) ?? ""
        
        
        if let thisString = json["inProduction"]as? String
        {
            if thisString == "1"
            {
                isInProduction = true
            }
            else
            {
                isInProduction = false
            }
        }
        else
        {
            isInProduction = false
        }
        
        
        
        kakeRatio = String(describing: json["kakeRatio"]as? Double ?? 0)
        kojiRatio = String(describing: json["kojiRatio"]as? Double ?? 0)
        
        
        if let thisString = json["labelExist"]as? String
        {
            if thisString == "1"
            {
                isLabelInDatabase = true
            }
            else
            {
                isLabelInDatabase = false
            }
        }
        else
        {
            isLabelInDatabase = false
        }
        
        
        
        if let urlString = json["mainImgUrl"]as? String
        {
            mainImageURLString = APIConstants.ImagesEndPoint + urlString
        }
        else
        {
            if let urlStrings = json["imgs"]as? Array<String>, urlStrings.count > 0
            {
                if let mainImageIndex = json["mainImg"]as? Int, mainImageIndex < urlStrings.count
                {
                    mainImageURLString = APIConstants.ImagesEndPoint + urlStrings[mainImageIndex]
                }
                else
                {
                    mainImageURLString = APIConstants.ImagesEndPoint + urlStrings[0]
                }
            }
            else
            {
                mainImageURLString = ""
            }
        }
        
        
        if let nameDic = json["name"]as? [String:Any]
        {
            if let name = nameDic[UserObject.sharedInstance.language]as? String
            {
                sakeName = name
            }
            else
            {
                sakeName = ""
            }
        }
        else
        {
            sakeName = ""
        }
        
        
        
        pastorizeTankStorage = (json["pastorizeTankStorage"]as? String) ?? ""
        pressAndSqueeze = (json["pressAndSqueeze"]as? String) ?? ""
        riceKake = (json["riceKake"]as? String) ?? ""
        riceKoji = (json["riceKoji"]as? String) ?? ""
        type = (json["type"]as? String) ?? ""
        userID = (json["userId"]as? String) ?? ""
        yeast = (json["yeast"]as? String) ?? ""
        
        smv = json["smv"]as? Int ?? 0
        
        countryCd = (json["countryCd"]as? String) ?? ""
        regionCd = (json["regionCd"]as? String) ?? ""
        
        
        if let thisRegionDic = json["regionName"]as? [String:String]
        {
            regionDic = thisRegionDic
        }
        else
        {
            if let thisRegionDic = userDic?["regionName"]as? [String:String]
            {
                regionDic = thisRegionDic
            
            }
            else
            {
                regionDic = [String:String]()
            }
        }
        
        if let thisCountryDic = json["countryName"]as? [String:String]
        {
            countryDic = thisCountryDic
        }
        else
        {
            if let thisCountryDic = userDic?["countryName"]as? [String:String]
            {
                countryDic = thisCountryDic
                
            }
            else
            {
                countryDic = [String:String]()
            }
        }
        
        sakeNameDic = json["name"]as? [String:String] ?? [String:String]()
        
        
        likeCount = (json["favoured"]as? Int) ?? 0
        reviewCount = (json["reviewCount"]as? Int) ?? 0
        
        if let rate = json["rate"]as? Double
        {
            rating = rate
        }
        else
        {
            if let rate = userDic?["avgRate"]as? Double
            {
                rating = rate
            }
            else
            {
                rating = 0
            }
        }
        
        if let created = json["created"]as? Double
        {
            createTimeServer = created
            createTimeDate = Date(timeIntervalSince1970: TimeInterval(created / 1000))
        }
        else
        {
            createTimeServer = 0
            createTimeDate = Date()
        }
        
        
        if let updated = json["updated"]as? Double
        {
            updatedTimeServer = updated
            updatedTime = Date(timeIntervalSince1970: TimeInterval(updated / 1000))
        }
        else
        {
            updatedTimeServer = 0
            updatedTime = Date()
        }
        
        
        reviews = nil
        
        //details
        flavorType = json["flavorType"]as? String
        productImageStrings = json["imgs"]as? Array<String>
        aromaObservation = json["aromaObservation"]as? [String:String]
        longDescription = json["longDesc"]as? [String:String]
        shortDescription = json["shortDesc"]as? [String:String]
        productSize = json["size"]as? Int
        tasteObservation = json["tasteObservation"]as? [String:String]
        tempChilled = json["tempChilled"]as? Int
        tempHot = json["tempHot"]as? Int
        tempRoom = json["tempRoom"]as? Int
        tempVHot = json["tempVHot"]as? Int
        tempWarm = json["tempWarm"]as? Int
        
        if let userDetails = userDic
        {
            if let thisString = userDetails["userHasNote"]as? Int
            {
                if thisString < 0
                {
                    hasUserNote = true
                }
                else
                {
                    hasUserNote = false
                }
            }
            else
            {
                hasUserNote = false
            }
            
            if let thisString = userDetails["userFavourite"]as? Int
            {
                if thisString < 0
                {
                    userHasFavored = true
                }
                else
                {
                    userHasFavored = false
                }
            }
            else
            {
                userHasFavored = false
            }

            userRating = userDetails["userRate"]as? Double
            userReview = userDetails["userReview"]as? [String:String]
            totalRatings = userDetails["totalRates"]as? Int
            totalFavorites = userDetails["totalFavourites"]as? Int
            breweryName = userDetails["breweryName"]as? [String:String]

        }
        
    }
    
    
    class func currentNameForDic(productDic: [String:String]) -> String?
    {
        if let thisName = productDic[UserObject.sharedInstance.language]
        {
            return thisName
        }
        else
        {
            return productDic["en"]
        }
    }
    
    class func presentStringForType(serverString: String) -> String
    {
        switch serverString {
        case "JUNMAIDAIGINJOSHU":
            return "Junmai Daiginjoshu".localized()
        case "JUNMAIGINJOSHU":
            return "Junmai Ginjoshu".localized()
        case "TOKUBETSUJUNMAISHU":
            return "Tokubetsu Junmaishu".localized()
        case "JUNMAISHU":
            return "Junmaishu".localized()
        case "DAIJINJOSHU":
            return "Daijinjoshu".localized()
        case "GINJOSHU":
            return "Ginjoshu".localized()
        case "TOKEBETSUHONJOZOSHU":
            return "Tokubetsu Honjozoshu".localized()
        case "HONJOZOSHU":
            return "Honjozoshu".localized()
        case "SPARKING":
            return "Sparkling".localized()
        case "AMAZAKE":
            return "Amazake".localized()
        case "MIXEDLIQUOR":
            return "Mixed Liquor".localized()
        default:
            return ""
        }
    
    }
    
    class func presentStringForPressAndSqueeze(serverString: String) -> String
    {
        switch serverString {
        case "ARABASHIRI":
            return "Arabashiri".localized()
        case "NAKADORI_NAKAGUMO_NAKADARE":
            return "Nakadori Nakagumo Nakadare".localized()
        case "SEME_OSHIKIRI":
            return "Seme Oshikiri".localized()
        case "FUKUROTURI_FUKUROSHIBORI_TSURUSHIZAKE":
            return "Fukuroturi Fukuroshibori Tsurushizake".localized()
        case "TOBINDORI_TOBINKAKOI":
            return "Tobindori Tobinkakoi".localized()
        case "ORIGARAMI":
            return "Origarami".localized()
        case "NIGORIZAKE":
            return "Nigorizake".localized()
        default:
            return ""
        }
        
    }
    
    class func presentStringForRiceKojiKake(serverString: String) -> String
    {
        switch serverString {
        case "YAMADANISHIKI":
            return "Yamadanishiki".localized()
        case "GOHYAKUMANGOKU":
            return "Gohyakumangoku".localized()
        case "MIYAMANISHIKI":
            return "Miyamanishiki".localized()
        case "OMACHI":
            return "Omachi".localized()
        case "HYOGOYUMENISHIKI":
            return "Hyogoyumenishiki".localized()
        case "HATTANNISHIKI_NO1":
            return "Hattannishiki No.1".localized()
        case "DEWASANSAN":
            return "Dewasansan".localized()
        case "HANAFUBUKI":
            return "Hanafubuki".localized()
        case "GINPU":
            return "Ginpu".localized()
        case "TAMASAKAE":
            return "Tamasakae".localized()
        default:
            return ""
        }
        
    }
    
    class func presentStringForFilterAndWater(serverString: String) -> String
    {
        switch serverString {
        case "MUROKAGENSHU":
            return "Muroka Genshu".localized()
        case "MUROKA":
            return "Muroka".localized()
        case "GENSHUMUKASHI":
            return "Genshu - Mukasui".localized()
        case "NONE":
            return "None".localized()
        default:
            return ""
        }
        
    }
    
    class func presentStringForPasturizationAndTankStorage(serverString: String) -> String
    {
        switch serverString {
        case "NAMAZAKE":
            return "Namazake".localized()
        case "NAMAZUMESHU":
            return "Namachozoshu".localized()
        case "NAMAZUMESHU_HIYAOROSHI":
            return "Namazumeshu (Hiyaoroshi)".localized()
        case "NAMACHOZOSHU":
            return "Namachozoshu".localized()
        case "TSUJO":
            return "Tsujo".localized()
        case "CHOKICHOZO_JUKUSEI":
            return "Chokichozo - Jukusei".localized()
        case "TARUSHU":
            return "Tarushu".localized()
        default:
            return ""
        }
        
    }

}
