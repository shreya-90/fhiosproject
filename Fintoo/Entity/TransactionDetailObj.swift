//
//  TransactionDetailObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 23/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class TransactionDetailObj: NSObject {
    var schemecode : String?
    var folio_no : String?
    var scheme_name : String?
    var curr_value : String?
    var gain_loss : String?
    var xirr : String?
    var transaction_type : String?
    var inv_amount : String?
    var inv_since : String?
    var price : String?
    var units : String?
    var cummUnits : String?
    var curNav : String?
    var curValue : String?
    var gainLoss : String?
    var days : String?
    var valid_for = [String]()
    var account_no : String?
    var is_exapanded: Bool = true;
    var internal_cagr : String?
    var no_of_units: String?
    var curr_value1 : String?
    var mininvest : String?
    var trxnnumber : String?
    var stptxnid : String?
    var stpcid : String?
    var trans_sell_buy : String?
    var swpcid : String?
    var minredeemAmt : String?
    var minredeemUnit : String?
    var curr_nav :String?
    static func getTransactionDetail(schemecode:String,scheme_name: String,curr_value: String,gain_loss:String,folio_no:String,xirr:String,account_no:String,valid_for:[String],no_of_units:String,curr_value1:String,mininvest:String,trxnnumber:String,stptxnid:String,stpcid:String,swpcid:String,minredeemAmt:String,minredeemUnit:String,curr_nav:String) -> TransactionDetailObj{
        let TransactionDetailModel = TransactionDetailObj()
        
        TransactionDetailModel.schemecode = schemecode
        TransactionDetailModel.folio_no = folio_no
        TransactionDetailModel.scheme_name = scheme_name
        TransactionDetailModel.curr_value = curr_value
        TransactionDetailModel.gain_loss = gain_loss
        TransactionDetailModel.xirr = xirr
        TransactionDetailModel.valid_for = valid_for
        TransactionDetailModel.account_no = account_no
        TransactionDetailModel.no_of_units = no_of_units
        TransactionDetailModel.curr_value1 = curr_value1
        TransactionDetailModel.mininvest = mininvest
        TransactionDetailModel.trxnnumber = trxnnumber
        TransactionDetailModel.stptxnid = stptxnid
        TransactionDetailModel.stpcid = stpcid
        TransactionDetailModel.swpcid = swpcid
        TransactionDetailModel.minredeemUnit = minredeemUnit
        TransactionDetailModel.minredeemAmt = minredeemAmt
        TransactionDetailModel.curr_nav = curr_nav
        return TransactionDetailModel
    }
    static func getTransactOnline(scheme_name: String,curr_value: String,gain_loss:String,xirr:String) -> TransactionDetailObj{
        let TransactionDetailModel = TransactionDetailObj()
        return TransactionDetailModel
    }
    static func getTransactionDetailS(transaction_type: String,inv_amount: String,inv_since:String,purchase_price: String,units:String,comm_units: String,curr_nav:String,curr_value:String,gain_loss:String,days:String,trans_sell_buy:String,internal_cagr:String) -> TransactionDetailObj{
        let TransactionDetailModel = TransactionDetailObj()
        TransactionDetailModel.transaction_type = transaction_type
        TransactionDetailModel.inv_amount = inv_amount
        TransactionDetailModel.inv_since = inv_since
        TransactionDetailModel.price = purchase_price
        TransactionDetailModel.units = units
        TransactionDetailModel.cummUnits = comm_units
        TransactionDetailModel.curNav = curr_nav
        TransactionDetailModel.curValue = curr_value
        TransactionDetailModel.gainLoss = gain_loss
        TransactionDetailModel.days = days
        TransactionDetailModel.trans_sell_buy = trans_sell_buy
        TransactionDetailModel.internal_cagr = internal_cagr
        //TransactionDetailModel.xirr = xirr
        return TransactionDetailModel
    }
    
    
}
