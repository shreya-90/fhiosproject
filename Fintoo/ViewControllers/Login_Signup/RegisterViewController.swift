//
//  RegisterViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 13/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel

var fourdigit = fourDigitNumber

class RegisterViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet weak var emailIdtf: UITextField!
    
    @IBOutlet weak var mobileNotf: UITextField!
    @IBOutlet weak var checkBox: UIButton!
    
    @IBOutlet weak var passwordTf: UITextField!
    
    @IBOutlet weak var ConfirmPwdTf: UITextField!
    var iconClick : Bool!
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
    let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
    var checkBoxSelected = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      //  setTransperntNavigationBar()
        checkBox.layer.borderWidth = 2
        checkBox.layer.borderColor = UIColor.gray.cgColor
        //mobileNotf.delegate = self
        passwordTf.delegate = self
       ConfirmPwdTf.delegate = self
        passwordTf.rightViewMode = UITextFieldViewMode.always
        
        let image = UIImage(named: "show")
        imageView.image = image
        passwordTf.rightView = imageView
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(eyebtnTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
        
        
        ConfirmPwdTf.rightViewMode = UITextFieldViewMode.always
        
        let image1 = UIImage(named: "show")
        imageView1.image = image1
        ConfirmPwdTf.rightView = imageView1
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(eyebtnTapped1(tapGestureRecognizer1:)))
        imageView1.isUserInteractionEnabled = true
        imageView1.addGestureRecognizer(tapGestureRecognizer1)
        
        // Do any additional setup after loading the view.
    }

    @objc func eyebtnTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if(iconClick == true) {
            passwordTf.rightViewMode = UITextFieldViewMode.always
            let image = UIImage(named: "show")
            passwordTf.isSecureTextEntry = true
            imageView.image = image
            passwordTf.rightView = imageView
            iconClick = false
            Mixpanel.mainInstance().track(event: "Register Screen :- Password Textfield Eye Show Button Clicked")
        }else {
            passwordTf.rightViewMode = UITextFieldViewMode.always
            let image = UIImage(named: "hide")
            passwordTf.isSecureTextEntry = false
            imageView.image = image
            passwordTf.rightView = imageView
            iconClick = true
            Mixpanel.mainInstance().track(event: "Register Screen :- Password Textfield Eye hide Button Clicked")
        }
        
        // Your action
    }
    @objc func eyebtnTapped1(tapGestureRecognizer1: UITapGestureRecognizer)
    {
        if(iconClick == true) {
            ConfirmPwdTf.rightViewMode = UITextFieldViewMode.always
            let image = UIImage(named: "show")
            ConfirmPwdTf.isSecureTextEntry = true
            imageView1.image = image
            ConfirmPwdTf.rightView = imageView1
            iconClick = false
            Mixpanel.mainInstance().track(event: "Register Screen :- Re-Type Password Textfield Eye Show Button Clicked")
            
        }else {
            ConfirmPwdTf.rightViewMode = UITextFieldViewMode.always
            let image = UIImage(named: "hide")
            ConfirmPwdTf.isSecureTextEntry = false
            imageView1.image = image
            ConfirmPwdTf.rightView = imageView1
            iconClick = true
            Mixpanel.mainInstance().track(event: "Register Screen :- Re-Type Password Textfield Eye hide Button Clicked")
        }
    }
    
    @IBAction func checkboxSelected(_ sender: UIButton) {
        if !sender.isSelected{
            print(!sender.isSelected)
            sender.isSelected = !sender.isSelected
            checkBoxSelected = true
            checkBox.setBackgroundImage(UIImage(named: "right"), for: .selected)
            Mixpanel.mainInstance().track(event: "Register Screen :- Terms and Condition Checkbox Ticked")
        }
        else{
            sender.isSelected = !sender.isSelected
            checkBoxSelected = false
            print(sender.isSelected)
            Mixpanel.mainInstance().track(event: "Register Screen :- Terms and Condition Checkbox Unticked")
        }
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        _ = CharacterSet.whitespaces
        Mixpanel.mainInstance().track(event: "Register Screen :- Register Button Clicked")
        if emailIdtf!.text!.isEmpty{
            presentWindow!.makeToast(message: "Please Enter Correct Email Id")
            Mixpanel.mainInstance().track(event: "Register Screen :- Please Enter Correct Email Id")
            //self.navigationController?.view.makeToast("Please Enter Correct Email Id", duration: 3.0, position: .center)
        }
        
        else if !emailIdtf.text!.isValidEmail() {
            
            presentWindow!.makeToast(message: "Please Enter Correct Email Id")
            Mixpanel.mainInstance().track(event: "Register Screen :- Please Enter Correct Email Id")
            //self.navigationController?.view.makeToast("Please Enter Correct Email Id ", duration: 3.0, position: .center)
            
        }
        else if mobileNotf!.text!.characters.count < 10 || mobileNotf!.text!.characters.count > 15{
            presentWindow!.makeToast(message: "Please Enter Correct Mobile No")
            Mixpanel.mainInstance().track(event: "Register Screen :- Please Enter Correct Mobile No")
        }
            
        else if passwordTf.text!.characters.count < 8 || passwordTf!.text!.characters.count > 16{
            if passwordTf!.text!.characters.count > 16{
                Mixpanel.mainInstance().track(event: "Register Screen :- Password Should Maximum 16 Characters Long")
                presentWindow!.makeToast(message: "Password Should Maximum 16 Characters Long")
                
            }else{
                Mixpanel.mainInstance().track(event: "Register Screen :- Password Should Maximum 8 Characters Long")
                presentWindow!.makeToast(message: "Password Should Minimum 8 Characters Long")
                
            }
        }
        else  if passwordTf.text!.contains(" "){
            Mixpanel.mainInstance().track(event: "Register Screen :-Password Should Not Contain Spaces")
            presentWindow!.makeToast(message: "Password Should Not Contain Spaces")
        }
          
        else if passwordTf!.text != ConfirmPwdTf.text!{
            ConfirmPwdTf!.text = ""
            presentWindow!.makeToast(message: "Password Does Not Match Please Validate")
            Mixpanel.mainInstance().track(event: "Register Screen :- Password Does Not Match Please Validate")
            
        }
        else if checkBoxSelected == true {
            print("suc")
            checkcredentials()
        }
        else {
            presentWindow!.makeToast(message: "Please Accpet Terms And Conditions")
            Mixpanel.mainInstance().track(event: "Register Screen :- Please Accpet Terms And Conditions")
        }
    }
    func checkcredentials(){
        //self.navigationController?.view.makeToastActivity(.center)
        presentWindow?.makeToastActivity(message: "Loading...")
        if Connectivity.isConnectedToInternet{
            let parameters = ["mobile" : "\(mobileNotf.text!)","email":"\(emailIdtf.text!)","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
            // print(fourDigit)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.CHECK_CREDENTIALS)", method: .post, parameters: parameters, encoding: JSONEncoding.default) .responseString { response in
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
                print(response.result.value ?? "checkcredentials")
                let data = dict
                print(data)
                if (data as? Any) != nil{
                    //print(data)
                    if let code = data as? NSArray {
                        //print(code)
                        for code in (code.value(forKey: "error") as? NSArray)! {
                            // print(code)
                            let errorcode = code as! String
                            print(errorcode)
                            //self.navigationController?.view.hideToastActivity()
                            if errorcode == Constants.ERROR_CODE_1005  {
                                //self.navigationController?.view.hideToastActivity()
                                self.presentWindow?.hideToastActivity()
                                self.mobileNotf.text = ""
                                self.emailIdtf.text = ""
                                self.presentWindow!.makeToast(message: "Email and Mobile Already Exists")
                                Mixpanel.mainInstance().track(event: "Register Screen :- Email and Mobile Already Exists")
                            }
                            else if errorcode == Constants.ERROR_CODE_1004{
                                self.presentWindow?.hideToastActivity()
                                //self.navigationController?.view.hideToastActivity()
                                self.mobileNotf.text = ""
                                self.presentWindow!.makeToast(message: "Mobile No Already Exists")
                                Mixpanel.mainInstance().track(event: "Register Screen :- Mobile No Already Exists")
                            }
                            else if errorcode == Constants.ERROR_CODE_1003{
                                self.presentWindow?.hideToastActivity()
                                //self.navigationController?.view.hideToastActivity()
                                self.emailIdtf.text = ""
                                self.presentWindow!.makeToast(message: "Email ID Already Exists")
                                Mixpanel.mainInstance().track(event: "Register Screen :- Email ID Already Exists")
                                
                            }
                            else{
                                
                                self.presentWindow?.hideToastActivity()
                                
                                self.send_otp_on_mobile1(mobile_number: ("\(self.mobileNotf.text!)"), msg:  "Greetings from Fintoo! Your OTP Verifaction code is \(fourdigit)",fourDigit:"\(fourdigit)")
                                self.send_otp_on_Email(ToEmailID: "\(self.emailIdtf.text!)", FromEmailID: "support@fintoo.in", Body: "Greetings from Fintoo! Your OTP verification code is \(fourdigit)", Subject: "OTP Verification Code")
                                
                            }
                            
                        }
                    } else{
                        Mixpanel.mainInstance().track(event: "Register Screen :- Something Went Wrong")
                        self.presentWindow?.hideToastActivity()
                        self.presentWindow.makeToast(message: "Something Went Wrong")
                        print("failed")
                    }
                }
            }
            
        }
        else{
            
            presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            Mixpanel.mainInstance().track(event: "Register Screen :- No Internet Connection")
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
       
        if textField == ConfirmPwdTf {
            
            let whitespaceSet = NSCharacterSet.whitespaces
            
            
            let nsString:NSString? = ConfirmPwdTf.text as NSString?
            let updatedString = nsString?.replacingCharacters(in:range, with:string);
            
            ConfirmPwdTf.text = updatedString;
            
            
            //Setting the cursor at the right place
            let selectedRange = NSMakeRange(range.location + string.count, 0)
            let from = ConfirmPwdTf.position(from: ConfirmPwdTf.beginningOfDocument, offset:selectedRange.location)
            let to = ConfirmPwdTf.position(from: from!, offset:selectedRange.length)
            ConfirmPwdTf.selectedTextRange = ConfirmPwdTf.textRange(from: from!, to: to!)
            
            //Sending an action
            ConfirmPwdTf.sendActions(for: UIControlEvents.editingChanged)
            return false
           // return false
        }
        else {
        let whitespaceSet = NSCharacterSet.whitespaces
        
        
        let nsString:NSString? = passwordTf.text as NSString?
        let updatedString = nsString?.replacingCharacters(in:range, with:string);
        
        passwordTf.text = updatedString;
        
        
        //Setting the cursor at the right place
        let selectedRange = NSMakeRange(range.location + string.count, 0)
        let from = passwordTf.position(from: passwordTf.beginningOfDocument, offset:selectedRange.location)
        let to = passwordTf.position(from: from!, offset:selectedRange.length)
        passwordTf.selectedTextRange = passwordTf.textRange(from: from!, to: to!)
        
        //Sending an action
        passwordTf.sendActions(for: UIControlEvents.editingChanged)
        return false
        }
        
    }
    

    func send_otp_on_mobile1(mobile_number:String,msg:String,fourDigit:String){
        if Connectivity.isConnectedToInternet{
            let parameters = ["mobile" : "\(mobile_number.covertToBase64())","msg" : "\(msg.covertToBase64())","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
            print(parameters)
            print(fourDigit)
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_SMS_OTP)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
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
                                    
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)

                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "OTPScreenViewController") as! OTPScreenViewController
                                    destVC.toOTP = fourDigit
                                    destVC.id = "2"
                                    //destVC.id = "1"

                                    //destVC.idu = self.idu
                                    destVC.toemail = self.emailIdtf.text!
                                    destVC.tophone = self.mobileNotf.text!
                                    //destVC.toprofile = self.profile
                                    destVC.topassword = self.passwordTf.text!
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
             Mixpanel.mainInstance().track(event: "Register Screen :- Internet Connection not Available")
            presentWindow?.makeToast(message: "Internet Connection not Available")
            // self.navigationController?.view.makeToast("Internet Connection not Available!", duration: 3.0, position: .center)
        }
    }
    @IBAction func termsCondition(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Register Screen :- Terms & Condition Button Clicked")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "TermsConditionViewController") as! TermsConditionViewController
       // destVC.id = "12"
        print(destVC.id)
        let navController = UINavigationController(rootViewController: destVC)
        self.present(navController, animated:true, completion: nil)
        
    }
}
var fourDigitNumber: String {
    var result = ""
    repeat {
        //Create a string with a random number 0...9999
        //
        result = String(format:"%05d", arc4random_uniform(10000) )
    } while Set<Character>(result.characters).count < 5
    return result
}

