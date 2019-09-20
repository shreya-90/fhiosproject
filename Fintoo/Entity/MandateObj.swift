//
//  MandateObj.swift
//  Fintoo
//
//  Created by Shreya Pallan on 11/09/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

//
//  MandateDocDetail.swift
//  Fintoo
//
//  Created by Shreya Pallan on 06/09/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import Foundation
import UIKit

class MandateObj: NSObject {
    var transaction_bse_mandate_id : String?
    var transaction_bank_id: String?
    var bank_name : String?
    var transaction_user_id : String?
    var m_name,mandates,m_dates : [String:String]?
    
    var latest_mandate_id : String = ""
    var latest_mandate_name : String = ""
   
    
    init(transaction_bse_mandate_id:String,transaction_bank_id:String,bank_name:String,transaction_user_id:String,m_name:[String:String],mandates:[String:String],m_dates:[String:String]){
        self.transaction_bse_mandate_id = transaction_bse_mandate_id
        self.transaction_bank_id = transaction_bank_id
        self.bank_name = bank_name
        self.transaction_user_id = transaction_user_id
        self.mandates = mandates
        self.m_dates = m_dates
        self.m_name = m_name
        
    }
}
