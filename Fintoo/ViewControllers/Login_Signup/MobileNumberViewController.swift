//
//  MobileNumberViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 14/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class MobileNumberViewController: BaseViewController {

    @IBOutlet weak var mobileNumbertf: UITextField!
    
    var idu: String!
    
    
    var email = String()
    var mobileNumber = String()
    var profile = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        setWhiteNavigationBar()
        addBackbutton()
        // Do any additional setup after loading the view.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Mobile Number Screen :- Back Button Clicked")
        dismiss(animated: true, completion: nil)
    }
    @IBAction func submitButton(_ sender: Any) {
         Mixpanel.mainInstance().track(event: "Mobile Number Screen :- Submit Button Clicked")
        if mobileNumbertf.text!.isEmpty {
            Mixpanel.mainInstance().track(event: "Mobile Number Screen :- Please Enter Correct Mobile No")
            presentWindow?.makeToast(message: "Please Enter Correct Mobile No")
        }
        else if mobileNumbertf.text!.count < 10{
            Mixpanel.mainInstance().track(event: "Mobile Number Screen :- Please Enter Correct Mobile No")
            presentWindow!.makeToast(message: "Please Enter Correct Mobile No")
        }
        else{
        let url = "\(Constants.BASE_URL)\(Constants.API.MOBILE_UPDATE_MOBILE)\(mobileNumbertf.text!)"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default)
            .responseJSON { response in
                print(response.result.value)
                let data = response.result.value! as? String
                if data == "true"{
                    self.send_otp_on_mobile1(mobile_number: "\(self.mobileNumbertf.text!)", msg: "Greetings from Fintoo! Your OTP Verifaction code is \(fourdigit)", fourDigit: "\(fourdigit)")
                    
                }
                else{
                    Mixpanel.mainInstance().track(event: "Mobile Number Screen :- \(data!)")
                    self.presentWindow?.makeToast(message: "\(data!)")
                }
        }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
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
                    let data = dict
                    print(data,"mobile Number data")
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
                                    Mixpanel.mainInstance().track(event: "Mobile Number Screen :- Failed To Send OTP on Mobile")
                                }
                                else{
                                    
                                    //self.send_Email()
                                   //  Mixpanel.mainInstance().track(event: "Mobile Number Screen :- Failed To Send OTP on Mobile")
                                    print("otpScreen")
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "OTPScreenViewController") as! OTPScreenViewController
                                    destVC.toOTP = fourDigit
                                    destVC.id = "1"
                                    //destVC.id = "1"
                                    
                                    destVC.idu = self.idu
                                    destVC.toemail = self.email
                                    destVC.tophone = self.mobileNumbertf.text!
                                    destVC.toprofile = self.profile
                                    let navController = UINavigationController(rootViewController: destVC)
                                    self.present(navController, animated:true, completion: nil)
                                    //self.present(destVC, animated:true, completion:nil)
                                    
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
            presentWindow?.makeToast(message: "Internet Connection not Available")
            // self.navigationController?.view.makeToast("Internet Connection not Available!", duration: 3.0, position: .center)
        }
    }
}
