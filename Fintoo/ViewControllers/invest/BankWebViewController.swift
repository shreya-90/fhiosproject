//
//  BankWebViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 29/03/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import UIKit
import WebKit
import Alamofire
import Mixpanel

class BankWebViewController: BaseViewController,UIWebViewDelegate {
    var responseString = ""
    var cartSIPTotal = 0
    var trnsarr = ""
    var cartObjects = [CartObject]()
    var selectedBank: getBankObj?
    var transactionObject = [gettransactiondetailsObject]()
    var cartTransactionID = [String]()
    var Status = "D"
    var net_banking_success_trnsarr = [String]()
     var userDataArr = [UserDataObj]()
    var id = "0"
     var str = ""
    var mandateid = ""
    var mandate_type = ""
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        let filename = getDocumentsDirectory().appendingPathComponent("output.html")
        do {
            try responseString.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print(error)
        }
        webView.delegate = self
        for cartObj in cartObjects {
            let type = cartObj.cart_purchase_type
            if type == "SIP" {
                if let ammount = cartObj.cart_amount.numberValue {
                    cartSIPTotal = cartSIPTotal + Int(truncating: ammount)
                }
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        gettransactiondetails(trnsarr: trnsarr)
        loadWebView()
    }
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    override func onBackButtonPressed(_ sender: UIButton) {
       // navigationController?.popViewController(animated: true)
       // paymentGatewayResponse()
        Mixpanel.mainInstance().track(event: "Bank WebView Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        
        self.navigationController?.pushViewController(destVC, animated: true)

    }
    func loadWebView()  {
        let documentDirUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let indexFileUrl = documentDirUrl.appendingPathComponent("output.html")
        print(indexFileUrl)
        webView.loadRequest(URLRequest(url: indexFileUrl as URL))
        //webView.loadRequest(URLRequest(url: URL(string: "https://test.netperformers.de/users.php")!))
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("request: \(request.description)")
        print("URL:\(request.httpBody)")
        if request.description == "\(Constants.API.mobile_payment_logout)"{
            //do close window magic here!!
            print("url matches...")
            stopLoading()
            return false
        }
        return true
    }
    
    func stopLoading() {
        webView.removeFromSuperview()
        self.moveToVC()
    }
    
    func moveToVC()  {
        print("Write code where you want to go in app")
        presentWindow.makeToastActivity(message: "Loading..")
        // Note: [you use push or present here]
       paymentGatewayResponse()
    }
    func paymentGatewayResponse(){
        
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        for i in 0..<self.transactionObject.count{
            let bse_reg_order_id = transactionObject[i].bse_reg_order_id
            let url = "\(Constants.BASE_URL)\(Constants.API.paymentGatewayResponse)/\(userid!)/\(bse_reg_order_id)"
            if Connectivity.isConnectedToInternet {
                Alamofire.request("\(url)").responseJSON { response in
                    let data = response.result.value as? [String:Any]
                    print(data)
                    let status = data?["status"] as? String ?? ""
                    let response = data?["response"] as? String ?? ""
                    print(response,"dataresponse")
                     //if let bse_reg_status = data?["status"] as? String{
                    if status != "" && status == "Success" && response == "100|APPROVED ( DIRECT )" || response == "100|APPROVED ( NEFT )"{
                        self.presentWindow.hideToastActivity()
                        self.Status = "Y"
                        self.net_banking_success_trnsarr.append(self.transactionObject[i].transaction_id)
                    }else if status != "" && status == "Success" && ( response == "100|AWAITING FOR RESPONSE FROM BILLDESK ( DIRECT )" || response == "100|AWAITING FOR RESPONSE FROM BILLDESK ( NODAL )" || response == "100|AWAITING FOR FUNDS CONFIRMATION ( NODAL )") {
                        self.presentWindow.hideToastActivity()
                        self.Status = "A"
                        self.net_banking_success_trnsarr.append(self.transactionObject[i].transaction_id)
                    }
                }
            }
        }
        if Status == "Y" || Status == "A"{
            // call updatetransaction
            updatetransaction(txn_status: "\(Status)", trns_arr: trnsarr)
        }
//        else {
//            updatetransaction(txn_status: "D", trns_arr: trnsarr)
//        }
    }
    func updatetransaction(txn_status:String,trns_arr:String){
        // presentWindow.makeToastActivity(message: "Loading..")
        let url = "\(Constants.BASE_URL)\(Constants.API.updatetransaction)"
        print(url)
        let parameters = ["trnsarr": "\(trns_arr)", "txn_status": "\(txn_status)","txn_user_ip":"\(getIPAddress() ?? "")","enc_resp":"3"] as [String : Any]
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    print(enc_response)
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    print(response.result.value ?? "")
                    if enc ==  "\"true\""{
                        print("Success")
                        if txn_status == "Y" || txn_status == "A" {
                            var str = ""
                            for i in 0..<self.cartTransactionID.count{
                                str = str + "trnsarr[\(i)]=\(self.cartTransactionID[i])&"
                            }
                            for i in 0..<self.cartTransactionID.count {
                                self.addTxnLogin(i: i, trnsarr: str)
                            }
                        } else {
                            self.presentWindow.hideToastActivity()
                            self.sendPaymentFailureEmailToUser(username: self.userDataArr[0].fname ?? "", email: self.userDataArr[0].email ?? "")
                            let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                            destVC.success = "Payment Unsuccessful"
                            destVC.desc = "The payment of this transaction has failed. Please retry using different payment method"
                            destVC.titles = "Transaction Request"
                            destVC.id = "1"
                            self.navigationController?.pushViewController(destVC, animated: true)
                        }
                    } else {
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Something went wrong")
                        print("Error Has Occured")
                    }
                    
                    
                    
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func sendPaymentFailureEmailToUser(username:String,email:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        var tableContent = ""
        if Connectivity.isConnectedToInternet{
            if self.cartObjects.count <= 5 {
                for i in 0..<cartObjects.count{
                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
                }
            }
            else{
                let first5 = self.cartObjects.prefix(5)
                for i in 0..<first5.count{
                    print(cartObjects[i].cart_purchase_type)
                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
                }
            }
            let parameters = [
                "ToEmailID":"\(email)",
                "FromEmailID":"",
                "Subject" :"Payment Declined - Fintoo !",
                "template_name": "paymentfailure",
                "username":"\(username)",
                "tableContent":"\(tableContent)"
                
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.templates)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value ?? "")
                    let data = response.result.value ?? ""
                    if let response = data as? [[String: AnyObject]] {
                        let error = response[0]["error"] as? String
                        if error != ""{
                            print("Failed To Sent Email")
                        } else{
                            print("Success")
                            self.sendSmsToUSer(mobile: "\(self.userDataArr[0].mobile ?? "")", msg: "Your recent transaction on Fintoo got declined. Kindly try again by clicking here \(Constants.API.productlist). And if there’s anything we can help you with, call us directly on 9699 800600")
                        }
                    }
                    
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    func sendSmsToUSer(mobile:String,msg:String){
        //let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "mobile":"\(mobile)",
                "msg":"\(msg)"
            ]
            print(parameters)
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_SMS)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    print(response.result.value ?? "")
                    let data = response.result.value
                    if let code = data as? NSArray {
                        //print(code)
                        for code in (code.value(forKey: "code") as? NSArray)! {
                            print(code)
                            let msg_code = String(code as! Int)
                            if msg_code != Constants.ERROR_CODE_1701{
                                self.presentWindow!.makeToast(message: "Failed To Send Message On Mobile")
                            }
                            else{
                                print("send message")
                            }
                        }
                    }
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getIPAddress() -> String? {
        var address : String?
        
        // Get list of all interfaces on the local machine:
        var ifaddr : UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }
        
        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee
            
            // Check for IPv4 or IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if  name == "en0" || name == "pdp_ip0" {
                    
                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                }
            }
        }
        freeifaddrs(ifaddr)
        
