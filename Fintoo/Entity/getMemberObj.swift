//
//  getMemberObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 04/10/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class getMemberObj: NSObject {
    
    var id : String?
    var name : String?
    var pan : String?
    var dob : String?
    var member_display_flag : String!
    init(id: String,name: String,pan: String,dob: String,member_display_flag:String){
        self.id = id
        self.name = name
        self.pan = pan
        self.dob = dob
        self.member_display_flag = member_display_flag
    }
    
}
