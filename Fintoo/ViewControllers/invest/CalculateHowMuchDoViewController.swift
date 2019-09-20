//
//  CalculateHowMuchDoViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 20/03/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Mixpanel
protocol Delegate : class {
    func doSomething(goal: String,year:String)
}

class CalculateHowMuchDoViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var viewHowMuch: UIView!
    
    @IBOutlet weak var goaltf: UITextField!
    
    @IBOutlet weak var yearstf: UITextField!
    var row : Int?
    var tableview = UITableView()
   weak var delegate: Delegate?
    override func viewDidLoad() {
        super.viewDidLoad()
       // viewHowMuch.dropShadow()
       goaltf.delegate = self
        viewHowMuch.dropShadow(color: .black, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 3, scale: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == goaltf{
            if textField.text != "" {
                let formatter = NumberFormatter()              // Cache this,
                formatter.locale = Locale(identifier: "en_IN") // Here indian local
                formatter.numberStyle = .decimal
                let string = formatter.string(from: goaltf.text!.numberValue!)
                goaltf.text = string
            }
        }
        
    }
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        Mixpanel.mainInstance().track(event: "Start SIP Screen :- Cancel Button Clicked")
    }
    @IBAction func calculate(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Start SIP Screen :- Calculate Button Clicked")
        goaltf.resignFirstResponder()
        yearstf.resignFirstResponder()
        if goaltf.text!.isEmpty{
            goaltf.resignFirstResponder()
            presentWindow.makeToast(message: "Please Enter Goal Amount")
             Mixpanel.mainInstance().track(event: "Start SIP Screen :- Please Enter Goal Amount")
        }
        else if goaltf.text! == "0" {
                presentWindow.makeToast(message: "Min amount too low to calculate SIP amount")
        }
        else if yearstf.text!.isEmpty{
            presentWindow.makeToast(message: "Please Enter Year(s)")
            yearstf.resignFirstResponder()
            
            presentWindow.makeToast(message: "Please Enter Year(s)")
        }
        else if yearstf.text! == "0"{
            presentWindow.makeToast(message: "Min 1 Year Allowed")
            yearstf.resignFirstResponder()
            presentWindow.makeToast(message: "Min 1 Year Allowed")
        }else if Int(yearstf.text ?? "0")! > 60 {
            yearstf.resignFirstResponder()
            
            presentWindow.makeToast(message: "Max 60 Years Allowed")
            presentWindow.makeToast(message: "Max 60 Years Allowed")
        }
        else {
            let abc = goaltf.text?.replacingOccurrences(of: ",", with: "")
            let year = Double(yearstf.text!)!*12
            let er = (0.10)/12
            let pv = Double(abc!)
            let npv = -(pv!);
            let math = 1 - pow((1+er), year)
            var pmt = npv*(er/math)
            pmt = max(pmt,0);
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            _ = storyBoard.instantiateViewController(withIdentifier: "StartSIPViewController") as! StartSIPViewController
            if delegate != nil {
                delegate?.doSomething(goal: String(Int(pmt)), year: yearstf.text!)
                dismiss(animated: true, completion: nil)
            }
        
        }
    }
    
   

}
