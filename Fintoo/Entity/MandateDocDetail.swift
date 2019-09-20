//
//  MandateDocDetail.swift
//  Fintoo
//
//  Created by Shreya Pallan on 06/09/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import Foundation
import UIKit

class MandateDocDetail: NSObject {
    var doc_id : String
    var doc_name: String
    var doc_type : String
    var doc_address_proof_type : String
    var doc_other_address_type : String
    var doc_address_proof_expdate : String
    var doc_user_id : String
    var doc_sub_req : String
    var doc_sub_req_date : String
    var doc_sub_req_time : String
    var dt_identifier  : String
    
    init(doc_id:String,doc_name:String,doc_type:String,doc_address_proof_type:String,doc_other_address_type:String,doc_address_proof_expdate:String,doc_user_id:String,doc_sub_req:String,
         doc_sub_req_date:String,doc_sub_req_time:String,dt_identifier:String){
            self.doc_id = doc_id
            self.doc_name = doc_name
            self.doc_type = doc_type
            self.doc_address_proof_type = doc_address_proof_type
            self.doc_other_address_type = doc_other_address_type
            self.doc_address_proof_expdate = doc_address_proof_expdate
            self.doc_user_id = doc_user_id
            self.doc_sub_req = doc_sub_req
            self.doc_sub_req_date = doc_sub_req_date
            self.doc_sub_req_time = doc_sub_req_time
            self.dt_identifier = dt_identifier
    }
}
