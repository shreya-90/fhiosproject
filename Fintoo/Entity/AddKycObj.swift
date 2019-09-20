//
//  AddKycObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 28/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class AddKycObj: NSObject {
    
    var kyc_id : String?
    var kyc_aadhar : String?
    var kyc_birth_place : String?
    var kyc_fathers_first_name : String?
    var kyc_fathers_middle_name : String?
    var kyc_fathers_last_name : String?
    var kyc_birth_country : String?
    
    
    static func addkycDetail(kyc_id: String,kyc_aadhar: String,kyc_birth_place: String,kyc_fathers_first_name: String,kyc_fathers_middle_name: String,kyc_fathers_last_name: String,kyc_birth_country: String) -> AddKycObj{
        let kycDetailModel = AddKycObj()
        kycDetailModel.kyc_id = kyc_id
        kycDetailModel.kyc_aadhar = kyc_aadhar
        kycDetailModel.kyc_birth_place = kyc_birth_place
        kycDetailModel.kyc_fathers_first_name = kyc_fathers_first_name
        kycDetailModel.kyc_fathers_middle_name = kyc_fathers_middle_name
        kycDetailModel.kyc_fathers_last_name = kyc_fathers_last_name
        kycDetailModel.kyc_birth_country = kyc_birth_country
        
        return kycDetailModel
    }
    
    
    
}
