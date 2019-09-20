//
//  SIP_date_calculation.swift
//  Fintoo
//
//  Created by iosdevelopermme on 22/03/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation

class SIP_date_calculation: NSObject {

    var start_date: String?
    var end_date: String?
    var totalins : String?
    var remainingins : String?
    var sip_reg_no : String?
    
    


    static func getSIP_date_calculation_ModelInstance(start_date: String,end_date: String,totalins:String,remainingins:String,sip_reg_no:String) -> SIP_date_calculation{
        let subCategoryModel = SIP_date_calculation ()
        subCategoryModel.start_date = start_date
        subCategoryModel.end_date = end_date
        subCategoryModel.totalins = totalins
        subCategoryModel.remainingins = remainingins
        subCategoryModel.sip_reg_no = sip_reg_no
        return subCategoryModel
    }
}
