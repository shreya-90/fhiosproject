//
//  uploadMandate.swift
//  Fintoo
//
//  Created by iosdevelopermme on 15/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class uploadMandate: NSObject {
    
    var mandate_id : String?
    var mandate_name : String?
    
    
    static func getMandate(mandate_id: String,mandate_name: String) -> uploadMandate{
        let mandateModel = uploadMandate()
        mandateModel.mandate_id = mandate_id
        mandateModel.mandate_name = mandate_name
        return mandateModel
    }
    
    
    
}
