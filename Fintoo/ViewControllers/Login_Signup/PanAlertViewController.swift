 //
//  PanAlertViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 23/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class PanAlertViewController: BaseViewController {

    var topan : String!
    var p_email: String!
    var p_phone: String!
    var p_id : String!
    var p_final : String!
    var s_final : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        //var myString: String = "hello hi";
        var myStringArr = p_email.components(separatedBy: "@")
       print(myStringArr)
        
        
        let dropemail = myStringArr[0].dropLast(3)
        _ = myStringArr[0].count - 2
        if myStringArr[0].count >= 4  {
            print(myStringArr[0])
            let firsttwo = myStringArr[0].prefix(2)
            let lasttwo = myStringArr[0].suffix(2)
            let hastric = myStringArr[0].count - 4
            var text = ""
            for _ in 0...hastric{
                print("*")
                text += "*"
            }
            p_final = firsttwo + text + lasttwo
            print(p_final)


        }
        else{
            let firsttwo = myStringArr[0].prefix(1)
            let lasttwo = myStringArr[0].suffix(1)
            let hastric = myStringArr[0].count - 2
            var text = ""
            for _ in 0...hastric{
                print("*")
                text += "*"
            }
            p_final = firsttwo + text + lasttwo
            print(p_final)
        }
        if myStringArr[1].count >= 4  {
            print(myStringArr[0])
            let firsttwo = myStringArr[1].prefix(2)
            let lasttwo = myStringArr[1].suffix(2)
            let hastric = myStringArr[1].count - 4
            var text = ""
            for _ in 0...hastric{
                print("*")
                text += "*"
            }
            s_final = firsttwo + text + lasttwo
            print(s_final)
            
            
        }
        else{
            let firsttwo = myStringArr[1].prefix(1)
            let lasttwo = myStringArr[1].suffix(1)
            let hastric = myStringArr[1].count - 2
            var text = ""
            for _ in 0...hastric{
                print("*")
                text += "*"
            }
            s_final = firsttwo + text + lasttwo
            print(s_final)
        }
  
        _ = String(dropemail) + "***\(myStringArr[1])"
        
        let drop7 = p_phone.dropFirst(7)
        let pno = "*******" + drop7 as String
        
        pandetailmsg.text = "This PAN is alreay associated with email:\(p_final!)@\(s_final!) mobile:\(pno) OTP verification will be sent on mail id and mobile number. Once this person verifies,this PAN will be associated with your account? Do you want to go ahead wih this process? "

        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var pandetailmsg: UILabel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Nobtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Pancard Screen :- Alert No Button Clicked")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func yesbtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Pancard Screen :- Alert Yes Button Clicked")
        let otp = fourDigitNumber
        let longstring = "|*|" + otp
        let data = (longstring).data(using: String.Encoding.utf8)
        let base64 = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        print(base64)
        self.sendsmsotp(id: p_phone!, msg: "Greetings from Fintoo! Your OTP verification code is \(otp) ", encoded:"\(base64)", otp: otp,email:p_email!, p_id: p_id!)
       // self.sendmail(id: p_email!, msg: "Greetings from Fintoo! Your OTP verification code is ", encoded: "\(base64)")
        send_otp_on_mobile(mobile_number: p_email!, msg: "Greetings from Fintoo! Your OTP verification code is \(otp)", fourDigit :"\(otp)")
        sendmail(ToEmailID: "\(p_email!)", FromEmailID: "", Body: "Greetings from Fintoo! Your OTP verification code is \(otp)", Subject: "OTP Verification Code For Fintoo User")
    }
    
    
    
    func sendsmsotp(id:String,msg:String,encoded:String,otp:String,email:String,p_id:String){
        
        if Connectivity.isConnectedToInternet{
            let parameters = ["mobile" : "\(id)","msg" : "\(msg)","enc_resp":"3"]
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
                             self.presentWindow.hideToastActivity()
                        }
                        else{
                            print("send message")
                            print("otpScreen")
                             self.presentWindow.hideToastActivity()
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "OTPScreenViewController") as! OTPScreenViewController
                            destVC.toOTP = otp
                            destVC.id = "4"
                            destVC.tophone = id
                            destVC.toemail = email
                            destVC.toPAN = self.topan
                            destVC.p_id = p_id
                            let navController = UINavigationController(rootViewController: destVC)
                            self.present(navController, animated:true, completion: nil)
                            //self.navigationController?.pushViewController(destVC, animated: true)
                        }
                    }
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func sendmail(ToEmailID:String,FromEmailID:String,Body:String,Subject:String){
        let parameters = ["ToEmailID" : "\(ToEmailID)","FromEmailID" :"support@fintoo.in","Body" :"\(Body)","Subject": "\(Subject)","enc_resp":"3"]
        
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
                    if (data as? Any) != nil{
                        //print(data)
                        if let code = data as? NSArray {
                            //print(code)
                            for code in (code.value(forKey: "error") as? NSArray)! {
                                // print(code)
                                let email_code = code as! String
                                
                                if email_code == Constants.ERROR_CODE_1007{
                                    self.presentWindow?.makeToast(message: "OTP Failed To Sent on Mail")
                                    
                                }
                                else{
                                    print("OTP Send")
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
    
}
