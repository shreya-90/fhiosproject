//
//  PaymentViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 25/03/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
class PaymentViewController: BaseViewController {

    @IBOutlet weak var neftOutlet: UIButton!
    @IBOutlet weak var netBanking: UIButton!
    @IBOutlet weak var neftView: UIView!
    @IBOutlet weak var netBankingView: NSLayoutConstraint!
    @IBOutlet weak var heightConstarint: NSLayoutConstraint!
    @IBOutlet weak var bankNameLabel: UILabel!
  
    
    var cartSIPTotal = 0
    var cartObjects = [CartObject]()
    var selectedBank: getBankObj?
    var cartTransactionID = [String]()
    var isFromConfirmTransaction = -1
    var str = ""
    var netbanking = 1
    var count = 0
    var mandate_type = ""
    var email = ""
    var username = ""
    var mandateid = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        
        netBankingView.constant = 170
        heightConstarint.constant = 0
        neftView.isHidden = true
        bankNameLabel.text = selectedBank?.bank_name ?? ""
        for i in 0..<cartTransactionID.count{
            str = str + "trnsarr[\(i)]=\(cartTransactionID[i])&"
        }
        print(str)
    }
    override func viewWillAppear(_ animated: Bool) {
        //orderEntry()
        for cartObj in cartObjects {
            let type = cartObj.cart_purchase_type
            if type == "SIP" {
                if let ammount = cartObj.cart_amount.numberValue {
                    cartSIPTotal = cartSIPTotal + Int(truncating: ammount)
                }
            }
        }
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        if mandate_type != ""{
            updatemandatetype(userid: userid!, bank_id: self.selectedBank?.bank_id ?? "", mandate_type: mandate_type, scan_mandate_flag: "0")
        }else {
            orderEntry()
        }
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    @IBAction func netBanking(_ sender: UIButton) {
        neftOutlet.backgroundColor = UIColor.white
        neftOutlet.borderWidth = 1
        neftOutlet.borderColor = UIColor.black
        neftOutlet.setTitleColor(UIColor.black, for: .normal)
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
        sender.borderWidth = 0.0
         netBankingView.constant = 170
        heightConstarint.constant = 0
        neftView.isHidden = true
       netbanking = 1
    }
    
    @IBAction func neftBtn(_ sender: UIButton) {
        netBanking.backgroundColor = UIColor.white
        netBanking.borderWidth = 1
        netBanking.borderColor = UIColor.black
        netBanking.setTitleColor(UIColor.black, for: .normal)
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
        sender.borderWidth = 0.0
        heightConstarint.constant = 100
        neftView.isHidden = false
        netBankingView.constant = 300
    }
    @IBAction func proceedBtn(_ sender: Any) {
        if isFromConfirmTransaction == 1 && neftOutlet.backgroundColor == #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1) {
            //  www.erokda.in/adminpanel/transaction/transaction_ws.php/addpaymentmode
            presentWindow.makeToastActivity(message: "Loading..")
            let url = "\(Constants.BASE_URL)\(Constants.API.addpaymentmode)"
            let parameters = ["transaction_data": self.cartTransactionID,"mode":"neft"] as [String : Any]
            print(parameters)
            if Connectivity.isConnectedToInternet {
                Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                    .responseString { response in
                        print(response.result.value ?? "")
                        let data = response.result.value?.replacingOccurrences(of: "\n", with: "") ?? ""
                        
                        if data == "\"true\""{
                            self.presentWindow.hideToastActivity()
                            var str = ""
                            for i in 0..<self.cartTransactionID.count{
                                str = str + "trnsarr[\(i)]=\(self.cartTransactionID[i])&"
                            }
                            for i in 0..<self.cartTransactionID.count{
                                self.addTxnLogin(i: i, trnsarr: str)
                            }
                            print(str,"trnsarrlogin")
                            
//                            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//                            let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentResponseViewController") as! PaymentResponseViewController
//                            destVC.titles = "Payment Request"
//                            destVC.trnsarr = str
//                            destVC.isNeft = "1"
//                            destVC.cartObjects = self.cartObjects
//                            self.navigationController?.pushViewController(destVC, animated: true)
                           
                        } else {
                            self.presentWindow.hideToastActivity()
                            
                        }
                }
            } else {
                self.presentWindow.hideToastActivity()
                self.presentWindow?.makeToast(message: "No Internet Connection")
            }
        } else if isFromConfirmTransaction == 1 && netbanking == 1 {
           // paymentGateway
             presentWindow.makeToastActivity(message: "Loading..")
            let url = "\(Constants.BASE_URL)\(Constants.API.paymentGateway)/\(str)/1"
            if Connectivity.isConnectedToInternet{
                Alamofire.request(url).responseJSON { response in
                    let data = response.result.value as? [String:Any]
                    if let response = data?["response"] as? [String:Any]{
                        if let status = response["Status"] as? String {
                            if status != "101" {
                                if let ResponseString = response["ResponseString"] as? String{
                                    print(ResponseString)
                                    self.presentWindow.hideToastActivity()
                                    var str = ""
                                    for i in 0..<self.cartTransactionID.count{
                                        str = str + "trnsarr[\(i)]=\(self.cartTransactionID[i])&"
                                    }
                                    let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "BankWebViewController") as! BankWebViewController
                                    destVC.trnsarr = str
                                    destVC.cartObjects = self.cartObjects
                                    destVC.responseString = ResponseString
                                    destVC.cartTransactionID = self.cartTransactionID
                                    destVC.mandateid = self.mandateid
                                    destVC.mandate_type = self.mandate_type
                                    self.navigationController?.pushViewController(destVC, animated: true)
                                }
                                
                            } else{
                                 self.presentWindow.hideToastActivity()
                            }
                        } else{
                            self.presentWindow.hideToastActivity()
                        }
                    } else {
                        self.presentWindow.hideToastActivity()
                    }
                }
            } else {
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
            
        } else if isFromConfirmTransaction == 0 {
            let alert = UIAlertController(title: "Alert", message: "Something Went Wrong ", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
                print("Ok Button Clicked")
                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                self.navigationController?.pushViewController(destVC, animated: false)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func orderEntry(){
        
        for cartObj in cartObjects {
            count = count + 1
            let type = cartObj.cart_purchase_type
            if type == "Lumpsum" || type == "Additional Purchase" {
                bseNormalOrderEntry(transaction_id: cartObj.transaction_id)
            }else {
                if selectedBank?.bank_mandate_type == "XSIP"{
                     bseXSIPOrderEntry(transaction_id: cartObj.transaction_id)
                } else {
                   bseISIPOrderEntry(transaction_id: cartObj.transaction_id)
                }
            }
        }
        
    }
    func bseNormalOrderEntry(transaction_id:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.NormalOrderEntry)\(transaction_id)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                if self.count == self.cartObjects.count {
                    self.presentWindow.hideToastActivity()
                }
                let data = response.result.value as? [String:Any]
                 let bse_err_msg = data?["bse_err_msg"] as? String ?? "Something Went Wrong"
                if let bse_reg_status = data?["bse_err_status"] as? String{
                    if bse_reg_status != "FAIL" {
                         print("succes%%%%%")
                        self.isFromConfirmTransaction = 1
                    }else {
                        if self.isFromConfirmTransaction != 0 {
                            self.isFromConfirmTransaction = 0
                            let alert = UIAlertController(title: "Alert", message: "\(bse_err_msg)", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
                                print("Ok Button Clicked")
                                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                                self.navigationController?.pushViewController(destVC, animated: false)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func bseXSIPOrderEntry(transaction_id:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.XSIPOrderEntry)\(transaction_id)"
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(url)").responseJSON { response in
                if self.count == self.cartObjects.count {
                    self.presentWindow.hideToastActivity()
                }
                let data = response.result.value as? [String:Any]
                let bse_err_msg = data?["bse_err_msg"] as? String ?? "Something Went Wrong"
                if let bse_reg_status = data?["bse_err_status"] as? String{
                    if bse_reg_status != "FAIL" {
                        print("succes%%%%%")
                        self.isFromConfirmTransaction = 1
                    } else {
                        if self.isFromConfirmTransaction != 0 {
                            self.isFromConfirmTransaction = 0
                            let alert = UIAlertController(title: "Alert", message: "\(bse_err_msg)", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
                                print("Ok Button Clicked")
                                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                                self.navigationController?.pushViewController(destVC, animated: false)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    func bseISIPOrderEntry(transaction_id:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.ISIPOrderEntry)\(transaction_id)"
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(url)").responseJSON { response in
                if self.count == self.cartObjects.count {
                    self.presentWindow.hideToastActivity()
                }
                let data = response.result.value as? [String:Any]
                 let bse_err_msg = data?["bse_err_msg"] as? String ?? "Something Went Wrong"
                if let bse_reg_status = data?["bse_err_status"] as? String{
                    if bse_reg_status != "FAIL" {
                        print("succes%%%%%")
                        self.isFromConfirmTransaction = 1
                    } else {
                        if self.isFromConfirmTransaction != 0 {
                            self.isFromConfirmTransaction = 0
                            let alert = UIAlertController(title: "Alert", message: "\(bse_err_msg)", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
                                print("Ok Button Clicked")
                                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                                self.navigationController?.pushViewController(destVC, animated: false)
                            }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    func addTxnLogin(i:Int,trnsarr:String){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.addtxnlogin)"
        var masterCartID = [String]()
        for obj in self.cartObjects {
            masterCartID.append(obj.cart_mst_id)
        }
        let str = masterCartID.joined(separator: ",")
        let parameters = ["txn_source":"Mobile_App_Fintoo","main_cart_id":str.covertToBase64(),"uid":"\(covertToBase64(text: userid as! String))","tag":"success_mf_online","txn_rm":"","txn_id":"\(cartObjects[i].transaction_id.covertToBase64())","cart_amount":"\(cartObjects[i].cart_amount.covertToBase64())","enc_resp":"3"]
        print(url,"url:",parameters)
        if Connectivity.isConnectedToInternet {
            //Alamofire.request(<#T##url: URLConvertible##URLConvertible#>, method: <#T##HTTPMethod#>, parameters: <#T##Parameters?#>, encoding: <#T##ParameterEncoding#>, headers: <#T##HTTPHeaders?#>)
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    
                    if enc ==  "\"true\""{
                        print("Success add txn_login")
                        if i == self.cartTransactionID.count - 1{
                            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentResponseViewController") as! PaymentResponseViewController
                            destVC.titles = "Payment Request"
                            destVC.trnsarr = trnsarr
                            destVC.isNeft = "1"
                            destVC.cartObjects = self.cartObjects
                            destVC.selectedBank = self.selectedBank
                            destVC.cartSIPTotal = self.cartSIPTotal
                            destVC.mandateid = self.mandateid
                            destVC.mandate_type = self.mandate_type
                            self.navigationController?.pushViewController(destVC, animated: true)
                        } else{
                            print("dont send email")
                        }
                    } else {
                        self.presentWindow.hideToastActivity()
                        print("Error Has Occured")
                    }
                    
                    
                    
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func updatemandatetype(userid:String,bank_id:String,mandate_type:String,scan_mandate_flag:String){
        presentWindow.makeToastActivity(message: "Loading..")
        let url = "\(Constants.BASE_URL)\(Constants.API.updatemandatetype)"
        let parameters = [
            "id": userid,
            "bankid":bank_id,
            "mandate_type": mandate_type
        ]
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value)
                    let response = response.result.value as? String ?? ""
                    if response == "true"{
                        self.mandateRegister(userid:userid,bank_id: (self.selectedBank?.bank_id)!, cart_SIP_total: self.cartSIPTotal,scan_mandate_flag:scan_mandate_flag)
                    } else {
                        self.presentWindow.hideToastActivity()
                    }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    func mandateRegister(userid:String,bank_id:String,cart_SIP_total:Int,scan_mandate_flag:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.MandateRegister)\(userid)/\(bank_id)/\(cart_SIP_total)/app"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                let data = response.result.value as? [String:Any]
                if let response = data?["response"] as? String {
                    print(response)
                    let status = data?["status"] as? String
                    let response_arr = response.split {$0 == "|"}
                    print(response_arr)
                    var mandate_id = ""
                    if response_arr.indices.contains(2){
                        mandate_id = String(response_arr[2])
                    }
                    if status != "Success"{
                        self.presentWindow.hideToastActivity()
                        let alert = UIAlertController(title: "Alert", message: "\(response)", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                            print("Ok button clicked")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }else if response_arr[0] != "100"{
                        self.presentWindow.hideToastActivity()
                        let alert = UIAlertController(title: "Alert", message: "\(response_arr[1])", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                            print("Ok button clicked")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else {
                            self.orderEntry()
                            self.mandateid = mandate_id
                        //self.sendMandateRegisterEmailToUser(username: self.username, email: self.email,mandate_id:mandate_id)
                    }
                }else {
                    let alert = UIAlertController(title: "Alert", message: "Due to some technical error you can not proceed further, Please connect to our technical support team on 9699 800600.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                        print("Ok button clicked")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    func ScanMandateImageUpload(userid:String,bank_id:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.ScanMandateImageUpload)\(userid)/\(bank_id)"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                print(response.result.value)
                self.presentWindow.hideToastActivity()
                let data = response.result.value as? [String:Any]
                if let bse_err_status = data?["bse_err_status"] as? String{
                    if bse_err_status != "FAIL" {
                       // self.presentWindow.hideToastActivity()
                        self.orderEntry()
                       
                    } else {
                        self.presentWindow.hideToastActivity()
                    }
                    
                }
            }
        }
    }
}
