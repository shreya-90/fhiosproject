//
//  GetPickInvestPlan.swift
//  Fintoo
//
//  Created by Tabassum Sheliya on 30/05/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//
import Foundation

// MARK: - GetPickInvestPlan
import Foundation
class GetPickInvestPlan {
    var id: String
    var invest_plans: String
    var plans_img_url: String
    var plans_categroy_id: String
    var is_most_popular: String
    
    init(id: String, invest_plans: String, plans_img_url: String, plans_categroy_id: String, is_most_popular: String) {
        self.id = id
        self.invest_plans = invest_plans
        self.plans_img_url = plans_img_url
        self.plans_categroy_id = plans_categroy_id
        self.is_most_popular = is_most_popular
        
    }
}

