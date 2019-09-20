//
//  DocObject.swift
//  Fintoo
//
//  Created by Dharmesh on 21/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation

class DocObject {
    var doc_sub_req_time: String
    var doc_user_id: String
    var doc_id: String
    var doc_address_proof_type: String
    var doc_name: String
    var doc_address_proof_expdate: String
    var doc_sub_req_date: String
    var dt_identifier: String
    var doc_other_address_type: String
    var doc_sub_req: String
    var doc_type: String
    
    init(doc_sub_req_time: String, doc_user_id: String, doc_id: String, doc_address_proof_type: String, doc_name: String, doc_address_proof_expdate: String, doc_sub_req_date: String, dt_identifier: String, doc_other_address_type: String, doc_sub_req: String, doc_type: String) {
        
        
        self.doc_sub_req_time = doc_sub_req_time
        self.doc_user_id = doc_user_id
        self.doc_id = doc_id
        self.doc_address_proof_type = doc_address_proof_type
        self.doc_name = doc_name
        self.doc_address_proof_expdate = doc_address_proof_expdate
        self.doc_sub_req_date = doc_sub_req_date
        self.dt_identifier = dt_identifier
        self.doc_other_address_type = doc_other_address_type
        self.doc_sub_req = doc_sub_req
        self.doc_type = doc_type
    }
}
