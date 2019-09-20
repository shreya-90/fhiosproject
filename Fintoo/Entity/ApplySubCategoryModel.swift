//
//  ApplySubCategoryModel.swift
//  Fintoo
//
//  Created by iosdevelopermme on 26/03/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class ApplysubCategoryModel: NSObject {
    
    var subCategoryName: String?
    var subCategoryId: String?
    var isSelected: Bool = false
    
    
    static func getFilterListModelInstance(subCategoryName: String,subCategoryId: String) -> ApplysubCategoryModel{
        let applysubCategoryModel = ApplysubCategoryModel ()
        applysubCategoryModel.subCategoryName = subCategoryName
        applysubCategoryModel.subCategoryId = subCategoryId
        return applysubCategoryModel
    }
    
    
    
}
