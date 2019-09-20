//
//  PanCardViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 13/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire
import Mixpanel

class PanCardViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var pancardtf: UITextField!
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    override func viewDidLoad() {
        super.viewDidLoad()
        setWhiteNavigationBar()
        addBackbutton()
        pancardtf.delegate = self
        presentWindow = UIApplication.shared.keyWindow
        pancardtf.autocapitalizationType = .allCharacters
       
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        print(UserDefaults.standard.value(forKey: "userid")!)
        Mixpanel.mainInstance().track(event: "Pancard Screen :- Back Button Clicked")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func submitbtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Pancard Screen :- Submit Button Clicked")
        //print(validatePancard(pancardtf.text!))
        let boolean = validatePancard(pancardtf.text!)
        print(boolean)
        if pancardtf.text!.isEmpty{
            presentWindow?.makeToast(message: "Please Enter Valid PAN No")
            Mixpanel.mainInstance().track(event: "Pancard Screen :- Please Enter Valid PAN No.")
        }
        if boolean != true {
           presentWindow?.makeToast(message: "Please Enter Valid PAN No")
           Mixpanel.mainInstance().track(event: "Pancard Screen :- Please Enter Valid PAN No.")
        }
        else {
            //let userid = UserDefaults.standard.value(forKey: "userid")
            print(UserDefaults.standard.value(forKey: "userid")!)
            var userid = UserDefaults.standard.value(forKey: "userid")
            if flag != "0"{
                userid! = flag
                
            }
            else{
                // flag = "0"
                userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
            }
            validatepan(id:userid!,pan: pancardtf.text!)
        }
    }
    func validatePancard(_ candidate: String) -> Bool {
        let panCardRegex = "[A-Z]{3}[PHABTCF][A-Z]{1}[0-9]{4}[A-Z]{1}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", panCardRegex)
        return emailTest.evaluate(with: candidate)
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lowercaseCharRange: NSRange = (string as NSString).rangeOfCharacter(from: CharacterSet.lowercaseLetters)
        if lowercaseCharRange.location != NSNotFound {
            textField.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string.uppercased())
            return false
        } else  if textField == pancardtf{
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        return true
    }
    func validatepan(id:Any,pan:String){
        if Connectivity.isConnectedToInternet{
            let parameters = ["id" : "\(id)","pan" : "\(pan)"]
            
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.VALIDATE_PAN)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    //print(response.result.value)
                    let data = response.result.value
                    if (data) != nil{
                       if let code = data as? NSArray {
                        for c in (code as? NSArray)!{
                            print((c as AnyObject).value(forKey: "id"))
                        //}
                        
                            let p_uid = (c as AnyObject).value(forKey: "id") as? String
                            let p_email = (c as AnyObject).value(forKey: "email") as? String
                            let p_phone = (c as AnyObject).value(forKey: "mobile") as? String
                           // print(p_phone)
                            let p_response = (c as AnyObject).value(forKey: "response") as? String
                            if p_response == "true"{
                                print(p_uid!)
                                
                                var c_id = UserDefaults.standard.value(forKey: "userid")
                                if flag != "0"{
                                    c_id = flag
                                    
                                }
                                else{
                                    // flag = "0"
                                    c_id = "\(UserDefaults.standard.value(forKey: "userid"))"
                                }
                                print(c_id)
                                print(self.pancardtf.text!)
                                self.update_PAN(p_id: p_uid!, c_id: c_id!, pan: self.pancardtf.text!)
                            }
                            else{
                                print("panAlertViewController")
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "PanAlertViewController") as! PanAlertViewController
                                destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                destVC.topan = self.pancardtf.text!
                                destVC.p_email = p_email
                                destVC.p_phone = p_phone
                                destVC.p_id = p_uid
                                self.present(destVC, animated:true, completion: nil)
                                //let userid = UserDefaults.standard.value(forKey: "userid") as? String
                                
                            }
                            print(code.value(forKey: "id"))
                        }
                    }
                    }
                    else{
                        print(response.result.error ?? "")
                    }
            }
        }
        else{
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
        
    }
    func update_PAN(p_id:String,c_id:Any,pan:String){
        let parameters = ["id" : "\(p_id)","cid" : "\(c_id)","pan":"\(pan)"]
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.UPDATE_PAN)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value ?? "")
                    let data = response.result.value as? Int
                    if data == 1{
                        UserDefaults.standard.setValue(pan, forKey: "pan")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PanAlertSuccessViewController") as! PanAlertSuccessViewController
                        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                       // UserDefaults.standard.setValue(p_id, forKey: Constants.User_Defaults.USER_ID)
                        self.present(destVC, animated:true, completion: nil)
                    }
                    else{
                        self.presentWindow?.makeToast(message: "Something Went Wrong")
                    }
                    
            }
        }
        else{
            presentWindow!.makeToast(message: "Internet Connection not Available")
            
        }
    }
    func sendsmsotp(id:String,msg:String,encoded:String,otp:String,email:String,p_id:String){
    
        if Connectivity.isConnectedToInternet{
            let parameters = ["mobile" : "\(id)","msg" : "\(msg)","encoded":"\(encoded)","enc_resp":"3"]
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_SMS_OTP)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    let data = dict
                    if let response = data as? [[String: AnyObject]] {
                        let msg_code = String(response[0]["code"] as! Int)
                        print(msg_code)
                        if msg_code != Constants.ERROR_CODE_1701 {
                            self.presentWindow!.makeToast(message: "Failed To Send Message On Mobile")
                        }
                        else{
                            print("send message")
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "OTPScreenViewController") as! OTPScreenViewController
                            destVC.toOTP = otp
                            destVC.id = "4"
                            destVC.tophone = id
                            destVC.toemail = email
                            destVC.toPAN = self.pancardtf.text!
                            destVC.p_id = p_id
                            self.navigationController?.pushViewController(destVC, animated: true)
                        }
                    }
            }
        }
        else{
            
        }
    }
   


}
