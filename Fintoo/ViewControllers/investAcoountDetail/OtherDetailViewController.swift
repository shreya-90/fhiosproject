 //
//  OtherDetailViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 23/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import Alamofire
import Mixpanel
class OtherDetailViewController: BaseViewController,UITextFieldDelegate,FlexibleSteppedProgressBarDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var occupationTableView: UITableView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var selectStateConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var stateBtnOutlet: UIButton!
    @IBOutlet weak var selectCityConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityBtnOutlet: UIButton!
    @IBOutlet weak var cityBtnImage: UIImageView!
    @IBOutlet weak var spouseLabel: UILabel!
    @IBOutlet weak var taxTableView: UITableView!
    @IBOutlet weak var countryTableView: UITableView!
    
    @IBOutlet weak var stateTableView: UITableView!
    
    @IBOutlet weak var cityTableView: UITableView!
    
    @IBOutlet weak var locationTableView: UITableView!
    @IBOutlet weak var maritalTableView: UITableView!
    @IBOutlet weak var resedentialTableView: UITableView!
    @IBOutlet weak var spouseName: UILabel!
    
    @IBOutlet weak var politicallyNo: UIButton!
    @IBOutlet weak var politicallyYes: UIButton!
    
    @IBOutlet weak var politicallyPEP: UIButton!
    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    @IBOutlet weak var placeOfBirthTf: UITextField!
    
    @IBOutlet weak var occupationtf: UITextField!
    
    @IBOutlet weak var locationtf: UITextField!
    
    @IBOutlet weak var maritalStatus: UITextField!
    
    @IBOutlet weak var spouseNametf: UITextField!
    
    @IBOutlet weak var nameOfGuardian: UITextField!
    
    @IBOutlet weak var relationOFGuardiantf: UITextField!
    
    @IBOutlet weak var flatNumbertf: UITextField!
    
    @IBOutlet weak var bnametf: UITextField!
    
    @IBOutlet weak var roadStreettf: UITextField!
    
    @IBOutlet weak var addresstf: UITextField!
    
    @IBOutlet weak var countrytf: UITextField!
    
    @IBOutlet weak var statetf: UITextField!
    
    @IBOutlet weak var citytf: UITextField!
    
   
    @IBOutlet weak var pincodetf: UITextField!
    
    @IBOutlet weak var taxStatus: UITextField!
    
    @IBOutlet weak var residentialStatustf: UITextField!
    
    @IBOutlet weak var ffnametf: UITextField!
    
    @IBOutlet weak var fmname: UITextField!
    
    
    @IBOutlet weak var flname: UITextField!
    
    
   
    var city_flag  = "0"
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var residentialArr = ["Select","RES-Resident","NRI-Non Resident","NRO-Resident but not ordinarily Resident"]
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/-, "
    let ACCEPTABLE_CHARACTERS_SPACE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    let ACCEPTABLE_CHARACTERS1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    var marital_status = ["Select","Married","Unmarried","Other"]
    let pickerView = UIPickerView()
    var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    var progressColor = UIColor(red: 45.0 / 255.0, green: 180.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var bgcolor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    var maxIndex = -1
    var userDataArr = [UserDataObj]()
    var occupation_id : String!
    var location_id : String!
    var tax_status_id : String!
    var marital_Status : String!
    var residential_status : String!
    var occupationArr = [OccupationObj]()
    var locationArr = [LocationObj]()
    var taxStatusArr = [TaxStatusObj]()
    var kycDataArr = [AddKycObj]()
    var countriesArr = [CountriesObj]()
    var NriDataArr = [UserNriObj]()
    var stateArr = [StateObj]()
    var cityArr = [CityObj]()
    var country_ID1 : String!
    var state_ID : String!
    var city_ID : String!
    var kyc_id : String!
    var politically_exposed : String!
    var kyc_aadhar : String!
    var fatca_id : String!
    var nri_id : String!
    var fatcaArr = [FatcaObj]()
    var fatca_detail_flag = false
    var flatNo = ""
    var building_name = ""
    var road_street = ""
    var locality = ""
    var personal_details_alert = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        presentWindow.makeToastActivity(message: "Loading...")
        
        getUserData()
       
        politically_exposed = "1"
        getUserNRIDetails()
        
        heightConstraint.constant = 600.0
       // heightConstraint.priority = 1000
        self.OverseasStackView?.visiblity(gone: true, dimension: 0)
        
//        bnametf.delegate = self
        spouseNametf.delegate = self
        residentialStatustf.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        flatNumbertf.delegate = self
       // addresstf.delegate = self
      //  roadStreettf.delegate = self
        fmname.delegate = self
        flname.delegate = self
        ffnametf.delegate = self
        placeOfBirthTf.delegate = self

        getCountries()
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
        progressBar.completedTillIndex = 2
        progressBar.useLastState = true
        
        progressBar.lastStateCenterColor = progressColor
        progressBar.selectedBackgoundColor = progressColor
        
        progressBar.selectedOuterCircleStrokeColor = backgroundColor
        progressBar.lastStateOuterCircleStrokeColor = backgroundColor
        progressBar.currentSelectedCenterColor = progressColor
        progressBar.currentSelectedTextColor = progressColor
        progressBar.stepTextColor = textColorHere
        progressBar.currentIndex = 2
        
        
        
        occupationtf.delegate = self
        maritalStatus.delegate = self
        locationtf.delegate = self
        taxStatus.delegate = self
        countrytf.delegate =  self
        statetf.delegate = self
        citytf.delegate = self
        
        
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
        stateTableView.delegate = self
        stateTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.dataSource = self
        locationTableView.delegate = self
        locationTableView.dataSource = self
        maritalTableView.delegate = self
        maritalTableView.dataSource = self
        resedentialTableView.delegate = self
        resedentialTableView.dataSource = self
        taxTableView.delegate = self
        taxTableView.dataSource = self
        occupationTableView.delegate = self
        occupationTableView.dataSource = self
        
        countryTableView.isHidden = true
        stateTableView.isHidden = true
        cityTableView.isHidden = true
        locationTableView.isHidden =  true
        maritalTableView.isHidden = true
        taxTableView.isHidden = true
    }
    
    
    @IBOutlet weak var OverseasStackView: UIStackView!
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Other Details Screen :- Back Button Clicked")
        if personal_details_alert == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
        navigationController?.popViewController(animated: true)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag,"textfield")
        
        if textField == residentialStatustf{
            residentialStatustf.inputView = pickerView
            pickerView.tag = 1
           // self.OverseasStackView?.visiblity(gone: true, dimension: 0)
            //OverseasStackView.arrangedSubviews[1].isHidden = true
        }
        else if textField == occupationtf{
            //occupationtf.inputView = pickerView
            pickerView.tag = 2
        }
        else if textField == maritalStatus{
            maritalStatus.inputView = pickerView
            pickerView.tag = 3
        }
        else if textField == locationtf{
            locationtf.inputView = pickerView
            pickerView.tag = 4
        }
        else if textField == taxStatus{
            taxStatus.inputView = pickerView
            pickerView.tag = 5
        }
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //if textField == residentialStatustf{
            if residentialStatustf.text! == "NRI-Non Resident" {
                self.OverseasStackView?.visiblity(gone: false, dimension:280)
                heightConstraint.constant = 1000.0
            }
           
        else{
            self.OverseasStackView?.visiblity(gone: true, dimension:0)
            heightConstraint.constant = 600.0
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            //print(countriesArr.count)
            return residentialArr.count
        }
        else if pickerView.tag == 2{
            return occupationArr.count
        }
        else if pickerView.tag == 3{
           return marital_status.count
        }
        else if pickerView.tag == 4{
            return locationArr.count
            
        }
        else if pickerView.tag == 5{
            return taxStatusArr.count
            
        }
        
            
        else{
            return 10
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            return residentialArr[row]
        }
        else if pickerView.tag == 2{
            return occupationArr[row].occupation_name
        }
        else if pickerView.tag == 3{
            return marital_status[row]
        }
        else if pickerView.tag == 4{
            return locationArr[row].location_name
        }
        else if pickerView.tag == 5{
            return taxStatusArr[row].taxStatus_name
        }
        
        
        else{
            return "hello"
        }
        
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == flatNumbertf{
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
       if textField == addresstf || textField == ffnametf || textField == flname || textField == fmname || textField == placeOfBirthTf{
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS1).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")

            return (string == filtered)
        } else if textField == spouseNametf || textField == bnametf{
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS_SPACE).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        return true
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView.tag,"picker view tag")
        //print(items,"items")
        //let cell: customCell = tableview.cellForRow(at: IndexPath(row: items, section: 0)) as! customCell
        if pickerView.tag == 1{
            
            residentialStatustf.text = residentialArr[row]
            if residentialArr[row] == "RES-Resident"{
                
                self.residential_status = "1"
            }
            else if residentialArr[row] == "NRI-Non Resident"{
                //self.residentialStatustf.text = "NRI-Non Resident"
                self.residential_status = "2"
            }
            else {
                self.residential_status = "3"
            }
        }
        else if pickerView.tag == 2{
            occupationtf.text = occupationArr[row].occupation_name
            occupation_id = occupationArr[row].occupation_id
            print(occupationArr[row].occupation_id)
            
            
        }
        else if pickerView.tag == 3{
            maritalStatus.text = marital_status[row]
            if maritalStatus.text == "Married"{
                marital_Status = "married"
            }
            else if maritalStatus.text == "Unmarried"{
                marital_Status = "unmarried"
            }
            else if maritalStatus.text == "Other"{
                marital_Status = "other"
            }
            
        }
        else if pickerView.tag == 4{
            locationtf.text = locationArr[row].location_name
            location_id = locationArr[row].location_id
            //if marital_status[]
        }
        else if pickerView.tag == 5{
            taxStatus.text = taxStatusArr[row].taxStatus_name
            tax_status_id = taxStatusArr[row].taxStatus_id
            //if marital_status[]
        }
        
        
       
        
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
    @IBAction func politicallyNoBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Other Details Screen :- Politically Exposed No Button Clicked")
        politicallyYes.setImage(UIImage(named: "uncheck"), for: .normal)
        politicallyNo.setImage(UIImage(named: "check"), for: .normal)
        politicallyPEP.setImage(UIImage(named: "uncheck"), for: .normal)
        politically_exposed = "2"
    }
    
    @IBAction func politicallyPEPBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Other Details Screen :- Politically Exposed PE Button Clicked")
        politicallyYes.setImage(UIImage(named: "uncheck"), for: .normal)
        politicallyNo.setImage(UIImage(named: "uncheck"), for: .normal)
        politicallyPEP.setImage(UIImage(named: "check"), for: .normal)
        politically_exposed = "3"
    }
    
    @IBAction func politicallyYesBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Other Details Screen :- Politically Exposed yes Button Clicked")
        politicallyYes.setImage(UIImage(named: "check"), for: .normal)
        politicallyNo.setImage(UIImage(named: "uncheck"), for: .normal)
        politicallyPEP.setImage(UIImage(named: "uncheck"), for: .normal)
        politically_exposed = "1"
    }
    
    @IBAction func save(_ sender: Any) {
        print(occupation_id,"occ")
        let address_text = flatNumbertf.text!
        let address_text_split = address_text.split(separator: ",")
        print(address_text_split)
        var f_c = false
        var fourt_comma = ""
        if address_text.first != "," && address_text.last != ","{
            f_c = true
            if address_text_split.indices.contains(0) {
                flatNo = String(address_text_split[0])
            }
            if address_text_split.indices.contains(1) {
                building_name = String(address_text_split[1])
            }
            if address_text_split.indices.contains(2) {
                road_street = String(address_text_split[2])
            }
            if address_text_split.indices.contains(3) {
                locality = String(address_text_split[3])
            }
            if address_text_split.indices.contains(4) {
                 fourt_comma = "1"
            }
        }
        Mixpanel.mainInstance().track(event: "Other Details Screen :- Save Button Clicked")
        if occupationtf.text == "Select Occupation"{
            presentWindow.makeToast(message: "Please Select Occupation")
            Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Select Occupation")
        } else if !f_c {
            presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
        }else if fourt_comma == "1"{
            presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
        }
        else if locationtf.text == "Select Location"{
            presentWindow.makeToast(message: "Please Select Location")
            Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Select Location")
        }
        else if maritalStatus.text == "Select"{
            presentWindow.makeToast(message: "Please Select Marital Status")
            Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Select Marital Status")
        }
        else if spouseNametf.text == "" && maritalStatus.text == "Married"{
            presentWindow.makeToast(message: "Please Enter Spouse Name")
            Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Enter Spouse Name")
        }
        else if residentialStatustf.text == "Select"{
            presentWindow.makeToast(message: "Please Select Residential Status")
            Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Select Residential Status")
        }
        //else
        else if taxStatus.text == "Select Tax Status"{
            presentWindow.makeToast(message: "Please Select Tax Status")
            Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Select Residential Status")
        }
        else if placeOfBirthTf.text == ""{
            presentWindow.makeToast(message: "Please Enter Place of Birth")
            Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Enter Place of Birth")
        }
        else if ffnametf.text == ""{
            presentWindow.makeToast(message: "Please Enter Father's First Name")
            Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Enter Father's First Name")
        }
        else if flname.text == ""{
            presentWindow.makeToast(message: "Please Enter Father's Last Name")
            Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Enter Father's Last Name")
        }
        else if politically_exposed == nil{
            presentWindow.makeToast(message: "Please ")
        }
        else if residentialStatustf.text == "NRI-Non Resident"{
            if flatNumbertf.text == ""{
                flatNumbertf.resignFirstResponder()
                presentWindow.makeToast(message: "Please Enter Address")
                
                Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Enter Falt Number")
            } else if flatNo == "" && building_name == "" && road_street == "" && locality == "" {
                 flatNumbertf.resignFirstResponder()
                presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
                Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
            }else if flatNo == "" {
                presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
                Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
            }
            else if building_name == "" {
                 flatNumbertf.resignFirstResponder()
                presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
                Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
            }
            else if road_street == "" {
                 flatNumbertf.resignFirstResponder()
                presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
                Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
                
            }else if locality == ""{
                presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
                Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
            }
            else if countrytf.text == "Select Country"{
                presentWindow.makeToast(message: "Please Select Country")
                Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Select Country")
            }
            else if statetf.text == "Select State"{
                presentWindow.makeToast(message: "Please Select State")
                Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Select State")
            }
            else if city_flag == "0" && citytf.text == "Select City" {
                presentWindow.makeToast(message: "Please Select City")
                Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Select City")
            }
            else if pincodetf.text == ""{
                presentWindow.makeToast(message: "Please Enter Pincode")
                Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Enter Pincode")
            }
            else if pincodetf.text!.count < 6{
                presentWindow.makeToast(message: "Please Enter Atleast 6 Digits Pincode")
                Mixpanel.mainInstance().track(event: "Other Details Screen :- Please Enter Atleast 6 Digits Pincode")
            }
            else{
                SaveNRIDetails()
               // postUserData()
            }
            
        }
        else {
           
            postUserData()
            
        }
        //else if
    }
    
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        print(userid)
        //print(countriesArr.count)
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(covertToBase64(text: userid as? String ?? ""))/3"
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
                    // print(data)
                    self.presentWindow.hideToastActivity()
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
                           // let spouse_name = (abc as AnyObject).value(forKey: "spouse_name") as? String
                            self.occupation_id = occupation!
                            self.location_id = location!
                            self.tax_status_id = user_tax_status!
                            self.marital_Status = marital_status
                            self.spouseNametf.text! = spouse_name!
                            if marital_status == "married"{
                                let attr = [ NSAttributedStringKey.foregroundColor : UIColor.red ]
                                let myNewLabelText = NSMutableAttributedString(string: "*", attributes: attr)
                                let spouseNames = NSMutableAttributedString(string: "Spouse Name ")
                                spouseNames.append(myNewLabelText)
                                self.spouseName.attributedText = spouseNames
                            } else {
                                self.spouseNametf.isEnabled = false
                                self.spouseNametf.text = ""
                                self.spouseName.text = "Spouse Name"
                            }
