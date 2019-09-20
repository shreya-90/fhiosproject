//
//  TaxStatusObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 25/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class TaxStatusObj: NSObject {
    
    var taxStatus_name : String?
    var taxStatus_id : String?
    
    
    static func getTaxStatus(taxStatus_id: String,taxStatus_name: String) -> TaxStatusObj{
        let taxStatusDetailModel = TaxStatusObj()
        taxStatusDetailModel.taxStatus_id = taxStatus_id
        taxStatusDetailModel.taxStatus_name = taxStatus_name
        return taxStatusDetailModel
    }
    
    
    
}
