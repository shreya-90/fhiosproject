//
//  PaymentReviewViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 12/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import DropDown
import Mixpanel
class PaymentReviewViewController: BaseViewController {
    @IBOutlet weak var hideView: UIView!
    @IBOutlet weak var defaultNomineeTf: UITextField!
    @IBOutlet weak var deafaultNomineeAlertView: UIView!
    @IBOutlet weak var defaultNomineeMainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblToalCartItems: UILabel!
    @IBOutlet weak var tfTotalAmount: UITextField!
    var pg_msg = [String]()
    var transaction_date_sms = ""
    var userDataArr = [UserDataObj]()
    var cartObjects = [CartObject]()
    
    var FolioNoObj = [getFolioNo]()
    var id = "0"
    let tempArr = ["", "Lumpsum", "SIP", "Additional Purchase"]
    let nomineeDropDown = DropDown()
    let folioDropDown = DropDown()
    var nomineeDetailsObjArr = [nomineeDetailsObj]()
    var totalCartValue = 0
    var selectedBank: getBankObj?
    var mandate_type = ""
    //var bdvc: BDViewController!
    var status = "D"
    var pg_trnsId_arr = [String]()
    var tempArrForPatment = [CartObject]()
    var transactionObject = [FetchTransactionIdData]()
    var singlebankIdData = [SingleBankDetailObject]()
    var default_nominee_id = ""
    var default_nominee_fullname = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        self.id = "0"
        self.lblToalCartItems.text = "Subtotal (\(self.cartObjects.count) items) :"
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        let formattedNumber = numberFormatter.string(from: NSNumber(value:self.totalCartValue))
        guard let number = formattedNumber else {return}
        let formatter = NumberFormatter()              // Cache this,
        formatter.locale = Locale(identifier: "en_IN") // Here indian local
        formatter.numberStyle = .decimal
        let string = formatter.string(from: number.numberValue!)
        self.tfTotalAmount.text = "\(string ?? "")"
        self.getCartData()
        var str = ""
        
       // self.getNominee()
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        
        navigationController?.popViewController(animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
       
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.isNavigationBarHidden = false
//        if self.cartObjects.count > 5 {
//            let alert = UIAlertController(title: "Alert", message: "As per payment gateway guidelines, at a time, only 5 transactions will be executed. If there are any more in your cart you will be redirected back and you just have to click continue to execute the remaining.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {alert in
//                Mixpanel.mainInstance().track(event: "Payment Review Screen :- Ok Button Clicked")
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func folioNoButtonClicked(_ sender: UIButton) {
        print(sender.tag)
        
        if FolioNoObj.count > 0 {
            self.folioDropDown.anchorView = sender
            var folioArr = self.FolioNoObj.map { $0.folio_no}
            folioArr.insert("Select Folio", at: 0)
            self.folioDropDown.dataSource = folioArr
            self.folioDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                if index != 0 {
                    let indexPath = IndexPath(row: sender.tag, section: 0)
                    let cell = self.tableView.cellForRow(at: indexPath) as! PaymentReviewTableViewCell
                    //cell.folioTf.text = item
                    cell.folioNumberTf.text = item
                    //folioNumberTf.text = item
                    //update folio api call
                    self.updateFolio(cartObj: self.cartObjects[sender.tag], foli_no: item)
                }
            }
            self.folioDropDown.show()
        }else {
            self.gettransactiondetails(trnsarr: "trnsarr[\(sender.tag)]=\(cartObjects[sender.tag].transaction_id)")
        }
    }
    @IBAction func defaultNomineeDropDown(_ sender: UIButton) {
        if self.nomineeDetailsObjArr.count > 0 {
            self.nomineeDropDown.anchorView = sender
            var nominieeArr = self.nomineeDetailsObjArr.map { $0.fullName}
            nominieeArr.insert("Select Nominee", at: 0)
            self.nomineeDropDown.dataSource = nominieeArr
            self.nomineeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                if index == 0 {
//                    self.cartObjects[sender.tag].nominee = nil
                } else {
                    self.defaultNomineeTf.text = item
                    self.default_nominee_id = self.nomineeDetailsObjArr[index-1].nominee_id ?? ""
                }
            }
            self.nomineeDropDown.show()
        }
    }
    @IBAction func defaultNomineeProceedBtnClicked(_ sender: Any) {
        if defaultNomineeTf.text != "Select Nominee" {
            var userid = UserDefaults.standard.value(forKey: "userid")
            if flag != "0"{
                userid = flag
            } else{
                userid = UserDefaults.standard.value(forKey: "userid")
            }
            presentWindow.makeToastActivity(message: "Loading...")
            let url = "\(Constants.BASE_URL)\(Constants.API.SetGetDefaultNominee)\(userid!)/\(default_nominee_id)"
            print(url)
            if Connectivity.isConnectedToInternet {
                Alamofire.request(url).responseJSON { response in
                    let response = response.result.value as? String
                    if response == "true" {
                         //self.presentWindow.hideToastActivity()
                         self.defaultNomineeMainView.isHidden = true
                        self.getNominee()
                    }else {
                       self.presentWindow?.makeToast(message: "Something Went wrong")
                    }
                }
            } else {
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        } else {
            presentWindow?.makeToast(message: "Please select nominee")
        }
    }
    
}

//#MARK: BillDeskDelegates
//extension PaymentReviewViewController: LibraryPaymentStatusProtocol {
//
//    func paymentStatus(_ message: String!) {
//        navigationController?.popToViewController(self, animated: true)
//        print("payment s`tatus response [\(message)]")
//        pg_msg = message.components(separatedBy: "<")
//
//        var responseComponents = message.components(separatedBy: "|")
//        if responseComponents.count >= 25 {
//            let statusCode = responseComponents[14]
//            print(statusCode)
//            let trns_id = responseComponents[1]
//            let trns_id_str = trns_id.replacingOccurrences(of: "-", with: ",",options: NSString.CompareOptions.literal, range:nil)
//            pg_trnsId_arr = trns_id_str.components(separatedBy: ",")
//            print(trns_id_str)
//            switch statusCode {
//            case "0300":
//                hideView.isHidden = false
//                status = "Y"
//                var str = ""
//                for i in 0..<pg_trnsId_arr.count{
//                    str = str + "trnsarr[\(i)]=\(pg_trnsId_arr[i])&"
//                }
//                print(str)
//                id = "0"
//                updatetransaction(txn_status: "Y", trns_arr: str)
//
//            default:
//                hideView.isHidden = false
//                status = "Y"
//                var str = ""
//                for i in 0..<pg_trnsId_arr.count{
//                    str = str + "trnsarr[\(i)]=\(pg_trnsId_arr[i])&"
//                }
//                print(str)
//                id = "0"
//                updatetransaction(txn_status: "Y", trns_arr: str)
////            default:
////
////                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
////                let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
////                destVC.success = "Payment Unsuccessful"
////                destVC.desc = "The payment of this transaction has failed. Please retry using different payment method"
////                destVC.titles = "Transaction Request"
////                destVC.id = "1"
////                self.navigationController?.pushViewController(destVC, animated: true)
//            }
//        } else {
//            presentWindow?.makeToast(message: "Something went wrong")
//        }
//    }
//
//
//
//    func onError(_ exception: NSException?) {
//        if let anException = exception {
//            print("Exception got in Merchant App \(anException)")
//        }
//    }
//
//    func tryAgain() {
//        print("Try again method in Merchant App")
//    }
//
//    func cancelTransaction() {
//        print("Cancel Transaction method in Merchant App")
//    }
//}

