
//
//  AddMemberViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 05/04/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import FileBrowser
import Alamofire
import Mixpanel
class AddMemberViewController: BaseViewController,UIDocumentPickerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/-"
    let ACCEPTABLE_CHARACTERS1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    @IBOutlet weak var fname: UITextField!
    
    @IBOutlet weak var pantf: UITextField!
    @IBOutlet weak var uploadpantf: UITextField!
    var base_64_string : String!
    var extensions : String!
    var userDataArr = [UserDataObj]()
    var id = "0"
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        getUserData()
        pantf.delegate = self
        fname.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction func save(_ sender: Any) {
        let boolean = validatePancard(pantf.text!)
        print(boolean)
        if fname.text!.isEmpty{
            presentWindow?.makeToast(message: "Please Enter First Name")
            Mixpanel.mainInstance().track(event: "Add Member Screen :- Please Enter First Name")
        }
        else if pantf.text!.isEmpty{
            presentWindow?.makeToast(message: "Please Enter Valid PAN No")
            Mixpanel.mainInstance().track(event: "Add Member Screen :- Please Enter Valid PAN No")
        }
        else if boolean != true {
            presentWindow?.makeToast(message: "Please Enter Valid PAN No")
            Mixpanel.mainInstance().track(event: "Add Member Screen :- Please Enter Valid PAN No")
        }
        else if uploadpantf.text!.isEmpty {
            presentWindow?.makeToast(message: "Please Upload PAN")
            Mixpanel.mainInstance().track(event: "Add Member Screen :- Please Upload PAN")
        }
        else {
            print("hello")
            CheckPan()
            // let userid = UserDefaults.standard.value(forKey: "userid") as? String
            //validatepan(id:userid!,pan: pancardtf.text!)
        }
    }
    func validatePancard(_ candidate: String) -> Bool {
        let panCardRegex = "[A-Z]{3}[PH][A-Z]{1}[0-9]{4}[A-Z]{1}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", panCardRegex)
        return emailTest.evaluate(with: candidate)
    }
    @IBAction func uploadFile(_ sender: Any) {
       uploadDoc()
        Mixpanel.mainInstance().track(event: "Add Member Screen :- Upload File Button Clicked")
    }
    
    func uploadDoc(){
        let documentPicker = UIDocumentPickerViewController(documentTypes:["public.image", "public.composite-content", "public.text"], in: .import)
        
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
       // Mixpanel.mainInstance().track(event: "Chat Screen:- \(self.service!) Document Selected")
    }
  
    
    // MARK:- UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
       
        print("@@@@@@@@@@@@\(url)","@@@@@@@@@@@")
        let file = "\(url)"
        _  = NSData(contentsOfFile: file)
        let fileNameWithoutExtension = file.fileName()
        let fileExtension = file.fileExtension()
        print(fileNameWithoutExtension)
        print(fileExtension)
        //uploadpantf.text = fileNameWithoutExtension
       // Allowed file types are jpg, jpeg, png, pdf, tiff)
        if fileExtension == "jpg" || fileExtension == "JPG" || fileExtension == "pdf" || fileExtension == "PDF" || fileExtension == "jpeg" || fileExtension == "JPEG" || fileExtension == "png" || fileExtension == "PNG" || fileExtension == "tiff" || fileExtension == "TIFF" {
            uploadpantf.text = fileNameWithoutExtension
            do {
            let data = try Data(contentsOf: url)
            let base64str = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            base_64_string = base64str
            extensions = fileExtension
            
            }
            catch{
                print(error)
            }
           // self.imageView.image = UIImage(data: data)
            
        }
        else{
            presentWindow.makeToast(message: "Invalid file type (Allowed file types are jpg, jpeg, png, pdf, tiff)")
            Mixpanel.mainInstance().track(event: "Add Member Screen :- Invalid file type (Allowed file types are jpg, jpeg, png, pdf, tiff)")
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        Mixpanel.mainInstance().track(event: "Add Member Screen :- Document Picker Cancel Button Clicked")
        uploadpantf.text = ""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == pantf{
            let lowercaseCharRange: NSRange = (string as NSString).rangeOfCharacter(from: CharacterSet.lowercaseLetters)
            if lowercaseCharRange.location != NSNotFound {
                textField.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string.uppercased())
                return false
            }
        } else if textField == fname {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS1).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        return true
    }
    func CheckPan(){
        //http://www.erokda.in/adminpanel/users/user_ws.php/checkparentpan?exclude=1&id=117340&p=1&pan=CUOPM1603B
       // adminpanel/users/user_ws.php/checkparentpan?exclude=1&id=userid&p=&n=1
        //let userid = UserDefaults.standard.value(forKey: "userid")
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let p = ""
        let url = "\(Constants.BASE_URL)\(Constants.API.checkparentpan)\(userid!)&p=\(p)&pan=\(pantf.text!)&n=1"
        print(url)
        presentWindow.makeToastActivity(message: "Saving..")
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value!)
                let data = response.result.value
                if data as! String == "true"{
                    print("validate pan")
                    print(userid)
                    print(self.pantf.text)
                    //let userid = UserDefaults.standard.value(forKey: "userid") as? String
                    self.validatepan(id:userid ?? "",pan: self.pantf.text!)
                    
                }
                else{
                    self.presentWindow.hideToastActivity()
                    let refreshAlert = UIAlertController(title: "", message: "It seems your main account already has '\(self.pantf.text!)' associated.\n You might want to \n\u{2022} Enter another PAN \n\u{2022} Check your main account to see where you have associated this PAN \n\u{2022} If there is any confusion regarding this, please contact our support at +91-9699 800600", preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        refreshAlert.dismiss(animated: true, completion: nil)
                        Mixpanel.mainInstance().track(event: "Add Member Screen :-Ok Button Clicked")
                    }))
 
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                    print("show alert")
                }
                
                
            }
        }
        
            
        else{
            self.presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
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
                                let p_uid = (c as AnyObject).value(forKey: "id") as? String
                                let p_email = (c as AnyObject).value(forKey: "email") as? String
                                let p_phone = (c as AnyObject).value(forKey: "mobile") as? String
                                // print(p_phone)
                                let p_response = (c as AnyObject).value(forKey: "response") as? String
                                if p_response == "true"{
                                    _ = UserDefaults.standard.value(forKey: "userid") as? String
                                    self.addMember()
                                    //self.update_PAN(p_id: p_uid!, c_id: c_id!, pan: self.pancardtf.text!)
                                }
                                else{
                                    self.presentWindow.hideToastActivity()
                                    print("panAlertViewController")
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "PanAlertViewController") as! PanAlertViewController
                                    destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                                    destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                                    destVC.topan = self.pantf.text!
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
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func addMember(){
       // let p_id = UserDefaults.standard.value(forKey: "userid") as? String
        var p_id = UserDefaults.standard.value(forKey: "parent_user_id")
//        if flag != "0"{
//            p_id = flag
//        } else{
//            p_id = UserDefaults.standard.value(forKey: "userid")
//        }
        if Connectivity.isConnectedToInternet{
            let parameters = ["pid":"\(p_id ?? "")",
                "id":"",
                "name":"\(fname.text!)",
                "middle_name":"",
                "last_name":"",
                "email":"",
                "mobile":"",
                "landline":"",
                "pan":"\(pantf.text!)",
                "flat_no":"",
                "building_name":"",
                "road_street":"",
                "address":"",
                "dob":"",
                "gender":"",
                "country":"",
                "state":"",
                "city":"",
                "pincode":"",
                "salutation":"",
                "spouse_name":"",
                "guardian_name":"",
                "relation":"",
                "guardian_relation":"",
                "occupation":"",
                "income_slab":"",
                "residential_status":"",
                "user_location":"",
                "user_tax_status":"",
                "source":1,
                "medium":26,
                "updateid":""
                
                ] as [String : Any]
            
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.Add_Member)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    _ = response.result.value
                    self.sendsmsotp()
                    self.sendEmailToUser()
                    self.uplodDoc(doc_value: self.base_64_string, doc_ext: self.extensions)
         }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func sendsmsotp(){
        let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "mobile":"\(phone!)",
                "msg":"You have added \(fname.text!) as a family member to your Fintoo Account successfully. Go ahead and complete his profile to start investing on his/her behalf.For any urgent query, call us directly on +91-9699 800600"
                ]
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_SMS_OTP)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value ?? "")
                    let data = response.result.value
                    if let code = data as? NSArray {
                        //print(code)
                        for code in (code.value(forKey: "code") as? NSArray)! {
                            print(code)
                            let msg_code = String(code as! Int)
                            if msg_code != Constants.ERROR_CODE_1701{
                                self.presentWindow!.makeToast(message: "Failed To Send Message On Mobile")
                            }
                            else{
                                print("send message")
                            }
                        }
                    }
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func sendEmailToSupport(){
        let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "ToEmailID":"support@fintoo.in",
                "FromEmailID":"",
                "Subject" :"\(email!) has added a new member !",
                "template_name": "member_approval_request",
                "email":"\(email!)",
                "membername":"\(fname.text!)"
                
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.templates)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value ?? "")
                    let data = response.result.value
                    if (data as? Any) != nil{
                        //print(data)
                        if let code = data as? NSArray {
                            //print(code)
                            for code in (code.value(forKey: "error") as? NSArray)! {
                                // print(code)
                                let email_code = code as! String
                                print(email_code)
                                if email_code != ""{
                                    // self.presentWindow?.makeToast(message: "Failed To Sent Email")
                                    print("Failed To Sent Email")
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
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func sendEmailToUser(){
        //let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        let email = UserDefaults.standard.value(forKey: "Email") as? String
        
        if Connectivity.isConnectedToInternet{
            let fname1 = userDataArr[0].fname
            var str = ""
            if fname1 != "" {
                str = fname1 ?? email!
            }else {
                str = email!
            }
            let parameters = ["ToEmailID":"\(email!)",
                "FromEmailID":"",
                "Subject":"Member Added Successfully - Fintoo !",
                "template_name": "member_added",
                "username":"\(str)",
                "membername":"\(fname.text!)"
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.templates)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value ?? "")
                    let data = response.result.value
                    if (data as? Any) != nil{
                        //print(data)
                        if let code = data as? NSArray {
                            //print(code)
                            for code in (code.value(forKey: "error") as? NSArray)! {
                                // print(code)
                                let email_code = code as! String
                                print(email_code)
                                if email_code != ""{
                                   // self.presentWindow?.makeToast(message: "Failed To Sent Email")
                                    print("Failed To Sent Email")
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
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "parent_user_id")
        print(userid)
        
       
        //presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //self.presentWindow.hideToastActivity()
                let data = response.result.value
                if data != nil{
                    print(data)
                    
                    if let dataArray = data as? NSArray{
                        // print(dataArray)
                        //print(dataArray.value(forKey: "name"))
                        for abc in dataArray{
                            
                            let salutations = (abc as AnyObject).value(forKey: "salutation") as? String
                            let fname = (abc as AnyObject).value(forKey: "name") as? String
                            let mname = (abc as AnyObject).value(forKey: "middle_name") as? String
                            let lname =  (abc as AnyObject).value(forKey: "last_name") as? String
                            let gender1 = (abc as AnyObject).value(forKey: "gender") as? String
                            let dob = (abc as AnyObject).value(forKey: "dob") as? String
                            let mobile = (abc as AnyObject).value(forKey: "mobile") as? String
                            let landline = (abc as AnyObject).value(forKey: "landline") as? String
                            let email = (abc as AnyObject).value(forKey: "email") as? String
                            //let aadhar = (abc as AnyObject).value(forKey: "dob") as? String
                            let pan = (abc as AnyObject).value(forKey: "pan") as? String
                            let flat_no = (abc as AnyObject).value(forKey: "flat_no") as? String
                            let building_name = (abc as AnyObject).value(forKey: "building_name") as? String
                            let road_street = (abc as AnyObject).value(forKey: "road_street") as? String
                            let address = (abc as AnyObject).value(forKey: "address") as? String
                            let country = (abc as AnyObject).value(forKey: "country") as? String
                            let state =  (abc as AnyObject).value(forKey: "state") as? String
                            let city = (abc as AnyObject).value(forKey: "city") as? String
                            let pincode = (abc as AnyObject).value(forKey: "pincode") as? String
                            let occupation = (abc as AnyObject).value(forKey: "occupation") as? String
                            let location = (abc as AnyObject).value(forKey: "user_location") as? String
                            let marital_status = (abc as AnyObject).value(forKey: "marital_status") as? String
                            let spouse_name = (abc as AnyObject).value(forKey: "spouse_name") as? String
                            let residential_status = (abc as AnyObject).value(forKey: "residential_status") as? String
                            let user_tax_status = (abc as AnyObject).value(forKey: "user_tax_status") as? String
                            let income_slab = (abc as AnyObject).value(forKey: "income_slab") as? String
                            let income_slab_id = (abc as AnyObject).value(forKey: "IncomeSlabID") as? String
                            print(location)
                            
                            self.userDataArr.append(UserDataObj.getUserData(salutation: salutations!, fname: fname!, mname: mname!, lname: lname!, gender: gender1!, dob: dob!, mobile: mobile!, landline: landline!, email: email!, aadhar: "", pan: pan!, flat_no: flat_no!, building_name: building_name!, road_street: road_street!, address: address!, Country: country!, State:state!, City: city!, pincode:pincode!, occupation: occupation!, location: location!, marital_status: marital_status!, spouse_name: spouse_name!, residential_status: residential_status!, user_tax_status: user_tax_status!, tax_slab: income_slab ?? "", IncomeSlabID: income_slab_id ?? ""))
                            self.presentWindow.hideToastActivity()
                            
                            
                        }
                        
                    }
                }
                
            }
        }
            
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    func uplodDoc(doc_value:String,doc_ext:String){
         let user_id = UserDefaults.standard.value(forKey: "userid")
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "doc_value":"\(doc_value)",
                "user_id":"\(user_id!)",
                "doc_ext":"\(doc_ext)"
            ]
            print(parameters)
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.uploadDoc)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value ?? "")
                    print("@@@@@")
                    let data = response.result.value
                    if let code = data as? NSArray {
                        for code in (code.value(forKey: "error") as? NSArray)! {
                            let error_code = code as! String
                            if error_code == ""{
                                print("Success")
                                self.presentWindow.makeToast(message: "Member Added Successfully")
                                self.presentWindow.hideToastActivity()
                                if self.id != "1"{
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                                    //  let navController = UINavigationController(rootViewController: destVC)
                                    self.navigationController?.pushViewController(destVC, animated: true)
                                } else {
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "NomineesViewController") as! NomineesViewController
                                    self.navigationController?.pushViewController(destVC, animated: true)
                                }
                            }
                            else{
                                print("Failed")
                                self.presentWindow.hideToastActivity()
                                self.presentWindow?.makeToast(message: "Something Went wrong!")
                            }
                        }
                    }
                    
                    
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
}