//                            self.country_ID1 = country!
//                            self.state_ID = state!
//                            self.city_ID = city!
                            var income_slab = (abc as AnyObject).value(forKey: "income_slab") as? String
                            let income_slab_id = (abc as AnyObject).value(forKey: "IncomeSlabID") as? String
                            if income_slab_id == "0" {
                                income_slab = ""
                            }
                            
                            
                            self.userDataArr.append(UserDataObj.getUserData(salutation: salutations!, fname: fname!, mname: mname!, lname: lname!, gender: gender1!, dob: dob!, mobile: mobile!, landline: landline!, email: email!, aadhar: "", pan: pan!, flat_no: flat_no!, building_name: building_name!, road_street: road_street!, address: address!, Country: country!, State:state!, City: city!, pincode:pincode!, occupation: occupation!, location: location!, marital_status: marital_status!, spouse_name: spouse_name!, residential_status: residential_status!, user_tax_status: user_tax_status!, tax_slab: income_slab!, IncomeSlabID: income_slab_id ?? ""))
                            self.getOccupation()
                            self.getLocation()
                            
                            self.getUserKycDetails()
                            self.getUserFatcaDetails()
                            //self.getCountries()
                            //self.getState(id: country!)
                           // self.getCity1(id: state!)
                             self.residential_status = residential_status!
                            if residential_status == "1"{
                                self.residentialStatustf.text = "RES-Resident"
                                self.getTaxStatus(id: "1", didSelect: false)
                            }
                            else if residential_status == "2"{
                                self.residentialStatustf.text = "NRI-Non Resident"
                                self.OverseasStackView?.visiblity(gone: false, dimension:280)
                                self.heightConstraint.constant = 1000.0
                                self.getTaxStatus(id: "2", didSelect: false)
                            }
                            else {
                                self.residentialStatustf.text = "NRO-Resident but not ordinarily Resident"
                                self.getTaxStatus(id: "3", didSelect: false)
                            }
                            if marital_status == "married"{
                                self.maritalStatus.text! = "Married"
                            }
                            else if marital_status == "unmarried"{
                                self.maritalStatus.text! = "Unmarried"
                                self.spouseNametf.isEnabled = false
                            }
                            else {
                                self.maritalStatus.text! = "Other"
                                self.spouseNametf.isEnabled = false
                                
                            }
                            
                            //print(self.userDataArr)
                            //self.postUserData()
                            
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
    
    func getOccupation(){
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.getOccupation)/3"
        occupationArr.append(OccupationObj.getOccupation(occupation_id: "00", occupation_name: "Select Occupation"))
        if Connectivity.isConnectedToInternet{
           // stateArr.removeAll()
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
                    for type in data{
                        if let occupationName = type.value(forKey: "occupation_name") as? String,
                            let occupationId = type.value(forKey: "occupation_id") as? String{
                            print(occupationName)
                            //self.state_ID = stateId
                            self.occupationArr.append(OccupationObj.getOccupation(occupation_id: occupationId, occupation_name: occupationName))
                            print(self.occupation_id!)
                            print(occupationId)
                            self.presentWindow.hideToastActivity()
                            if self.occupation_id! == occupationId{
                                self.occupationtf.text = occupationName
                            
                            }
//                            else{
//                                self.occupationtf.text = ""
//                            }
                        }
                    }
                    self.occupationTableView.reloadData()
                    // print(self.countriesArr)
                }
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getLocation(){
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.getLocations)/3"
        locationArr.append(LocationObj.getLocation(location_id: "0", location_name: "Select Location"))
        if Connectivity.isConnectedToInternet{
            // stateArr.removeAll()
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
                    for type in data{
                        if let locationName = type.value(forKey: "location_name") as? String,
                            let locationId = type.value(forKey: "location_id") as? String{
                           // print(locationName)
                            //print(location_id)
                            //self.state_ID = stateId
                            self.locationArr.append(LocationObj.getLocation(location_id: locationId, location_name: locationName))
                            self.presentWindow.hideToastActivity()
                            print(self.location_id,locationId)
                            if self.location_id! == locationId{
                                if self.location_id! == "0"{
                                    self.locationtf.text = "Select Location"
                                }
                                else{
                                    self.locationtf.text = locationName
                                }
                            }
                            
                        }
                    }
                    // print(self.countriesArr)
                }
                self.locationTableView.reloadData()
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getTaxStatus(id:String,didSelect:Bool){
        taxStatusArr.removeAll()
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.getTaxStatus)/3"
        taxStatusArr.append(TaxStatusObj.getTaxStatus(taxStatus_id: "0", taxStatus_name: "Select Tax Status"))
        if Connectivity.isConnectedToInternet{
            // stateArr.removeAll()
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
                    for type in data{
                        
                            self.presentWindow.hideToastActivity()
                            //self.state_ID = stateId
                            if id == "1"{
                                let residential_status = type.value(forKey: "residential_status") as? String ?? ""
                                let tax_status_id = type.value(forKey: "tax_status_id") as? String ?? ""
                                let tax_status_desc = type.value(forKey: "tax_status_desc") as? String ?? ""
                                
                                if residential_status == id{
                                    self.taxStatusArr.append(TaxStatusObj.getTaxStatus(taxStatus_id: tax_status_id, taxStatus_name: tax_status_desc))
                                }
                                if didSelect {
                                    self.tax_status_id = ""
                                    self.taxStatus.text = "Select Tax Status"
                                }
                                if self.tax_status_id! == tax_status_id{
                                    self.taxStatus.text = tax_status_desc
                                }
                            } else if id == "2"{
                                let residential_status = type.value(forKey: "residential_status") as? String ?? ""
                                let tax_status_id = type.value(forKey: "tax_status_id") as? String ?? ""
                                let tax_status_desc = type.value(forKey: "tax_status_desc") as? String ?? ""
                                
                                if residential_status == id{
                                    print(tax_status_desc)
                                    self.taxStatusArr.append(TaxStatusObj.getTaxStatus(taxStatus_id: tax_status_id, taxStatus_name: tax_status_desc))
                                }
                                if didSelect {
                                    self.tax_status_id = ""
                                    self.taxStatus.text = "Select Tax Status"
                                }
                                if self.tax_status_id! == tax_status_id{
                                    self.taxStatus.text = tax_status_desc
                                }
                            } else if id == "3"{
                                let residential_status = type.value(forKey: "residential_status") as? String ?? ""
                                let tax_status_id = type.value(forKey: "tax_status_id") as? String ?? ""
                                let tax_status_desc = type.value(forKey: "tax_status_desc") as? String ?? ""
                                print(tax_status_desc)
                                if residential_status == id{
                                    self.taxStatusArr.append(TaxStatusObj.getTaxStatus(taxStatus_id: tax_status_id, taxStatus_name: tax_status_desc))
                                }
                                if didSelect {
                                    self.tax_status_id = ""
                                    self.taxStatus.text = "Select Tax Status"
                                }
                                if self.tax_status_id! == tax_status_id{
                                    self.taxStatus.text = tax_status_desc
                                }
                            }
                            
                            
                       // }
                    }
                    // print(self.countriesArr)
                }
                self.taxTableView.reloadData()
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func  getCountries(){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        countriesArr.removeAll()
        countriesArr.append(CountriesObj.getuserdata(country_name: "Select Country", country_id: "0"))
        if countrytf.text == ""{
            self.countrytf.text = self.countriesArr[0].country_name
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.country)/3"
        if Connectivity.isConnectedToInternet{
            //countriesArr.removeAll()
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
                    for type in data{
                        if let countryName = type.value(forKey: "country_name") as? String,
                            let countryId = type.value(forKey: "country_id") as? String{
                            print(countryName)
                            if countryName != "India" &&  countryName != "Canada" && countryName != "United States"{
                                self.countriesArr.append(CountriesObj.getuserdata(country_name: countryName, country_id: countryId))
                            }
                            
                        }
                    }
                    // print(self.countriesArr)
                }
                self.countryTableView.reloadData()
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getState(id:String){
        print(id)
        presentWindow.makeToastActivity(message: "Loading..")
        if id != "0" {
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
            let url = "\(Constants.BASE_URL)\(Constants.API.state)\(id)/3"
            stateArr.removeAll()
            stateArr.append(StateObj.getState(State_name: "Select State", State_id: "0"))
            if statetf.text == ""{
                self.statetf.text = self.stateArr[0].State_name
            }
            if Connectivity.isConnectedToInternet{
                //stateArr.removeAll()
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
                        for type in data{
                            if let stateName = type.value(forKey: "state_name") as? String,
                                let stateId = type.value(forKey: "state_id") as? String{
                                print(stateName)
    //                            if self.state_ID == stateId {
    //                                self.statetf.text = stateName
    //                            }
    //                            self.presentWindow.hideToastActivity()
                                self.stateArr.append(StateObj.getState(State_name: stateName, State_id: stateId))
                            }
                        }
                        // print(self.countriesArr)
                    }
                    self.presentWindow.hideToastActivity()
                    self.stateTableView.reloadData()
                    
                }
             }
            else{
                //presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        } else {
            if statetf.text == ""{
                self.statetf.text = "Select State"
                self.citytf.text = "Select City"
            }
            
        }
    }
    func  getCity1(id:String){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        let url = "\(Constants.BASE_URL)\(Constants.API.city)\(id)/3"
        cityArr.removeAll()
        cityArr.append(CityObj.getCity(City_name: "Select City", City_id: "0"))
        if citytf.text == ""{
            self.citytf.text = self.cityArr[0].City_name
        }
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
                        self.city_flag = "0"
                        self.cityBtnImage.isHidden = false
                        self.citytf.isEnabled = true
                        self.cityBtnOutlet.isHidden = false
                        let attr = [ NSAttributedStringKey.foregroundColor : UIColor.red ]
                        let myNewLabelText = NSMutableAttributedString(string: "*", attributes: attr)
                        let city = NSMutableAttributedString(string: "City ")
                        city.append(myNewLabelText)
                        self.cityLabel.attributedText = city
                        if let cityName = type.value(forKey: "city_name") as? String,
                            let cityId = type.value(forKey: "city_id") as? String{
                            print(cityId)
//                            if self.city_ID == cityId{
//                                self.citytf.text! = cityName
//                            }
//                            self.presentWindow.hideToastActivity()
                            self.cityArr.append(CityObj.getCity(City_name: cityName, City_id: cityId))
                        }
                    }
                     } else{
                        if id == "0"{
                            self.citytf.text = "Select City"
                            self.cityBtnImage.isHidden = false
                            self.citytf.isEnabled = true
                            self.cityBtnOutlet.isHidden = false
                            //self.cityBtnOutlet.isUserInteractionEnabled = true
                           
                        } else {
                            self.city_ID = ""
                            self.citytf.text = "NA"
                            self.citytf.isEnabled = false
                            self.cityBtnOutlet.isHidden = true
                            self.cityBtnImage.isHidden = true
                            self.city_flag = "1"
                            self.cityLabel.text = "City"
                           // self.cityBtnOutlet.isUserInteractionEnabled = false
                            print("city is empty")
                        }
                    }
                    // print(self.countriesArr)
                }
                self.cityTableView.reloadData()
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getUserKycDetails(){
        presentWindow.makeToastActivity(message: "Loading...")
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.getKyc)\(covertToBase64(text: userid as! String))/3"
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
                   if  !data.isEmpty {
                    for type in data{
                        if let birth_place = type.value(forKey: "kyc_birth_place") as? String,
                            let kyc_id = type.value(forKey: "kyc_id") as? String, let kyc_aadhar = type.value(forKey: "kyc_aadhar") as? String,let kyc_birth_country = type.value(forKey: "kyc_birth_country") as? String , let kyc_fathers_first_name = type.value(forKey: "kyc_fathers_first_name")as? String,let kyc_fathers_middle_name = type.value(forKey: "kyc_fathers_middle_name")as? String,let kyc_fathers_last_name = type.value(forKey: "kyc_fathers_last_name")as? String{
                           
                            
                            print(kyc_aadhar,kyc_id,kyc_birth_country,kyc_fathers_first_name,kyc_fathers_middle_name,kyc_fathers_last_name)
                                self.kyc_id = kyc_id
                                self.kyc_aadhar = kyc_aadhar
                                self.ffnametf.text = kyc_fathers_first_name
                                self.fmname.text = kyc_fathers_middle_name
                                self.flname.text = kyc_fathers_last_name
                                self.placeOfBirthTf.text = birth_place
                                self.kycDataArr.append(AddKycObj.addkycDetail(kyc_id: kyc_id, kyc_aadhar: kyc_aadhar, kyc_birth_place: birth_place, kyc_fathers_first_name: kyc_fathers_first_name, kyc_fathers_middle_name: kyc_fathers_middle_name, kyc_fathers_last_name: kyc_fathers_last_name, kyc_birth_country: kyc_birth_country))
                                print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                                self.presentWindow.hideToastActivity()
                            
                        }
                    }
                   }
                   else{
                    self.presentWindow.hideToastActivity()
                    self.kyc_id = ""
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
    func getUserNRIDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.getNriDetails)\(covertToBase64(text: userid as! String))/3"
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
                        if let user_nri_id = type.value(forKey: "user_nri_id") as? String,
                            let user_nri_flat_no = type.value(forKey: "user_nri_flat_no") as? String, let user_nri_building_name = type.value(forKey: "user_nri_building_name") as? String , let user_nri_road_street = type.value(forKey: "user_nri_road_street")as? String,let user_nri_address = type.value(forKey: "user_nri_address")as? String,let user_nri_city = type.value(forKey: "user_nri_city") as? String,let user_nri_state = type.value(forKey: "user_nri_state") as? String,let user_nri_country = type.value(forKey: "user_nri_country") as? String,let user_nri_pincode = type.value(forKey: "user_nri_pincode") as? String,let country_name = type.value(forKey: "country_name") as? String,let state_name = type.value(forKey: "state_name") as? String{
                            let city_name = type.value(forKey: "city_name") as? String
                            if city_name ==  nil {
                                self.citytf.text = "NA"
                                self.cityLabel.text = "City"
                                self.citytf.isEnabled = false
                                self.cityBtnOutlet.isHidden = true
                                self.cityBtnImage.isHidden = true
                            } else {
                                self.citytf.text = city_name
                                self.citytf.isEnabled = true
                                self.cityBtnOutlet.isHidden = false
                                self.cityBtnImage.isHidden = false
                            }
                            print(user_nri_id,user_nri_flat_no,user_nri_building_name,user_nri_road_street)
                            self.NriDataArr.append(UserNriObj.addNriDetail(user_nri_id: user_nri_id, user_nri_flat_no: user_nri_flat_no, user_nri_building_name: user_nri_building_name, user_nri_road_street: user_nri_road_street, user_nri_address: user_nri_address, user_nri_city: user_nri_city, user_nri_state: user_nri_state, user_nri_country: user_nri_country, user_nri_pincode: user_nri_pincode))
                            if user_nri_flat_no == "" && user_nri_building_name == "" && user_nri_road_street == "" && user_nri_address == ""{
                                 self.flatNumbertf.text = ""
                                
                            }else {
                               self.flatNumbertf.text = "\(user_nri_flat_no),\(user_nri_building_name),\(user_nri_road_street),\(user_nri_address)"
                            }
                           
                           // self.flatNumbertf.text = user_nri_flat_no
//                            self.bnametf.text = user_nri_building_name
//                            self.roadStreettf.text = user_nri_road_street
//                            self.addresstf.text = user_nri_address
                            self.countrytf.text = country_name
                            self.statetf.text = state_name
                            
                            self.country_ID1 = user_nri_country
                            self.state_ID = user_nri_state
                            self.city_ID =  user_nri_city
                            self.nri_id = user_nri_id
                            if user_nri_pincode == "0"{
                                self.pincodetf.text = ""
                            } else{
                                self.pincodetf.text = user_nri_pincode
                            }
                            
                            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                            
                            
                        }
                    }
                    }
                    else{
                        self.nri_id = ""
                        
                        print("empty")
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
    
    func getUserFatcaDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
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
                //print(response.result.value)
                if let data = data as? [AnyObject]{
                     if !data.isEmpty{
                    for type in data{
                        if let fatca_id = type.value(forKey: "fatca_id") as? String,
                            let fatca_networth = type.value(forKey: "fatca_networth") as? String, let fatca_networth_date = type.value(forKey: "fatca_networth_date") as? String , let fatca_politically_exposed = type.value(forKey: "fatca_politically_exposed") as? String,let fatca_nationality = type.value(forKey: "fatca_nationality") as? String,let fatca_other_nationality = type.value(forKey: "fatca_other_nationality") as? String,let fatca_tax_resident = type.value(forKey: "fatca_tax_resident") as? String ,let fatca_resident_country = type.value(forKey: "fatca_resident_country") as? String,let fatca_tax_player_id = type.value(forKey: "fatca_tax_player_id") as? String,let fatca_id_type = type.value(forKey: "fatca_id_type") as? String,let fatca_resident_country_1 = type.value(forKey: "fatca_resident_country_1") as? String, let fatca_tax_player_id_1 = type.value(forKey: "fatca_tax_player_id_1") as? String,let fatca_id_type_1 = type.value(forKey: "fatca_id_type_1") as? String,let fatca_resident_country_2 = type.value(forKey: "fatca_resident_country_2") as? String,let fatca_tax_player_id_2 = type.value(forKey: "fatca_tax_player_id_2") as? String,let fatca_id_type_2 = type.value(forKey: "fatca_id_type_2") as? String{
                            print(fatca_politically_exposed,fatca_networth,fatca_networth_date,fatca_resident_country_1)
                             print(fatca_id)
                            self.fatca_id = fatca_id
                            print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                            if fatca_politically_exposed == "1"{
                                self.politicallyYes.setImage(UIImage(named: "check"), for: .normal)
                                self.politicallyNo.setImage(UIImage(named: "uncheck"), for: .normal)
                                self.politicallyPEP.setImage(UIImage(named: "uncheck"), for: .normal)
                                self.politically_exposed = "1"
                            }
                            else if fatca_politically_exposed == "2"{
                                self.politicallyYes.setImage(UIImage(named: "uncheck"), for: .normal)
                                self.politicallyNo.setImage(UIImage(named: "check"), for: .normal)
                                self.politicallyPEP.setImage(UIImage(named: "uncheck"), for: .normal)
                                self.politically_exposed = "2"
                            }
                            else if fatca_politically_exposed == "3"{
                                self.politicallyYes.setImage(UIImage(named: "uncheck"), for: .normal)
                                self.politicallyNo.setImage(UIImage(named: "uncheck"), for: .normal)
                                self.politicallyPEP.setImage(UIImage(named: "check"), for: .normal)
                                self.politically_exposed = "3"
                            }
                           self.fatca_detail_flag = true
                            self.fatcaArr.append(FatcaObj.getFatcaDetail(fatcaid: fatca_id, fatca_networth: fatca_networth, fatca_networth_date: fatca_networth_date, fatca_politically_exposed: fatca_politically_exposed, fatca_nationality: fatca_nationality, fatca_other_nationality: fatca_other_nationality, fatca_tax_res: fatca_tax_resident, fatca_resident_country: fatca_resident_country, fatca_resident_country_1: fatca_resident_country_1, fatca_resident_country_2: fatca_resident_country_2, fatca_tax_player_id: fatca_tax_player_id, fatca_tax_player_id_1: fatca_tax_player_id_1, fatca_tax_player_id_2: fatca_tax_player_id_2, fatca_id_type: fatca_id_type , fatca_id_type_1: fatca_id_type_1, fatca_id_type_2: fatca_id_type_2))
                            
                        }
                        
                    }
                    }
                     else{
                        self.fatca_detail_flag = false
                        self.fatca_id = ""
                        self.fatcaArr.append(FatcaObj.getFatcaDetail(fatcaid: "", fatca_networth: "", fatca_networth_date: "", fatca_politically_exposed: "", fatca_nationality: "", fatca_other_nationality: "", fatca_tax_res: "", fatca_resident_country: "", fatca_resident_country_1: "", fatca_resident_country_2: "", fatca_tax_player_id: "", fatca_tax_player_id_1: "", fatca_tax_player_id_2: "", fatca_id_type: "" , fatca_id_type_1: "", fatca_id_type_2: ""))
                        print("empty")
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
                    if data?["status"] != nil && data?["status"] as? String == "Error" {
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
                    //redirect to kyc detail
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
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
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    
    func postUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        presentWindow.makeToastActivity(message: "Saving...")
        //print(country_ID1,state_ID,city_ID)
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id":"\(covertToBase64(text: userid as! String))",
                "name":"\(userDataArr[0].fname!.covertToBase64())",
                "middle_name":"\(userDataArr[0].mname!.covertToBase64())",
                "last_name":"\(userDataArr[0].lname!.covertToBase64())",
                "email":"\(userDataArr[0].email!.covertToBase64())",
                "mobile":"\(userDataArr[0].mobile!.covertToBase64())",
                "landline":"\(userDataArr[0].landline!.covertToBase64())",
                "pan":"\(userDataArr[0].pan!.covertToBase64())",
                "flat_no":"\(userDataArr[0].flat_no!.covertToBase64())",
                "building_name":"\(userDataArr[0].building_name!.covertToBase64())",
                "road_street":"\(userDataArr[0].road_street!.covertToBase64())",
                "address":"\(userDataArr[0].address!.covertToBase64())",
                "dob":"\(userDataArr[0].dob!.covertToBase64())",
                "gender":"\(userDataArr[0].gender!.covertToBase64())",
                "country":"\(userDataArr[0].Country!.covertToBase64())",
                "state":"\(userDataArr[0].State!.covertToBase64())",
                "city":"\(userDataArr[0].City!.covertToBase64())",
                "pincode":"\(userDataArr[0].pincode!.covertToBase64())",
                "salutation":"\(userDataArr[0].salutation!.covertToBase64())",
                "marital_status":"\(marital_Status!.covertToBase64())",
                "spouse_name":"\(spouseNametf.text!.covertToBase64())",
                "guardian_name":"",
                "relation":"",
                "guardian_relation":"",
                "occupation":"\(occupation_id!.covertToBase64())",
                "income_slab":"\(userDataArr[0].IncomeSlabID!.covertToBase64())",
                "residential_status":"\(residential_status!.covertToBase64())",
                "user_location":"\(location_id!.covertToBase64())",
                "user_tax_status":"\(tax_status_id!.covertToBase64())","enc_resp":"3"]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.postUserData)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value)
                    
                    let data = response.result.value as? Bool
                    // print(data!)
                    
                    if data == true {
                        print("updated user data")
                        self.AddKycDetails()
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
    func AddKycDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id":"\(covertToBase64(text: userid as! String))",
                "kycid":"\(kyc_id!.covertToBase64())",
                "kyc_aadhar":"\(kyc_aadhar!.covertToBase64())",
                "kyc_birth_place":"\(placeOfBirthTf.text!.covertToBase64())",
                "kyc_fathers_first_name":"\(ffnametf.text!.covertToBase64())",
                "kyc_fathers_middle_name":"\(fmname.text!.covertToBase64())",
                "kyc_fathers_last_name":"\(flname.text!.covertToBase64())",
                "kyc_birth_country":"","enc_resp":"3"]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addkyc)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    print("&&&&&")
                    
                    if enc == "\"true\"" {
                        
                        print("updated user kyc data")
                        self.AddFatcaDetails()
                      
                    }
                    else{
                         self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Something went wrong")
                        print("error has occured13")
                    }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
      }
    
    func AddFatcaDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
       // presentWindow.makeToastActivity(message: "Saving...")

        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id" : "\(userid!)",
                "fatcaid" : "\(fatca_id!.covertToBase64())",
                "fatca_networth" : "\(fatcaArr[0].fatca_networth!.covertToBase64())",
                "fatca_networth_date" : "\(fatcaArr[0].fatca_networth_date!.covertToBase64())",
                "fatca_politically_exposed" : "\(politically_exposed!.covertToBase64())",
                "fatca_nationality" : "\(fatcaArr[0].fatca_nationality!.covertToBase64())",
                "fatca_other_nationality" : "\(fatcaArr[0].fatca_other_nationality!.covertToBase64())",
                "fatca_tax_res" : "\(fatcaArr[0].fatca_tax_res!.covertToBase64())",
                "fatca_resident_country" : "\(fatcaArr[0].fatca_resident_country!.covertToBase64())",
                "fatca_resident_country_1" : "\(fatcaArr[0].fatca_resident_country_1!.covertToBase64())",
                "fatca_resident_country_2" : "\(fatcaArr[0].fatca_resident_country_2!.covertToBase64())",
                "fatca_tax_player_id" : "\(fatcaArr[0].fatca_tax_player_id!.covertToBase64())",
                "fatca_tax_player_id_1" : "\(fatcaArr[0].fatca_tax_player_id_1!.covertToBase64())",
                "fatca_tax_player_id_2" : "\(fatcaArr[0].fatca_tax_player_id_2!.covertToBase64())",
                "fatca_id_type" : "\(fatcaArr[0].fatca_id_type!.covertToBase64())",
                "fatca_id_type_1" : "\(fatcaArr[0].fatca_id_type_1!.covertToBase64())",
                "fatca_id_type_2" : "\(fatcaArr[0].fatca_id_type_2!.covertToBase64())","enc_resp":"3"]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addFatca)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    
                    if enc == "\"true\"" {
                       // self.presentWindow.hideToastActivity()
                        print("updated user fatca detail")
                        if self.fatca_detail_flag {
                            self.bseRegisteredFlag(userid: userid as! String)
                        } else {
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
                            //self.presentWindow.hideToastActivity()
                            self.navigationController?.pushViewController(destVC, animated: true)
                        }
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Something went wrong")
                        print("error has occured 12")
                    }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func SaveNRIDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        //presentWindow.makeToastActivity(message: "Saving...")
        let address_text = flatNumbertf.text!
        let address_text_split = address_text.split(separator: ",")
        print(address_text_split)
        let flatNo = self.flatNo
        let building_name = self.building_name
        let road_street = self.road_street
        let locality = self.locality
        if Connectivity.isConnectedToInternet{
            print(nri_id,"NRI")
            let parameters = [
                "id":"\(covertToBase64(text: userid as! String))",
                "nri_id":"\(nri_id!.covertToBase64())",
                "nri_flat_no":"\(flatNo.covertToBase64())",
                "nri_building_name":"\(building_name.covertToBase64())",
                "nri_road_street":"\(road_street.covertToBase64())",
                "nri_address":"\(locality.covertToBase64())",
                "nri_country":"\(country_ID1!.covertToBase64())",
                "nri_state":"\(state_ID!.covertToBase64())",
                "nri_city":"\(city_ID!.covertToBase64())",
                "nri_pincode":"\(pincodetf.text!.covertToBase64())","enc_resp":"3"]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addNRiDetails)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    
                    
                    if enc == "true" {
                        print("updated user Nri data")
                        self.postUserData()
                        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == countryTableView{
            return countriesArr.count
        }
        else if tableView == stateTableView{
            return stateArr.count
        }
        else if tableView == locationTableView{
            return locationArr.count
        }
        else if tableView == maritalTableView{
            return marital_status.count
        }
        else if tableView == resedentialTableView{
            return residentialArr.count
        }
        else if tableView == taxTableView{
            return taxStatusArr.count
        }
        else if tableView == occupationTableView{
            return occupationArr.count
        }
        else{
            return cityArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == countryTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
            cell.textLabel?.text = countriesArr[indexPath.row].country_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else if tableView == stateTableView{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "state", for: indexPath)
            if stateArr.count > 0{
             cell.textLabel?.text = stateArr[indexPath.row].State_name ?? ""
            }
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else if tableView == locationTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "location", for: indexPath)
            cell.textLabel?.text = locationArr[indexPath.row].location_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
        else if tableView == maritalTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "marital", for: indexPath)
            cell.textLabel?.text = marital_status[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
        else if tableView == resedentialTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "residential", for: indexPath)
            cell.textLabel?.text = residentialArr[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else if tableView == taxTableView{
            print(taxStatusArr[indexPath.row].taxStatus_name)
            if taxStatusArr.indices.contains(Int(tax_status_id) ?? 0) {
                taxStatus.text = taxStatusArr[Int(tax_status_id) ?? 0].taxStatus_name
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "tax", for: indexPath)
            cell.textLabel?.text = taxStatusArr[indexPath.row].taxStatus_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else if tableView == occupationTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "occupation", for: indexPath)
            cell.textLabel?.text = occupationArr[indexPath.row].occupation_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "city", for: indexPath)
            cell.textLabel?.text = cityArr[indexPath.row].City_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == countryTableView{
            let cell = countryTableView.cellForRow(at: indexPath)
            countrytf.text = cell?.textLabel?.text
            country_ID1 = countriesArr[indexPath.row].country_id
            //print(country_ID)
            self.countryTableView.isHidden = true
            statetf.text = "Select State"
            citytf.text = "Select City"
            if countrytf.text == "Select Country"{
                statetf.text = "Select State"
                citytf.text = "Select City"
                country_ID1 = ""
                state_ID = ""
                getCity1(id:"0")
            }
            getState(id:country_ID1)
        }
        else if tableView == stateTableView{
            let cell = stateTableView.cellForRow(at: indexPath)
            statetf.text = cell?.textLabel?.text
            state_ID = stateArr[indexPath.row].State_id
            self.stateTableView.isHidden = true
            
            citytf.text = "Select City"
            if statetf.text == "Select State"{
                //statetf.text = "Select State"
                citytf.text = "Select City"
            }
            
            getCity1(id:state_ID)
        }
        else if tableView == locationTableView{
            let cell = locationTableView.cellForRow(at: indexPath)
            locationtf.text = cell?.textLabel?.text
            location_id = locationArr[indexPath.row].location_id
            self.locationTableView.isHidden = true
        }
        else if tableView == maritalTableView{
            let cell = maritalTableView.cellForRow(at: indexPath)
            maritalStatus.text = cell?.textLabel?.text
            //location_id = locationArr[indexPath.row].location_id
            if maritalStatus.text == "Married"{
                marital_Status = "married"
                spouseNametf.isEnabled = true
                let attr = [ NSAttributedStringKey.foregroundColor : UIColor.red ]
                let myNewLabelText = NSMutableAttributedString(string: "*", attributes: attr)
                let spouseNames = NSMutableAttributedString(string: "Spouse Name ")
                spouseNames.append(myNewLabelText)
                spouseName.attributedText = spouseNames
                
            } else if maritalStatus.text == "Select"{
                spouseNametf.isEnabled = false
                spouseName.text = "Spouse Name"
            }
            else if maritalStatus.text == "Unmarried"{
                marital_Status = "unmarried"
                spouseNametf.isEnabled = false
                spouseNametf.text = ""
                spouseName.text = "Spouse Name"
            }
            else if maritalStatus.text == "Other"{
                marital_Status = "other"
                spouseNametf.isEnabled = false
                spouseNametf.text = ""
                spouseName.text = "Spouse Name"
            }
            
            self.maritalTableView.isHidden = true
        }
        else if tableView == resedentialTableView{
            let cell = resedentialTableView.cellForRow(at: indexPath)
            residentialStatustf.text = cell?.textLabel?.text

            
            if residentialArr[indexPath.row] == "RES-Resident"{
                
                self.residential_status = "1"
                self.OverseasStackView?.visiblity(gone: true, dimension:0)
                heightConstraint.constant = 600.0
                tax_status_id = ""
                getTaxStatus(id:"1", didSelect: true)
               
            }
            else if residentialArr[indexPath.row] == "NRI-Non Resident"{
                //self.residentialStatustf.text = "NRI-Non Resident"
                self.residential_status = "2"
                tax_status_id = ""
                getTaxStatus(id:"2", didSelect: true)
                self.OverseasStackView?.visiblity(gone: false, dimension:280)
                heightConstraint.constant = 1000.0
                
            }
            else {
                self.residential_status = "3"
                tax_status_id = ""
                getTaxStatus(id:"3", didSelect: true)
                self.OverseasStackView?.visiblity(gone: true, dimension:0)
                heightConstraint.constant = 600.0
            }
            resedentialTableView.isHidden = true
        }
        else if tableView == taxTableView{
            let cell = taxTableView.cellForRow(at: indexPath)
            taxStatus.text = cell?.textLabel?.text
            tax_status_id = taxStatusArr[indexPath.row].taxStatus_id
            self.taxTableView.isHidden = true
            
        }
        else if tableView == occupationTableView {
            let cell = occupationTableView.cellForRow(at: indexPath)
            occupationtf.text = cell?.textLabel?.text
            occupation_id = occupationArr[indexPath.row].occupation_id
            self.occupationTableView.isHidden = true
        }
        else{
            let cell = cityTableView.cellForRow(at: indexPath)
            citytf.text = cell?.textLabel?.text
            city_ID = cityArr[indexPath.row].City_id
            self.cityTableView.isHidden = true
            self.OverseasStackView?.visiblity(gone: false, dimension:280)
            
        }
    }
    
    @IBAction func countryBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Other Details Screen :- Country Button Clicked")
        self.countryTableView.isHidden = !self.countryTableView.isHidden
        
        self.stateTableView.isHidden = true
        self.cityTableView.isHidden = true
        self.locationTableView.isHidden = true
        self.maritalTableView.isHidden = true
        self.resedentialTableView.isHidden = true
        self.taxTableView.isHidden = true
    }
    @IBAction func stateBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Other Details Screen :- State Button Clicked")
        self.stateTableView.isHidden = !self.stateTableView.isHidden
        
        self.countryTableView.isHidden = true
        self.cityTableView.isHidden = true
        self.locationTableView.isHidden =  true
        self.maritalTableView.isHidden = true
        self.resedentialTableView.isHidden = true
        self.taxTableView.isHidden = true
        print(country_ID1)
        //self.getState(id: country_ID1!)
    }
    
    @IBAction func cityBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Other Details Screen :- City Button Clicked")
        self.cityTableView.isHidden = !self.cityTableView.isHidden
        self.countryTableView.isHidden = true
        self.stateTableView.isHidden = true
        self.locationTableView.isHidden =  true
        self.maritalTableView.isHidden = true
        self.resedentialTableView.isHidden = true
        self.taxTableView.isHidden = true
        
        if self.cityTableView.isHidden == false {
            self.OverseasStackView?.visiblity(gone: false, dimension:480)
        }
        else{
            self.OverseasStackView?.visiblity(gone: false, dimension:280)
        }
       // getState(id: state_ID)
    }
    @IBAction func locationBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Other Details Screen :- Location Button Clicked")
        self.locationTableView.isHidden = !self.locationTableView.isHidden
        
        self.countryTableView.isHidden = true
        self.cityTableView.isHidden = true
        self.stateTableView.isHidden = true
        self.maritalTableView.isHidden = true
        self.resedentialTableView.isHidden = true
        self.taxTableView.isHidden = true
        self.occupationTableView.isHidden  = true
    }
    
    @IBAction func maritalBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Other Details Screen :- Marital Satus Button Clicked")
        self.maritalTableView.isHidden = !self.maritalTableView.isHidden
        
        self.countryTableView.isHidden = true
        self.cityTableView.isHidden = true
        self.stateTableView.isHidden = true
        self.locationTableView.isHidden =  true
        self.resedentialTableView.isHidden = true
        self.taxTableView.isHidden = true
        self.occupationTableView.isHidden  = true
    }
    
    @IBAction func resedentialBtnPrsd(_ sender: Any) {
         Mixpanel.mainInstance().track(event: "Other Details Screen :- Residential Satus Button Clicked")
        self.resedentialTableView.isHidden = !self.resedentialTableView.isHidden
        
        self.countryTableView.isHidden = true
        self.cityTableView.isHidden = true
        self.stateTableView.isHidden = true
        self.locationTableView.isHidden =  true
        self.maritalTableView.isHidden = true
        self.taxTableView.isHidden = true
        self.occupationTableView.isHidden  = true
    }
    @IBAction func taxBtnPrsd(_ sender: Any) {
         Mixpanel.mainInstance().track(event: "Other Details Screen :- Tax Satus Button Clicked")
        self.taxTableView.isHidden = !self.taxTableView.isHidden
        
        self.countryTableView.isHidden = true
        self.cityTableView.isHidden = true
        self.stateTableView.isHidden = true
        self.locationTableView.isHidden =  true
        self.maritalTableView.isHidden = true
        self.resedentialTableView.isHidden = true
        self.occupationTableView.isHidden  = true
    }
    @IBAction func occupationBtnPrsd(_ sender: Any) {
         Mixpanel.mainInstance().track(event: "Other Details Screen :- Occupation Button Clicked")
        self.occupationTableView.isHidden = !self.occupationTableView.isHidden
        
        self.countryTableView.isHidden = true
        self.cityTableView.isHidden = true
        self.stateTableView.isHidden = true
        self.locationTableView.isHidden =  true
        self.maritalTableView.isHidden = true
        self.resedentialTableView.isHidden = true
        self.taxTableView.isHidden = true
    }
}
