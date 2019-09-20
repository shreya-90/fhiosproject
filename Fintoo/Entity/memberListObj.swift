//
//  memberListObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 10/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class memberListObj: NSObject {
    
    var name : String?
    var m_id : String?
    var mname : String?
    var pan : String?
    var lname : String?
    var dob : String?
    var relation : String?
    var fullName = ""
    static func getMemberList(name: String,m_id: String,mname: String,pan: String,lname: String,full_name:String,dob:String) -> memberListObj{
        let memberListModel = memberListObj()
        memberListModel.name = name
        memberListModel.m_id = m_id
        memberListModel.lname = lname
        memberListModel.mname = mname
        memberListModel.pan = pan
        memberListModel.fullName = full_name
        memberListModel.dob = dob
//        memberListModel.relation = relation
//        memberListModel.dob = dob
        return memberListModel
    }
    
    
    
}
