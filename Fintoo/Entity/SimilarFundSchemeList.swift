//
//  SimilarFundSchemeList.swift
//  Fintoo
//
//  Created by iosdevelopermme on 09/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class SimilarFundSchemeList: NSObject {
    
    var schemecode : String?
    var scheme : String?
    var MININVT : String?
    
    static func getSchemeFund(schemecode: String,scheme: String,MININVT:String) -> SimilarFundSchemeList{
        let bankDetailModel = SimilarFundSchemeList()
        bankDetailModel.schemecode = schemecode
        bankDetailModel.scheme = scheme
        bankDetailModel.MININVT = MININVT
        return bankDetailModel
    }
}
