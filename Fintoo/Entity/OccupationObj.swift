//
//  OccupationObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 24/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class OccupationObj: NSObject {
    
    var occupation_name : String?
    var occupation_id : String?
    
    
    static func getOccupation(occupation_id: String,occupation_name: String) -> OccupationObj{
        let occupationDetailModel = OccupationObj()
        occupationDetailModel.occupation_id = occupation_id
        occupationDetailModel.occupation_name = occupation_name
        return occupationDetailModel
    }
    
    
    
}
