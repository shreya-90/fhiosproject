//
//  UserDataObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 16/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation

class UserDataObj: NSObject {
    
    var salutation : String?
    var fname : String?
    var mname : String?
    var lname : String?
    var gender : String?
    var dob : String?
    var mobile : String?
    var landline : String?
    var email : String?
    var aadhar : String?
    var pan : String?
    var flat_no : String?
    var building_name : String?
    var road_street: String?
    var address : String?
    var Country : String?
    var State : String?
    var City : String?
    var pincode : String?
    var occupation : String?
    var location :  String?
    var marital_status :  String?
    var spouse_name : String?
    var residential_status : String?
    var user_tax_status : String?
    var tax_slab : String?
    var IncomeSlabID : String?
    static func getUserData(salutation : String?,fname : String?,mname : String?,lname : String?,gender : String?,dob : String?,mobile : String?,landline : String?,email : String?,aadhar : String?,pan : String?,flat_no : String?,building_name : String?,road_street: String?,address : String?,Country : String?,State : String?,City : String?,pincode : String?,occupation : String?,location :  String?,marital_status :  String?,spouse_name : String?,residential_status : String?,user_tax_status : String?,tax_slab : String?,IncomeSlabID:String) -> UserDataObj{
        let UserDataDetailModel = UserDataObj()
        UserDataDetailModel.salutation = salutation
        UserDataDetailModel.fname = fname
        UserDataDetailModel.mname = mname
        UserDataDetailModel.lname = lname
        UserDataDetailModel.gender =  gender
        UserDataDetailModel.dob =  dob
        UserDataDetailModel.mobile = mobile
        UserDataDetailModel.landline = landline
        UserDataDetailModel.email = email
        UserDataDetailModel.aadhar = aadhar
        UserDataDetailModel.pan = pan
        UserDataDetailModel.flat_no = flat_no
        UserDataDetailModel.building_name = building_name
        UserDataDetailModel.road_street = road_street
        UserDataDetailModel.address = address
        UserDataDetailModel.Country = Country
        UserDataDetailModel.State = State
        UserDataDetailModel.City = City
        UserDataDetailModel.pincode = pincode
        UserDataDetailModel.occupation = occupation
        UserDataDetailModel.location = location
        UserDataDetailModel.marital_status = marital_status
        UserDataDetailModel.spouse_name = spouse_name
        UserDataDetailModel.residential_status = residential_status
        UserDataDetailModel.user_tax_status = user_tax_status
        UserDataDetailModel.tax_slab = tax_slab
        UserDataDetailModel.IncomeSlabID = IncomeSlabID
        return UserDataDetailModel
    }
    
    
}