//#MARK: @IBActions
extension PaymentReviewViewController {
    
    @IBAction func btnProccedWithPaymentTapped(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Payment Review Screen :- Proceed With payment Button Clicked")
//        for obj in self.cartObjects {
//            if obj.nominee == nil {
//                presentWindow?.makeToast(message: "Please select nominee")
//                return
//            }
//        }
//        if self.cartObjects.count > 5 {
//            let alert = UIAlertController(title: "Alert", message: "As per payment gateway guidelines, at a time, only 5 transactions will be executed. If there are any more in your cart you will be redirected back and you just have to click continue to execute the remaining.", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
//                self.initiatePayment()
//                Mixpanel.mainInstance().track(event: "Payment Review Screen :- Ok Button Clicked")
//            }))
//            self.present(alert, animated: true, completion: nil)
//        } else{
//             self.initiatePayment()
//        }
        let cartTransactionID = cartObjects.map { $0.transaction_id }
       // print(cartTransactionID)
        guard let bankObj = self.selectedBank else { return }
        let storyboard = UIStoryboard(name: "ProductList", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        controller.selectedBank = bankObj
        controller.mandate_type = mandate_type
        controller.cartObjects = self.cartObjects
        controller.cartTransactionID = cartTransactionID
        controller.email = userDataArr[0].email ?? ""
        controller.username = userDataArr[0].fname ?? ""
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    
    @IBAction func btnCanclePaymentTapped(_ sender: Any) {
        //http://www.erokda.in/adminpanel/transaction/transaction_ws.php/canceltxn
        //{"txn_id":"1585,1586", "cart_mst_id":"1333"}
        let alert = UIAlertController(title: "", message: "Are you sure you want to cancel this transaction?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
           // self.cancelTransactions()
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            
            self.navigationController?.pushViewController(destVC, animated: true)
            Mixpanel.mainInstance().track(event: "Payment Review Screen :- Cancel Payment Button Clicked")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func btnNomineeTapped(sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Payment Review Screen :- Select Nominee Dropdown Clicked")
        if self.nomineeDetailsObjArr.count > 0 {
            self.nomineeDropDown.anchorView = sender
            var nominieeArr = self.nomineeDetailsObjArr.map { $0.fullName}
            nominieeArr.insert("Select Nominee", at: 0)
            self.nomineeDropDown.dataSource = nominieeArr
            self.nomineeDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                let indexPath = IndexPath(row: sender.tag, section: 0)
                let cell = self.tableView.cellForRow(at: indexPath) as! PaymentReviewTableViewCell
                
                if index == 0 {
                    self.cartObjects[sender.tag].nominee = nil
                } else {
                    let alert = UIAlertController(title: "", message: "Are you sure you want to save the nominee?", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
                        self.cartObjects[sender.tag].nominee = self.nomineeDetailsObjArr[index - 1]
                        self.tableView.reloadRows(at: [indexPath], with: .automatic)
                        self.updateNominee(cartObj: self.cartObjects[sender.tag])
                        cell.tfNominee.text = item
                        Mixpanel.mainInstance().track(event: "Payment Review Screen :- Are you sure you want to save the nominee? Alert Ok Button Clicked")
                    }))
                    alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { alert in
                        guard let nominee = self.cartObjects[sender.tag].nominee?.fullName else { return }
                        //print(nominee)
                         cell.tfNominee.text = "Select Nominee"
                        Mixpanel.mainInstance().track(event: "Payment Review Screen :- Are you sure you want to save the nominee? Alert Cancel Button Clicked")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    
                }
               
            }
            self.nomineeDropDown.show()
            
        }
    }
}

//#MARK: UITableViewDelegate
extension PaymentReviewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "pamentreview", for: indexPath) as! PaymentReviewTableViewCell
        
        let cartObj = self.cartObjects[indexPath.row]
        cell.lblName.text = cartObj.S_NAME
        cell.lblType.text = cartObj.cart_purchase_type
        cell.lblTenure.text = cartObj.cart_tenure
        cell.folioButtonOutlet.tag = indexPath.row
        if cartObj.cart_folio_no != ""{
            cell.folioNumberTf.text = cartObj.cart_folio_no
        }
        print(cartObj.cart_purchase_type)
        if cartObj.cart_purchase_type == "SIP"  {
            cell.sipStartDate.text = "(SIP will start from -\(cartObj.cart_sip_start_date1))"
        } else {
             cell.sipStartDate.text = ""
        }
        let formatter = NumberFormatter()              // Cache this,
        formatter.locale = Locale(identifier: "en_IN") // Here indian local
        formatter.numberStyle = .decimal
        let string = formatter.string(from: cartObj.cart_amount.numberValue!)
        cell.lblAmount.text = string
        
        cell.selectionStyle = .none
        cell.tfNominee.isUserInteractionEnabled = false
        
