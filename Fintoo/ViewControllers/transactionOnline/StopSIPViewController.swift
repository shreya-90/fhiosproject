//
//  StopSIPViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 14/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class StopSIPViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
   
    var no_of_units : String!
    var curr_value : String!
    var transactionArrs = [String]()
    var selectAction : String!
    var SchemeName : String!
    var Schemecode : String!
    var folio_no : String!
    var row : Int!
    var bank_acc_no_from_bank_list = [String: [String:String]]()
    var acc_no : String!
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
    @IBOutlet weak var schemeNameTf: UITextField!
    @IBOutlet weak var selectActiontf: UITextField!
    @IBOutlet weak var selectActionTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        addBackbutton()
        schemeNameTf.text = SchemeName!
        selectActiontf.text = selectAction!
        
        selectActionTableview.delegate = self
        selectActionTableview.dataSource = self
        if self.bse_reg_code != "Y"{
            self.clientregistrationBse(userid: userid as! String)
        } else {
            self.presentWindow.hideToastActivity()
        }
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "TRANSACT ONLINE"
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Stop SIP Screen :- Back Button Clicked")
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
         Mixpanel.mainInstance().track(event: "Stop SIP Screen :- Dropdown Button Clicked")
        selectActionTableview.isHidden = !selectActionTableview.isHidden
    }
    @IBAction func submit(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Stop SIP Screen :- Submit Button Clicked")
        getCartId(txn_no: trxnnumber)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "selectaction", for: indexPath)
        cell.textLabel?.text = transactionArrs[indexPath.row] as! String
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == selectActionTableview{
            let cell = tableView.cellForRow(at: indexPath)
            selectActiontf.text = cell?.textLabel?.text
            selectActionTableview.isHidden = true
            //return cell
            if selectActiontf.text  == "Additional Purchase"{
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
            else if selectActiontf.text == "Stop SIP"{
                
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
    }
    func getCartId(txn_no:String){
        let url = "transaction/transaction_ws.php/getCartId"
        
        
        //  txn_id="", user_id, cart_id = response from above web service, bank_id, status="", trxntype="SOU", trxndate=cartsipdate, transaction_folio_no
        let parameters = ["txn_no":"\(txn_no.covertToBase64())","enc_resp":"3"]
        print(parameters,"transaction>>>>>>")
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(url)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                   // print(response.value!)
                    print(response.result.value)
                    let enc_response = response.result.value?.replacingOccurrences(of: "\n", with: "")
                    print(enc_response)
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    // print(enc1)
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    //print(response.result.value ?? "cart detail")
                    let data1 = dict
                     self.presentWindow.hideToastActivity()
                    if let data = data1 as? [AnyObject]{
                        for type in data{
                            if let transaction_cart_id = type.value(forKey: "transaction_cart_id") as? String{
                                let bse_reg_order_id = type.value(forKey: "bse_reg_order_id") as? String
                                let transaction_id = type.value(forKey: "transaction_id") as? String ?? ""
                                print(transaction_cart_id)
                                if bse_reg_order_id == "0" {
                                    self.stopSIP(transaction_cart_id: "\(transaction_cart_id)")
                                }else {
                                    self.bse_stop_SIP(transaction_id: transaction_id,transaction_cart_id:transaction_cart_id)
                                }
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
    func stopSIP(transaction_cart_id:String){
        let url = "cart/cart_ws.php/stopsipswpstp"
        //adminpanel/cart/cart_ws.php/stopsipswpstp
        //  schemecode, amount="", cartptype = 2, cart_id=transaction_cart_idice, bank_id, status="", trxntype="SOU", trxndate=cartsipdate, transaction_folio_no
        let parameters = ["schemecode":"\(Schemecode!.covertToBase64())","amount":"","cartptype" :"2","cart_id":"\(transaction_cart_id.covertToBase64())","enc_resp":"3"]
        print(parameters,"transaction>>>>>>")
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(url)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    //self.presentWindow.hideToastActivity()
                    let data = response.result.value?.replacingOccurrences(of: "\n", with: "").base64Decoded() as? String
                    if data == "\"true\""{
                        //self.bse_stop_SIP(transaction_id: transaction_cart_id)
                        self.presentWindow.hideToastActivity()
                        let name = UserDefaults.standard.value(forKey: "name") as? String
                        let email = UserDefaults.standard.value(forKey: "Email") as? String
                        let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
                        
                        self.sendStopSIPRequestEmailToUser(username: name!, email: email!)
                        self.sendSmsToUSer(mobile: phone!)
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as! PaymentSuccessViewController
                        destVC.success = "Stop SIP Request Placed Successfully"
                        destVC.titles = "Stop SIP Request"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        self.navigationController?.pushViewController(destVC, animated: true)
                        
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                        destVC.success = "Stop SIP Request Placed Unsuccessfully"
                        destVC.titles = "Stop SIP Request"
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
    
    func bse_stop_SIP(transaction_id:String,transaction_cart_id:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.XSIPOrderEntry)\(transaction_id)/CXL"
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(url)").responseJSON { response in
                print(response.result.value as? [String:Any])
                let data = response.result.value as? [String:Any]
                if let bse_reg_status = data?["bse_err_status"] as? String{
                    if bse_reg_status != "FAIL" {
                        print("succes%%%%%")
                        self.stopSIP(transaction_cart_id: transaction_cart_id)
                    } else {
                        print("fail%%%%%")
                        self.presentWindow.hideToastActivity()
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                        destVC.success = "Stop SIP Request Placed Unsuccessfully"
                        destVC.titles = "Stop SIP Request"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                }
            }
        }
        
    }
    func sendStopSIPRequestEmailToUser(username:String,email:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            
           
            let parameters = [
                "ToEmailID":"\(email.covertToBase64())",
                "FromEmailID":"",
                "Subject" : "\(covertToBase64(text: "Stop SIP request - Fintoo "))",
                "template_name": "\(covertToBase64(text: "stoprequest"))",
                "username":"\(username.covertToBase64())",
                "txn_date":"",
                "type":"\(covertToBase64(text: "SIP"))",
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
                            self.sendStopSIPRequestEmailToSupport(username: username, email: email)
                        }
                    }
                    
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    
    //send suuport mail
    func sendStopSIPRequestEmailToSupport(username:String,email:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "ToEmailID":"\(covertToBase64(text: "support@fintoo.in"))",
                "FromEmailID":"",
                "Subject" :"\(covertToBase64(text: "Stop SIP request for \(username) on Fintoo"))",
                "template_name": "\(covertToBase64(text: "stoprequestonline"))",
                "email":"\(email.covertToBase64())",
                "username":"\(username.covertToBase64())",
                "type":"\(covertToBase64(text: "SIP"))",
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
                "msg":"Your request to stop SIP on Fintoo has been received. For any urgent query, call us directly on 9699 800600","enc_resp":"3"
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
