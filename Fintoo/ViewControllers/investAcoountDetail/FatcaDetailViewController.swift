//
//  FatcaDetailViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 29/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import  FlexibleSteppedProgressBar
import Alamofire
import FSCalendar
import Mixpanel

class FatcaDetailViewController: BaseViewController,FlexibleSteppedProgressBarDelegate,UITextFieldDelegate,FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var datebtnOutlet: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var countryTableView: UITableView!
    
    @IBOutlet weak var grossAnnualIncomeLbl: UILabel!
    @IBOutlet weak var grossAnnualIncomeTableView: UITableView!
    
    @IBOutlet weak var nationalityTableView: UITableView!
    
    @IBOutlet weak var country1View: UIView!
   
    @IBOutlet weak var OtherTableView: UITableView!
    
    
    @IBOutlet weak var country1TableView: UITableView!
    
    @IBOutlet weak var country2TableView: UITableView!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var natinalitytf: UITextField!
    
    @IBOutlet weak var otherCountrytf: UITextField!
    
    @IBOutlet weak var grossAnnualIncometf: UITextField!
    
    @IBOutlet weak var networthlbl: UILabel!
    @IBOutlet weak var networthtf: UITextField!
    
    @IBOutlet weak var datetf: UITextField!
    @IBOutlet weak var datetflbl: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    
    @IBOutlet weak var expandableCountryView: UIView!
    
    @IBOutlet weak var addViewOutlet: UIButton!
    
    
    @IBOutlet weak var countryTf: UITextField!
    
    @IBOutlet weak var taxPayertf: UITextField!
    
    @IBOutlet weak var identificationtypetf: UITextField!
    
    @IBOutlet weak var country1tf: UITextField!
    
    @IBOutlet weak var taxpayer1tf: UITextField!
    
    @IBOutlet weak var identificationtype1tf: UITextField!
    
    @IBOutlet weak var country2tf: UITextField!
    
    @IBOutlet weak var taxpayer2tf: UITextField!
    
    @IBOutlet weak var otherBtn: UIButton!
    
    @IBOutlet weak var identificationtype2tf: UITextField!
    
    @IBOutlet weak var yesbtnOutlet: UIButton!
    @IBOutlet weak var grossbtn: UIButton!
    
    @IBOutlet weak var nobtnOutlet: UIButton!
    
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    let pickerView = UIPickerView()
    var bool_value : Bool!
    var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    var progressColor = UIColor(red: 45.0 / 255.0, green: 180.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var bgcolor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    var maxIndex = -1
    var userDataArr = [UserDataObj]()
    var countriesArr = [CountriesObj]()
    var slabArr = [SlabObj]()
    var fatcaArr = [FatcaObj]()
    var nationalityArr = ["Select Country","Indian","Other"]
    var slabId : String!
    var countryID : String!
    var country_ID = ""
    var country_ID_1 = ""
    var country_ID_2 = ""
    var fatca_resident_country : String!
    var fatca_resident_country_1 : String!
    var fatca_resident_country_2 : String!
    var fatca_id : String!
    var nationality_id : String!
    var fatca_tax_res : String!
    var fatca_detail_flag = false
    var personal_details_alert = false
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //calendar.appearance.titleWeekendColor = .red
        //calendar.appearance.week
        identificationtypetf.delegate = self
        identificationtype1tf.delegate = self
        identificationtype2tf.delegate = self
        
        taxPayertf.delegate = self
        taxpayer1tf.delegate = self
        taxpayer2tf.delegate = self
        
        if natinalitytf.text == "Other"{
            otherCountrytf.isEnabled = true
        }
        let textViewRecognizer = UITapGestureRecognizer()
        textViewRecognizer.addTarget(self, action: #selector(tappedTextView(_:)))
        datetf.addGestureRecognizer(textViewRecognizer)
        getUserData()
        getUserFatcaDetails()
        fatca_tax_res = "2"
        countryID = ""
        addBackbutton()
        getIncomeSlabList()
        
        
        bool_value = true
        expandableCountryView.visiblity(gone: true, dimension:0)
        country1View.visiblity(gone: true, dimension: 0)
        heightConstraint.constant = 470.0
       
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
        progressBar.completedTillIndex = 4
        progressBar.useLastState = true
        
        progressBar.lastStateCenterColor = progressColor
        progressBar.selectedBackgoundColor = progressColor
        
        progressBar.selectedOuterCircleStrokeColor = backgroundColor
        progressBar.lastStateOuterCircleStrokeColor = backgroundColor
        progressBar.currentSelectedCenterColor = progressColor
        progressBar.currentSelectedTextColor = progressColor
        progressBar.stepTextColor = textColorHere
        progressBar.currentIndex = 4
        
        calendar.delegate = self
        calendar.dataSource = self
        networthtf.delegate = self
        natinalitytf.delegate = self
        otherCountrytf.delegate = self
        grossAnnualIncometf.delegate = self
        grossAnnualIncometf.text = "Select Slab"
        nationalityTableView.isHidden = true
        OtherTableView.isHidden = true
        countryTableView.isHidden = true
        country1TableView.isHidden = true
        country2TableView.isHidden = true
        grossAnnualIncomeTableView.isHidden = true
        
        nationalityTableView.delegate = self
        nationalityTableView.dataSource = self
        
        OtherTableView.delegate = self
        OtherTableView.dataSource = self
        
        countryTableView.delegate = self
        countryTableView.dataSource = self
        
        country1TableView.delegate = self
        country1TableView.dataSource = self
        
        country2TableView.delegate = self
        country2TableView.dataSource = self
        
        grossAnnualIncomeTableView.delegate = self
        grossAnnualIncomeTableView.dataSource = self
        
        
        
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Back Button Clicked")
        navigationController?.popViewController(animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        getCountries()
    }
    @objc func tappedTextView(_ sender: UITapGestureRecognizer) {
        
        print("detected tap!")
        
       calendar.isHidden = false
        let point = CGPoint(x: 0, y: 0) // 200 or any value you like.
        scrollView.contentOffset = point
        countryTf.isUserInteractionEnabled = false
        
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
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == taxpayer1tf || textField == taxPayertf || textField == taxpayer2tf || textField == identificationtypetf || textField == identificationtype1tf || textField == identificationtype2tf {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        return true
    }
    
    @IBAction func addview(_ sender: Any) {
        if bool_value == true{
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Minimize Button Clicked")
            addViewOutlet.setTitle("-", for: .normal)
            expandableCountryView.visiblity(gone: false, dimension:344)
            heightConstraint.constant = 1050.0
            bool_value = false
        }
        else{
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Expand Button Clicked")
            addViewOutlet.setTitle("+", for: .normal)
            expandableCountryView.visiblity(gone: true, dimension:0)
            heightConstraint.constant = 750.0
            bool_value = true
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag,"textfield")
        if calendar.isHidden != false  {
            if textField == natinalitytf{
                natinalitytf.inputView = pickerView
                pickerView.tag = 1
            }
            else if textField == otherCountrytf{
                otherCountrytf.inputView = pickerView
                pickerView.tag = 2
            }
            else if textField == grossAnnualIncometf{
                grossAnnualIncometf.inputView = pickerView
                pickerView.tag = 3
            }
            else if textField == datetf {
               // resignFirstResponder()
                calendar.isHidden = false
            }
        } else {
            
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("textFieldDidEndEditing detected")
        //if textField == residentialStatustf{
        if textField == natinalitytf {
            if natinalitytf.text! == "Other" {
                otherCountrytf.isEnabled = true
                otherBtn.isUserInteractionEnabled = true
            }
            else if natinalitytf.text! == "Indian"{
                otherCountrytf.isEnabled = false
                 otherBtn.isUserInteractionEnabled = false
                //otherCountrytf.text = ""
            }
            
        }
        else if textField == networthtf{
            if networthtf.text == ""{
                grossAnnualIncometf.isEnabled = true
                grossbtn.isUserInteractionEnabled = true
            }
            else{
                grossAnnualIncometf.isEnabled = false
                grossbtn.isUserInteractionEnabled = false
            }
        }
        else if textField == grossAnnualIncometf{
            if grossAnnualIncometf.text == "Select Slab"{
                networthtf.isEnabled = true
                datetf.isEnabled = true
            }
            else{
                networthtf.isEnabled = false
                datetf.isEnabled = false
            }
        }
       
    }
   
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
      
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        datetf.text = formatter.string(from: date)
        calendar.isHidden = true
        countryTf.isUserInteractionEnabled = true
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date().startOfMonth()
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }

    
    @IBAction func yes(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- Yes Button Clicked")
         nobtnOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
         yesbtnOutlet.setImage(UIImage(named: "check"), for: .normal)
        fatca_tax_res = "1"
         country1View.visiblity(gone: false, dimension: 190)
        heightConstraint.constant = 700.0
        let point = CGPoint(x: 0, y: 500) // 200 or any value you like.
        scrollView.contentOffset = point
    }
    @IBAction func No(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- No Button Clicked")
        nobtnOutlet.setImage(UIImage(named: "check"), for: .normal)
        yesbtnOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        fatca_tax_res = "2"
        country1View.visiblity(gone: true, dimension: 0)
        heightConstraint.constant = 470.0
    }
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        print(userid ?? "")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
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
                self.presentWindow.hideToastActivity()
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
                            //let income_slab = (abc as AnyObject).value(forKey: "income_slab") as? String
                            let IncomeSlabID = (abc as AnyObject).value(forKey: "IncomeSlabID") as? String
                            var income_slab = (abc as AnyObject).value(forKey: "income_slab") as? String
                            let income_slab_id = (abc as AnyObject).value(forKey: "IncomeSlabID") as? String
                            if income_slab_id == "0" {
                                income_slab = ""
                            }
                            self.grossAnnualIncometf.text = income_slab!
                            if self.grossAnnualIncometf.text != ""{
                                print("gross value here \(income_slab)")
                                self.networthtf.isEnabled = false
                                self.datetf.isEnabled = false
                                self.datebtnOutlet.isUserInteractionEnabled = false
                                //self.datetf.isEnabled = false
                                self.grossAnnualIncomeLbl.text = "Gross Annual Income*"
                                let rangeGrossIn = (self.grossAnnualIncomeLbl.text! as NSString).range(of: "*")
                                let attributedString = NSMutableAttributedString(string:self.grossAnnualIncomeLbl.text!)
                                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: rangeGrossIn)
                                self.grossAnnualIncomeLbl.attributedText = attributedString
                            }
                            self.slabId = IncomeSlabID!
                            self.userDataArr.append(UserDataObj.getUserData(salutation: salutations!, fname: fname!, mname: mname!, lname: lname!, gender: gender1!, dob: dob!, mobile: mobile!, landline: landline!, email: email!, aadhar: "", pan: pan!, flat_no: flat_no!, building_name: building_name!, road_street: road_street!, address: address!, Country: country!, State:state!, City: city!, pincode:pincode!, occupation: occupation!, location: location!, marital_status: marital_status!, spouse_name: spouse_name!, residential_status: residential_status!, user_tax_status: user_tax_status!, tax_slab: income_slab!, IncomeSlabID: income_slab_id!))
                            
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
    func  getCountries(){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
//        if natinalitytf.text = "Other"
        let url = "\(Constants.BASE_URL)\(Constants.API.country)/3"
        print(url)
        self.countriesArr.append(CountriesObj.getuserdata(country_name: "Select Country", country_id: "0"))
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
                    if !data.isEmpty {
                        for type in data{
                            if let countryName = type.value(forKey: "country_name") as? String,
                                let countryId = type.value(forKey: "country_id") as? String{
                                if countryName != "India" &&  countryName != "Canada" && countryName != "United States"{
                                    if self.countryID == countryId {
                                        print(countryName)
                                        self.otherCountrytf.text = countryName
                                    }
                                    if self.fatca_resident_country_1 == countryId{
                                        self.country1tf.text = countryName
                                    }
                                    if self.fatca_resident_country_2 == countryId{
                                        self.country2tf.text = countryName
                                    }
                                    if self.fatca_resident_country == countryId{
                                        print(countryName)
                                        self.countryTf.text = countryName
                                    }
                                    self.countriesArr.append(CountriesObj.getuserdata(country_name: countryName, country_id: countryId))
                                    self.OtherTableView.reloadData()
                                    self.countryTableView.reloadData()
                                    self.country1TableView.reloadData()
                                    self.country2TableView.reloadData()
                                }
                                
                            }
                        }
                        // print(self.countriesArr)
                    }
                    else{
                        print("empty")
                    }
               }
               else{
                    
                }
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getIncomeSlabList(){
        let url = "\(Constants.BASE_URL)\(Constants.API.getIncomeSlabList)/3"
        self.slabArr.append(SlabObj.getIncomeSlab(IncomeSlabName: "Select Slab", IncomeSlabID: "00"))
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
                        if let IncomeSlabName = type.value(forKey: "IncomeSlabName") as? String,
                            let IncomeSlabID = type.value(forKey: "IncomeSlabID") as? String{
                            self.slabArr.append(SlabObj.getIncomeSlab(IncomeSlabName: IncomeSlabName, IncomeSlabID: IncomeSlabID))
                        }
                    }
                    self.grossAnnualIncomeTableView.reloadData()
                    //print(slabArr.count)
                   
                }
                
            }
         }
        else{
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
                                
                                self.countryID = fatca_other_nationality
                                self.country_ID = fatca_resident_country
                                self.country_ID_1 = fatca_resident_country_1
                                self.country_ID_2 = fatca_resident_country_2
                                
                                self.nationality_id = fatca_nationality
                                self.fatca_resident_country = fatca_resident_country
                                self.fatca_resident_country_1 = fatca_resident_country_1
                                self.fatca_resident_country_2 =  fatca_resident_country_2
                                print(self.countryID!)
                                print(fatca_politically_exposed,fatca_networth,fatca_networth_date,fatca_resident_country_1)
                                self.fatca_id = fatca_id
                                
                                if fatca_nationality == "indian"{
                                    self.natinalitytf.text! = "Indian"
                                    self.otherBtn.isUserInteractionEnabled = false
                                }
                                else{
                                    self.natinalitytf.text! = "Other"
                                    self.otherCountrytf.isEnabled = true
                                }
                                if fatca_networth == "0"{
                                    self.networthtf.text = ""
                                } else{
                                    self.networthtf.text = fatca_networth
                                }
                                if fatca_networth_date == "0000-00-00"{
                                    self.datetf.text = ""
                                } else {
                                    self.datetf.text = fatca_networth_date
                                }
                                self.taxPayertf.text = fatca_tax_player_id
                                self.taxpayer1tf.text = fatca_tax_player_id_1
                                self.taxpayer2tf.text = fatca_tax_player_id_2
                                self.identificationtypetf.text = fatca_id_type
                                self.identificationtype1tf.text = fatca_id_type_1
                                self.identificationtype2tf.text = fatca_id_type_2
                                if self.networthtf.text != ""{
                                    self.grossbtn.isUserInteractionEnabled = false
                                    self.grossAnnualIncometf.isEnabled = false
                                }
                                else{
                                    self.grossbtn.isUserInteractionEnabled = true
                                    self.grossAnnualIncometf.isEnabled = true
                                }
                                if fatca_tax_resident == "1"{
                                    self.yesbtnOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                                    self.nobtnOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                                    self.fatca_tax_res = "1"
                                    self.country1View.visiblity(gone: false, dimension: 190)
                                    self.heightConstraint.constant = 700.0
                                    let point = CGPoint(x: 0, y: 500) // 200 or any value you like.
                                    self.scrollView.contentOffset = point
                                }
                                else{
                                    self.nobtnOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                                    self.yesbtnOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                                    self.fatca_tax_res = "2"
                                    self.country1View.visiblity(gone: true, dimension: 0)
                                    self.heightConstraint.constant = 470.0

                                }
                                self.fatca_detail_flag = true
                                if self.countryID != "" {
                                    self.getCountries()
                                }
                                print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
                                self.fatcaArr.append(FatcaObj.getFatcaDetail(fatcaid: fatca_id, fatca_networth: fatca_networth, fatca_networth_date: fatca_networth_date, fatca_politically_exposed: fatca_politically_exposed, fatca_nationality: fatca_nationality, fatca_other_nationality: fatca_other_nationality, fatca_tax_res: fatca_tax_resident, fatca_resident_country: fatca_resident_country, fatca_resident_country_1: fatca_resident_country_1, fatca_resident_country_2: fatca_resident_country_2, fatca_tax_player_id: fatca_tax_player_id, fatca_tax_player_id_1: fatca_tax_player_id_1, fatca_tax_player_id_2: fatca_tax_player_id_2, fatca_id_type: fatca_id_type , fatca_id_type_1: fatca_id_type_1, fatca_id_type_2: fatca_id_type_2))
                              //  natinalitytf.text = ""
                               
                                
                            }
                        }
                    }
                    else{
                        self.fatca_detail_flag = false
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
    func AddFatcaDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Saving...")
        print(nationality_id)
        print(fatca_id)
        if fatca_id == nil{
            fatca_id = ""
        }
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id" : "\(covertToBase64(text: userid as! String))",
                "fatcaid" : "\(fatca_id!.covertToBase64())",
                "fatca_networth" : "\(networthtf.text!.covertToBase64())",
                "fatca_networth_date" : "\(datetf.text!.covertToBase64())",
                "fatca_politically_exposed" : "\(fatcaArr[0].fatca_politically_exposed!.covertToBase64())",
                "fatca_nationality" : "\(nationality_id!.covertToBase64())",
                "fatca_other_nationality" : "\(countryID!.covertToBase64())",
                "fatca_tax_res" : "\(fatca_tax_res!.covertToBase64())",
                "fatca_resident_country" : "\(country_ID.covertToBase64())",
                "fatca_resident_country_1" : "\(country_ID_1.covertToBase64())",
                "fatca_resident_country_2" : "\(country_ID_2.covertToBase64())",
                "fatca_tax_player_id" : "\(taxPayertf.text!.covertToBase64())",
                "fatca_tax_player_id_1" : "\(taxpayer1tf.text!.covertToBase64())",
                "fatca_tax_player_id_2" : "\(taxpayer2tf.text!.covertToBase64())",
                "fatca_id_type" : "\(identificationtypetf.text!.covertToBase64())",
                "fatca_id_type_1" : "\(identificationtype1tf.text!.covertToBase64())",
                "fatca_id_type_2" : "\(identificationtype2tf.text!.covertToBase64())",
                "enc_resp":"3"]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addFatca)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    
                    if enc == "\"true\"" {
                        print("updated user fatca detail")
                       // UserDataViewController
                        if self.fatca_detail_flag {
                            self.bseRegisteredFlag(userid: userid as! String)
                        } else {
                            self.presentWindow.makeToast(message: "Personal Detail Saved Successfully")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "BankDetailViewController") as! BankDetailViewController
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
                        
                    }
                    else{
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
    func clientregistrationBse(userid:String){
        print("Modify ucc data")
        //https://www.financialhospital.in/adminpanel/bse/bse_ws.php/clientregistration/userid
        let url = "\(Constants.BASE_URL)\(Constants.API.clientregistration)\(userid)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value as? [String:Any]
                if let response_status = data?["response"] {
                    if data?["status"] != nil && data?["status"] as? String  == "Error" {
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
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "BankDetailViewController") as! BankDetailViewController
                    self.navigationController?.pushViewController(controller, animated: true)
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
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "BankDetailViewController") as! BankDetailViewController
                        self.navigationController?.pushViewController(controller, animated: true)
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
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Saving...")
//        print(userDataArr[0].City)
//        print(userDataArr[0].State)
        //print(country_ID1,state_ID,city_ID)
        print(slabId)
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
                "marital_status":"\(userDataArr[0].marital_status!.covertToBase64())",
                "spouse_name":"\(userDataArr[0].spouse_name!.covertToBase64())",
                "guardian_name":"",
                "relation":"",
                "guardian_relation":"",
                "occupation":"\(userDataArr[0].occupation!.covertToBase64())",
                "income_slab":"\(slabId!.covertToBase64())",
                "residential_status":"\(userDataArr[0].residential_status!.covertToBase64())",
                "user_location":"\(userDataArr[0].location!.covertToBase64())",
                "user_tax_status":"\(userDataArr[0].user_tax_status!.covertToBase64())",
                "enc_resp":"3"]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.postUserData)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value ?? "")
                    self.presentWindow.hideToastActivity()
                    let data = response.result.value as? Bool
                    // print(data!)
                    
                    if data == true {
                        print("updated user data")
                        //self.AddKycDetails()
                    }
                    else{
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
    @IBAction func save(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- Save Button Clicked")
        if natinalitytf.text == "Select Country"{
            presentWindow.makeToast(message: "Please Select Nationality")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Select Nationality")
        }
        else if natinalitytf.text == "Other" && otherCountrytf.text == "Select Country"{
            
            presentWindow.makeToast(message: "Please Select Other Nationality")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Select Other Nationality")
        }
        else if networthtf.isEnabled && networthtf.text == "" {
            presentWindow.makeToast(message: "Please Enter Networth in Rs")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Enter Networth in Rs")
        }
        else if networthtf.isEnabled && networthtf.text == "0" {
            presentWindow.makeToast(message: "Please Enter Networth in Rs")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Enter Networth in Rs")
        }
        else if datetf.isEnabled && datetf.text == "" {
             presentWindow.makeToast(message: "Please Select Date")
             Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Select Date")
        }
        else if grossAnnualIncometf.isEnabled && grossAnnualIncometf.text == "Select Slab"{
            presentWindow.makeToast(message: "Please Select Gross Annual Income")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Select Gross Annual Income")

        }
        else if yesbtnOutlet.currentImage == #imageLiteral(resourceName: "check") && countryTf.text == "Select Country"{
            presentWindow.makeToast(message: "Please Select Country")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Select Country")
        }
        else if yesbtnOutlet.currentImage == #imageLiteral(resourceName: "check") && taxPayertf.text == ""{
            presentWindow.makeToast(message: "Please Enter Tax Payer ID Number")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Enter Tax Payer ID Number")
        }
        else if yesbtnOutlet.currentImage == #imageLiteral(resourceName: "check") && taxPayertf.text == "0"{
            presentWindow.makeToast(message: "Please Enter Tax Payer ID Number")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Enter Tax Payer ID Number")
        }
        else if yesbtnOutlet.currentImage == #imageLiteral(resourceName: "check") && identificationtypetf.text == ""{
            presentWindow.makeToast(message: "Please Enter Identification Type")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Enter Identification Type")
        }
        else if yesbtnOutlet.currentImage == #imageLiteral(resourceName: "check") && country1tf.text != "Select Country" && taxpayer1tf.text == ""{
            presentWindow.makeToast(message: "Please Enter Tax Payer ID Number")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Enter Tax Payer ID Number")
        }
        else if yesbtnOutlet.currentImage == #imageLiteral(resourceName: "check") && country1tf.text != "Select Country" && identificationtype1tf.text == ""{
            presentWindow.makeToast(message: "Please Enter Identification Type")
             Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Enter Identification Type")
        }
        else if yesbtnOutlet.currentImage == #imageLiteral(resourceName: "check") && country2tf.text != "Select Country" && taxpayer2tf.text == ""{
            presentWindow.makeToast(message: "Please Enter Tax Payer ID Number")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Enter Tax Payer ID Number")
        }
        else if yesbtnOutlet.currentImage == #imageLiteral(resourceName: "check") && country2tf.text != "Select Country" && identificationtype2tf.text == ""{
            presentWindow.makeToast(message: "Please Enter Identification Type")
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Please Enter Identification Type")
        }
        else{
           AddFatcaDetails()
           postUserData()
        }

    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == nationalityTableView{
            return nationalityArr.count
        }
        else if tableView == OtherTableView{
            return countriesArr.count
        }
        else if tableView == countryTableView{
            return countriesArr.count
        }
        else if tableView == country1TableView{
            return countriesArr.count
        }
        else if tableView == grossAnnualIncomeTableView{
            return slabArr.count
        }
        else{
            return countriesArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == nationalityTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "nationality", for: indexPath)
            cell.textLabel?.text = nationalityArr[indexPath.row]
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
        else if tableView == OtherTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "other", for: indexPath)
            cell.textLabel?.text = countriesArr[indexPath.row].country_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
        else if tableView == countryTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
            cell.textLabel?.text = countriesArr[indexPath.row].country_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
        else if tableView == country1TableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "country1", for: indexPath)
            cell.textLabel?.text = countriesArr[indexPath.row].country_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
        else if tableView == grossAnnualIncomeTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "gross", for: indexPath)
            cell.textLabel?.text = slabArr[indexPath.row].IncomeSlabName
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "country2", for: indexPath)
            cell.textLabel?.text = countriesArr[indexPath.row].country_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == nationalityTableView{
            let cell = nationalityTableView.cellForRow(at: indexPath)
            natinalitytf.text = cell?.textLabel?.text
            if natinalitytf.text! == "Other" {
                Mixpanel.mainInstance().track(event: "FATCA Screen :- Nationality : Other Clicked")
                otherCountrytf.text = "Select Country"
                otherCountrytf.isEnabled = true
                nationality_id = "other"
                otherBtn.isUserInteractionEnabled = true
            }
            else if natinalitytf.text! == "Indian"{
                Mixpanel.mainInstance().track(event: "FATCA Screen :- Nationality : Indian Clicked")
                otherCountrytf.isEnabled = false
                otherBtn.isUserInteractionEnabled = false
                nationality_id = "indian"
                countryID = ""
                otherCountrytf.text = ""
            } else {
                Mixpanel.mainInstance().track(event: "FATCA Screen :- Nationality : Indian Clicked")
                otherCountrytf.isEnabled = false
                otherBtn.isUserInteractionEnabled = false
                countryID = ""
                otherCountrytf.text = ""
            }
            self.nationalityTableView.isHidden = true
            
        }
        else if tableView == OtherTableView{
            let cell = OtherTableView.cellForRow(at: indexPath)
            otherCountrytf.text = cell?.textLabel?.text
            countryID = countriesArr[indexPath.row].country_id
            print(countryID)
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Other Nationality : \(otherCountrytf.text!) Clicked")
            self.OtherTableView.isHidden = true
        }
        else if tableView == countryTableView{
            let cell = countryTableView.cellForRow(at: indexPath)
            countryTf.text = cell?.textLabel?.text
            country_ID = countriesArr[indexPath.row].country_id!
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Country : \(countryTf.text!) Clicked")
            self.countryTableView.isHidden = true
        }
        else if tableView == country1TableView{
            let cell = country1TableView.cellForRow(at: indexPath)
            country1tf.text = cell?.textLabel?.text
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Country : \(country1tf.text!) Clicked")
            country_ID_1 = countriesArr[indexPath.row].country_id!
            self.country1TableView.isHidden = true
        }
        else if tableView == grossAnnualIncomeTableView{
            let cell = grossAnnualIncomeTableView.cellForRow(at: indexPath)
            grossAnnualIncometf.text = cell?.textLabel?.text
            slabId = slabArr[indexPath.row].IncomeSlabID
            if grossAnnualIncometf.text == "Select Slab"{
                print("here - select slab")
                networthtf.isEnabled = true
                datetf.isEnabled = true
                datebtnOutlet.isUserInteractionEnabled = true
                networthlbl.text = "Networth in Rs*"
                datetflbl.text = "As of (Date)*"
                grossAnnualIncomeLbl.text = "Gross Annual Income"
                
                let range = (networthlbl.text! as NSString).range(of: "*")
                let attributedString = NSMutableAttributedString(string:networthlbl.text!)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: range)
                networthlbl.attributedText = attributedString
                
                let rangedate = (datetflbl.text! as NSString).range(of: "*")
                let attributedStringdate = NSMutableAttributedString(string:datetflbl.text!)
                attributedStringdate.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: rangedate)
                datetflbl.attributedText = attributedStringdate
                
                
            }
            else{
                networthtf.text = ""
                datetf.text = ""
                networthtf.isEnabled = false
                datetf.isEnabled = false
                datebtnOutlet.isUserInteractionEnabled = false
                networthlbl.text = "Networth in Rs"
                datetflbl.text = "As of (Date)"
                grossAnnualIncomeLbl.text = "Gross Annual Income*"
                
                let rangeGrossIn = (grossAnnualIncomeLbl.text! as NSString).range(of: "*")
                let attributedString = NSMutableAttributedString(string:grossAnnualIncomeLbl.text!)
                attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.red, range: rangeGrossIn)
                grossAnnualIncomeLbl.attributedText = attributedString
            }
            self.grossAnnualIncomeTableView.isHidden = true
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Gross Annual Income : \(grossAnnualIncometf.text!) Clicked")
        }
        
        else{
            let cell = country2TableView.cellForRow(at: indexPath)
            country2tf.text = cell?.textLabel?.text
            country_ID_2 = countriesArr[indexPath.row].country_id!
            self.country2TableView.isHidden = true
            Mixpanel.mainInstance().track(event: "FATCA Screen :- Country : \(country2tf.text!) Clicked")
            
        }
    }
    
    
    
    
    @IBAction func otherBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- Other Dropdown Button Clicked")
      //  getCountries()
        OtherTableView.isHidden = !OtherTableView.isHidden
        print(countriesArr.count)
        nationalityTableView.isHidden = true
        countryTableView.isHidden = true
        country1TableView.isHidden = true
        country2TableView.isHidden = true
        calendar.isHidden = true
        grossAnnualIncomeTableView.isHidden = true
    }
    @IBAction func nationalityBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- Nationality Dropdown Button Clicked")
        nationalityTableView.isHidden = !nationalityTableView.isHidden
        
        OtherTableView.isHidden = true
        countryTableView.isHidden = true
        country1TableView.isHidden = true
        country2TableView.isHidden = true
        calendar.isHidden = true
        grossAnnualIncomeTableView.isHidden = true
    }
    @IBAction func dateBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- Date  Button Clicked")
        scrollView.scrollToTop(animated: false)
        
        calendar.isHidden = !calendar.isHidden
        nationalityTableView.isHidden = true
        countryTableView.isHidden = true
        country1TableView.isHidden = true
        country2TableView.isHidden = true
        OtherTableView.isHidden = true
       grossAnnualIncomeTableView.isHidden = true
        
        
    }
    
    @IBAction func CountryBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- Country Button Clicked")
        countryTableView.isHidden = !countryTableView.isHidden
        
        nationalityTableView.isHidden = true
        OtherTableView.isHidden = true
        country1TableView.isHidden = true
        country2TableView.isHidden = true
        calendar.isHidden = true
        grossAnnualIncomeTableView.isHidden = true
    }
    @IBAction func Country1BtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- Country Button Clicked")
        country1TableView.isHidden = !country1TableView.isHidden
        
        nationalityTableView.isHidden = true
        OtherTableView.isHidden = true
        countryTableView.isHidden = true
        country2TableView.isHidden = true
        calendar.isHidden = true
        grossAnnualIncomeTableView.isHidden = true
    }
    @IBAction func Country2BtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- Country Button Clicked")
        country2TableView.isHidden = !country2TableView.isHidden
        
        nationalityTableView.isHidden = true
        OtherTableView.isHidden = true
        country1TableView.isHidden = true
        countryTableView.isHidden = true
        calendar.isHidden = true
        grossAnnualIncomeTableView.isHidden = true
    }
    
    @IBAction func grossbtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "FATCA Screen :- Gross Annual Income Button Clicked")
        grossAnnualIncomeTableView.isHidden = !grossAnnualIncomeTableView.isHidden
        
        nationalityTableView.isHidden = true
        OtherTableView.isHidden = true
        country1TableView.isHidden = true
        countryTableView.isHidden = true
        calendar.isHidden = true
        country2TableView.isHidden = true
        
    }
}
extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