        if default_nominee_fullname == "" {
            cell.tfNominee.text = "Select Nominee"
        } else {
            cell.tfNominee.text = default_nominee_fullname
        }
        print(default_nominee_fullname,"nomineee")
        cell.btnDropDown.tag = indexPath.row
        cell.btnDropDown.addTarget(self, action: #selector(btnNomineeTapped(sender:)), for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartObjects.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}

//#MARK: API Calls
extension PaymentReviewViewController {
    func getCartData() {
        
        self.cartObjects.removeAll()
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.GetCartData)\(covertToBase64(text: userid as! String))/3"
        if Connectivity.isConnectedToInternet {
            self.totalCartValue = 0
            Alamofire.request(url).responseString { response in
                let enc_response = response.result.value
                print(enc_response)
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                // print(enc1)
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                
                
                //let data = response.result.value
                if data != nil {
                    
                    if let response = data as? [[String: AnyObject]] {
                        for cartItem in response {
                            let MAXINVT = cartItem["MAXINVT"] as? String ?? ""
                            let MININVT = cartItem["MININVT"] as? String ?? ""
                            let SCHEMECODE = cartItem["SCHEMECODE"] as? String ?? ""
                            let SIPMININVT = cartItem["SIPMININVT"] as? String ?? ""
                            let S_NAME = cartItem["S_NAME"] as? String ?? ""
                            let cart_added = cartItem["cart_added"] as? String ?? ""
                            let cart_amount = cartItem["cart_amount"] as? String ?? ""
                            self.totalCartValue = self.totalCartValue + Int(cart_amount)!
                            let cart_folio_no = cartItem["cart_folio_no"] as? String ?? ""
                            let cart_frequency = cartItem["cart_frequency"] as? String ?? ""
                            let cart_id = cartItem["cart_id"] as? String ?? ""
                            let cart_mst_id = cartItem["cart_mst_id"] as? String ?? ""
                            let cart_mst_session_id = cartItem["cart_mst_session_id"] as? String ?? ""
                            
                            let mode = cartItem["cart_purchase_type"] as? String ?? ""
                            let cart_purchase_type = self.tempArr[Int(mode) ?? 0]
                            
                            let cart_scheme_code = cartItem["cart_scheme_code"] as? String ?? ""
                            
                            let originalDate = cartItem["cart_sip_start_date"] as? String ?? ""
                            let CLASSCODE = cartItem["CLASSCODE"] as? String ?? ""
                            var cart_sip_start_date = ""
                            if mode == "1" || mode == "3" {
                                cart_sip_start_date = "NA"
                            } else {
                                if originalDate == "0000-00-00" {
                                    cart_sip_start_date = "NA"
                                } else {
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy-mm-dd"
                                    let date = dateFormatter.date(from: originalDate)
                                    let calendar = Calendar.current
                                    let day = calendar.component(.day, from: date!)
                                    
                                    cart_sip_start_date = "\(day)"
                                }
                            }
                            
                            let cart_tenure = cartItem["cart_tenure"] as? String ?? ""
                            let cart_tenure_perpetual = cartItem["cart_tenure_perpetual"] as? String ?? ""
                            let multiples = cartItem["multiples"] as? String ?? ""
                            let transaction_bank_id = cartItem["transaction_bank_id"] as? String ?? ""
                            let transaction_id = cartItem["transaction_id"] as? String ?? ""
                            let AMC_CODE = cartItem["AMC_CODE"] as? String ?? ""
                            let cartObj = CartObject(MAXINVT: MAXINVT, MININVT: MININVT, SCHEMECODE: SCHEMECODE, SIPMININVT: SIPMININVT, S_NAME: S_NAME, cart_added: cart_added, cart_amount: cart_amount, cart_folio_no: cart_folio_no, cart_frequency: cart_frequency, cart_id: cart_id, cart_mst_id: cart_mst_id, cart_mst_session_id: cart_mst_session_id, cart_purchase_type: cart_purchase_type, cart_scheme_code: cart_scheme_code, cart_sip_start_date: cart_sip_start_date, cart_tenure: cart_tenure, cart_tenure_perpetual: cart_tenure_perpetual, multiples: multiples, transaction_bank_id: transaction_bank_id, transaction_id: transaction_id,cart_sip_start_date1: originalDate, mode: mode, is_save: false, AMC_CODE: AMC_CODE, CLASSCODE:CLASSCODE, nominee: nil)
                            self.cartObjects.append(cartObj)
                            
                            //self.presentWindow.hideToastActivity()
                        }
                        self.getNominee()
                    }
                } else {
                    self.presentWindow.hideToastActivity()
                    
                    
                }
                self.tableView.reloadData()
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func gettransactiondetails(trnsarr:String){
        
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
                            let rav_amc_value = transactionIdData["rav_amc_value"] as? String ?? ""
                            let transaction_id = transactionIdData["transaction_id"] as? String ?? ""
                            let transaction_date = transactionIdData["transaction_date"] as? String ?? ""
                            let cart_id = transactionIdData["cart_id"] as? String ?? ""
                            let cart_amount = transactionIdData["cart_amount"] as? String ?? ""
                            
                            self.totalCartValue = self.totalCartValue + Int(cart_amount)!
                            let cart_tenure = transactionIdData["cart_tenure"] as? String ?? ""
                            let cart_tenure_perpetual = transactionIdData["cart_tenure_perpetual"] as? String ?? ""
                            let bank_name = transactionIdData["bank_name"] as? String ?? ""
                            let bank_acc_no = transactionIdData["bank_acc_no"] as? String ?? ""
                            let cart_payout_opt = transactionIdData["cart_payout_opt"] as? String ?? "N/A"
                            self.transaction_date_sms = transaction_date
                            let bse_reg_order_id = transactionIdData["bse_reg_order_id"] as? String ?? ""
                            self.getFoliNo(rav_amc_value:rav_amc_value)
                            let transactionObj = gettransactiondetailsObject(S_NAME: S_NAME,cart_purchase_type: cart_purchase_type,transaction_id: transaction_id, transaction_date: transaction_date, cart_id: cart_id, cart_amount: cart_amount, cart_tenure: cart_tenure, cart_tenure_perpetual: cart_tenure_perpetual, bank_name: bank_name, bank_acc_no: bank_acc_no, bse_reg_order_id: bse_reg_order_id, cart_payout_opt: cart_payout_opt)
                            
                            //self.transactionObject.append(transactionObj)
                        }
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
    func getFoliNo(rav_amc_value:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.getFoliandAMCbyPAN)"
        
        let pan = UserDefaults.standard.value(forKey: "pan") as? String ?? ""
        let parameters = ["pan": "\(pan)"] as [String : Any]
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    let response = response.result.value as? [[String:Any]] ?? [[:]]
                    if !response.isEmpty{
                        for responseDetail in response{
                            let folio_no = responseDetail["folio_no"] as? String ?? ""
                            let AMC_CODE = responseDetail["AMC_CODE"] as? String ?? ""
                            if rav_amc_value == AMC_CODE {
                                self.FolioNoObj.append(getFolioNo(folio_no: folio_no, folio_AMC_CODE: AMC_CODE))
                            }
                        }
                    }
            }
        }
    }
    func updateFolio(cartObj:CartObject,foli_no:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.updateTransactionandCartFolio)"
        let parameters = ["trans_id":"\(cartObj.transaction_id)","cart_id":"\(cartObj.cart_id)","folio_no":"\(foli_no)"] as [String : Any]
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
            }
        }
    }
    func cancelTransactions(){
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.canceltxn)"
        
        let cartTransactionID = cartObjects.map { $0.transaction_id }
        let cartMasterID = cartObjects.map { $0.cart_mst_id }
        let srtOfID = cartTransactionID.joined(separator: ",")

        let strOfcartMasterID = cartMasterID.joined(separator: ",")
        print(srtOfID)
        print(strOfcartMasterID)
        let parameters = ["txn_id": srtOfID.covertToBase64(), "cart_mst_id": strOfcartMasterID.covertToBase64(),"enc_resp":"3"] as [String : Any]
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    
                    self.presentWindow.hideToastActivity()
                    //let data = response.result.value as? Bool
                    if enc == "true"{
                        let storyboard = UIStoryboard(name: "ProductList", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                        print("Cart Cancel")
                    }
                    else{
                        print("Error Occured")
                    }
                    
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func updateNominee(cartObj: CartObject) {
        
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.addtransnominee)"
        guard let nominee = cartObj.nominee?.nominee_id else { return }
        let parameters = ["txn_id": cartObj.transaction_id.covertToBase64(), "nominee_id": nominee.covertToBase64(),"enc_resp":"3"] as [String : Any]
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    //let data = response.result.value as? String
                    if enc ==  "\"true\""{
                        self.presentWindow.makeToast(message: "Nominee Saved Successfully!")
                        Mixpanel.mainInstance().track(event: "Payment Review Screen :- Nominee Saved Successfully!")
                    } else {
                        print("Error Has Occured")
                    }
                    
                    self.presentWindow.hideToastActivity()
                    
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
//    func initiatePayment() {
//        
//        if self.cartObjects.count <= 5 {
//            print(cartObjects.map{Int($0.cart_amount)!}.reduce(0, +))
//            let amount_total  = cartObjects.map{Int($0.cart_amount)!}.reduce(0,+)
//            guard let selectedBank = selectedBank else {return}
//            _ = selectedBank.bank_id ?? ""
//            let cartTransactionID = cartObjects.map { $0.transaction_id }
//            var bankIFSC = selectedBank.bank_ifsc_code!
//            
//            for _ in 1..<self.cartObjects.count {
//                bankIFSC = bankIFSC + "-" + selectedBank.bank_ifsc_code!
//            }
//            let srtOfID = cartTransactionID.joined(separator: "-")
//            
//            print(totalCartValue)
//            let userEmail = UserDefaults.standard.string(forKey: "Email") ?? ""
//            let mobile = UserDefaults.standard.string(forKey: "Mobile") ?? ""
//            
//            SHKActivityIndicator.current().displayActivity("Fetching Data")
//            _ = "amt=\(totalCartValue)&email=\(userEmail)"
//            let str1 = "\(get_msg_token_string)"
//            print("url dfgf str \(str1) ")
//            
//            var str = ""
//            
//            for i in 0..<cartTransactionID.count {
//                str = str + "trnsarr[\(i)]=\(cartTransactionID[i])&"
//            }
//            presentWindow.makeToastActivity(message: "Loading...")
//            //http://www.erokda.in/adminpanel/transaction/transaction_ws.php/gettransactiondetails/trnsarr[0]=1401&trnsarr[1]=1402&trnsarr[2]=1403
//            let url = "\(Constants.BASE_URL)\(Constants.API.gettransactiondetails)/\(str)/3"
//            print(url)
//            if Connectivity.isConnectedToInternet {
//                Alamofire.request(url).responseString { response in
//                    let enc_response = response.result.value
//                    var dict = [Dictionary<String,Any>]()
//                    let enc1 = enc_response?.replacingOccurrences(of: " " , with: "")
//                    if let enc = enc1?.base64Decoded() {
//                        dict = self.convertToDictionary(text: enc)
//                    } else{
//                        self.presentWindow.hideToastActivity()
//                    }
//                    let data = dict
//                    self.presentWindow.hideToastActivity()
//                    let response = self.jsonToNSData(json: data)
//                    self.presentWindow.hideToastActivity()
//                    let transactiondetails = try? JSONDecoder().decode(Transactiondetails.self, from: response! as Data)
//                    if transactiondetails!.indices.contains(0) {
//                        let user_investor_id = transactiondetails![0]["user_investor_id"]
//                        //let bd_amc_value = transactiondetails![0]["bd_amc_value"]
//                        let residential_status = transactiondetails![0]["residential_status"]
//                        _ = transactiondetails![0]["CAMS_CODE"]!.dropFirst()
//                        var transaction_date = transactiondetails![0]["transaction_date"]!.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
//                        transaction_date = transaction_date.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
//                        transaction_date = transaction_date.replacingOccurrences(of: ":", with: "", options: NSString.CompareOptions.literal, range:nil)
//                        self.transaction_date_sms = transactiondetails![0]["transaction_date"] ?? ""
//                        var transactionAmount = ""
//                        var CAMS_CODE_5 = ""
//                        var bd_amc_value = ""
//                        for obj in transactiondetails! {
//                            transactionAmount = transactionAmount + "-" + obj["cart_amount"]!
//                            CAMS_CODE_5 = CAMS_CODE_5 + "-" + String(obj["CAMS_CODE"]!.dropFirst())
//                            bd_amc_value = bd_amc_value + "-" + obj["bd_amc_value"]!
//                        }
//                        print(CAMS_CODE_5)
//                        print(residential_status,"residential")
//                        var respoStr = ""
//                        if residential_status == "1" {
//                            respoStr = "FINANCIALH|\(srtOfID)|NA|\(amount_total)|\(selectedBank.banks_bd_code!)|NA|NA|INR|DIRECT|R|financialh|NA|NA|F|NA|\(user_investor_id ?? "")|ARN-21209|\(bd_amc_value.dropFirst())|NONLIQUID|RESIDENT\(CAMS_CODE_5)-NA-L-NA-NA|\(transaction_date)\(transactionAmount)|\(Constants.API.pg_dump_php)"
//                        } else if residential_status == "2" {
//                            respoStr = "FINANCIALH|\(srtOfID)|NA|\(amount_total)|\(selectedBank.banks_bd_code!)|NA|NA|INR|DIRECT|R|financialh|NA|NA|F|NA|\(user_investor_id ?? "")|ARN-21209|\(bd_amc_value.dropFirst())|NONLIQUID|NRINRO\(CAMS_CODE_5)-NA-L-NA-NA|\(transaction_date)\(transactionAmount)|\(Constants.API.pg_dump_php)"
//                        } else if residential_status == "3" {
//                            respoStr = "FINANCIALH|\(srtOfID)|NA|\(amount_total)|\(selectedBank.banks_bd_code!)|NA|NA|INR|DIRECT|R|financialh|NA|NA|F|NA|\(user_investor_id ?? "")|ARN-21209|\(bd_amc_value.dropFirst())|NONLIQUID|NRINRE\(CAMS_CODE_5)-NA-L-NA-NA|\(transaction_date)\(transactionAmount)|\(Constants.API.pg_dump_php)"
//                        }else {
//                            respoStr = "FINANCIALH|\(srtOfID)|NA|\(amount_total)|\(selectedBank.banks_bd_code!)|NA|NA|INR|DIRECT|R|financialh|NA|NA|F|NA|\(user_investor_id ?? "")|ARN-21209|\(bd_amc_value.dropFirst())|NONLIQUID|NA-NA-L-NA-NA|\(transaction_date)\(transactionAmount)|\(Constants.API.pg_dump_php)"
//                        }
//                        
//                        let key = "dAig7XVShQcu"
//                        let hmac_sha256 = respoStr.hmac(algorithm: .sha256, key: key)
//                        print(hmac_sha256)
//                        let checksum = hmac_sha256.uppercased()
//                        let msg = respoStr + "|" + checksum;
//                        print(msg)
//                        print(respoStr)
//                        self.bdvc = BDViewController(message: msg, andToken:"NA", andEmail: userEmail, andMobile: mobile, andTxtPayCategory:"NB-F")
//                        
//                        self.bdvc?.delegate = self
//                        SHKActivityIndicator.current().displayCompleted("")
//                        self.bdvc?.hidesBottomBarWhenPushed = true
//                        self.navigationController?.pushViewController(self.bdvc!, animated: true)
//                        
//                        
//                    }
//                }
//            } else {
//                presentWindow.hideToastActivity()
//                presentWindow?.makeToast(message: "No Internet Connection")
//            }
//            
//        } else {
//            let first5 = cartObjects.prefix(5)
//            print(first5.map{Int($0.cart_amount)!}.reduce(0, +))
//            let amount_total  = first5.map{Int($0.cart_amount)!}.reduce(0,+)
//            guard let selectedBank = selectedBank else {return}
//            _ = selectedBank.bank_id ?? ""
//            let cartTransactionID = first5.map { $0.transaction_id }
//            var bankIFSC = selectedBank.bank_ifsc_code!
//            
//            for _ in 1..<first5.count {
//                bankIFSC = bankIFSC + "-" + selectedBank.bank_ifsc_code!
//            }
//            let srtOfID = cartTransactionID.joined(separator: "-")
//            
//            let userEmail = UserDefaults.standard.string(forKey: "Email") ?? ""
//            let mobile = UserDefaults.standard.string(forKey: "Mobile") ?? ""
//            
//            SHKActivityIndicator.current().displayActivity("Fetching Data")
//            _ = "amt=\(totalCartValue)&email=\(userEmail)"
//            let str1 = "\(get_msg_token_string)"
//            print("url dfgf str \(str1) ")
//            
//            var str = ""
//            
//            for i in 0..<cartTransactionID.count {
//                str = str + "trnsarr[\(i)]=\(cartTransactionID[i])&"
//            }
//            presentWindow.makeToastActivity(message: "Loading...")
//            //http://www.erokda.in/adminpanel/transaction/transaction_ws.php/gettransactiondetails/trnsarr[0]=1401&trnsarr[1]=1402&trnsarr[2]=1403
//            let url = "\(Constants.BASE_URL)\(Constants.API.gettransactiondetails)/\(str)/3"
//            if Connectivity.isConnectedToInternet {
//                Alamofire.request(url).responseString { response in
//                    let enc_response = response.result.value
//                    var dict = [Dictionary<String,Any>]()
//                    let enc1 = enc_response?.replacingOccurrences(of: " " , with: "")
//                    if let enc = enc1?.base64Decoded() {
//                        dict = self.convertToDictionary(text: enc)
//                    } else{
//                        self.presentWindow.hideToastActivity()
//                    }
//                    let data = dict
//                    self.presentWindow.hideToastActivity()
//                    let response = self.jsonToNSData(json: data)
//                    self.presentWindow.hideToastActivity()
//                    let transactiondetails = try? JSONDecoder().decode(Transactiondetails.self, from: response as! Data)
//                    if transactiondetails!.indices.contains(0) {
//                        let user_investor_id = transactiondetails![0]["user_investor_id"]
//                       // let bd_amc_value = transactiondetails![0]["bd_amc_value"]
//                        let residential_status = transactiondetails![0]["residential_status"]
//                        _ = transactiondetails![0]["CAMS_CODE"]!.dropFirst()
//                        var transaction_date = transactiondetails![0]["transaction_date"]!.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
//                        transaction_date = transaction_date.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range:nil)
//                        transaction_date = transaction_date.replacingOccurrences(of: ":", with: "", options: NSString.CompareOptions.literal, range:nil)
//                        print(transaction_date)
//                        self.transaction_date_sms = transactiondetails![0]["transaction_date"] ?? ""
//                        var transactionAmount = ""
//                        var CAMS_CODE_5 = ""
//                        var bd_amc_value = ""
//                        for obj in transactiondetails! {
//                            transactionAmount = transactionAmount + "-" + obj["cart_amount"]!
//                            CAMS_CODE_5 = CAMS_CODE_5 + "-" + String(obj["CAMS_CODE"]!.dropFirst())
//                            bd_amc_value = bd_amc_value + "-" + obj["bd_amc_value"]!
//                        }
//                        print(CAMS_CODE_5)
//                        var respoStr = ""
//                        if residential_status == "1" {
//                            respoStr = "FINANCIALH|\(srtOfID)|NA|\(amount_total)|\(selectedBank.banks_bd_code!)|NA|NA|INR|DIRECT|R|financialh|NA|NA|F|NA|\(user_investor_id ?? "")|ARN-21209|\(bd_amc_value.dropFirst())|NONLIQUID|RESIDENT\(CAMS_CODE_5)-NA-L-NA-NA|\(transaction_date)\(transactionAmount)|\(Constants.API.pg_dump_php)"
//                        } else if residential_status == "2" {
//                            respoStr = "FINANCIALH|\(srtOfID)|NA|\(amount_total)|\(selectedBank.banks_bd_code!)|NA|NA|INR|DIRECT|R|financialh|NA|NA|F|NA|\(user_investor_id ?? "")|ARN-21209|\(bd_amc_value.dropFirst())|NONLIQUID|NRINRO\(CAMS_CODE_5)-NA-L-NA-NA|\(transaction_date)\(transactionAmount)|\(Constants.API.pg_dump_php)"
//                        } else if residential_status == "3" {
//                            respoStr = "FINANCIALH|\(srtOfID)|NA|\(amount_total)|\(selectedBank.banks_bd_code!)|NA|NA|INR|DIRECT|R|financialh|NA|NA|F|NA|\(user_investor_id ?? "")|ARN-21209|\(bd_amc_value.dropFirst())|NONLIQUID|NRINRE\(CAMS_CODE_5)-NA-L-NA-NA|\(transaction_date)\(transactionAmount)|\(Constants.API.pg_dump_php)"
//                        }
//                        
//                        let key = "dAig7XVShQcu"
//                        let hmac_sha256 = respoStr.hmac(algorithm: .sha256, key: key)
//                        let checksum = hmac_sha256.uppercased()
//                        let msg = respoStr + "|" + checksum
//                        print(msg)
//                        self.bdvc = BDViewController(message: msg, andToken:"NA", andEmail: userEmail, andMobile: mobile, andTxtPayCategory:"NB-F")
//                        
//                        self.bdvc?.delegate = self
//                        SHKActivityIndicator.current().displayCompleted("")
//                        self.hideView.isHidden = false
//                        self.bdvc?.hidesBottomBarWhenPushed = true
//                        self.navigationController?.pushViewController(self.bdvc!, animated: true)
//                        
//                    }
//                }
//            } else {
//                presentWindow.hideToastActivity()
//                presentWindow?.makeToast(message: "No Internet Connection")
//            }
//        }
//    }
    
    func getNominee() {
        
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.getNomineeDetails)\(covertToBase64(text: userid as! String))/3"
        print(url)
        if Connectivity.isConnectedToInternet {
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
                
                self.nomineeDetailsObjArr.removeAll()
                
                if let response = data as? [[String: AnyObject]]{
                    print(response)
                    if !response.isEmpty{
                    for nominee in response {
                        
                        let nomObj = nomineeDetailsObj()
                        nomObj.nominee_dob = nominee["nominee_dob"] as? String ?? ""
                        nomObj.nominee_gender = nominee["nominee_gender"] as? String ?? ""
                        nomObj.nominee_email = nominee["nominee_email"] as? String ?? ""
                        nomObj.nominee_first_name = nominee["nominee_first_name"] as? String ?? ""
                        nomObj.txn_exst = nominee["txn_exst"] as? String ?? ""
                        nomObj.nominee_mobile = nominee["nominee_mobile"] as? String ?? ""
                        nomObj.nominee_relation = nominee["nominee_relation"] as? String ?? ""
                        nomObj.nominee_middle_name = nominee["nominee_middle_name"] as? String ?? ""
                        nomObj.nominee_guardian_pan = nominee["nominee_guardian_pan"] as? String ?? ""
                        nomObj.nominee_id = nominee["nominee_id"] as? String ?? ""
                        nomObj.nominee_last_name = nominee["nominee_last_name"] as? String ?? ""
                        nomObj.nominee_member_id = nominee["nominee_member_id"] as? String ?? ""
                        nomObj.default_nominee = nominee["default_nominee"] as? String ?? ""
                        nomObj.fullName = nomObj.nominee_first_name! + " " + nomObj.nominee_middle_name! + " "  + nomObj.nominee_last_name!
                        self.nomineeDetailsObjArr.append(nomObj)
                        if nomObj.default_nominee == "Y"{
                            self.default_nominee_fullname = nomObj.fullName
                            break
                        }
                    }
//                        let nominee =  self.nomineeDetailsObjArr.contains{ $0.default_nominee == "Y" }
//                        if !nominee {
//                            self.defaultNomineeMainView.isHidden = false
//                        }else {
//                            self.defaultNomineeMainView.isHidden = true
//                        }
                       
                    let cartIDArr = self.cartObjects.map { $0.transaction_id}
                        //self.getNomineedDetailForCardID(cartArr: cartIDArr, is_empty: false)
                    self.presentWindow.hideToastActivity()
                    
                        
                    self.tableView.reloadData()
                    } else {
                        self.presentWindow.hideToastActivity()
                        print("nomine is empty")
                        let cartIDArr = self.cartObjects.map { $0.transaction_id}
                        //self.getNomineedDetailForCardID(cartArr: cartIDArr, is_empty: true)
                       
                    }
                    
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getNomineedDetailForCardID(cartArr: [String],is_empty : Bool) {
        
        presentWindow.makeToastActivity(message: "Loading...")
        
        var str = ""
        
        for i in 0..<cartArr.count {
            str = str + "trnsarr[\(i)]=\(cartArr[i])&"
        }
        
        let url = "\(Constants.BASE_URL)\(Constants.API.get_txns_nominee)/\(str)/3"
        if Connectivity.isConnectedToInternet {
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
                let response = self.jsonToNSData(json: data)
                
                let transactionNomineed = try! JSONDecoder().decode(TransactionNomineed.self, from: response! as Data)
                
                for i in 0..<self.cartObjects.count {
                    let cartID = self.cartObjects[i].transaction_id
                    for j in 0..<transactionNomineed.count {
                        if cartID == transactionNomineed[j].transactionTxnID {
                            for k in 0..<self.nomineeDetailsObjArr.count {
                                let transactionNomID = transactionNomineed[j].transactionNomID
//                                if self.nomineeDetailsObjArr[k].nominee_id == transactionNomID {
//                                    self.cartObjects[i].nominee = self.nomineeDetailsObjArr[k]
//                                }
                            }
                        }
                    }
                }
               
                self.tableView.reloadData()
                
                if is_empty {
                    let alert = UIAlertController(title: "Alert", message: "Please Fill Nominee Detail To Continue.", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
                        Mixpanel.mainInstance().track(event: "Payment Review Screen :- Please Fill Nominee Detail To Continue alert ok button clicked")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
               self.presentWindow.hideToastActivity()
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
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
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    print(response.result.value ?? "")
                    if enc ==  "\"true\""{
                       print("Success")
                        self.fetchTransactionIdData(trnsarr:trns_arr)
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
    func fetchTransactionIdData(trnsarr:String){
       // presentWindow.makeToastActivity(message: "Loading..")
        let url = "\(Constants.BASE_URL)\(Constants.API.fetchPaymentTransactionData)/\(trnsarr)/3"
        print(url)
        if Connectivity.isConnectedToInternet {
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
                
               // let data = response.result.value
                if data != nil {
                    if let response = data as? [[String: AnyObject]] {
                        for transactionIdData in response {
                            let SCHEMECODE = transactionIdData["SCHEMECODE"] as? String ?? ""
                            let MAIN_AMC_CODE = transactionIdData["MAIN_AMC_CODE"] as? String ?? ""
                            let REPURPRICE = transactionIdData["REPURPRICE"] as? String ?? ""
                            let user_investor_id = transactionIdData["user_investor_id"] as? String ?? ""
                            let transaction_user_id = transactionIdData["transaction_user_id"] as? String ?? ""
                            let AMC_CODE = transactionIdData["AMC_CODE"] as? String ?? ""
                            let cart_scheme_code = transactionIdData["cart_scheme_code"] as? String ?? ""
                            let S_NAME = transactionIdData["S_NAME"] as? String ?? ""
                            let CAMS_CODE = transactionIdData["CAMS_CODE"] as? String ?? ""
                            let amfitype = transactionIdData["amfitype"] as? String ?? ""
                            let cart_purchase_type = transactionIdData["cart_purchase_type"] as? String ?? ""
                            let rav_amc_value = transactionIdData["rav_amc_value"] as? String ?? ""
                            let rav_code_type = transactionIdData["rav_code_type"] as? String ?? ""
                            let asbm_bank_name = transactionIdData["asbm_bank_name"] as? String ?? ""
                            let asbm_bank_account = transactionIdData["asbm_bank_account"] as? String ?? ""
                            let transaction_id = transactionIdData["transaction_id"] as? String ?? ""
                            let transaction_date = transactionIdData["transaction_date"] as? String ?? ""
                            let cart_id = transactionIdData["cart_id"] as? String ?? ""
                            let cart_amount = transactionIdData["cart_amount"] as? String ?? ""
                            let cart_units = transactionIdData["cart_units"] as? String ?? ""
                            let cart_frequency = transactionIdData["cart_frequency"] as? String ?? ""
                            let cart_tenure = transactionIdData["cart_tenure"] as? String ?? ""
                            let cart_tenure_perpetual = transactionIdData["cart_tenure_perpetual"] as? String ?? ""
                            let cart_sip_start_date = transactionIdData["cart_sip_start_date"] as? String ?? ""
                            let cart_sip_end_date = transactionIdData["cart_sip_end_date"] as? String ?? ""
                            let cart_added = transactionIdData["cart_added"] as? String ?? ""
                            let transaction_folio_no = transactionIdData["transaction_folio_no"] as? String ?? ""
                            let transaction_urn = transactionIdData["transaction_urn"] as? String ?? ""
                            let transaction_bank_id = transactionIdData["transaction_bank_id"] as? String ?? ""
                            let transaction_SI_for_SO = transactionIdData["transaction_SI_for_SO"] as? String ?? ""
                            let RT_CODE = transactionIdData["RT_CODE"] as? String ?? ""
                            let bank_name = transactionIdData["bank_name"] as? String ?? ""
                            let bank_acc_no = transactionIdData["bank_acc_no"] as? String ?? ""
                            let trxn_type = transactionIdData["trxn_type"] as? String ?? ""
                            
                            let transactionObj = FetchTransactionIdData(SCHEMECODE: SCHEMECODE, MAIN_AMC_CODE: MAIN_AMC_CODE, REPURPRICE: REPURPRICE, user_investor_id: user_investor_id, transaction_user_id: transaction_user_id, AMC_CODE: AMC_CODE, cart_scheme_code: cart_scheme_code, S_NAME: S_NAME, CAMS_CODE: CAMS_CODE, amfitype: amfitype, cart_purchase_type: cart_purchase_type, rav_amc_value: rav_amc_value, rav_code_type: rav_code_type, asbm_bank_name: asbm_bank_name, asbm_bank_account: asbm_bank_account, transaction_id: transaction_id, transaction_date: transaction_date, cart_id: cart_id, cart_amount: cart_amount, cart_units: cart_units, cart_frequency: cart_frequency, cart_tenure: cart_tenure, cart_tenure_perpetual: cart_tenure_perpetual, cart_sip_start_date: cart_sip_start_date, cart_sip_end_date: cart_sip_end_date, cart_added: cart_added, transaction_folio_no: transaction_folio_no, transaction_urn: transaction_urn, transaction_bank_id: transaction_bank_id, transaction_SI_for_SO: transaction_SI_for_SO, RT_CODE: RT_CODE, bank_name: bank_name, bank_acc_no: bank_acc_no, trxn_type: trxn_type)
                            
                            self.transactionObject.append(transactionObj)
                        }
                        
                    }
                    if self.status == "Y"{
                        
                        for i in 0..<self.pg_trnsId_arr.count {
                            self.singleBankDetail(transaction_bank_id:self.transactionObject[i].transaction_bank_id,i:i,trnsarr:trnsarr)
                        }

                    } else if self.status == "D" {
                        for i in 0..<self.pg_trnsId_arr.count {
                            if i == self.pg_trnsId_arr.count - 1{
                                //PaymentUnsuccessViewController
                                //self.presentWindow.hideToastActivity()
                                self.addchecksummessage(pg_msg: self.pg_msg[0], txn_id: self.transactionObject[i].transaction_id)
                                self.sendPaymentFailureEmailToUser(username: self.userDataArr[0].fname ?? "", email: self.userDataArr[0].email ?? "")
                                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                                destVC.success = "Payment Unsuccessful"
                                destVC.desc = "The payment of this transaction has failed. Please retry using different payment method"
                                destVC.titles = "Transaction Request"
                                destVC.id = "1"
                                self.navigationController?.pushViewController(destVC, animated: true)
                            } else {
                                self.addchecksummessage(pg_msg: self.pg_msg[0], txn_id: self.transactionObject[i].transaction_id)
                            }
                            //self.singleBankDetail(transaction_bank_id:self.transactionObject[i].transaction_bank_id,i:i, trnsarr: trnsarr)
                        }
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
    func singleBankDetail(transaction_bank_id:String,i:Int,trnsarr:String){
        print(transaction_bank_id)
        let url = "\(Constants.BASE_URL)\(Constants.API.SingleBankDetail)/\(transactionObject[i].transaction_bank_id)/3"
        
        print(url)
        
        //presentWindow.makeToastActivity(message: "Loading...")
        if Connectivity.isConnectedToInternet {
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
               // let data = response.result.value
                if data != nil {
                    if let response = data as? [[String: AnyObject]] {
                        for bankIdData in response {
                            let  bank_id = bankIdData["bank_id"] as? String ?? ""
                            let  user_name = bankIdData["user_name"] as? String ?? ""
                            let  mobile = bankIdData["mobile"] as? String ?? ""
                            let  user_email = bankIdData["user_email"] as? String ?? ""
                            let  pan = bankIdData["pan"] as? String ?? ""
                            let  bank_name = bankIdData["bank_name"] as? String ?? ""
                            let  bank_type = bankIdData["bank_type"] as? String ?? ""
                            let  bank_mst_name = bankIdData["bank_mst_name"] as? String ?? ""
                            let  bank_acc_no = bankIdData["bank_acc_no"] as? String ?? ""
                            let  bank_ifsc_code = bankIdData["bank_ifsc_code"] as? String ?? ""
                            let  micr_code = bankIdData["micr_code"] as? String ?? ""
                            let  bank_branch = bankIdData["bank_branch"] as? String ?? ""
                            let  bank_joint_holder = bankIdData["bank_joint_holder"] as? String ?? ""
                            let  single_survivor = bankIdData["single_survivor"] as? String ?? ""
                            let  bank_city = bankIdData["bank_city"] as? String ?? ""
                            let  bank_state = bankIdData["bank_state"] as? String ?? ""
                            let  bank_country = bankIdData["bank_country"] as? String ?? ""
                            let  bank_mandate = bankIdData["bank_mandate"] as? String ?? ""
                            let  bank_txn_limit = bankIdData["bank_txn_limit"] as? String ?? ""
                            let  bank_cancel_cheque = bankIdData["bank_cancel_cheque"] as? String ?? ""
                            let  bank_current_txn_limit = bankIdData["bank_current_txn_limit"] as? String ?? ""
                            let  bank_mandate_document = bankIdData["bank_mandate_document"] as? String ?? ""
                            
                            let bankObj = SingleBankDetailObject(bank_id: bank_id, user_name: user_name, mobile: mobile, user_email: user_email, pan: pan, bank_name: bank_name, bank_type: bank_type, bank_mst_name: bank_mst_name, bank_acc_no: bank_acc_no, bank_ifsc_code: bank_ifsc_code, micr_code: micr_code, bank_branch: bank_branch, bank_joint_holder: bank_joint_holder, single_survivor: single_survivor, bank_city: bank_city, bank_state: bank_state, bank_country: bank_country, bank_mandate: bank_mandate, bank_txn_limit: bank_txn_limit, bank_cancel_cheque: bank_cancel_cheque, bank_current_txn_limit: bank_current_txn_limit, bank_mandate_document: bank_mandate_document)
                            
                            self.singlebankIdData.append(bankObj)
                            self.addMandateForm(i:i,trnsarr:trnsarr)
                        }
                        
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
    func addMandateForm(i:Int,trnsarr:String){
        
       // id=userid, document_name=bank_mandate_document(from above api), bankid=transaction_bank_id(from above api), bank_txn_limit=bank_txn_limit(from above api)+bank_current_txn_limit(from above api), bank_current_txn_limit = 0
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.addmandateform)"
        print(url)
        //presentWindow.makeToastActivity(message: "Loading...")
        let bank_txn_limit = singlebankIdData[0].bank_txn_limit + singlebankIdData[0].bank_current_txn_limit
        let parameters = ["id": "\(covertToBase64(text: userid as! String))", "document_name": "\(singlebankIdData[0].bank_mandate_document.covertToBase64())","bankid":"\(singlebankIdData[0].bank_id.covertToBase64())","bank_txn_limit":"\(bank_txn_limit.covertToBase64())","bank_current_txn_limit":"0","enc_resp":"3"] as [String : Any]
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    //let data = response.result.value as? String
                    print(response.result.value ?? "")
                    if enc ==  "\"true\""{
                        print("Success")
                        if self.transactionObject[i].rav_code_type == "0"{
                            if self.transactionObject[i].RT_CODE == "1" { //CAMS
                                let url = "\(Constants.BASE_URL)\(Constants.API.feedFile)GenerateCAMSFile";
                                self.generateFile(url: url, i: i,trnsarr:trnsarr)
                            }else if self.transactionObject[i].RT_CODE == "2"{ //KARVY
                                let url = "\(Constants.BASE_URL)\(Constants.API.feedFile)GenerateKARVYFile";
                                self.generateFile(url: url, i: i,trnsarr:trnsarr)
                            }else if self.transactionObject[i].RT_CODE == "6" { //FRANKLIN
                                let url = "\(Constants.BASE_URL)\(Constants.API.feedFile)GenerateFTFile";
                                self.generateFile(url: url, i: i,trnsarr:trnsarr)
                            }else if self.transactionObject[i].RT_CODE == "14" { //SUNDARAM
                                let url = "\(Constants.BASE_URL)\(Constants.API.feedFile)GenerateSUNDARAMFile";
                                self.generateFile(url: url, i: i,trnsarr:trnsarr)
                            }
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
    func generateFile(url:String,i:Int,trnsarr:String){
        print(url)
        //presentWindow.makeToastActivity(message: "Loading..")
        let parameters = ["txnId":"\(transactionObject[i].transaction_id)","enc_resp":"3"]
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
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
                    //let data = response.result.value as? [String:String]
                    print(response.result.value ?? "")
                    let status = data1["status"] as? String ?? ""
                    if status ==  "true"{
                        print("Success")
                        self.addTxnLogin(i:i,trnsarr:trnsarr)
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
    func addchecksummessage(pg_msg:String,txn_id:String){
       // presentWindow.makeToastActivity(message: "Loading..")
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let url = "\(Constants.BASE_URL)transaction/transaction_ws.php/addchecksummessage"
        let parameters = ["pcv_msg_string":"\(pg_msg.covertToBase64())","txn_id":"\(txn_id.covertToBase64())","uid":"\(covertToBase64(text: userid as! String))","enc_resp":"3"]
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    print(enc)
//                    self.presentWindow.hideToastActivity()
//                    print(response.result.value)
//                    let data = response.result.value as? [String:String]
//                    print(response.result.value ?? "")
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func addTxnLogin(i:Int,trnsarr:String){
        var count = 0
       // if i == pg_trnsId_arr.count - 1{
            var userid = UserDefaults.standard.value(forKey: "userid")
            if flag != "0"{
                userid = flag
            } else{
                userid = UserDefaults.standard.value(forKey: "userid")
            }
            let url = "\(Constants.BASE_URL)\(Constants.API.addtxnlogin)"
            var masterCartID = [String]()
            
            if self.cartObjects.count <= 5 {
                for obj in self.cartObjects {
                    masterCartID.append(obj.cart_mst_id)
                }
                count = self.cartObjects.count
                
            } else {
                let first5 = self.cartObjects.prefix(5)
                for obj in first5 {
                    masterCartID.append(obj.cart_mst_id)
                    
                }
                count = first5.count
            }
            let str = masterCartID.joined(separator: ",")
            
        let parameters = ["txn_source":"x","main_cart_id":str.covertToBase64(),"uid":"\(covertToBase64(text: userid as! String))","tag":"success_mf_online","txn_rm":"","txn_id":"\(cartObjects[i].transaction_id.covertToBase64())","cart_amount":"\(cartObjects[i].cart_amount.covertToBase64())","enc_resp":"3"]
            print(url,"url:",parameters)
            if Connectivity.isConnectedToInternet {
                Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                    .responseString { response in
                        let enc_response = response.result.value
                        let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                        let enc = enc1?.base64Decoded()
                        
                        if enc ==  "\"true\""{
                            print("Success add txn_login")
                            
                            self.addchecksummessage(pg_msg: self.pg_msg[0], txn_id: self.transactionObject[i].transaction_id)
                            if i == self.pg_trnsId_arr.count - 1{
                                self.sendPaymentSuccessEmailToUser(username: self.userDataArr[0].fname ?? "", email: self.userDataArr[0].email ?? "");
                                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentResponseViewController") as! PaymentResponseViewController
                                destVC.titles = "Payment Request"
                                destVC.trnsarr = trnsarr
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
//        } else{
//            addchecksummessage(pg_msg: pg_msg[0], txn_id: transactionObject[i].transaction_id)
//            print(cartObjects.count,"count")
//        }
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
    func sendPaymentSuccessEmailToUser(username:String,email:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            var tableContent = ""
            if self.cartObjects.count <= 5 {
                for i in 0..<cartObjects.count{
                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
                }
            }
            else{
                let first5 = self.cartObjects.prefix(5)
                for i in 0..<first5.count{
                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
                }
            }
            let parameters = [
                "ToEmailID":"\(email)",
                "FromEmailID":"",
                "Subject" :"Your purchase request has been submitted successfully - Fintoo",
                "template_name": "txnsuccess",
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
                            print(self.transaction_date_sms)
                            self.sendPaymentSuccessEmailToOnline(username: self.userDataArr[0].fname ?? "", email: "support@fintoo.in")
                            self.sendSmsToUSer(mobile: self.userDataArr[0].mobile ?? "", msg: "Your transaction with Fintoo has been successfully placed on \(self.transaction_date_sms). You will receive a confirmation shortly, subject to funds realisation from Fund House. For any urgent query, call us directly on 9699 800600")
                           
                        }
                    }

            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func sendPaymentSuccessEmailToOnline(username:String,email:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            
            var tableContent = ""
            if self.cartObjects.count <= 5 {
                for i in 0..<cartObjects.count{
                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
                }
            }
            else{
                let first5 = self.cartObjects.prefix(5)
                for i in 0..<first5.count{
                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
                }
            }
            let parameters = [
                "ToEmailID":"support@fintoo.in",
                "FromEmailID":"",
                "email":"\(email)",
                "Subject" :"\(username) has made a purchase on Fintoo",
                "template_name": "txnsuccessonline",
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
       presentWindow.makeToastActivity(message: "Loading...")
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
    
}
