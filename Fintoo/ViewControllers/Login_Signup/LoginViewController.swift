//
//  LoginViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 09/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class LoginViewController: BaseViewController,UITextFieldDelegate {

    
    @IBOutlet weak var tfMobileNo: UITextField!
    
    @IBOutlet weak var pwdTf: UITextField!
    
    //var l_id : Int!
    var notification_kill = [AnyHashable : Any]()
    var id  = ""
    var iconClick : Bool!
    let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 15))
    var PresentWindows = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        PresentWindows = self.view
        pwdTf.delegate = self
        pwdTf.leftViewMode = UITextFieldViewMode.always
        imageView.contentMode = .scaleAspectFit
        let image = UIImage(named: "show")
        
        imageView.image = image
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: pwdTf.frame.height))
        paddingView.addSubview(imageView)
        imageView.center = paddingView.center
        pwdTf.leftView = paddingView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(eyebtnTapped(tapGestureRecognizer:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGestureRecognizer)
    }
    //pwd field
    @objc func eyebtnTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if(iconClick == true) {
            pwdTf.leftViewMode = UITextFieldViewMode.always
            let image = UIImage(named: "show")
            pwdTf.isSecureTextEntry = true
            imageView.image = image
            iconClick = false
            Mixpanel.mainInstance().track(event: "Login Screen :- Eye Show Button Clicked")
        }else {
            pwdTf.leftViewMode = UITextFieldViewMode.always
            let image = UIImage(named: "hide")
            pwdTf.isSecureTextEntry = false
            imageView.image = image
            iconClick = true
            Mixpanel.mainInstance().track(event: "Login Screen :- Eye Hide Button Clicked")
        }
        
        
        // Your action
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == pwdTf {
            
            _ = NSCharacterSet.whitespaces
            
            
            let nsString:NSString? = pwdTf.text as NSString?
            let updatedString = nsString?.replacingCharacters(in:range, with:string);
            
            pwdTf.text = updatedString;
            
            
            //Setting the cursor at the right place
            let selectedRange = NSMakeRange(range.location + string.count, 0)
            let from = pwdTf.position(from: pwdTf.beginningOfDocument, offset:selectedRange.location)
            let to = pwdTf.position(from: from!, offset:selectedRange.length)
            pwdTf.selectedTextRange = pwdTf.textRange(from: from!, to: to!)
            
            //Sending an action
            pwdTf.sendActions(for: UIControlEvents.editingChanged)
            return false
            // return false
        }
        return true
    }
    @IBAction func loginButtonTap(_ sender: Any) {
        //if
        _ = tfMobileNo.resignFirstResponder()
        _ = pwdTf.resignFirstResponder()
        
        if tfMobileNo.text == "" {
            PresentWindows.makeToast(message: "Please Enter A Valid Email/Mobile")
            Mixpanel.mainInstance().track(event: "Login Screen :- Please Enter A Valid Email/Mobile")
        }
        else if self.pwdTf.text!.isEmpty {
            self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
            Mixpanel.mainInstance().track(event: "Login Screen :- Please Enter A Valid Password")
        }else if Connectivity.isConnectedToInternet {
            self.view.makeToastActivity(message: "Loading..")
            print("Yes! internet is available.")
            let email_enc = "\(tfMobileNo.text!)"
            let pwd_enc = "\(pwdTf.text!)"
            let parameters_enc = ["email" : "\(email_enc.covertToBase64())","password" : "\(pwd_enc.covertToBase64())","enc_resp": "M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
            let parameters = ["email" : "\(tfMobileNo.text!)","password" : "\(pwdTf.text!)"]
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.LOGIN_API)", method: .post, parameters: parameters_enc, encoding: JSONEncoding.default)
                    .responseString { response in
                        let enc_response = response.result.value
                        var dict = [Dictionary<String,Any>]()
                        let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                        if let enc = enc1?.base64Decoded() {
                             dict = self.convertToDictionary(text: enc)
                        } else{
                            self.PresentWindows.hideToastActivity()
                        }
                            let data = dict
                                if self.tfMobileNo.text!.isEmpty {
                                    self.PresentWindows.hideToastActivity()
                                    self.PresentWindows.makeToast(message: "Please Enter A Valid Email/Mobile")
                                    Mixpanel.mainInstance().track(event: "Login Screen :- Please Enter A Valid Email/Mobile")
                                    
                                }
                                else if self.pwdTf.text!.isEmpty{
                                    self.PresentWindows.hideToastActivity()
                                    self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                                    Mixpanel.mainInstance().track(event: "Login Screen :- Please Enter A Valid Password")
                            }
                            if let code = data as? NSArray {
                                
                                for code in (code.value(forKey: "error") as? NSArray)! {
                                    // print(code)
                                    let errorcode = code as! String
                                    print(errorcode)
                                    self.PresentWindows.hideToastActivity()
                                    if errorcode == Constants.ERROR_CODE_1001 {
                                        
                                        self.PresentWindows.makeToast(message: "Please Enter A Valid Email/Mobile")
                                        Mixpanel.mainInstance().track(event: "Login Screen :- Please Enter A Valid Email/Mobile")
                                    }
                                    else if errorcode == Constants.ERROR_CODE_1002 {
                                        self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                                         Mixpanel.mainInstance().track(event: "Login Screen :- Please Enter A Valid Password")
                                       
                                    }
                                    else {
                                        self.PresentWindows.hideToastActivity()
                                        let data = dict
                                        if let code = data as? [Dictionary<String,Any>] {
                                            
                                            for c in code {
                                                let mobile = (c as AnyObject).value(forKey: "mobile") as? String
                                                let idu = (c as AnyObject).value(forKey: "id") as? String
                                                
                                                let email = (c as AnyObject).value(forKey: "email") as? String
                                                let profile = (c as AnyObject).value(forKey: "profile") as? String
                                                let pan = (c as AnyObject).value(forKey: "pan") as? String
                                                
                                                if mobile == ""{
                                                    
                                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                    let destVC = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllers.MOBILE_NUMBER_VIEW_CONTROLLER) as! MobileNumberViewController
                                                    
                                                    let navController = UINavigationController(rootViewController: destVC)
                                                    destVC.idu = idu
                                                    destVC.email = email!
                                                    destVC.mobileNumber = mobile!
                                                    destVC.profile = profile!
                                                    UserDefaults.standard.setValue(idu!, forKey: Constants.User_Defaults.USER_ID)
                                                    UserDefaults.standard.setValue(idu!, forKey: "parent_user_id")
                                                    UserDefaults.standard.setValue(pan!, forKey: "parent_pan")
                                                    self.present(navController, animated:true, completion: nil)
                                                    

                                                }
                                                else{
                                                    
                                                    print("PAN Number")
                                                    UserDefaults.standard.setValue(mobile!, forKey: Constants.User_Defaults.MOBILE_NUMBER)
                                                    UserDefaults.standard.setValue(profile!, forKey: Constants.User_Defaults.PROFILE_IMG)
                                                    UserDefaults.standard.setValue(idu!, forKey: Constants.User_Defaults.USER_ID)
                                                    UserDefaults.standard.setValue(idu!, forKey: "parent_user_id")
                                                    UserDefaults.standard.setValue(pan!, forKey: "parent_pan")
                                                    Mixpanel.mainInstance().track(event: "Login Screen :- Login Successfully For this \(idu!) ")
                                                    Mixpanel.mainInstance().identify(distinctId: idu!)
                                                    Mixpanel.mainInstance().people.set(property: "Email",
                                                                                       to: "\(email!)")
                                                    Mixpanel.mainInstance().people.set(property: "Mobile",
                                                                                       to: "\(mobile!)")
                                                    flag = idu!
                                                    //parent_user_id
                                                    UserDefaults.standard.setValue(email!, forKey: Constants.User_Defaults.EMAIL)
                                                    UserDefaults.standard.set(true, forKey: Constants.User_Defaults.USER_LOGIN)
                                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                                    
                                                    let destVC = storyBoard.instantiateViewController(withIdentifier: Constants.ViewControllers.LANDING_PAGE) as! ViewController
                                                    let navController = UINavigationController(rootViewController: destVC)
                                                    destVC.id  = self.id
                                                    destVC.notification_kill = self.notification_kill
                                                    self.present(navController, animated:true, completion: nil)
                                                    //self.present(destVC, animated:true, completion:nil)
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                               self.PresentWindows.hideToastActivity()
                               self.PresentWindows.makeToast(message: "Something Went Wrong")
                                print("failed")
                            }
                        
                }
            }
        
        else{
             self.PresentWindows.hideToastActivity()
            PresentWindows.makeToast(message: "No Internet Connection")
        }
        
        
        
    }
    @IBAction func signupBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Login Screen :- New User? Signup Button Clicked")
    }
    @IBAction func forgotPwdBtn(_ sender: Any) {
         Mixpanel.mainInstance().track(event: "Login Screen :- Forgot Password Button Clicked")
    }
    
}
