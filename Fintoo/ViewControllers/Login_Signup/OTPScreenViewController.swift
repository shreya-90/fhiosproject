//
//  OTPScreenViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 13/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class OTPScreenViewController: BaseViewController {
    
    var id : String!
    var toOTP : String!
    var idu : String!
    var toemail : String!
    var tophone : String!
    var toprofile = ""
    var toPAN : String!
    var p_id : String!
    var topassword: String!
    
    @IBOutlet weak var OTPtf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         print(id)
        print(idu)
        setWhiteNavigationBar()
        addBackbutton()
       
        
        // Do any additional setup after loading the view.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        
        if id == "3" {
            navigationController?.popViewController(animated: true)
            Mixpanel.mainInstance().track(event: "OTP Screen :- Back Button Clicked")
        }
        
        else{
            Mixpanel.mainInstance().track(event: "OTP Screen :- Back Button Clicked")
            self.dismiss(animated: true, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func resendOTP(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "OTP Screen :- Resend Button Clicked")
        let fourdigit1 = fourDigitNumber
        OTPtf.text = ""
        self.send_otp_on_mobile1(mobile_number: "\(self.tophone!)", msg: "Greetings from Fintoo! Your OTP Verifaction code is \(fourdigit1)", fourDigit: "\(fourdigit1)")
       self.send_otp_on_Email(ToEmailID: "\(self.toemail!)", FromEmailID: "support@fintoo.in", Body: "Greetings from Fintoo! Your OTP verification code is \(fourdigit1)", Subject: "OTP Verification Code")
        //self.send_otp_on_Email(ToEmailID: "\(toemail)", FromEmailID: "", Body: "Greetings from Financial Hospital! Your OTP verification code is \(fourdigit)", Subject: "OTP Verification Code For FinancialHospital User")
    }
    
    @IBAction func submitOTP(_ sender: Any) {
        print(toOTP,"OTP on submit")
        print(id)
        Mixpanel.mainInstance().track(event: "OTP Screen :- Submit Button Clicked")
        if OTPtf.text!.isEmpty{
            Mixpanel.mainInstance().track(event: "OTP Screen :- Please Enter Correct OTP")
            presentWindow!.makeToast(message: "Please Enter Correct OTP")
        }
        
        else if (OTPtf.text == toOTP){
           presentWindow?.makeToastActivity(message: "Loading...")
            
            if id == "1"{
                presentWindow?.hideToastActivity()
               //"missing Mobile number in db"
                
                update_user_data()
                
                
            }
            else if id == "2"{
                //Register Screen
                presentWindow?.hideToastActivity()
                verified_user()
                print("register")

            }
            else if id == "3" {
                presentWindow?.hideToastActivity()
                //print("Forgot password screen")
                
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                destVC.toemail = toemail
                destVC.tophone = tophone
                navigationController?.pushViewController(destVC, animated: true)
            }
            else if id! == "4"{
                presentWindow?.hideToastActivity()
                let c_id = UserDefaults.standard.value(forKey: Constants.User_Defaults.USER_ID) as? String
                print(c_id,"current user id")
                print(p_id)
                print(toPAN)
                update_PAN(p_id: p_id, c_id: c_id!, pan: toPAN)
                //updating PAN
                
            }
        }
        else{
            Mixpanel.mainInstance().track(event: "OTP Screen :- Please Enter Valid OTP")
            presentWindow?.makeToast(message: "Please Enter Valid OTP")
        }
        
    }
    func update_PAN(p_id:String,c_id:String,pan:String){
        let parameters = ["id" : "\(p_id)","cid" : "\(c_id)","pan":"\(pan)"]
        print(parameters)
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.UPDATE_PAN)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value ?? "")
                    let data = response.result.value as? Int
                    if data == 1{
                        print("done")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PanAlertSuccessViewController") as! PanAlertSuccessViewController
                        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                        UserDefaults.standard.setValue(p_id, forKey: Constants.User_Defaults.USER_ID)
                        self.present(destVC, animated:true, completion: nil)
                        print("list")
                    }
                    else{
                        Mixpanel.mainInstance().track(event: "OTP Screen :- Something Went Wrong")
                        self.presentWindow?.makeToast(message: "Something Went Wrong!")
                    }
                    
            }
        }
        else{
            presentWindow!.makeToast(message: "Internet Connection not Available")
            
        }
    }
    func update_user_data(){
        let parameters = ["id" : "\(idu!.covertToBase64())","mobile" : "\(tophone!.covertToBase64())","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.UPDATE_MOBILE)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    print(enc_response)
                    var dict = ""
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    print(enc1)
                    if let enc = enc1?.base64Decoded() {
                        dict = enc
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    print(response.result.value ?? "register")
                    let data = dict
                    print(data,"Missing Mobile number data")
                    
                    if (data as? Any) != nil{
                        print("@@@@@@@@@@@@@@@@",data)
                        //if let code = data as? NSString{
                            if data == "true"{
                                Mixpanel.mainInstance().track(event: "OTP Screen :- Mobile number Updated Successfully")
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                
                                UserDefaults.standard.setValue(self.tophone!, forKey: Constants.User_Defaults.MOBILE_NUMBER)
                                UserDefaults.standard.setValue(self.toprofile, forKey: Constants.User_Defaults.PROFILE_IMG)
                                UserDefaults.standard.setValue(self.toemail!, forKey: Constants.User_Defaults.EMAIL)
                                UserDefaults.standard.set(true, forKey: Constants.User_Defaults.USER_LOGIN)
                                self.navigationController?.pushViewController(destVC, animated: true)
                            }
                            else{
                                Mixpanel.mainInstance().track(event: "OTP Screen :- Technical issue")
                                print("Technical issue")
                                self.presentWindow!.makeToast(message: "Technical issue")
                            }
                        //}
//                        else{
//
//                        }
                    }
            }
        }
        else{
            presentWindow!.makeToast(message: "Internet Connection not Available")
           
        }
    }
    func send_otp_on_mobile1(mobile_number:String,msg:String,fourDigit:String){
        presentWindow?.makeToastActivity(message: "Sending...")
        if Connectivity.isConnectedToInternet{
             let parameters = ["mobile" : "\(mobile_number.covertToBase64())","msg" : "\(msg.covertToBase64())","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
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
                    print(response.result.value ?? "Resend OTP")
                    let data = dict
                    if  data != nil{
                        let data = data
                        if let code = data as? NSArray {
                            //print(code)
                            for code in (code.value(forKey: "code") as? NSArray)! {
                                print(code)
                                let msg_code = String(code as! Int)
                                if msg_code != Constants.ERROR_CODE_1701{
                                    self.presentWindow?.hideToastActivity()
                                    self.presentWindow!.makeToast(message: "Failed To Send OTP on Mobile")
                                    Mixpanel.mainInstance().track(event: "OTP Screen :- Failed To Send OTP on Mobile")
                                }
                                else{
                                    self.presentWindow?.hideToastActivity()
                                    //self.send_Email()
                                    print("otpScreen")
                                    self.toOTP = fourDigit
                                    
                                    
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
            presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "Internet Connection not Available")
            // self.navigationController?.view.makeToast("Internet Connection not Available!", duration: 3.0, position: .center)
        }
    }
    func verified_user(){
        
        if id == "2" {
            print(toprofile)
            if toprofile == ""{
                toprofile = "0"
            }
            //print(toprofile,"hello")
            let parameters = ["mobile" : "\(tophone!.covertToBase64())","email" : "\(toemail!.covertToBase64())","password" : "\(topassword!.covertToBase64())","tags" :"Mobile_App_Fintoo","profile" : "\(toprofile.covertToBase64())","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
            //print(fourDigit)
            presentWindow?.makeToastActivity(message: "")
            if Connectivity.isConnectedToInternet{
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.REGISTER_USER)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
                        if (data as? Any) != nil{
                            print("@@@@@@@@@@@@@@@@data",data)
                            if let code = data as? NSArray {
                                var idu : Any?
                                var pf = ""
                                print(pf,"profile image")
                                print(idu,"id#######")
                                print(code.value(forKey: "id"))
                                for code1 in (code.value(forKey: "profile") as? NSArray)! {
                                    pf = code1 as! String
                                }
                                for code2 in (code.value(forKey: "id") as? NSArray)! {
                                    idu = (code2 as? Any)
                                }
                                for code in (code.value(forKey: "error") as? NSArray)! {
                                    // print(code)
                                    //code.valu
                                    let errorcode = code as! String
                                    print(errorcode)
                                    if errorcode == "1006" {
                                        self.presentWindow?.hideToastActivity()
                                        self.presentWindow!.makeToast(message: "Error Has Occurred Please Retry After Some Time")
                                        
                                    }
                                    else{
                                        
                                        self.presentWindow?.hideToastActivity()
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let destVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                        print(idu)
                                        UserDefaults.standard.setValue(idu!, forKey: Constants.User_Defaults.USER_ID)
                                        UserDefaults.standard.setValue(idu!, forKey: "parent_user_id")
                                        //UserDefaults.standard.setValue(Any?, forKey: "parent_user_id")
                                        flag = String(describing: idu!)
                                        UserDefaults.standard.setValue(self.tophone!, forKey: Constants.User_Defaults.MOBILE_NUMBER)
                                        UserDefaults.standard.setValue(pf, forKey: Constants.User_Defaults.PROFILE_IMG)
                                        UserDefaults.standard.setValue(self.toemail!, forKey: Constants.User_Defaults.EMAIL)
                                        UserDefaults.standard.set(true, forKey: Constants.User_Defaults.USER_LOGIN)
                                        self.navigationController?.pushViewController(destVC, animated: true)
                                        
                                    }
                                }
                                
                            }
                            else{
                                self.presentWindow?.hideToastActivity()
                                self.presentWindow!.makeToast(message: "Registration Failed Please Try Again Later")
                               // Mixpanel.mainInstance().track(event: "OTP screen:- Registration Failed")
                            }
                        }
                        
                        
                }
            }
            else{
                presentWindow?.hideToastActivity()
                presentWindow!.makeToast(message: "Internet Connection not Available")
                
            }
        }
        else if id == "0"{
            print("OTp")
        }
    }
}
