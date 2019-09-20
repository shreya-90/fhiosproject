//
//  UserNriObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 28/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class UserNriObj: NSObject {
    
    var user_nri_id : String?
    var user_nri_flat_no : String?
    var user_nri_building_name : String?
    var user_nri_road_street : String?
    var user_nri_address : String?
    var user_nri_city : String?
    var user_nri_state : String?
    var user_nri_country : String?
    var user_nri_pincode : String?
    
    static func addNriDetail(user_nri_id: String,user_nri_flat_no: String,user_nri_building_name: String,user_nri_road_street: String,user_nri_address: String,user_nri_city: String,user_nri_state: String,user_nri_country: String,user_nri_pincode: String) -> UserNriObj{
        let NriDetailModel = UserNriObj()
        NriDetailModel.user_nri_id = user_nri_id
        NriDetailModel.user_nri_flat_no = user_nri_flat_no
        NriDetailModel.user_nri_building_name = user_nri_building_name
        NriDetailModel.user_nri_address = user_nri_address
        NriDetailModel.user_nri_road_street = user_nri_road_street
        NriDetailModel.user_nri_city = user_nri_city
        NriDetailModel.user_nri_state = user_nri_state
        NriDetailModel.user_nri_country = user_nri_country
        NriDetailModel.user_nri_pincode = user_nri_pincode
        return NriDetailModel
    }
    
   
    
}
