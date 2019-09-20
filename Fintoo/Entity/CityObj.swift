//
//  CityObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 15/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class CityObj: NSObject {
    
    var City_name : String?
    var City_id : String?
    
    
    static func getCity(City_name: String,City_id: String) -> CityObj{
        let CityDetailModel = CityObj()
        CityDetailModel.City_name = City_name
        CityDetailModel.City_id = City_id
        return CityDetailModel
    }
    
    
    
}
