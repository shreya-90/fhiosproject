//
//  TransactionsViewController.swift
//  Fintoo
//
//  Created by Matchpoint  on 02/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import Mixpanel
protocol TransactionDelegate: class {
    func expandView(row: Int , btn : UIButton)
   
}
var all_flag = "1"
var transactionArr = [TransactionDetailObj]()
class TransactionsViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,TransactionDelegate {
    @IBOutlet weak var activeMember: UITextField!
    
    @IBOutlet weak var tblViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reportButtonViewHeight: NSLayoutConstraint!
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var subscribeAlertView: UIView!
    
    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var unsubscribeBtn: UIButton!
    
    @IBOutlet weak var reqReportBtn: UIButton!
    
    @IBOutlet weak var emReportBtn: UIButton!
    @IBOutlet weak var downloadBtn: UIButton!
    
    var frequencyMode : String!
    
    var bank_acc_no_from_bank_list = [String:[String:String]]()
    var bank_name_arr = [String:String]()
    var dropdownForSiFund = DropDown()
    var abc  = ""
    var UserObjects = [UserObj]()
    var bank_is_empty  = false
    var personal_is_empty = false
    // Drop Down
    var id = "0"
    var loading_flag = "0"
    let dropDownMember = DropDown()
    var get_member_list = [getMemberObj]()
    var bse_aof_status_code = ""
    var bse_reg_code = ""
    
