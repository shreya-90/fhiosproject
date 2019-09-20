//
//  SiFundObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 24/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation

class SiFundObj {
    var transaction_id: String
    var transaction_cart_id: String
    var cart_amount: String
    var AMFI_NAME: String
    var cart_scheme_code: String
    
    
    init(transaction_id: String, transaction_cart_id: String, cart_amount: String, AMFI_NAME: String, cart_scheme_code: String) {
        
        
        self.transaction_id = transaction_id
        self.transaction_cart_id = transaction_cart_id
        self.cart_amount = cart_amount
        self.AMFI_NAME = AMFI_NAME
        self.cart_scheme_code = cart_scheme_code
        
    }
}
