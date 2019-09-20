//
//  LocationObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 25/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class LocationObj: NSObject {
    
    var location_name : String?
    var location_id : String?
    
    
    static func getLocation(location_id: String,location_name: String) -> LocationObj{
        let locationDetailModel = LocationObj()
        locationDetailModel.location_id = location_id
        locationDetailModel.location_name = location_name
        return locationDetailModel
    }
    
    
    
}
