//
//  ReedemViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 08/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel

class ReedemViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    var units = ""
    var no_of_units : String!
    var curr_value : String!
    var bank_id : String!
    var transactionArrs = [String]()
    var selectAction : String!
    var SchemeName : String!
    var Schemecode : String!
    var acc_no : String!
    var folio_no : String!
    var trxnnumber : String!
    var mininvest : String!
    var swpcid : String!
    var stptxnid : String!
    var stpcid : String!
    var bank_acc_no_from_bank_list = [String: [String:String]]()
    var bse_aof_status_code = ""
    var bse_reg_code = ""
    var minredeemUnit = ""
    var minredeemAmt = ""
    var row : Int!
    var curr_nav = ""
    var swptxnid = ""
    @IBOutlet weak var label_units: UILabel!
    @IBOutlet weak var selectActiontf: UITextField!
    @IBOutlet weak var selectActionTableview: UITableView!
    @IBOutlet weak var schemeNameTf: UITextField!
    //@IBOutlet weak var bankNameTf: UITextField!
    
    @IBOutlet weak var unitsTf: UITextField!
    //@IBOutlet weak var selectBankTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        setWhiteNavigationBar()
        let swptxnid1 = UserDefaults.standard.value(forKey: "swptxnid") as? String ?? ""
        if swptxnid1 != "" {
            swptxnid = swptxnid1
        }
        getBankId()
        selectActiontf.text =  selectAction!
        schemeNameTf.text = SchemeName
        
        //selectBankTableview.delegate = self
        //selectBankTableview.dataSource = self
        
        selectActionTableview.delegate = self
        selectActionTableview.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "TRANSACT ONLINE"
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Redeem Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
        destVC.selectIndexValue = true
        self.navigationController?.pushViewController(destVC, animated: true)
    }
   
    @IBOutlet weak var selectActionBtn: UIButton!
    @IBAction func selectActionBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Redeem Screen :- Dropdown Button Clicked")
        //selectActionTableview.isHidden = !selectActionTableview.isHidden
        //selectBankTableview.isHidden = true
    }
    
    @IBOutlet weak var selectBankBtn: UIButton!
    
    @IBAction func selectBankBtn(_ sender: Any) {
        //selectBankTableview.isHidden = !selectBankTableview.isHidden
        //selectActionTableview.isHidden = true
    }
    
    @IBOutlet weak var noOfUnitsBtn: UIButton!
    @IBAction func noOfUnitsBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Redeem Screen :- No Of Units Button Clicked")
        noOfUnitsBtn.setImage(UIImage(named: "check"), for: .normal)
        allUnits.setImage(UIImage(named: "uncheck"), for: .normal)
        amountBtn.setImage(UIImage(named: "uncheck"), for: .normal)
        unitsTf.isEnabled = true
        units = "noofunits"
        unitsTf.text = ""
        label_units.text = "Your max units to redeem from this folio is \(no_of_units!)"
    }
    @IBOutlet weak var allUnits: UIButton!
    @IBAction func allUnits(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Redeem Screen :- All Units Button Clicked")
        noOfUnitsBtn.setImage(UIImage(named: "uncheck"), for: .normal)
        allUnits.setImage(UIImage(named: "check"), for: .normal)
        amountBtn.setImage(UIImage(named: "uncheck"), for: .normal)
        unitsTf.isEnabled = false
        units = "all"
        label_units.text = ""
        unitsTf.text = ""
    }
    
    @IBOutlet weak var amountBtn: UIButton!
    @IBAction func amountBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Redeem Screen :- Amount Button Clicked")
        noOfUnitsBtn.setImage(UIImage(named: "uncheck"), for: .normal)
        allUnits.setImage(UIImage(named: "uncheck"), for: .normal)
        amountBtn.setImage(UIImage(named: "check"), for: .normal)
        unitsTf.isEnabled = true
        units = "amount"
        label_units.text = "Your max amount to redeem from this folio is Rs. \(curr_value!)"
        unitsTf.text = ""
    }
    
    @IBAction func submit(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Redeem Screen :- Submit Button Clicked")
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        if units == ""{
            presentWindow.makeToast(message: "Please Select units or amount")
            Mixpanel.mainInstance().track(event: "Redeem Screen :- Please Select units or amount")
        }
        else if units != "all" && unitsTf.text == ""{
            presentWindow.makeToast(message: "Please enter units or amount")
            Mixpanel.mainInstance().track(event: "Redeem Screen :- Please Select units or amount")
        }
        else if unitsTf.text == "0"{
            presentWindow.makeToast(message: "Please enter units or amount")
            Mixpanel.mainInstance().track(event: "Redeem Screen :- Please Select units or amount")
        }
        else if units == "noofunits" && Int(unitsTf.text!)! < Int(minredeemUnit)! {
            presentWindow.makeToast(message: "You can minimum \(minredeemUnit) units redeem from this folio")
            Mixpanel.mainInstance().track(event: "Redeem Screen :- You can minimum \(minredeemUnit) units redeem from this folio")
        }
        else if units == "noofunits" && Int(unitsTf.text!)! > Int(truncating: no_of_units.numberValue!) {
            presentWindow.makeToast(message: "You have only \(no_of_units!) units to redeem from this folio")
            Mixpanel.mainInstance().track(event: "Redeem Screen :- You have only \(no_of_units!) units to redeem from this folio")
        }
        else if units == "amount" && Int(unitsTf.text!)! > Int(truncating: curr_value.numberValue!){
            //  You have only 58854 Rs. to redeem from this folio
            presentWindow.makeToast(message: "You have only \(curr_value!) RS. to redeem from this folio")
            Mixpanel.mainInstance().track(event: "Redeem Screen :- You have only \(curr_value!) RS. to redeem from this folio")
        }
        else if units == "amount" && Int(unitsTf.text!)! < Int(minredeemAmt)! {
            presentWindow.makeToast(message: "You need minimum \(minredeemAmt) Rs. to redeem into selected scheme")
            Mixpanel.mainInstance().track(event: "Redeem Screen :- You need minimum \(minredeemAmt) Rs. to redeem into selected scheme")
        }
        else{
            
            if units == "amount"{
                addtocart(id: Schemecode, tenure: "", units: "", amount: (unitsTf.text!), type: "4", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "")

            }
            else if units == "noofunits"{
                 addtocart(id: Schemecode, tenure: "", units: unitsTf.text!, amount: "", type: "4", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "")
            }
            else{
                addtocart(id: Schemecode, tenure: "", units: "", amount: "", type: "4", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "")
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectActionTableview{
            return transactionArrs.count
        }
        else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == selectActionTableview{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "selectaction", for: indexPath)
            cell.textLabel?.text = transactionArrs[indexPath.row]
            return cell
        }
        else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "schemeName", for: indexPath)
            cell.textLabel?.text = "Bank List"
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == selectActionTableview{
            let cell = tableView.cellForRow(at: indexPath)
            selectActiontf.text = cell?.textLabel?.text
            if selectActiontf.text  == "Additional Purchase"{
                // transacttf.text = "Additional Purchase"
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "AdditionalPurchaseViewController") as! AdditionalPurchaseViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Additional Purchase"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text == "Redeem"{
                
            }
            else if selectActiontf.text  == "Switch"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "transactSwitchViewController") as! transactSwitchViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Switch"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text  == "Stop SIP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSIPViewController") as! StopSIPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Stop SIP"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text == "Stop SWP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSWPViewController") as! StopSWPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.selectAction = "Stop SWP"
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text  == "Stop STP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSTPViewController") as! StopSTPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Stop STP"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text == "Start SWP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StartSWPViewController") as! StartSWPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Start SWP"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
                
            }
            else if selectActiontf.text  == "Start STP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "STPViewController") as! STPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Start STP"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
                
            }
            selectActionTableview.isHidden = true
            //return cell
        }
        else {
            let cell = tableView.cellForRow(at: indexPath)
            //bankNameTf.text = cell?.textLabel?.text
            //selectBankTableview.isHidden = true
        }
        
    }
    func getBankId(){
        //http://www.erokda.in/adminpanel/settings/cutoffservice_ws.php/getShemecodeWBR/2766,ABBPV7175K,feed
        self.presentWindow.makeToastActivity(message: "Loading..")
        var userid = UserDefaults.standard.value(forKey: "userid")
        let pan = UserDefaults.standard.value(forKey: "pan") as? String
        if flag != "0"{
            userid! = flag
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        
        let pan1 = pan?.replacingOccurrences(of: "'", with: "")
        let url = "\(Constants.BASE_URL)settings/cutoffservice_ws.php/getShemecodeWBR/\(Schemecode!),\(pan1!),feed"
        print(url,"bank")
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    print(data.isEmpty)
                    if data.isEmpty != true{
                        for type in data{
                            if let bank_id_1 = type.value(forKey: "bank_id") as? String,
                                let bank_name = type.value(forKey: "bankname") as? String
                            {
                                print(bank_id_1)
                                print("$$$$$")
                                //self.presentWindow.hideToastActivity()
                                self.bank_id = bank_id_1
                                //self.bankNameTf.text = bank_name
                                if self.bse_reg_code != "Y"{
                                    self.clientregistrationBse(userid: userid as! String)
                                } else {
                                    self.presentWindow.hideToastActivity()
                                }
                                //self.fetchSchemeName(s_code: self.Schemecode!)
                            }
                        }
                    } else{
                        self.presentWindow.hideToastActivity()
                        print("hello")
                    }
                }
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func addtocart(id:String,tenure: String,units:String,amount:String,type:String,frequency:String, userid: String, sessionid:String, perpetual:String){
        
        
        let parameters = ["id":"\(id.covertToBase64())","tenure":tenure.covertToBase64(),"unit":units.covertToBase64(),"amount":amount.covertToBase64(),"type":type.covertToBase64(),"frequency":frequency.covertToBase64(),"userid":userid.covertToBase64(),"sessionid":sessionid.covertToBase64(),"perpetual":perpetual.covertToBase64(),"enc_resp":"3"] as [String : Any]
        print(parameters)
        presentWindow.makeToastActivity(message: "Loading.")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addToCart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value ?? "")
                    let cart_id = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                    if cart_id != nil {
                        self.addtransaction(cart_id: Int(cart_id!) ?? 0, user_id: userid, folio_no: "\(self.folio_no!)", bank_id: "\(self.bank_id!)")
                    }
                    
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func addtransaction(cart_id:Int,user_id:String,folio_no:String,bank_id:String){
        presentWindow.makeToastActivity(message: "Processing..")
        let url = "transaction/transaction_ws.php/addtransaction"
        let parameters = ["txn_id":"","user_id":"\(user_id.covertToBase64())","cart_id":"\(cart_id)","bank_id":"\(bank_id.covertToBase64())","status":"", "trxntype":"R", "folio_no":"\(folio_no.covertToBase64())","enc_resp":"3"]
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(url)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value!)
                    self.presentWindow.hideToastActivity()
                    let transaction_id = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                    if let transactionid = Int(transaction_id!){
                        print(transactionid)
                        //http://www.erokda.in/adminpanel/transaction/transaction_ws.php/fetchTransactionIdUnitData/trnsarr[0]=1200/all/1305/EFYPK0306A
                        self.fetchTrxndetails(t_id:transactionid)
                    } else{
                        
                    }
              }
            
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func fetchTrxndetails(t_id:Int){
        let pan = UserDefaults.standard.value(forKey: "pan") as? String
        //adminpanel/transaction_ws.php/fetchTransactionIdUnitData/transarr/all/schemecode/pan
        let url = "\(Constants.BASE_URL)\(Constants.API.fetchTransactionIdUnitData)/trnsarr[0]=\(t_id)/all/\(Schemecode!)/\(pan!.covertToBase64())/3"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseString { response in
                print(response.result.value)
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
                let data = dict
                if let data1 = data as? [AnyObject]{
                    for type in data1{
                        print(data1)
                        if let  RT_CODE = type.value(forKey: "RT_CODE") as? String,
                            let transaction_id = type.value(forKey: "transaction_id") as? String,
                            let user_name = type.value(forKeyPath: "user_name") as? String,
                            let email = type.value(forKeyPath: "email") as? String,
                            let S_NAME = type.value(forKeyPath: "S_NAME") as? String,
                            let transaction_date = type.value(forKeyPath: "transaction_date") as? String,
                            let mobile = type.value(forKeyPath: "mobile") as? String{
                            print(RT_CODE)
                            print(transaction_id)
                           // "adminpanel/transaction/transaction_ws.php/fetchTransactionIdUnitData/trnsarr[0]=1820&trnsarr[1]=1821&trnsarr[2]=1822/all/10223/EFYPK0306A
                           // self.GenerateFile(RT_CODE: RT_CODE,transaction_id:transaction_id,user_name:user_name,email:email,S_NAME:S_NAME,transaction_date:transaction_date,mobile:mobile)
                            
                            self.bseNormalOrderEntry(transaction_id: transaction_id, user_name: user_name,email:email,S_NAME:S_NAME, transaction_date:transaction_date,mobile: mobile)
                        }
                    }
                    // print(self.countriesArr)
                }
              //  self.cityTableView.reloadData()
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }

    func bseNormalOrderEntry(transaction_id:String,user_name:String,email:String,S_NAME:String,transaction_date:String,mobile:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.NormalOrderEntry)\(transaction_id)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data = response.result.value as? [String:Any]
                if let bse_reg_status = data?["bse_err_status"] as? String{
                    if bse_reg_status != "FAIL" {
                        self.UpdateGenerateFileStatus(txnId:transaction_id,user_name:user_name, email: email,S_NAME:S_NAME,transaction_date:transaction_date,mobile:mobile)
                    } else {
                        
                        
                    }
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func GenerateFile(RT_CODE:String,transaction_id:String,user_name:String,email:String,S_NAME:String,transaction_date:String,mobile:String){
        print(RT_CODE)
        var fileType = ""
        if RT_CODE == "1"{
            //GenerateCAMSFile
            fileType = "GenerateCAMSFile"
        }
        else if RT_CODE == "2"{
            //GenerateKARVYFile
            fileType = "GenerateKARVYFile"
        }
        else if RT_CODE == "6"{
            //GenerateFTFile
            fileType = "GenerateFTFile"
        }
        else if RT_CODE == "14"{
            //GenerateSUNDARAMFile
            fileType = "GenerateSUNDARAMFile"
            
        }
        print("\(Constants.BASE_URL)\(Constants.API.feedFile)\(fileType)")
        let parameters = ["txnId":"\(transaction_id.covertToBase64())","enc_resp":"3"]
        print(parameters)
        
        //http://www.erokda.in/adminpanel/feedfile/feedfile_ws.php/GenerateCAMSFile
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.feedFile)\(fileType)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    let enc_response = response.result.value
                    print(enc_response)
                    var dict = [String:Any]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    print(enc1)
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary3(text: enc)!
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    let data1 = dict
                    if let data = data1 as? [String:Any]{
                    
                        print(data["status"])
                        let status = data["status"] as? String
                        if status ==  "true"{
                            self.presentWindow.hideToastActivity()
                            self.UpdateGenerateFileStatus(txnId:transaction_id,user_name:user_name, email: email,S_NAME:S_NAME,transaction_date:transaction_date,mobile:mobile)
                        } else {
                            self.presentWindow.hideToastActivity()
                        }
                    }
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
        
        
    }
    func UpdateGenerateFileStatus(txnId:String,user_name:String,email:String,S_NAME:String,transaction_date:String,mobile:String){
       
        print("\(Constants.BASE_URL)\(Constants.API.updateGenerateFileStatus)")
        let parameters = ["txnId":"\(txnId.covertToBase64())","enc_resp":"3"]
        print(parameters)
        
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.updateGenerateFileStatus)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    self.presentWindow.hideToastActivity()
                    print(response.result.value)
                    let status = response.result.value?.replacingOccurrences(of: "\n", with: "").base64Decoded() as? String
                    print(status)
                    if status == "\"true\""{
                        self.sendReedemRequestEmailToUser(username: user_name, email: email, S_NAME: S_NAME, transaction_date: transaction_date)
                        self.sendSmsToUSer(mobile: mobile, transaction_date: transaction_date)
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as! PaymentSuccessViewController
                        destVC.success = "Redeem Request Placed Successfully"
                        destVC.titles = "Redeem Request"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        self.navigationController?.pushViewController(destVC, animated: true)
                        
                    }
                    else{
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                        destVC.success = "Redeem Request Placed Unsuccessfully"
                        destVC.titles = "Redeem Request"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        destVC.id = "2"
                        self.navigationController?.pushViewController(destVC, animated: true)
                        //self.presentWindow.makeToast(message: "Something Went wrong")
                    }
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
        
        
    }
    //send user mail
    
    func sendReedemRequestEmailToUser(username:String,email:String,S_NAME:String,transaction_date:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            
            //{
            let s_amt : String!
            if units == "amount"{
                s_amt = "\(String(describing: unitsTf.text!))"
            }
            else if units  == "noofunits"{
                s_amt = "\(String(describing: unitsTf.text!)) Units"
            }
            else{
                s_amt = "All Units"
            }
            let parameters = [
                "ToEmailID":"\(email)",
                "FromEmailID":"",
                "Subject" :"Your redemption request has been submitted successfully - Fintoo",
                "template_name": "redeemsuccess",
                "username":"\(username)",
                "txn_date":"\(transaction_date)",
                "table":"1",
                "scheme_name":"\(S_NAME)",
                "scheme_type":"Redeem",
                "scheme_amount":"\(s_amt!)"
                
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.templates)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
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
                                    print("Success")
                                    self.sendReedemRequestEmailToSupport(username: username, email: email, S_NAME: S_NAME)
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
    
    
    //send suuport mail
    func sendReedemRequestEmailToSupport(username:String,email:String,S_NAME:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        let s_amt : String!
        if units == "amount"{
            s_amt = "\(String(describing: unitsTf.text!))"
        }
        else if units  == "noofunits"{
            s_amt = "\(String(describing: unitsTf.text!)) Units"
        }
        else{
            s_amt = "All Units"
        }
        
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "ToEmailID":"support@fintoo.in",
                "FromEmailID":"",
                "Subject" :"\(username) has made a Redeem request on Fintoo",
                "template_name": "redeemsuccessonline",
                "email":"\(email)",
                "username":"\(username)",
                "table":"1",
                "scheme_name":"\(S_NAME)",
                "scheme_type":"Redeem",
                "scheme_amount":"\(s_amt!)"
                
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.templates)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
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
                                    print("Success Online Support Email")
                                   
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
    func sendSmsToUSer(mobile:String,transaction_date:String){
        //let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "mobile":"\(mobile)",
                "msg":"Your transaction with  Fintoo has been successfully placed on \(transaction_date). You will receive the confirmation shortly, subjected to funds realisation from Fund House. For any urgent query, call us directly on 9699 800600","enc_resp":"3"
            ]
            print(parameters)
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_SMS)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
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
                    let data = dict
                    if let response = data as? [[String: AnyObject]] {
                        let msg_code = String(response[0]["code"] as! Int)
                        print(msg_code)
                        if msg_code != Constants.ERROR_CODE_1701 {
                            self.presentWindow!.makeToast(message: "Failed To Send Message On Mobile")
                        }
                        else{
                            print("send message")
                        }
                    }
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    // BSE API
    
    func clientregistrationBse(userid:String){
        print("Modify ucc data")
        let url = "\(Constants.BASE_URL)\(Constants.API.clientregistration)\(userid)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value as? [String:Any]
                if let response_status = data?["response"] {
                    if data?["status"] != nil && data?["status"] as? String == "Error" {
                        self.presentWindow.hideToastActivity()
                        
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
                    self.presentWindow.hideToastActivity()
                    let alert = UIAlertController(title: "Alert", message: "\(data!["bse_err_status"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                        print("Ok button clicked")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if self.bse_aof_status_code != "1" {
                        self.AOFImageUpload(userid: userid)
                    }else {
                    }
                }
            }
        } else {
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func AOFImageUpload(userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.AOFImageUpload)\(userid)"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                let data = response.result.value as? [String:String]
                if data?["bse_err_status"] != nil && data?["bse_err_status"]  == "FAIL" {
                    self.presentWindow.hideToastActivity()
                    let alert = UIAlertController(title: "Alert", message: "\(data!["bse_err_status"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                        print("Ok button clicked")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.presentWindow.hideToastActivity()
                    //self.presentWindow.makeToast(message: "AOF Uploaded Successfully")
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }

}
