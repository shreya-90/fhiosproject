//
//  FilterListModel.swift
//  Fintoo
//
//  Created by Matchpoint  on 17/03/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class SubCategoryModel: NSObject {
    
    var subCategoryName: String?
    var subCategoryId: String?
    var isSelected: Bool = false
    
    
    static func getFilterListModelInstance(subCategoryName: String,subCategoryId: String) -> SubCategoryModel{
        let subCategoryModel = SubCategoryModel ()
        subCategoryModel.subCategoryName = subCategoryName
        subCategoryModel.subCategoryId = subCategoryId
        return subCategoryModel
    }
    
    
    
}
