//
//  getBankObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 04/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class getBankObj: NSObject {
    
    //var bank_mst_name : String?
    //var bank_mst_id : String?
    var bank_acc_no : String?
    var bank_branch : String?
    var bank_cancel_cheque : String?
    var bank_city : String?
    var bank_country : String?
    var bank_current_txn_limit : String?
    var bank_id : String?
    var bank_ifsc_code  : String?
    var bank_joint_holder : String?
    var bank_mandate :  String?
    var bank_mandate_document:  String?
    var bank_name :  String?
    var bank_state :  String?
    var bank_txn_limit:  String?
    var bank_type:  String?
    var banks_bd_code:  String?
    var micr_code:  String?
    var single_survivor:  String?
    var txn_exst:  String?
    var country_name : String?
    var state_name : String?
    var city_name : String?
    var bank_razorpay_code : String?
    var bank_razorpay_code_user : String?
    var is_expanded : String?
    var max_acc_number : String?
    var min_acc_number : String?
    var bank_mandate_type : String?
    var isip_allow : String?
    var max_trxn_limit : String?
    static func getUserBank(bank_acc_no : String?,bank_branch : String?,bank_cancel_cheque : String?,bank_city : String?,bank_country : String?,bank_current_txn_limit : String?,bank_id : String?,bank_ifsc_code  : String?,bank_joint_holder : String?,bank_mandate :  String?,bank_mandate_document:  String?,bank_name :  String?,bank_state :  String?,bank_txn_limit:  String?,bank_type:  String?,banks_bd_code:  String?,micr_code:  String?,single_survivor:  String?,txn_exst:  String?,country_name: String?,state_name:String?,city_name:String?,bank_razorpay_code:String,bank_razorpay_code_user:String,min_acc_number:String,max_acc_number:String,isip_allow:String,bank_mandate_type:String,max_trxn_limit:String) -> getBankObj{
        let bankDetailModel = getBankObj()
         bankDetailModel.bank_acc_no = bank_acc_no
         bankDetailModel.bank_branch = bank_branch
            bankDetailModel.bank_cancel_cheque = bank_cancel_cheque
            bankDetailModel.bank_city = bank_city
            bankDetailModel.bank_country = bank_country
            bankDetailModel.bank_current_txn_limit = bank_current_txn_limit
            bankDetailModel.bank_id = bank_id
            bankDetailModel.bank_ifsc_code = bank_ifsc_code
            bankDetailModel.bank_joint_holder = bank_joint_holder
            bankDetailModel.bank_mandate = bank_mandate
            bankDetailModel.bank_mandate_document = bank_mandate_document
            bankDetailModel.bank_name = bank_name
            bankDetailModel.bank_state = bank_state
            bankDetailModel.bank_txn_limit = bank_txn_limit
            bankDetailModel.bank_type = bank_type
            bankDetailModel.banks_bd_code = banks_bd_code
            bankDetailModel.micr_code = micr_code
            bankDetailModel.single_survivor = single_survivor
            bankDetailModel.txn_exst = txn_exst
            bankDetailModel.country_name = country_name
            bankDetailModel.state_name = state_name
            bankDetailModel.city_name = city_name
            bankDetailModel.bank_razorpay_code = bank_razorpay_code
            bankDetailModel.bank_razorpay_code_user = bank_razorpay_code_user
            bankDetailModel.min_acc_number = min_acc_number
            bankDetailModel.max_acc_number = max_acc_number
            bankDetailModel.isip_allow = isip_allow
            bankDetailModel.bank_mandate_type = bank_mandate_type
            bankDetailModel.max_trxn_limit = max_trxn_limit
        return bankDetailModel
    }
    
    
    
}
