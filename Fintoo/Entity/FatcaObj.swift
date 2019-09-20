//
//  FatcaObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 29/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class FatcaObj: NSObject {
    
//    var IncomeSlabName : String?
//    var IncomeSlabID : String?
    var fatcaid : String?
    var fatca_networth : String?
    var fatca_networth_date : String?
    var fatca_politically_exposed : String?
    var fatca_nationality : String?
    var fatca_other_nationality : String?
    var fatca_tax_res : String?
    var fatca_resident_country : String?
    var fatca_resident_country_1 : String?
    var fatca_resident_country_2 : String?
    var fatca_tax_player_id : String?
    var fatca_tax_player_id_1 : String?
    var fatca_tax_player_id_2 : String?
    var fatca_id_type : String?
    var fatca_id_type_1 : String?
    var fatca_id_type_2 : String?
//    "fatca_networth" : "",
//    "fatca_networth_date" : "",
//    "fatca_politically_exposed" : "\(politically_exposed!)",
//    "fatca_nationality" : "",
//    "fatca_other_nationality" : "",
//    "fatca_tax_res" : "",
//    "fatca_resident_country" : "",
//    "fatca_resident_country_1" : "",
//    "fatca_resident_country_2" : "",
//    "fatca_tax_player_id" : "",
//    "fatca_tax_player_id_1" : "",
//    "fatca_tax_player_id_2" : "",
//    "fatca_id_type" : "",
//    "fatca_id_type_1" : "",
//    "fatca_id_type_2" : ""
    
    static func getFatcaDetail(fatcaid : String?, fatca_networth : String?, fatca_networth_date : String?, fatca_politically_exposed : String?, fatca_nationality : String?, fatca_other_nationality : String?, fatca_tax_res : String?, fatca_resident_country : String?, fatca_resident_country_1 : String?, fatca_resident_country_2 : String?, fatca_tax_player_id : String?, fatca_tax_player_id_1 : String?, fatca_tax_player_id_2 : String?, fatca_id_type : String?, fatca_id_type_1 : String?, fatca_id_type_2 : String?) -> FatcaObj{
        let fatcaDetailModel = FatcaObj()
        fatcaDetailModel.fatcaid = fatcaid
        fatcaDetailModel.fatca_networth = fatca_networth //fatcaDetailModel.fatcaid = fatcaid
        fatcaDetailModel.fatca_networth_date = fatca_networth_date
        fatcaDetailModel.fatca_politically_exposed = fatca_politically_exposed
        fatcaDetailModel.fatca_nationality = fatca_nationality
        fatcaDetailModel.fatca_other_nationality = fatca_other_nationality
        fatcaDetailModel.fatca_tax_res = fatca_tax_res
        fatcaDetailModel.fatca_tax_player_id = fatca_tax_player_id
        fatcaDetailModel.fatca_tax_player_id_1 = fatca_tax_player_id_1
        fatcaDetailModel.fatca_tax_player_id_2 = fatca_tax_player_id_2
        fatcaDetailModel.fatca_id_type = fatca_id_type
        fatcaDetailModel.fatca_id_type_1 = fatca_id_type_1
        fatcaDetailModel.fatca_id_type_2 = fatca_id_type_2
        fatcaDetailModel.fatca_resident_country = fatca_resident_country
        fatcaDetailModel.fatca_resident_country_1 = fatca_resident_country_1
        fatcaDetailModel.fatca_resident_country_2 = fatca_resident_country_2
        
        
        return fatcaDetailModel
    }
    
    
    
}
