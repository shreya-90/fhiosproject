    //
//  ConfirmTransactionViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 17/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import DropDown
import FSCalendar
import Alamofire
import Mixpanel
    
class ConfirmTransactionViewController: BaseViewController {
    
    @IBOutlet weak var isipNoteLabel: UILabel!
    @IBOutlet weak var mandateTypeLabel: UILabel!
    @IBOutlet weak var xsipOutlet: UIButton!
    @IBOutlet weak var isipOutlet: UIButton!
    @IBOutlet weak var activeMember: UITextField!
    @IBOutlet weak var btnCourier: UIButton!
    @IBOutlet weak var btnPickup: UIButton!
    @IBOutlet weak var dateAndTimingView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calanderView: FSCalendar!
    @IBOutlet weak var tfDate: UITextField!
    @IBOutlet weak var tfTiming: UITextField!
    @IBOutlet weak var courierAddressView: UIView!
    @IBOutlet weak var textFieldAof: UITextField!
    @IBOutlet weak var btnSelectBankDropDown: UIButton!
    @IBOutlet weak var mandateTypeView: UIView!
    
    @IBOutlet weak var tfBank: UITextField!
    @IBOutlet weak var lblYourMandateAmountlabel: UILabel!
    @IBOutlet weak var btnYesForHigherMandate: UIButton!
    @IBOutlet weak var btnNoForHigherMandate: UIButton!
    @IBOutlet weak var newMandateAmmountView: UIView!
    @IBOutlet weak var otherOptionForBankView: UIView!
    @IBOutlet weak var downloadMandateFormMainView: UIView!
    @IBOutlet weak var uploadMandateMainView: UIView!
    @IBOutlet weak var couriorView: UIView!
    @IBOutlet weak var viewDownloadAOF: UIView!
    @IBOutlet weak var viewUploadAOF: UIView!
    @IBOutlet weak var btnSaveAndProceed: UIButton!
    
    @IBOutlet weak var mandateTypeHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainHeighConstraint: NSLayoutConstraint!
    @IBOutlet weak var courierHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadAOFHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadAOFHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bankViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadMandateFormViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadMandateMainViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var termsAndConditionHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mandateTypeTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var courierTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadAOFTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadAOFTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectBankTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadMandateTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadMandateTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var termsViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var lblMandateAmount2: UILabel!
    @IBOutlet weak var viewUploadMandateForm: UIView!
    @IBOutlet weak var tfNewMandateAmount: UITextField!
    @IBOutlet weak var btnTerms: UIButton!
    @IBOutlet weak var tfUploadAOF: UITextField!
    
    var get_member_list = [getMemberObj]()
    let dropDownMember = DropDown()
    var dropdownForTiming = DropDown()
    var dropdownForBank = DropDown()
    var doc_sub_req_time = [timeSlotObj]()
    var cartObjects = [CartObject]()
    var UserObjects = [UserObj]()
    var selectedBank: getBankObj?
    var shouldCheckForNext = true
    var cartSIPTotal = 0
    var mandateAmmountForDonloadMandateForm = 0
    var isMandateTappedForUpload = false
    var aof_id = ""
    var aof_doc_name = ""
    var isTermsAccepted = false
    var isKYCVerified = false
    var isUserDetailUpdated = false
    var amc_code_flag = false
    var transaction_bank_id = ""
    var doc_id = ""
    var uploadedCount = 0
    var totalCartValue = 0
    var country_name = ""
    var state_name = ""
    var city_name = ""
    var id = "0"
    var bank_id_dropdown = "0"
    var pickup_bool = false
    var max_trxn_limit =  false
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        addBackbutton()
       self.presentWindow.hideToastActivity()
        calanderView.dataSource = self
        calanderView.delegate = self
        
        self.dateAndTimingView.isHidden = true
        self.calanderView.isHidden = true
        self.courierAddressView.isHidden = true
        self.newMandateAmmountView.isHidden = true
       self.otherOptionForBankView.isHidden = true
        self.downloadMandateFormMainView.isHidden = true
        self.uploadMandateMainView.isHidden = true
        self.lblMandateAmount2.isHidden = true
        self.viewUploadMandateForm.isHidden = true
        
       // self.courierHeightConstraint.constant = 120
        self.bankViewHeightConstraint.constant = 80
        
        self.downloadMandateFormViewHeightConstraint.constant = 0
        self.uploadMandateMainViewHeightConstraint.constant = 0
        
        self.downloadMandateTopConstraint.constant = 0
        self.uploadMandateTopConstraint.constant = 0
        
        self.scrollView.keyboardDismissMode = .onDrag
        
        for cartObj in cartObjects {
            
            if shouldCheckForNext {
                let type = cartObj.cart_purchase_type
                if type == "Lumpsum" || type == "Additional Purchase" {
                    shouldCheckForNext = true
                    self.mandateTypeHeightConstraint.constant = 0
                    self.mandateTypeTopConstraints.constant = 0
                    mandateTypeView.isHidden = true
                    adjustMainHeight()
                } else {
                    shouldCheckForNext = false
                    //lblYourMandateAmountlabel.isHidden = false
                    isipNoteLabel.isHidden = true
                    mandateTypeView.isHidden = true
                    mandateTypeHeightConstraint.constant = 0
                    self.mandateTypeTopConstraints.constant = 0
                    adjustMainHeight()
                }
            }
            //added this for sundaram fund
            if cartObj.AMC_CODE == "400029" {
                amc_code_flag = true
                isipOutlet.isHidden = true
            }
        }
        
        for cartObj in cartObjects {
            let type = cartObj.cart_purchase_type
            if type == "SIP" {
                if let ammount = cartObj.cart_amount.numberValue {
                    cartSIPTotal = cartSIPTotal + Int(truncating: ammount)
                }
            }
        }
        
        for cartObj in cartObjects {
            
            if self.transaction_bank_id == "" {
                self.transaction_bank_id = cartObj.transaction_bank_id
            }
        }
        
            self.checkForAOFStatus()
        
//        if self.transaction_bank_id.count > 0 {
//            getBankList()
//           // self.getBankDetail(bankID: self.transaction_bank_id)
//        } else {
//            getCurriorPickUpData()
//        }
        
        self.couriorView.isHidden = true
        self.courierTopConstraint.constant = 0
        self.courierHeightConstraint.constant = 0
        
        self.adjustMainHeight()
       
    }
  
    
    override func viewWillDisappear(_ animated: Bool) {
        userBanklist.removeAll()
    }
    func adjustMainHeight() {
        self.presentWindow.hideToastActivity()
        let totalSeperatorConstant = courierTopConstraint.constant + downloadAOFTopConstraint.constant + uploadAOFTopConstraint.constant
        let totalSeperatorConstant1 = totalSeperatorConstant + selectBankTopConstraint.constant + downloadMandateTopConstraint.constant
        let totalSeperatorConstant2 =  totalSeperatorConstant1 + uploadMandateTopConstraint.constant + termsViewTopConstraint.constant
        let part1 = courierHeightConstraint.constant + downloadAOFHeightConstraint.constant  + uploadAOFHeightConstraint.constant + bankViewHeightConstraint.constant
        let part2 = downloadMandateFormViewHeightConstraint.constant + uploadMandateMainViewHeightConstraint.constant + termsAndConditionHeightConstraint.constant + mandateTypeHeightConstraint.constant + totalSeperatorConstant2
        let totalHeight = part1 + part2
        mainHeighConstraint.constant = totalHeight
        print( mainHeighConstraint.constant,"########")
        self.lblYourMandateAmountlabel.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // self.getPanDetail()
        self.getUserDetail()
        getUserData()
        uploadedCount = 0
        
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        navigationController?.pushViewController(destVC, animated: false)
    }
    func pickDoc(){
        
        let documentPicker = UIDocumentPickerViewController(documentTypes:["public.image", "public.composite-content", "public.text"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
    }
    @IBAction func memberBtn(_ sender: UIButton) {
        
        //getMemberList(sender: sender)
        //id = "1"
    }
}
//#MARK: FSCalendar Delegates
extension ConfirmTransactionViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.calanderView.isHidden = true
        self.dateAndTimingView.isHidden = false
       // self.courierHeightConstraint.constant = 200
        self.adjustMainHeight()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myString = formatter.string(from: date)
        self.tfDate.text = myString
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)
        if weekday == 1 || weekday == 7 {
            
            return false
        }
        return true
    }
}

//#MARK: API
extension ConfirmTransactionViewController {
    
