//
//  myCustomSlider.swift
//  slider
//
//  Created by iosdevelopermme on 10/10/17.
//  Copyright © 2017 iosdevelopermme. All rights reserved.
//

import UIKit

class myCustomSlider: UISlider {
    
    var label: UILabel
    var labelXMin: CGFloat?
    var labelXMax: CGFloat?
    var labelText: ()->String = { "" }
    var decBtn: UIButton?
    var incBtn: UIButton?
    public var incrementValue: Float = 1.0
    required public init(coder aDecoder: NSCoder) {
        label = UILabel()
        super.init(coder: aDecoder)!
        //  self.addTarget(self, action: Selector(("onValueChanged:")), for: .valueChanged)
        self.addTarget(self, action: #selector(geofenceValueChange(_:)), for: .valueChanged)
        
    }
    
    func setup(){
        labelXMin = frame.origin.x + 16
        labelXMax = frame.origin.x + self.frame.width - 14
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRect(x:labelXPos,y:self.frame.origin.y - 25, width:200, height:25)
        label.text = self.value.description
        self.superview!.addSubview(label)
        
        
    }
    func updateLabel(){
        label.text = labelText()
        let labelXOffset: CGFloat = labelXMax! - labelXMin!
        let valueOffset: CGFloat = CGFloat(self.maximumValue - self.minimumValue)
        let valueDifference: CGFloat = CGFloat(self.value - self.minimumValue)
        let valueRatio: CGFloat = CGFloat(valueDifference/valueOffset)
        let labelXPos = CGFloat(labelXOffset*valueRatio + labelXMin!)
        label.frame = CGRect(x:labelXPos - label.frame.width/2,y:self.frame.origin.y - 25, width:200, height:25)
        label.textAlignment = NSTextAlignment.center
        self.superview!.addSubview(label)
    }
    public override func layoutSubviews() {
        
        let intString = String(Int(Float(self.value.description)!))
        let fv = Double(intString)
        let formatter = NumberFormatter()              // Cache this,
        formatter.locale = Locale(identifier: "en_IN") // Here indian local
        formatter.numberStyle = .decimal
        
        let string = formatter.string(from: NSNumber(value: fv!))
        

       // Format format = com.ibm.icu.text.NumberFormat.getCurrencyInstance(new Locale("en", "in"));
       // System.out.println(format.format(new BigDecimal("100000000")));
        label.font = label.font.withSize(15)
        label.textColor = UIColor(hexaString: "#2DB4E8")

        labelText = { "₹ " + string! }
       
        setup()
        updateLabel()
        super.layoutSubviews()
        super.layoutSubviews()
    }
    @objc func geofenceValueChange(_ sender:UISlider) {
       updateLabel()
    }
    func increment(sender: UIButton!){
      //  let_ = self.value
        self.value += Float(incrementValue)
        updateLabel()
    }
    func decrement(sender: UIButton){
        //let val = self.value
        self.value -= Float(incrementValue)
        updateLabel()
    }
    
    
    
}
//extension UIColor {
//    convenience init(hexaString: String, alpha: CGFloat = 1) {
//        let chars = Array(hexaString.characters)
//        self.init(red:   CGFloat(strtoul(String(chars[1...2]),nil,16))/255,
//                  green: CGFloat(strtoul(String(chars[3...4]),nil,16))/255,
//                  blue:  CGFloat(strtoul(String(chars[5...6]),nil,16))/255,
//                  alpha: alpha)}
//}