        return address
    }
    func gettransactiondetails(trnsarr:String){
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.gettransactiondetails)/\(trnsarr)"
        print(url)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url).responseJSON { response in
                self.presentWindow.hideToastActivity()
                let data = response.result.value
                if data != nil {
                    if let response = data as? [[String: AnyObject]] {
                        for transactionIdData in response {
                            
                            let S_NAME = transactionIdData["S_NAME"] as? String ?? ""
                            let cart_purchase_type = transactionIdData["cart_purchase_type"] as? String ?? ""
                            let transaction_id = transactionIdData["transaction_id"] as? String ?? ""
                            let transaction_date = transactionIdData["transaction_date"] as? String ?? ""
                            let cart_id = transactionIdData["cart_id"] as? String ?? ""
                            let cart_amount = transactionIdData["cart_amount"] as? String ?? ""
                            let cart_tenure = transactionIdData["cart_tenure"] as? String ?? ""
                            let cart_tenure_perpetual = transactionIdData["cart_tenure_perpetual"] as? String ?? ""
                            let bank_name = transactionIdData["bank_name"] as? String ?? ""
                            let bank_acc_no = transactionIdData["bank_acc_no"] as? String ?? ""
                            let bse_reg_order_id = transactionIdData["bse_reg_order_id"] as? String ?? ""
                            let cart_payout_opt = transactionIdData["cart_payout_opt"] as? String ?? "N/A"
                            
                            let transactionObj = gettransactiondetailsObject(S_NAME: S_NAME,cart_purchase_type: cart_purchase_type,transaction_id: transaction_id, transaction_date: transaction_date, cart_id: cart_id, cart_amount: cart_amount, cart_tenure: cart_tenure, cart_tenure_perpetual: cart_tenure_perpetual, bank_name: bank_name, bank_acc_no: bank_acc_no, bse_reg_order_id: bse_reg_order_id, cart_payout_opt: cart_payout_opt)
                            
                            self.transactionObject.append(transactionObj)
                        }
                        self.getUserData()
                    }
                } else{
                    self.presentWindow.hideToastActivity()
                }
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        print(userid)
        
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        
        let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //self.presentWindow.hideToastActivity()
                let data = response.result.value
                if data != nil{
                    // print(data)
                    if self.id != "0"{
                        self.presentWindow.hideToastActivity()
                    }
                    self.id = "1"
                    
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
                            let income_slab = (abc as AnyObject).value(forKey: "income_slab") as? String
                            let income_slab_id = (abc as AnyObject).value(forKey: "IncomeSlabID") as? String
                            print(location)
                            
                            self.userDataArr.append(UserDataObj.getUserData(salutation: salutations!, fname: fname!, mname: mname!, lname: lname!, gender: gender1!, dob: dob!, mobile: mobile!, landline: landline!, email: email!, aadhar: "", pan: pan!, flat_no: flat_no!, building_name: building_name!, road_street: road_street!, address: address!, Country: country!, State:state!, City: city!, pincode:pincode!, occupation: occupation!, location: location!, marital_status: marital_status!, spouse_name: spouse_name!, residential_status: residential_status!, user_tax_status: user_tax_status!, tax_slab: income_slab ?? "", IncomeSlabID: income_slab_id ?? ""))
                            
                            
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
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: " " , with: "")
                    let enc = enc1?.base64Decoded()
                    
                    if enc ==  "\"true\""{
                        print("Success add txn_login")
                        if i == self.cartTransactionID.count - 1{
                            self.presentWindow.hideToastActivity()
                            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentResponseViewController") as! PaymentResponseViewController
                            destVC.titles = "Payment Request"
                            destVC.trnsarr = trnsarr
                            destVC.isNeft = "0"
                            destVC.cartObjects = self.cartObjects
                            destVC.selectedBank = self.selectedBank
                            destVC.cartSIPTotal = self.cartSIPTotal
                            destVC.mandateid = self.mandateid
                            destVC.mandate_type = self.mandate_type
                            destVC.paymentSuccessMessage = self.Status
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
}

