//
//  transactSwitchViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 20/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class transactSwitchViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var selectActionTableView: UITableView!
    
    @IBOutlet weak var schemeNameTableView: UITableView!
    
    @IBOutlet weak var toSchemeTableView: UITableView!
    
    @IBOutlet weak var label_units: UILabel!
    @IBOutlet weak var unitsTf: UITextField!
    
    @IBOutlet weak var selectActionTF: UITextField!
    @IBOutlet weak var schemeNameTF: UITextField!
    @IBOutlet weak var toSchemeTF: UITextField!
    var no_of_units : String!
    var curr_value : String!
    var units = ""
    var similarFundLsitArr = [SimilarFundSchemeList]()
    var transactionArrs = [String]()
    var selectAction : String!
    var SchemeName : String!
    var Schemecode : String!
    var acc_no : String!
    var folio_no : String!
    var bank_acc_no_from_bank_list = [String: [String:String]]()
    var bank_id : String!
   // var toScheme  = "HDFC Arbitrage-WP(G)"
    var toSchemeID = ""
    var toMININVT = "0"
    var SI_t_id : Int!
    var SO_t_id : Int!
    var row : Int!
    var trxnnumber : String!
    var mininvest : String!
    var swpcid : String!
    var stptxnid : String!
    var stpcid : String!
    var bse_aof_status_code = ""
    var bse_reg_code = ""
    var minredeemUnit = ""
    var minredeemAmt = ""
    var curr_nav = ""
    var swptxnid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(transactionArrs)
        addBackbutton()
        getBankId()
        selectActionTableView.isHidden = true
        
        toSchemeTableView.isHidden = true
        //
        schemeNameTF.text = SchemeName
        selectActionTF.text = selectAction
        //toSchemeTF.text = toScheme
        selectActionTableView.delegate = self
        selectActionTableView.dataSource = self
       
        toSchemeTableView.delegate = self
        toSchemeTableView.dataSource = self
        print(bank_acc_no_from_bank_list)
        print(acc_no)
        let swptxnid1 = UserDefaults.standard.value(forKey: "swptxnid") as? String ?? ""
        if swptxnid1 != "" {
            swptxnid = swptxnid1
        }
        // bank_id = bank_acc_no_from_bank_list[acc_no]!["bank_id"]
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.title = "TRANSACT ONLINE"
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Switch Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
        destVC.selectIndexValue = true
        
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectActionTableView{
            return transactionArrs.count
        }
       
        else{
            return similarFundLsitArr.count
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func getBankId(){
        //Security Note done because it return html responce
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
                if let data = response.result.value as? [AnyObject]{
                    print(data.isEmpty)
                    if data.isEmpty != true{
                        for type in data{
                            if let bank_id_1 = type.value(forKey: "bank_id") as? String
                            {
                                print(bank_id_1)
                                print("$$$$$")
                                self.bank_id = bank_id_1
                                
                                self.fetchSchemeName(s_code: self.Schemecode!, userid: userid as! String)
                            }
                        }
                    } else{
                        print("hello")
                    }
                }
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == selectActionTableView{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "selectAction", for: indexPath)
            cell.textLabel?.text = transactionArrs[indexPath.row]
            return cell
        }
       
        else{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "toScheme", for: indexPath)
            cell.textLabel?.text = similarFundLsitArr[indexPath.row].scheme
            
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectActionTableView{
            let cell = selectActionTableView.cellForRow(at: indexPath)
            selectActionTF.text = cell?.textLabel?.text
            selectActionTableView.isHidden = true
            selectActionTF.text = cell?.textLabel?.text
            if selectActionTF.text  == "Additional Purchase"{
                     //transacttf.text = "Additional Purchase"
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "AdditionalPurchaseViewController") as! AdditionalPurchaseViewController
                    destVC.transactionArrs = transactionArr[row].valid_for
                    destVC.selectAction = "Additional Purchase"
                    destVC.SchemeName = transactionArr[row].scheme_name
                    destVC.Schemecode = transactionArr[row].schemecode
                    destVC.folio_no = transactionArr[row].folio_no
                    destVC.acc_no = transactionArr[row].account_no
                    destVC.bank_acc_no_from_bank_list = bank_acc_no_from_bank_list
                    destVC.no_of_units = transactionArr[row].no_of_units!
                    destVC.curr_value = transactionArr[row].curr_value1
                    destVC.trxnnumber = transactionArr[row].trxnnumber
                    destVC.row = row
                    destVC.bse_aof_status_code = self.bse_aof_status_code
                    destVC.bse_reg_code = self.bse_reg_code
                    destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                    destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                    destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                    navigationController?.pushViewController(destVC, animated: true)
                }
             else if selectActionTF.text == "Redeem"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "ReedemViewController") as! ReedemViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Redeem"
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTF.text  == "Switch"{
                
            }
            else if selectActionTF.text  == "Stop SIP"{
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
                destVC.row = row
                destVC.mininvest = transactionArr[row].mininvest
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTF.text == "Stop SWP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSWPViewController") as! StopSWPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Stop SWP"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.row = row
                destVC.mininvest = transactionArr[row].mininvest
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTF.text == "Stop STP"{
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
                destVC.row = row
                destVC.mininvest = transactionArr[row].mininvest
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTF.text == "Start SWP"{
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
                destVC.row = row
                destVC.mininvest = transactionArr[row].mininvest
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTF.text  == "Start STP"{
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
                destVC.row = row
                destVC.mininvest = transactionArr[row].mininvest
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
                
            }
            
            }
        
        
        else{
            let cell = toSchemeTableView.cellForRow(at: indexPath)
            toSchemeTF.text = cell?.textLabel?.text
            toSchemeID = similarFundLsitArr[indexPath.row].schemecode!
            toMININVT = similarFundLsitArr[indexPath.row].MININVT!
            print(toSchemeID)
            toSchemeTableView.isHidden = true
        }
    }
    
    
    @IBAction func selectActionBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Switch Screen :- Select Action DropDown Button Clicked")
        self.selectActionTableView.isHidden = !self.selectActionTableView.isHidden
      //  schemeNameTableView.isHidden = true
        toSchemeTableView.isHidden = true
    }
    
    
    @IBAction func schemeNameBtnPrsd(_ sender: Any) {
        self.schemeNameTableView.isHidden = !self.schemeNameTableView.isHidden
        self.selectActionTableView.isHidden = true
        self.toSchemeTableView.isHidden = true
        toSchemeTableView.reloadData()
    }
    
    
    
    @IBAction func toSchemeBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Switch Screen :- To Scheme Dropdown Button Clicked")
        self.toSchemeTableView.isHidden = !self.toSchemeTableView.isHidden
        self.selectActionTableView.isHidden = true
       // self.schemeNameTableView.isHidden = true
    }
    
    
    @IBAction func submitBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Switch Screen :- Submit Button Clicked")
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
         let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        if units == ""{
            presentWindow.makeToast(message: "Please Select units or amount")
            Mixpanel.mainInstance().track(event: "Switch Screen :- Please Select units or amount")
        }
        else if units != "all" && unitsTf.text == "" {
            presentWindow.makeToast(message: "Please enter units or amount")
            Mixpanel.mainInstance().track(event: "Switch Screen :- Please enter units or amount")
        }
        else if unitsTf.text == "0"{
            presentWindow.makeToast(message: "Please enter units or amount")
            Mixpanel.mainInstance().track(event: "Switch Screen :- Please enter units or amount")
        }
        else if units == "noofunits" && Int(unitsTf.text!)! > Int(truncating: no_of_units.numberValue!) {
            presentWindow.makeToast(message: "You have only \(no_of_units!) units to switch from this folio")
            Mixpanel.mainInstance().track(event: "Switch Screen :- You have only \(no_of_units!) units to switch from this folio")
        }
        else if units == "noofunits" && Int(unitsTf.text!)! < Int(Float(toMININVT)!/Float(curr_nav)!) {
            presentWindow.makeToast(message: "You can minimum \(Int(Float(toMININVT)!/Float(curr_nav)!)) units to switch into selected scheme")
            Mixpanel.mainInstance().track(event: "Switch Screen :- You have only \(Int(Float(toMININVT)!/Float(curr_nav)!)) units to switch from this folio")
        }
        else if units == "amount" && Int(unitsTf.text!)! > Int(truncating: curr_value.numberValue!){
            //  You have only 58854 Rs. to redeem from this folio
            presentWindow.makeToast(message: "You have only \(curr_value!) RS. to switch from this folio")
            Mixpanel.mainInstance().track(event: "Switch Screen :- You have only \(curr_value!) RS. to switch from this folio")
        }
        else if units == "amount" && Int(unitsTf.text!)! < Int(toMININVT)!{
            //  You have only 58854 Rs. to redeem from this folio
            presentWindow.makeToast(message: "You need minimum \(toMININVT) Rs. to switch into selected scheme")
            Mixpanel.mainInstance().track(event: "Switch Screen :- You have only \(toMININVT) RS. to switch from this folio")
        }
        else if  toSchemeTF.text == "Select Scheme"{
             Mixpanel.mainInstance().track(event: "Switch Screen :- Please Select to scheme")
            presentWindow.makeToast(message: "Please Select to scheme")
        }
        else{
            if units == "amount"{
              //  id=schemecode, tenure="", amount, unit, type=6,frequency="",userid,sessionid="",perpetual=""
                addtocart(id: Schemecode, tenure: "", units: "", amount: unitsTf.text!, type: "6", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "")
                
            }
            else if units == "noofunits"{
                addtocart(id: Schemecode, tenure: "", units: unitsTf.text!, amount: "", type: "6", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "")
            }
            else{
                addtocart(id: Schemecode, tenure: "", units: "", amount: "", type: "6", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "")
            }
        }
    }
    
    
    @IBOutlet weak var noOfUnitsBtn: UIButton!
    @IBAction func noOfUnitsBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Switch Screen :- No Of Units Button Clicked")
        noOfUnitsBtn.setImage(UIImage(named: "check"), for: .normal)
        allUnits.setImage(UIImage(named: "uncheck"), for: .normal)
        amountBtn.setImage(UIImage(named: "uncheck"), for: .normal)
        unitsTf.isEnabled = true
        units = "noofunits"
        unitsTf.text = ""
        label_units.text = "Your max units to switch from this folio is \(no_of_units!)"
    }
    
    @IBOutlet weak var allUnits: UIButton!
    
    @IBAction func allUnits(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Switch Screen :- All Units Button Clicked")
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
        Mixpanel.mainInstance().track(event: "Switch Screen :- Amount Button Clicked")
        noOfUnitsBtn.setImage(UIImage(named: "uncheck"), for: .normal)
        allUnits.setImage(UIImage(named: "uncheck"), for: .normal)
        amountBtn.setImage(UIImage(named: "check"), for: .normal)
        unitsTf.isEnabled = true
        units = "amount"
        label_units.text = "Your max amount to Switch from this folio is Rs. \(curr_value!)"
        unitsTf.text = ""
    }
    
    
    func addtocart(id:String,tenure: String,units:String,amount:String,type:String,frequency:String, userid: String, sessionid:String, perpetual:String){
        
        let parameters = ["id":"\(id.covertToBase64())","tenure":tenure.covertToBase64(),"unit":units.covertToBase64(),"amount":amount.covertToBase64(),"type":type.covertToBase64(),"frequency":frequency.covertToBase64(),"userid":userid.covertToBase64(),"sessionid":sessionid.covertToBase64(),"perpetual":perpetual.covertToBase64(),"enc_resp":"3"] as [String : Any]
        print(parameters)
        presentWindow.makeToastActivity(message: "Loading.")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addtostpswpcart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value ?? "")
                    let cart_id = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                    if cart_id != nil {
                    print(userid)
                    print(self.folio_no!)
                    print(self.bank_id!)
                    self.addtransaction(cart_id: Int(cart_id!) ?? 0, user_id: userid, folio_no: "\(self.folio_no!)", bank_id: "\(self.bank_id!)", trxntype: "SO", SI_id: "", transaction_SI_for_SO: "")
                    }
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func sIAddtocart(id:String,tenure: String,units:String,amount:String,type:String,frequency:String, userid: String, sessionid:String, perpetual:String,SI_id:String){
        //id=schemecode, tenure="", amount, unit, type=6,frequency="",userid,sessionid="",perpetual=""
        
        let parameters = ["id":"\(id.covertToBase64())","tenure":tenure.covertToBase64(),"unit":units.covertToBase64(),"amount":amount.covertToBase64(),"type":type.covertToBase64(),"frequency":frequency.covertToBase64(),"userid":userid.covertToBase64(),"sessionid":sessionid.covertToBase64(),"perpetual":perpetual.covertToBase64(),"enc_resp":"3"] as [String : Any]
        print(parameters)
        //presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addtostpswpcart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value ?? "")
                    let cart_id = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                    if cart_id != nil {
                    print(userid)
                    self.addtransaction(cart_id: Int(cart_id!) ?? 0, user_id: userid, folio_no: "\(self.folio_no!)", bank_id: "\(self.bank_id!)", trxntype: "SI",SI_id:SI_id, transaction_SI_for_SO: "\(self.SI_t_id!)")
                    }
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func addtransaction(cart_id:Int,user_id:String,folio_no:String,bank_id:String,trxntype:String,SI_id:String,transaction_SI_for_SO:String){
        
        
        // as [String : Any]
        
       // presentWindow.makeToastActivity(message: "Loading..")
        let url = "transaction/transaction_ws.php/addtransaction"
        
        //  txn_id="", user_id, cart_id="response from above web service", bank_id, status="",trxntype="SO", folio_no
        //txn_id="", user_id, cart_id="response from above web service", bank_id, status="",trxntype="SI", folio_no, transaction_SI_for_SO = generated txn id from SO
        let parameters = ["txn_id":"","user_id":"\(user_id.covertToBase64())","cart_id":"\(cart_id)","bank_id":"\(bank_id.covertToBase64())","status":"", "trxntype":"\(trxntype.covertToBase64())", "folio_no":"\(folio_no.covertToBase64())","transaction_SI_for_SO":"\(transaction_SI_for_SO.covertToBase64())","enc_resp":"3"] as [String : Any]
        print(parameters)
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(url)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value!)
                    let transaction_id = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                   
                    if let transactionid = Int(transaction_id!){
                        print(transactionid)
                        if SI_id == "1"{
                            self.fetchTrxndetails(t_id:transactionid, SI_id: SI_id, SI_t_id: self.SI_t_id!, SI_T_ID1: transactionid, userid: user_id)
                        }
                        else{
                            self.SO_t_id = transactionid
                            self.SI_t_id = transactionid
                            self.fetchTrxndetails(t_id:transactionid, SI_id: SI_id, SI_t_id: transactionid, SI_T_ID1: 0,userid: user_id)
                        }
                    }
                    else{
                         self.presentWindow.hideToastActivity()
                    }
                    
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    
    
    func fetchTrxndetails(t_id:Int,SI_id:String,SI_t_id:Int,SI_T_ID1 : Int,userid:String){
       // pan
        let pan = UserDefaults.standard.value(forKey: "pan") as? String
        print(pan ?? "pan")
        var url = ""
        if SI_id == "1"{
            url = "\(Constants.BASE_URL)\(Constants.API.fetchTransactionIdData)/trnsarr[0]=\(SI_T_ID1)/3"
        }
        else{
             url = "\(Constants.BASE_URL)\(Constants.API.fetchTransactionIdData)/trnsarr[0]=\(t_id)/3"
        }
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
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
                    // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                }
                let data = dict
                if let data1 = data as? [AnyObject]{
                    var RT_CODE = ""
                    var transaction_id = ""
                    var user_name = ""
                    var email = ""
                    var S_NAME = ""
                    var transaction_date = ""
                    var mobile = ""
                    for type in data1{
                        print(data)
                        RT_CODE = type.value(forKey: "RT_CODE") as? String ?? ""
                        transaction_id = type.value(forKey: "transaction_id") as? String ?? ""
                        user_name = type.value(forKey: "user_name") as? String ?? ""
                        email = type.value(forKey: "email") as? String ?? ""
                        S_NAME = type.value(forKey: "S_NAME") as? String ?? ""
                        transaction_date = type.value(forKey: "transaction_date") as? String ?? ""
                        mobile = type.value(forKey: "mobile") as? String ?? ""
                    }
                    //self.GenerateFile(RT_CODE: RT_CODE,transaction_id:transaction_id,user_name:user_name,email:email,S_NAME:S_NAME,transaction_date:transaction_date,mobile:mobile, SI_id: SI_id)
                            
                    if SI_id != "1"{
                        if self.units == "amount"{
                            //  id=schemecode, tenure="", amount, unit, type=6,frequency="",userid,sessionid="",perpetual=""
                            self.sIAddtocart(id: self.toSchemeID, tenure: "", units: "", amount: self.unitsTf.text!, type: "5", frequency: "", userid: userid, sessionid: "\(sessionId!)", perpetual: "", SI_id: "1")
                            
                        }
                        else if self.units == "noofunits"{
                            self.sIAddtocart(id: self.toSchemeID, tenure: "", units: self.unitsTf.text!, amount: "", type: "5", frequency: "", userid: userid, sessionid: "\(sessionId!)", perpetual: "", SI_id: "1")
                        }
                        else{
                            self.sIAddtocart(id: self.toSchemeID, tenure: "", units: "", amount: "", type: "5", frequency: "", userid: userid, sessionid: "\(sessionId!)", perpetual: "", SI_id: "1")
                        }
                        
                        
                    } else {
                        self.bseSwitchOrderEntry(user_name: user_name, email: email, S_NAME: S_NAME, transaction_date: transaction_date, mobile: mobile, from_trxn_id: self.SO_t_id, to_trxn_id: SI_T_ID1)
                        print("call bse api")
                    }
                    
                    }
                }
                
            }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func bseSwitchOrderEntry(user_name:String,email:String,S_NAME:String,transaction_date:String,mobile:String,from_trxn_id:Int,to_trxn_id :Int){
        let url = "\(Constants.BASE_URL)\(Constants.API.SwitchOrderEntry)trnsarr[0]=\(from_trxn_id)&trnsarr[1]=\(to_trxn_id)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                print(response.result.value as? [String:Any])
                let data = response.result.value as? [String:Any]
                if let bse_reg_status = data?["bse_err_status"] as? String{
                    if bse_reg_status != "FAIL" {
                        self.presentWindow.hideToastActivity()
                        self.UpdateGenerateFileStatus(user_name:user_name, email: email, S_NAME:S_NAME, transaction_date:transaction_date, mobile:mobile, to_trxn_id:self.SI_t_id, from_trxn_id: self.SO_t_id,update_status: "N")
                    } else {
                        self.presentWindow.hideToastActivity()
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                        destVC.success = "Switch Request Placed Unsuccessfully"
                        destVC.titles = "Switch Request"
                        destVC.id = "2"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func GenerateFile(RT_CODE:String,transaction_id:String,user_name:String,email:String,S_NAME:String,transaction_date:String,mobile:String,SI_id:String){
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
       
        let url = "\(Constants.BASE_URL)\(Constants.API.feedFile)\(fileType)"
        print(url)
        let parameters = ["txnId":"\(transaction_id.covertToBase64())","enc_resp":"3"]
        print(parameters,"feed file")
        if Connectivity.isConnectedToInternet {
            print("@@@@@@@@@@@@@@@@@@@@@@@@")
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print("hello")
                    print(response.value ?? "generate status")
                    print(response.result.value ?? "generate status")
                    let enc_response = response.result.value
                    var dict = [String:Any]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary3(text: enc)!
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    let data1 = dict
                    if let data = data1 as? [String:Any]{
                        let status = data["status"] as? String
                        if status == "true"{
                            //self.presentWindow.hideToastActivity()
                            self.UpdateGenerateFileStatus(user_name:user_name, email: email, S_NAME:S_NAME, transaction_date:transaction_date, mobile:mobile, to_trxn_id:self.SI_t_id, from_trxn_id: self.SO_t_id,update_status: "N")
                        } else {
                            self.presentWindow.hideToastActivity()
                        }
                    }
                    
                    //self.presentWindow.hideToastActivity()
                    
               }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
        
        
    }
    
    func UpdateGenerateFileStatus(user_name:String,email:String,S_NAME:String,transaction_date:String,mobile:String,to_trxn_id :Int,from_trxn_id:Int,update_status:String){
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        var parameters = [String:Any]()
        if flag != "0"{
            userid! = flag
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        if update_status != "Y" {
            parameters = ["txnId":"\(covertToBase64(text: String(from_trxn_id)))","txnstid":"9","enc_resp":"3"]
        } else {
            parameters = ["txnId":"\(covertToBase64(text: String(to_trxn_id)))","txnstid":"9","enc_resp":"3"]
        }
        
       
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.updateGenerateFileStatus)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    let status = response.result.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                    if status == "\"true\""{
                        
                        if update_status != "Y" {
                            self.UpdateGenerateFileStatus(user_name:user_name, email: email, S_NAME:S_NAME, transaction_date:transaction_date, mobile:mobile, to_trxn_id:self.SI_t_id, from_trxn_id: self.SO_t_id,update_status: "Y")
                        } else {
                            self.presentWindow.hideToastActivity()
                            self.sendSwitchRequestEmailToUser(username: user_name, email: email, S_NAME: S_NAME, transaction_date: transaction_date)
                            self.sendSmsToUSer(mobile: mobile, transaction_date: transaction_date)
                            let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as! PaymentSuccessViewController
                            destVC.success = "Switch Request Placed Successfully"
                            destVC.titles = "Switch Request"
                            //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                            self.navigationController?.pushViewController(destVC, animated: true)
                        }
//                        if SI_id != "1"{
//                            if self.units == "amount"{
//                                //  id=schemecode, tenure="", amount, unit, type=6,frequency="",userid,sessionid="",perpetual=""
//                                self.sIAddtocart(id: self.toSchemeID, tenure: "", units: "", amount: self.unitsTf.text!, type: "5", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "", SI_id: "1")
//
//                            }
//                            else if self.units == "noofunits"{
//                                self.sIAddtocart(id: self.toSchemeID, tenure: "", units: self.unitsTf.text!, amount: "", type: "5", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "", SI_id: "1")
//                            }
//                            else{
//                                self.sIAddtocart(id: self.toSchemeID, tenure: "", units: "", amount: "", type: "5", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "", SI_id: "1")
//                            }
//
//
//                        }
//                        else{
//                            self.presentWindow.hideToastActivity()
//                            self.sendSwitchRequestEmailToUser(username: user_name, email: email, S_NAME: S_NAME, transaction_date: transaction_date)
//                            self.sendSmsToUSer(mobile: mobile, transaction_date: transaction_date)
//                            let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                            let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as! PaymentSuccessViewController
//                            destVC.success = "Switch Request Placed Successfully"
//                            destVC.titles = "Switch Request"
//                            //destVC.successLabel!.text = "Reedem Request Placed Successfully"
//                            self.navigationController?.pushViewController(destVC, animated: true)
//                        }
                    }
                    
                    else{
                         self.presentWindow.hideToastActivity()
                    }
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
        
        
    }
    
    func sendSwitchRequestEmailToUser(username:String,email:String,S_NAME:String,transaction_date:String){
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
                "ToEmailID":"\(email.covertToBase64())",
                "FromEmailID":"",
                "Subject" :"\(covertToBase64(text: "Your Switch request submitted successfully - Fintoo"))",
                "template_name": "\(covertToBase64(text: "switchsuccess"))",
                "username":"\(username.covertToBase64())",
                "txn_date":"\(transaction_date.covertToBase64())",
                "table":"1",
                "scheme_name":"\(schemeNameTF.text?.covertToBase64() ?? "") to \(toSchemeTF.text?.covertToBase64() ?? "") ",
                "scheme_type":"\(covertToBase64(text: "Switch"))",
                "scheme_amount":"\(s_amt!.covertToBase64())",
                "enc_resp":"3"
                
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.templates)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    print(response.result.value ?? "value")
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                    }
                    let data = dict
                    if let response = data as? [[String: AnyObject]] {
                        let msg_code = response[0]["error"] as? String ?? ""
                        if msg_code != "" {
                            self.presentWindow!.makeToast(message: "Failed To Send Message On Mobile")
                        }
                        else{
                            print("send message")
                            self.sendSwitchRequestEmailToSupport(username: username, email: email, S_NAME: S_NAME)
                        }
                    }
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    
    //send suuport mail
    func sendSwitchRequestEmailToSupport(username:String,email:String,S_NAME:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        //\(username) has made a Switch request on Fintoo
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
                "ToEmailID":"\(covertToBase64(text: "support@fintoo.in"))",
                "FromEmailID":"",
                "Subject" :"\(covertToBase64(text: "\(username) has made a Switch request on Fintoo"))",
                "template_name": "switchsuccessonline",
                "email":"\(email.covertToBase64())",
                "username":"\(username.covertToBase64())",
                "table":"1",
                "scheme_name":"\(schemeNameTF.text?.covertToBase64() ?? "") to \(toSchemeTF.text?.covertToBase64() ?? "") ",
                "scheme_type":"\(covertToBase64(text: "Switch"))",
                "scheme_amount":"\(s_amt!.covertToBase64())",
                "enc_resp":"3"
                
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.templates)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    print(response.result.value ?? "value")
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                    }
                    let data = dict
                    if let response = data as? [[String: AnyObject]] {
                        let msg_code = response[0]["error"] as? String ?? ""
                        if msg_code != "" {
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
    func sendSmsToUSer(mobile:String,transaction_date:String){
        //let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        //Your Switch request on Fintoo has been successfully placed on \(transaction_date). You will receive the confirmation shortly. For any urgent query, call us directly on 9699 800600
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "mobile":"\(mobile)",
                "msg":"Your Switch request on Fintoo has been successfully placed on \(transaction_date). You will receive the confirmation shortly. For any urgent query, call us directly on 9699 800600.","enc_resp":"3"
            ]
            print(parameters)
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_SMS)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    let data = dict
                     if let response = data as? [[String: AnyObject]] {
                        let msg_code = String(response[0]["code"] as? Int ?? 0)
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
    
    func fetchSchemeName(s_code:String,userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.showschemes)\(s_code)/app/3"
        
        print(url)
        similarFundLsitArr.append(SimilarFundSchemeList.getSchemeFund(schemecode: "0", scheme: "Select Scheme", MININVT: "0"))
        presentWindow.makeToastActivity(message: "Loading..")
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
                if let data = dict as? [AnyObject]{
                    if !data.isEmpty {
                       for type in data{
                            //print(data)
                            if let  schemecode = type.value(forKey: "schemecode") as? String,
                                let scheme = type.value(forKey: "scheme") as? String{
                                let MININVT = type.value(forKey: "MININVT") as? String ?? ""
                                self.presentWindow.hideToastActivity()
                                self.similarFundLsitArr.append(SimilarFundSchemeList.getSchemeFund(schemecode: schemecode, scheme: scheme, MININVT: MININVT))
                                if self.bse_reg_code != "Y"{
                                    self.clientregistrationBse(userid: userid as! String)
                                } else {
                                    self.presentWindow.hideToastActivity()
                                }
                            }
                         }
                    } else{
                        
                        self.similarFundLsitArr.append(SimilarFundSchemeList.getSchemeFund(schemecode: "0", scheme: "Select Scheme", MININVT: "0"))
                        self.presentWindow.hideToastActivity()
                    }
                }
                self.toSchemeTableView.reloadData()
            }
        } else{
            presentWindow.hideToastActivity()
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
                    if data?["status"] != nil && data?["status"] as? String   == "Error" {
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
