//
//  ProductObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 06/03/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation

class ProductObj:NSObject {
    var p_name :String?
    var p_rating: Int?
    var p_nav: String?
    var SIP : String?
    var lumpsum_Min : String?
    var lumpsum_Max : String?
    var SIP_Min : String?
    var SIP_Max : String?
    var OPT_Code : String?
    var Scheme_code : String
    var sipfreq : String?
    var allsipamounts : String?
    var offset : Int?
    var MAXINVT : String?
    var IsPurchaseAvailable : String?
    var isSelected: Bool = false
    var bseschemetype : String?
    var totalcount : String?
    init(p_name: String, p_rating: Int, p_nav: String,SIP : String,lumpsum_Min: String,lumpsum_Max:String,SIP_Min:String,SIP_Max:String,OPT_Code:String,Scheme_code:String,sipfreq:String,allsipamounts:String,offset: Int,MAXINVT:String,IsPurchaseAvailable:String,isSelected:Bool,bseschemetype:String,totalcount:String) {
        
        self.p_name = p_name
        self.p_rating = p_rating
        self.p_nav = p_nav
        self.SIP = SIP
        self.lumpsum_Max = lumpsum_Max
        self.lumpsum_Min = lumpsum_Min
        self.SIP_Min = SIP_Min
        self.SIP_Max = SIP_Max
        self.OPT_Code = OPT_Code
        self.Scheme_code = Scheme_code
        self.sipfreq = sipfreq
        self.allsipamounts = allsipamounts
        self.offset = offset
        self.MAXINVT = MAXINVT
        self.IsPurchaseAvailable = IsPurchaseAvailable
        self.isSelected = isSelected
        self.bseschemetype = bseschemetype
        self.totalcount = totalcount
    }

}
