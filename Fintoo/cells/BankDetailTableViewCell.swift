//
//  BankDetailTableViewCell.swift
//  Fintoo
//
//  Created by iosdevelopermme on 03/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
protocol BankDetailCellDelegate: class {
    func deleteCell(row:Int)
    func uploadFile(row:Int)
    func viewDoc(row:Int)
}
var account_type_id : String!
var bank_name_id : String!
var account_min_count : String!
var C_ID : String!
var S_ID : String!
var City_id : String!
var city_flag_bank  = "0"
 var bank_dd_flag = 0
var bank_razorpay_code : String!
class BankDetailTableViewCell: UITableViewCell ,UITableViewDelegate,UITableViewDataSource{
   
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var countryBtnOutlet: UIButton!
    @IBOutlet weak var accountTypeBtnOutlet: UIButton!
    @IBOutlet weak var viewDocOutlet: UIButton!
    
    @IBOutlet weak var bank_city_image: UIImageView!
    @IBOutlet weak var cityBtnOutlet: UIButton!
    @IBOutlet weak var stateBtnOutlet: UIButton!
    @IBOutlet weak var bankNameOutlet: UIButton!
    var countriesArr = [CountriesObj]()
    var bankArr = [bankDetailObj]()
    //var bankTypeArr = [bankTypeObj]()
    var country_ID1: String!
    var PresentWindows = UIView()
    //var userBanklist = [getBankObj]()
    var cityArr = [CityObj]()
    var city_ID : String!
    
