//
//  AssetObj.swift
//  Fintoo
//
//  Created by iosdevelopermme on 01/09/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import Foundation
class AssetObj {
    
    var  name :  String
    var  y :  Double
    var  is_selected :  Bool
    var colors : UIColor
    var values : Double
    
    init (name : String, y : Double, is_selected : Bool,colors:UIColor,values:Double){
        self.name = name
        self.y = y
        self.is_selected = is_selected
       self.colors = colors
        self.values = values
    }
}