    func checkForAOFStatus() {
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
//        let url = "\(Constants.BASE_URL)\(Constants.API.fetchAOFfileofUser)/\(userid!.covertToBase64())/3"
//        if Connectivity.isConnectedToInternet {
//            Alamofire.request(url).responseString { response in
//                let enc_response = response.result.value
//                var dict = [Dictionary<String,Any>]()
//                let enc1 = enc_response?.replacingOccurrences(of: " " , with: "")
//                if let enc = enc1?.base64Decoded() {
//                    dict = self.convertToDictionary(text: enc)
//                } else{
//                    self.presentWindow.hideToastActivity()
//                }
//                let data = dict
//
//                print(response.result.value,"AOF STATUS")
//                if let responseData = data as? [[String: AnyObject]] {
//                    if responseData.indices.contains(0) {
//                        let doc_name = responseData[0]["doc_name"] as? String ?? ""
//                        if doc_name.count > 0 {
//                            self.viewDownloadAOF.isHidden = true
//                            self.viewUploadAOF.isHidden = true
//                            self.downloadAOFHeightConstraint.constant = 0
//                            self.uploadAOFHeightConstraint.constant = 0
//                            self.downloadAOFTopConstraint.constant = 0
//                            self.uploadAOFTopConstraint.constant = 0
//                            self.adjustMainHeight()
//                        }
//                    }
//                } else {
//                    self.couriorView.isHidden = false
//                    self.courierTopConstraint.constant = 12
//                    self.courierHeightConstraint.constant = 120
//                    self.adjustMainHeight()
//                }
//            }
        let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(covertToBase64(text: userid ?? ""))/3"
        print(url)
        //DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.presentWindow.makeToastActivity(message: "Loading...")
       // })
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
                // self.presentWindow.hideToastActivity()
                if let data = data as? [[String: AnyObject]] {
                    for object in data {
                        let bse_aof_status =  object["bse_aof_status"] as? String ?? ""
                        if bse_aof_status == "1" {
                            self.viewDownloadAOF.isHidden = true
                            self.viewUploadAOF.isHidden = true
                            self.downloadAOFHeightConstraint.constant = 0
                            self.uploadAOFHeightConstraint.constant = 0
                            self.downloadAOFTopConstraint.constant = 0
                            self.uploadAOFTopConstraint.constant = 0
                            if self.transaction_bank_id.count > 0 {
                                self.getBankList()
                                // self.getBankDetail(bankID: self.transaction_bank_id)
                            } else {
                                self.getCurriorPickUpData()
                            }
                            self.adjustMainHeight()
                        } else {
                            //self.couriorView.isHidden = false
                           // self.courierTopConstraint.constant = 12
                           // self.courierHeightConstraint.constant = 120
                            if self.transaction_bank_id.count > 0 {
                                self.getBankList()
                                // self.getBankDetail(bankID: self.transaction_bank_id)
                            } else {
                                self.getCurriorPickUpData()
                            }
                            self.adjustMainHeight()
                        }
                    }
                }
            }
        }else {
            self.presentWindow.hideToastActivity()
            self.presentWindow?.makeToast(message: "No Internet Connection")
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
                    let alert = UIAlertController(title: "Alert", message: "\(data!["bse_err_status"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                        print("Ok button clicked")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
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
                let data = response.result.value as? [String:String]
                if let bse_reg_status = data?["bse_reg"] {
                    print(bse_reg_status)
                    if bse_reg_status == "Y" {
                        self.clientregistrationBse(userid: userid)
                    } else {
                    }
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    func updatemandatetype1(userid:String,bank_id:String,mandate_type:String,scan_mandate_flag:String){
        self.presentWindow.makeToastActivity(message: "Loading...")
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
                        self.mandateRegister1(userid:userid,bank_id: (self.selectedBank?.bank_id)!, cart_SIP_total: self.cartSIPTotal,scan_mandate_flag:scan_mandate_flag)
                    } else {
                        self.presentWindow.hideToastActivity()
                    }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    func mandateRegister1(userid:String,bank_id:String,cart_SIP_total:Int,scan_mandate_flag:String){
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
                        if self.btnYesForHigherMandate.currentImage == #imageLiteral(resourceName: "check") {
                            
                            if self.tfNewMandateAmount.text == "" {
                                let mandateAmount = self.lblMandateAmount2.text!.components(separatedBy: " ").last
                                
                                self.presentWindow?.makeToast(message: "Please enter higher amount than \(mandateAmount!)")
                            } else {
                                let amount = Int64(self.tfNewMandateAmount.text!)
                                if amount! % 500 == 0 {
                                    let mandateAmount = self.lblMandateAmount2.text!.components(separatedBy: " ").last
                                    if mandateAmount!.count > 0 {
                                        if Int(self.tfNewMandateAmount.text!)! > Int(mandateAmount!)! {
                                            var userid = UserDefaults.standard.value(forKey: "userid") as? String
                                            if flag != "0"{
                                                userid! = flag
                                            } else{
                                                userid = UserDefaults.standard.value(forKey: "userid") as? String
                                            }
                                            guard let bankObj = self.selectedBank else {return}
                                            let selectedBankID = bankObj.bank_id ?? ""
                                            let mandateAmmount = "\(self.tfNewMandateAmount.text!)"
                                            
                                            var cartIDArray = [String]()
                                            for cartObj in self.cartObjects {
                                                cartIDArray.append(cartObj.cart_id)
                                            }
                                            
                                            
                                            var url = ""
                                            print(self.UserObjects[0].mobile)
                                            if self.UserObjects[0].mobile != "" && self.UserObjects[0].email != "" {
                                                self.presentWindow.hideToastActivity()
                                                let memberid = UserDefaults.standard.value(forKey: "memberid") as? String ?? "0"
                                                let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
                                                if memberid != "0"  && memberid != parent_user_id {
                                                    userid! = flag
                                                    let phone = self.UserObjects[0].mobile
                                                    let email = self.UserObjects[0].email
                                                    print(email)
                                                    let email_mobile = phone + "|" + email
                                                    url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())&member=1"
                                                    print(url,"mandate")
                                                } else{
                                                    let phone = self.UserObjects[0].mobile
                                                    let email = self.UserObjects[0].email
                                                    let email_mobile = phone + "|" + email
                                                    userid = UserDefaults.standard.value(forKey: "userid") as? String
                                                    url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())"
                                                    print(url,"mandate")
                                                }
                                            } else{
                                                self.presentWindow.hideToastActivity()
                                                self.presentWindow.makeToast(message: "Please First Complete Personal Details!!")
                                                Mixpanel.mainInstance().track(event: "Additional Details : Please First Complete Personal Details!!")
                                            }
                                            if Connectivity.isConnectedToInternet {
                                                
                                                let destination: DownloadRequest.DownloadFileDestination = { _,_ in
                                                    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                                    documentsURL.appendPathComponent("mandate-\(userid!)-\(selectedBankID)-unsigned.pdf")
                                                    return (documentsURL, [.removePreviousFile])
                                                }
                                                
                                                Alamofire.download(url, to: destination).responseData { response in
                                                    if let destinationUrl = response.destinationURL {
                                                        let destinationURLForFile = destinationUrl.absoluteURL
                                                        self.showFileWithPath(path: destinationURLForFile.path)
                                                    } else {
                                                        self.presentWindow.hideToastActivity()
                                                    }
                                                }
                                                
                                            } else {
                                                self.presentWindow.hideToastActivity()
                                                self.presentWindow?.makeToast(message: "No Internet Connection")
                                            }
                                        } else {
                                            self.presentWindow?.makeToast(message: "Please enter higher amount than \(mandateAmount!)")
                                            Mixpanel.mainInstance().track(event: "Additional Details : Please enter higher amount than \(mandateAmount!)")
                                        }
                                    }
                                } else {
                                    self.presentWindow?.makeToast(message: "The new mandate amount should be multiple of 500.")
                                    Mixpanel.mainInstance().track(event: "Additional Details : The new mandate amount should be multiple of 500.")
                                }
                            }
                        } else {
                            var userid = UserDefaults.standard.value(forKey: "userid") as? String
                            if flag != "0"{
                                userid! = flag
                            } else{
                                userid = UserDefaults.standard.value(forKey: "userid") as? String
                            }
                            guard let bankObj = self.selectedBank else {return}
                            let selectedBankID = bankObj.bank_id ?? ""
                            let mandateAmmount = "\(self.mandateAmmountForDonloadMandateForm)"
                            
                            var cartIDArray = [String]()
                            for cartObj in self.cartObjects {
                                cartIDArray.append(cartObj.cart_id)
                            }
                            
                            self.presentWindow.makeToastActivity(message: "Loading...")
                            print(self.UserObjects[0].mobile)
                            var url = ""
                            if self.UserObjects[0].mobile != "" && self.UserObjects[0].email != "" {
                                let memberid = UserDefaults.standard.value(forKey: "memberid") as? String ?? "0"
                                let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
                                if memberid != "0" && memberid != parent_user_id {
                                    userid! = flag
                                    let phone = self.UserObjects[0].mobile
                                    let email = self.UserObjects[0].email
                                    print(email)
                                    let email_mobile = phone + "|" + email
                                    url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())&member=1"
                                    print(url,"mandate")
                                    //presentWindow.hideToastActivity()
                                } else{
                                    let phone = self.UserObjects[0].mobile
                                    let email = self.UserObjects[0].email
                                    let email_mobile = phone + "|" + email
                                    userid = UserDefaults.standard.value(forKey: "userid") as? String
                                    url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())"
                                    print(url,"mandate")
                                    //presentWindow.hideToastActivity()
                                }
                            } else{
                                self.presentWindow.hideToastActivity()
                                self.presentWindow.makeToast(message: "Please First Complete Personal Details!!")
                                Mixpanel.mainInstance().track(event: "Additional Details : Please First Complete Personal Details!!")
                            }
                            if Connectivity.isConnectedToInternet {
                                
                                let destination: DownloadRequest.DownloadFileDestination = { _,_ in
                                    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                                    documentsURL.appendPathComponent("mandate-\(userid!)-\(selectedBankID)-unsigned.pdf")
                                    return (documentsURL, [.removePreviousFile])
                                }
                                
                                Alamofire.download(url, to: destination).responseData { response in
                                    if let destinationUrl = response.destinationURL {
                                        let destinationURLForFile = destinationUrl.absoluteURL
                                        self.showFileWithPath(path: destinationURLForFile.path)
                                    } else {
                                        self.presentWindow.hideToastActivity()
                                    }
                                }
                                
                            } else {
                                self.presentWindow.hideToastActivity()
                                self.presentWindow?.makeToast(message: "No Internet Connection")
                            }
                        }
                    }
                } else {
                    self.presentWindow.hideToastActivity()
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
    func updatemandatetype(userid:String,bank_id:String,mandate_type:String,scan_mandate_flag:String){
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
                        if scan_mandate_flag == "1"{
                            self.ScanMandateImageUpload(userid: userid, bank_id: bank_id)
                        }else{
                            guard let bankObj = self.selectedBank else { return }
                            self.presentWindow.hideToastActivity()
                            let storyboard = UIStoryboard(name: "ProductList", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "PaymentReviewViewController") as! PaymentReviewViewController
                            controller.selectedBank = bankObj
                            controller.cartObjects = self.cartObjects
                            controller.totalCartValue = self.totalCartValue
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
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
                        self.presentWindow.hideToastActivity()
                        let name = UserDefaults.standard.value(forKey: "name") ?? ""
                        let email = UserDefaults.standard.value(forKey: "Email") ?? ""
                        let address = self.UserObjects[0].flat_no + " " + self.UserObjects[0].building_name + " " + self.UserObjects[0].road_street + " " + self.UserObjects[0].address + " " + self.city_name + " " + self.state_name + " " + self.country_name + "-" + self.UserObjects[0].pincode
                        let fullname = self.UserObjects[0].name + " " +  self.UserObjects[0].middle_name + " " + self.UserObjects[0].last_name
                        if self.btnPickup.currentImage == #imageLiteral(resourceName: "check") {
                            self.send_otp_on_Email(ToEmailID: "support@fintoo.in", FromEmailID: "\(email)", Body: "Hey Team,The documents for \(name), registered with email id\(email) have been picked up.Kindly review this and pass this to the concerned department, so that due diligence is done", Subject: "Documents picked up for \(name) on Fintoo")
                            //8976565077
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "yyyy-MM-dd"
                            let startTime = dateFormatter1.date(from: "\(self.tfDate.text!)")
                            dateFormatter1.dateFormat = "MMMM dd, yyyy"
                            
                            print(dateFormatter1.string(from: startTime!))
                            let date_time = dateFormatter1.string(from: startTime!) + " " + self.tfTiming.text!
                            self.send_otp_on_mobile(mobile_number: "8976565077", msg: "\(fullname) has placed pickup document request - Address: \(address) Date: \(date_time)", fourDigit: "")
                        }
                        else if self.btnCourier.currentImage == #imageLiteral(resourceName: "check"){
                            
                            self.send_otp_on_mobile(mobile_number: "8976565077", msg: "\(fullname) with address: \(address) has selected courier option so no need to go there for document collection.", fourDigit: "")
                        }
                    } else {
                        self.presentWindow.hideToastActivity()
                    }

                }
            }
        }
    }
    func getCurriorPickUpData() {
        
        presentWindow.makeToastActivity(message: "Loading..")
        
        var masterCartID = [String]()
        for obj in self.cartObjects {
            masterCartID.append(obj.cart_mst_id)
        }
        let str = masterCartID.joined(separator: ",")
        let url = "\(Constants.BASE_URL)\(Constants.API.getCurriorData)/\(str)"
        print(url)
        if Connectivity.isConnectedToInternet {
            
             Alamofire.request(url).responseJSON { response in
                
                if let responseData = response.result.value as? [[String: AnyObject]] {
                    if responseData.indices.contains(0) {
                        let doc_sub_req = responseData[0]["doc_sub_req"] as? String ?? ""
                        self.doc_id = responseData[0]["doc_id"] as? String ?? ""
                       // self.presentWindow.hideToastActivity()
                        if doc_sub_req == "courier" {
                            self.btnCourier.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                            self.courierAddressView.isHidden = false
                            //self.courierHeightConstraint.constant = 210
                            self.adjustMainHeight()
                        } else if doc_sub_req == "pickup" {
                            self.btnPickup.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                            let doc_sub_req_time = responseData[0]["doc_sub_req_time"] as? String ?? ""
                            let doc_sub_req_date = responseData[0]["doc_sub_req_date"] as? String ?? ""
                            
                            self.tfTiming.text = doc_sub_req_time
                            self.tfDate.text = doc_sub_req_date
                            
                            self.dateAndTimingView.isHidden = false
                            //self.courierHeightConstraint.constant = 200
                            self.adjustMainHeight()
                        } else {
                            self.presentWindow.hideToastActivity()
                            print("no data")
                        }
                    }
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func addToTransaction(obj: CartObject) {
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.addTransaction)"
        if Connectivity.isConnectedToInternet {
            print(obj.cart_purchase_type)
            var status = ""
            switch obj.cart_purchase_type {
            case "Lumpsum":
                status = "1"
            case "SIP":
                status = "6"
            case "Additional Purchase":
                status = "24"
            default:
                status = ""
            }
            
            let parameters = [
                "txn_id": obj.transaction_id.covertToBase64() ,
                "user_id":"\(userid!.covertToBase64())",
                "cart_id": obj.cart_id.covertToBase64(),
                "bank_id": self.selectedBank?.bank_id?.covertToBase64() ?? "",
                "status": status,
                "folio_no": obj.cart_folio_no.covertToBase64(),
                "trxntype": "",
                "enc_resp":"3"
            ]
            print(parameters)
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    print(self.uploadedCount,self.cartObjects.count - 1,"Count")
                    if self.uploadedCount == self.cartObjects.count - 1 {
                        
                        guard let bankObj = self.selectedBank else { return }
                        if !self.shouldCheckForNext {
                            if self.isipOutlet.currentImage == #imageLiteral(resourceName: "check") {
                                guard let bankObj = self.selectedBank else { return }
                                self.presentWindow.hideToastActivity()
                                let storyboard = UIStoryboard(name: "ProductList", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "PaymentReviewViewController") as! PaymentReviewViewController
                                controller.selectedBank = bankObj
                                controller.cartObjects = self.cartObjects
                                controller.totalCartValue = self.totalCartValue
                                controller.mandate_type = "isip"
                                self.navigationController?.pushViewController(controller, animated: true)
                             //   self.updatemandatetype(userid: userid!, bank_id: self.selectedBank?.bank_id ?? "", mandate_type: "isip", scan_mandate_flag: "0")
                            } else {
                                guard let bankObj = self.selectedBank else { return }
                                self.presentWindow.hideToastActivity()
                                let storyboard = UIStoryboard(name: "ProductList", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "PaymentReviewViewController") as! PaymentReviewViewController
                                controller.selectedBank = bankObj
                                controller.cartObjects = self.cartObjects
                                controller.totalCartValue = self.totalCartValue
                                 controller.mandate_type = "xsip"
                                self.navigationController?.pushViewController(controller, animated: true)
                              //  self.updatemandatetype(userid: userid!, bank_id: self.selectedBank?.bank_id ?? "", mandate_type: "xsip", scan_mandate_flag: "0")
                            }
                        } else {
                            self.presentWindow.hideToastActivity()
                            let storyboard = UIStoryboard(name: "ProductList", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "PaymentReviewViewController") as! PaymentReviewViewController
                            controller.selectedBank = bankObj
                            controller.cartObjects = self.cartObjects
                            controller.totalCartValue = self.totalCartValue
                            self.navigationController?.pushViewController(controller, animated: true)
                        }
//                        let storyboard = UIStoryboard(name: "ProductList", bundle: nil)
//                        let controller = storyboard.instantiateViewController(withIdentifier: "PaymentReviewViewController") as! PaymentReviewViewController
//                        controller.selectedBank = bankObj
//                        controller.cartObjects = self.cartObjects
//                        controller.totalCartValue = self.totalCartValue
//                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                   // self.presentWindow.hideToastActivity()
                    self.uploadedCount += 1
                    
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
//    func getBankDetail(bankID: String) {
//
//        var userid = UserDefaults.standard.value(forKey: "userid") as? String
//        if flag != "0"{
//            userid! = flag
//        } else{
//            userid = UserDefaults.standard.value(forKey: "userid") as? String
//        }
//        presentWindow.makeToastActivity(message: "Loading...")
//        let url = "\(Constants.BASE_URL)\(Constants.API.getBank)\(userid!.covertToBase64())/fintoo/3"
//
//        if Connectivity.isConnectedToInternet {
//
//            userBanklist.removeAll()
//            userBanklist.append(getBankObj.getUserBank(bank_acc_no: "", bank_branch: "", bank_cancel_cheque: "", bank_city: "", bank_country: "", bank_current_txn_limit: "", bank_id: "", bank_ifsc_code: "", bank_joint_holder: "", bank_mandate: "", bank_mandate_document: "", bank_name: "Select Bank", bank_state: "", bank_txn_limit: "", bank_type: "Select", banks_bd_code: "", micr_code: "", single_survivor: "", txn_exst: "", country_name: "Select Country", state_name: "Select State", city_name: "Select City"))
//
//            Alamofire.request(url).responseString { response in
//                let enc_response = response.result.value
//                var dict = [Dictionary<String,Any>]()
//                let enc1 = enc_response?.replacingOccurrences(of: " " , with: "")
//                if let enc = enc1?.base64Decoded() {
//                    dict = self.convertToDictionary(text: enc)
//                } else{
//                    self.presentWindow.hideToastActivity()
//                }
//                let data = dict
//
//                self.getCurriorPickUpData()
//               // self.presentWindow.hideToastActivity()
//                if let data = data as? [AnyObject]{
//
//                    if data.isEmpty != true {
//                        for type in data {
//
//                            if let bank_id = type.value(forKey: "bank_id") as? String,
//                                let bank_name = type.value(forKey: "bank_name") as? String,
//                                let bank_acc_no = type.value(forKey: "bank_acc_no") as? String,
//                                let bank_branch = type.value(forKey: "bank_branch") as? String,
//                                let bank_cancel_cheque = type.value(forKey: "bank_cancel_cheque") as? String,
//                                let bank_city = type.value(forKey: "bank_city") as? String,
//                                let bank_country = type.value(forKey: "bank_country") as? String,
//                                let bank_current_txn_limit = type.value(forKey: "bank_current_txn_limit") as? String,
//                                let bank_ifsc_code = type.value(forKey: "bank_ifsc_code") as? String,
//                                let bank_joint_holder = type.value(forKey: "bank_joint_holder") as? String,
//                                let bank_mandate = type.value(forKey: "bank_mandate") as? String,
//                                let bank_state = type.value(forKey: "bank_state") as? String,
//                                let bank_txn_limit = type.value(forKey: "bank_txn_limit") as? String,
//                                let bank_type = type.value(forKey: "bank_type") as? String,
//                                let banks_bd_code = type.value(forKey: "banks_bd_code") as? String,
//                                let micr_code = type.value(forKey: "micr_code") as? String,
//                                let single_survivor = type.value(forKey: "single_survivor") as? String,
//                                let txn_exst = type.value(forKey: "txn_exst") as? String,
//                                let bank_mandate_document = type.value(forKey: "bank_mandate_document") as? String,
//                                let country = type.value(forKey: "country_name") as? String,
//                                let state = type.value(forKey: "state_name") as? String,
//                                let city = type.value(forKey: "city_name") as? String
//                            {
//
//                                userBanklist.append(getBankObj.getUserBank(bank_acc_no: bank_acc_no, bank_branch: bank_branch, bank_cancel_cheque: bank_cancel_cheque, bank_city: bank_city, bank_country: bank_country, bank_current_txn_limit: bank_current_txn_limit, bank_id: bank_id, bank_ifsc_code: bank_ifsc_code, bank_joint_holder: bank_joint_holder, bank_mandate: bank_mandate, bank_mandate_document: bank_mandate_document, bank_name: bank_name, bank_state: bank_state, bank_txn_limit: bank_txn_limit, bank_type: bank_type, banks_bd_code: banks_bd_code, micr_code: micr_code, single_survivor: single_survivor, txn_exst: txn_exst, country_name:country ,state_name: state, city_name: city))
//
//                                if bank_id == self.transaction_bank_id {
//                                    self.selectedBank = getBankObj.getUserBank(bank_acc_no: bank_acc_no, bank_branch: bank_branch, bank_cancel_cheque: bank_cancel_cheque, bank_city: bank_city, bank_country: bank_country, bank_current_txn_limit: bank_current_txn_limit, bank_id: bank_id, bank_ifsc_code: bank_ifsc_code, bank_joint_holder: bank_joint_holder, bank_mandate: bank_mandate, bank_mandate_document: bank_mandate_document, bank_name: bank_name, bank_state: bank_state, bank_txn_limit: bank_txn_limit, bank_type: bank_type, banks_bd_code: banks_bd_code, micr_code: micr_code, single_survivor: single_survivor, txn_exst: txn_exst, country_name:country ,state_name: state, city_name: city)
//                                }
//
//                            }
//                        }
//                    } else{
//                        self.presentWindow.hideToastActivity()
//                    }
//
//                    self.dropdownForBank.anchorView = self.btnSelectBankDropDown
//                    self.dropdownForBank.dataSource = userBanklist.map { $0.bank_name ?? ""}
//
//                    if self.selectedBank != nil {
//
//                        self.tfBank.text = self.selectedBank?.bank_name ?? ""
//
//                        if !self.shouldCheckForNext {
//                            self.couriorView.isHidden = false
//                            self.courierTopConstraint.constant = 12
//                            self.courierHeightConstraint.constant = 120
//                        }
//                        self.getMedmandateAmount(bankObj: self.selectedBank!)
//                    }
//
//                    self.dropdownForBank.selectionAction = { [unowned self] (index: Int, item: String) in
//                        self.tfBank.text = userBanklist[index].bank_name
//                        if index != 0 {
//
//                            if !self.shouldCheckForNext {
//                                self.couriorView.isHidden = false
//                                self.courierTopConstraint.constant = 12
//                                self.courierHeightConstraint.constant = 120
//                            }
//                            self.selectedBank = userBanklist[index]
//                            self.getMedmandateAmount(bankObj: userBanklist[index])
//                        } else {
//
//                            if !self.shouldCheckForNext {
//                                self.couriorView.isHidden = true
//                                self.courierTopConstraint.constant = 0
//                                self.courierHeightConstraint.constant = 0
//                            }
//
//                            self.lblYourMandateAmountlabel.text = "Your available mandate amount : Rs 0"
//
//                            self.downloadMandateFormMainView.isHidden = true
//                            self.uploadMandateMainView.isHidden = true
//                            self.lblMandateAmount2.isHidden = true
//                            self.newMandateAmmountView.isHidden = true
//                            self.otherOptionForBankView.isHidden = true
//                            self.bankViewHeightConstraint.constant = 112
//
//                            self.downloadMandateFormViewHeightConstraint.constant = 0
//                            self.uploadMandateMainViewHeightConstraint.constant = 0
//
//                            self.downloadMandateTopConstraint.constant = 0
//                            self.uploadMandateTopConstraint.constant = 0
//
//                            self.adjustMainHeight()
//                        }
//                    }
//                }
//            }
//        } else {
//            presentWindow.hideToastActivity()
//            presentWindow?.makeToast(message: "No Internet Connection")
//        }
//    }
    
    func getPanDetail() {
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let pan = UserDefaults.standard.value(forKey: "pan") as? String ?? ""
        let pan1 = pan.replacingOccurrences(of: "'", with: "")
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.kycStatus)\(pan1)/\(userid!)/3"
        print(url)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url).responseString { response in
                let enc_response = response.result.value
                var dict = [String: Any]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary3(text: enc)!
                    
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                self.presentWindow.hideToastActivity()
                if let data = data as? [String: AnyObject] {
                    let status = data["status"] as? String ?? ""
                    print(status)
                    
                    if status == "002" || status == "102" || status == "202" || status == "302" || status == "402" {
                        print("verified")
                        self.presentWindow.hideToastActivity()
                        self.isKYCVerified = true
                        self.btnSaveAndProceed.setTitle("PROCEED", for: .normal)
                        self.cart_count()
                        //self.getUserDetail()
                    } else {
                        //self.getUserDetail()
                        self.presentWindow.hideToastActivity()
                        self.btnSaveAndProceed.setTitle("SAVE DETAILS", for: .normal)
                        let alert = UIAlertController(title: "Alert", message: "We have your documents and we will get your KYC done. Once done, you will be intimated and then you can proceed with the purchase", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {alert in
                            Mixpanel.mainInstance().track(event: "Additional Details : Alert Ok Button Clicked")
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func cart_count(){
        self.presentWindow.hideToastActivity()
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        if flag != "0"{
            userid = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as! String
        }
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3")
                .responseString { response in
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
                        self.btnCart.badgeString = String(data.count)
                        self.presentWindow.hideToastActivity()
                        if data.count == 0{
                            let alert = UIAlertController(title: "Alert", message: "To proceed please add fund/s in cart.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                                Mixpanel.mainInstance().track(event: "Additional Details : Alert Ok Button Clicked")
                                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
                                self.navigationController?.pushViewController(destVC, animated: true)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            print("bank is empty")
                        }
                    }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getUserDetail() {
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(covertToBase64(text: userid!))/3"
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
                if let data = data as? [[String: AnyObject]] {
                    if data.count > 0 {
                        self.isUserDetailUpdated = true
                        self.getPanDetail()
                        
                    } else {
                        
                        let alert = UIAlertController(title: "Alert", message: "For further process, as per SEBI guidelines you need to fill in your account details.", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "Click here to proceed!", style: UIAlertActionStyle.default, handler: { alert in
                            Mixpanel.mainInstance().track(event: "Additional Details : Alert Click here to proceed! Button Clicked")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                            self.navigationController?.pushViewController(controller, animated: true)
                        }))
                        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { alert in
                            Mixpanel.mainInstance().track(event: "Additional Details : Alert Cancel Button Clicked")
                            
                        }))
                        self.present(alert, animated: true, completion: nil)
                        self.btnSaveAndProceed.setTitle("FILL KYC DETAILS TO CONTINUE!", for: .normal)
                    }
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    
    func getTimeSlot(sender: UIButton) {
        
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.getTimeSlot)"
        doc_sub_req_time.removeAll()
        doc_sub_req_time.append(timeSlotObj.getTimeSlot(time_slot_id: "00", time_slot_value: "Pickup Time"))
        
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                self.presentWindow.hideToastActivity()
                if let data = response.result.value as? [AnyObject] {
                    if data.isEmpty != true{
                        for type in data{
                            if let time_slot_id = type.value(forKey: "time_slot_id") as? String,
                                let time_slot_value = type.value(forKey: "time_slot_value") as? String{
                                self.doc_sub_req_time.append(timeSlotObj.getTimeSlot(time_slot_id: time_slot_id, time_slot_value: time_slot_value))
                                
                            }
                        }
                        
                        self.dropdownForTiming.anchorView = sender
                        self.dropdownForTiming.dataSource = self.doc_sub_req_time.map { $0.time_slot_value ?? ""}
                        self.dropdownForTiming.selectionAction = { [unowned self] (index: Int, item: String) in
                            self.tfTiming.text = self.doc_sub_req_time[index].time_slot_value
                        }
                        self.dropdownForTiming.show()
                    }
                }
                
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getAOF() {
      var userid = UserDefaults.standard.value(forKey: "userid") as? String
        var url = ""
        print(UserObjects[0].mobile)
        let memberid = UserDefaults.standard.value(forKey: "memberid") as? String
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        if UserObjects[0].mobile != "" && UserObjects[0].email != "" {
            if memberid != "0" && memberid != parent_user_id {
                userid! = flag
                let phone = UserObjects[0].mobile
                let email = UserObjects[0].email
                print(email)
                let email_mobile = phone + "|" + email
                url = "\(Constants.API.generateAOF)\(userid!.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())&member=1"
            } else{
                let phone = UserObjects[0].mobile
                let email = UserObjects[0].email
                let email_mobile = phone + "|" + email
                userid = UserDefaults.standard.value(forKey: "userid") as? String
                url = "\(Constants.API.generateAOF)\(userid!.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())"
                
            }
            presentWindow.makeToastActivity(message: "Loading...")
            print(url)
            let destination: DownloadRequest.DownloadFileDestination = { _,_ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent("aof-\(userid!)-0-unsigned.pdf")
                return (documentsURL, [.removePreviousFile])
            }
            
            Alamofire.download(url, to: destination).responseData { response in
                if let destinationUrl = response.destinationURL {
                    print("destinationUrl \(destinationUrl.absoluteURL)")
                    let destinationURLForFile = destinationUrl.absoluteURL
                    self.showFileWithPath(path: destinationURLForFile.path)
                } else {
                    self.presentWindow.hideToastActivity()
                }
            }
        } else{
            presentWindow.makeToast(message: "Please First Fill Personal Details!!")
            Mixpanel.mainInstance().track(event: "Additional Details : Please First Fill Personal Details!!")
        }
    }
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            
            viewer.presentPreview(animated: true)
            presentWindow.hideToastActivity()
        }
    }
    
    func uploadDocs(doc_value:String,doc_ext:String){
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading...")
        if Connectivity.isConnectedToInternet {
            
            let parameters = [
                "doc_value":"\(doc_value)",
                "user_id":"\(userid!.covertToBase64())",
                "doc_ext":"\(doc_ext)",
                "enc_resp":"3"
            ]
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.uploadDoc)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                    }
                    let data = dict
                    
                    
                    if let data = data as? [[String: AnyObject]] {
                        if data.indices.contains(0) {
                            let doc_name = data[0]["doc_name"] as? String ?? ""
                            let error = data[0]["error"] as? String ?? ""
                            if error.count > 0 {
                                self.presentWindow?.makeToast(message: "Something Went wrong!")
                            } else {
                                if self.isMandateTappedForUpload {
                                    var selectedOption = ""
                                    if self.btnPickup.currentImage == #imageLiteral(resourceName: "check") {
                                        selectedOption = "pickup"
                                        self.addDocDetails(document_name: doc_name, doc_id: self.doc_id, type: "mandate", address_type: "", doc_sub_req: selectedOption, doc_sub_req_date: self.tfDate.text!, doc_sub_req_time: self.tfTiming.text!)
                                        self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
                                        Mixpanel.mainInstance().track(event: "Additional Details : Mandate Uploaded Successfully")
                                    } else {
                                        selectedOption = "courier"
                                        self.addDocDetails(document_name: doc_name, doc_id: self.doc_id, type: "mandate", address_type: "", doc_sub_req: selectedOption, doc_sub_req_date: "", doc_sub_req_time: "")
                                         self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
                                        Mixpanel.mainInstance().track(event: "Additional Details : Mandate Uploaded Successfully")
                                    }
                                } else {
                                    self.addDocDetails(document_name: doc_name, doc_id: "", type: "aof", address_type: "", doc_sub_req: "", doc_sub_req_date: "", doc_sub_req_time: "")
                                    //self.presentWindow.makeToast(message: "AOF Uploaded Successfully")
                                    Mixpanel.mainInstance().track(event: "Additional Details : AOF Uploaded Successfully")
                                }
                            }
                        }
                    }
                    
            }
        } else{
            self.presentWindow.hideToastActivity()
            self.presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func addDocDetails(document_name:String, doc_id:String, type:String, address_type:String, doc_sub_req:String, doc_sub_req_date:String, doc_sub_req_time:String) {
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading...")
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id":"\(userid!.covertToBase64())",
                "document_name":"\(document_name.covertToBase64())",
                "docid":"\(doc_id.covertToBase64())",
                "type":"\(type.covertToBase64())",
                "address_type":"\(address_type.covertToBase64())",
                "other_address_type":"",
                "address_expdate":"",
                "doc_sub_req":"\(doc_sub_req.covertToBase64())",
                "doc_sub_req_date":"\(doc_sub_req_date.covertToBase64())",
                "doc_sub_req_time":"\(doc_sub_req_time.covertToBase64())",
                "enc_resp":"3"
            ]
            print(parameters)
            let url = "\(Constants.BASE_URL)\(Constants.API.addDoc)"
            Alamofire.request("\(url)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    
                    
                    
                    switch type {
                        
                    case "aof":
                        if enc == "\"true\""{
                            //self.textFieldAof.text = ""
                            //call aof bse upload image
                            self.AOFImageUpload(userid: userid!)
                        } else {
                            self.presentWindow.hideToastActivity()
                            self.presentWindow.makeToast(message: "Something Went Wrong!!")
                        }
                    case "mandate":
                        if enc == "\"true\""{
                            //self.presentWindow.hideToastActivity()
                            self.tfUploadAOF.text = document_name
                            self.addMandateForForSelectedBank(document_name: document_name,scan_mandate_flag:"1")
                        } else {
                            self.presentWindow.hideToastActivity()
                            self.presentWindow.makeToast(message: "Something Went Wrong!!")
                        }
                    default:
                        break
                    }
                    
            }
        } else {
            self.presentWindow.hideToastActivity()
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
                    let bse_err_msg = data?["bse_err_msg"]
                    self.presentWindow.hideToastActivity()
                    let alert = UIAlertController(title: "Alert", message: "\(bse_err_msg ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                        print("Ok button clicked")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.presentWindow.hideToastActivity()
                    self.presentWindow.makeToast(message: "AOF Uploaded Successfully")
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    
    func addMandateForForSelectedBank(document_name: String,scan_mandate_flag: String) {
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading...")
         let url = "\(Constants.BASE_URL)\(Constants.API.addmandateform)"
        if Connectivity.isConnectedToInternet {
            
            let parameters = [
                "id": "\(userid!.covertToBase64())",
                "document_name": "\(document_name.covertToBase64())",
                "bankid": self.selectedBank?.bank_id?.covertToBase64() ?? "",
                "bank_txn_limit": self.selectedBank?.bank_txn_limit?.covertToBase64() ?? "",
                "bank_current_txn_limit": self.lblMandateAmount2.text!.components(separatedBy: " ").last ?? "",
                "enc_resp":"3"
                ] as [String : Any]
            
            Alamofire.request(url, method: .post, parameters: parameters , encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    _ = UserDefaults.standard.value(forKey: "Mobile") ?? ""
                    if enc == "\"true\""{
                        // call mandate api
                        self.updatemandatetype(userid: userid!, bank_id: self.selectedBank?.bank_id ?? "", mandate_type: "xsip", scan_mandate_flag: "1")
                    } else {
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getBankList() {
        var index = -1
        var count = 0
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
       // DispatchQueue.main.async {
            self.presentWindow.makeToastActivity(message: "Loading...")
        //}
        let url = "\(Constants.BASE_URL)\(Constants.API.getBank)\(userid!.covertToBase64())/fintoo/3"
        print(url)
        if Connectivity.isConnectedToInternet {
            
            userBanklist.removeAll()
            userBanklist.append(getBankObj.getUserBank(bank_acc_no: "", bank_branch: "", bank_cancel_cheque: "", bank_city: "", bank_country: "", bank_current_txn_limit: "", bank_id: "", bank_ifsc_code: "", bank_joint_holder: "", bank_mandate: "", bank_mandate_document: "", bank_name: "Select Bank", bank_state: "", bank_txn_limit: "", bank_type: "Select", banks_bd_code: "", micr_code: "", single_survivor: "", txn_exst: "", country_name: "Select Country", state_name: "Select State", city_name: "Select City", bank_razorpay_code: "0", bank_razorpay_code_user: "0", min_acc_number: "0",max_acc_number: "0", isip_allow: "0",bank_mandate_type: "XSIP", max_trxn_limit: ""))
            
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
                    
                    if data.isEmpty != true {
                        for type in data{
                            count = count + 1
                            if let bank_id = type.value(forKey: "bank_id") as? String,
                                let bank_name = type.value(forKey: "bank_name") as? String,
                                let bank_acc_no = type.value(forKey: "bank_acc_no") as? String,
                                let bank_branch = type.value(forKey: "bank_branch") as? String,
                                let bank_cancel_cheque = type.value(forKey: "bank_cancel_cheque") as? String,
                                let bank_city = type.value(forKey: "bank_city") as? String,
                                let bank_country = type.value(forKey: "bank_country") as? String,
                                let bank_current_txn_limit = type.value(forKey: "bank_current_txn_limit") as? String,
                                let bank_ifsc_code = type.value(forKey: "bank_ifsc_code") as? String,
                                let bank_joint_holder = type.value(forKey: "bank_joint_holder") as? String,
                                let bank_mandate = type.value(forKey: "bank_mandate") as? String,
                                let bank_state = type.value(forKey: "bank_state") as? String,
                                let bank_txn_limit = type.value(forKey: "bank_txn_limit") as? String,
                                let bank_type = type.value(forKey: "bank_type") as? String,
                                let banks_bd_code = type.value(forKey: "banks_bd_code") as? String,
                                let micr_code = type.value(forKey: "micr_code") as? String,
                                let single_survivor = type.value(forKey: "single_survivor") as? String,
                                let txn_exst = type.value(forKey: "txn_exst") as? String,
                                let bank_mandate_document = type.value(forKey: "bank_mandate_document") as? String,
                                let country = type.value(forKey: "country_name") as? String,
                                let state = type.value(forKey: "state_name") as? String
                              {
                                let city = type.value(forKey: "city_name") as? String
                                let min_acc_number = type.value(forKey: "min_acc_number") as? String ?? "0"
                                let max_acc_number = type.value(forKey: "max_acc_number") as? String ?? "0"
                                let isip_allow = type.value(forKey: "isip_allow") as? String ?? "0"
                                let bank_mandate_type = type.value(forKey: "bank_mandate_type") as? String ?? "XSIP"
                                let max_trxn_limit = type.value(forKey: "max_trxn_limit") as? String ?? ""
                                
                                if self.transaction_bank_id == bank_id {
                                    self.tfBank.text = bank_name
                                    
                                    self.bank_id_dropdown = "1"
                                    index = count
                                    if self.tfBank.text != "Select Bank" && !self.shouldCheckForNext {
                                        DispatchQueue.main.async {
                                        self.presentWindow.hideToastActivity()
                                        }
                                        
                                        self.mandateTypeView.isHidden = false
                                        self.mandateTypeHeightConstraint.constant = 100
                                        self.mandateTypeTopConstraints.constant = 12
                                        self.adjustMainHeight()
                                    }
                                   
                                }
//                                if max_trxn_limit != "" && max_trxn_limit != "0" {
//                                    self.presentWindow.makeToast(message: "Selected bank have maximum Rs. \(max_trxn_limit) transaction limit per day. Please reduce the cart amount to proceed.")
//                                    self.max_trxn_limit =  true
//
//                                }
                                userBanklist.append(getBankObj.getUserBank(bank_acc_no: bank_acc_no, bank_branch: bank_branch, bank_cancel_cheque: bank_cancel_cheque, bank_city: bank_city, bank_country: bank_country, bank_current_txn_limit: bank_current_txn_limit, bank_id: bank_id, bank_ifsc_code: bank_ifsc_code, bank_joint_holder: bank_joint_holder, bank_mandate: bank_mandate, bank_mandate_document: bank_mandate_document, bank_name: bank_name, bank_state: bank_state, bank_txn_limit: bank_txn_limit, bank_type: bank_type, banks_bd_code: banks_bd_code, micr_code: micr_code, single_survivor: single_survivor, txn_exst: txn_exst, country_name:country ,state_name: state, city_name: city, bank_razorpay_code: "0", bank_razorpay_code_user: "0", min_acc_number: min_acc_number,max_acc_number: max_acc_number, isip_allow: isip_allow,bank_mandate_type: bank_mandate_type, max_trxn_limit: max_trxn_limit))
                                
                                
                            }
                        }
                    }
                    self.presentWindow.hideToastActivity()
                    self.dropdownForBank.anchorView = self.btnSelectBankDropDown
                    self.dropdownForBank.dataSource = userBanklist.map { $0.bank_name ?? ""}
                    self.dropdownForBank.selectionAction = { [unowned self] (index: Int, item: String) in
                        self.tfBank.text = userBanklist[index].bank_name
                       
                        if userBanklist[index].bank_mandate_type == "ISIP"{
                            self.isipOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                            self.xsipOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                            
                            self.mandateTypeLabel.text = "ISIP : This is basically a SIP started online, by registering the fund house as a biller in your netbanking."
                        } else {
                            self.xsipOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                            self.isipOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                        }
                        if userBanklist[index].max_trxn_limit != "" && userBanklist[index].max_trxn_limit != "0" {
                            if self.totalCartValue > Int(userBanklist[index].max_trxn_limit!)!{
                                self.presentWindow.makeToast(message: "Selected bank have maximum Rs. \(userBanklist[index].max_trxn_limit ?? "") transaction limit per day. Please reduce the cart amount to proceed.")
                                 self.max_trxn_limit =  true
                            }
                            
                        }else{
                             self.max_trxn_limit =  false
                        }
                        if userBanklist[index].isip_allow == "1" && self.amc_code_flag != true {
                            self.isipOutlet.isHidden = false
                        } else {
                            self.isipOutlet.isHidden = true
                        }
                        
                        if index != 0 {
                            
                            if !self.shouldCheckForNext {
                                //self.couriorView.isHidden = false
                                //self.courierTopConstraint.constant = 12
                               // self.courierHeightConstraint.constant = 120
                                self.mandateTypeView.isHidden = false
                                self.mandateTypeHeightConstraint.constant = 100
                                self.mandateTypeTopConstraints.constant = 12
                                self.adjustMainHeight()
                            }
                            self.selectedBank = userBanklist[index]
                            
                            self.getMedmandateAmount(bankObj: userBanklist[index])
                        } else {
                            self.presentWindow.hideToastActivity()
                            if !self.shouldCheckForNext {
                                self.couriorView.isHidden = true
                                self.courierTopConstraint.constant = 0
                                self.courierHeightConstraint.constant = 0
                            }
                            
                            self.lblYourMandateAmountlabel.text = "Your available mandate amount : Rs 0"
                            
                            self.downloadMandateFormMainView.isHidden = true
                            self.uploadMandateMainView.isHidden = true
                            self.lblMandateAmount2.isHidden = true
                            self.lblYourMandateAmountlabel.isHidden = true
                            self.newMandateAmmountView.isHidden = true
                            self.otherOptionForBankView.isHidden = true
                            self.bankViewHeightConstraint.constant = 80
                            
                            self.downloadMandateFormViewHeightConstraint.constant = 0
                            self.uploadMandateMainViewHeightConstraint.constant = 0
                            
                            self.downloadMandateTopConstraint.constant = 0
                            self.uploadMandateTopConstraint.constant = 0
                            
                            self.adjustMainHeight()
                        }
                    }
                    if self.bank_id_dropdown != "1" {
                        self.dropdownForBank.show()
                    } else {
                        if index > 0 {
                            if userBanklist[index].bank_mandate_type == "ISIP"{
                                self.isipOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                                self.xsipOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                                self.mandateTypeLabel.text = "ISIP : This is basically a SIP started online, by registering the fund house as a biller in your netbanking."
                            } else {
                                self.xsipOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                                self.isipOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                            }
                            
                            if userBanklist[index].isip_allow == "1" && self.amc_code_flag != true {
                                self.isipOutlet.isHidden = false
                            } else {
                                self.isipOutlet.isHidden = true
                            }
                            if !self.shouldCheckForNext {
                                //self.couriorView.isHidden = false
//                                self.courierTopConstraint.constant = 12
//                                self.courierHeightConstraint.constant = 120
                            }
                            self.selectedBank = userBanklist[index]
                            self.presentWindow.hideToastActivity()
                            self.getMedmandateAmount(bankObj: userBanklist[index])
                        }
                    }
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getMedmandateAmount(bankObj: getBankObj) {
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        
        let url = "\(Constants.BASE_URL)\(Constants.API.getUsedMandateAmount)"
        let bank_mandate_doc =  bankObj.bank_mandate_document ?? ""
        let bank_txn_limit = bankObj.bank_txn_limit
        print(bank_mandate_doc)
        var mandate_doc = false
        if bank_mandate_doc == ""{
            mandate_doc =  false
        } else{
            mandate_doc =  true
        }
        if Connectivity.isConnectedToInternet {
            let parameters = [
                "bank_id": bankObj.bank_id ?? "0",
                "id": userid!,
                "available_mandate":"\(bank_txn_limit!)",
                "cart_sip_total":self.cartSIPTotal,
                "mandate_doc": mandate_doc,
                "enc_resp":"3"
                ] as [String : Any]
            print(parameters)
            Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
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
                    
                    if let abc = data as? [[String:Any]]{
                        let remainingMandate = abc[0]["remainingMandate"] as? Int ?? 0
                        let finalMandate = abc[0]["finalMandate"] as? Int ?? 0
                        print(remainingMandate)
                        print(finalMandate)
                        if self.shouldCheckForNext && self.viewUploadAOF.isHidden {
                            self.lblYourMandateAmountlabel.isHidden = true
                            self.lblMandateAmount2.isHidden = true
                            self.couriorView.isHidden = true
                            self.courierHeightConstraint.constant = 0
                            self.courierTopConstraint.constant = 0
                            self.adjustMainHeight()
                        } else {
                            if !self.shouldCheckForNext {
                            if let bank_txn_limit = bankObj.bank_txn_limit?.numberValue {
                                let remainingAmmount = remainingMandate
                                if !mandate_doc {
                                    self.lblYourMandateAmountlabel.text = "Your2 available mandate amount : Rs \(bank_txn_limit)"
                                } else{
                                    self.lblYourMandateAmountlabel.text = "Your3 available mandate amount : Rs \(remainingAmmount)"
                                }
                                
                                if self.cartSIPTotal <= remainingAmmount {
                                    
                                    self.lblMandateAmount2.isHidden = true
                                    if self.viewUploadAOF.isHidden {
                                        self.couriorView.isHidden = true
                                        self.courierHeightConstraint.constant = 0
                                        self.courierTopConstraint.constant = 0
                                    }
                                    self.mandateAmmountForDonloadMandateForm = 0
                                    self.downloadMandateFormMainView.isHidden = true
                                    self.uploadMandateMainView.isHidden = true
                                    self.lblMandateAmount2.isHidden = false
                                    self.downloadMandateFormViewHeightConstraint.constant = 0
                                    self.uploadMandateMainViewHeightConstraint.constant = 0
                                    
                                    self.downloadMandateTopConstraint.constant = 0
                                    self.uploadMandateTopConstraint.constant = 0
                                    
                                    self.newMandateAmmountView.isHidden = true
                                    self.otherOptionForBankView.isHidden = true
                                    
                                    //self.viewUploadMandateForm.isHidden = false
                                    self.bankViewHeightConstraint.constant = 80
                                    
                                    
                                } else if self.isipOutlet.currentImage != #imageLiteral(resourceName: "uncheck"){
                                    //added for isip selection
                                    let ammount = finalMandate
                                    print(ammount,"amount1")
                                    self.lblMandateAmount2.text = "Your mandate amount will be: Rs \(self.cartSIPTotal)"
                                    self.isipNoteLabel.isHidden = false
                                    self.mandateTypeHeightConstraint.constant = 135
                                    self.downloadMandateFormMainView.isHidden = true
                                    self.uploadMandateMainView.isHidden = true
                                    self.couriorView.isHidden = true
                                    self.lblMandateAmount2.isHidden = true
                                    self.downloadMandateFormViewHeightConstraint.constant = 0
                                    self.uploadMandateMainViewHeightConstraint.constant = 0
                                    self.courierHeightConstraint.constant = 0
                                    
                                    self.downloadMandateTopConstraint.constant = 0
                                    self.uploadMandateTopConstraint.constant = 0
                                    self.courierTopConstraint.constant = 0
                                    //self.otherOptionForBankView.isHidden = false
                                    //self.bankViewHeightConstraint.constant = 244
                                    //self.lblMandateAmount2.isHidden = false
                                    self.adjustMainHeight()
                                } else {
                                    
                                   // let ammount = self.cartSIPTotal - remainingAmmount
                                     let ammount = finalMandate
                                    print(ammount,"amount")
                                    self.lblMandateAmount2.text = "Your mandate amount will be: Rs \(self.cartSIPTotal)"
                                    self.mandateAmmountForDonloadMandateForm = Int(ammount) ?? 0
                                    self.lblMandateAmount2.isHidden = false
                                    self.viewUploadMandateForm.isHidden = true
                                    self.btnNoForHigherMandate.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                                    self.btnYesForHigherMandate.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                                   // self.otherOptionForBankView.isHidden = false
                                   self.bankViewHeightConstraint.constant = 80
                                   // self.downloadMandateFormViewHeightConstraint.constant = 170
                                   // self.uploadMandateMainViewHeightConstraint.constant = 150
                                    
                                    //self.downloadMandateFormMainView.isHidden = false
                                    //self.uploadMandateMainView.isHidden = false
                                   // self.downloadMandateTopConstraint.constant = 12
                                   // self.uploadMandateTopConstraint.constant = 12
                                }
                            }
                            
                            
                            } else {
                                self.lblYourMandateAmountlabel.isHidden = true
                                print("lblYourMandateAmountlabel")
                            }
                    }
                        self.adjustMainHeight()
                    }
            }
        } else {
            presentWindow.hideToastActivity()
            self.presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getDocDetailForAOF() {
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.userDoc)\(userid!.covertToBase64())/fintoo/3"
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
                if let data = data as? [[String: AnyObject]] {
                    for object in data {
                        let doc_sub_req_time = object["doc_sub_req_time"] as? String ?? ""
                        let doc_user_id = object["doc_user_id"] as? String ?? ""
                        let doc_id = object["doc_id"] as? String ?? ""
                        let doc_address_proof_type = object["doc_address_proof_type"] as? String ?? ""
                        let doc_name = object["doc_name"] as? String ?? ""
                        let doc_address_proof_expdate = object["doc_address_proof_expdate"] as? String ?? ""
                        let doc_sub_req_date = object["doc_sub_req_date"] as? String ?? ""
                        let dt_identifier = object["dt_identifier"] as? String ?? ""
                        let doc_other_address_type = object["doc_other_address_type"] as? String ?? ""
                        let doc_sub_req = object["doc_sub_req"] as? String ?? ""
                        let doc_type = object["doc_type"] as? String ?? ""
                        
                        _ = DocObject(doc_sub_req_time: doc_sub_req_time, doc_user_id: doc_user_id, doc_id: doc_id, doc_address_proof_type: doc_address_proof_type, doc_name: doc_name, doc_address_proof_expdate: doc_address_proof_expdate, doc_sub_req_date: doc_sub_req_date, dt_identifier: dt_identifier, doc_other_address_type: doc_other_address_type, doc_sub_req: doc_sub_req, doc_type: doc_type)
                        
                    }
                }
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getDocumentListForbank() {
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        guard let bankObj = self.selectedBank else {
            return
        }
        var url = ""
        let memberid = UserDefaults.standard.value(forKey: "memberid") as? String ?? "0"
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        if memberid != "0" && memberid != parent_user_id{
            userid! = flag
            let phone = UserObjects[0].mobile
            let email = UserObjects[0].email
            print(email)
            let email_mobile = phone + "|" + email
            url = "\(Constants.API.getBankDoc)\(bankObj.bank_mandate_document ?? "")&path=1&userId=\(userid!.convertToBase64())&action=globalfiledownload&aData=\(email_mobile.convertToBase64())&member=1"
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
            let phone = UserObjects[0].mobile
            let email = UserObjects[0].email
            print(email)
            let email_mobile = phone + "|" + email
            url = "\(Constants.API.getBankDoc)\(bankObj.bank_mandate_document ?? "")&path=1&userId=\(userid!.convertToBase64())&action=globalfiledownload&aData=\(email_mobile.convertToBase64())"
        }
        if Connectivity.isConnectedToInternet {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "DocumentWebViewController") as! DocumentWebViewController
            destVC.url = url
            self.navigationController?.pushViewController(destVC, animated: true)
        } else {
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func getUserData(){
        UserObjects.removeAll()
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(covertToBase64(text: userid as? String ?? ""))/3"
        print(url)
         presentWindow.makeToastActivity(message: "Loading...")
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
               // self.presentWindow.hideToastActivity()
                if let data = data as? [[String: AnyObject]] {
                    for object in data {
                        let id = object["id"] as? String ?? ""
                        let pan = object["pan"] as? String ?? ""
                        let dob = object["dob"] as? String ?? ""
                        let mobile = object["mobile"] as? String ?? ""
                        let landline = object["landline"] as? String ?? ""
                        let name = object["name"] as? String ?? ""
                        let middle_name = object["middle_name"] as? String ?? ""
                        let last_name = object["last_name"] as? String ?? ""
                        let flat_no = object["flat_no"] as? String ?? ""
                        let building_name = object["building_name"] as? String ?? ""
                        let road_street = object["road_street"] as? String ?? ""
                        let address = object["address"] as? String ?? ""
                        let city = object["city"] as? String ?? ""
                        let state = object["state"] as? String ?? ""
                        let country = object["country"] as? String ?? ""
                        let pincode  = object["pincode"] as? String ?? ""
                        let email = object["email"] as? String ?? ""
                        let bse_aof_status =  object["bse_aof_status"] as? String ?? ""
                        self.getCountries(code:country, state: state,city: city)
                        let UserObjs = UserObj(id: id, pan: pan, dob: dob, mobile: mobile, landline: landline, name: name, middle_name: middle_name, last_name: last_name, flat_no: flat_no, building_name: building_name, road_street: road_street, address: address, city: city, state: state, country: country, pincode: pincode, email: email)
                        let full_name = "\(name) \(middle_name) \(last_name)"
                        
                        self.UserObjects.append(UserObjs)
                        
                        self.activeMember.text = "\(full_name) (\(pan))"
                        
                    }
                }
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
        func  getCountries(code:String,state:String,city:String){
            //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
            
            let url = "\(Constants.BASE_URL)\(Constants.API.country)"
           
           // presentWindow.makeToastActivity(message: "Loading...")
            if Connectivity.isConnectedToInternet{
               // self.presentWindow.hideToastActivity()
                Alamofire.request(url).responseJSON { response in
                    //print(response.result.value)
                    if let data = response.result.value as? [AnyObject]{
                        for type in data{
                            if let countryName = type.value(forKey: "country_name") as? String,
                                let countryId = type.value(forKey: "country_id") as? String{
                                self.presentWindow.hideToastActivity()
                                if code == countryId{
                                    self.country_name = countryName
                                }
                              }
                        }
                        self.getState(id: code,state:state, city: city)
                   }
               }
            } else{
                self.presentWindow.hideToastActivity()
                self.presentWindow?.makeToast(message: "No Internet Connection")
            }
        }
        func  getState(id:String,state:String,city:String){
            //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
            
            let url = "\(Constants.BASE_URL)\(Constants.API.state)\(id)"
            
            if Connectivity.isConnectedToInternet{
                
                Alamofire.request(url).responseJSON { response in
                    //print(response.result.value)
                    if let data = response.result.value as? [AnyObject]{
                        for type in data{
                            if let stateName = type.value(forKey: "state_name") as? String,
                                let stateId = type.value(forKey: "state_id") as? String{
                                self.presentWindow.hideToastActivity()
                                if state == stateId {
                                    self.state_name = stateName
                                }
                              }
                        }
                        self.getCity1(id: state, city: city)
                     }
                 }
             } else{
               presentWindow?.makeToast(message: "No Internet Connection")
            }
        }
        func  getCity1(id:String,city:String){
           let url = "\(Constants.BASE_URL)\(Constants.API.city)\(id)"
            if Connectivity.isConnectedToInternet{
                
                Alamofire.request(url).responseJSON { response in
                  //  self.presentWindow.hideToastActivity()
                    if let data = response.result.value as? [AnyObject]{
                        
                        for type in data{
                            if let cityName = type.value(forKey: "city_name") as? String,
                                let cityId = type.value(forKey: "city_id") as? String{
                                if city == cityId{
                                    self.city_name = cityName
                                }
                             }
                        }
                        
                    }
                 }
              } else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }
        
        
    func getMemberList(sender: UIButton){
        
        get_member_list.removeAll()
        let userid = UserDefaults.standard.value(forKey: "userid")
        let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
        let url1 = "\(Constants.BASE_URL)\(Constants.API.getmemberswithparent)/\(p_userid!)"
        let url = "\(Constants.BASE_URL)\(Constants.API.Member_List)\(userid!)"
        print(url)
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url1).responseJSON { response in
                print(response.result.value)
                let data = response.result.value
                if data != nil{
                    if let response = data as? [[String:AnyObject]]{
                        // print(dataArray)
                        var pan1 = ""
                        self.presentWindow.hideToastActivity()
                        for memberIdData in response {
                            let id = memberIdData["id"] as? String ?? ""
                            let name = memberIdData["name"] as? String ?? ""
                            let middle_name = memberIdData["middle_name"] as? String ?? ""
                            let last_name = memberIdData["last_name"] as? String ?? ""
                            let pan = memberIdData["pan"] as? String ?? ""
                            let member_display_flag = memberIdData["member_display_flag"] as? String ?? ""
                            pan1 = pan
                            let dob = memberIdData["dob"] as? String ?? ""
                            let full_name = "\(name) \(middle_name) \(last_name)"
                            
                            self.get_member_list.append(getMemberObj(id: id, name: full_name, pan: "\(pan)", dob: dob, member_display_flag: member_display_flag ))
                        }
                        self.dropDownMember.anchorView = sender
                        self.dropDownMember.dataSource = self.get_member_list.map { $0.name ?? ""}
                        self.dropDownMember.selectionAction = { [unowned self] (index: Int, item: String) in
                            //self.activeMember.text = self.get_member_list[index].name
                            self.getrandomstring(userid: self.get_member_list[index].id ?? "")
                            self.activeMember.text = "\(self.get_member_list[index].name!) (\(pan1))"
                            flag = self.get_member_list[index].id!
                            let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
                            if self.get_member_list[index].id! == String(describing: p_userid!) {
                                UserDefaults.standard.setValue("0", forKey: "memberid")
                            } else {
                                UserDefaults.standard.setValue(self.get_member_list[index].id!, forKey: "memberid")
                            }
                            UserDefaults.standard.setValue(self.get_member_list[index].id, forKey: "userid")
                            UserDefaults.standard.setValue(self.get_member_list[index].pan, forKey: "pan")
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmTransactionViewController") as! ConfirmTransactionViewController
                            controller.cartObjects = self.cartObjects
                            controller.totalCartValue = self.totalCartValue
                            self.navigationController?.pushViewController(controller, animated: false)
                        }
                        
                        if self.id != "0"{
                            self.dropDownMember.show()
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
    func getrandomstring(userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.getrandomstring)"
        
        print(url)
        
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    for type in data{
                        let randomstring = type.value(forKey: "randomstring") as? String
                        print(randomstring)
                        UserDefaults.standard.setValue(randomstring, forKey: "sessionId")
                        self.bseRegisteredFlag(userid: userid)
                    }
                } else{
                    print("Random string not generated")
                }
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }

}
//#MARK: @IBActions
extension ConfirmTransactionViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UINavigationBar.appearance().tintColor = UIColor.black
        return self
    }
    
}

//MARK: UIDocumentPickerDelegate
extension ConfirmTransactionViewController: UIDocumentPickerDelegate{
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        let file = "\(url)"
        let fileNameWithoutExtension = file.fileName()
        let fileExtension = file.fileExtension()
        if fileExtension == "jpg" || fileExtension == "JPG" || fileExtension == "jpeg" || fileExtension == "JPEG"  {
            
            do {
                let data = try Data(contentsOf: url)
//                let image = UIImage(data:data,scale:1.0)
//                let imageData = UIImageJPEGRepresentation(image!, 1)
                let jpegSize: Int = data.count 
                let size  = Double(jpegSize) / 1024.0
                let size1 = Double(size) / 1024.0
                print("size of jpeg image in KB: %f ", size1)
                if Int(size1) > 2 {
                    presentWindow.makeToast(message: "File is to big! Max allowed file size is 2 MB")
                } else {
                    let base64str = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))

                    if self.isMandateTappedForUpload {
                        self.tfUploadAOF.text = "\(fileNameWithoutExtension).\(fileExtension)"
                    } else {
                        self.textFieldAof.text = "\(fileNameWithoutExtension).\(fileExtension)"
                    }
                    self.uploadDocs(doc_value: base64str, doc_ext: fileExtension)
                }
               
                
            } catch{
                print(error)
            }
        }
        else{
            self.textFieldAof.text = ""
            presentWindow.makeToast(message: "Invalid file type (Allowed file types are jpg, jpeg)")
            Mixpanel.mainInstance().track(event: "Additional Details : Invalid file type (Allowed file types are jpg, jpeg)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.textFieldAof.text = ""
    }
}

//#MARK: @IBActions
extension ConfirmTransactionViewController {
    
    @IBAction func isip(_ sender: UIButton) {
       
        mandateTypeLabel.text = "ISIP : This is basically a SIP started online, by registering the fund house as a biller in your netbanking."
        self.xsipOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        if sender.currentImage == #imageLiteral(resourceName: "uncheck") {
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }
        
        if sender.currentImage == #imageLiteral(resourceName: "check") {
            print("isip selected")
            self.lblMandateAmount2.isHidden = true
            self.lblYourMandateAmountlabel.isHidden = true
        }
        
        if tfBank.text != "Select Bank"  {
            mandateTypeHeightConstraint.constant = 135
            isipNoteLabel.isHidden = false
            
            self.downloadMandateFormMainView.isHidden = true
            self.uploadMandateMainView.isHidden = true
            self.couriorView.isHidden = true
            self.downloadMandateFormViewHeightConstraint.constant = 0
            self.uploadMandateMainViewHeightConstraint.constant = 0
            self.courierHeightConstraint.constant = 0
            
            self.downloadMandateTopConstraint.constant = 0
            self.uploadMandateTopConstraint.constant = 0
            self.courierTopConstraint.constant = 0
            
            adjustMainHeight()
        }
    }
    @IBAction func xsip(_ sender: UIButton) {
       
        isipNoteLabel.isHidden = true
        mandateTypeHeightConstraint.constant = 100
        mandateTypeLabel.text = "XSIP : This is basically setting up investments in a mutual fund scheme at a fixed frequency on a fixed date with a fixed amount for a fixed period."
        self.isipOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        if sender.currentImage == #imageLiteral(resourceName: "uncheck") {
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
        }
       
        if sender.currentImage == #imageLiteral(resourceName: "check") {
            print("xsip selected")
            self.lblMandateAmount2.isHidden = false
            self.lblYourMandateAmountlabel.isHidden = true
        }
        if tfBank.text != "Select Bank" && viewUploadMandateForm.isHidden == true{
            mandateTypeHeightConstraint.constant = 100
            //self.downloadMandateFormMainView.isHidden = false
            //self.uploadMandateMainView.isHidden = false
            //self.couriorView.isHidden = false
//            self.courierHeightConstraint.constant = 120
//            self.downloadMandateFormViewHeightConstraint.constant = 170
//            self.uploadMandateMainViewHeightConstraint.constant = 150
            
//            self.downloadMandateTopConstraint.constant = 12
//            self.uploadMandateTopConstraint.constant = 12
//            self.courierTopConstraint.constant = 12
            self.termsViewTopConstraint.constant = 12
            if btnCourier.currentImage == #imageLiteral(resourceName: "check") {
                self.courierAddressView.isHidden = false
               //self.courierHeightConstraint.constant = 210
            } else if btnPickup.currentImage == #imageLiteral(resourceName: "check")  {
                self.dateAndTimingView.isHidden = false
              //  self.courierHeightConstraint.constant = 200
            }
            
        }
        adjustMainHeight()
    }
    
    @IBAction func btnCourierTapped(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Additional Details : Courier button clicked")
        self.btnPickup.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        self.calanderView.isHidden = true
        self.dateAndTimingView.isHidden = true
       // self.courierHeightConstraint.constant = 120
        self.adjustMainHeight()
        
        if sender.currentImage == #imageLiteral(resourceName: "uncheck") {
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            self.courierAddressView.isHidden = false
           // self.courierHeightConstraint.constant = 210
            self.adjustMainHeight()
        } else {
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            self.courierAddressView.isHidden = true
            //self.courierHeightConstraint.constant = 120
            self.adjustMainHeight()
        }
    }
    
    @IBAction func btnPickUpTapped(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Additional Details : Pickup button clicked")
        self.courierAddressView.isHidden = true
      //  self.courierHeightConstraint.constant = 120
        self.btnCourier.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        self.adjustMainHeight()
        pickup_bool = true
        if sender.currentImage == #imageLiteral(resourceName: "uncheck") {
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            self.dateAndTimingView.isHidden = false
         //   self.courierHeightConstraint.constant = 200
            self.adjustMainHeight()
        } else {
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            self.calanderView.isHidden = true
            self.dateAndTimingView.isHidden = true
            //self.courierHeightConstraint.constant = 120
            self.adjustMainHeight()
        }
    }
    
    @IBAction func btnDropDownForDateTapped(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Additional Details : Date Dropdown button clicked")
        if self.calanderView.isHidden {
            self.calanderView.isHidden = false
            self.dateAndTimingView.isHidden = false
            //self.courierHeightConstraint.constant = 500
            self.adjustMainHeight()
        } else {
            self.calanderView.isHidden = true
            self.dateAndTimingView.isHidden = false
           // self.courierHeightConstraint.constant = 200
            self.adjustMainHeight()
        }
    }
    
    @IBAction func btnDropDownForTimingTapped(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Additional Details : Timing Dropdown Button Clicked")
        getTimeSlot(sender: sender)
    }
    
    @IBAction func btnDownloadAOFTapped(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Additional Details : Download Aof Button Clicked")
        getAOF()
    }
    
    @IBAction func btnUploadTapped(_ sender: UIButton) {
        //Mixpanel.mainInstance().track(event: "Additional Details : Download Aof Button Clicked")
        if UserObjects[0].mobile != "" && UserObjects[0].email != ""  {
            self.isMandateTappedForUpload = false
            pickDoc()
        } else{
            presentWindow.hideToastActivity()
            Mixpanel.mainInstance().track(event: "Additional Details : Please First Complete Personal Details!!")
            presentWindow.makeToast(message: "Please First Complete Personal Details!!")
        }
        
    }
    
    @IBAction func btnSelectDropDownTapped(_ sender: UIButton) {
        
        if userBanklist.count > 1 && id != "1" {
            self.dropdownForBank.anchorView = self.btnSelectBankDropDown
            self.dropdownForBank.dataSource = userBanklist.map { $0.bank_name ?? ""}
            self.dropdownForBank.selectionAction = { [unowned self] (index: Int, item: String) in
                self.tfBank.text = userBanklist[index].bank_name
                if userBanklist[index].max_trxn_limit != "" && userBanklist[index].max_trxn_limit != "0" {
                    if self.totalCartValue > Int(userBanklist[index].max_trxn_limit!)!{
                    self.presentWindow.makeToast(message: "Selected bank have maximum Rs. \(userBanklist[index].max_trxn_limit ?? "") transaction limit per day. Please reduce the cart amount to proceed.")
                     self.max_trxn_limit =  true
                    }
                }else {
                     self.max_trxn_limit =  false
                }
                if userBanklist[index].bank_mandate_type == "ISIP"{
                    self.isipOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                    self.xsipOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                    self.mandateTypeLabel.text = "ISIP : This is basically a SIP started online, by registering the fund house as a biller in your netbanking."
                } else {
                    self.xsipOutlet.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                    self.isipOutlet.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                }
                if userBanklist[index].isip_allow == "1"  && self.amc_code_flag != true {
                    self.isipOutlet.isHidden = false
                } else {
                    self.isipOutlet.isHidden = true
                }
                
                if index == 0 {
                    self.mandateTypeView.isHidden = true
                    self.mandateTypeHeightConstraint.constant = 0
                    self.mandateTypeTopConstraints.constant = 0

                    if !self.shouldCheckForNext {
                        self.couriorView.isHidden = true
                        self.courierTopConstraint.constant = 0
                        self.courierHeightConstraint.constant = 0
                    }
                    
                    self.lblYourMandateAmountlabel.text = "Your available mandate amount : Rs 0"
                    
                    self.downloadMandateFormMainView.isHidden = true
                    self.uploadMandateMainView.isHidden = true
                    self.lblMandateAmount2.isHidden = true
                    self.downloadMandateFormViewHeightConstraint.constant = 0
                    self.uploadMandateMainViewHeightConstraint.constant = 0
                    
                    self.downloadMandateTopConstraint.constant = 0
                    self.uploadMandateTopConstraint.constant = 0
                    
                    self.newMandateAmmountView.isHidden = true
                    self.otherOptionForBankView.isHidden = true
                    
                    self.bankViewHeightConstraint.constant = 80
                    self.isipNoteLabel.isHidden = true
                    //self.mandateTypeHeightConstraint.constant = 100
                    
                    self.adjustMainHeight()
                    
                } else {
                    
                    self.adjustMainHeight()
                    if self.isipOutlet.currentImage != #imageLiteral(resourceName: "check") {
                        if !self.shouldCheckForNext {
                            //self.couriorView.isHidden = false
                            //self.courierTopConstraint.constant = 12
//                            if self.btnCourier.currentImage == #imageLiteral(resourceName: "check") {
//                                self.courierHeightConstraint.constant = 210
//                            } else if self.btnPickup.currentImage == #imageLiteral(resourceName: "check") {
//                                self.courierHeightConstraint.constant = 200
//                            } else {
//                                self.courierHeightConstraint.constant = 120
//                            }
                        }
                        
                        self.selectedBank = userBanklist[index]
                        
                        if self.shouldCheckForNext && self.viewUploadAOF.isHidden {
                            
                            self.lblYourMandateAmountlabel.isHidden = true
                            self.lblMandateAmount2.isHidden = true
                            
                            self.couriorView.isHidden = true
                            self.courierHeightConstraint.constant = 0
                            self.courierTopConstraint.constant = 0
                            
                        } else {
                            
                            self.getMedmandateAmount(bankObj: userBanklist[index])
                            
                            //self.downloadMandateFormMainView.isHidden = false
                            //self.uploadMandateMainView.isHidden = false
                            
//                            self.downloadMandateFormViewHeightConstraint.constant = 170
//                            self.uploadMandateMainViewHeightConstraint.constant = 150
//
//                            self.downloadMandateTopConstraint.constant = 12
//                            self.uploadMandateTopConstraint.constant = 12
                            
                            //self.otherOptionForBankView.isHidden = false
                            self.newMandateAmmountView.isHidden = true
                            self.btnNoForHigherMandate.setImage(#imageLiteral(resourceName: "check"), for: .normal)
                            self.btnYesForHigherMandate.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
                            self.mandateTypeView.isHidden = false
                            self.mandateTypeHeightConstraint.constant = 100
                            self.mandateTypeTopConstraints.constant = 12
                            //self.bankViewHeightConstraint.constant = 244
                        }
                        self.adjustMainHeight()
                    } else {
                        //added for isip selection
                        if self.shouldCheckForNext {
                            
                        }else {
                            self.selectedBank = userBanklist[index]
                            self.getMedmandateAmount(bankObj: userBanklist[index])
                            self.isipNoteLabel.isHidden = false
                            self.mandateTypeView.isHidden = false
                            self.mandateTypeTopConstraints.constant = 12
                            self.mandateTypeHeightConstraint.constant = 135
                            self.downloadMandateFormMainView.isHidden = true
                            self.uploadMandateMainView.isHidden = true
                            self.couriorView.isHidden = true
                            self.downloadMandateFormViewHeightConstraint.constant = 0
                            self.uploadMandateMainViewHeightConstraint.constant = 0
                            self.courierHeightConstraint.constant = 0
                            
                            self.downloadMandateTopConstraint.constant = 0
                            self.uploadMandateTopConstraint.constant = 0
                            self.courierTopConstraint.constant = 0
                            
                            self.adjustMainHeight()
                        }
                    }
                }
            }
            self.dropdownForBank.show()
        } else {
            getBankList()
        }
    }
    
    @IBAction func btnYesForHigherMandateTapped(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Additional Details : Yes Button Clicked")
        self.btnNoForHigherMandate.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        if sender.currentImage == #imageLiteral(resourceName: "uncheck") {
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            self.newMandateAmmountView.isHidden = false
            self.bankViewHeightConstraint.constant = self.bankViewHeightConstraint.constant + 36
            self.adjustMainHeight()
        }
    }
    
    @IBAction func btnNoForHigherMandateTapped(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Additional Details : No Button Clicked")
        self.btnYesForHigherMandate.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        if sender.currentImage == #imageLiteral(resourceName: "uncheck") {
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            self.view.endEditing(true)
            self.newMandateAmmountView.isHidden = true
            self.bankViewHeightConstraint.constant = self.bankViewHeightConstraint.constant - 36
            self.adjustMainHeight()
        }
    }
    
    @IBAction func btnDownloadMandateFormTapped(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Additional Details : Download Mandate Button Clicked")
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        self.updatemandatetype1(userid: userid!, bank_id: self.selectedBank?.bank_id ?? "", mandate_type: "xsip", scan_mandate_flag: "0")
//        if btnYesForHigherMandate.currentImage == #imageLiteral(resourceName: "check") {
//
//            if tfNewMandateAmount.text == "" {
//                let mandateAmount = self.lblMandateAmount2.text!.components(separatedBy: " ").last
//
//                presentWindow?.makeToast(message: "Please enter higher amount than \(mandateAmount!)")
//            } else {
//                let amount = Int64(self.tfNewMandateAmount.text!)
//                if amount! % 500 == 0 {
//                    let mandateAmount = self.lblMandateAmount2.text!.components(separatedBy: " ").last
//                    if mandateAmount!.count > 0 {
//                        if Int(tfNewMandateAmount.text!)! > Int(mandateAmount!)! {
//                            var userid = UserDefaults.standard.value(forKey: "userid") as? String
//                            if flag != "0"{
//                                userid! = flag
//                            } else{
//                                userid = UserDefaults.standard.value(forKey: "userid") as? String
//                            }
//                            guard let bankObj = self.selectedBank else {return}
//                            let selectedBankID = bankObj.bank_id ?? ""
//                            let mandateAmmount = "\(self.tfNewMandateAmount.text!)"
//
//                            var cartIDArray = [String]()
//                            for cartObj in self.cartObjects {
//                                cartIDArray.append(cartObj.cart_id)
//                            }
//
//                            presentWindow.makeToastActivity(message: "Loading...")
//                            var url = ""
//                            print(UserObjects[0].mobile)
//                            if UserObjects[0].mobile != "" && UserObjects[0].email != "" {
//                                presentWindow.hideToastActivity()
//                                let memberid = UserDefaults.standard.value(forKey: "memberid") as? String ?? "0"
//                                if memberid != "0" {
//                                    userid! = flag
//                                    let phone = UserObjects[0].mobile
//                                    let email = UserObjects[0].email
//                                    print(email)
//                                    let email_mobile = phone + "|" + email
//                                    url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())&member=1"
//                                    print(url,"mandate")
//                                } else{
//                                    let phone = UserObjects[0].mobile
//                                    let email = UserObjects[0].email
//                                    let email_mobile = phone + "|" + email
//                                    userid = UserDefaults.standard.value(forKey: "userid") as? String
//                                    url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())"
//                                    print(url,"mandate")
//                                }
//                            } else{
//                                presentWindow.hideToastActivity()
//                                 presentWindow.makeToast(message: "Please First Complete Personal Details!!")
//                                Mixpanel.mainInstance().track(event: "Additional Details : Please First Complete Personal Details!!")
//                            }
//                            if Connectivity.isConnectedToInternet {
//
//                                let destination: DownloadRequest.DownloadFileDestination = { _,_ in
//                                    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                                    documentsURL.appendPathComponent("mandate-\(userid!)-\(selectedBankID)-unsigned.pdf")
//                                    return (documentsURL, [.removePreviousFile])
//                                }
//
//                                Alamofire.download(url, to: destination).responseData { response in
//                                    if let destinationUrl = response.destinationURL {
//                                        let destinationURLForFile = destinationUrl.absoluteURL
//                                        self.showFileWithPath(path: destinationURLForFile.path)
//                                    } else {
//                                        self.presentWindow.hideToastActivity()
//                                    }
//                                }
//
//                            } else {
//                                presentWindow.hideToastActivity()
//                                presentWindow?.makeToast(message: "No Internet Connection")
//                            }
//                        } else {
//                            presentWindow?.makeToast(message: "Please enter higher amount than \(mandateAmount!)")
//                            Mixpanel.mainInstance().track(event: "Additional Details : Please enter higher amount than \(mandateAmount!)")
//                        }
//                    }
//                } else {
//                    presentWindow?.makeToast(message: "The new mandate amount should be multiple of 500.")
//                    Mixpanel.mainInstance().track(event: "Additional Details : The new mandate amount should be multiple of 500.")
//                }
//            }
//        } else {
//            var userid = UserDefaults.standard.value(forKey: "userid") as? String
//            if flag != "0"{
//                userid! = flag
//            } else{
//                userid = UserDefaults.standard.value(forKey: "userid") as? String
//            }
//            guard let bankObj = self.selectedBank else {return}
//            let selectedBankID = bankObj.bank_id ?? ""
//            let mandateAmmount = "\(self.mandateAmmountForDonloadMandateForm)"
//
//            var cartIDArray = [String]()
//            for cartObj in self.cartObjects {
//                cartIDArray.append(cartObj.cart_id)
//            }
//
//            presentWindow.makeToastActivity(message: "Loading...")
//            print(UserObjects[0].mobile)
//            var url = ""
//            if UserObjects[0].mobile != "" && UserObjects[0].email != "" {
//               let memberid = UserDefaults.standard.value(forKey: "memberid") as! String
//                if memberid != "0" {
//                    userid! = flag
//                    let phone = UserObjects[0].mobile
//                    let email = UserObjects[0].email
//                    print(email)
//                    let email_mobile = phone + "|" + email
//                    url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())&member=1"
//                    print(url,"mandate")
//                     //presentWindow.hideToastActivity()
//                } else{
//                    let phone = UserObjects[0].mobile
//                    let email = UserObjects[0].email
//                    let email_mobile = phone + "|" + email
//                    userid = UserDefaults.standard.value(forKey: "userid") as? String
//                    url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())"
//                    print(url,"mandate")
//                     //presentWindow.hideToastActivity()
//                }
//            } else{
//                self.presentWindow.hideToastActivity()
//                presentWindow.makeToast(message: "Please First Complete Personal Details!!")
//                Mixpanel.mainInstance().track(event: "Additional Details : Please First Complete Personal Details!!")
//            }
//            if Connectivity.isConnectedToInternet {
//
//                let destination: DownloadRequest.DownloadFileDestination = { _,_ in
//                    var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                    documentsURL.appendPathComponent("mandate-\(userid!)-\(selectedBankID)-unsigned.pdf")
//                    return (documentsURL, [.removePreviousFile])
//                }
//
//                Alamofire.download(url, to: destination).responseData { response in
//                    if let destinationUrl = response.destinationURL {
//                        let destinationURLForFile = destinationUrl.absoluteURL
//                        self.showFileWithPath(path: destinationURLForFile.path)
//                    } else {
//                        self.presentWindow.hideToastActivity()
//                    }
//                }
//
//            } else {
//                presentWindow.hideToastActivity()
//                presentWindow?.makeToast(message: "No Internet Connection")
//            }
//        }
    }
    
    @IBAction func btnUploadMandateTapped(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Additional Details : Upload Mandate Button Clicked")
        if btnCourier.currentImage == #imageLiteral(resourceName: "check")  || btnPickup.currentImage == #imageLiteral(resourceName: "check") {
            if UserObjects[0].mobile != "" && UserObjects[0].email != "" {
                print(tfDate.text!.count,tfDate.text)
                print(tfTiming.text)
                if btnPickup.currentImage == #imageLiteral(resourceName: "check") && tfDate.text!.count == 0{
                    presentWindow.makeToast(message: "Please Select Date")
                    Mixpanel.mainInstance().track(event: "Additional Details : Please Select Date")
                 }else if btnPickup.currentImage == #imageLiteral(resourceName: "check") && tfTiming.text == "Pickup Time"{
                    presentWindow.makeToast(message: "Please Select Time")
                    Mixpanel.mainInstance().track(event: "Additional Details : Please Select Time")
                }else{
                    self.isMandateTappedForUpload = true
                    pickDoc()
                }
            } else {
                presentWindow.makeToast(message: "Please First Fill Personal Details!!")
                Mixpanel.mainInstance().track(event: "Additional Details : Please First Fill Personal Details!!")
            }
            
        } else {
            presentWindow?.makeToast(message: "Please select courier or pickup.")
            Mixpanel.mainInstance().track(event: "Additional Details : Please select courier or pickup.")
        }
        
    }
    
    @IBAction func btnViewDocumentFromAOF(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Additional Details : View Aof Button Clicked")
        getDocDetailForAOF()
    }
    
    @IBAction func btnViewDocumentFromBankViewTapped(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Additional Details : View Aof Button Clicked")
        getDocumentListForbank()
    }
    @objc func enableButton() {
        self.btnSaveAndProceed.isEnabled = true
    }
    @IBAction func btnSaveAndProceedTapped(_ sender: UIButton) {
        
        sender.isEnabled = false
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.enableButton), userInfo: nil, repeats: false)
        if self.max_trxn_limit ==  false {
        if sender.currentTitle == "SAVE DETAILS"  || sender.currentTitle == "FILL KYC DETAILS TO CONTINUE!"{
            
            if !isUserDetailUpdated {
//                let alert = UIAlertController(title: "Alert", message: "For further process, as per SEBI guidelines you need to fill in your account details.", preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Click here to proceed!", style: UIAlertActionStyle.default, handler: { alert in
//
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                    self.navigationController?.pushViewController(controller, animated: true)
            } else {
                if tfBank.text == "Select Bank"{
                    Mixpanel.mainInstance().track(event: "Additional Details : Please Select Bank")
                    self.presentWindow?.makeToast(message: "Please Select Bank")
                } else {
                    let alert = UIAlertController(title: "Alert", message: "We have your documents and we will get your KYC done. Once done, you will be intimated and then you can proceed with the purchase", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
                        Mixpanel.mainInstance().track(event: "Additional Details : Ok Button Clicked")
                    }))
                    self.btnSaveAndProceed.setTitle("SAVE DETAILS", for: .normal)
                    Mixpanel.mainInstance().track(event: "Additional Details : SAVE DETAILS Button Clicked")
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        } else {
            if tfBank.text == "Select Bank"{
                self.presentWindow?.makeToast(message: "Please Select Bank")
            } else if isTermsAccepted {
                
                if !self.couriorView.isHidden {
                    if btnPickup.currentImage == #imageLiteral(resourceName: "check") || btnCourier.currentImage == #imageLiteral(resourceName: "check") {
                        print(tfTiming.text)
                        if btnPickup.currentImage == #imageLiteral(resourceName: "check") && tfDate.text!.count == 0{
                            presentWindow.makeToast(message: "Please Select Date")
                            Mixpanel.mainInstance().track(event: "Additional Details : Please Select Date")
                            return
                        }else if btnPickup.currentImage == #imageLiteral(resourceName: "check") && tfTiming.text == "Pickup Time"{
                            presentWindow.makeToast(message: "Please Select Time")
                            Mixpanel.mainInstance().track(event: "Additional Details : Please Select Time")
                            return
                        }
                        if btnYesForHigherMandate.currentImage == #imageLiteral(resourceName: "check") {
                            if tfNewMandateAmount.text == "" {
                                let mandateAmount = self.lblMandateAmount2.text!.components(separatedBy: " ").last
                                presentWindow?.makeToast(message: "Please enter higher amount than \(mandateAmount!)")
                            } else {
                                let amount = Int(self.tfNewMandateAmount.text!)
                                if amount! % 500 == 0 {
                                    let mandateAmount = self.lblMandateAmount2.text!.components(separatedBy: " ").last
                                    if mandateAmount!.count > 0 {
                                        if Int(tfNewMandateAmount.text!)! > Int(mandateAmount!)! {
                                            for cartObj in cartObjects {
                                              self.addToTransaction(obj: cartObj)
                                            }
                                        } else {
                                            presentWindow?.makeToast(message: "Please enter higher amount than \(mandateAmount!)")
                                            Mixpanel.mainInstance().track(event: "Additional Details : Please enter higher amount than \(mandateAmount!)")
                                        }
                                    }
                                } else {
                                    presentWindow?.makeToast(message: "The new mandate amount should be multiple of 500.")
                                    Mixpanel.mainInstance().track(event: "Additional Details : The new mandate amount should be multiple of 500.")
                                }
                            }
                        } else if btnNoForHigherMandate.currentImage == #imageLiteral(resourceName: "check") {
                         
                            for cartObj in cartObjects {
                                self.addToTransaction(obj: cartObj)
                            }
                        }
                    } else {
                        presentWindow?.makeToast(message: "Please select courier or pickup.")
                        Mixpanel.mainInstance().track(event: "Additional Details : Please select courier or pickup.")
                    }
                } else {
                    if shouldCheckForNext {
                        for cartObj in cartObjects {
                            self.addToTransaction(obj: cartObj)
                        }
                        
                    } else  {
                        if btnYesForHigherMandate.currentImage == #imageLiteral(resourceName: "check") {
                            if tfNewMandateAmount.text == "" {
                                let mandateAmount = self.lblMandateAmount2.text!.components(separatedBy: " ").last
                                presentWindow?.makeToast(message: "Please enter higher amount than \(mandateAmount!)")
                                Mixpanel.mainInstance().track(event: "Additional Details : Please enter higher amount than \(mandateAmount!)")
                            } else {
                                let amount = Int(self.tfNewMandateAmount.text!)
                                if amount! % 5 == 0 {
                                    let mandateAmount = self.lblMandateAmount2.text!.components(separatedBy: " ").last
                                    if mandateAmount!.count > 0 {
                                        if Int(tfNewMandateAmount.text!)! > Int(mandateAmount!)! {
                                            for cartObj in cartObjects {
                                                self.addToTransaction(obj: cartObj)
                                            }
                                            
                                            
                                        } else {
                                            presentWindow?.makeToast(message: "Please enter higher amount than \(mandateAmount!) and should be multiple of 500")
                                            Mixpanel.mainInstance().track(event: "Additional Details : Please enter higher amount than \(mandateAmount!) and should be multiple of 500")
                                        }
                                    }
                                } else {
                                    presentWindow?.makeToast(message: "The new mandate amount should be multiple of 500.")
                                    Mixpanel.mainInstance().track(event: "Additional Details : The new mandate amount should be multiple of 500.")
                                }
                            }
                        }
                        else if viewUploadMandateForm.isHidden == false{
                            for cartObj in cartObjects {
                                self.addToTransaction(obj: cartObj)
                            }
                        } else {
                            // added else condition for isip for proceed
                            for cartObj in cartObjects {
                                self.addToTransaction(obj: cartObj)
                            }
                        }
                    }
                 }
                
            } else if textFieldAof.text?.isEmpty ?? false && !self.viewDownloadAOF.isHidden {
                presentWindow?.makeToast(message: "Please Upload AOF")
                Mixpanel.mainInstance().track(event: "Please Upload AOF")
            }else {
                presentWindow?.makeToast(message: "Please accept terms and conditions.")
                Mixpanel.mainInstance().track(event: "Please accept terms and conditions.")
            }
        }
        }
    }
    
    @IBAction func btnTermsTapped(_ sender: UIButton) {
    Mixpanel.mainInstance().track(event: "Additional Details : Terms and Condition Button Clicked")
    print("^^^^^^^^^^^^^^")
        if sender.currentImage == #imageLiteral(resourceName: "square") {
            self.isTermsAccepted = true
            sender.setImage(#imageLiteral(resourceName: "check-blue"), for: .normal)
        } else {
            self.isTermsAccepted = false
            sender.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        }
    }
    
    
}