    var stateArr = [StateObj]()
    var state_ID : String!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == countryTableView{
            return countriesArr.count
        }
        else if tableView == stateTableView{
            return stateArr.count
        }
        else if tableView == bankNameTableview{
            return bankArr.count
        }
        else if tableView == accountTypeTableview{
            return bankTypeArr.count
        }
        else{
            return cityArr.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView ==  accountTypeTableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "accounttype", for: indexPath)
            cell.textLabel?.text = bankTypeArr[indexPath.row].bank_mst_name
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Bank Name : \(cell.textLabel!.text!) is  Clicked")
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else if tableView == bankNameTableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "bankname", for: indexPath)
            cell.textLabel?.text = bankArr[indexPath.row].banks_name_value
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else if tableView ==  countryTableView{
        //print(userBanklist[countryBtnOutlet.tag].bank_country,"*&*&*&*&*&**&**&*&*&")
            let cell = tableView.dequeueReusableCell(withIdentifier: "country", for: indexPath)
            cell.textLabel?.text = countriesArr[indexPath.row].country_name
            
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else if tableView == stateTableView{
          //  getState(id:"0")
            let cell = tableView.dequeueReusableCell(withIdentifier: "state", for: indexPath)
            cell.textLabel?.text = stateArr[indexPath.row].State_name
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- State : \(cell.textLabel!.text!) is  Clicked")
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else if tableView == cityTableView{
           // getCity1(id:"0")
            let cell = tableView.dequeueReusableCell(withIdentifier: "city", for: indexPath)
            cell.textLabel?.text = cityArr[indexPath.row].City_name
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- City : \(cell.textLabel!.text!) is  Clicked")
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "city", for: indexPath)
            cell.textLabel?.text = "good"
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == countryTableView{
            let cell = countryTableView.cellForRow(at: indexPath)
            countryTf.text = cell?.textLabel?.text
            print(countriesArr.count)
            country_ID1 = countriesArr[indexPath.row].country_id
            C_ID = countriesArr[indexPath.row].country_id
            userBanklist[countryBtnOutlet.tag].bank_country = countriesArr[indexPath.row].country_id
            print(userBanklist[countryBtnOutlet.tag].bank_country)
            self.countryTableView.isHidden = true
            S_ID = "0"
            City_id = "0"
            city_ID = "0"
            stateTf.text = "Select State"
            cityTf.text = "Select City"
            
            if countryTf.text == "Select Country"{
               
                userBanklist[countryBtnOutlet.tag].country_name = "Select Country"
                userBanklist[countryBtnOutlet.tag].state_name = "Select State"
                
                userBanklist[countryBtnOutlet.tag].city_name = "Select City"
                S_ID =  stateArr[indexPath.row].State_id
                state_ID = "0"
                city_ID = "0"
                stateTf.text = "Select State"
                cityTf.text = "Select City"
//                self.bank_city_image.isHidden = false
//                self.cityTf.isEnabled = true
                self.cityBtnOutlet.isUserInteractionEnabled = true
                 stateArr.removeAll()
                cityArr.removeAll()
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Select Country is  Clicked")
            }
            else{
                city_ID = "0"
                userBanklist[countryBtnOutlet.tag].country_name = countryTf.text
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Contry : \(countryTf.text!) is  Clicked")
            }
            getState(id:country_ID1)
        }
        else if tableView == stateTableView{
            let cell = stateTableView.cellForRow(at: indexPath)
            stateTf.text = cell?.textLabel?.text
            state_ID = stateArr[indexPath.row].State_id
            S_ID =  stateArr[indexPath.row].State_id
            City_id = "0"
            city_ID = "0"
            userBanklist[stateBtnOutlet.tag].bank_state = stateArr[indexPath.row].State_id
            self.stateTableView.isHidden = true
            
            cityTf.text = "Select City"
            if stateTf.text == "Select State"{
                cityArr.removeAll()
                city_ID = "0"
                userBanklist[countryBtnOutlet.tag].state_name = "Select State"
                 userBanklist[countryBtnOutlet.tag].city_name = "Select City"
                cityTf.text = "Select City"
//                self.bank_city_image.isHidden = false
//                self.cityTf.isEnabled = true
//                self.cityBtnOutlet.isUserInteractionEnabled = true
            }
            else{
                userBanklist[countryBtnOutlet.tag].state_name = stateTf.text
            }
            getCity1(id:state_ID)
        }
        else if tableView == bankNameTableview{
            let cell = bankNameTableview.cellForRow(at: indexPath)
            bankNameTf.text = cell?.textLabel?.text
            bank_name_id = bankArr[indexPath.row].banks_id
            account_min_count = bankArr[indexPath.row].min_acc_number!
            userBanklist[bankNameOutlet.tag].bank_name = bankArr[indexPath.row].banks_name_value!
            if bankArr[indexPath.row].min_acc_number! == "0"{
                userBanklist[bankNameOutlet.tag].max_acc_number = "18"
                userBanklist[bankNameOutlet.tag].min_acc_number = "8"
                accountNumberTf.maxLength = 18
            } else {
                userBanklist[bankNameOutlet.tag].max_acc_number = bankArr[indexPath.row].max_acc_number!
                userBanklist[bankNameOutlet.tag].min_acc_number = bankArr[indexPath.row].min_acc_number!
                accountNumberTf.maxLength = Int(bankArr[indexPath.row].max_acc_number!) ?? 18
            }
            
            userBanklist[bankNameOutlet.tag].bank_razorpay_code_user = bankArr[indexPath.row].bank_razorpay_code
            self.bankNameTableview.isHidden = true
            if bankNameTf.text == "Select Bank" {
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Number")
              // self.addAnotherBankOutlet.tag = 2
               // self.bank_details_flag=false
                bank_dd_flag = 2
                
            }else{
                bank_dd_flag = 0
            }
            
            
        }
        else if tableView == accountTypeTableview{
            let cell = accountTypeTableview.cellForRow(at: indexPath)
            accountTypeTf.text = cell?.textLabel?.text
            account_type_id = bankTypeArr[indexPath.row].bank_mst_id
            userBanklist[accountTypeBtnOutlet.tag].bank_type = bankTypeArr[indexPath.row].bank_mst_id!
            self.accountTypeTableview.isHidden = true
            print(accountTypeTf.text)
            print("###")
            if accountTypeTf.text == "Select" {
                //PresentWindows.makeToast(message: "Please Enter account type")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Type")
            //self.addAnotherBankOutlet.tag = 8
            //self.bank_details_flag=false
                bank_dd_flag = 8
            }else{
                bank_dd_flag = 0
            }
        }
        else{
            let cell = cityTableView.cellForRow(at: indexPath)
            cityTf.text = cell?.textLabel?.text
            city_ID = cityArr[indexPath.row].City_id
            City_id = cityArr[indexPath.row].City_id
            userBanklist[cityBtnOutlet.tag].bank_city = cityArr[indexPath.row].City_id
            if cityTf.text == "Select City"{
                userBanklist[countryBtnOutlet.tag].city_name = "Select City"
            }
            else{
                userBanklist[countryBtnOutlet.tag].city_name = cityTf.text
            }
            self.cityTableView.isHidden = true
            
        }
    }
    
    @IBOutlet weak var operationTypeYesOutlet: UIButton!
    
    @IBOutlet weak var operationTypeNoOutlet: UIButton!
    @IBOutlet weak var accountTypeTableview: UITableView!
    
    @IBOutlet weak var bankNameTableview: UITableView!
    
    @IBOutlet weak var countryTableView: UITableView!
    
    @IBOutlet weak var stateTableView: UITableView!
    
    
    @IBOutlet weak var cityTableView: UITableView!
    
    @IBOutlet weak var uploadBtnOutlet: UIButton!
    
    @IBOutlet weak var deleteBtnOutlet: UIButton!
    
    @IBOutlet weak var accountNumberTf: UITextField!
    
    @IBOutlet weak var accountTypeTf: UITextField!
    
    @IBOutlet weak var bankNameTf: UITextField!
    
    @IBOutlet weak var micrCodeTf: UITextField!
    
    @IBOutlet weak var IFSCCodeTf: UITextField!
    
    @IBOutlet weak var bankBranchTf: UITextField!
    
    @IBOutlet weak var countryTf: UITextField!
    
    @IBOutlet weak var stateTf: UITextField!
    
    @IBOutlet weak var cityTf: UITextField!
    
    @IBOutlet weak var accountLimitPerTxnTf: UITextField!
    
    
    @IBOutlet weak var cancelledChequeTf: UITextField!
    
    weak var delegate: BankDetailCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
       // getUserBankList()
        PresentWindows = UIView()
        getUserBankDetails()
     //   getBankType()
        getCountries()
        // Initialization code
        accountTypeTableview.delegate = self
        accountTypeTableview.dataSource = self
        
        bankNameTableview.delegate = self
        bankNameTableview.dataSource = self
        
        countryTableView.delegate = self
        countryTableView.dataSource = self
        
        stateTableView.delegate = self
        stateTableView.dataSource = self
        
        cityTableView.delegate = self
        cityTableView.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func uploadFile(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Bank Details Screen :- Upload Button Clicked")
        delegate?.uploadFile(row: sender.tag)
        
    }
    @IBAction func deleteBtn(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Bank Details Screen :- Delete Button Clicked")
        delegate?.deleteCell(row: sender.tag)
        
    }
    @IBAction func operationTypeYes(_ sender: Any) {
        
    }
    
    @IBAction func operationTypeNo(_ sender: Any) {
        
    }
    
    @IBAction func viewDoc(_ sender: UIButton) {
        delegate?.viewDoc(row: sender.tag)
    }
    
    @IBAction func accountTypeBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Bank Details Screen :- Account Type Dropdown Button Clicked")
        accountTypeTableview.isHidden = !accountTypeTableview.isHidden
        bankNameTableview.isHidden = true
        countryTableView.isHidden = true
        stateTableView.isHidden = true
        cityTableView.isHidden = true
        accountTypeTableview.reloadData()
    }
    @IBAction func bankNameBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Bank Details Screen :- Bank Name Dropdown Button Clicked")
        print("hiii")
        bankNameTableview.isHidden = !bankNameTableview.isHidden
        accountTypeTableview.isHidden = true
        countryTableView.isHidden = true
        stateTableView.isHidden = true
        cityTableView.isHidden = true
    }
    @IBAction func countyBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Bank Details Screen :- Country Dropdown Button Clicked")
        getCountries()
        countryTableView.isHidden = !countryTableView.isHidden
        bankNameTableview.isHidden = true
        accountTypeTableview.isHidden = true
        stateTableView.isHidden = true
        cityTableView.isHidden = true
        
    }
    @IBAction func stateBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Bank Details Screen :- State Dropdown Button Clicked")
        stateTableView.isHidden = !stateTableView.isHidden
        
        bankNameTableview.isHidden = true
        countryTableView.isHidden = true
        accountTypeTableview.isHidden = true
        cityTableView.isHidden = true
        self.stateTableView.reloadData()
    }
    @IBAction func cityBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Bank Details Screen :- City Dropdown Button Clicked")
       // getCity1(id: state_ID)
