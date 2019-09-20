//
//  timeSlotObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 12/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation

class timeSlotObj: NSObject {
    
    var time_slot_id : String?
    var time_slot_value : String?
    
    static func getTimeSlot(time_slot_id: String,time_slot_value: String) -> timeSlotObj{
        let timeSlotDetailModel = timeSlotObj()
        timeSlotDetailModel.time_slot_id = time_slot_id
        timeSlotDetailModel.time_slot_value = time_slot_value
        return timeSlotDetailModel
    }
}
