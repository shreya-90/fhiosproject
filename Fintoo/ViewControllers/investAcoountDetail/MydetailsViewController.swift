//
//  MydetailsViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 09/04/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import  Alamofire
import Mixpanel
class MydetailsViewController: BaseViewController,FlexibleSteppedProgressBarDelegate ,UITextFieldDelegate{
    
    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    var progressColor = UIColor(red: 45.0 / 255.0, green: 180.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
     var bgcolor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    var maxIndex = -1
    var arrUserData = [MyDetailObj]()
    var gender = ""
    var salutation = ""
    var datePicker = UIDatePicker()
    var p_final : String!
    var s_final : String!
    var checkpan : String!
    var checkaadhar : String!
    var aadhar_kyc_id : String!
    var userDataArr = [UserDataObj]()
    var fatcaArr = [FatcaObj]()
    var kycDataArr = [AddKycObj]()
    var fatca_detail_flag = false
    var personal_details_alert = false
    @IBOutlet weak var mrOutlet: UIButton!
    
    @IBOutlet weak var msOutlet: UIButton!
    
    @IBOutlet weak var mrsOutlet: UIButton!
    
    @IBOutlet weak var maleOutlet: UIButton!
    
    @IBOutlet weak var femaleOutlet: UIButton!
    
    @IBOutlet weak var otherOutlet: UIButton!
    
    @IBOutlet weak var fnametf: UITextField!
    
    @IBOutlet weak var mnametf: UITextField!
    
    @IBOutlet weak var lnametf: UITextField!
    
    @IBOutlet weak var dobtf: UITextField!
    
    @IBOutlet weak var mobiletf: UITextField!
    @IBOutlet weak var landlinetf: UITextField!
    
    @IBOutlet weak var emailtf: UITextField!
    
    @IBOutlet weak var aadhartf: UITextField!
    @IBOutlet weak var pantf: UITextField!
    
    //var progressBar: FlexibleSteppedProgressBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        fnametf.delegate = self
        mnametf.delegate = self
        lnametf.delegate = self
        dobtf.delegate = self
        pantf.delegate = self
        getUserData()
        getaadhar()
        getUserFatcaDetails()
        addBackbutton()
        setWhiteNavigationBar()
       progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        // Customise the progress bar here
        progressBar.numberOfPoints = 5
       // progressBar.heightAnchor.constraint(equalToConstant: 100)
        progressBar.lineHeight = 6
        progressBar.radius = 10
        progressBar.progressRadius = 10
        progressBar.progressLineHeight = 3
        progressBar.backgroundColor = bgcolor
        progressBar.delegate = self
       // progressBar.completedTillIndex = 1
        progressBar.useLastState = true
        
        progressBar.lastStateCenterColor = progressColor
        progressBar.selectedBackgoundColor = progressColor
    
        progressBar.selectedOuterCircleStrokeColor = backgroundColor
        progressBar.lastStateOuterCircleStrokeColor = backgroundColor
        progressBar.currentSelectedCenterColor = progressColor
        progressBar.currentSelectedTextColor = progressColor
        progressBar.stepTextColor = textColorHere
        progressBar.currentIndex = 0
       // arrUserData.f

        // Do any additional setup after loading the view.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Back Button Clicked")
        navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        progressBar.currentIndex = index
        if index > maxIndex {
            maxIndex = index
            progressBar.completedTillIndex = maxIndex
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == self.progressBar  {
            if position == FlexibleSteppedProgressBarTextLocation.top {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                case 4: return ""
                default: return ""
                    
                }
            } else if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                case 4: return ""
                default: return ""
                    
                }
                
            } else if position == FlexibleSteppedProgressBarTextLocation.center {
                switch index {
                    
                case 0: return "1"
                case 1: return "2"
                case 2: return "3"
                case 3: return "4"
                case 4: return "5"
                default: return ""
                    
                }
            }
        }
        
        return ""
    }
    
    @IBAction func mr(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Mr. Button Clicked")
        mrOutlet.setImage(UIImage(named: "check"), for: .normal)
        msOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        mrsOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        salutation = "Mr."
    }
    
    @IBAction func ms(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Ms. Button Clicked")
         msOutlet.setImage(UIImage(named: "check"), for: .normal)
        mrOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        mrsOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        salutation = "Ms."
    }
    
    @IBAction func mrs(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Mrs. Button Clicked")
         mrsOutlet.setImage(UIImage(named: "check"), for: .normal)
        mrOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        msOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        salutation = "Mrs."
    }
    
    @IBAction func male(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Male Button Clicked")
        maleOutlet.setImage(UIImage(named: "check"), for: .normal)
        femaleOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        otherOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        gender = "male"
    }
    
    @IBAction func female(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Feamale. Button Clicked")
        maleOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        femaleOutlet.setImage(UIImage(named: "check"), for: .normal)
        otherOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        gender = "female"
    }
    @IBAction func other(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Other Button Clicked")
        maleOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        femaleOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        otherOutlet.setImage(UIImage(named: "check"), for: .normal)
        gender = "other"
    }
    
    
    @IBAction func save(_ sender: Any) {
        //postUserData()
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Save & Proceed Button Clicked")
        let boolean = validatePancard(pantf.text!)
        if fnametf.text == ""{
            presentWindow.makeToast(message: "Please Enter First Name")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Please Enter First Name")
        }
        else if lnametf.text == ""{
            presentWindow.makeToast(message: "Please Enter Last Name")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Please Enter Last Name")
        }
        else if gender == ""{
            presentWindow.makeToast(message: "Please Select Gender")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Please Select Gender")
        }
        else if dobtf.text == ""{
            presentWindow.makeToast(message: "Please Choose DOB")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Please Choose DOB")
        }
        else if mobiletf.text == ""{
            presentWindow.makeToast(message: "Please Enter Mobile No")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Please Enter Mobile No")
        }
        else if (mobiletf.text?.count)! < 10{
            presentWindow.makeToast(message: "Please Enter atleast 10 Digits")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Please Enter atleast 10 Digits")
        }
//        else if aadhartf.text == ""{
//            presentWindow.makeToast(message: "Please Enter Aadhar No")
//        }
        else if  aadhartf.text != "" && aadhartf.text!.count < 12{
            presentWindow?.makeToast(message: "Invalid Aadhar No")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Invalid Aadhar No")
        }
        else if pantf.text == ""{
            presentWindow.makeToast(message: "Please Enter PAN No")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Please Enter PAN No")
        }
        else if boolean != true {
            presentWindow?.makeToast(message: "Please Enter Valid PAN No")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Please Enter PAN No")
        }
        else if emailtf.text == ""{
            presentWindow.makeToast(message: "Please Enter Email Id")
            Mixpanel.mainInstance().track(event: "My Profile Screen :- Please Enter PAN No")
        }
        else if emailtf.text != "" {
            if !emailtf.text!.isValidEmail() {
                presentWindow!.makeToast(message: "Please Enter Correct Email Id")
                Mixpanel.mainInstance().track(event: "Register Screen :- Please Enter Correct Email Id")
            }else{
                checkExistingUserEmail()
            }
        }
        else{
           // postUserData()
            mobile_check()
        }
        
        //else if ==""
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == fnametf || textField == mnametf || textField == lnametf{
            let alloweC = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            return alloweC.isSuperset(of: characterSet)
            
        }
        else if textField == pantf{
            let lowercaseCharRange: NSRange = (string as NSString).rangeOfCharacter(from: CharacterSet.lowercaseLetters)
            if lowercaseCharRange.location != NSNotFound {
                textField.text = (textField.text as NSString?)?.replacingCharacters(in: range, with: string.uppercased())
                textField.maxLength = 10
                return false
            }
            textField.maxLength = 10
            return true
        }
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dobtf{
            self.pickUpDate(self.dobtf)
        }
        // print("oooooooo")
    }
    
    func checkExistingUserEmail() {
        
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        
        let parent_id = UserDefaults.standard.value(forKey: "parent_user_id")
        
        let url = "https://www.financialhospital.in/adminpanel/users/user_ws.php/verifyemailid"
        //let url = "\(Constants.BASE_URL)\(Constants.API.updateEmailCheck)"
        print(url)
        
        let email = emailtf.text ?? ""
        let parameters = ["id" : "\(userid as! String)","emailid":"\(email)","p_id":"\(parent_id!)"]
        print(parameters)
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseString { (response) in
                let resp = response.result.value ?? ""
                var resp1 = resp.replacingOccurrences(of: "\n" , with: "")
                
                if resp1 != "\"true\"" {
                    
                    let refreshAlert = UIAlertController(title: "", message: "\(email) is already registered with us", preferredStyle: UIAlertControllerStyle.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                        refreshAlert.dismiss(animated: true, completion: nil)
                       
                    }))
                    
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                    
                }else {
                    UserDefaults.standard.setValue(email, forKey: "Email")
                    self.mobile_check()
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
        
        
    }
    
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        
        // Mixpanel.mainInstance().track(event: "Premium Calculator :-Picking Date")
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -100, to: Date())
        //  let calcAge = calendar.dateComponents(.year,from:birthdayDate!, to: now, options: [])
        // let age = calcAge.year
        //  let age = calcAge.year
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MydetailsViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MydetailsViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        print("hiiii")
    }
    

    @objc func doneClick() {
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Date Done Button Clicked")
        let dateFormatter1 = DateFormatter()
        //yyyy-MM-dd
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        //dateFormatter1.dateStyle = .medium
        //  dateFormatter1.timeStyle = .none
        
        dobtf.text = dateFormatter1.string(from: datePicker.date)
        dobtf.resignFirstResponder()
    }
    @objc func cancelClick() {
        Mixpanel.mainInstance().track(event: "My Profile Screen :- Date Cancel Button Clicked")
        dobtf.text = ""
        dobtf.resignFirstResponder()
    }
    func validatePancard(_ candidate: String) -> Bool {
        let panCardRegex = "[A-Z]{3}[PHABTCF][A-Z]{1}[0-9]{4}[A-Z]{1}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", panCardRegex)
        return emailTest.evaluate(with: candidate)
    }
    func CheckPan(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let p = ""
        let url = "\(Constants.BASE_URL)\(Constants.API.checkparentpan)\(covertToBase64(text: userid as! String))&p=\(p)&pan=\(pantf.text!.covertToBase64())&n=1/3"
        print(url)
        //if
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data = response.result.value
                if self.checkpan != self.pantf.text{
                    if data as! String == "true"{
                        print("validate pan")
                        self.validatepan(id:userid ?? "",pan: self.pantf.text!)
                        
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        let refreshAlert = UIAlertController(title: "", message: "It seems your main account already has '\(self.pantf.text!)' associated.\n You might want to \n\u{2022} Enter another PAN \n\u{2022} Check your main account to see where you have associated this PAN \n\u{2022} If there is any confusion regarding this, please contact our support at +91-9699 800600", preferredStyle: UIAlertControllerStyle.alert)
                        
                        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                            refreshAlert.dismiss(animated: true, completion: nil)
                            self.pantf.text = ""
                            Mixpanel.mainInstance().track(event: "My Profile Screen :- Alert Ok Button Clicked")
                        }))
                        
                        
                        self.present(refreshAlert, animated: true, completion: nil)
                        print("show alert")
                    }
                }
                else{
                    //self.presentWindow.hideToastActivity()
                    self.validatepan(id:userid ?? "",pan: self.pantf.text!)
                }
                
            }
        }
    }
    func validatepan(id:Any,pan:String){
        
        //presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet{
            let parameters = ["id" : "\(covertToBase64(text: id as! String))","pan" : "\(pan.covertToBase64())","enc_resp":"3"]
            
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.VALIDATE_PAN)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                      //  self.presentWindow.hideToastActivity()
                    }
                    let data = dict
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
                                    
                                    _ = UserDefaults.standard.value(forKey: "userid") as? String
                                    print(self.pantf.text!)
                                    self.postUserData()
                                   
                                   // self.update_PAN(p_id: p_uid!, c_id: c_id!, pan: self.pancardtf.text!)
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
                        self.presentWindow.hideToastActivity()
                        print(response.result.error ?? "")
                    }
            }
        }
        else{
            presentWindow.hideToastActivity()
        }
        
    }
    func postUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid = flag
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        //presentWindow.makeToastActivity(message: "Saving...")
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id":"\(covertToBase64(text: userid as! String))",
                "name":"\(fnametf.text!.covertToBase64())",
                "middle_name":"\(mnametf.text!.covertToBase64())",
                "last_name":"\(lnametf.text!.covertToBase64())",
                "email":"\(emailtf.text!.covertToBase64())",
                "mobile":"\(mobiletf.text!.covertToBase64())",
                "landline":"\(landlinetf.text!.covertToBase64())",
                "pan":"\(pantf.text!.covertToBase64())",
                "flat_no":"\(userDataArr[0].flat_no!.covertToBase64())",
                "building_name":"\(userDataArr[0].building_name!.covertToBase64())",
                "road_street":"\(userDataArr[0].road_street!.covertToBase64())",
                "address":"\(userDataArr[0].address!.covertToBase64())",
                "dob":"\(dobtf.text!.covertToBase64())",
                "gender":"\(gender.covertToBase64())",
                "country":"\(userDataArr[0].Country!.covertToBase64())",
                "state":"\(userDataArr[0].State!.covertToBase64())",
                "city":"\(userDataArr[0].City!.covertToBase64())",
                "pincode":"\(userDataArr[0].pincode!.covertToBase64())",
                "salutation":"\(salutation.covertToBase64())",
                "marital_status":"\(userDataArr[0].marital_status!.covertToBase64())",
                "spouse_name":"\(userDataArr[0].spouse_name!.covertToBase64())",
                "guardian_name":"",
                "relation":"",
                "guardian_relation":"",
                "occupation":"\(userDataArr[0].occupation!.covertToBase64())",
                "income_slab":"\(userDataArr[0].IncomeSlabID!.covertToBase64())",
                "residential_status":"\(userDataArr[0].residential_status!.covertToBase64())",
                "user_location":"\(userDataArr[0].location!.covertToBase64())",
                "user_tax_status":"\(userDataArr[0].user_tax_status!.covertToBase64())",
                "enc_resp":"3"]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.postUserData)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    // self.presentWindow.hideToastActivity()
                    let data = response.result.value as? Bool
                    
                    if data == true {
                        print("updated user data")
                        self.addAadhar()
                        
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Something went wrong")
                        print("error has occured")
                    }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        let emails = UserDefaults.standard.value(forKey: "Email") as? String
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(covertToBase64(text: userid as? String ?? ""))/3"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseString { response in
                let enc_response = response.result.value
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                if data != nil{
                    self.presentWindow.hideToastActivity()
                    if let dataArray = data as? NSArray{
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
                            // let tax_slab = (abc as AnyObject).value(forKey: "tax_slab") as? String
                            self.checkpan =  pan
                            
                            self.fnametf.text = fname!
                            self.mnametf.text = mname!
                            self.lnametf.text =  lname
                            self.dobtf.text = dob!
                            self.mobiletf.text = mobile!
                            self.landlinetf.text = landline
                            self.emailtf.text = email
                            
                            self.pantf.text! = pan!
                            
                            if salutations == "Mr."{
                                self.mrOutlet.setImage(UIImage(named: "check"), for: .normal)
                                self.salutation = "Mr."
                            }
                            else if salutations == "Ms."{
                                self.msOutlet.setImage(UIImage(named: "check"), for: .normal)
                                self.salutation = "Ms."
                            }
                            else if salutations == "Mrs."{
                                self.mrsOutlet.setImage(UIImage(named: "check"), for: .normal)
                                self.salutation = "Mrs."
                            }
                            
                            if gender1! == "male"{
                                self.maleOutlet.setImage(UIImage(named: "check"), for: .normal)
                                self.gender = "male"
                            }
                            else if gender1 == "female"{
                                self.femaleOutlet.setImage(UIImage(named: "check"), for: .normal)
                                self.gender = "female"
                            }
                            else if gender1 == "other"{
                                
                                self.otherOutlet.setImage(UIImage(named: "check"), for: .normal)
                                self.gender = "other"
                                
                            }
                            var income_slab = (abc as AnyObject).value(forKey: "income_slab") as? String
                            let income_slab_id = (abc as AnyObject).value(forKey: "IncomeSlabID") as? String
                            if income_slab_id == "0" {
                                income_slab = ""
                            }
                            //print()
                            self.userDataArr.append(UserDataObj.getUserData(salutation: salutations!, fname: fname!, mname: mname!, lname: lname!, gender: gender1!, dob: dob!, mobile: mobile!, landline: landline!, email: email!, aadhar: "", pan: pan!, flat_no: flat_no!, building_name: building_name!, road_street: road_street!, address: address!, Country: country!, State:state!, City: city!, pincode:pincode!, occupation: occupation!, location: location!, marital_status: marital_status!, spouse_name: spouse_name!, residential_status: residential_status!, user_tax_status: user_tax_status!, tax_slab: income_slab!, IncomeSlabID: income_slab_id ?? ""))
                            self.getaadhar()
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
    
    func addAadhar(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        
        if Connectivity.isConnectedToInternet{
            print(aadhar_kyc_id!)
            print(kycDataArr[0].kyc_birth_place!)
            let parameters = ["id":"\(covertToBase64(text: userid as! String))", "kycid":"\(aadhar_kyc_id!.covertToBase64())", "kyc_aadhar":"\(aadhartf.text!.covertToBase64())", "kyc_birth_place":"\(kycDataArr[0].kyc_birth_place!.covertToBase64())", "kyc_fathers_first_name":"\(kycDataArr[0].kyc_fathers_first_name!.covertToBase64())", "kyc_fathers_middle_name":"\(kycDataArr[0].kyc_fathers_middle_name!.covertToBase64())", "kyc_fathers_last_name":"\(kycDataArr[0].kyc_fathers_last_name!.covertToBase64())","enc_resp":"3"]
            
            print(parameters)
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addkyc)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                     let enc = enc1?.base64Decoded()
                    print("&&&&&")
                    
                    let data = enc as? String
                    //print(data as? any)
                    
                    if data == "\"true\""{
                        
                        if self.fatca_detail_flag {
                            self.bseRegisteredFlag(userid: userid as! String)
                        } else {
                            self.presentWindow.hideToastActivity()
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "addressDetailViewController") as! addressDetailViewController
                            self.navigationController?.pushViewController(destVC, animated: true)
                        }
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        print("error has occured")
                    }
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getaadhar(){
        presentWindow.makeToastActivity(message: "Loading...")
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.getKyc)\(userid!)/3"
        print(url)
        if Connectivity.isConnectedToInternet{
            //cityArr.removeAll()
            Alamofire.request(url).responseString { response in
                let enc_response = response.result.value
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                //print(response.result.value)
                if let data = data as? [AnyObject]{
                    if !data.isEmpty{
                        for type in data{
                            if let birth_place = type.value(forKey: "kyc_birth_place") as? String,
                                let kyc_id = type.value(forKey: "kyc_id") as? String, let kyc_aadhar = type.value(forKey: "kyc_aadhar") as? String,let kyc_birth_country = type.value(forKey: "kyc_birth_country") as? String , let kyc_fathers_first_name = type.value(forKey: "kyc_fathers_first_name")as? String,let kyc_fathers_middle_name = type.value(forKey: "kyc_fathers_middle_name")as? String,let kyc_fathers_last_name = type.value(forKey: "kyc_fathers_last_name")as? String{
                                self.aadhartf.text = kyc_aadhar
                                print(kyc_id)
                                print(kyc_birth_country)
                                self.aadhar_kyc_id = kyc_id
                                self.kycDataArr.append(AddKycObj.addkycDetail(kyc_id: kyc_id, kyc_aadhar: kyc_aadhar, kyc_birth_place: birth_place, kyc_fathers_first_name: kyc_fathers_first_name, kyc_fathers_middle_name: kyc_fathers_middle_name, kyc_fathers_last_name: kyc_fathers_last_name, kyc_birth_country: kyc_birth_country))
                                
                                self.presentWindow.hideToastActivity()
                                
                            }
                        }
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        self.aadhar_kyc_id = ""
                        self.kycDataArr.append(AddKycObj.addkycDetail(kyc_id: "", kyc_aadhar: "", kyc_birth_place: "", kyc_fathers_first_name: "", kyc_fathers_middle_name: "", kyc_fathers_last_name: "", kyc_birth_country: ""))
                    }
                    
                    // print(self.countriesArr)
                }
                
            }
            
            
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func checkAadhar(){
        if aadhartf.text != "" {
            var userid = UserDefaults.standard.value(forKey: "userid")
            if flag != "0"{
                userid! = flag
                
            }
            else{
                // flag = "0"
                userid = UserDefaults.standard.value(forKey: "userid")
            }
            let url = "\(Constants.BASE_URL)\(Constants.API.checkAadhar)\(userid!)&aadhar_no=\(aadhartf.text!)"
            //let url = "\(Constants.BASE_URL)\(Constants.API.checkAadhar)\(covertToBase64(text: userid as! String))&aadhar_no=\(aadhartf.text!.covertToBase64())/3"
            print(aadhartf.text!,"aadhar")
            print(url)
            if Connectivity.isConnectedToInternet{
                Alamofire.request(url).responseString { response in
                     print(response.result.value)
                    
                    let data = response.result.value?.replacingOccurrences(of: "\n", with: "")
                    if data != nil{
                        if data != "\"true\""{
                            self.presentWindow.hideToastActivity()
                            self.presentWindow.makeToast(message: "\(data!)")
                        }
                        else{
                            //self.presentWindow.hideToastActivity()
                            self.CheckPan()
                            print("not register aadhar")
                        }
                    }
                        
                    else{
                        print("empty")
                    }
                }
            } else{
                self.presentWindow.hideToastActivity()
            }
        } else {
            self.CheckPan()
        }
    }
    func mobile_check(){
        let userid = UserDefaults.standard.value(forKey: "parent_user_id")
        presentWindow.makeToastActivity(message: "Saving..")
        let url = "\(Constants.BASE_URL)login/login_ws.php/checkmobile?exclude=\(covertToBase64(text: userid as! String))&mobile=\(mobiletf.text!.covertToBase64())&type=app&enc_resp=3"
        print(url)
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseString { response in
                let enc_response = response.result.value
                var dict = [Dictionary<String,Any>]()
                var data1 = ""
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    data1 =  response.result.value?.replacingOccurrences(of: "\n", with: "") ?? ""
                    
                    //self.presentWindow.hideToastActivity()
                }
                let data = dict
                //let data = response.result.value
                
                if data != nil{
                    if data1 != ""{
                        if data1 == "\"true\""{
                            self.checkAadhar()
                        }
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        if let dataArray = data as? NSArray{
                            self.presentWindow.hideToastActivity()
                            for abc in dataArray{
                                let error = (abc as AnyObject).value(forKey: "error") as? String
                                let mobile = (abc as AnyObject).value(forKey: "mobile") as? String
                                let email = (abc as AnyObject).value(forKey: "email") as? String
                                if error == "1"{
                                    var myStringArr = email!.components(separatedBy: "@")
                                    print(myStringArr)
                                    
                                    _ = myStringArr[0].dropLast(3)
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
                                        self.p_final = firsttwo + text + lasttwo
                                        print(self.p_final)
                                        
                                        
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
                                        self.p_final = firsttwo + text + lasttwo
                                        print(self.p_final)
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
                                        self.s_final = firsttwo + text + lasttwo
                                        print(self.s_final)
                                        
                                        
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
                                        self.s_final = firsttwo + text + lasttwo
                                        print(self.s_final)
                                    }
                                    
                                    // let pemail = String(dropemail) + "***\(myStringArr[1])"
                                    
                                    let refreshAlert = UIAlertController(title: "", message: "'\(mobile!)' is already registered with \(self.p_final!)@\(self.s_final!).\n\u{2022} You might want to provide another number\n\u{2022} you may directly login with the existing one", preferredStyle: UIAlertControllerStyle.alert)
                                    
                                    refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
                                        refreshAlert.dismiss(animated: true, completion: nil)
                                    }))
                                    
                                    
                                    self.present(refreshAlert, animated: true, completion: nil)
                                }
                                else{
                                    
                                    self.presentWindow.makeToast(message: "mobile no does not exit")
                                }
                            }
                        }
                    }
                }
                    
                else{
                    self.presentWindow.hideToastActivity()
                    print("empty")
                }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    func getUserFatcaDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.getFatcaDetails)\(covertToBase64(text: userid as! String))/3"
        print(url)
        if Connectivity.isConnectedToInternet{
            //cityArr.removeAll()
            Alamofire.request(url).responseString { response in
                let enc_response = response.result.value
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                if let data = data as? [AnyObject]{
                    if !data.isEmpty{
                        for type in data{
                            if let fatca_id = type.value(forKey: "fatca_id") as? String,
                                let fatca_networth = type.value(forKey: "fatca_networth") as? String, let fatca_networth_date = type.value(forKey: "fatca_networth_date") as? String , let fatca_politically_exposed = type.value(forKey: "fatca_politically_exposed") as? String,let fatca_nationality = type.value(forKey: "fatca_nationality") as? String,let fatca_other_nationality = type.value(forKey: "fatca_other_nationality") as? String,let fatca_tax_resident = type.value(forKey: "fatca_tax_resident") as? String ,let fatca_resident_country = type.value(forKey: "fatca_resident_country") as? String,let fatca_tax_player_id = type.value(forKey: "fatca_tax_player_id") as? String,let fatca_id_type = type.value(forKey: "fatca_id_type") as? String,let fatca_resident_country_1 = type.value(forKey: "fatca_resident_country_1") as? String, let fatca_tax_player_id_1 = type.value(forKey: "fatca_tax_player_id_1") as? String,let fatca_id_type_1 = type.value(forKey: "fatca_id_type_1") as? String,let fatca_resident_country_2 = type.value(forKey: "fatca_resident_country_2") as? String,let fatca_tax_player_id_2 = type.value(forKey: "fatca_tax_player_id_2") as? String,let fatca_id_type_2 = type.value(forKey: "fatca_id_type_2") as? String{
                                
                                self.fatca_detail_flag = true
                                self.fatcaArr.append(FatcaObj.getFatcaDetail(fatcaid: fatca_id, fatca_networth: fatca_networth, fatca_networth_date: fatca_networth_date, fatca_politically_exposed: fatca_politically_exposed, fatca_nationality: fatca_nationality, fatca_other_nationality: fatca_other_nationality, fatca_tax_res: fatca_tax_resident, fatca_resident_country: fatca_resident_country, fatca_resident_country_1: fatca_resident_country_1, fatca_resident_country_2: fatca_resident_country_2, fatca_tax_player_id: fatca_tax_player_id, fatca_tax_player_id_1: fatca_tax_player_id_1, fatca_tax_player_id_2: fatca_tax_player_id_2, fatca_id_type: fatca_id_type , fatca_id_type_1: fatca_id_type_1, fatca_id_type_2: fatca_id_type_2))
                                //  natinalitytf.text = ""
                                
                                
                            }
                        }
                    }
                    else{
                        self.fatca_detail_flag = false
                        print("fatca detail is empty")
                    }
                    // print(self.countriesArr)
                }
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func clientregistrationBse(userid:String){
        print("Modify ucc data")
        //https://www.financialhospital.in/adminpanel/bse/bse_ws.php/clientregistration/userid
        let url = "\(Constants.BASE_URL)\(Constants.API.clientregistration)\(userid)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value as? [String:Any]
                if let response_status = data?["response"] {
                    if data?["status"] != nil && data?["status"] as? String  == "Error" {
                        let a = data?["bse_err_msg"] as? String
                        let bse_err_msg =  data?["bse_err_msg"] as? String ?? "FAIL"
                        let alert = UIAlertController(title: "Alert", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.setValue(bse_err_msg.htmlToAttributedString, forKey: "attributedMessage")
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                           print("Ok button clicked")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                            self.navigationController?.pushViewController(controller, animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else  {
                        //fatca called after success ucc else no required.
                        self.fatcaUploadBse(userid: userid)
                    }
                }
            }
        } else {
            
        }
    }
    func fatcaUploadBse(userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.FATCAUpload)\(userid)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value as? [String:Any]
                if data?["bse_err_status"] != nil && data?["bse_err_status"] as? String  == "FAIL" {
                        let alert = UIAlertController(title: "Alert", message: "\(data!["response"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                            print("Ok button clicked")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                            self.navigationController?.pushViewController(controller, animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        //redirect to address detail
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "addressDetailViewController") as! addressDetailViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
            }
        } else {
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func bseRegisteredFlag(userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.isBSERegistered)\(userid)"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                let data = response.result.value as? [String:String]
                if let bse_reg_status = data?["bse_reg"] {
                    print(bse_reg_status)
                    if bse_reg_status == "Y" {
                        self.clientregistrationBse(userid: userid)
                    } else {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "addressDetailViewController") as! addressDetailViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
}
