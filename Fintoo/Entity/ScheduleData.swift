//
//  ScheduleData.swift
//  Fintoo
//
//  Created by iosdevelopermme on 22/02/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import Foundation

struct ScheduleData: Codable {
    let hoursOfOperation: HoursOfOperation
}

struct HoursOfOperation: Codable {
    let sat, fri, sun, mon: Fri
    let tue, wed, thu: Fri
}

struct Fri: Codable {
    let enabled: Bool
    let schedule: [Schedule]
}

struct Schedule: Codable {
    let time: Time
}

struct Time: Codable {
    let close, timeOpen: Int
    
    enum CodingKeys: String, CodingKey {
        case close
        case timeOpen = "open"
    }
}
