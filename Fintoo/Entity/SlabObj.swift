//
//  SlabObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 29/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class SlabObj: NSObject {
    
    var IncomeSlabName : String?
    var IncomeSlabID : String?
    
    
    static func getIncomeSlab(IncomeSlabName: String,IncomeSlabID: String) -> SlabObj{
        let slabDetailModel = SlabObj()
        slabDetailModel.IncomeSlabID = IncomeSlabID
        slabDetailModel.IncomeSlabName = IncomeSlabName
        return slabDetailModel
    }
    
    
    
}
