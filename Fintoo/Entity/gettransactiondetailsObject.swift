//
//  FetchTransactionIdData.swift
//  Fintoo
//
//  Created by iosdevelopermme on 29/08/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class gettransactiondetailsObject{
    
    var S_NAME: String
    var cart_id: String
    var cart_amount: String
    var cart_tenure: String
    var cart_tenure_perpetual: String
    var transaction_id: String
    var transaction_date: String
    var bank_name: String
    var bank_acc_no: String
    var cart_purchase_type: String
    var bse_reg_order_id : String
    var cart_payout_opt : String
    init(S_NAME: String,cart_purchase_type: String, transaction_id: String,  transaction_date: String,  cart_id: String,  cart_amount: String, cart_tenure: String,  cart_tenure_perpetual: String, bank_name: String, bank_acc_no: String,bse_reg_order_id:String,cart_payout_opt:String) {
        
        self.cart_purchase_type = cart_purchase_type
        self.S_NAME = S_NAME
        
        self.transaction_id = transaction_id
        self.transaction_date = transaction_date
        self.cart_id = cart_id
        self.cart_amount = cart_amount
       
        self.cart_tenure = cart_tenure
        self.cart_tenure_perpetual = cart_tenure_perpetual
        
        self.bank_name = bank_name
        self.bank_acc_no = bank_acc_no
        self.bse_reg_order_id = bse_reg_order_id
        self.cart_payout_opt = cart_payout_opt
        
    }
}
