//
//  searchFundObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 18/02/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import Foundation

typealias SearchFundObj = [SearchFundObjElement]

struct SearchFundObjElement: Codable {
    let id, value: String
}

