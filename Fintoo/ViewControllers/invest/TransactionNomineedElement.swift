//
//  File.swift
//  Fintoo
//
//  Created by Dharmesh on 12/08/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation

typealias TransactionNomineed = [TransactionNomineedElement]

struct TransactionNomineedElement: Codable {
    let transactionNomineeID, transactionTxnID, transactionNomID: String
    
    enum CodingKeys: String, CodingKey {
        case transactionNomineeID = "transaction_nominee_id"
        case transactionTxnID = "transaction_txn_id"
        case transactionNomID = "transaction_nom_id"
    }
}

typealias Transactiondetails = [[String: String]]
