//
//  CartViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 08/03/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import DropDown
import Mixpanel

class CartViewController: BaseViewController,UITextFieldDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var lblToalCartItems: UILabel!
    @IBOutlet weak var lblTotalAmount: UILabel!
    @IBOutlet weak var nodataView: UIView!
    @IBOutlet weak var labelView: UIView!
    @IBOutlet weak var sundarmView: NSLayoutConstraint!

    @IBOutlet weak var l1MessageView: UILabel!
    @IBOutlet weak var selectAllBtn: UIButton!
    @IBOutlet weak var deleteAllBtn: UIButton!

    @IBOutlet weak var l1MessageViewHeightConstraint: NSLayoutConstraint!
    var today_is_holiday = false
     var holidayDateArray = [String]()
    var l1Indices = [Int]()
    var selectedRows:[IndexPath] = []
    var holiday_flag = true
    var allowed_flag = false

    var fatca_detail_flag = false
    var UserObjects = [UserObj]()
    var cartObjects = [CartObject]()
    var dropDownArr = [String]()
    let dropDown = DropDown()
    let dropDownYear = DropDown()
    let tempArr = ["", "Lumpsum", "SIP", "Additional Purchase"]
    var totalCartValue = 0
    var isEditingEnabled = false
    var id = "0"
    var flag_next_page =  false

    var get_member_list = [getMemberObj]()
    let dropDownMember = DropDown()
    var city_name = ""
    var country_name = ""
    var state_name = ""

    @IBOutlet weak var activeMember: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(UserDefaults.standard.value(forKey: "userid"))
       // todayIsHoliday()
        //self.getUserProfileStat(onload:true)
        addBackbutton()
        getUserFatcaDetails()
        tableview.delegate = self
        tableview.dataSource = self
    }

    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
        navigationController?.pushViewController(destVC, animated: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {

        getUserData()
        getCartData()

    }

    @IBAction func memberBtn(_ sender: UIButton) {

        getMemberList(sender: sender)
        id = "1"

    }

    @IBAction func selectAllBtnPressed(_ sender: UIButton) {
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "check-blue") {
            sender.setBackgroundImage(#imageLiteral(resourceName: "square"), for: .normal)

        } else {
            sender.setBackgroundImage(#imageLiteral(resourceName: "check-blue"), for: .normal)
        }

        print("select all button pressed")
        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "square") {
            self.selectedRows.removeAll()
            for i in 0..<cartObjects.count {
                self.cartObjects[i].isSelected = false
            }
        } else {
            self.selectedRows = getAllIndexPaths()
            for i in 0..<cartObjects.count {
                self.cartObjects[i].isSelected = true
            }
        }


        self.tableview.reloadData()
        print(self.selectedRows)
    }

    @IBAction func deleteAllBtnPRessed(_ sender: UIButton) {
        let count = self.cartObjects.filter { $0.isSelected == true }.count
        print(count)
        if count == 0 {
            self.presentWindow.makeToast(message: "Select cart items to delete")
        }
        else {
            let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete?", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                self.deleteAllRequest(sender)
                //self.removeCartObject(cartObjIndex: sender.tag)
                Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Delete Item Yes Button Clicked")
            }))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { action in
                Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Delete Item No Button Clicked")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }

    func deleteAllRequest(_ sender: UIButton){

        print("inside deleteAllRequest")
         //var cartObjectsToDelete = [CartObject]()
         var indexPathsToDelete = [IndexPath]()
        var cartIdArray = [String]()
        indexPathsToDelete.removeAll()
        for i in 0..<cartObjects.count {

            if cartObjects[i].isSelected == true {
                indexPathsToDelete.append(IndexPath(row: i, section: 0))
              var selectedIndexPath = IndexPath(row : i, section: 0)
                cartIdArray.append("\(cartObjects[i].cart_id)")
                 self.selectedRows.remove(at: self.selectedRows.index(of: selectedIndexPath)!)
            }

        }

        //let cartIdArray = cartObjectsToDelete.map{$0.cart_id}
        //print(indexPathsToDelete)
        print(cartIdArray)
        let parameters = ["id": cartIdArray ]
        let url = "\(Constants.BASE_URL)\(Constants.API.DeleteCart)"
        print(url)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    let enc_response = response.result.value ?? ""
                    let enc1 = enc_response.replacingOccurrences(of: "\n" , with: "")
                    print(enc1)
                    if enc1 == "\"true\"" {
                        self.presentWindow.makeToast(message: "Items Deleted Successfully")
                        Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Deleted All Successfully")
            var sortedIndexPathsToDelete = indexPathsToDelete.sorted{$0.row > $1.row}
                        for  i in 0..<sortedIndexPathsToDelete.count{
                           self.cartObjects.remove(at: sortedIndexPathsToDelete[i].row)
                        }

                        self.presentWindow.hideToastActivity()
                        if self.cartObjects.count == 0 {
                            self.nodataView.isHidden = false
                            self.getCartData()
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                                // your code here
//                                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//                                let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
//
//                                self.navigationController?.pushViewController(destVC, animated: true)
//                            }
                        }
                        else {
                            self.getCartData()
                            self.tableview.reloadData()
                        }

                    }else {
                        self.presentWindow.makeToast(message: "Error in deleting items")
                    }
            }
        }else {
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
                    if let response = data as? [[String:AnyObject]] {
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

                            var txnID = [String]()
                            var cart_mst_ID = [String]()
                            for obj in self.cartObjects {
                                txnID.append(obj.transaction_id)
                                cart_mst_ID.append(obj.cart_mst_id)
                            }
                            let txnIDstr = txnID.joined(separator: ",")
                            let cart_mst_IDstr = cart_mst_ID.joined(separator: ",")


                            print("txnidStr \(txnIDstr)")
                            print("cart_mst_IDstr \(cart_mst_IDstr)")
                            self.updateCartData(txnid: txnIDstr, userid: flag, cart_mst_ids: cart_mst_IDstr)


//                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//                            controller.cartObjects = self.cartObjects
//                            controller.totalCartValue = self.totalCartValue
//                            self.navigationController?.pushViewController(controller, animated: false)

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
                        //self.bseRegisteredFlag(userid: userid)
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

    func getUserProfileStat(onload:Bool){

        let panid = UserDefaults.standard.value(forKey: "pan") as? String
        //let new_pan = panid?.replacingOccurrences(of: "'", with: "")

        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }

        let url = "\(Constants.BASE_URL)\(Constants.API.CHECK_USER_STAT)\(panid!)"
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


                        } else  {
                            if onload == true {
                                //self.getUserData()
                                //self.getCartData()
                            }else {
                                 self.bseRegisteredFlag(userid: userid as! String) // from proceed checkout Btn
                            }

                        }

                    }
                }

            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
}


