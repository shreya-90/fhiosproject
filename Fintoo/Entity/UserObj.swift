//
//  UserObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 16/08/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class UserObj {
    var id: String
    var pan: String
    var dob: String
    var mobile: String
    var landline: String
    var name: String
    var middle_name: String
    var last_name: String
    var flat_no: String
    var building_name: String
    var road_street: String
    var address : String
    var city : String
    var state : String
    var country : String
    var pincode : String
    var email : String
    init(id: String, pan: String, dob: String, mobile: String, landline: String, name: String, middle_name: String, last_name: String, flat_no: String, building_name: String, road_street: String,address : String,city : String,state : String,country : String,pincode : String,email:String) {
        
        
        self.id = id
        self.pan = pan
        self.dob = dob
        self.mobile = mobile
        self.landline = landline
        self.name = name
        self.middle_name = middle_name
        self.last_name = last_name
        self.flat_no = flat_no
        self.building_name = building_name
        self.road_street = road_street
        self.address = address
        self.city = city
        self.state = state
        self.country = country
        self.pincode = pincode
        self.email = email
    }
}
