//
//  recommendedFundObj.swift
//  Fintoo
//
//  Created by Tabassum Sheliya on 12/06/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import Foundation
class recommendedFundObj:NSObject {
    var CLASSCODE : String?
    var ASSET_TYPE : String?
    var S_NAME : String?
    var SCHEMECODE : String?
    var NAVRS : String?
    var scheme_rating_value : String?
    var firstyear : String?
    var thirdyear : String?
    var fifthyear : String?
    var SIP : String?
    var PRIMARY_FUND : String?
    var scheme_most_popular : String?
    var scheme_recommended : String?
    var scheme_best_seller : String?
    var MININVT : String?
    var SIPMININVT : String?
    var allsipamounts : String?
    var sipfreq : String?
    var OPT_CODE : String?
    var MAXINVT : String?
    var multiples : String?
    var IsPurchaseAvailable : String?
    var searchedFund : String?
    var bseschemename : String?
    var Dividendoptionflag : String?
    var bseschemetype : String?
    var divided_amount : String?
    var asset_type_value : String?
    var amount_value : String?
   // var is_deleted = false
    //var reminder = 0
    var isSelected: Bool = false
    var addedtocart_flag = false
    init(CLASSCODE : String,ASSET_TYPE : String,S_NAME : String,SCHEMECODE : String,NAVRS : String,scheme_rating_value : String,firstyear : String,thirdyear : String,fifthyear : String,SIP : String,PRIMARY_FUND : String,scheme_most_popular : String,scheme_recommended : String,scheme_best_seller : String,MININVT : String,SIPMININVT : String,allsipamounts : String,sipfreq : String,OPT_CODE : String,MAXINVT : String,multiples : String,IsPurchaseAvailable : String,searchedFund : String,bseschemename : String,Dividendoptionflag : String,bseschemetype : String,divided_amount:String,isSelected:Bool,asset_type_value:String,amount_value:String,addedtocart_flag:Bool) {
      self.CLASSCODE = CLASSCODE
      self.ASSET_TYPE = ASSET_TYPE
      self.S_NAME = S_NAME
      self.SCHEMECODE = SCHEMECODE
      self.NAVRS = NAVRS
      self.scheme_rating_value = scheme_rating_value
      self.firstyear = firstyear
      self.thirdyear = thirdyear
      self.fifthyear = fifthyear
      self.SIP = SIP
      self.PRIMARY_FUND = PRIMARY_FUND
      self.scheme_most_popular = scheme_most_popular
      self.scheme_recommended = scheme_recommended
      self.scheme_best_seller = scheme_best_seller
      self.MININVT = MININVT
      self.SIPMININVT = SIPMININVT
      self.allsipamounts = allsipamounts
      self.sipfreq = sipfreq
      self.OPT_CODE = OPT_CODE
      self.MAXINVT = MAXINVT
      self.multiples = multiples
      self.IsPurchaseAvailable = IsPurchaseAvailable
      self.searchedFund = searchedFund
      self.bseschemename = bseschemename
      self.Dividendoptionflag = Dividendoptionflag
      self.bseschemetype = bseschemetype
      self.divided_amount = divided_amount
      self.isSelected = isSelected
      self.asset_type_value = asset_type_value
      self.amount_value = amount_value
      self.addedtocart_flag = addedtocart_flag
    }
    
}
