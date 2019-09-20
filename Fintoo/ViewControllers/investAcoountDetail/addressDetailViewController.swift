//
//  addressDetailViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 17/04/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import Alamofire
import Mixpanel
class addressDetailViewController: BaseViewController,FlexibleSteppedProgressBarDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    
    
    @IBOutlet weak var cityBtnOutlet: UIButton!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    //var arrUserData:[MyDetailObj]!
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789/-, "
    let ACCEPTABLE_CHARACTERS1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    //getting data from personal detail
    var country_ID : String!
    var country_ID1 : String!
    var state_ID : String!
    var city_ID : String!
    let pickerView = UIPickerView()
    var salutation : String!
    var fname : String!
    var mname : String!
    var pincode_isValid = true
    var lname : String!
    var gender : String!
    var district1 = "Select City"
    var dob : String!
    var mobile : String!
    var landline : String!
    var email : String!
    var aadhar : String!
    var pan : String!
    var city_flag  = "0"
    var countriesArr = [CountriesObj]()
    var stateArr = [StateObj]()
    var cityArr = [CityObj]()
    var userDataArr = [UserDataObj]()
    var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    var progressColor = UIColor(red: 45.0 / 255.0, green: 180.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var bgcolor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    var maxIndex = -1
    var fatca_detail_flag = false
    var flatNo = ""
    var building_name = ""
    var road_street = ""
    var locality = ""
    var personal_details_alert : Bool = false
    
    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    
    @IBOutlet weak var flatNumbertf: UITextField!
    
    @IBOutlet weak var bnametf: UITextField!
    
    @IBOutlet weak var roadtf: UITextField!
    @IBOutlet weak var localitytf: UITextField!
    @IBOutlet weak var countrytf: UITextField!
    @IBOutlet weak var statetf: UITextField!
    
    @IBOutlet weak var citytf: UITextField!
    
    @IBOutlet weak var pincodetf: UITextField!
    
    @IBOutlet weak var cityTableView: UITableView!
    
    @IBOutlet weak var stateTableView: UITableView!
    
    @IBOutlet weak var countryTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //countryTableView.reloadData()
        addBackbutton()
        getUserFatcaDetails()
        getUserData()
       // postUserData()
        
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
        progressBar.completedTillIndex = 1
        progressBar.useLastState = true
        
        progressBar.lastStateCenterColor = progressColor
        progressBar.selectedBackgoundColor = progressColor
        
        progressBar.selectedOuterCircleStrokeColor = backgroundColor
        progressBar.lastStateOuterCircleStrokeColor = backgroundColor
        progressBar.currentSelectedCenterColor = progressColor
        progressBar.currentSelectedTextColor = progressColor
        progressBar.stepTextColor = textColorHere
        progressBar.currentIndex = 1
        // Do any additional setup after loading the view.
      
        
        countrytf.delegate = self
        statetf.delegate = self
        citytf.delegate = self
        flatNumbertf.delegate = self
        
        pincodetf.delegate =  self
     //   bnametf.delegate = self
        //localitytf.delegate = self
        cityTableView.delegate = self
        cityTableView.dataSource = self
        stateTableView.delegate = self
        stateTableView.dataSource = self
        countryTableView.delegate = self
        countryTableView.dataSource = self
        
        countryTableView.isHidden = true
        stateTableView.isHidden = true
        cityTableView.isHidden = true
        
        //getCountries()
        //countryTableView.separatorStyle = .none
        
        
        //countryTableView.reloadData()
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Address Details Screen :- Back Button Clicked")
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
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == pincodetf{
            getPincode(pincode: pincodetf.text ?? "")
        }
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        stateTableView.isHidden = true
        cityTableView.isHidden = true
        countryTableView.isHidden = true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == flatNumbertf{
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        else if textField == bnametf || textField == localitytf{
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS1).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        } else if textField == pincodetf {
            return true
            
        }
        return false
    }
    
    //get methods
    func getPincode(pincode:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.postofficeapi)\(pincode)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                self.presentWindow.hideToastActivity()
                let data = response.result.value as? [String:Any] ?? [:]
                if !data.isEmpty {
                     self.pincode_isValid = true
                    self.countrytf.text = data["Country"] as? String
                    self.statetf.text = data["State"] as? String
                    self.district1 = data["District"] as? String ?? "Select City"
                    self.citytf.text = "Select City"
                    self.getState(id: "94",pincode:"1")
                    
                    //self.citytf.text = data["District"] as? String
                } else {
                    let data_true = response.result.value as? String
                    if (data_true != nil) {
                        self.pincode_isValid = false
                        
                    }
                }
                print(data)
            }
        } else {
            
        }
    }
    
   
    @IBAction func save(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Address Details Screen :- Save & Proceed Button Clicked")
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
        
        
        
        if flatNumbertf.text == ""{
            presentWindow?.makeToast(message: "Please Enter Address")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
        }
        else if !f_c {
            presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
        }else if fourt_comma == "1"{
            presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
        }
        else if flatNo == "" && building_name == "" && road_street == "" && locality == "" {
            
            presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
        }else if flatNo == ""{
            presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
        }
        else if building_name == "" {
            presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
        }
        else if road_street == "" {
            presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
            
        } else if locality == ""{
            presentWindow?.makeToast(message: "Please Enter As Per Given Ex.Format")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Flat Number")
        }
//        else if roadtf.text == ""{
//            presentWindow.makeToast(message: "Please Enter Road/Street")
//            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Road/Street")
//        }
//        else if localitytf.text == ""{
//            presentWindow.makeToast(message: "Please Enter Locality/Area")
//            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Locality/Area")
//        }
        else if pincodetf.text == ""{
            presentWindow.makeToast(message: "Please Enter Pincode")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Pincode")
        }
        else if pincodetf.text!.count < 6{
            presentWindow.makeToast(message: "Please Enter Atleast 6 Digits Pincode")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Enter Atleast 6 Digits Pincode")
        }else if !pincode_isValid {
            self.presentWindow.makeToast(message: "Entered pincode does not exists, please enter correct pincode !!")
        }
        else if countrytf.text == "Select Country"{
            presentWindow.makeToast(message: "Please Select Country")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Select Country")
        }
        else if statetf.text == "Select State"{
            presentWindow.makeToast(message: "Please Select State")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Select State")
        }
        else if city_flag == "0"  && citytf.text == "Select City"{
            presentWindow.makeToast(message: "Please Select City")
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Please Select City")
        }
        
        else{
            postUserData()
        }
        
        //else if
        
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
        else{
            return cityArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == countryTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
            cell.textLabel?.text = countriesArr[indexPath.row].country_name
          //  cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else if tableView == stateTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "state", for: indexPath)
            cell.textLabel?.text = stateArr[indexPath.row].State_name ?? ""
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
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Country Name (\(countrytf.text!)) is selected")
            country_ID1 = countriesArr[indexPath.row].country_id
            //print(country_ID)
            self.countryTableView.isHidden = true
            statetf.text = "Select State"
            citytf.text = "Select City"
            if countrytf.text == "Select Country"{
                statetf.text = "Select State"
                citytf.text = "Select City"
                state_ID = "0"
                city_ID = "0"
                getCity1(id: "0", pincode: "0")
            }
            getState(id:country_ID1, pincode: "0")
        }
        else if tableView == stateTableView{
            let cell = stateTableView.cellForRow(at: indexPath)
            if cell?.textLabel?.text == "" {
                statetf.text = "Select State"
            } else {
                statetf.text = cell?.textLabel?.text
            }
            
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Country Name (\(statetf.text!)) is selected")
            state_ID = stateArr[indexPath.row].State_id
            self.stateTableView.isHidden = true
            
            citytf.text = "Select City"
            if statetf.text == "Select State"{
                //statetf.text = "Select State"
                citytf.text = "Select City"
                state_ID = "0"
                city_ID = "0"
            }
            getCity1(id:state_ID, pincode: "0")
        }
        else{
            let cell = cityTableView.cellForRow(at: indexPath)
            citytf.text = cell?.textLabel?.text
            Mixpanel.mainInstance().track(event: "Address Details Screen :- Country Name (\(citytf.text!)) is selected")
            city_ID = cityArr[indexPath.row].City_id
            self.cityTableView.isHidden = true
           
        }
    }
    
    
    @IBAction func countryBtnPrsd(_ sender: Any) {
       // getCountries()
        Mixpanel.mainInstance().track(event: "Address Details Screen :- Country Dropdown Clicked")
        self.countryTableView.isHidden = !self.countryTableView.isHidden
        self.stateTableView.isHidden = true
        self.cityTableView.isHidden = true
        
    }
    
    @IBAction func stateBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Address Details Screen :- State Dropdown Clicked")
        if stateArr.count > 36 {
            self.stateTableView.isHidden = !self.stateTableView.isHidden
            self.countryTableView.isHidden = true
            self.cityTableView.isHidden = true
        }
        
    }
    
    @IBAction func cityBtnPrsd(_ sender: Any) {
        
        Mixpanel.mainInstance().track(event: "Address Details Screen :- City Dropdown Clicked")
        if cityArr.count > 1 {
            self.cityTableView.isHidden = !self.cityTableView.isHidden
            self.countryTableView.isHidden = true
            self.stateTableView.isHidden = true
        }
        
    }
    func  getCountries(){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        
        let url = "\(Constants.BASE_URL)\(Constants.API.country)/3"
        countriesArr.removeAll()
        countriesArr.append(CountriesObj.getuserdata(country_name: "Select Country", country_id: "0"))
        if countrytf.text == ""{
            self.countrytf.text = self.countriesArr[0].country_name
        }
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
                //print(response.result.value)
                if let data = data as? [AnyObject]{
                    for type in data{
                        if let countryName = type.value(forKey: "country_name") as? String,
                            let countryId = type.value(forKey: "country_id") as? String{
                            
                            if self.country_ID1 == countryId{
                                self.countrytf.text! = countryName
                            }
                            //print(countryName)
                            if countryName == "India" {
                                self.presentWindow.hideToastActivity()
                                self.countriesArr.append(CountriesObj.getuserdata(country_name: countryName, country_id: countryId))
                            }
                            
                        }
                    }
                    //       self.countrytf.text = self.countriesArr[0].country_name
                    self.countryTableView.reloadData()
                    // print(self.countriesArr)
                }
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getState(id:String,pincode:String){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        print(id,"address state")
        if id != " " {
            let url = "\(Constants.BASE_URL)\(Constants.API.state)\(id)/3"
            stateArr.removeAll()
            stateArr.append(StateObj.getState(State_name: "Select State", State_id: "0"))
            if statetf.text == ""{
                self.statetf.text = self.stateArr[0].State_name
            }
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
                    //print(response.result.value)
                    if let data = data as? [AnyObject]{
                        for type in data{
                            if let stateName = type.value(forKey: "state_name") as? String,
                                let stateId = type.value(forKey: "state_id") as? String{
                                //print(stateName)
                                //self.state_ID = stateId
                                if pincode == "1"
                                {
                                    if stateName == self.statetf.text {
                                        self.getCity1(id: stateId, pincode: pincode)
                                    }
                                }else {
                                    if self.state_ID == stateId {
                                        self.statetf.text = stateName
                                    }
                                }
                                self.presentWindow.hideToastActivity()
                                self.stateArr.append(StateObj.getState(State_name: stateName, State_id: stateId))
                            }
                        }
                        // print(self.countriesArr)
                    }
                    //                self.statetf.text = self.stateArr[0].State_name
                    self.stateTableView.reloadData()
                    
                }
                
                
                
            }
            else{
                //presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }
    }
    func getCity1(id:String,pincode:String){
        print(id,"city")
        if id != ""{
            //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
            let url = "\(Constants.BASE_URL)\(Constants.API.city)\(id)/3"
            
            
            cityArr.removeAll()
            cityArr.append(CityObj.getCity(City_name: "Select City", City_id: "0"))
            if citytf.text == ""{
                self.citytf.text = self.cityArr[0].City_name
            }
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
                    if let data = data as? [AnyObject]{
                        if !data.isEmpty{
                            self.city_flag = "0"
                            self.city_dropdown.isHidden = false
                            self.citytf.isEnabled = true
                            let attr = [ NSAttributedStringKey.foregroundColor : UIColor.red ]
                            let myNewLabelText = NSMutableAttributedString(string: "*", attributes: attr)
                            let city = NSMutableAttributedString(string: "City ")
                            city.append(myNewLabelText)
                            self.cityLabel.attributedText = city
                            for type in data{
                                   let cityName = type.value(forKey: "city_name") as? String ?? ""
                                    let cityId = type.value(forKey: "city_id") as? String ?? "0"
                                    // print(self.city_ID,cityId)
                                    if pincode == "1"  {
                                       if self.district1  == cityName {
                                            self.citytf.text! = cityName
                                            self.city_ID = cityId
                                        }
                                
                                    } else {
                                        if self.city_ID == cityId{
                                            self.citytf.text! = cityName
                                        }
                                    }
                                    // self.city_ID = cityId
                                    self.presentWindow.hideToastActivity()
                                    self.cityArr.append(CityObj.getCity(City_name: cityName, City_id: cityId))
                               // }
                            }
                        } else {
                            if id == "0"{
                                self.citytf.text = "Select City"
                                self.city_dropdown.isHidden = false
                                self.citytf.isEnabled = true
                                self.cityBtnOutlet.isUserInteractionEnabled = true
                            } else {
                                self.city_flag = "1"
                                self.cityLabel.text = "City"
                                self.citytf.text = "NA"
                                self.city_dropdown.isHidden = true
                                self.citytf.isEnabled = false
                                self.cityBtnOutlet.isUserInteractionEnabled = false
                            }
                            print("city is empty")
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
        } else {
            if citytf.text == ""{
                citytf.text = "Select City"
            }
        }
    }
    @IBOutlet weak var city_dropdown: UIImageView!
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
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
               // let data = response.result.value
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
                            print(location!)
                            self.country_ID1 = country!
                            self.state_ID = state!
                            self.city_ID = city!
                            self.getCountries()
                            self.getState(id: country!, pincode: "0")
                            self.getCity1(id: state!, pincode: "0")
                            if flat_no == "" || building_name == "" && road_street == "" && address == ""{
                                self.flatNumbertf.text = ""
                            }else {
                                self.flatNumbertf.text = "\(flat_no!),\(building_name!),\(road_street!),\(address!)"
                            }
                            //self.bnametf.text = building_name!
                            //self.roadtf.text = road_street!
                           // self.localitytf.text = address
                            
                            //self.countrytf.text = country!
                            //self.statetf.text = state!
                            //self.citytf.text = city!
                            if pincode == "0" {
                                self.pincodetf.text = ""
                            } else {
                                 self.pincodetf.text = pincode!
                            }
                           
                            var income_slab = (abc as AnyObject).value(forKey: "income_slab") as? String
                            let income_slab_id = (abc as AnyObject).value(forKey: "IncomeSlabID") as? String
                            if income_slab_id == "0" {
                                income_slab = ""
                            }
                            
                            
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
    
    // post method
    
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
        let address_text = flatNumbertf.text!
        let address_text_split = address_text.split(separator: ",")
        print(address_text_split)
        let flatNo = self.flatNo
        let building_name = self.building_name
        let road_street = self.road_street
        let locality = self.locality
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id":"\(covertToBase64(text: userid as! String))!)",
                "name":"\(userDataArr[0].fname!.covertToBase64())",
                "middle_name":"\(userDataArr[0].mname!.covertToBase64())",
                "last_name":"\(userDataArr[0].lname!.covertToBase64())",
                "email":"\(userDataArr[0].email!.covertToBase64())",
                "mobile":"\(userDataArr[0].mobile!.covertToBase64())",
                "landline":"\(userDataArr[0].landline!.covertToBase64())",
                "pan":"\(userDataArr[0].pan!.covertToBase64())",
                "flat_no":"\(flatNo.covertToBase64())",
                "building_name":"\(building_name.covertToBase64())",
                "road_street":"\(road_street.covertToBase64())",
                "address":"\(locality.covertToBase64())",
                "dob":"\(userDataArr[0].dob!.covertToBase64())",
                "gender":"\(userDataArr[0].gender!.covertToBase64())",
                "country":"\(country_ID1!.covertToBase64())",
                "state":"\(state_ID!.covertToBase64())",
                "city":"\(city_ID!.covertToBase64())",
                "pincode":"\(pincodetf.text!.covertToBase64())",
                "salutation":"\(userDataArr[0].salutation!.covertToBase64())",
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
                "enc_resp":"3"
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.postUserData)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
                    let data = response.result.value as? Bool
                    // print(data!)
                    
                    if data == true {
                        print("updated user data")
                        if self.fatca_detail_flag {
                            self.bseRegisteredFlag(userid: userid as! String)
                        } else {
                            self.presentWindow.hideToastActivity()
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "OtherDetailViewController") as! OtherDetailViewController
                            self.navigationController?.pushViewController(destVC, animated: true)
                        }
                        
                        
                        
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
                            if let _ = type.value(forKey: "fatca_id") as? String,
                                let fatca_networth = type.value(forKey: "fatca_networth") as? String, let fatca_networth_date = type.value(forKey: "fatca_networth_date") as? String , let fatca_politically_exposed = type.value(forKey: "fatca_politically_exposed") as? String,let fatca_nationality = type.value(forKey: "fatca_nationality") as? String,let fatca_other_nationality = type.value(forKey: "fatca_other_nationality") as? String,let fatca_tax_resident = type.value(forKey: "fatca_tax_resident") as? String ,let fatca_resident_country = type.value(forKey: "fatca_resident_country") as? String,let fatca_tax_player_id = type.value(forKey: "fatca_tax_player_id") as? String,let _ = type.value(forKey: "fatca_id_type") as? String,let fatca_resident_country_1 = type.value(forKey: "fatca_resident_country_1") as? String, let fatca_tax_player_id_1 = type.value(forKey: "fatca_tax_player_id_1") as? String,let _ = type.value(forKey: "fatca_id_type_1") as? String,let fatca_resident_country_2 = type.value(forKey: "fatca_resident_country_2") as? String,let fatca_tax_player_id_2 = type.value(forKey: "fatca_tax_player_id_2") as? String,let fatca_id_type_2 = type.value(forKey: "fatca_id_type_2") as? String{
                                
                                self.fatca_detail_flag = true
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
             presentWindow?.makeToast(message: "No Internet Connection")
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
                    //redirect to other detail
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "OtherDetailViewController") as! OtherDetailViewController
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
                let data = response.result.value as? [String:Any]
                if let bse_reg_status = data?["bse_reg"] as? String {
                    print(bse_reg_status)
                    if bse_reg_status == "Y" {
                        self.clientregistrationBse(userid: userid)
                    } else {
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "OtherDetailViewController") as! OtherDetailViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
             presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
}
