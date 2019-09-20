 //
 //  BankDetailViewController.swift
 //  Fintoo
 //
 //  Created by iosdevelopermme on 17/02/18.
 //  Copyright © 2018 iosdevelopermme. All rights reserved.
 //
 
 import UIKit
 import Alamofire
 import Crashlytics
 import Mixpanel
 var userBanklist = [getBankObj]()
 var bankTypeArr = [bankTypeObj]()
 
 class BankDetailViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,BankDetailCellDelegate,UITextFieldDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    
    @IBOutlet weak var addAnotherBankOutlet: UIButton!
    let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
    let ACCEPTABLE_CHARACTERS2 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    let ACCEPTABLE_CHARACTERS1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "
    var data = ["One"]
    var upload_tag : Int!
    var account_number = ""
    var account_type = ""
    var bank_name = ""
    var micr_code = ""
    var ifsc_code = ""
    var bank_branch = ""
    var country = ""
    var state = ""
    var uploadedCount = 0
    var city = ""
    var c_cheque = ""
    var bank1 = "1"
    var tab = [String:String]()
    var UserObjects = [UserObj]()
    var city_name_razorpay = ""
    var city_id_razorpay = ""
    var state_name_razorpay = ""
    var state_id_razorpay = ""
    var bank_branch_razorpay = ""
    var fatca_detail_flag = false
    var acc_no_arr = [String]()
    
    var bank_details_flag=true
    
    var userExistingBank = [String:[String:String]]()
    
    var personal_details_alert = false
    
    func checkValidationForBank1(){
        
        
        if userBanklist[0].bank_acc_no == nil || userBanklist[0].bank_acc_no == "" {
            bank_details_flag = false
            presentWindow.makeToast(message: "Please Enter Account Number")
            return
        }
            
        else if userBanklist[0].bank_type == "0" || userBanklist[0].bank_type == "" {
            bank_details_flag = false
            presentWindow.makeToast(message: "Please Enter bank type")
            return
        }else if userBanklist[0].bank_name == "Select Bank" || userBanklist[0].bank_name == "" {
            bank_details_flag = false
            presentWindow.makeToast(message: "Please Enter bank name")
            return
        }else if userBanklist[0].bank_ifsc_code == nil || userBanklist[0].bank_ifsc_code == "" {
            bank_details_flag = false
            presentWindow.makeToast(message: "Please Enter bank ifsc code")
            return
        }else if userBanklist[0].bank_branch == nil || userBanklist[0].bank_branch == "" {
            bank_details_flag = false
            presentWindow.makeToast(message: "Please Enter bank branch")
            return
        }else if userBanklist[0].bank_country == nil || userBanklist[0].bank_country == "" {
            bank_details_flag = false
            presentWindow.makeToast(message: "Please Enter country")
            return
        }else if userBanklist[0].bank_state == nil || userBanklist[0].bank_state == "" {
            bank_details_flag = false
            presentWindow.makeToast(message: "Please Enter state")
            return
        }else if userBanklist[0].bank_city == nil || userBanklist[0].bank_city == "" {
            bank_details_flag = false
            presentWindow.makeToast(message: "Please Enter city")
            return
        }else if userBanklist[0].bank_cancel_cheque == nil || userBanklist[0].bank_cancel_cheque == "" {
            bank_details_flag = false
            presentWindow.makeToast(message: "Please upload bank proof")
            return
        }else{
            bank_details_flag = true
        }
        
    }
    
    func checkValidationForBank2(){
        let index = IndexPath(row: 1, section: 0)
        print(index)
        let cell = tableView.cellForRow(at: index) as? BankDetailTableViewCell
        if let cell = cell {    //for 2nd bank table
            if cell.accountNumberTf.text == "" {
                bank_details_flag = false
                presentWindow.makeToast(message: "Please Enter Account Number")
                return
            }else if cell.accountTypeTf.text == "Select" {
                bank_details_flag = false
                presentWindow.makeToast(message: "Please Enter Account type")
                return
            }else if cell.bankNameTf.text == "Select Bank" {
                bank_details_flag = false
                presentWindow.makeToast(message: "Please Enter Bank name")
                return
            }else if cell.IFSCCodeTf.text == ""{
                bank_details_flag = false
                presentWindow.makeToast(message: "Please Enter IFSC code")
                return
            }else if cell.bankBranchTf.text == "" {
                bank_details_flag = false
                presentWindow.makeToast(message: "Please Enter Bank branch")
                return
            }else if cell.countryTf.text == "" {
                bank_details_flag = false
                presentWindow.makeToast(message: "Please Enter Country")
                return
            }else if cell.stateTf.text == "" {
                bank_details_flag = false
                presentWindow.makeToast(message: "Please Enter State")
                return
            }else if cell.cityTf.text == "" {
                bank_details_flag = false
                presentWindow.makeToast(message: "Please Enter City")
                return
            }else if cell.cancelledChequeTf.text == "" {
                bank_details_flag = false
                presentWindow.makeToast(message: "Please upload bank proof")
                return
            }
            else{
                bank_details_flag = true
            }
            
            
            if cell.bankNameTf.text == "Select Bank"{
                print("**********")
                bank_dd_flag = 2
                
            }else if  cell.accountTypeTf.text == "Select"{
                print("+++++++++")
                bank_dd_flag = 8
            }
            else{
                bank_dd_flag = 0
            }
            
        }
    }
    @IBAction func addAnotherBank(_ sender: Any) {
       
        checkValidationForBank1()
        checkValidationForBank2()
       
        if bank_dd_flag != 0 {
            bank_details_flag = false
            //(sender as! UIButton).tag = 0
        }
        print(bank_details_flag)
        //////////
        Mixpanel.mainInstance().track(event: "Bank Details Screen :- Add Another Button Clicked")
        
        if  bank_details_flag == false {
            if (sender as AnyObject).tag == 1 {
                presentWindow.makeToast(message: "Please Enter Account Number")
            }else if (sender as AnyObject).tag == 2 || bank_dd_flag == 2{
                presentWindow.makeToast(message: "Please Enter Bank Name")
            }else if (sender as AnyObject).tag == 3{
                presentWindow.makeToast(message: "Please Enter IFSC Code")
            }else if (sender as AnyObject).tag == 4{
                presentWindow.makeToast(message: "Please Enter bank branch")
            }else if (sender as AnyObject).tag == 5{
                presentWindow.makeToast(message: "Please Enter country")
            }else if (sender as AnyObject).tag == 6{
                self.presentWindow?.makeToast(message: "Please enter state")
            }else if (sender as AnyObject).tag == 7{
                self.presentWindow?.makeToast(message: "Please enter city")
            }else if (sender as AnyObject).tag == 8 || bank_dd_flag == 8{
                 self.presentWindow?.makeToast(message:"Please Enter Account Type")
            }
        }else
        if bank_details_flag == true {
        
            if userBanklist.count > 2{
                addAnotherBankOutlet.isHidden = true
                self.tableViewBottom.constant = -42
            }
            else {
                addAnotherBankOutlet.isHidden = false
                
                bank_name_id = "01"
                C_ID = "0"
                S_ID = "0"
                City_id = "0"
            
                userBanklist.append(getBankObj.getUserBank(bank_acc_no: "", bank_branch: "", bank_cancel_cheque: "", bank_city: "0", bank_country: "0", bank_current_txn_limit: "", bank_id: "", bank_ifsc_code: "", bank_joint_holder: "", bank_mandate: "", bank_mandate_document: "", bank_name: "Select Bank", bank_state: "0", bank_txn_limit: "", bank_type: "0", banks_bd_code: "", micr_code: "", single_survivor: "", txn_exst: "", country_name: "india", state_name: "State", city_name: "City", bank_razorpay_code: "0", bank_razorpay_code_user: "0", min_acc_number: "8", max_acc_number: "18", isip_allow: "0",bank_mandate_type: "XSIP", max_trxn_limit: ""))
                acc_no_arr.append("0")
                if userBanklist.count > 2{
                    addAnotherBankOutlet.isHidden = true
                    self.tableViewBottom.constant = -42
                }
            }
        }
        tableView.reloadData()
        let indexPath = NSIndexPath(item: userBanklist.count - 1 , section: 0)
        tableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.middle, animated: true)
    }
    
    func deleteCell(row: Int) {
        let refreshAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to delete this bank details?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle no logic here")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Confirm Alert No Button Clicked")
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.acc_no_arr.remove(at: row)
            self.deleteBank(id:userBanklist[row].bank_id!)
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Confirm Alert Yes Button Clicked")
            userBanklist.remove(at: row)
            if userBanklist.count < 3{
                self.addAnotherBankOutlet.isHidden = false
                self.tableViewBottom.constant = -10
            }
            bank_name_id = "00"
            self.tableView.reloadData()
            let topIndex = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: topIndex, at: .top, animated: true)
            //self.tableView?.reloadData()
            
            
        }))
        refreshAlert.view.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        present(refreshAlert, animated: true, completion: nil)
    }
    
    
    func viewDoc(row: Int) {
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        
        var url = ""
        let memberid = UserDefaults.standard.value(forKey: "memberid") as! String
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        if UserObjects[0].mobile != "" && UserObjects[0].email != "" {
            
            if memberid != "0" && memberid != parent_user_id{
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
                url = "\(Constants.API.kycViewDoc)\(userBanklist[row].bank_cancel_cheque!)&path=1&userId=\(userid!.convertToBase64())&action=globalfiledownload&aData=\(email_mobile.convertToBase64())"
            }
            presentWindow.makeToastActivity(message: "Loading...")
            print(url)
            if Connectivity.isConnectedToInternet {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "DocumentWebViewController") as! DocumentWebViewController
                destVC.url = url
                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        } else{
            presentWindow.makeToast(message: "Please First Complete Personal Details!!")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please First Complete Personal Details!!")
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // if data.count > 3{}
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? BankDetailTableViewCell
        if tableView == cell?.accountTypeTableview{
            return 10
        } else if tableView == tableView{
            return userBanklist.count
        } else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BankDetailTableViewCell
       
        
        cell?.bankBranchTf.delegate = self
        cell?.accountNumberTf.delegate = self
        cell?.accountTypeTf.delegate = self
        cell?.bankNameTf.delegate = self
        cell?.micrCodeTf.delegate = self
        cell?.IFSCCodeTf.delegate = self
        cell?.bankBranchTf.delegate = self
        cell?.countryTf.delegate = self
        cell?.stateTf.delegate = self
        cell?.cityTf.delegate = self
        cell?.accountTypeBtnOutlet.tag = indexPath.row
        cell?.viewDocOutlet.tag = indexPath.row
        cell?.bankNameOutlet.tag = indexPath.row
        cell?.countryBtnOutlet.tag = indexPath.row
        cell?.stateBtnOutlet.tag = indexPath.row
        cell?.cityBtnOutlet.tag = indexPath.row
        cell?.micrCodeTf.tag = indexPath.row
        cell?.IFSCCodeTf.tag = indexPath.row
        cell?.countryTf.tag = indexPath.row
        cell?.stateTf.tag = indexPath.row
        cell?.cityTf.tag = indexPath.row
        cell?.cancelledChequeTf.delegate = self
        cell?.uploadBtnOutlet.tag = indexPath.row
        cell?.accountNumberTf.maxLength = Int(userBanklist[indexPath.row].max_acc_number!) ?? 18
        // upload_tag = cell?.uploadBtnOutlet.tag
        cell?.accountNumberTf.text = userBanklist[indexPath.row].bank_acc_no
        cell?.accountNumberTf.tag = indexPath.row
        cell?.bankBranchTf.tag = indexPath.row
        cell?.bankBranchTf.text = userBanklist[indexPath.row].bank_branch
        cell?.bankNameTf.text = userBanklist[indexPath.row].bank_name
        cell?.micrCodeTf.text = userBanklist[indexPath.row].micr_code
        cell?.IFSCCodeTf.text = userBanklist[indexPath.row].bank_ifsc_code
        
        cell?.cancelledChequeTf.text = userBanklist[indexPath.row].bank_cancel_cheque
        
        cell?.countryTf.text = userBanklist[indexPath.row].country_name
        cell?.stateTf.text = userBanklist[indexPath.row].state_name
        if userBanklist[indexPath.row].city_name == nil{
            cell?.cityTf.text = "City"
            // cell?.bank_city_image.isHidden = true
            //cell?.cityTf.isEnabled = false
            //cell?.cityBtnOutlet.isUserInteractionEnabled = false
        } else {
            cell?.cityTf.text = userBanklist[indexPath.row].city_name
            // cell?.bank_city_image.isHidden = false
            // cell?.cityTf.isEnabled = true
            //cell?.cityBtnOutlet.isUserInteractionEnabled = true
        }
        
        cell?.deleteBtnOutlet.tag = indexPath.row
        cell?.cancelledChequeTf.tag = indexPath.row
        //print(bankTypeArr[Int(userBanklist[indexPath.row].bank_type!)!].bank_mst_name ?? "","@@@@")
        print(bankTypeArr.count)
        if bankTypeArr.count > 1 {
            cell?.accountTypeTf.text = bankTypeArr[Int(userBanklist[indexPath.row].bank_type ?? "0") ?? 0].bank_mst_name ?? "0"
        }
        account_number = userBanklist[indexPath.row].bank_acc_no!
        // account_type = cell!.accountTypeTf!.text!
        bank_name = userBanklist[indexPath.row].bank_name!
        micr_code = userBanklist[indexPath.row].micr_code!
        ifsc_code = userBanklist[indexPath.row].bank_ifsc_code!
        bank_branch = userBanklist[indexPath.row].bank_branch!
        C_ID =  userBanklist[indexPath.row].bank_country!
        S_ID = userBanklist[indexPath.row].bank_state!
        city = userBanklist[indexPath.row].bank_city!
        c_cheque = userBanklist[indexPath.row].bank_cancel_cheque!
        cell?.delegate = self
        if userBanklist[indexPath.row].bank_cancel_cheque! == ""{
            cell?.viewDocOutlet.isHidden = true
        }
        if userBanklist[indexPath.row].txn_exst == "Y"  {
            cell?.deleteBtnOutlet.isHidden = false
            
            print("You can not delete this bank as you have used this bank for your investments!")
            cell?.deleteBtnOutlet.alpha = 0.5
            cell?.deleteBtnOutlet.isEnabled = false
            cell?.deleteLabel.isHidden = false
        } else{
            if indexPath.row == 0{
                cell?.deleteBtnOutlet.isHidden = true
                cell?.deleteLabel.isHidden = true
            } else {
                cell?.deleteLabel.isHidden = true
                cell?.deleteBtnOutlet.isHidden = false
                cell?.deleteBtnOutlet.isEnabled = true
                cell?.deleteBtnOutlet.alpha = 1
                //cell?.deleteLabel.isHidden = false
            }
        }
        
//        let duplicates = Array(Set(acc_no_arr.filter({ (i: String) in acc_no_arr.filter({ $0 == i }).count > 1})))
//        for i in 0..<userBanklist.count{
//            // userExistingBank["bank\(i)"]!["verified"] = "false"
//            if cell?.accountNumberTf.text == ""{
//                bank_details_flag=false
//                presentWindow.makeToast(message: "Please Enter Account Number")
//                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Number")
//
//
//            }
//            else if cell?.bankNameTf.text == ""{
//                bank_details_flag=false
//                presentWindow.makeToast(message: "Please Enter Bank Name")
//                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Number")
//
//            }
//
//            else if cell?.IFSCCodeTf.text == ""{
//                bank_details_flag=false
//                presentWindow.makeToast(message: "Please Enter IFSC Code")
//                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter IFSC Code")
//
//
//            }else if cell?.bankBranchTf.text == ""{
//                bank_details_flag=false
//                presentWindow.makeToast(message: "lease Enter bank branch")
//                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter bank branch")
//
//
//            }else if cell?.countryTf.text == ""{
//                bank_details_flag=false
//                presentWindow.makeToast(message: "Please Enter country")
//                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please enter country ")
//
//            }
//            else if cell?.stateTf.text == ""{
//                bank_details_flag=false
//                self.presentWindow?.makeToast(message: "Please enter state")
//                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please enter state")
//
//            }else if cell?.cityTf.text == ""{
//                bank_details_flag=false
//                self.presentWindow?.makeToast(message: "IFSC code and Bank name not matching")
//                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Upload Cancelled Cheque")
//
//            }else{
//                print("hello")
//                // userExistingBank["bank\(i)"]!["verified"]="true"
//            }
        //}
        
        return cell!
        
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//         let cell = tableView.cellForRow(at: indexPath) as? BankDetailTableViewCell
//
//        if cell?.accountTypeTf.text == "Select"{
//            presentWindow.makeToast(message: "Please Enter account type")
//            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Number")
//            self.addAnotherBankOutlet.tag = 8
//        }
//        else if cell?.bankNameTf.text == "Select Bank"{
//            presentWindow.makeToast(message: "Please Enter Bank Name")
//            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Number")
//            self.addAnotherBankOutlet.tag = 2
//        }
//    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        print(index)
        let cell = tableView.cellForRow(at: index) as? BankDetailTableViewCell
        
        ////
        
        if textField == cell?.accountNumberTf{
            if textField.text == "" {
                bank_details_flag=false
               // presentWindow.makeToast(message: "Please Enter Account Number")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Number")
                self.addAnotherBankOutlet.tag = 1
                return
            }else{
                bank_details_flag=true
                self.addAnotherBankOutlet.tag = 0
            }
        
        }
         if textField == cell?.accountTypeTf{
            if textField.text == "Select"{
           // presentWindow.makeToast(message: "Please Enter account type")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Type")
            self.addAnotherBankOutlet.tag = 8
                return
            }else{
                bank_details_flag=true
                self.addAnotherBankOutlet.tag = 0
            }
        }
         if textField == cell?.bankNameTf {
            if textField.text == "" {
            bank_details_flag=false
           // presentWindow.makeToast(message: "Please Enter Bank Name")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Number")
            self.addAnotherBankOutlet.tag = 2
                return
            }else{
                bank_details_flag=true
                self.addAnotherBankOutlet.tag = 0
            }
            
        }
            
         if textField == cell?.IFSCCodeTf {
            if textField.text == ""{
            bank_details_flag=false
           // presentWindow.makeToast(message: "Please Enter IFSC Code")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter IFSC Code")
            self.addAnotherBankOutlet.tag = 3
                return
            }else{
                bank_details_flag=true
                self.addAnotherBankOutlet.tag = 0
            }
            
        }
        if textField == cell?.bankBranchTf{
            if textField.text == "" {
            bank_details_flag=false
           // presentWindow.makeToast(message: "lease Enter bank branch")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter bank branch")
            self.addAnotherBankOutlet.tag = 4
                return
            }else{
                bank_details_flag=true
                self.addAnotherBankOutlet.tag = 0
            }
            
            
        }
        if textField == cell?.countryTf{
            if textField.text == ""{
            bank_details_flag=false
          //  presentWindow.makeToast(message: "Please Enter country")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please enter country ")
            self.addAnotherBankOutlet.tag = 5
                return
            }else{
                bank_details_flag=true
                self.addAnotherBankOutlet.tag = 0
            }
            
        }
         if textField == cell?.stateTf{
            if textField.text == "" {
            bank_details_flag=false
            //self.presentWindow?.makeToast(message: "Please enter state")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please enter state")
            self.addAnotherBankOutlet.tag = 6
                return
            }else{
                bank_details_flag=true
                self.addAnotherBankOutlet.tag = 0
            }
            
        }
        if textField == cell?.cityTf{
            if textField.text == "" {
            bank_details_flag=false
            //self.presentWindow?.makeToast(message: "Please enter city")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Upload Cancelled Cheque")
            self.addAnotherBankOutlet.tag = 7
                return
            }else{
                bank_details_flag=true
                self.addAnotherBankOutlet.tag = 0
            }
            
        }else{
             bank_details_flag = true
        }
    
        /////
       
        if textField == cell?.bankBranchTf{
            userBanklist[textField.tag].bank_branch =  cell!.bankBranchTf.text
            bank_branch = cell!.bankBranchTf.text!
            
            c_cheque = userBanklist[textField.tag].bank_cancel_cheque!
        } else if textField == cell?.accountNumberTf{
//            if textField.text == ""{
//                bank_details_flag=false
//                presentWindow.makeToast(message: "Please Enter Account Number")
//            }
//            else{
            //cell?.accountNumberTf.text = cell!.accountNumberTf.text!
            userBanklist[textField.tag].bank_acc_no =  cell!.accountNumberTf.text
            acc_no_arr[textField.tag] = cell!.accountNumberTf.text ?? "0"
            account_number =  cell!.accountNumberTf.text!
            userBanklist[textField.tag].micr_code =  cell!.micrCodeTf.text
            micr_code =  cell!.micrCodeTf.text!
           // }
        } else if textField == cell?.micrCodeTf{
            
            userBanklist[textField.tag].micr_code =  cell!.micrCodeTf.text
            micr_code =  cell!.micrCodeTf.text!
            userBanklist[textField.tag].bank_ifsc_code =  cell!.IFSCCodeTf.text
            ifsc_code = cell!.IFSCCodeTf.text!
            
        }
        else if textField == cell?.IFSCCodeTf{
            userBanklist[textField.tag].bank_ifsc_code =  cell!.IFSCCodeTf.text
            ifsc_code = cell!.IFSCCodeTf.text!
            userBanklist[textField.tag].bank_branch =  cell!.bankBranchTf.text
            bank_branch = cell!.bankBranchTf.text!
            
            getRazorpay(ifsc_code: ifsc_code,index : textField.tag)
        }
        else if textField == cell?.cancelledChequeTf{
            userBanklist[textField.tag].bank_ifsc_code =  cell!.cancelledChequeTf.text
            ifsc_code = cell!.cancelledChequeTf.text!
        }
        else if textField == cell?.countryTf{
            userBanklist[textField.tag].country_name = cell!.countryTf.text
            C_ID = userBanklist[textField.tag].bank_country!
        }
        
        
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWhiteNavigationBar()
        addBackbutton()
        getUserBankDetails()
        getUserFatcaDetails()
        tableView.delegate = self
        tableView.dataSource = self
        print(tabBarController?.viewControllers?.count)
//        if upload_flag && tabBarController?.viewControllers?.count ?? 0 > 3{
//            let indexToRemove = 3
//            if var tabs = self.tabBarController?.viewControllers {
//                tabs.remove(at: indexToRemove)
//                self.tabBarController?.viewControllers = tabs
//            } else {
//                print("There is something wrong with tabbar controller")
//            }
//        }
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 && userBanklist[indexPath.row].txn_exst != "Y" {
            return 570
        } else {
            return 630
        }
    }
    override func onBackButtonPressed(_ sender: UIButton) {
         Mixpanel.mainInstance().track(event: "Bank Details Screen :- Back Button Clicked")
        if personal_details_alert == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
       
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
        self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
    func getUserBankDetails(){
        
        userBanklist.removeAll()
        var count  = 0
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading..")
        let url = "\(Constants.BASE_URL)\(Constants.API.getBank)\(userid!.covertToBase64())/fintoo/3"
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
                if let data = data as? [AnyObject]{
                    if data.isEmpty != true{
                        for type in data{
                            print(">>>>>>>>>>>>>>>>>>",count,"<<<<<<<<<<")
                            count += 1
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
                                let bank_razorpay_code = type.value(forKey: "bank_razorpay_code") as? String ?? ""
                                var min_acc_number = type.value(forKey: "min_acc_number") as? String ?? "0"
                                var max_acc_number = type.value(forKey: "max_acc_number") as? String ?? "0"
                                let max_trxn_limit = type.value(forKey: "max_trxn_limit") as? String ?? ""
                                if min_acc_number == "0"{
                                    min_acc_number = "8"
                                    max_acc_number = "18"
                                }
                                if banks_bd_code != nil{
                                    userBanklist.append(getBankObj.getUserBank(bank_acc_no: bank_acc_no, bank_branch: bank_branch, bank_cancel_cheque: bank_cancel_cheque, bank_city: bank_city, bank_country: bank_country, bank_current_txn_limit: bank_current_txn_limit, bank_id: bank_id, bank_ifsc_code: bank_ifsc_code, bank_joint_holder: bank_joint_holder, bank_mandate: bank_mandate, bank_mandate_document: bank_mandate_document, bank_name: bank_name, bank_state: bank_state, bank_txn_limit: bank_txn_limit, bank_type: bank_type, banks_bd_code: banks_bd_code, micr_code: micr_code, single_survivor: single_survivor, txn_exst: txn_exst, country_name:country ,state_name: state, city_name: city, bank_razorpay_code: "0", bank_razorpay_code_user: bank_razorpay_code, min_acc_number: min_acc_number, max_acc_number: max_acc_number, isip_allow: "0",bank_mandate_type: "XSIP", max_trxn_limit: max_trxn_limit))
                                }
                                self.getRazorpay(ifsc_code: bank_ifsc_code, index: count - 1)
                                self.acc_no_arr.append(bank_acc_no)
                            }
                        }
                        
                        self.getBankType()
                        if userBanklist.count > 2{
                            self.addAnotherBankOutlet.isHidden = true
                            self.tableViewBottom.constant = -42
                        }
                    } else{
                        self.getBankType()
                        //presentWindow.hideToastActivity()
                        bank_name_id = "01"
                        city_flag_bank = "0"
                        userBanklist.append(getBankObj.getUserBank(bank_acc_no: "", bank_branch: "", bank_cancel_cheque: "", bank_city: "", bank_country: "0", bank_current_txn_limit: "", bank_id: "", bank_ifsc_code: "", bank_joint_holder: "", bank_mandate: "", bank_mandate_document: "", bank_name: "Select Bank", bank_state: "", bank_txn_limit: "", bank_type: "0", banks_bd_code: "", micr_code: "", single_survivor: "", txn_exst: "", country_name: "india", state_name: "State", city_name: "City", bank_razorpay_code: "0", bank_razorpay_code_user: "0", min_acc_number: "8", max_acc_number: "18", isip_allow: "0",bank_mandate_type: "XSIP", max_trxn_limit: ""))
                        self.acc_no_arr.append("0")
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
    func postUserBankDetail(bankid:String,bank_name:String,acc_no:String,bank_type:String,ifsc_code:String,micr_code:String,bank_branch:String,bank_city:String,bank_state:String,bank_country:String,bank_cancel_cheque:String,city_name:String){
        presentWindow.makeToastActivity(message: "Updating..")
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.addBank)"
        if Connectivity.isConnectedToInternet{
            
            let parameters = [
                "id": "\(userid!.covertToBase64())",
                "bankid":"\(bankid.covertToBase64())",
                "bank_name":"\(bank_name.covertToBase64())",
                "acc_no":"\(acc_no.covertToBase64())",
                "bank_type":"\(bank_type.covertToBase64())",
                "ifsc_code":"\(ifsc_code.covertToBase64())",
                "micr_code":"\(micr_code.covertToBase64())",
                "bank_branch":"\(bank_branch.covertToBase64())",
                "bank_city":"\(bank_city.covertToBase64())",
                "bank_state":"\(bank_state.covertToBase64())",
                "bank_country":"\(bank_country.covertToBase64())",
                "bank_cancel_cheque":"\(bank_cancel_cheque.covertToBase64())",
                "single_survivor" : "single",
                "city_name":"\(city_name)",
                "enc_resp":"3"
            ]
            Alamofire.request("\(url)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    //let data = response.result.value as? String
                    if enc == "\"true\""{
                        print(self.uploadedCount,"upload count")
                        print(userBanklist.count,"bcount")
                        if self.uploadedCount == userBanklist.count - 1 {
                            
                            if self.fatca_detail_flag {
                                self.bseRegisteredFlag(userid: userid!)
                            } else {
                                self.uploadedCount = self.uploadedCount - 1
                                self.presentWindow.hideToastActivity()
                                self.presentWindow.makeToast(message: "For further process, please fill personal details.")
                            }
                        }
                        self.uploadedCount += 1
                    }
                    else {
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func uploadDocs(doc_value:String,doc_ext:String){
        presentWindow.makeToastActivity(message: "Uploading..")
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        if Connectivity.isConnectedToInternet{
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
                    _ = response.result.value
                    if let data = data as? [AnyObject]{
                        if data.isEmpty != true{
                            for type in data{
                                if let doc_name = type.value(forKey: "doc_name") as? String,
                                    let error = type.value(forKey: "error") as? String {
                                    if error == ""{
                                        self.presentWindow.hideToastActivity()
                                        userBanklist[self.upload_tag].bank_cancel_cheque = doc_name
                                        self.c_cheque = userBanklist[self.upload_tag].bank_cancel_cheque!
                                    } else{
                                        self.presentWindow.hideToastActivity()
                                        self.presentWindow?.makeToast(message: "Something Went wrong!")
                                    }
                                    
                                }
                            }
                        }
                        
                    }
            }
            
            
        } else{
            self.presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func deleteBank(id:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.deleteBank)"
        let duplicates = Array(Set(acc_no_arr.filter({ (i: String) in acc_no_arr.filter({ $0 == i }).count > 1})))
        self.presentWindow.makeToastActivity(message: "Deleting..")
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "bid": "\(id.covertToBase64())",
                "enc_resp":"3"
            ]
            // let url = "\(Constants.BASE_URL)\(Constants.API.addDoc)"
            Alamofire.request("\(url)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    // print(response.result.value)
                    //print("@@@@@")
                    let data = response.result.value as? String
                    if data! == "true"{
                        self.presentWindow.hideToastActivity()
                        print("success@@@")
                        print(userBanklist.count)
                        
                        
                    } else {
                        print("Failed")
                        self.presentWindow.hideToastActivity()
                    }
            }
        }
            
        else{
            self.presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    @IBAction func save(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Bank Details Screen :- Save Button Clicked")
        let duplicates = Array(Set(acc_no_arr.filter({ (i: String) in acc_no_arr.filter({ $0 == i }).count > 1})))
        print(account_number,"account number")
        print(micr_code,"micr")
        print(micr_code.count,"micr")
        print(bank_name_id,"bid")
        print(ifsc_code,"ifsc")
        print(bank_branch,"bb")
        print(C_ID,"cid")
        print(c_cheque)
        print(city_flag_bank,"city_flag")
        print(account_min_count,"min_count")
        
        //var bank_details_flag=true
        for i in 0..<userBanklist.count{
            // userExistingBank["bank\(i)"]!["verified"] = "false"
            if userBanklist[i].bank_acc_no == ""{
                bank_details_flag=false
                presentWindow.makeToast(message: "Please Enter Account Number")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Number")
                break
            } else if Int(userBanklist[i].min_acc_number!)!  > userBanklist[i].bank_acc_no!.count {
                bank_details_flag=false
                presentWindow.makeToast(message: "Min length is \(userBanklist[i].min_acc_number!) digits required for \(userBanklist[i].bank_name!).")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Account Number")
                break
            }
            else if userBanklist[i].bank_type == "00"{
                bank_details_flag=false
                presentWindow.makeToast(message: "Please Select Account Type")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Select Account Type")
                break
            }
            else if userBanklist[i].bank_type == "0"{
                bank_details_flag=false
                presentWindow.makeToast(message: "Please Select Account Type")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Select Account Type")
                break
            }
            else if bank_name_id == "01"{
                bank_details_flag=false
                presentWindow.makeToast(message: "Please Select Bank Name")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Select Bank Name")
                break
            }
                //                else if userBanklist[i].micr_code == ""{
                //                    bank_details_flag=false
                //                    Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter MICR Code")
                //                    presentWindow.makeToast(message: "Please Enter MICR Code")
                //                    break
                //                }
            else if userBanklist[i].micr_code != "" && userBanklist[i].micr_code!.count < 9{
                bank_details_flag=false
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- MICR code should not be less than 9 digit")
                presentWindow.makeToast(message: "MICR code should not be less than 9 digit")
                break
            }
                
            else if userBanklist[i].bank_ifsc_code == ""{
                bank_details_flag=false
                presentWindow.makeToast(message: "Please Enter IFSC Code")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter IFSC Code")
                break
            }
                
            else if userBanklist[i].bank_ifsc_code!.count < 11{
                bank_details_flag=false
                presentWindow.makeToast(message: "IFSC code should not be less than 11 characters")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- IFSC code should not be less than 11 characters")
                break
            }
                //                else if userBanklist[i].bank_branch == ""{
                //                    bank_details_flag=false
                //                    presentWindow.makeToast(message: "Please Enter Bank Branch ")
                //                    Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Enter Bank Branch ")
                //                    break
                //                }
                //                else if userBanklist[i].bank_country == "0" {
                //                    bank_details_flag=false
                //                    presentWindow.makeToast(message: "Please Select Country")
                //                    Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Select Country")
                //                    break
                //                }
                //                else if userBanklist[i].state_name == "Select State"{
                //                    bank_details_flag=false
                //                    presentWindow.makeToast(message: "Please Select State")
                //                    Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Select State")
                //                    break
                //                }
                //                else if city_flag_bank == "0"  && userBanklist[i].city_name == "Select City"{
                //                    bank_details_flag=false
                //                    presentWindow.makeToast(message: "Please Select City")
                //                    Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Select City")
                //                    break
                //                }
                
            else if userBanklist[i].bank_cancel_cheque == ""{
                bank_details_flag=false
                presentWindow.makeToast(message: "Please Upload Cancelled Cheque")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Upload Cancelled Cheque")
                break
            }
            else if userBanklist[i].bank_razorpay_code == "1"{
                bank_details_flag=false
                self.presentWindow?.makeToast(message: "Please add valid IFSC code")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please add valid IFSC code")
                break
            }
            else if userBanklist[i].bank_razorpay_code != userBanklist[i].bank_razorpay_code_user
            {
                bank_details_flag=false
                self.presentWindow?.makeToast(message: "IFSC code and Bank name not matching")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Please Upload Cancelled Cheque")
                break
            } else if duplicates.count > 0 {
                bank_details_flag=false
                self.presentWindow?.makeToast(message: "Account number is not unique.")
                Mixpanel.mainInstance().track(event: "Bank Details Screen :- Account number is not unique.")
                break
            } else{
                bank_details_flag = true
                print("hello")
                // userExistingBank["bank\(i)"]!["verified"]="true"
            }
            
            
        }
        if bank_details_flag == true{
            for i in 0..<userBanklist.count{
                print("JKKKK\(i)")
                
                postUserBankDetail(bankid: userBanklist[i].bank_id!, bank_name: userBanklist[i].bank_name! , acc_no: userBanklist[i].bank_acc_no!, bank_type: userBanklist[i].bank_type!, ifsc_code: userBanklist[i].bank_ifsc_code!, micr_code: userBanklist[i].micr_code!, bank_branch: userBanklist[i].bank_branch!, bank_city: userBanklist[i].bank_city!, bank_state: userBanklist[i].bank_state!, bank_country: "94", bank_cancel_cheque: userBanklist[i].bank_cancel_cheque!, city_name: userBanklist[i].city_name!)
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let index = IndexPath(row: textField.tag, section: 0)
        print(index)
        let cell = tableView.cellForRow(at: index) as? BankDetailTableViewCell
        if textField == cell?.IFSCCodeTf{
            if textField.maxLength > 11{
                return false
            } else {
                let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS2).inverted
                let filtered = string.components(separatedBy: cs).joined(separator: "")
                print(filtered)
                return (string == filtered)
            }
        }
        else if textField == cell?.bankBranchTf{
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS1).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            
            return (string == filtered)
        }
        return true
    }
    func uploadFile(row: Int) {
        print(row,"row")
        upload_tag = row
        pickDoc()
    }
    func pickDoc(){
        let documentPicker = UIDocumentPickerViewController(documentTypes:["public.image", "public.composite-content", "public.text"], in: .import)
        
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
        // Mixpanel.mainInstance().track(event: "Chat Screen:- \(self.service!) Document Selected")
        
    }
    
    // MARK:- UIDocumentPickerDelegate
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        
        
        let index = IndexPath(row: upload_tag , section: 0)
        print(index)
        let cell = tableView.cellForRow(at: index) as? BankDetailTableViewCell
        print("@@@@@@@@@@@@\(url)","@@@@@@@@@@@")
        let file = "\(url)"
        
        let fileNameWithoutExtension = file.fileName()
        
        let fileExtension = file.fileExtension()
        print(fileNameWithoutExtension)
        print(fileExtension)
        //uploadpantf.text = fileNameWithoutExtension
        // Allowed file types are jpg, jpeg, png, pdf, tiff)
        if fileExtension == "jpg" || fileExtension == "JPG" || fileExtension == "pdf" || fileExtension == "PDF" || fileExtension == "jpeg" || fileExtension == "JPEG" || fileExtension == "png" || fileExtension == "PNG" || fileExtension == "tiff" || fileExtension == "TIFF" {
            
            do {
                let data = try Data(contentsOf: url)
                let base64str = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                cell?.cancelledChequeTf.text = fileNameWithoutExtension + "." + fileExtension
                uploadDocs(doc_value: base64str, doc_ext: fileExtension)
            } catch{
                print(error)
            }
            
            
        } else{
            cell?.cancelledChequeTf.text = ""
            presentWindow.makeToast(message: "Invalid file type (Allowed file types are jpg, jpeg, png, pdf, tiff)")
            Mixpanel.mainInstance().track(event: "Bank Details Screen :- Invalid file type (Allowed file types are jpg, jpeg, png, pdf, tiff)")
        }
    }
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(covertToBase64(text: userid as? String ?? ""))/3"
        // presentWindow.makeToastActivity(message: "Loading...")
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
                        // self.getCountries(code:country, state: state,city: city)
                        let UserObjs = UserObj(id: id, pan: pan, dob: dob, mobile: mobile, landline: landline, name: name, middle_name: middle_name, last_name: last_name, flat_no: flat_no, building_name: building_name, road_street: road_street, address: address, city: city, state: state, country: country, pincode: pincode, email: email)
                        self.UserObjects.append(UserObjs)
                        
                    }
                }
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    func getBankType(){
        let url = "\(Constants.BASE_URL)\(Constants.API.bankType)"
        bankTypeArr.removeAll()
        bankTypeArr.append(bankTypeObj.getBankType(bank_mst_name: "Select", bank_mst_id: "0"))
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    for type in data{
                        if let bank_mst_name = type.value(forKey: "bank_mst_name") as? String,
                            let bank_mst_id = type.value(forKey: "bank_mst_id") as? String{
                            bankTypeArr.append(bankTypeObj.getBankType(bank_mst_name: bank_mst_name, bank_mst_id: bank_mst_id))
                        }
                    }
                }
                self.presentWindow.hideToastActivity()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }

                
            }
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getRazorpay(ifsc_code : String,index:Int) {
        print(index,"Razorpay")
        let url = "https://ifsc.razorpay.com/\(ifsc_code)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                if let data = response.result.value as? [String:Any]{
                    let branch = data["BRANCH"] as? String ?? ""
                    let contact = data["CONTACT"] as? String ?? ""
                    let state = data["STATE"] as? String ?? ""
                    let district = data["DISTRICT"] as? String ?? ""
                    let address = data["ADDRESS"] as? String ?? ""
                    let city = data["CITY"] as? String ?? ""
                    let bank = data["BANK"] as? String ?? ""
                    let bankcode = data["BANKCODE"] as? String ?? ""
                    let ifsc = data["IFSC"] as? String ?? ""
                    print(branch,contact,state,district,address,city,bank,bankcode,ifsc)
                    userBanklist[index].city_name = city
                    userBanklist[index].state_name = state
                    userBanklist[index].bank_branch = branch
                    userBanklist[index].bank_razorpay_code = bankcode
                    self.presentWindow.hideToastActivity()
                    self.tableView.reloadData()
                    self.getState(id: "94",index:index)
                    
                } else {
                    //self.presentWindow?.makeToast(message: "Please add valid IFSC code")
                    print("Not found")
                    userBanklist[index].bank_razorpay_code = "1"
                }
            }
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getState(id:String,index:Int){
        //let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(userid!)"
        if id != "0"{
            let url = "\(Constants.BASE_URL)\(Constants.API.state)\(id)"
            
            if Connectivity.isConnectedToInternet{
                
                Alamofire.request(url).responseJSON { response in
                    //print(response.result.value)
                    if let data = response.result.value as? [AnyObject]{
                        for type in data{
                            if let stateName = type.value(forKey: "state_name") as? String,
                                let stateId = type.value(forKey: "state_id") as? String{
                                if userBanklist[index].state_name!.lowercased() == stateName.lowercased() {
                                    userBanklist[index].bank_state! = stateId
                                }
                                
                            }
                        }
                        self.getCity1(id:userBanklist[index].bank_state!,index: index)
                    }
                }
            }
            else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }
    }
    func getCity1(id:String,index:Int){
        let url = "\(Constants.BASE_URL)\(Constants.API.city)\(id)"
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    if !data.isEmpty{
                        city_flag_bank = "0"
                        for type in data{
                            if let cityName = type.value(forKey: "city_name") as? String,
                                let cityId = type.value(forKey: "city_id") as? String{
                                if self.city_name_razorpay.lowercased() == cityName.lowercased() {
                                    self.city_id_razorpay = cityId
                                    userBanklist[index].bank_city! = cityName
                                } else{
                                    userBanklist[index].bank_city! = "0"
                                }
                            }
                        }
                    } else {
                        city_flag_bank = "1"
                        if id == "0" || id == ""{
                            print("city is empty")
                        } else{
                            print("city is empty")
                            
                        }
                        
                    }
                }
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            //presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func clientregistrationBse(userid:String){
        print("Modify ucc data")
        //https://www.financialhospital.in/adminpanel/bse/bse_ws.php/clientregistration/userid
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
                    self.presentWindow.hideToastActivity()
                    self.presentWindow.makeToast(message: "Bank details Added Successfully")
                    //redirect to nominee detail
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let controller = storyboard.instantiateViewController(withIdentifier: "NomineesViewController") as! NomineesViewController
                    self.navigationController?.pushViewController(controller, animated: true)
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
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Bank details Added Successfully")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "NomineesViewController") as! NomineesViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                    }
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    func getUserFatcaDetails(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.getFatcaDetails)\(covertToBase64(text: userid as! String))/3"
        print(url)
        if Connectivity.isConnectedToInternet{
            //cityArr.removeAll()
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
                    if !data.isEmpty{
                        for type in data{
                            if let _ = type.value(forKey: "fatca_id") as? String,
                                let fatca_networth = type.value(forKey: "fatca_networth") as? String, let fatca_networth_date = type.value(forKey: "fatca_networth_date") as? String , let fatca_politically_exposed = type.value(forKey: "fatca_politically_exposed") as? String,let fatca_nationality = type.value(forKey: "fatca_nationality") as? String,let fatca_other_nationality = type.value(forKey: "fatca_other_nationality") as? String,let fatca_tax_resident = type.value(forKey: "fatca_tax_resident") as? String ,let fatca_resident_country = type.value(forKey: "fatca_resident_country") as? String,let fatca_tax_player_id = type.value(forKey: "fatca_tax_player_id") as? String,let _ = type.value(forKey: "fatca_id_type") as? String,let fatca_resident_country_1 = type.value(forKey: "fatca_resident_country_1") as? String, let fatca_tax_player_id_1 = type.value(forKey: "fatca_tax_player_id_1") as? String,let _ = type.value(forKey: "fatca_id_type_1") as? String,let fatca_resident_country_2 = type.value(forKey: "fatca_resident_country_2") as? String,let fatca_tax_player_id_2 = type.value(forKey: "fatca_tax_player_id_2") as? String,let _ = type.value(forKey: "fatca_id_type_2") as? String{
                                
                                self.fatca_detail_flag = true
                            }
                        }
                    }
                    else{
                        self.fatca_detail_flag = false
                        print("fatca detail is empty")
                    }
                    // print(self.countriesArr)
                }
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
 }
