//
//  ChangePasswordViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 20/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class ChangePasswordViewController: BaseViewController,UITextFieldDelegate {
    var toid : String!
    var toemail : String!
    var tophone : String!
    
    @IBOutlet weak var newpasswordtf: UITextField!
    
    @IBOutlet weak var cfpasswordtf: UITextField!
    
    @IBOutlet weak var oldpasswordtf: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWhiteNavigationBar()
        addBackbutton()
        newpasswordtf.delegate = self
        cfpasswordtf.delegate = self
        presentWindow = UIApplication.shared.keyWindow
        //self.title = "Password Reset"
        if toid == "1"{
            oldpasswordtf.isHidden = false
            self.title = "CHANGE PASSWORD"
           // CHANGE PASSWORD
            
        }
        else{
            oldpasswordtf.isHidden = true
            self.title = "PASSWORD RESET"
        }
        
        // Do any additional setup after loading the view.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Mobile Number Screen :- Back Button Clicked")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func Submitbtn(_ sender: Any) {
         //print(OldPassword(oldpasswordtf.text!))
         Mixpanel.mainInstance().track(event: "Password Screen :- Submit Button Clicked")
         if toid == "1"{
            if oldpasswordtf.text!.isEmpty{
                presentWindow?.makeToast(message:"Old Password Should Minimum 8 Characters Long")
            }
            else if (oldpasswordtf.text?.count)! < 8{
                presentWindow?.makeToast(message:"Old Password Should Minimum 8 Characters Long")
                oldpasswordtf.text = ""
                
                
            }
            else if newpasswordtf.text!.isEmpty{
                presentWindow?.makeToast(message:"New Password Should Minimum 8 Characters Long")
               
            }
            else if (newpasswordtf.text?.count)! < 8{
                presentWindow?.makeToast(message:"New Password Should Minimum 8 Characters Long")
                newpasswordtf.text = ""
              
                
            }
            else if newpasswordtf.text == oldpasswordtf.text{
                presentWindow?.makeToast(message:"New Password Can Not Be Same As Old Password")
                newpasswordtf.text = ""
                cfpasswordtf.text = ""
            }
            else if cfpasswordtf.text!.isEmpty{
                presentWindow?.makeToast(message:"Password Does Not Match")
               // Mixpanel.mainInstance().track(event: "NewPassword Screen :- Password Should Minimum
            }
            else if newpasswordtf.text != cfpasswordtf.text{
                presentWindow?.makeToast(message:"Password Does Not Match")
                
                cfpasswordtf.text = ""
                
                
            }
            else{
                if toid == "1"{
                    let c_id = UserDefaults.standard.value(forKey: Constants.User_Defaults.USER_ID)
                    OldPassword(id:"\(c_id!)",OLD_PWD: "\(oldpasswordtf.text!)")
                }
                else{
                
                 reset_password()
                }
            }
        }
         else{
            if newpasswordtf.text!.isEmpty{
                presentWindow?.makeToast(message:"New Password Should Minimum 8 Characters Long")
                 Mixpanel.mainInstance().track(event: "Mobile Number Screen :- New Password Should Minimum 8 Characters Long")
            }
            else if (newpasswordtf.text?.count)! < 8{
                presentWindow?.makeToast(message:"New Password Should Minimum 8 Characters Long")
                newpasswordtf.text = ""
                Mixpanel.mainInstance().track(event: "Mobile Number Screen :- New Password Should Minimum 8 Characters Long")
                
            }
            else if newpasswordtf.text == oldpasswordtf.text{
                presentWindow?.makeToast(message:"New Password Can Not Be Same As Old Password")
                Mixpanel.mainInstance().track(event: "Mobile Number Screen :- New Password Can Not Be Same As Old Password")
                newpasswordtf.text = ""
                cfpasswordtf.text = ""
            }
            else if cfpasswordtf.text!.isEmpty{
                presentWindow?.makeToast(message:"Password Does Not Match")
                Mixpanel.mainInstance().track(event: "Mobile Number Screen :- Password Does Not Match")
                // Mixpanel.mainInstance().track(event: "NewPassword Screen :- Password Should Minimum
            }
            else if newpasswordtf.text != cfpasswordtf.text{
                presentWindow?.makeToast(message:"Password Does Not Match")
                Mixpanel.mainInstance().track(event: "Mobile Number Screen :- Password Does Not Match")
                cfpasswordtf.text = ""
             }
            else{
                reset_password()
            }
        }
    }
    func reset_password(){
        presentWindow?.makeToastActivity(message: "Updating..")
        var parameters = [String:Any]()
        if tophone != "" {
            parameters = ["email" : "\(tophone!.covertToBase64())","password":"\(newpasswordtf.text!.covertToBase64())","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
        }else {
            parameters = ["email" : "\(toemail!.covertToBase64())","password":"\(newpasswordtf.text!.covertToBase64())","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
        }
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.RESET_PASSWORD)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = ""
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = enc
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    print(response.result.value ?? " ")
                    let data = dict
                    print(data," data")
                    //let data = response.result.value as! String
                    print(data)
                    if data == "\"true\""{
                        if self.toid == "1"{
                            self.presentWindow?.hideToastActivity()
                            //presentWindow?.makeToast(message:"Password Updated Successfully")
                            self.navigationController?.popViewController(animated: true)
                        }
                        else{
                            self.presentWindow?.hideToastActivity()
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            self.present(destVC, animated:true, completion: nil)
                        }
                        //self.navigationController?.pushViewController(destVC, animated: true)
                        
                    }
                    else{
                        self.presentWindow?.hideToastActivity()
                        self.presentWindow?.makeToast(message:"Please try again after some time")
                        
                        
                    }
            }
            
        }
        else{
            presentWindow?.makeToast(message: "Internet Connection not Available!")
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == newpasswordtf {
            
           // let whitespaceSet = NSCharacterSet.whitespaces
            
            
            let nsString:NSString? = newpasswordtf.text as NSString?
            let updatedString = nsString?.replacingCharacters(in:range, with:string);
            
            newpasswordtf.text = updatedString;
            
            
            //Setting the cursor at the right place
            let selectedRange = NSMakeRange(range.location + string.count, 0)
            let from = newpasswordtf.position(from: newpasswordtf.beginningOfDocument, offset:selectedRange.location)
            let to = newpasswordtf.position(from: from!, offset:selectedRange.length)
            newpasswordtf.selectedTextRange = newpasswordtf.textRange(from: from!, to: to!)
            
            //Sending an action
            newpasswordtf.sendActions(for: UIControlEvents.editingChanged)
            return false
            // return false
        }
        else {
           // let whitespaceSet = NSCharacterSet.whitespaces
            
            
            let nsString:NSString? = cfpasswordtf.text as NSString?
            let updatedString = nsString?.replacingCharacters(in:range, with:string);
            
            cfpasswordtf.text = updatedString;
            
            
            //Setting the cursor at the right place
            let selectedRange = NSMakeRange(range.location + string.count, 0)
            let from = cfpasswordtf.position(from: cfpasswordtf.beginningOfDocument, offset:selectedRange.location)
            let to = cfpasswordtf.position(from: from!, offset:selectedRange.length)
            cfpasswordtf.selectedTextRange = cfpasswordtf.textRange(from: from!, to: to!)
            
            //Sending an action
            cfpasswordtf.sendActions(for: UIControlEvents.editingChanged)
            return false
        }
        //return false
        
    }
    func OldPassword(id:String,OLD_PWD: String) {
        let c_id = UserDefaults.standard.value(forKey: Constants.User_Defaults.USER_ID)
        presentWindow?.makeToastActivity(message: "Changing..")
        let parameters = [ "oldpassword":OLD_PWD]
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.CHECK_FOR_OLD_PWD)\(c_id!)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    let data = response.result.value as! String
                    print(data)
                    if data == "true"{
                        self.presentWindow?.hideToastActivity()
                        
                        
                        self.update_new_pwd(id: id, new_pwd: "\(self.newpasswordtf.text!)")
                        
                        //self.navigationController?.pushViewController(destVC, animated: true)
                        
                    }
                    else{
                        self.presentWindow?.hideToastActivity()
                        self.oldpasswordtf.text = ""
                        
                       self.presentWindow?.makeToast(message:"\(response.result.value!)")
                        
                        
                    }
            }
            
        }
        else{
            presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "Internet Connection not Available!")
        }
        
    }
    func update_new_pwd(id:String,new_pwd:String){
        
        let parameters = [ "id":id,"newpassword":new_pwd]
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.CHANGE_PASSWORD_UPDATE)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                   // let data = response.result.value
                    let data = response.result.value as? Int
                    if data == 1{
                        self.presentWindow?.makeToast(message: "Password Updated Successfully")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                    else{
                        self.presentWindow?.makeToast(message: "Something Went Wrong")
                    }
                    
            }
            
        }
        else{
            //presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "Internet Connection not Available!")
        }
    }
    

}