    @IBAction func emailBtn(_ sender: UIButton) {
        print("emailbtn clicked")
        
        var userid = UserDefaults.standard.value(forKey: "userid")
        let pan = UserDefaults.standard.value(forKey: "pan") as? String
        let name = UserDefaults.standard.value(forKey: "name") as? String
        let email = UserDefaults.standard.value(forKey: "Email") as? String
        
        print(userid!)
        print(pan!)
        print(name!)
        print(email!)
        
       
        if flag != "0"{
            userid! = flag
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        
        let new_pan = pan?.replacingOccurrences(of: "'", with: "")
        print("new pan \(new_pan!)")
        let url = "\(Constants.BASE_URL)\(Constants.API.sendTxnReport)"
        let parameters = ["email":"\(email!)","memberpan":new_pan!,"userid": "\(userid!)","username":"\(name!)"]
        
        print(url)
        print(parameters)
        if Connectivity.isConnectedToInternet {
            self.presentWindow.makeToastActivity(message: "Sending..")
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    
                    print(response.result.value!)
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    //if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc1!)
                    //} else{
                    //    self.presentWindow.hideToastActivity()
                   // }
                    let data1 = dict
                    print("***\(data1)")
                     if let data = data1 as? [AnyObject] {
                        print("0")
                        self.presentWindow.hideToastActivity()
                        print(data.isEmpty)
                        if data.isEmpty != true {
                            print("1")
                            for res in data {
                            print("###\n\n\(res)")
                                if let error = res["error"] as? String{
                                    if error == "" {
                                        print("3 success")
                                        self.presentWindow.makeToastActivity(message: "Email sent successfully")
                                        let alert = UIAlertController(title: "Alert", message: "Email sent successfully", preferredStyle: UIAlertControllerStyle.alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                        self.present(alert, animated: true, completion: nil)

                                    }
                                   
                            }
                            else {
                                    print("2")
                                    self.presentWindow.makeToastActivity(message: "Error in sending email")
                        }
                        
                       
                    }
                  }
                
                }
                    
            }
            
        
        }
        
    }
    
    func removeFile(itemName:String, fileExtension: String) {
        let fileManager = FileManager.default
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        guard let dirPath = paths.first else {
            return
        }
        let filePath = "\(dirPath)/\(itemName).\(fileExtension)"
        do {
            try fileManager.removeItem(atPath: filePath)
            print("file removed successfully")
        } catch let error as NSError {
            print(error.debugDescription)
            print("error in file removal")
        }
        
    }
    
    func getTxnDocumentName(){
        self.subscribeAlertView.isHidden = true
        
        
        var userid = UserDefaults.standard.value(forKey: "userid")
        let pan = UserDefaults.standard.value(forKey: "pan") as? String
        let name = UserDefaults.standard.value(forKey: "name") as? String
        
        if flag != "0"{
            userid! = flag
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        
        let panid = UserDefaults.standard.value(forKey: "pan") as? String
        let new_pan = panid?.replacingOccurrences(of: "'", with: "")
        print("\(userid!) \(pan!) \(name!)")
        
        let url = "\(Constants.BASE_URL)\(Constants.API.generatePDFofTxn)"
       
        let parameters = ["pan":"\(new_pan!)","userid": (userid!),"username":(name!)]
        print(url)
        print(parameters)
        
        
        self.presentWindow.makeToastActivity(message: "Downloading..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters)
                .responseString{ response in
                    let docname = response.result.value?.replacingOccurrences(of: "\n" , with: "") ?? ""
                    print("docname recvd \(docname)")
                    //let newdoc = docname.replacingOccurrences(of: "\n" , with: "")
                    if docname != "" {
                        self.reportDocumentOpen(docname: docname)
                    }
                
                    
            }
        }
    }
    
    @IBAction func downloadBtn(_ sender: UIButton) {
        self.subscribeAlertView.isHidden = true
        self.getTxnDocumentName()
        Mixpanel.mainInstance().track(event: "Download report Button Clicked")
        
    }
    func reportDocumentOpen(docname:String){
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        var url = ""
        let memberid = UserDefaults.standard.value(forKey: "memberid") as! String
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        if memberid != "0" && memberid != parent_user_id {
            print("1")
            print(docname)
            userid = flag
            let phone = UserObjects[0].mobile
            let email = UserObjects[0].email
            let email_mobile = phone + "|" + email
            url = "\(Constants.API.getBankDoc)\(docname)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload&aData=\(email_mobile.convertToBase64())&member=1"
        }
        else{
            print("2")
            print(docname)
            userid = UserDefaults.standard.value(forKey: "userid") as! String
            if flag != "0"{
                userid = flag
                
            } else{
                userid = UserDefaults.standard.value(forKey: "userid") as! String
            }
            print(userid)
            let phone = UserObjects[0].mobile
            let email = UserObjects[0].email
            let email_mobile = phone + "|" + email
            url = "\(Constants.API.getBankDoc)\(docname)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload&aData=\(email_mobile.convertToBase64())"
            
        }
        print(url)
        self.presentWindow.makeToastActivity(message: "Downloading..")
        
        if Connectivity.isConnectedToInternet {
            
            //            let destination = DownloadRequest.suggestedDownloadDestination(for : .documentDirectory)
            let destination: DownloadRequest.DownloadFileDestination = { _,_ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent(docname)
                print("documentsURL \(documentsURL)")
                return (documentsURL, [.removePreviousFile])
                
            }
            
            
            //Alamofire.download(url, to: destination).responseData { response in
            //let url1 = "\(Constants.API.getBankDoc)\transactionpdf_1564033646.pdf&path=1&userId=116338&action=globalfiledownload"
            
            
            
            Alamofire.download(url, method: .get, to: destination).responseData { response in
                if let error = response.error {
                    print("error : \(error)")
                    print(response.debugDescription)
                }
                
                print(response)
                print(response.debugDescription)
                if let destinationUrl = response.destinationURL {
                    print("show file 1")
                    print(response)
                    
                    print(destinationUrl)
                    let destinationURLForFile = destinationUrl.absoluteURL
                    print(destinationURLForFile)
                    self.showFileWithPath(path : destinationURLForFile.path)
                } else {
                    self.presentWindow.hideToastActivity()
                }
            }
        }else {
            self.presentWindow.hideToastActivity()
            self.presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func showFileWithPath(path: String){
        print("in showFileWithPath")
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            print("file found")
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            presentWindow.hideToastActivity()
            viewer.presentPreview(animated: true)
        }
        else{
            print("file NOT found")
        }
    }
    
    @IBAction func requestReportBtnClicked(_ sender: UIButton) {
        self.subscribeAlertView.isHidden = false
    }
    func expandView(row: Int ,btn : UIButton) {
        transactionArr[row].is_exapanded = !transactionArr[row].is_exapanded
        let ValidForObj = transactionArr[row].valid_for
        
        print(ValidForObj)
        
        self.dropdownForSiFund.anchorView = btn
        self.dropdownForSiFund.dataSource = ValidForObj.compactMap({ $0})
        print(self.bank_is_empty,"bank flag")
        if !self.bank_is_empty && !personal_is_empty {
            self.dropdownForSiFund.selectionAction = { [unowned self] (index: Int, item: String) in
                let Index = IndexPath(row: row, section: 0)
                let cell = self.tableView.cellForRow(at: Index) as? transactionCell
                cell?.transacttf.text = ValidForObj[index]
                let selectAction = cell?.transacttf.text
                if cell?.transacttf.text == "Additional Purchase"{
                    // transacttf.text = "Additional Purchase"
                    Mixpanel.mainInstance().track(event: "Transaction Screen :- Additional Purchase Clicked")
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "AdditionalPurchaseViewController") as! AdditionalPurchaseViewController
                    destVC.transactionArrs = transactionArr[row].valid_for
                    destVC.selectAction = selectAction
                    destVC.SchemeName = transactionArr[row].scheme_name
                    destVC.Schemecode = transactionArr[row].schemecode
                    destVC.folio_no = transactionArr[row].folio_no
                    destVC.acc_no = transactionArr[row].account_no
                    destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
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
                else if cell?.transacttf.text == "Redeem"{
                   Mixpanel.mainInstance().track(event: "Transaction Screen :- Redeem Clicked")
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "ReedemViewController") as! ReedemViewController
                    destVC.transactionArrs = transactionArr[row].valid_for
                    destVC.selectAction = selectAction
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
                else if cell?.transacttf.text == "Switch"{
                    Mixpanel.mainInstance().track(event: "Transaction Screen :- Switch Clicked")
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "transactSwitchViewController") as! transactSwitchViewController
                    destVC.transactionArrs = transactionArr[row].valid_for
                    destVC.selectAction = selectAction
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
                    destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
                else if cell?.transacttf.text == "Stop SIP"{
                    Mixpanel.mainInstance().track(event: "Transaction Screen :- Stop SIP Clicked")
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSIPViewController") as! StopSIPViewController
                    destVC.transactionArrs = transactionArr[row].valid_for
                    destVC.selectAction = selectAction
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
                else if cell?.transacttf.text == "Stop SWP"{
                    Mixpanel.mainInstance().track(event: "Transaction Screen :- Stop SWP Clicked")
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSWPViewController") as! StopSWPViewController
                    destVC.transactionArrs = transactionArr[row].valid_for
                    destVC.selectAction = selectAction
                    destVC.SchemeName = transactionArr[row].scheme_name
                    destVC.Schemecode = transactionArr[row].schemecode
                    destVC.acc_no = transactionArr[row].account_no
                    
                    destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                    destVC.folio_no = transactionArr[row].folio_no
                    destVC.no_of_units = transactionArr[row].no_of_units!
                    destVC.curr_value = transactionArr[row].curr_value1
                    destVC.trxnnumber = transactionArr[row].trxnnumber
                    destVC.swpcid = transactionArr[row].swpcid
                    destVC.row = row
                    destVC.mininvest = transactionArr[row].mininvest
                    destVC.stptxnid = transactionArr[row].stptxnid
                    destVC.stpcid = transactionArr[row].stpcid
                    destVC.bse_aof_status_code = self.bse_aof_status_code
                    destVC.bse_reg_code = self.bse_reg_code
                    destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                    destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                    destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
                else if cell?.transacttf.text == "Stop STP"{
                    Mixpanel.mainInstance().track(event: "Transaction Screen :- Stop STP Clicked")
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSTPViewController") as! StopSTPViewController
                    destVC.transactionArrs = transactionArr[row].valid_for
                    destVC.selectAction = selectAction
                    destVC.SchemeName = transactionArr[row].scheme_name
                    destVC.Schemecode = transactionArr[row].schemecode
                    destVC.stptxnid = transactionArr[row].stptxnid
                    destVC.stpcid = transactionArr[row].stpcid
                    destVC.mininvest = transactionArr[row].mininvest
                    destVC.acc_no = transactionArr[row].account_no
                    destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                    destVC.folio_no = transactionArr[row].folio_no
                    destVC.no_of_units = transactionArr[row].no_of_units!
                    destVC.curr_value = transactionArr[row].curr_value1
                    destVC.trxnnumber = transactionArr[row].trxnnumber
                    destVC.swpcid = transactionArr[row].swpcid
                    destVC.row = row
                    destVC.bse_aof_status_code = self.bse_aof_status_code
                    destVC.bse_reg_code = self.bse_reg_code
                    destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                    destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                    destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
                    
                else if cell?.transacttf.text == "Start SWP"{
                    Mixpanel.mainInstance().track(event: "Transaction Screen :- Start SWP Clicked")
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "StartSWPViewController") as! StartSWPViewController
                    destVC.transactionArrs = transactionArr[row].valid_for
                    destVC.selectAction = selectAction
                    destVC.SchemeName = transactionArr[row].scheme_name
                    destVC.Schemecode = transactionArr[row].schemecode
                    destVC.acc_no = transactionArr[row].account_no
                    destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                    destVC.folio_no = transactionArr[row].folio_no
                    destVC.no_of_units = transactionArr[row].no_of_units!
                    destVC.curr_value = transactionArr[row].curr_value1
                    destVC.trxnnumber = transactionArr[row].trxnnumber
                    destVC.swpcid = transactionArr[row].swpcid
                    destVC.row = row
                    destVC.mininvest = transactionArr[row].mininvest
                    destVC.stptxnid = transactionArr[row].stptxnid
                    destVC.stpcid = transactionArr[row].stpcid
                    destVC.bse_aof_status_code = self.bse_aof_status_code
                    destVC.bse_reg_code = self.bse_reg_code
                    destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                    destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                    destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
                    
                else if cell?.transacttf.text == "Start STP"{
                     Mixpanel.mainInstance().track(event: "Transaction Screen :- Start STP Clicked")
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "STPViewController") as! STPViewController
                    destVC.transactionArrs = transactionArr[row].valid_for
                    destVC.selectAction = selectAction
                    destVC.SchemeName = transactionArr[row].scheme_name
                    destVC.Schemecode = transactionArr[row].schemecode
                    destVC.acc_no = transactionArr[row].account_no
                    destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                    destVC.folio_no = transactionArr[row].folio_no
                    destVC.no_of_units = transactionArr[row].no_of_units!
                    destVC.curr_value = transactionArr[row].curr_value1
                    destVC.row = row
                    destVC.mininvest = transactionArr[row].mininvest
                    destVC.stptxnid = transactionArr[row].stptxnid
                    destVC.stpcid = transactionArr[row].stpcid
                    destVC.trxnnumber = transactionArr[row].trxnnumber
                    destVC.swpcid = transactionArr[row].swpcid
                    destVC.bse_aof_status_code = self.bse_aof_status_code
                    destVC.bse_reg_code = self.bse_reg_code
                    destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                    destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                    destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                    self.navigationController?.pushViewController(destVC, animated: true)
                    
                }

                
         }
            self.dropdownForSiFund.show()
        }else if bank_is_empty && personal_is_empty {
            let alert = UIAlertController(title: "Alert", message: "For further process, please fill bank detail & personal detail", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click here to proceed!", style: UIAlertActionStyle.default, handler: { alert in
                
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                self.navigationController?.pushViewController(destVC, animated: true)
                Mixpanel.mainInstance().track(event: "Transaction Screen :- Click here to proceed! Button Clicked")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { alert in
                 Mixpanel.mainInstance().track(event: "Transaction Screen :- Cancel Button Clicked")
            }))
            self.present(alert, animated: true, completion: nil)
            print("bank is empty")
        } else if personal_is_empty {
            let alert = UIAlertController(title: "Alert", message: "For further process, please fill personal details.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click here to proceed!", style: UIAlertActionStyle.default, handler: { alert in
                Mixpanel.mainInstance().track(event: "Transaction Screen :- Click here to proceed! Button Clicked")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                self.navigationController?.pushViewController(controller, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { alert in
                Mixpanel.mainInstance().track(event: "Transaction Screen :- Cancel Button Clicked")
                
            }))
            self.present(alert, animated: true, completion: nil)
            print("bank is empty")
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "For further process, please fill bank details.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Click here to proceed!", style: UIAlertActionStyle.default, handler: { alert in
                Mixpanel.mainInstance().track(event: "Transaction Screen :- Click here to proceed! Button Clicked")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let controller = storyboard.instantiateViewController(withIdentifier: "BankDetailViewController") as! BankDetailViewController
                self.navigationController?.pushViewController(controller, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { alert in
                Mixpanel.mainInstance().track(event: "Transaction Screen :- Cancel Button Clicked")
            }))
            self.present(alert, animated: true, completion: nil)
            print("bank is empty")
        }

    }
    
    @IBAction func memberBtn(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Transaction Screen :- Member Dropdown Button Clicked")
        getMemberList(sender: sender)
        id = "1"
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    
    //var is_exapanded  = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let button = UIButton()
        button.isHidden = true
      //  getMemberList(sender: button)
        super.viewDidLoad()
        addBackbutton()
        weeklyBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
        unsubscribeBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        monthlyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        frequencyMode = "1"
        self.subscribeAlertView.isHidden = true
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserProfileStat()
        getUserData()
        getUserBankDetails()
        getUserDetail()
       // self.tabBarController?.navigationItem.hidesBackButton = true
    }
    override func viewDidAppear(_ animated: Bool) {
        //addBackbutton()
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        print("back")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "transaction", for: indexPath) as? transactionCell
        cell?.contentView.backgroundColor = UIColor.clear
       // cell.contentView.frame = UIEdgeInsetsInsetRect(cell.contentView.frame, UIEdgeInsetsMake(6, 6, 6, 6))

        var heights : Int!
        if transactionArr[indexPath.row].is_exapanded == true{
            heights = 160
        }
        else{
            heights = 350
        }
        //activeMember.text
        if activeMember.text == "ALL" || transactionArr[indexPath.row].valid_for.count < 2{
            //cell?.expandTransact.backgroundColor  = UIColor.lightGray
            cell?.expandTransact.isEnabled = false
            cell?.transacttf.isEnabled = false
            cell?.transacttf.textColor = UIColor.lightGray
          } else {
            cell?.expandTransact.isEnabled = true
            cell?.transacttf.isEnabled = true
            cell?.transacttf.textColor = UIColor.black
        }
        let whiteRoundedView : UIView = UIView(frame: CGRect(x:5, y:5, width:Int(self.view.frame.size.width - 10), height:heights!))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.shadowOffset = CGSize(width:-1, height:1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        cell?.expandTransact.tag = indexPath.row
        cell?.contentView.addSubview(whiteRoundedView)
        cell?.contentView.sendSubview(toBack: whiteRoundedView)
        
        cell?.currentValue.text = transactionArr[indexPath.row].curr_value
        cell?.schemeName.text = transactionArr[indexPath.row].scheme_name
        cell?.xirr.text = transactionArr[indexPath.row].xirr! + "%"
        if (cell?.xirr.text?.contains(find: "-"))!{
             cell?.arrayButton.image = UIImage(named: "red_arrow_down")
        }
        else{
            cell?.arrayButton.image = UIImage(named: "green_arrow_up")
           
        }
        
        cell?.gainLoss.text = transactionArr[indexPath.row].gain_loss
        cell?.schemeName.tag = indexPath.row
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        cell?.schemeName.addGestureRecognizer(gestureRecognizer)
        print(transactionArr[indexPath.row].valid_for.count)
       
        cell?.delegate = self
        return cell!
    }
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer,id:Int) {
        Mixpanel.mainInstance().track(event: "Transaction Screen :- Fund Name Clicked")
        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "TransactionDetailsViewController") as! TransactionDetailsViewController
        destVC.id = gestureRecognizer.view?.tag
        navigationController?.pushViewController(destVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
            return 169
     }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 4
//    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func getTransactionDetail(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let panid = UserDefaults.standard.value(forKey: "pan") as? String
        let new_pan = panid?.replacingOccurrences(of: "'',", with: "")
        let new_pan1 = new_pan?.replacingOccurrences(of: ",''", with: "")
        //presentWindow.makeToast(message: "\(panid!)")
        let url = "\(Constants.BASE_URL)\(Constants.API.getTransactionDetail)\(new_pan1!.covertToBase64())/3"

        //let url = "\(Constants.BASE_URL)\(Constants.API.getTransactionDetail)\(pan!.covertToBase64())/3"
        print(url)
        transactionArr.removeAll()
       // if loading_flag == "1"{
       //     self.presentWindow.makeToastActivity(message: "Loading..")
        //}
         self.presentWindow.makeToastActivity(message: "Loading..")//
        if Connectivity.isConnectedToInternet{
             Alamofire.request(url).responseString { response in
                print(response.result.value ?? "value")
                let enc_response = response.result.value
                var dict = [String:Any]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    print()
                    if enc != "[]" {
                        dict = self.convertToDictionary3(text: enc)!
                    }
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data1 = dict
                let data = data1
               if !data.isEmpty {
                    self.presentWindow.hideToastActivity()//
                    self.nodataView.isHidden = true
                    let countForCell = data.count - 1
                    for i in (0..<countForCell){
                        if let dataDetail = data["\(String(i))"]as? NSDictionary{
                            print(dataDetail["schemecode"])
                            if  let schemecode = dataDetail.value(forKey: "schemecode") as? String,
                                let folio_no = dataDetail.value(forKey: "folio_no") as? String,
                                let scheme_name = dataDetail.value(forKey: "scheme_name") as? String,
                                let curr_value = dataDetail.value(forKey: "curr_value") as? String,
                                let gain_loss = dataDetail.value(forKey: "gain_loss") as? String,
                                let xirr = dataDetail.value(forKey: "xirr") as? String,
                                let account_no = dataDetail.value(forKey: "account_no") as? String,
                                var valid_for = dataDetail.value(forKey: "valid_for") as? [String],
                                let units = dataDetail.value(forKey: "units") as? String,
                                let curr_value1 = dataDetail.value(forKey: "curr_value") as? String,
                                let mininvest = dataDetail.value(forKey: "mininvest") as? String,
                                let trxnnumber = dataDetail.value(forKey: "trxnnumber") as? String,
                                let stptxnid = dataDetail.value(forKey: "stptxnid") as? String {
                                
                                let stpcid =  dataDetail.value(forKey: "stpcid") as? String ?? ""
                                let swpcid = dataDetail.value(forKey: "swpcid") as? String ?? ""
                                let minredeemUnit =  dataDetail.value(forKey: "minredeemUnit") as? String ?? ""
                                let minredeemAmt = dataDetail.value(forKey: "minredeemAmt") as? String ?? ""
                                let curr_nav = dataDetail.value(forKey: "curr_nav") as? String ?? ""
                                let swptxnid = dataDetail.value(forKey: "swptxnid") as? String ?? ""
                                UserDefaults.standard.setValue(swptxnid, forKey: "swptxnid")
                                valid_for.insert("Select", at: 0)
                                let formatter = NumberFormatter()              // Cache this,
                                formatter.locale = Locale(identifier: "en_IN") // Here indian local
                                formatter.numberStyle = .decimal
                                let curr_value_comma = formatter.string(from: (curr_value.numberValue)!)
                                
                                let formatter_gain = NumberFormatter()              // Cache this,
                                formatter_gain.locale = Locale(identifier: "en_IN") // Here indian local
                                formatter_gain.numberStyle = .decimal
                                let gain_loss_comma = formatter_gain.string(from: (gain_loss.numberValue)!)
                                //self.investCost.text = invested_cost1
                                transactionArr.append(TransactionDetailObj.getTransactionDetail(schemecode: schemecode, scheme_name: scheme_name, curr_value: ("₹ " + curr_value_comma!), gain_loss: gain_loss_comma!, folio_no: folio_no, xirr: xirr, account_no: account_no, valid_for: valid_for, no_of_units: units, curr_value1: curr_value1, mininvest: mininvest,trxnnumber:trxnnumber, stptxnid: stptxnid, stpcid: stpcid,swpcid:swpcid, minredeemAmt: minredeemAmt,minredeemUnit: minredeemUnit,curr_nav: curr_nav))
                              }
                        }
                    }
                    
                    self.tableView.reloadData()
                    self.presentWindow.hideToastActivity()
                    print(transactionArr)
                } else{
                    self.presentWindow.hideToastActivity()
                    self.nodataView.isHidden = false
                    print("show screen")
                }
            }
         } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
   
    func getUserBankDetails(){
        userBanklist.removeAll()
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.getBank)\(userid!.covertToBase64())/fintoo/3"
        print(url,"bank")
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
                let data1 = dict
                if let data = data1 as? [AnyObject]{
                    print(data.isEmpty)
                    if data.isEmpty != true{
                        self.bank_is_empty = false
                        for type in data{
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
                                let state = type.value(forKey: "state_name") as? String,
                                let city = type.value(forKey: "city_name") as? String
                            {
                                
                                self.abc  = bank_acc_no
                                self.bank_name_arr["bank_name"] = bank_name
                                self.bank_name_arr["bank_id"] = bank_id
                                self.bank_acc_no_from_bank_list[bank_acc_no] = self.bank_name_arr
                                let min_acc_number = type.value(forKey: "min_acc_number") as? String ?? "0"
                                let max_acc_number = type.value(forKey: "max_acc_number") as? String ?? "0"
                                let isip_allow = type.value(forKey: "isip_allow") as? String ?? "0"
                                let bank_mandate_type = type.value(forKey: "bank_mandate_type") as? String ?? "XSIP"
                                let max_trxn_limit = type.value(forKey: "max_trxn_limit") as? String ?? ""
                                if banks_bd_code != nil{
                                    print(bank_type,"banktype")
                                    userBanklist.append(getBankObj.getUserBank(bank_acc_no: bank_acc_no, bank_branch: bank_branch, bank_cancel_cheque: bank_cancel_cheque, bank_city: bank_city, bank_country: bank_country, bank_current_txn_limit: bank_current_txn_limit, bank_id: bank_id, bank_ifsc_code: bank_ifsc_code, bank_joint_holder: bank_joint_holder, bank_mandate: bank_mandate, bank_mandate_document: bank_mandate_document, bank_name: bank_name, bank_state: bank_state, bank_txn_limit: bank_txn_limit, bank_type: bank_type, banks_bd_code: banks_bd_code, micr_code: micr_code, single_survivor: single_survivor, txn_exst: txn_exst, country_name:country ,state_name: state, city_name: city, bank_razorpay_code: "0", bank_razorpay_code_user: "0", min_acc_number: min_acc_number,max_acc_number: max_acc_number, isip_allow: isip_allow,bank_mandate_type: bank_mandate_type, max_trxn_limit: max_trxn_limit))
                                }
                            }
                        }
                    } else{
                        self.bank_is_empty = true
                        print("hello")
                    }
                }
            }
        } else{
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
        let url = "\(Constants.BASE_URL)\(Constants.API.getFatcaDetails)\(userid!)/3"
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
                let data1 = dict
                //self.presentWindow.hideToastActivity()
                
                if let data = data1 as? [[String: AnyObject]] {
                    print(data)
                    if data.count > 0 {
                       self.personal_is_empty = false
                    } else {
                         self.personal_is_empty = true
                        
                    }
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    
    func getUserProfileStat(){
        
        let panid = UserDefaults.standard.value(forKey: "pan") as? String
        let new_pan = panid?.replacingOccurrences(of: "'", with: "")
        
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        
        let url = "\(Constants.BASE_URL)\(Constants.API.CHECK_USER_STAT)\(new_pan!)"
        print(url)
        
        if Connectivity.isConnectedToInternet{
            self.presentWindow.makeToastActivity(message: "Loading..")
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value
                self.presentWindow.hideToastActivity()
                if data != nil {
                    if let resp = data as? [String:Any] {
                        print(response,"response###")
                        // for object in resp {
                        let personal_details_filled = resp["personal_details"] as? String ?? ""
                        let address_details_filled = resp["address_details"] as? String ?? ""
                        let other_details_filled = resp["other_details"] as? String ?? ""
                        let kyc_details_filled = resp["kyc_details"] as? String ?? ""
                        let fatca_details_filled = resp["fatca_details"] as? String ?? ""
                        let bank_details_filled = resp["bank_details"] as? String ?? ""
                        let aof_upload_status_filled = resp["aof_upload_status"] as? String ?? ""
                        let bse_aof_status_filled = resp["bse_aof_status"] as? String ?? ""
                        
                        print("other_details_filled \(other_details_filled)")
                        if personal_details_filled == "No" {
                            let alert = UIAlertController(title: "Alert", message: "Please fill personal details", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                alert in
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "MydetailsViewController") as! MydetailsViewController
                                controller.personal_details_alert = true
                                self.navigationController?.pushViewController(controller, animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                        } else if address_details_filled == "No" {
                            
                            let alert = UIAlertController(title: "Alert", message: "Please fill address details", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                alert in
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "addressDetailViewController") as! addressDetailViewController
                                destVC.personal_details_alert = true
                                self.navigationController?.pushViewController(destVC, animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                            
                        } else if other_details_filled == "No" {
                            
                            let alert = UIAlertController(title: "Alert", message: "Please fill other details", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                alert in
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "OtherDetailViewController") as! OtherDetailViewController
                                destVC.personal_details_alert = true
                                self.navigationController?.pushViewController(destVC, animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        } else if kyc_details_filled == "No" {
                            
                            let alert = UIAlertController(title: "Alert", message: "Please fill kyc details", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                alert in
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
                                destVC.personal_details_alert = true
                                self.navigationController?.pushViewController(destVC, animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        } else if fatca_details_filled == "No" {
                            
                            let alert = UIAlertController(title: "Alert", message: "Please fill fatca details", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                alert in
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "FatcaDetailViewController") as! FatcaDetailViewController
                                destVC.personal_details_alert = true
                                self.navigationController?.pushViewController(destVC, animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        } else if bank_details_filled == "No"{
                            let alert = UIAlertController(title: "Alert", message: "Please fill bank details", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                alert in
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let controller = storyboard.instantiateViewController(withIdentifier: "BankDetailViewController") as! BankDetailViewController
                                controller.personal_details_alert = true
                                self.navigationController?.pushViewController(controller, animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        } else if aof_upload_status_filled == "No" {
                            
                            let alert = UIAlertController(title: "Alert", message: "Please fill aof details", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                alert in
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "UploadDocumentViewController") as! UploadDocumentViewController
                                self.navigationController?.pushViewController(destVC, animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }  else if bse_aof_status_filled == "No" {
                            
                            let alert = UIAlertController(title: "Alert", message: "Please fill aof details", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
                                alert in
                                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "UploadDocumentViewController") as! UploadDocumentViewController
                                self.navigationController?.pushViewController(destVC, animated: true)
                                
                            }))
                            self.present(alert, animated: true, completion: nil)
                            
                            
                        }else {
                            
//                            if id == 4 {
//                                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//                                let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//                                self.navigationController?.pushViewController(destVC, animated: true)
//
//                            } else {
//                                let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
//                                let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
//                                destVC.dashboardIndex = true
//                                self.navigationController?.pushViewController(destVC, animated: true)
//                            }
                            
                        }
                    }
                    
                }
            }
            
            
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    
    
    func getUserData(){
        print(flag)
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.CHECK_PAN_DB)\(covertToBase64(text: userid! as? String ?? ""))/3"
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
                        let bse_reg =  object["bse_reg"] as? String ?? ""
                        let bse_aof_status = object["bse_aof_status"] as? String ?? ""
                        //UserDefaults.standard.set(pan, forKey: "pan")
                        self.bse_aof_status_code = bse_aof_status
                        self.bse_reg_code = bse_reg
                        parent_pan = pan
                        let UserObjs = UserObj(id: id, pan: pan, dob: dob, mobile: mobile, landline: landline, name: name, middle_name: middle_name, last_name: last_name, flat_no: flat_no, building_name: building_name, road_street: road_street, address: address, city: city, state: state, country: country, pincode: pincode, email: email)
                        let full_name = "\(name) \(middle_name) \(last_name)"
                        //UserDefaults.standard.setValue(pan, forKey: "pan")
                        self.UserObjects.append(UserObjs)
                        if all_flag != "0"{
                            UserDefaults.standard.setValue(pan, forKey: "pan")
                            self.activeMember.text = "\(full_name) (\(pan))"
                            parent_pan = pan
                            self.reqReportBtn.isHidden = false
                            self.emReportBtn.isHidden = false
                            self.downloadBtn.isHidden = false
                            self.tblViewTopConstraint.constant = 40
                            self.reportButtonViewHeight.constant = 40
                        }else{
                            print("flag set")
                            let pan = UserDefaults.standard.value(forKey: "pan") as? String
                            print(pan,"flag pan")
                            self.activeMember.text = "ALL"
                            self.reqReportBtn.isHidden = true
                            self.emReportBtn.isHidden = true
                            self.downloadBtn.isHidden = true
                            self.tblViewTopConstraint.constant = 4
                            self.reportButtonViewHeight.constant = 0
                        }
                        
                        self.getTransactionDetail()
                    }
                    
                    
                }
            }
            
        }
        else{
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
                            
                            self.get_member_list.append(getMemberObj(id: id, name: full_name, pan: "'\(pan)'", dob: dob, member_display_flag: member_display_flag ))
                        }
                        
                        print("\(self.get_member_list.map { $0.pan! }.joined(separator: ","))")
                        self.activeMember.text = "ALL"
                        self.reqReportBtn.isHidden = true
                        self.emReportBtn.isHidden = true
                        self.downloadBtn.isHidden = true
                        self.tblViewTopConstraint.constant = 4
                        self.reportButtonViewHeight.constant = 0
                        
                        let all_member = "\(self.get_member_list.map { $0.pan! }.joined(separator: ","))"
                        let all_member_id = "\(self.get_member_list.map { $0.id! }.joined(separator: ","))"
                        self.get_member_list.insert(getMemberObj(id:"\(all_member_id)", name: "ALL", pan: "\(all_member)", dob: "", member_display_flag: "0"), at: 0)
                        if self.id == "0"{
                            if self.activeMember.text == "ALL" {
                                UserDefaults.standard.setValue(self.get_member_list[0].pan, forKey: "pan")
                                all_flag = "0"
                                self.getTransactionDetail()
                                
                            }
                        }
                        //self.get_member_list.append(getMemberObj(id:"\(all_member)", name: "ALL", pan: "\(all_member)", dob: "", member_display_flag: ""))
                        self.dropDownMember.anchorView = sender
                        self.dropDownMember.dataSource = self.get_member_list.map { $0.name ?? ""}
                       
                        self.dropDownMember.selectionAction = { [unowned self] (index: Int, item: String) in
                            //self.activeMember.text = self.get_member_list[index].name
                            
                            if self.get_member_list[index].name == "ALL" {
                                self.activeMember.text = "ALL"
                                flag = p_userid as? String ?? ""
                                all_flag = "0"
                                UserDefaults.standard.setValue(self.get_member_list[0].pan, forKey: "pan")
                                UserDefaults.standard.setValue(self.get_member_list[0].id, forKey: "userid")
                                NotificationCenter.default.post(name: Notification.Name("Cart_Count"),
                                                                object: nil)
                                Mixpanel.mainInstance().track(event: "Transaction Screen :- Memeber DropDown ALL Selected")
                            } else{
                                self.reqReportBtn.isHidden = false
                                self.emReportBtn.isHidden = false
                                self.downloadBtn.isHidden = false
                                self.tblViewTopConstraint.constant = 40
                                self.reportButtonViewHeight.constant = 40
                                self.getrandomstring()
                                let pan_no = self.get_member_list[index].pan!
                                let pan_no_1 = pan_no.replacingOccurrences(of: "'", with: "", options: [], range: nil)
                                self.activeMember.text = "\(self.get_member_list[index].name!) (\(pan_no_1))"
                                flag = self.get_member_list[index].id!
                                UserDefaults.standard.setValue(self.get_member_list[index].pan, forKey: "pan")
                                all_flag = "1"
                                NotificationCenter.default.post(name: Notification.Name("Cart_Count"),
                                                                object: nil)
                                let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
                                if self.get_member_list[index].id! == String(describing: p_userid!) {
                                    UserDefaults.standard.setValue("0", forKey: "memberid")
                                } else {
                                    UserDefaults.standard.setValue(self.get_member_list[index].id!, forKey: "memberid")
                                }
                                Mixpanel.mainInstance().track(event: "Transaction Screen :- Memeber DropDown \(self.activeMember.text ?? "")  Selected")
                            }
                            
                            
                            self.loading_flag = "1"
                            self.getTransactionDetail()
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
    
    
    
    
    func getrandomstring(){
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
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        if frequencyMode == "0" || frequencyMode == "1" || frequencyMode == "2"{
            sendSubscriptionForRequestReport(mode:frequencyMode)
        }
        else  {
            presentWindow?.makeToast(message: "Select any one option")
        }
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
        self.subscribeAlertView.isHidden = true
    }
    
    func sendSubscriptionForRequestReport(mode: String){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        
        let url = "\(Constants.BASE_URL)\(Constants.API.getRequestReport)"
        let parameters = ["user_id":"\(userid!)","req_report": frequencyMode!]
        print(url)
        print("\(userid) \(frequencyMode)")
        self.presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.getRequestReport)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                    
                    print(response.value)
                    print("##\(response.result.value!)")
                    
                    let data =  response.result.value as? [String:Any]
                    
                    if let response_status = data?["status"] {
                        self.presentWindow.hideToastActivity()
                        if data?["status"] != nil {
                            if data?["message"] != nil {
                                if let message = data?["message"]! as? String {
                                    
                                    print("message: \(message)")
                                    
                                    
                                    let alert = UIAlertController(title: "Alert", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                                    self.present(alert, animated: true, completion: nil)
                                    self.subscribeAlertView.isHidden = true
                                }
                            }
                            
                        }
                        
                        
                    }
            }
        }
    }
    
    @IBAction func weeklyBtnClicked(_ sender: UIButton) {
        unsubscribeBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        monthlyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        weeklyBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
        frequencyMode = "1"
    }
    @IBAction func monthlyBtnClicked(_ sender: UIButton) {
        unsubscribeBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        monthlyBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
        weeklyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        frequencyMode = "2"
    }
    @IBAction func unsubscribeBtnClicked(_ sender: UIButton) {
        unsubscribeBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
        monthlyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        weeklyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        frequencyMode = "0"
    }

}

class transactionCell : UITableViewCell{
 
    
    @IBOutlet weak var schemeName: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var expandTransact: UIButton!
    @IBOutlet weak var xirr: UILabel!
    @IBOutlet weak var arrayButton: UIImageView!
    weak var delegate: TransactionDelegate?
    @IBOutlet weak var gainLoss: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func transactOnlineBtn(_ sender: UIButton) {
      delegate?.expandView(row: sender.tag, btn: sender )
    }
    @IBOutlet weak var transacttf: UITextField!
    
    
    
}

extension TransactionsViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UINavigationBar.appearance().tintColor = UIColor.black
        return self
    }
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        print("done btn")
        tableView.tableHeaderView = UIImageView(image: UIImage(named: ""))
        tableView.tableFooterView?.isHidden = true
        tableView.reloadData()
    }
}