//        cityArr.removeAll()
//        cityArr.append(CityObj.getCity(City_name: "Select City", City_id: "0"))
        cityTableView.isHidden = !cityTableView.isHidden
        
        bankNameTableview.isHidden = true
        countryTableView.isHidden = true
        stateTableView.isHidden = true
        accountTypeTableview.isHidden = true
        self.cityTableView.reloadData()
    }
    
    
    func  getCountries(){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        PresentWindows.makeToast(message: "Loading")
        let url = "\(Constants.BASE_URL)\(Constants.API.country)"
        countriesArr.removeAll()
        countriesArr.append(CountriesObj.getuserdata(country_name: "Select Country", country_id: "0"))
        if countryTf.text == ""{
            self.countryTf.text = self.countriesArr[0].country_name
        }
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    for type in data{
                        if let countryName = type.value(forKey: "country_name") as? String,
                            let countryId = type.value(forKey: "country_id") as? String{
                            
                            if self.country_ID1 == countryId{
                                self.countryTf.text! = countryName
                            }
                            //print(countryName)
                            
                           // self.presentWindow.hideToastActivity()
                            self.countriesArr.append(CountriesObj.getuserdata(country_name: countryName, country_id: countryId))
                            
                        }
                    }
                    if userBanklist.count > 0 {
                    print(self.countryBtnOutlet.tag)
                    self.getState(id:userBanklist[self.countryBtnOutlet.tag].bank_country ?? "")
                    }
                    self.countryTableView.reloadData()
                  
                }
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
           // presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func  getState(id:String){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        if id != "0"{
            let url = "\(Constants.BASE_URL)\(Constants.API.state)\(id)"
            stateArr.removeAll()
            stateArr.append(StateObj.getState(State_name: "Select State", State_id: "0"))
            if stateTf.text == ""{
                self.stateTf.text = self.stateArr[0].State_name
            }
            if Connectivity.isConnectedToInternet{
                
                Alamofire.request(url).responseJSON { response in
                    //print(response.result.value)
                    if let data = response.result.value as? [AnyObject]{
                        for type in data{
                            if let stateName = type.value(forKey: "state_name") as? String,
                                let stateId = type.value(forKey: "state_id") as? String{
                                //print(stateName)
                                //self.state_ID = stateId
                                if self.state_ID == stateId {
                                    self.stateTf.text = stateName
                                }
                                //self.presentWindow.hideToastActivity()
                                self.stateArr.append(StateObj.getState(State_name: stateName, State_id: stateId))
                            }
                        }
                        // print(self.countriesArr)
                    }
                    //                self.statetf.text = self.stateArr[0].State_name
                    if userBanklist.count > 0 {
                        self.getCity1(id:userBanklist[self.countryBtnOutlet.tag].bank_state ?? "")
                    }
                    self.stateTableView.reloadData()
                    
                }
                
                
                
            }
            else{
                //presentWindow.hideToastActivity()
               // presentWindow?.makeToast(message: "No Internet Connection")
            }
        }
    }
    func  getCity1(id:String){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        let url = "\(Constants.BASE_URL)\(Constants.API.city)\(id)"
        
        
        cityArr.removeAll()
        cityArr.append(CityObj.getCity(City_name: "Select City", City_id: "0"))
        if cityTf.text == ""{
           // self.cityTf.text = self.cityArr[0].City_name
            self.cityTf.text = "NA"
        }
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    if !data.isEmpty{
                        city_flag_bank = "0"
//                        self.bank_city_image.isHidden = false
//                        self.cityTf.isEnabled = true
//                        self.cityBtnOutlet.isUserInteractionEnabled = true
                    for type in data{
                        if let cityName = type.value(forKey: "city_name") as? String,
                            let cityId = type.value(forKey: "city_id") as? String{
                            if self.city_ID == cityId{
                                self.cityTf.text! = cityName
                            }
                            self.cityArr.append(CityObj.getCity(City_name: cityName, City_id: cityId))
                        }
                    }
                    } else {
                        city_flag_bank = "1"
                        print()
                        if userBanklist.count > 0{
                            print(self.countryBtnOutlet.tag)
                            userBanklist[self.countryBtnOutlet.tag].bank_city = ""
                        }
                        if id == "0" || id == ""{
                            self.cityTf.text = "City"
//                            self.bank_city_image.isHidden = false
//                            self.cityTf.isEnabled = true
//                            self.cityBtnOutlet.isUserInteractionEnabled = true
                        } else{
                            print("city is empty")
                            self.cityTf.text = "NA"
//                            self.bank_city_image.isHidden = true
//                            self.cityTf.isEnabled = false
//                            self.cityBtnOutlet.isUserInteractionEnabled = false
                        }
                        
                    }
                }
                self.cityTableView.reloadData()
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            //presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func  getUserBankDetails(){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        let userid = UserDefaults.standard.value(forKey: "userid")
        let url = "\(Constants.BASE_URL)\(Constants.API.getbankList)"
        
        
        bankArr.removeAll()
        bankArr.append(bankDetailObj.getBankDetail(banks_name_value: "Select Bank", banks_id: "01", banks_bd_code: "abcz", bank_razorpay_code: "0", min_acc_number: "0",max_acc_number: "0"))
        if bankNameTf.text == ""{
            self.bankNameTf.text = self.bankArr[0].banks_name_value
        }
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    print(data)
                    for type in data{
                        if let bankName = type.value(forKey: "banks_name_value") as? String,
                            let bankId = type.value(forKey: "banks_id") as? String, let bankCode = type.value(forKey:"banks_bd_code") as? String,
                        let bank_razorpay_code = type.value(forKey: "bank_razorpay_code") as? String {
                            let min_acc_number = type.value(forKey: "min_acc_number") as? String ?? "0"
                            let max_acc_number = type.value(forKey: "max_acc_number") as? String ?? "0"
                            self.bankArr.append(bankDetailObj.getBankDetail(banks_name_value: bankName, banks_id: bankId, banks_bd_code: bankCode, bank_razorpay_code: bank_razorpay_code, min_acc_number: min_acc_number,max_acc_number: max_acc_number))
                            
                        }
                    }
                    
                    // print(self.countriesArr)
                }
                self.bankNameTableview.reloadData()
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            //presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func  getBankType(){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        let userid = UserDefaults.standard.value(forKey: "userid")
        let url = "\(Constants.BASE_URL)\(Constants.API.bankType)"
        
        
        bankTypeArr.removeAll()
        bankTypeArr.append(bankTypeObj.getBankType(bank_mst_name: "Select", bank_mst_id: "0"))
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                if !data.isEmpty{
                    for type in data{
                        if let bank_mst_name = type.value(forKey: "bank_mst_name") as? String,
                            let bank_mst_id = type.value(forKey: "bank_mst_id") as? String{
                            print(account_type_id)
                            bankTypeArr.append(bankTypeObj.getBankType(bank_mst_name: bank_mst_name, bank_mst_id: bank_mst_id))
                            
                        }
                    }
                }
            }
                self.accountTypeTableview.reloadData()
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            //presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
   
}
