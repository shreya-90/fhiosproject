//
//  getSelectAddressObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 12/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class getSelectAddressObj: NSObject {
    
    var dt_id : String?
    var dt_name : String?
    
    
    static func getAddressType(dt_id: String,dt_name: String) -> getSelectAddressObj{
        let addressTypeDetailModel = getSelectAddressObj()
        addressTypeDetailModel.dt_id = dt_id
        addressTypeDetailModel.dt_name = dt_name
        return addressTypeDetailModel
    }
    
    
    
}
