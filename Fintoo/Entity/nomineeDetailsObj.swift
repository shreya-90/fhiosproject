//
//  nomineeDetailsObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 10/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
//getNomineeDetails
class nomineeDetailsObj: NSObject {
    
    
    var nominee_id : String?
    
    var nominee_member_id : String?
    var nominee_first_name : String?
    var nominee_middle_name : String?
    var nominee_last_name : String?
    var nominee_dob : String?
    var nominee_gender : String?
    var nominee_email : String?
    var nominee_mobile : String?
    var nominee_relation : String?
    var nominee_guardian_pan :  String?
    var txn_exst : String?
    var is_exapanded: Bool = true;
    var is_expandedInt : Int = 0
    var fullName = ""
    var isTermsAccepted = false
    var default_nominee : String?
    //Flag to maintain which view is expanded
    
    static func getNomineeDetails(nominee_id: String,nominee_member_id: String,nominee_first_name: String,nominee_middle_name: String,nominee_last_name: String,nominee_dob: String,nominee_gender: String,nominee_email: String,nominee_mobile: String,nominee_relation: String,nominee_guardian_pan: String,txn_exst: String, full_name: String,default_nominee:String) -> nomineeDetailsObj{
        let nomineeDetailModel = nomineeDetailsObj()
        nomineeDetailModel.nominee_id = nominee_id
        nomineeDetailModel.nominee_member_id = nominee_member_id
        nomineeDetailModel.nominee_first_name = nominee_first_name
        nomineeDetailModel.nominee_middle_name = nominee_middle_name
        nomineeDetailModel.nominee_last_name = nominee_last_name
        nomineeDetailModel.nominee_dob = nominee_dob
        nomineeDetailModel.nominee_gender = nominee_gender
        nomineeDetailModel.nominee_email = nominee_email
        nomineeDetailModel.nominee_mobile = nominee_mobile
        nomineeDetailModel.nominee_relation = nominee_relation
        nomineeDetailModel.nominee_guardian_pan = nominee_guardian_pan
        nomineeDetailModel.txn_exst = txn_exst
        nomineeDetailModel.fullName = full_name
        nomineeDetailModel.default_nominee = default_nominee
        
        return nomineeDetailModel
    }
    
    
    
}
