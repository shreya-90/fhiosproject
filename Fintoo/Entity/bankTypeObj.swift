//
//  bankTypeObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 04/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class bankTypeObj: NSObject {
    
    var bank_mst_name : String?
    var bank_mst_id : String?
    
    
    static func getBankType(bank_mst_name: String,bank_mst_id: String) -> bankTypeObj{
        let bankDetailModel = bankTypeObj()
        bankDetailModel.bank_mst_id = bank_mst_id
        bankDetailModel.bank_mst_name = bank_mst_name
        return bankDetailModel
    }
    
    
    
}
