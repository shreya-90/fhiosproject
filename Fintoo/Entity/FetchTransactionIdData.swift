//
//  FetchTransactionIdData.swift
//  Fintoo
//
//  Created by iosdevelopermme on 29/08/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class FetchTransactionIdData {
    
    var SCHEMECODE: String
    var MAIN_AMC_CODE: String
    var REPURPRICE: String
    var user_investor_id: String
    var transaction_user_id: String
    var AMC_CODE: String
    var cart_scheme_code: String
    var S_NAME: String
    var CAMS_CODE: String
    var amfitype: String
    var cart_purchase_type: String
    var rav_amc_value: String
    var rav_code_type: String
    var asbm_bank_name: String
    var asbm_bank_account: String
    var transaction_id: String
    var transaction_date: String
    var cart_id: String
    var cart_amount: String
    var cart_units: String
    var cart_frequency: String
    var cart_tenure: String
    var cart_tenure_perpetual: String
    var cart_sip_start_date: String
    var cart_sip_end_date: String
    var cart_added: String
    var transaction_folio_no:String
    var transaction_urn: String
    var transaction_bank_id: String
    var transaction_SI_for_SO: String
    var RT_CODE: String
    var bank_name: String
    var bank_acc_no: String
    var trxn_type: String
    
    init(SCHEMECODE: String, MAIN_AMC_CODE: String, REPURPRICE: String, user_investor_id: String, transaction_user_id: String, AMC_CODE: String, cart_scheme_code: String,  S_NAME: String,  CAMS_CODE: String,  amfitype: String,  cart_purchase_type: String,  rav_amc_value: String,  rav_code_type: String,  asbm_bank_name: String,  asbm_bank_account: String,  transaction_id: String,  transaction_date: String,  cart_id: String,  cart_amount: String,  cart_units: String,  cart_frequency: String,  cart_tenure: String,  cart_tenure_perpetual: String,  cart_sip_start_date: String,  cart_sip_end_date: String,  cart_added: String,  transaction_folio_no:String,  transaction_urn: String,  transaction_bank_id: String,  transaction_SI_for_SO: String,  RT_CODE: String,  bank_name: String,  bank_acc_no: String, trxn_type: String) {
        
        self.SCHEMECODE = SCHEMECODE
        self.MAIN_AMC_CODE = MAIN_AMC_CODE
        self.REPURPRICE = REPURPRICE
        self.user_investor_id = user_investor_id
        self.transaction_user_id = transaction_user_id
        self.AMC_CODE = AMC_CODE
        self.cart_scheme_code = cart_scheme_code
        self.S_NAME = S_NAME
        self.CAMS_CODE = CAMS_CODE
        self.amfitype = amfitype
        self.cart_purchase_type =  cart_purchase_type
        self.rav_amc_value = rav_amc_value
        self.rav_code_type = rav_code_type
        self.asbm_bank_name = asbm_bank_name
        self.asbm_bank_account = asbm_bank_account
        self.transaction_id = transaction_id
        self.transaction_date = transaction_date
        self.cart_id = cart_id
        self.cart_amount = cart_amount
        self.cart_units = cart_units
        self.cart_frequency = cart_frequency
        self.cart_tenure = cart_tenure
        self.cart_tenure_perpetual = cart_tenure_perpetual
        self.cart_sip_start_date = cart_sip_start_date
        self.cart_sip_end_date = cart_sip_end_date
        self.cart_added = cart_added
        self.transaction_folio_no = transaction_folio_no
        self.transaction_urn = transaction_urn
        self.transaction_bank_id = transaction_bank_id
        self.transaction_SI_for_SO = transaction_SI_for_SO
        self.RT_CODE = RT_CODE
        self.bank_name = bank_name
        self.bank_acc_no = bank_acc_no
        self.trxn_type = trxn_type
    }
}