//#MARK: API Calls
extension CartViewController {

    func getCartData() {

        self.cartObjects.removeAll()
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        if flag != "0"{
            userid = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as! String
        }
        if id == "0"{
            presentWindow.makeToastActivity(message: "Loading...")
        }
        //
        let url = "\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid)"
        print(url)
        if Connectivity.isConnectedToInternet {
            self.totalCartValue = 0
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3").responseString { response in
                let enc_response = response.result.value
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
                let data = dict

                //let data = response.result.value
                if data != nil {
                    var transaction_id = ""
                    var cart_mst_id = ""

                    self.presentWindow.hideToastActivity()
                    if let response = data as? [[String: AnyObject]] {
                        print(response)
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
                            cart_mst_id = cartItem["cart_mst_id"] as? String ?? ""
                            let cart_mst_session_id = cartItem["cart_mst_session_id"] as? String ?? ""
                            let CLASSCODE = cartItem["CLASSCODE"] as? String ?? ""
                            let mode = cartItem["cart_purchase_type"] as? String ?? ""
                            let cart_purchase_type = self.tempArr[Int(mode) ?? 0]

                            let cart_scheme_code = cartItem["cart_scheme_code"] as? String ?? ""

                            let originalDate = cartItem["cart_sip_start_date"] as? String ?? ""
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
                            transaction_id = cartItem["transaction_id"] as? String ?? ""
                            let AMC_CODE = cartItem["AMC_CODE"] as? String ?? ""
                            let cartObj = CartObject(MAXINVT: MAXINVT, MININVT: MININVT, SCHEMECODE: SCHEMECODE, SIPMININVT: SIPMININVT, S_NAME: S_NAME, cart_added: cart_added, cart_amount: cart_amount, cart_folio_no: cart_folio_no, cart_frequency: cart_frequency, cart_id: cart_id, cart_mst_id: cart_mst_id, cart_mst_session_id: cart_mst_session_id, cart_purchase_type: cart_purchase_type, cart_scheme_code: cart_scheme_code, cart_sip_start_date: cart_sip_start_date, cart_tenure: cart_tenure, cart_tenure_perpetual: cart_tenure_perpetual, multiples: multiples, transaction_bank_id: transaction_bank_id, transaction_id: transaction_id,cart_sip_start_date1: originalDate, mode: mode, is_save: false, AMC_CODE: AMC_CODE, CLASSCODE: CLASSCODE, nominee: nil)
                            self.cartObjects.append(cartObj)
                        }

                        self.tableview.reloadData()

                        if self.cartObjects.count != 0{
                        self.checkL1Allowed(time2pm: 0, time3pm: 0, flag: "0", i: 0,fromBtnProceed: false)
                        }

                        self.lblToalCartItems.text = "Cart Subtotal (\(self.cartObjects.count) item) :"
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = NumberFormatter.Style.decimal
                        let formattedNumber = numberFormatter.string(from: NSNumber(value:self.totalCartValue))
                        guard let number = formattedNumber else {return}
                        self.lblTotalAmount.text = "\(number)"

                        if totalCountFlag == "1" {
                            UserDefaults.standard.setValue("\(self.cartObjects.count)", forKey: "totalcartcount")
                        }else {
                            UserDefaults.standard.setValue("", forKey: "totalcartcount")
                        }

                    }

                    if self.cartObjects.count == 0 {
                        self.nodataView.isHidden = false
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                            // your code here
//                            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//                            let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
//
//                            self.navigationController?.pushViewController(destVC, animated: true)
//                        }
                    } else {
                        self.nodataView.isHidden = true
                        //self.updateCartData(txnid: transaction_id, userid: flag, cart_mst_ids: cart_mst_id)
                    }
                } else {
                    self.presentWindow.hideToastActivity()
                    self.nodataView.isHidden = false

                }
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }

