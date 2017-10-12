//
//  LocationObject.swift
//  SakeWiz
//
//  Created by welly, TW on 1/12/17.
//  Copyright © 2017 TW welly. All rights reserved.
//


//PUT THEM AS WATCHERS ON THE TICKET --- SALLY and HIRO

import Foundation
import CoreLocation


class LocationObject {

    var name: String
    var coordinate: CLLocationCoordinate2D
    var location: CLLocation
    var locationDescription: String
    var stars: String
    var locationType: String
    
    var cityLocation: String
    
    var distance: CLLocationDistance?
    
    init(){
        self.name = ""
        self.location = CLLocation(latitude: 35.611582, longitude: 139.626778)
        self.coordinate = location.coordinate
        self.locationDescription = ""
        self.stars = ""
        self.distance = nil
        self.locationType = ""
        self.cityLocation = ""
        
    }
    
    init(locationName: String, cityLocation: String, location: CLLocation, locationDescription: String, stars: String, locationType: String)
    {
        self.name = locationName
        self.cityLocation = cityLocation
        self.location = location
        self.coordinate = location.coordinate
        self.locationDescription = locationDescription
        self.stars = stars
        self.distance = location.distance(from: CLLocation(latitude: 35.611582, longitude: 139.626778))
        self.locationType = locationType
    }

}
