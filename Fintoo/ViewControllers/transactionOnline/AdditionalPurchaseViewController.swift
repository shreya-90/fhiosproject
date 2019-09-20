//
//  AdditionalPurchaseViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 06/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class AdditionalPurchaseViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    @IBAction func selectActionBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Additional Purchase Screen :- DropDown Button Clicked")
        tableview.isHidden = !tableview.isHidden
        
    }
    
    @IBOutlet weak var selectActionTf: UITextField!
    
    @IBOutlet weak var tableview: UITableView!
    
    @IBOutlet weak var schemeName: UITextField!
    
    @IBOutlet weak var amounttf: UITextField!
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
    var swptxnid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackbutton()
        let swptxnid1 = UserDefaults.standard.value(forKey: "swptxnid") as? String ?? ""
        if swptxnid1 != "" {
            swptxnid = swptxnid1
        }
        tableview.delegate = self
        tableview.dataSource =  self
        print(selectAction)
        selectActionTf.text =  selectAction!
        
        schemeName.text = SchemeName
        
        addRightBarButtonItems(items: [cartButton])
       
    }
    override func viewWillAppear(_ animated: Bool) {
        cart_count()
        self.title = "TRANSACT ONLINE"
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
        destVC.selectIndexValue = true
        self.navigationController?.pushViewController(destVC, animated: true)
        Mixpanel.mainInstance().track(event: "Additional Purchase Screen :- Back Button Clicked")
    }
    @IBAction func submit(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Additional Purchase Screen :- Submit Button Clicked")
        amounttf.resignFirstResponder()
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        } else{
           
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        if amounttf.text == ""{
            presentWindow.makeToast(message: "Please Enter Investment Amount")
            Mixpanel.mainInstance().track(event: "Additional Purchase Screen :- Please Enter Investment Amount")
        } else if mininvest != nil && (Int(amounttf.text!)! < Int(truncating: mininvest.numberValue!)) {
            presentWindow.makeToast(message: "Minimum investment amount is \(mininvest!)")
            Mixpanel.mainInstance().track(event: "Additional Purchase Screen :- Minimum investment amount is \(mininvest!)")
        } else{
            addtocart(id: Schemecode, tenure: "", amount: amounttf.text!, type: "3", frequency: "", userid: userid!, sessionid: "\(sessionId!)", perpetual: "", cart_folio_no: folio_no)
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableview.dequeueReusableCell(withIdentifier: "ADP", for: indexPath)
        cell.textLabel?.text = transactionArrs[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        selectActionTf.text = cell?.textLabel?.text
        
        tableView.isHidden = true
        
        if tableView == tableView{
            let cell = tableView.cellForRow(at: indexPath)
            selectActionTf.text = cell?.textLabel?.text
            if selectActionTf.text  == "Additional Purchase"{

            }
            else if selectActionTf.text == "Redeem"{
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTf.text  == "Switch"{
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTf.text  == "Stop STP"{
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTf.text == "Stop SWP"{
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTf.text == "Stop SIP"{
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTf.text == "Start SWP"{
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActionTf.text  == "Start STP"{
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
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
                
            }
         }
    }
    func addtocart(id:String,tenure: String,amount:String,type:String,frequency:String, userid: String, sessionid:String, perpetual:String,cart_folio_no:String){
        let parameters = ["id":"\(id.covertToBase64())","tenure":tenure.covertToBase64(),"amount":amount.covertToBase64(),"type":type.covertToBase64(),"frequency":frequency.covertToBase64(),"userid":userid.covertToBase64(),"sessionid":sessionid.covertToBase64(),"perpetual":perpetual.covertToBase64(),"cart_folio_no":cart_folio_no.covertToBase64(),"enc_resp":"\(3)"] as [String : Any]
        print(parameters)
        presentWindow.makeToastActivity(message: "Adding.")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addToCart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value)
                    print(response.result.value!)
                    let response = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded() ?? ""
                    if response == "\"true\""{
                        print("true response")
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Added to cart successfully!")
                        Mixpanel.mainInstance().track(event: "Additional Purchase Screen :- Added to cart successfully!")
                        self.cart_count()
                        self.amounttf.text = ""
                    } else if response == "false"{
                        self.presentWindow.hideToastActivity()
                        print("false response")
                    } else{
                        self.presentWindow.hideToastActivity()
                        print("")
                    }
            }
            
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func cart_count(){
        var userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        if flag != "0"{
            userid = flag
            
        }
        else{
            // flag = "0"
            userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        }
        // let userid = UserDefaults.standard.value(forKey: Constants.User_Defaults.USER_ID) as? String
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3").responseString { response in
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
                print(response.result.value ?? "cart count")
                let data = dict
                print(data)
                if !data.isEmpty {
                    print("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3")
                    // print(response.value)
                    print(data.count)
                    self.btnCart.badgeString = String(data.count)
                } else {
                    self.btnCart.badgeString = String(data.count)
                }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    override func onCartButtonPressed(_ sender: UIButton) {
        print("cart")
        Mixpanel.mainInstance().track(event: "Additional Purchase Screen :- Cart Button Clicked")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }

}
