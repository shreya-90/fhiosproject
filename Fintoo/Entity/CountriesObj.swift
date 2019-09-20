//
//  CountriesObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 14/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class CountriesObj: NSObject {
    
    var country_name : String?
    var country_id : String?
    
    
    static func getuserdata(country_name: String,country_id: String) -> CountriesObj{
        let countryDetailModel = CountriesObj()
        countryDetailModel.country_name = country_name
        countryDetailModel.country_id = country_id
        return countryDetailModel
    }
    
    
    
}
