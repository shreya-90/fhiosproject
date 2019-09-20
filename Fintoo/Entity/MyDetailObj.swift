//
//  MyDetailObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 17/04/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class MyDetailObj: NSObject {
    
    var salutation: String?
    var fname: String?
    var mname: String?
    var lname: String?
    var gender: String?
    var dob : String?
    var mobile: String?
    var landline: String?
    var email: String?
    var aadhar : String?
    var pan: String?
    
    
    static func getuserdata(salutation: String,fname: String,mname: String,lname: String,gender: String,dob : String,mobile: String,landline: String,email: String,aadhar : String,pan: String) -> MyDetailObj{
        let myDetailModel = MyDetailObj ()
        myDetailModel.salutation = salutation
        myDetailModel.fname = fname
        return myDetailModel
    }
    
    
    
}