    func updateCartData(txnid:String,userid:String,cart_mst_ids:String) {
        print("updateCartData called with txnid : \(txnid) userid:\(userid) cart_mst_ids:\(cart_mst_ids)")
        let url = "\(Constants.BASE_URL)\(Constants.API.UpdateCartData)"
        let parameters = ["transaction_ids":"\(txnid)","newuser":"\(userid)","cart_mst_ids":"\(cart_mst_ids)"]

        print(url)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    let enc_response = response.result.value!
                    print(enc_response)
                    var dict = ""
                    let enc1 = enc_response.replacingOccurrences(of: "\n" , with: "")
//                    if let enc = enc1.base64Decoded() {
//                        dict = enc
//                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    //}
                    dict = enc1
                    print("dict \(dict)")
                    if dict == "\"true\"" || dict == "true"  {
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                        controller.cartObjects = self.cartObjects
                        controller.totalCartValue = self.totalCartValue
                        totalCountFlag = "1"
                        self.navigationController?.pushViewController(controller, animated: false)
                    }
                    else {
//                        let alert = UIAlertController(title: "Alert", message: "Error in updateCartData", preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
                        print("FAIL: updateCartData failed...")
                        self.presentWindow.hideToastActivity()
                        totalCountFlag = "0"
                    }
            }
        }

    }
    func getSchemaMonthly(code: String, sender: UIButton) {

        if Connectivity.isConnectedToInternet{
            print("\(Constants.BASE_URL)\(Constants.API.Sip_start_days)\(code.covertToBase64())/monthly/3")
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.Sip_start_days)\(code.covertToBase64())/monthly/3").responseString { response in
                let enc_response = response.result.value
                print(enc_response,"response")
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
                print(data)
                //if let data = data1{
                    if !data.isEmpty{
                        for sip_date in data as! [NSDictionary]{
                            self.dropDownArr.removeAll()
                            for i in 1..<8 {
                                //print(sip_date.value(forKey: "SIPDAYS\(i)"))
                                let sip_days = sip_date.value(forKey: "SIPDAYS\(i)") as? String
                                if sip_days! != "0" && sip_days! != "29" && sip_days! != "30" && sip_days! != "31" {
                                    self.dropDownArr.append(sip_days!)
                                }
                            }
                        }
                    }

                    if data.isEmpty || self.dropDownArr.isEmpty{
                        self.dropDownArr = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"]
                    }

                    self.dropDown.anchorView = sender
                    self.dropDown.dataSource = self.dropDownArr
                    self.dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                        let indexPath = IndexPath(row: sender.tag, section: 0)
                        let cell = self.tableview.cellForRow(at: indexPath) as! CheckOutTableViewCell
                        cell.tfStartDate.text = item
                        self.cartObjects[sender.tag].cart_sip_start_date = item
                        if !self.cartObjects[sender.tag].isModify {
                            self.calculateSIPDate(cartObj: self.cartObjects[sender.tag])
                        } else {
                            print("save")
                        }

                    }
                    self.dropDown.show()
                //}
            }

        } else {
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }

    func calculateSIPDate(cartObj: CartObject) {

        if cartObj.cart_purchase_type == "Lumpsum" || cartObj.cart_purchase_type == "Additional Purchase" {
             presentWindow.makeToastActivity(message: "Saving..")
            self.updateCart(total_installment: "", remaining_installment: "", end_date: "", start_date: "", cartObj: cartObj)

        } else {
            let url = "\(Constants.BASE_URL)\(Constants.API.calculatesipdate)"
            presentWindow.makeToastActivity(message: "Saving..")
            let parameters = ["stdate": cartObj.cart_sip_start_date, "type": tempArr.index(of: cartObj.cart_purchase_type) ?? "", "tenure": cartObj.cart_tenure] as [String : Any]
            if Connectivity.isConnectedToInternet {
                Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON{ response in
                        self.presentWindow.hideToastActivity()
                        let data = response.result.value
                        if let responseData = data as? [[String: AnyObject]] {
                            if responseData.count > 0 {
                                let cartSIPData = responseData[0]
                                let total_installment = cartSIPData["totalins"] as? String ?? ""
                                let remaining_installment = cartSIPData["remainingins"] as? String ?? ""
                                let end_date = cartSIPData["end_date"] as? String ?? ""
                                let start_date = cartSIPData["start_date"] as? String ?? ""

                                self.updateCart(total_installment: total_installment, remaining_installment: remaining_installment, end_date: end_date, start_date: start_date, cartObj: cartObj)
                            }
                        }
                }
            } else {
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }
    }

    func updateCart(total_installment: String, remaining_installment: String, end_date: String, start_date: String, cartObj: CartObject) {

        let url = "\(Constants.BASE_URL)\(Constants.API.updateCart)"
        //presentWindow.makeToastActivity(message: "Loading...")
        let parameters = ["id": cartObj.SCHEMECODE.covertToBase64(), "tenure": cartObj.cart_tenure.covertToBase64(), "amount": cartObj.cart_amount.covertToBase64(), "type": tempArr.index(of: cartObj.cart_purchase_type) ?? "", "sessionid": cartObj.cart_mst_session_id.covertToBase64(), "perpetual": cartObj.cart_tenure_perpetual.covertToBase64(), "cid": cartObj.cart_id.covertToBase64(), "start_date": start_date.covertToBase64(), "end_date": end_date.covertToBase64(), total_installment: total_installment.covertToBase64(), "remaining_installment": remaining_installment.covertToBase64(), "cart_rm_ref_id": "","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"] as [String : Any]
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    let enc_response = response.result.value
                    var dict = ""
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = enc
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    print(dict)
                    if dict == "\"true\""{
                        self.id = "1"
                        self.presentWindow.makeToast(message: "Updated Successfully")
                        self.checkL1Allowed(time2pm: 0, time3pm: 0, flag: "0", i: 0, fromBtnProceed: false)
                        Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Updated Successfully")
                        self.presentWindow.hideToastActivity()
                       // self.getCartData()
                    } else {
                        self.presentWindow.hideToastActivity()
                    }


            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }

    func removeCartObject(cartObjIndex: Int) {
        let cartObj = self.cartObjects[cartObjIndex]
        let url = "\(Constants.BASE_URL)\(Constants.API.deleteCart)"
        print(url)
        presentWindow.makeToastActivity(message: "Loading...")
        let parameters = ["id": cartObj.cart_id.covertToBase64(),"enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"] as [String : Any]
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let r1 = response.result.value
                    let enc1 = r1?.replacingOccurrences(of: "\n" , with: "")
                    let status = enc1?.base64Decoded() ?? ""
                    //let status = response.result.value?.base64Decoded()
                    if status == "\"true\""{
                        self.presentWindow.makeToast(message: "Item Deleted Successfully")
                        Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Item Deleted Successfully")
                        self.presentWindow.hideToastActivity()

                        self.getCartData()
                    }

            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
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

                    if self.allowed_flag == true {
                        self.presentWindow.hideToastActivity()
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmTransactionViewController") as! ConfirmTransactionViewController
                        controller.cartObjects = self.cartObjects
                        controller.totalCartValue = self.totalCartValue
                        self.navigationController?.pushViewController(controller, animated: true)
                    }else {
                        //self.presentWindow.makeToast(message: "L1 orders restricted during this time frame")
                        let alert = UIAlertController(title: "", message: "Fund purchase of amount Rs. 2 lakhs and above are not allowed between (2:15 PM to 3:00 PM). Please contact support for more information", preferredStyle: UIAlertControllerStyle.alert)
                        alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel, handler: { action in
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        } else {
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func bseRegisteredFlag(userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.isBSERegistered)\(userid)"
        print(url)
        presentWindow.makeToastActivity(message: "Loding..")
        if Connectivity.isConnectedToInternet{

            Alamofire.request(url).responseJSON { response in
                let data = response.result.value as? [String:String]
                if response.result.value != nil {
                if let bse_reg_status = data?["bse_reg"] {
                    print(bse_reg_status)
                    if bse_reg_status == "N" {
                        self.clientregistrationBse(userid: userid)
                    } else {
                        self.presentWindow.hideToastActivity()
                         if self.allowed_flag == true {
                            self.presentWindow.hideToastActivity()
                            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmTransactionViewController") as! ConfirmTransactionViewController
                            controller.cartObjects = self.cartObjects
                            controller.totalCartValue = self.totalCartValue
                            self.navigationController?.pushViewController(controller, animated: true)
                         }else {

                            ///here
                            if self.allowed_flag == false{
                                //check if flag has changed
                                //self.getFixedTimeInMillis(flag:"1",i:0,fromBtnProceed:true)
                                self.checkL1Allowed(time2pm: 0, time3pm: 0, flag: "0", i: 0,fromBtnProceed: true)

                            }


//                            if self.allowed_flag == false {
//                            let alert = UIAlertController(title: "", message: "Fund purchase of amount Rs. 2 lakhs and above are not allowed between (2:15 PM to 3:00 PM). Please contact support for more information", preferredStyle: UIAlertControllerStyle.alert)
//                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel, handler: { action in
//
//                            }))
//                            self.present(alert, animated: true, completion: nil)
//                            }
//                            else {
//                                print("$$$$ got o confirm Txn page")
//                            }

                        }
                    }
                }
                }else {

                    self.presentWindow.hideToastActivity()
                }

            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }

}

//#MARK: Cell Button Actions
extension CartViewController {

    @objc func btnStartDateDropDownTapped(sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Start Date Button Clicked")
        print(sender.tag)
        print(cartObjects.count)
        print(cartObjects)
        let cartObj = cartObjects[sender.tag]
        let SCHEMECODE = cartObj.SCHEMECODE
        self.getSchemaMonthly(code: SCHEMECODE, sender: sender)
    }

    @objc func btnMonthDropDownTapped(sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Sip Tenure Button Clicked")
        self.dropDownYear.anchorView = sender
        self.dropDownYear.dataSource = [Int](1...60).map{String($0)}
        self.dropDownYear.direction = .bottom
        self.dropDownYear.selectionAction = { [unowned self] (index: Int, item: String) in
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = self.tableview.cellForRow(at: indexPath) as! CheckOutTableViewCell
            cell.tfMonth.text = item
            self.cartObjects[sender.tag].cart_tenure = item
        }
        self.dropDownYear.show()
    }

    @objc func btnRemoveCartItemTapped(sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Remove Button Clicked")
        self.view.endEditing(true)
        if self.cartObjects.indices.contains(sender.tag) {
            let cartObj = self.cartObjects[sender.tag]
            if cartObj.isModify {
                let alert = UIAlertController(title: "Alert", message: "You have unsaved item in your cart, are you sure you want to delete it?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                    self.cartObjects[sender.tag].isModify = true
                    self.isEditingEnabled = false
                    self.removeCartObject(cartObjIndex: sender.tag)
                    Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Delete Item Yes Button Clicked")
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { action in
                    Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Delete Item No Button Clicked")
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Delete Item", message: "Do you want to delete this item?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                    self.cartObjects[sender.tag].isModify = true
                    self.isEditingEnabled = false
                    self.removeCartObject(cartObjIndex: sender.tag)
                    Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Delete Item Yes Button Clicked")
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { action in
                    Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Delete Item No Button Clicked")
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }

    @objc func btnTickTapped(sender: UIButton) {
        for i in 0..<cartObjects.count {
            cartObjects[i].isTicked = false
        }

        if sender.backgroundImage(for: .normal) == #imageLiteral(resourceName: "check-blue") {
            self.cartObjects[sender.tag].isTicked = false
            let indexPath = IndexPath(item: sender.tag, section: 0)
            tableview.reloadRows(at: [indexPath], with: .automatic)
            Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Sip Tenure Perpetual Button Unticked")
        } else {
            self.cartObjects[sender.tag].isTicked = true
            self.cartObjects[sender.tag].cart_tenure = "60"
            let indexPath = IndexPath(item: sender.tag, section: 0)
            tableview.reloadRows(at: [indexPath], with: .automatic)
            Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Sip Tenure Perpetual Button Ticked")
        }
    }

    @objc func btnModifyCartItemTapped(sender: UIButton) {

        let title = sender.currentTitle!
        switch title {

        case "  SAVE":
           Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Save Button Clicked")
            let indexPath = IndexPath(row: sender.tag, section: 0)
            let cell = self.tableview.cellForRow(at: indexPath) as! CheckOutTableViewCell
            print(Int(truncating: cartObjects[sender.tag].MININVT.numberValue!))
           if cell.tfAmmount.text?.first == "0"{
                let trim_amount = cell.tfAmmount.text?.dropFirst()
            cell.tfAmmount.text = String(trim_amount!)
           }
            if cell.tfAmmount.text == ""{
             presentWindow.makeToast(message: "Please Enter Amount")
             Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Please Enter Amount")
             cell.tfAmmount.resignFirstResponder()
           }
           else if cartObjects[sender.tag].cart_purchase_type == "Lumpsum" && Int(truncating: cartObjects[sender.tag].MININVT.numberValue!) > Int(truncating: cell.tfAmmount.text!.numberValue!) {
                presentWindow.makeToast(message: "Minimum amount should be \(cartObjects[sender.tag].MININVT.numberValue!)")
               Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Minimum amount should be \(cartObjects[sender.tag].MININVT.numberValue!)")
                cell.tfAmmount.resignFirstResponder()
           }else if cartObjects[sender.tag].cart_purchase_type == "SIP" && Int(truncating: cartObjects[sender.tag].SIPMININVT.numberValue!) > Int(truncating: cell.tfAmmount.text!.numberValue!) {
            presentWindow.makeToast(message: "Minimum amount should be \(cartObjects[sender.tag].SIPMININVT.numberValue!)")
            Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Minimum amount should be \(cartObjects[sender.tag].SIPMININVT.numberValue!)")
            cell.tfAmmount.resignFirstResponder()
           }else if cartObjects[sender.tag].cart_purchase_type == "Additional Purchase" && Int(truncating: cartObjects[sender.tag].MININVT.numberValue!) > Int(truncating: cell.tfAmmount.text!.numberValue!) {
            presentWindow.makeToast(message: "Minimum amount should be \(cartObjects[sender.tag].MININVT.numberValue!)")
            Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Minimum amount should be \(cartObjects[sender.tag].MININVT.numberValue!)")
            cell.tfAmmount.resignFirstResponder()
           }
            else{

                self.view.endEditing(true)
                self.isEditingEnabled = false
                totalCartValue = 0

                cartObjects[sender.tag].isModify = false
                let indexPathWithModify = IndexPath(row: sender.tag, section: 0)
                self.tableview.reloadRows(at: [indexPathWithModify], with: .none)
                //self.tableview.reloadData()

                let cartObj = cartObjects[sender.tag]
                self.calculateSIPDate(cartObj: cartObj)
                for i in 0..<cartObjects.count
                    //where cartObjects[sender.tag].isSelected == true
                {
                    totalCartValue = totalCartValue + Int(cartObjects[i].cart_amount)!
                    if cartObjects[i].isModify == true{
                        self.isEditingEnabled = true
                    }
                }
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
                let formattedNumber = numberFormatter.string(from: NSNumber(value:self.totalCartValue))
                guard let number = formattedNumber else {return}
                self.lblTotalAmount.text = "\(number)"

            }

        case "  MODIFY":
             Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Modify Button Clicked")
            self.isEditingEnabled = true

            for i in 0..<cartObjects.count {

                if cartObjects[i].isModify {
                  //  cartObjects[i].isModify = false
                    let indexPathWithModify = IndexPath(row: i, section: 0)
                    self.tableview.reloadRows(at: [indexPathWithModify], with: .none)
                } else {
                  //  cartObjects[i].isModify = false
                }
            }

            self.cartObjects[sender.tag].isModify = true

            let indexPath = IndexPath(row: sender.tag, section: 0)
            self.tableview.reloadRows(at: [indexPath], with: .none)

            let cell = self.tableview.cellForRow(at: indexPath) as! CheckOutTableViewCell
            cell.tfAmmount.isUserInteractionEnabled = true
            cell.tfAmmount.becomeFirstResponder()

        default:
            break
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {

        cartObjects[textField.tag].cart_amount = textField.text!
    }

    @IBAction func btnProccedToCheckOutTapped(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Proceed To Checkout Button Clicked")
        if self.isEditingEnabled {
            for i in 0..<cartObjects.count {
                print(cartObjects[i].isModify)

            }
            let alert = UIAlertController(title: "Alert", message: "You have unsaved item in your cart, please update them to continue!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: {action in
                Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Unsaved Item Ok Button Clicked")
            }))
            self.present(alert, animated: true, completion: nil)
        } else {

//            var userid = UserDefaults.standard.value(forKey: "userid")
//            if flag != "0"{
//                userid! = flag
//
//            }
//            else{
//                // flag = "0"
//                userid = UserDefaults.standard.value(forKey: "userid") as? String
//            }
            self.getUserProfileStat(onload: false)
            //self.bseRegisteredFlag(userid: userid as! String)
        }
    }


//    func getL1RowIndex() -> [Int] {
//        if self.today_is_holiday == false {
//            for (i,cartobj) in self.cartObjects.enumerated() {
//                //let indexPath = IndexPath(row: i, section: 0)
//                //let cell = self.tableview.cellForRow(at: indexPath) as! CheckOutTableViewCell
//                if cartobj.CLASSCODE != "24" {
//                    if let cart_amt = Int(cartobj.cart_amount) {
//                        if cart_amt > 200000 {
//                            l1Indices.append(i)
//                        }
//                    }
//                }
//            }
//        }
//        return l1Indices
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        if textField == c {
            if textField.text?.count == 0 && string == "0" {
                return false
            }else {
                let allowedCharacters = CharacterSet(charactersIn: "0123456789")
                let characterSet = CharacterSet(charactersIn: string)
                return allowedCharacters.isSuperset(of: characterSet)
            }
        //}
        return true
    }
    func todayIsHoliday(date:String, fromProceedBtn:Bool){
        //let url = "https://www.financialhospital.in/adminpanel/cron/cron_ws.php/fetchholidaylist"
        let url = "\(Constants.BASE_URL)\(Constants.API.fetchHolidayList)"

        Alamofire.request(url)
            .responseJSON { (response) in
                let resp = response.result.value as? [[String:Any]] ?? [[:]]
                for (_,response_data) in resp.enumerated(){
                    let rta_holiday_date = response_data["rta_holiday_date"] as? String ?? ""
                    print("\(date)  \(rta_holiday_date)")
                    if "\(date)" == rta_holiday_date {
                        self.today_is_holiday = true
                    }
                }
                if self.today_is_holiday == false {
                    for (index,cartobj) in self.cartObjects.enumerated() {
                        let indexPath = IndexPath(row: index, section: 0)
                        let cell = self.tableview.cellForRow(at: indexPath) as? CheckOutTableViewCell
                        print("CLASSCODE \(cartobj.CLASSCODE) AMT \(cartobj.cart_amount)")
                        if cartobj.CLASSCODE != "24" {
                            if let cart_amt = Int(cartobj.cart_amount) {
                                print(cart_amt)
                                if cart_amt >= 200000 {
                                    // let current_time = 1564655400  //10.30
                                   // self.allowed_flag = false

                                    self.getFixedTimeInMillis(flag:"1",i:index,fromBtnProceed: fromProceedBtn)
                                   // self.l1MessageView.isHidden = false

                                    //break

                                } else {
                                    cell?.layer.masksToBounds = true
                                    cell?.layer.cornerRadius = 5
                                    cell?.layer.borderWidth = 0
                                    cell?.layer.shadowOffset = CGSize(width: -1, height: 1)
                                    let borderColor: UIColor = .white
                                    cell?.layer.borderColor = borderColor.cgColor
                                    self.l1MessageView.isHidden = true
                                    self.l1MessageViewHeightConstraint.constant = 0
                                     self.allowed_flag = true
                                }
                            }
                        }
                        else {
                            self.allowed_flag = true
                            print("classcode is 24")
                            self.allowed_flag = true
                        }
                    }
                }else {
                    print("holiday flag is true")
                    self.allowed_flag = true
                }
        }

    }

//    func checkHoliday(){
//        print("checkHoliday called")
//
//        let url = "https://www.financialhospital.in/adminpanel/cron/cron_ws.php/fetchholidaylist"
//
//        print(url)
//        Alamofire.request(url)
//            .responseString { (response) in
//                let enc_response = response.result.value
//                var dict = [Dictionary<String,Any>]()
//                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
//                //if let enc = enc1?.base64Decoded() {
//                    dict = self.convertToDictionary(text: enc1 ?? "")
//                //} else{
//                 //   self.presentWindow.hideToastActivity()
//                //}
//                let data = dict
//                if let data = data as? [AnyObject]{
//                    if !data.isEmpty{
//                        for type in data{
//                            if let date = type.value(forKey: "rta_holiday_date") as? String {
//                                self.holidayDateArray.append(date)
//                            }
//                        }
//                        print(self.holidayDateArray)
//                        self.presentWindow.hideToastActivity()
//
//                        if self.holidayDateArray.count > 0 {
//                            let date = Date()
//                            let dateFormatter3 = DateFormatter()
//                            dateFormatter3.dateFormat = "yyyy-MM-dd"
//
//                            let strCurrentDate = dateFormatter3.string(from: date)
//                            print("^^^\(strCurrentDate)")
//
//                            for i in 0..<self.holidayDateArray.count {
//                                //let indexPath = IndexPath(row: i, section: 0)
//                                //let cell = self.tableview.cellForRow(at: indexPath) as! CheckOutTableViewCell
//                                //if strCurrentDate == self.holidayDateArray[i] {
//                                 if "2018-01-01" == self.holidayDateArray[i] {
//                                    self.holiday_flag = true
//                                    break
//                                }
//                                self.holiday_flag = false
//                            }
//                            if self.holiday_flag == false {
//                                for cartobj in self.cartObjects {
//                                    if cartobj.CLASSCODE != "24" {
//                                        if let cart_amt = Int(cartobj.cart_amount) {
//                                            if cart_amt > 200000 {
//                                               // let current_time = 1564655400  //10.30
//                                               self.getFixedTimeInMillis()
//
//                                            }
//                                        }
//                                    }
//                                }
//                            }else {
//                                print("holiday flag is true")
//                                return
//                            }
//                    }
//
//
//
//
//                    }
//                }
//        }
//    }
    func getFixedTimeInMillis(flag:String,i:Int,fromBtnProceed:Bool){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH-mm-ss"
        let date = Date()

        let dateFormatter3 = DateFormatter()
        dateFormatter3.dateFormat = "yyyy-MM-dd"
        let currentDateStr = dateFormatter3.string(from : date)
        print(currentDateStr)

        let currentDate = dateFormatter3.date(from: currentDateStr)

        let strCurrentDate = dateFormatter3.string(from: currentDate!)
        print("$$$\(strCurrentDate)")
        
        let result_date =  dateFormatter.date(from:"\(strCurrentDate) 18-10-00")
        let result_date1 =  dateFormatter.date(from:"\(strCurrentDate) 19-43-00")

        let timeInMilliseconds = result_date!.timeIntervalSince1970
        print(Int(timeInMilliseconds)*1000)
        print(dateFormatter.string(from:result_date!))

        let timeInMilliseconds1 = result_date1!.timeIntervalSince1970
        print(Int(timeInMilliseconds1)*1000)
        print(dateFormatter.string(from:result_date1!))

        checkL1Allowed(time2pm: Int(timeInMilliseconds), time3pm: Int(timeInMilliseconds1),flag:flag,i:i,fromBtnProceed:fromBtnProceed)


    }

    func checkL1Allowed(time2pm:Int, time3pm:Int,flag:String,i:Int,fromBtnProceed:Bool){
       // let url = "http://www.erokda.in/adminpanel/users/user_ws.php/getserverdatetime"

        let url = "\(Constants.BASE_URL)\(Constants.API.getserverdatetime)"
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url).responseJSON { (response) in
                if let resp = response.result.value as? [String:Any]{
                    let servertime = resp["server_time"] as? Int
                    let server_date = resp["server_date"] as? String ?? ""
                    print("servertime \(servertime),server_date \(server_date) ")
                    print("TIME:::\(time2pm) \(servertime!) \(time3pm)")
                    print(servertime! > time2pm && servertime! < time3pm)

                    let indexPath = IndexPath(row: i, section: 0)
                    let cell = self.tableview.cellForRow(at: indexPath) as? CheckOutTableViewCell
                    if flag == "1" {
                        if servertime! > time2pm && servertime! < time3pm {
                            cell?.layer.masksToBounds = true
                            cell?.layer.cornerRadius = 5
                            cell?.layer.borderWidth = 5
                            cell?.layer.shadowOffset = CGSize(width: -1, height: 1)
                            let borderColor: UIColor = .red
                            cell?.layer.borderColor = borderColor.cgColor
                            self.l1MessageView.isHidden = false
                            self.l1MessageViewHeightConstraint.constant = 30
                            let alert = UIAlertController(title: "", message: "Fund purchase of amount Rs. 2 lakhs and above are not allowed between (2:15 PM to 3:00 PM). Please contact support for more information", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.cancel, handler: { action in
                            }))
                            self.present(alert, animated: true, completion: nil)
                            self.allowed_flag = false
                        } else {
                            print("Allowed")
                            cell?.layer.masksToBounds = true
                            cell?.layer.cornerRadius = 5
                            cell?.layer.borderWidth = 0
                            cell?.layer.shadowOffset = CGSize(width: -1, height: 1)
                            let borderColor: UIColor = .white
                            cell?.layer.borderColor = borderColor.cgColor
                            self.l1MessageView.isHidden = true
                            self.l1MessageViewHeightConstraint.constant = 0
                            self.allowed_flag = true
                            self.presentWindow?.hideToastActivity()
                            if fromBtnProceed == true && !self.flag_next_page {
                                self.presentWindow.hideToastActivity()
                                let controller = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmTransactionViewController") as! ConfirmTransactionViewController
                                controller.cartObjects = self.cartObjects
                                controller.totalCartValue = self.totalCartValue
                                self.navigationController?.pushViewController(controller, animated: true)
                                self.flag_next_page = true
                            }


                        }
                    }else {
                        self.todayIsHoliday(date:server_date,fromProceedBtn:fromBtnProceed)
                    }
            }
        }
    } else {
        presentWindow.hideToastActivity()
        presentWindow?.makeToast(message: "No Internet Connection")
    }


    }

}

//#MARK: UITableViewDelegate
extension CartViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cartObjects.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("****cellForRowAt - table loaded")
        let cell = self.tableview.dequeueReusableCell(withIdentifier: "checkout", for: indexPath) as! CheckOutTableViewCell

        let cartObject = cartObjects[indexPath.row]

        cell.lblTitle.text = cartObject.S_NAME
        cell.lblMode.text = cartObject.cart_purchase_type

        var fullDateArr = cartObject.cart_added.components(separatedBy: " ")

        if fullDateArr.count > 0 {
            cell.lblTransactionDate.text = fullDateArr[0]
        } else {
            cell.lblTransactionDate.text = cartObject.cart_added
        }

        cell.tfStartDate.isUserInteractionEnabled = false
        cell.tfMonth.isUserInteractionEnabled = false
        cell.tfMonth.isEnabled = false
        cell.tfAmmount.delegate = self
        cell.selectionStyle = .none
        cell.btnDropDown.tag = indexPath.row
        cell.btnModify.tag = indexPath.row
        cell.btnRemove.tag = indexPath.row
        cell.btnStartDate.tag = indexPath.row
        cell.btnTick.tag = indexPath.row
        cell.fundSelectBtn.tag = indexPath.row


        if selectedRows.contains(indexPath){
            print("\(indexPath.row) \(cell.lblTitle.text!) in selectedRows show check")
           // cell.fundSelectBtn.imageView?.image = #imageLiteral(resourceName: "check-blue")
            cell.fundSelectBtn.setBackgroundImage(#imageLiteral(resourceName: "check-blue"), for: .normal)
        }
        else {
             print("\(indexPath.row) \(cell.lblTitle.text!) not in selectedRows show UNcheck")
            cell.fundSelectBtn.setBackgroundImage(#imageLiteral(resourceName: "square"), for: .normal)
            //cell.fundSelectBtn.imageView?.image = #imageLiteral(resourceName: "square")
        }

        cell.fundSelectBtn.addTarget(self, action: #selector(checkBoxSelection(_:)), for: .touchUpInside)

        cell.btnDropDown.addTarget(self, action: #selector(self.btnMonthDropDownTapped(sender:)), for: .touchUpInside)
        cell.btnRemove.addTarget(self, action: #selector(self.btnRemoveCartItemTapped(sender:)), for: .touchUpInside)
        cell.btnModify.addTarget(self, action: #selector(self.btnModifyCartItemTapped(sender:)), for: .touchUpInside)
        cell.btnStartDate.addTarget(self, action: #selector(self.btnStartDateDropDownTapped(sender:)), for: .touchUpInside)
        cell.btnTick.addTarget(self, action: #selector(self.btnTickTapped(sender:)), for: .touchUpInside)

        cell.tfMonth.isUserInteractionEnabled = false
        cell.tfMonth.isEnabled = false
        cell.tfAmmount.text = cartObject.cart_amount
        cell.tfAmmount.isUserInteractionEnabled = false
        cell.tfAmmount.tag = indexPath.row

        cell.tfAmmount.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        cell.btnTick.isHidden = true
        cell.lblPerpetual.isHidden = true
        let AMC_CODE =  cartObjects.contains{ $0.AMC_CODE == "400029" }
        if !AMC_CODE {
            labelView.isHidden = true
            sundarmView.constant = 0
        }else {
            labelView.isHidden = false
            sundarmView.constant = 30
        }

        if cartObject.cart_purchase_type == "Lumpsum" || cartObject.cart_purchase_type == "Additional Purchase" {

            cell.tfStartDate.text = "NA"
            cell.imgDropDownStartDate.isHidden = true
            cell.tfStartDate.borderStyle = .none
            cell.tfMonth.text = "NA"
            cell.tfMonth.borderStyle = .none
            cell.lblYears.isHidden = true
            cell.imgDropDownForSIP.isHidden = true

        } else {

            cell.tfStartDate.text = cartObject.cart_sip_start_date
            cell.imgDropDownStartDate.isHidden = false
            cell.tfStartDate.borderStyle = .roundedRect
            cell.tfMonth.text = cartObject.cart_tenure
            cell.tfMonth.borderStyle = .roundedRect
            cell.lblYears.isHidden = false
            cell.imgDropDownForSIP.isHidden = false
        }

        if cartObject.isModify {
            cell.btnModify.setTitle("  SAVE", for: .normal)

            if cartObject.cart_purchase_type == "Lumpsum" || cartObject.cart_purchase_type == "Additional Purchase" {
                cell.btnDropDown.isUserInteractionEnabled = false
                cell.btnDropDown.isEnabled = false
            } else {
                cell.tfMonth.textColor = UIColor.black
                if cartObject.cart_purchase_type == "SIP" {
                    cell.btnTick.isHidden = false
                    cell.lblPerpetual.isHidden = false
                } else {
                    cell.btnTick.isHidden = true
                    cell.lblPerpetual.isHidden = true
                }

                if cartObject.isTicked {
                    cell.btnTick.setBackgroundImage(#imageLiteral(resourceName: "check-blue"), for: .normal)
                    cell.btnDropDown.isUserInteractionEnabled = false
                    cell.btnDropDown.isEnabled = false
                } else {
                    cell.btnDropDown.isUserInteractionEnabled = true
                    cell.btnDropDown.isEnabled = true
                    cell.btnTick.setBackgroundImage(#imageLiteral(resourceName: "square"), for: .normal)
                }
            }
            cell.tfAmmount.isUserInteractionEnabled = true
        } else {
            cell.btnModify.setTitle("  MODIFY", for: .normal)
            cell.btnDropDown.isUserInteractionEnabled = false
            cell.tfAmmount.isUserInteractionEnabled = false
            if cartObject.cart_purchase_type == "Lumpsum" || cartObject.cart_purchase_type == "Additional Purchase" {
                cell.tfMonth.textColor = UIColor.black
            } else {
                cell.tfMonth.textColor = UIColor.lightGray
            }
        }

        if cell.tfStartDate.text == "NA" {
          cell.btnStartDate.isUserInteractionEnabled = false
        } else {
          cell.btnStartDate.isUserInteractionEnabled = true
        }

        let whiteRoundedView : UIView = UIView(frame: CGRect(x:5, y:5, width:Int(self.view.frame.size.width - 10), height:260))
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.shadowOffset = CGSize(width:-1, height:1)
        whiteRoundedView.layer.shadowOpacity = 0.1
        // cell.expandTransact.tag = indexPath.row
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        return cell
    }

    @objc func checkBoxSelection(_ sender:UIButton) {
        print("checkBoxSelection called")
        let selectedIndexPath = IndexPath(row: sender.tag, section: 0)
        if self.selectedRows.contains(selectedIndexPath) {
            self.selectedRows.remove(at: self.selectedRows.index(of: selectedIndexPath)!)
            self.cartObjects[selectedIndexPath.row].isSelected = false
        }
        else {
            self.selectedRows.append(selectedIndexPath)
            self.cartObjects[selectedIndexPath.row].isSelected = true
        }

        if selectedRows.count != self.cartObjects.count
        {
            selectAllBtn.setBackgroundImage(#imageLiteral(resourceName: "square"), for: .normal)
        }
        else {
            selectAllBtn.setBackgroundImage(#imageLiteral(resourceName: "check-blue"), for: .normal)
        }
        self.tableview.reloadData()
    }

    func getAllIndexPaths() -> [IndexPath] {
        var indexPaths: [IndexPath] = []

        for j in 0..<self.tableview.numberOfRows(inSection: 0) {
            indexPaths.append(IndexPath(row: j, section: 0))
        }
        return indexPaths
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return 240
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
                let enc_response = response.result.value ?? ""
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                if let data = data as? [AnyObject]{
                    if !data.isEmpty{
                        for type in data{
                            if let _ = type.value(forKey: "fatca_id") as? String,
                                let _ = type.value(forKey: "fatca_networth") as? String, let _ = type.value(forKey: "fatca_networth_date") as? String , let _ = type.value(forKey: "fatca_politically_exposed") as? String,let _ = type.value(forKey: "fatca_nationality") as? String,let _ = type.value(forKey: "fatca_other_nationality") as? String,let _ = type.value(forKey: "fatca_tax_resident") as? String ,let _ = type.value(forKey: "fatca_resident_country") as? String,let _ = type.value(forKey: "fatca_tax_player_id") as? String,let _ = type.value(forKey: "fatca_id_type") as? String,let _ = type.value(forKey: "fatca_resident_country_1") as? String, let _ = type.value(forKey: "fatca_tax_player_id_1") as? String,let _ = type.value(forKey: "fatca_id_type_1") as? String,let _ = type.value(forKey: "fatca_resident_country_2") as? String,let _ = type.value(forKey: "fatca_tax_player_id_2") as? String,let _ = type.value(forKey: "fatca_id_type_2") as? String{

                                self.fatca_detail_flag = true
                                //  natinalitytf.text = ""


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
}
