//
//  upcomingTransactionObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 03/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class upcomingTransactionObj: NSObject {
    
    var S_NAME : String?
    var transaction_date : String?
    var tdate : String?
    var cart_amount : String?
    
    
    
    static func getUpcomingTransactionDetail(scheme_name: String,transaction_date: String,tdate:String,cart_amount:String) -> upcomingTransactionObj{
        let UpcomingTransactionDetailModel = upcomingTransactionObj()
        UpcomingTransactionDetailModel.S_NAME = scheme_name
        UpcomingTransactionDetailModel.transaction_date = transaction_date
        UpcomingTransactionDetailModel.tdate = tdate
        UpcomingTransactionDetailModel.cart_amount = cart_amount
        return UpcomingTransactionDetailModel
    }
    
    
    
}
