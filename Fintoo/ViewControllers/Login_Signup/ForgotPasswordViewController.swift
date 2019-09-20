//
//  ForgotPasswordViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 13/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class ForgotPasswordViewController: BaseViewController {

    @IBOutlet weak var forgotPwdtf: UITextField!
    var email : String!
    var mobile : String!
    var fourDigit = fourDigitNumber
    override func viewDidLoad() {
        super.viewDidLoad()
        setWhiteNavigationBar()
        addBackbutton()
        
        // Do any additional setup after loading the view.
    }

    
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Forgot Password Screen :- Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }

    func forgot_password(){
        presentWindow?.makeToastActivity(message: "Updating..")
        let parameters = [ "mobile" : "\(forgotPwdtf.text!.covertToBase64())","enc_resp" :"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
        print(parameters)
        if Connectivity.isConnectedToInternet{
           // \(Constants.BASE_URL)\(Constants.API.USER_EMAIL_MOBILE)
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.USER_EMAIL_MOBILE)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    print(enc_response)
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    print(enc1)
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    print(response.result.value ?? "forgot")
                    let data = dict
                    if data != nil{
                        print(data ?? "")
                        if let code = data as? NSArray {
                            //print(code)
                            for c in code {
                                let response = (c as AnyObject).value(forKey: "response") as! String
                                
                                print(response,"!!!!!!!!!!!!!!!!")
                                self.navigationController?.view.hideToastActivity()
                                if response == "true"{
                                    self.presentWindow?.hideToastActivity()
                                    self.email = (c as AnyObject).value(forKey: "email") as! String
                                    self.mobile = (c as AnyObject).value(forKey: "mobile") as? String
                                    Mixpanel.mainInstance().track(event: "Forgot Password screen:- Sending OTP")
                                    if self.forgotPwdtf.text!.isNumeric{
                                         self.send_otp_on_mobile1(mobile_number: ("\(self.forgotPwdtf.text!)"), msg:  "Greetings from Fintoo! Your OTP Verifaction code is \(fourdigit)",fourDigit:"\(fourdigit)")// send on msg and email
                                        //self.send_Email(toEmail: self.email,flag:2)
                                        self.send_otp_on_Email1(ToEmailID: "\(self.email ?? "")", FromEmailID: "support@fintoo.in", Body: "Greetings from Fintoo! Your OTP verification code is \(fourdigit)", Subject: "OTP Verification Code", flag: "", fourDigit: "\(fourdigit)")
                                    }else {
                                        if self.mobile == "" {
                                            self.send_otp_on_Email1(ToEmailID: "\(self.forgotPwdtf.text!)", FromEmailID: "support@fintoo.in", Body: "Greetings from Fintoo! Your OTP verification code is \(fourdigit)", Subject: "OTP Verification Code", flag: "1",fourDigit: "\(fourdigit)")
                                        }else{
                                            self.send_otp_on_mobile1(mobile_number: ("\(self.mobile!)"), msg:  "Greetings from Fintoo! Your OTP Verifaction code is \(fourdigit)",fourDigit:"\(fourdigit)")// send on msg and email
                                            //self.send_Email(toEmail: self.email,flag:2)
                                            self.send_otp_on_Email1(ToEmailID: "\(self.forgotPwdtf.text!)", FromEmailID: "support@fintoo.in", Body: "Greetings from Fintoo! Your OTP verification code is \(fourdigit)", Subject: "OTP Verification Code", flag: "", fourDigit: "\(fourdigit)")
                                        }
                                        
                                        print("sendemail")
                                    }
                                }
                                else{
                                    self.presentWindow?.hideToastActivity()
                                    self.presentWindow!.makeToast(message: "Please Enter A Valid Email/Mobile")
                                    Mixpanel.mainInstance().track(event: "Forgot Password screen:- Mobile Number Does Not Exists")
                                    
                                }
                                
                            }
                            
                        }
                    }
            }
        }
        else{
            presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message:"Internet Connection not Available")
           
        }
        
    }
    //func send_otp(msg:String)
    func send_otp_on_mobile1(mobile_number:String,msg:String,fourDigit:String){
        if Connectivity.isConnectedToInternet{
            let parameters = ["mobile" : "\(mobile_number.covertToBase64())","msg" : "\(msg.covertToBase64())","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
            print(parameters)
            print(fourDigit)
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_SMS_OTP)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    print(enc_response)
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    print(enc1)
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    print(response.result.value ?? "register")
                    let data = dict
                    print(data,"register data")
                    // print(response.result.value)
                    if data != nil{
                        let data = dict
                        if let code = data as? NSArray {
                            //print(code)
                            for code in (code.value(forKey: "code") as? NSArray)! {
                                print(code)
                                let msg_code = String(code as! Int)
                                if msg_code != Constants.ERROR_CODE_1701{
                                    
                                    self.presentWindow!.makeToast(message: "Failed To Send OTP on Mobile")
                                    Mixpanel.mainInstance().track(event: "Register Screen :- Failed To Send OTP on Mobile")
                                }
                                else{
                                    
                                    //self.send_Email()
                                    
                                    print("otpScreen")
                                    print(fourdigit)
                                    self.send_otp_on_Email(ToEmailID: "\(self.email!)", FromEmailID: "support@fintoo.in", Body: "Greetings from Fintoo! Your OTP verification code is \(self.fourDigit)", Subject: "OTP Verification Code")
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "OTPScreenViewController") as! OTPScreenViewController
                                    destVC.id = "3"
                                    destVC.toOTP = fourDigit
                                    destVC.toemail = self.email
                                    destVC.tophone = self.mobile
                                    // destVC.toEmail =
                                    
                                    self.navigationController?.pushViewController(destVC, animated: true)
                                    
                                    
                                }
                                
                            }
                        }
                    }
                    else{
                        print(response.result.error ?? "")
                    }
            }
        }
        else{
            Mixpanel.mainInstance().track(event: "Register Screen :- Internet Connection not Available")
            presentWindow?.makeToast(message: "Internet Connection not Available")
            // self.navigationController?.view.makeToast("Internet Connection not Available!", duration: 3.0, position: .center)
        }
    }
    func send_otp_on_Email1(ToEmailID:String,FromEmailID:String,Body:String,Subject:String,flag:String,fourDigit:String){
        // print("\(tfEmail.text!) @@@@ \(fourDigit)")
        let parameters = ["ToEmailID" : "\(ToEmailID.covertToBase64())","FromEmailID" :"support@fintoo.in","Body" :"\(Body.covertToBase64())","Subject": "\(Subject.covertToBase64())","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
        print(parameters,"email")
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_APP_EMAIL1)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    print(enc_response)
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    print(enc1)
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    print(response.result.value ?? "register")
                    let data = dict
                    print(data ,"register")
                    //let data = response.result.value
                    if (data as? Any) != nil{
                        //print(data)
                        if let code = data as? NSArray {
                            //print(code)
                            for code in (code.value(forKey: "error") as? NSArray)! {
                                print(code)
                                let email_code = code as! String
                                
                                if email_code == Constants.ERROR_CODE_1007{
                                    self.presentWindow?.makeToast(message: "OTP Failed To Sent on Mail")
                                    
                                }
                                else{
                                    print("OTP Send on mail")
                                    if flag == "1" {
                                        print("otpScreen")
                                        print(fourdigit)
//                                        self.send_otp_on_Email(ToEmailID: "\(self.email!)", FromEmailID: "support@fintoo.in", Body: "Greetings from Fintoo! Your OTP verification code is \(self.fourDigit)", Subject: "OTP Verification Code")
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let destVC = storyBoard.instantiateViewController(withIdentifier: "OTPScreenViewController") as! OTPScreenViewController
                                        destVC.id = "3"
                                        destVC.toOTP = fourDigit
                                        destVC.toemail = self.email
                                        destVC.tophone = self.mobile
                                        // destVC.toEmail =
                                        
                                        self.navigationController?.pushViewController(destVC, animated: true)
                                    }
                                    //self.presentWindow!.makeToast(message: "OTP Failed To Sent on Mail")
                                    
                                }
                            }
                        }
                    }
            }
        }
        else{
            presentWindow!.makeToast(message: "Internet Connection not Available")
            
        }
    }
    @IBAction func submitbtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Forgot Password Screen :- Submit Button Clicked")
//        if (forgotPwdtf.text!.isEmpty){
//            presentWindow!.makeToast(message: "Please Enter A Valid Mobile No")
//            Mixpanel.mainInstance().track(event: "Forgot Password Screen:- Please Enter A Valid Mobile No")
//        }
//        else if forgotPwdtf.text!.count < 10{
//            presentWindow!.makeToast(message: "Please Enter A Valid Mobile No")
//            Mixpanel.mainInstance().track(event: "Forgot Password Screen:- Please Enter A Valid Mobile No")
//        }
//        else{
//            forgot_password()
//        }
        if (forgotPwdtf.text!.isEmpty){
            presentWindow!.makeToast(message: "Please Enter A Valid Email/Mobile")
            Mixpanel.mainInstance().track(event: "Forgot Password screen:- Mobile No Field Is Empty")
        }
        else{
            forgot_password()
        }
    }

}
extension String {
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}
