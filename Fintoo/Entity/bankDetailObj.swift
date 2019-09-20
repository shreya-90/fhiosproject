//
//  bankDetailObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 04/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class bankDetailObj: NSObject {
    
    var banks_name_value : String?
    var banks_id : String?
    var banks_bd_code : String?
    var bank_razorpay_code : String?
    var max_acc_number : String?
    var min_acc_number : String?
    static func getBankDetail(banks_name_value: String,banks_id: String,banks_bd_code:String,bank_razorpay_code:String,min_acc_number:String,max_acc_number:String) -> bankDetailObj{
        let bankDetailModel = bankDetailObj()
        bankDetailModel.banks_id = banks_id
        bankDetailModel.banks_name_value = banks_name_value
        bankDetailModel.banks_bd_code = banks_bd_code
        bankDetailModel.bank_razorpay_code = bank_razorpay_code
        bankDetailModel.max_acc_number = max_acc_number
        bankDetailModel.min_acc_number = min_acc_number
        return bankDetailModel
    }
    
    
    
}
