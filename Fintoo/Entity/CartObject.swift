//
//  CartObject.swift
//  Fintoo
//
//  Created by Dharmesh on 11/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation

class CartObject {
    
    var MAXINVT: String
    var MININVT: String
    var SCHEMECODE: String
    var SIPMININVT: String
    var S_NAME: String
    var cart_added: String
    var cart_amount: String
    var cart_folio_no: String
    var cart_frequency: String
    var cart_id: String
    var cart_mst_id: String
    var cart_mst_session_id: String
    var cart_purchase_type: String
    var cart_scheme_code: String
    var cart_sip_start_date: String
    var cart_tenure: String
    var cart_tenure_perpetual: String
    var multiples: String
    var transaction_bank_id: String
    var transaction_id: String
    var mode: String
    var cart_sip_start_date1: String
    var isModify = false
    var isTicked = false
    var AMC_CODE : String
    var is_save =  false
    var nominee: nomineeDetailsObj?
    var isSelected = false
    var CLASSCODE : String
    init(MAXINVT: String, MININVT: String, SCHEMECODE: String, SIPMININVT: String, S_NAME: String, cart_added: String, cart_amount: String, cart_folio_no: String, cart_frequency: String, cart_id: String, cart_mst_id: String, cart_mst_session_id: String, cart_purchase_type: String, cart_scheme_code: String, cart_sip_start_date: String, cart_tenure: String, cart_tenure_perpetual: String, multiples: String, transaction_bank_id: String, transaction_id: String,cart_sip_start_date1: String,mode:String,is_save:Bool,AMC_CODE:String,CLASSCODE:String,nominee: nomineeDetailsObj?) {
        
        self.CLASSCODE = CLASSCODE
        self.MAXINVT = MAXINVT
        self.MININVT = MININVT
        self.SCHEMECODE = SCHEMECODE
        self.SIPMININVT = SIPMININVT
        self.S_NAME = S_NAME
        self.cart_added = cart_added
        self.cart_amount = cart_amount
        self.cart_folio_no = cart_folio_no
        self.cart_frequency = cart_frequency
        self.cart_id = cart_id
        self.cart_mst_id = cart_mst_id
        self.cart_mst_session_id = cart_mst_session_id
        self.cart_purchase_type = cart_purchase_type
        self.cart_scheme_code = cart_scheme_code
        self.cart_sip_start_date = cart_sip_start_date
        self.cart_tenure = cart_tenure
        self.cart_tenure_perpetual = cart_tenure_perpetual
        self.multiples = multiples
        self.transaction_bank_id = transaction_bank_id
        self.transaction_id = transaction_id
        self.cart_sip_start_date1 = cart_sip_start_date1
        self.nominee = nominee
        self.mode = mode
        self.is_save = is_save
        self.AMC_CODE = AMC_CODE
    }
}
