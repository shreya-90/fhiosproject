//
//  SingleBankDetailObject.swift
//  Fintoo
//
//  Created by iosdevelopermme on 30/08/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class SingleBankDetailObject {
    
    var  bank_id :  String
    var  user_name :  String
    var  mobile :  String
    var  user_email :  String
    var  pan : String
    var  bank_name :  String
    var  bank_type :  String
    var  bank_mst_name :  String
    var  bank_acc_no :  String
    var  bank_ifsc_code : String
    var  micr_code :  String
    var  bank_branch :  String
    var  bank_joint_holder : String
    var  single_survivor :  String
    var  bank_city :  String
    var  bank_state : String
    var  bank_country :  String
    var  bank_mandate : String
    var  bank_txn_limit :  String
    var  bank_cancel_cheque : String
    var  bank_current_txn_limit : String
    var  bank_mandate_document : String
    init(bank_id :String,user_name :String,mobile :String,user_email :String,pan :String,bank_name :String,bank_type :String,bank_mst_name :String,bank_acc_no :String,bank_ifsc_code : String,micr_code :String,bank_branch :String,bank_joint_holder : String,single_survivor :String,bank_city :String,bank_state : String,bank_country :String,bank_mandate : String,bank_txn_limit :String,bank_cancel_cheque : String,bank_current_txn_limit : String,bank_mandate_document : String){
            self.bank_id = bank_id
            self.user_name = user_name
            self.mobile = mobile
            self.user_email = user_email
            self.pan = pan
            self.bank_name = bank_name
            self.bank_type = bank_type
            self.bank_mst_name = bank_mst_name
            self.bank_acc_no = bank_acc_no
            self.bank_ifsc_code = bank_ifsc_code
            self.micr_code = micr_code
            self.bank_branch = bank_branch
            self.bank_joint_holder = bank_joint_holder
            self.single_survivor = single_survivor
            self.bank_city = bank_city
            self.bank_state = bank_state
            self.bank_country = bank_country
            self.bank_mandate = bank_mandate
            self.bank_txn_limit = bank_txn_limit
            self.bank_cancel_cheque = bank_cancel_cheque
            self.bank_current_txn_limit = bank_current_txn_limit
            self.bank_mandate_document = bank_mandate_document
        
    }
    
    
}
