 //
//  StopSTPViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 16/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import Mixpanel
 
class StopSTPViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var transactionArrs = [String]()
    var selectAction : String!
    var SchemeName : String!
    var Schemecode : String!
    var stptxnid : String!
    var stpcid : String!
    var transaction_cart_ids : String!
    var SI_cart_scheme_code :String!
    var mininvest : String!
    var swpcid : String!
    var acc_no : String!
    var folio_no : String!
    var bank_acc_no_from_bank_list = [String: [String:String]]()
    var bank_id : String!
    var no_of_units : String!
    var curr_value : String!
    var row : Int!
    var trxnnumber : String!
    var SiFundArr = [SiFundObj]()
    var dropdownForSiFund = DropDown()
    var bse_aof_status_code = ""
    var bse_reg_code = ""
    var minredeemUnit = ""
    var minredeemAmt = ""
    var curr_nav = ""
    @IBOutlet weak var selectActionTableview: UITableView!
    @IBOutlet weak var selectActiontf: UITextField!
    @IBOutlet weak var switchInSchemeNameTf: UITextField!
    
    @IBOutlet weak var siBtn: UIButton!
    @IBOutlet weak var switchOutSchemeNameTf: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackbutton()
        switchOutSchemeNameTf.text = SchemeName!
        selectActiontf.text = selectAction!
        selectActionTableview.delegate = self
        selectActionTableview.dataSource = self
        // Do any additional setup after loading the view.
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        if self.bse_reg_code != "Y"{
            self.clientregistrationBse(userid: userid as! String)
        } else {
            self.presentWindow.hideToastActivity()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "TRANSACT ONLINE"
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Stop STP Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
        destVC.selectIndexValue = true
        
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func selectActionBtn(_ sender: Any) {
        selectActionTableview.isHidden = !selectActionTableview.isHidden
    }
    @IBAction func switchInBtn(_ sender: Any) {
        print(stptxnid)
       
        if SiFundArr.count > 1{
            self.dropdownForSiFund.anchorView = self.siBtn
            self.dropdownForSiFund.dataSource = SiFundArr.map { $0.AMFI_NAME ?? ""}
            self.dropdownForSiFund.selectionAction = { [unowned self] (index: Int, item: String) in
                self.switchInSchemeNameTf.text = self.SiFundArr[index].AMFI_NAME
                print(self.SiFundArr[index].transaction_cart_id)
                self.transaction_cart_ids  = self.SiFundArr[index].transaction_cart_id
            }
            self.dropdownForSiFund.show()
        }
        else{
                getSIfundsofuser(txnid: stptxnid!)
        }
        
    }
    
    @IBAction func submit(_ sender: Any) {
        print(stpcid)
        if switchInSchemeNameTf.text == "Select Scheme"{
            presentWindow.makeToast(message: "Please select STP To Scheme")
             Mixpanel.mainInstance().track(event: "Stop STP Screen :- Please select STP To Scheme")
        }
        else{
            bseStopSTP(transaction_id: stptxnid)
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "selectaction", for: indexPath)
        cell.textLabel?.text = transactionArrs[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == selectActionTableview{
            let cell = tableView.cellForRow(at: indexPath)
            selectActiontf.text = cell?.textLabel?.text
            selectActionTableview.isHidden = true
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text == "Redeem"{
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text == "Stop SWP"{
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
            else if selectActiontf.text  == "Stop STP"{
                
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
                
            }
            //return cell
        }
    }
    func getSIfundsofuser(txnid : String){
        let parameters = ["txnid":"\(txnid)"]
        print(parameters,">>>>>>")
        let url = "\(Constants.BASE_URL)\(Constants.API.getSIfundsofuser)"
        print(url)
        SiFundArr.removeAll()
        SiFundArr.append(SiFundObj(transaction_id: "0", transaction_cart_id: "0", cart_amount: "0", AMFI_NAME: "Select Scheme", cart_scheme_code: "0"))
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
           // self.totalCartValue = 0
            Alamofire.request(url,method: .post,parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                self.presentWindow.hideToastActivity()
                if let data = response.result.value as? [[String: AnyObject]] {
                        // "transaction_folio_no": "10901677/71",
                           for object in data {
                            let transaction_id = object["transaction_id"] as? String ?? ""
                            let transaction_cart_id = object["transaction_cart_id"] as? String ?? ""
                            let cart_amount = object["cart_amount"] as? String ?? ""
                            let AMFI_NAME = object["AMFI_NAME"] as? String ?? ""
                            let cart_scheme_code = object["cart_scheme_code"] as? String ?? ""
                            
                            
                            let docObj = SiFundObj(transaction_id: transaction_id, transaction_cart_id: transaction_cart_id, cart_amount: cart_amount, AMFI_NAME: AMFI_NAME, cart_scheme_code: cart_scheme_code)
                            self.SiFundArr.append(docObj)
                            //self.stpcid = transaction_cart_id
                            
                            
                        }
                    print(self.SiFundArr.count)
                    self.dropdownForSiFund.anchorView = self.siBtn
                    //self.dropdownForSiFund.textFont = UIFont.systemFont(ofSize: 10)
                    //self.dropdownForSiFund.textFon
                    self.dropdownForSiFund.cellHeight = 60
                    self.dropdownForSiFund.dataSource = self.SiFundArr.map { $0.AMFI_NAME }
                    self.dropdownForSiFund.selectionAction = { [unowned self] (index: Int, item: String) in
                        self.switchInSchemeNameTf.text = self.SiFundArr[index].AMFI_NAME
                        print(self.SiFundArr[index].transaction_cart_id)
                        self.transaction_cart_ids  = self.SiFundArr[index].transaction_cart_id
                        self.SI_cart_scheme_code = self.SiFundArr[index].cart_scheme_code
                    }
                    self.dropdownForSiFund.show()
                    }
                }
            }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func stopSTP(schemecode : String,transaction_cart_id:String,cartptype:String,SO_ID:String){
        let url = "cart/cart_ws.php/stopsipswpstp"
        //adminpanel/cart/cart_ws.php/stopsipswpstp
        //  schemecode, amount="", cartptype = 2, cart_id=transaction_cart_idice, bank_id, status="", trxntype="SOU", trxndate=cartsipdate, transaction_folio_no
        let parameters = ["schemecode":"\(schemecode.covertToBase64())","amount":"","cartptype" :"\(cartptype.covertToBase64())","cart_id":"\(transaction_cart_id.covertToBase64())","enc_resp":"3"]
        print(parameters,"transaction>>>>>>")
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(url)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value!)
                    print(response.result.value ?? "")
                    self.presentWindow.hideToastActivity()
                    let data = response.result.value?.replacingOccurrences(of: "\n", with: "").base64Decoded() as? String
                    
                    if data == "\"true\""{
                        
                        let name = UserDefaults.standard.value(forKey: "name") as? String
                        let email = UserDefaults.standard.value(forKey: "Email") as? String
                        let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
                        
                        
                        if SO_ID == "1"{
                            self.sendStopSTPRequestEmailToUser(username: name!, email: email!)
                            self.sendSmsToUSer(mobile: phone!)
                            let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as! PaymentSuccessViewController
                            destVC.success = "Stop STP Request Placed Successfully"
                            destVC.titles = "Stop STP Request"
                            //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                            self.navigationController?.pushViewController(destVC, animated: true)
                        }
                        else{
                            self.stopSTP(schemecode: self.SI_cart_scheme_code!, transaction_cart_id: self.transaction_cart_ids!, cartptype: "8", SO_ID: "1")
                        }
                    }
                    else{
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                        destVC.success = "Stop STP Request Placed Unsuccessfully"
                        destVC.titles = "Stop STP Request"
                        destVC.id = "2"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                    
                    //call send mail to user
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func sendStopSTPRequestEmailToUser(username:String,email:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            
            
            let parameters = [
                "ToEmailID":"\(email.covertToBase64())",
                "FromEmailID":"",
                "Subject" :"\(covertToBase64(text: "Stop STP request - Fintoo")) ",
                "template_name": "\(covertToBase64(text: "stoprequest"))",
                "username":"\(username.covertToBase64())",
                "txn_date":"",
                "type":"\(covertToBase64(text: "STP"))",
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
                            self.sendStopSTPRequestEmailToSupport(username: username, email: email)
                        }
                    }
                   
                    
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    
    //send suuport mail
    func sendStopSTPRequestEmailToSupport(username:String,email:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "ToEmailID":"\(covertToBase64(text: "support@fintoo.in"))",
                "FromEmailID":"",
                "Subject" :"\(covertToBase64(text: "Stop STP request for \(username) on Fintoo"))",
                "template_name": "\(covertToBase64(text: "stoprequestonline"))",
                "email":"\(email.covertToBase64())",
                "username":"\(username.covertToBase64())",
                "type":"\(covertToBase64(text: "STP"))",
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
    func sendSmsToUSer(mobile:String){
        //let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        //Your request to stop SIP/SWP/STP (Ref No - >>Insert ref. No here<<) on Fintoo has been received. For any urgent query, call us directly on 9699 800600
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "mobile":"\(mobile)",
                "msg":"Your request to stop STP on Fintoo has been received. For any urgent query, call us directly on 9699 800600",
                "enc_resp":"3"
                
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
                    if data?["status"] != nil && data?["status"] as? String  == "Error" {
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
    func bseStopSTP(transaction_id:String){
        //https://www.financialhospital.in/adminpanel/bse/bse_ws.php/STPCancellation
        let url = "\(Constants.BASE_URL)\(Constants.API.STPCancellation)/\(transaction_id)"
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(url)").responseJSON { response in
                print(response.result.value as? [String:Any])
                let data = response.result.value as? [String:Any]
                if let bse_reg_status = data?["bse_err_status"] as? String{
                    if bse_reg_status != "FAIL" {
                        print("succes%%%%%")
                        self.stopSTP(schemecode: self.Schemecode!, transaction_cart_id: self.stpcid!, cartptype: "9", SO_ID: "0")
                    } else {
                        print("fail%%%%%")
//                        self.presentWindow.hideToastActivity()
//                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
//                        destVC.success = "Stop SIP Request Placed Unsuccessfully"
//                        destVC.titles = "Stop SIP Request"
//                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
//                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                }else {
                    self.stopSTP(schemecode: self.Schemecode!, transaction_cart_id: self.stpcid!, cartptype: "9", SO_ID: "0")
                }
            }
        }
        
    }
}
