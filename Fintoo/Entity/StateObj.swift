//
//  CountriesObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 14/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class StateObj: NSObject {
    
    var State_name : String?
    var State_id : String?
    
    
    static func getState(State_name: String,State_id: String) -> StateObj{
        let StateDetailModel = StateObj()
        StateDetailModel.State_name = State_name
        StateDetailModel.State_id = State_id
        return StateDetailModel
    }
    
    
    
}
