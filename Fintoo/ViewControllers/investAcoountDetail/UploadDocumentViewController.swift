//
//  UploadDocumentViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 17/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
protocol uploadDocumentCellDelegate: class {
    func uploadFile(row:Int)
    func viewMandate(row: Int)
    func viewDownloadedMandate(row:Int)
    func uploadMandate(row:Int)
}

class UploadDocumentViewController: BaseViewController,UITableViewDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate,uploadDocumentCellDelegate,UITableViewDataSource,UIDocumentInteractionControllerDelegate {
    @IBOutlet weak var textFieldAof: UITextField!
    
    @IBOutlet weak var downloadAofOutlet: UIButton!
 
    @IBOutlet weak var uploadAofOutlet: UIButton!
    @IBOutlet weak var mandateMainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var mandateMainView: UIView!
    @IBOutlet weak var viewAofOutlet: UIButton!
    
    @IBOutlet weak var mandateTableView: UITableView!
    
    @IBOutlet weak var noMandatesLbl: UILabel!
    
    
    
    var userDataArr = [UserDataObj]()
    var aof_id = ""
    var aof_base_64_string:String!
    var aof_extensions :String!
    var aof_doc_name : String!
     var id : String!
    var count  : Int!
    var mandate_name : String!
    var upload_mandate_arr = [MandateDocDetail]()
    var index0 : String!
    var index1 : String!
    var index2 : String!
    var inadex_name_2 : String!
    var inadex_name_1 : String!
    var inadex_name_0 : String!
    var index0_ext : String!
    var index1_ext : String!
    var index2_ext : String!
    var fatca_detail_flag = false
    var MandateObjlist = [MandateObj]()
    var MandateIdArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setWhiteNavigationBar()
        addBackbutton()
        mandateTableView.delegate = self
        mandateTableView.dataSource =  self
        mandateTableView.separatorStyle = .none
        
        getDocDetail()
        getUserData()
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserFatcaDetails()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userBanklist.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "mandate", for: indexPath) as? uploadDocumentCell
         cell?.downloadMandateBtn.tag = indexPath.row
        cell?.uploadMandateBtn.tag = indexPath.row
        let bankidfound =  self.MandateObjlist.contains{ $0.transaction_bank_id == userBanklist[indexPath.row].bank_id }
        print(userBanklist[indexPath.row].bank_id,"bankid found",bankidfound,userBanklist[indexPath.row].bank_name,"bankname")
        if bankidfound {  //bankid found but mandates is blank
            if MandateObjlist[indexPath.row].mandates! == ["":""] {
                cell?.noMandateLbl.isHidden = false
                cell?.bankmandatetf.isHidden = true
                cell?.viewMandateForm.isHidden = true
                //cell?.uploadmandateoutlet.isHidden = true
                cell?.uploadMandateBtn.isHidden = true
                cell?.datemandateView.isHidden = true
                cell?.heightConstraintOfDateMandateView.constant = 0.0
            }
            else {   //bankid found mandates is not blank
                var convertedArray: [Date] = []
                
                var dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-mm-yyyy"
                
                for i in self.MandateObjlist[indexPath.row].m_dates!{
                    print(i.value)
                    let date = dateFormatter.date(from: i.value)
                    if let date = date {
                        convertedArray.append(date)
                    }
                    
                }
                
                var dates = Array(self.MandateObjlist[indexPath.row].m_dates!.values)
                for (id,date) in self.MandateObjlist[indexPath.row].m_dates! {
                    print(id,"id!!",date,"date!!")
                }
              if dates.count > 1 && dates[0] == dates[1]{
                
                    print( Array(MandateObjlist[indexPath.row].m_dates!.keys)[0])
                print("####same")
                print("$$")
                }
                
                
                 var strCurrentDate = ""
                var mandateID = ""
                let set = NSSet(array: convertedArray)
               // if set.count == 1{
                 if dates.count > 1 && dates[0] == dates[1] {
                    strCurrentDate = dateFormatter.string(from: convertedArray[0])
                    var mandateID = Array(MandateObjlist[indexPath.row].m_dates!.keys)[0]
                    var mandateName = MandateObjlist[indexPath.row].m_name![mandateID]
                    MandateObjlist[indexPath.row].latest_mandate_id = mandateID
                    if let name = MandateObjlist[indexPath.row].m_name![mandateID]{
                        print("^^^^^",mandateID,name)
                        MandateObjlist[indexPath.row].latest_mandate_name = name
                        cell?.bankmandatetf.text = MandateObjlist[indexPath.row].latest_mandate_name
                        cell?.mandateDateLabel.text = "\(strCurrentDate)"
                        cell?.mandateIdLabel.text = "\(mandateID)"
                    }
                    
                    
                    
                }else {
                    var ready = convertedArray.sorted(by: { $0.compare($1) == .orderedDescending })
                    print(ready)
                    
                    let strCurrentDate = dateFormatter.string(from: ready[0])
                    print("$$$\(strCurrentDate)")
                    cell?.mandateDateLabel.text = "\(strCurrentDate)"
                   
                    for i in MandateObjlist[indexPath.row].m_dates!{
                        if i.value == strCurrentDate {
                            print(i.key,"mandateid")
                            cell?.mandateIdLabel.text = "\(i.key)"
                            mandateID = "\(i.key)"
                            MandateObjlist[indexPath.row].latest_mandate_id = mandateID
                            
                            print(MandateObjlist[indexPath.row].m_name![mandateID])
                            
                            if let name = MandateObjlist[indexPath.row].m_name![mandateID]{
                                print("^^^^^",mandateID,name)
                                MandateObjlist[indexPath.row].latest_mandate_name = name
                                cell?.bankmandatetf.text = MandateObjlist[indexPath.row].latest_mandate_name
                            }
                            
                        }
                    }
                }

                
                cell?.datemandateView.isHidden = false
                cell?.heightConstraintOfDateMandateView.constant = 87.0
                
                ///
                //cell?.uploadmandateoutlet.isHidden = false
                //cell?.uploadMandateBtn.isHidden = false
                ///
                
                if mandateID != "" {
                    for i in self.MandateObjlist[indexPath.row].mandates! {
                        if i.key == mandateID {
                            print("view button \(i.value)")
                            let showViewButton = i.value
                            if showViewButton == "0" {
                                cell?.viewMandateForm.isHidden = true
                                //cell?.uploadmandateoutlet.isHidden = true
                                cell?.uploadMandateBtn.isHidden = true
                            }else {
                                cell?.viewMandateForm.isHidden = false
                                //cell?.uploadmandateoutlet.isHidden = false
                                cell?.uploadMandateBtn.isHidden = false
                            }
                        }
                    }
                }

                
            }
        }else {  //bank id not found
            cell?.datemandateView.isHidden = true
            cell?.noMandateLbl.isHidden = false
            cell?.bankmandatetf.isHidden = true
            cell?.viewMandateForm.isHidden = true
            //cell?.uploadmandateoutlet.isHidden = true
            cell?.uploadMandateBtn.isHidden = true
            cell?.heightConstraintOfDateMandateView.constant = 0.0
        }
    
        cell?.bankNameLabel.text = userBanklist[indexPath.row].bank_name
        cell?.uploadmandateoutlet.tag = indexPath.row
        cell?.viewMandateForm.tag = indexPath.row
        cell?.delegate = self
       // mandateMainView.isHidden = false
        //cell?.bankmandatetf.text = userBanklist[indexPath.row].bank_mandate_document
        if userBanklist.count < 2{
            mandateMainViewHeight.constant = 150.0
        } else if userBanklist.count <= 3 {
            mandateMainViewHeight.constant = 250.0
        } else{
             mandateMainViewHeight.constant = 0
        }
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
 
    @IBAction func downloadAof(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Download Aof Button Clicked")
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        var url = ""
        let memberid = UserDefaults.standard.value(forKey: "memberid") as? String ?? "0"
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        if userDataArr[0].mobile != "" && userDataArr[0].email != "" {
            if memberid != "0" && memberid != parent_user_id {
                userid! = flag
                let phone = userDataArr[0].mobile
                let email = userDataArr[0].email
                let email_mobile = phone! + "|" + email!
                url = "\(Constants.API.generateAOF)\(userid!.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())&member=1"
            } else{
                let phone = userDataArr[0].mobile
                let email = userDataArr[0].email
                let email_mobile = phone! + "|" + email!
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
            presentWindow.makeToast(message: "Please First Complete Personal Details!!")
            Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Please First Complete Personal Details!!")
        }
    }
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            presentWindow.hideToastActivity()
            viewer.presentPreview(animated: true)
        }
    }
    @IBAction func selectBankButton(_ sender: Any) {
        
    }
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
       
        UINavigationBar.appearance().tintColor = UIColor.black
        
        return self
    }
    func uploadDocs(doc_value:String,doc_ext:String,id:String,row:Int,document_name:String,doc_id:String){
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
         presentWindow.makeToastActivity(message: "Loading...")
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "doc_value":"\(doc_value)",
                "user_id":"\(userid!.covertToBase64())",
                "doc_ext":"\(doc_ext)",
                "enc_resp":"3",
                "mandate_filename":document_name
            ]
            //print(parameters)
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
                    self.presentWindow.hideToastActivity()
                   // let data = response.result.value
                    if let data = data as? [[String: AnyObject]] {
                        if data.indices.contains(0) {
                            let doc_name = data[0]["doc_name"] as? String ?? ""
                            let error = data[0]["error"] as? String ?? ""
                            if error.count > 0 {
                                self.presentWindow?.makeToast(message: "Something Went wrong!")
                            } else {
                                if id == "1"{
                                    print(doc_name)
                                    print(self.aof_id)
                                    self.addDocDetails(document_name: doc_name, doc_id: self.aof_id, type: "aof", address_type: "", doc_sub_req: "", doc_sub_req_date: "", doc_sub_req_time: "", id: "1",row:row)
                                    self.presentWindow.makeToast(message: "AOF Uploaded Successfully")
                                    Mixpanel.mainInstance().track(event: "Upload Documents Screen :- AOF Uploaded Successfully")
                                } else{
                                    print("addDocDetails - \(document_name) \(doc_id)")
                                    self.addDocDetails(document_name: "\(document_name)", doc_id: "\(doc_id)", type: "mandate", address_type: "", doc_sub_req: "", doc_sub_req_date: "", doc_sub_req_time: "", id: "3",row:row)
                                    self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
                                    Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Mandate Uploaded Successfully")
          
//                                        self.addDocDetails(document_name: "\(final_mand_name)", doc_id: "\(final_mand_id)", type: "mandate", address_type: "", doc_sub_req: "", doc_sub_req_date: "", doc_sub_req_time: "", id: "3",row:row)
//                                        self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
//                                        Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Mandate Uploaded Successfully")
                                    
                                 
//                                    self.addDocDetails(document_name: "\(doc_name)", doc_id: "", type: "mandate", address_type: "", doc_sub_req: "", doc_sub_req_date: "", doc_sub_req_time: "", id: "3",row:row)
//                                    self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
//                                    Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Mandate Uploaded Successfully")
//
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
    func addDocDetails(document_name:String,doc_id:String,type:String,address_type:String,doc_sub_req:String,doc_sub_req_date:String,doc_sub_req_time:String,id:String,row:Int){
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
         presentWindow.hideToastActivity()
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
                    print("&&&&&")
                    if enc == "\"true\""{
                    self.presentWindow.hideToastActivity()
                    print("@@@@@")
                        print("success@@@")
                        if id != "1"{
                            self.MandateObjlist[row].latest_mandate_id = doc_id
                            self.MandateObjlist[row].latest_mandate_name = document_name
                            self.mandateTableView.reloadData()
                            //self.addMandateForForSelectedBank(document_name: document_name,row:row)
                            self.updateLatestBankMandate(row: row, doc_name: document_name, doc_id: doc_id)
                        }
                        
                    }
                    else {
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func updateLatestBankMandate(row:Int,doc_name:String,doc_id:String) {
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        
        //presentWindow.makeToastActivity(message: "Loading...")
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "id":"\(userid!.covertToBase64())",
                "document_name":"\(doc_name)",
                "bankid":"\(MandateObjlist[row].transaction_bank_id!)",
                "mandate_id":"\(doc_id)",
                "mandate_type":"XSIP",
                //"enc_resp":"3"
            ]
            print(parameters)
            
            let url = "\(Constants.BASE_URL)\(Constants.API.addDoc)"
            Alamofire.request("\(url)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                   
                    print("&&&&&")
                    if enc1 == "\"true\""{
                        self.presentWindow.hideToastActivity()
                        print("mandate added for selected bank")
                        self.ScanMandateImageUpload(row:row)
                        
                    }
                    else {
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
            
            }
        }
    }
    
    func ScanMandateImageUpload(row:Int){
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let bankid = MandateObjlist[row].transaction_bank_id!
        let url = "\(Constants.BASE_URL)\(Constants.API.scanmandateimageupload)\(userid!)/\(bankid)"
        print(url)
         Alamofire.request(url).responseJSON { response in
            let data =  response.result.value as? [String:Any]
            
            print("\(data)")
            if data?["bse_err_status"] != nil && data?["bse_err_status"] as? String  == "FAIL" {
                let alert = UIAlertController(title: "Alert", message: "\(data!["bse_err_status"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                    print("Ok button clicked")
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                    self.navigationController?.pushViewController(destVC, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{
                print("success in ScanMandateImageUpload")
                self.mandateTableView.reloadData()
            }
        }
        
        
    }
    
    func addMandateForForSelectedBank(document_name: String,row:Int) {
        
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
                "id": "\(userid!)",
                "document_name": "\(document_name)",
                "bankid": userBanklist[row].bank_id ?? "",
                "bank_txn_limit": userBanklist[row].bank_txn_limit ?? "",
                "bank_current_txn_limit": userBanklist[row].bank_current_txn_limit ?? "",
                "enc_resp":"3"
                ] as [String : Any]
            print(parameters)
            Alamofire.request(url, method: .post, parameters: parameters , encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc = enc1?.base64Decoded()
                    print("&&&&&")
                    self.presentWindow.hideToastActivity()
                    if enc == "\"true\""{
                    _ = UserDefaults.standard.value(forKey: "Mobile") ?? ""
                        print("mandate added for selected bank")
                    } else {
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getDocDetail(){
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading...")
        //http://www.erokda.in/adminpanel/kyc/kyc_ws.php/UserDocDetails/120747/fintoo
        let url = "\(Constants.BASE_URL)\(Constants.API.userDoc)\(covertToBase64(text: userid!))/fintoo/3"
        print(url)
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
                //let data = response.result.value
                if let dataArray = data as? [[String: String]]{
                    if !dataArray.isEmpty {
                    for abc in dataArray{
                        let document_type = (abc as AnyObject).value(forKey: "dt_identifier") as? String
                        _ = (abc as AnyObject).value(forKey: "doc_address_proof_type") as? String
                        _ = (abc as AnyObject).value(forKey: "doc_sub_req_time") as? String
                        _ = (abc as AnyObject).value(forKey: "doc_sub_req") as? String
                        print(document_type)
                        if document_type == "aof"{
                             let doc_name = (abc as AnyObject).value(forKey: "doc_name") as? String
                             let doc_id = (abc as AnyObject).value(forKey: "doc_id") as? String
                            print(doc_id)
                             self.aof_id  = doc_id ?? ""
                            self.aof_doc_name = doc_name!
                            self.viewAofOutlet.isHidden = false
                            self.textFieldAof.text = self.aof_doc_name
                            self.uploadAofOutlet.isEnabled = false
                            self.uploadAofOutlet.alpha =  0.3
                        }
                        else if document_type == "mandate"{
                            let doc_id = (abc as AnyObject).value(forKey: "doc_id") as? String ?? ""
                            let doc_name = (abc as AnyObject).value(forKey: "doc_name") as? String ?? ""
                            let doc_type = (abc as AnyObject).value(forKey: "doc_type") as? String ?? ""
                            let doc_address_proof_type = (abc as AnyObject).value(forKey: "doc_address_proof_type") as? String ?? ""
                            let doc_other_address_type = (abc as AnyObject).value(forKey: "doc_other_address_type") as? String ?? ""
                            let doc_address_proof_expdate = (abc as AnyObject).value(forKey: "doc_address_proof_expdate") as? String ?? ""
                            let doc_user_id = (abc as AnyObject).value(forKey: "doc_user_id") as? String ?? ""
                            let doc_sub_req = (abc as AnyObject).value(forKey: "doc_sub_req") as? String ?? ""
                            let doc_sub_req_date = (abc as AnyObject).value(forKey: "doc_sub_req_date") as? String ?? ""
                            let doc_sub_req_time = (abc as AnyObject).value(forKey: "doc_sub_req_time") as? String ?? ""
                            let dt_identifier = (abc as AnyObject).value(forKey: "dt_identifier") as? String ?? ""
                            
                           // let mandateDocObj = MandateDocDetail(doc_id: doc_id, doc_name: doc_name, doc_type: doc_type, doc_address_proof_type: doc_address_proof_type, doc_other_address_type: doc_other_address_type, doc_address_proof_expdate: doc_address_proof_expdate, doc_user_id: doc_user_id, doc_sub_req: doc_sub_req, doc_sub_req_date: doc_sub_req_date, doc_sub_req_time: doc_sub_req_time, dt_identifier: dt_identifier)
                            self.upload_mandate_arr.append(MandateDocDetail(doc_id:doc_id, doc_name: doc_name, doc_type: doc_type, doc_address_proof_type: doc_address_proof_type, doc_other_address_type: doc_other_address_type, doc_address_proof_expdate: doc_address_proof_expdate, doc_user_id: doc_user_id, doc_sub_req: doc_sub_req, doc_sub_req_date: doc_sub_req_date, doc_sub_req_time: doc_sub_req_time, dt_identifier: dt_identifier))
                            
                        }
                        
                    }
                    self.getUserBankDetails()
                } else {
                    self.presentWindow.hideToastActivity()
                    print("empty")
                    self.getUserBankDetails()
                    self.uploadAofOutlet.isEnabled = true
                    self.viewAofOutlet.isHidden = true
                    self.uploadAofOutlet.alpha =  1
                }
            }
         }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
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
        
        
        
        print("@@@@@@@@@@@@\(url)","@@@@@@@@@@@")
        let file = "\(url)"
       
        let fileNameWithoutExtension = file.fileName()
        
        let fileExtension = file.fileExtension()
        print(fileNameWithoutExtension)
        print(fileExtension)
        //uploadpantf.text = fileNameWithoutExtension
        // Allowed file types are jpg, jpeg, png, pdf, tiff)
        if fileExtension == "jpg" || fileExtension == "JPG" ||  fileExtension == "jpeg" || fileExtension == "JPEG"  {
            
            
            var final_mand_id = ""
            var final_mand_name = ""
            if id != "1" {
            for doc in self.upload_mandate_arr {
                if doc.dt_identifier == "mandate" {
                    print(doc.doc_id)
                    // let doc_mand_id = doc.doc_name.split(separator: "-")
                    let doc_mand_id = doc.doc_name.components(separatedBy: "-")
                    var latest_id = self.MandateObjlist[count].latest_mandate_id
                    if doc_mand_id.count > 1 && //self.MandateObjlist[row].latest_mandate_id == doc_mand_id[1] {
                        doc_mand_id.contains(latest_id) {
                        final_mand_id = self.MandateObjlist[count].latest_mandate_id
                        
                        let name = fileNameWithoutExtension.replacingOccurrences(of: "unsigned", with: "")
                        final_mand_name = "\(self.MandateObjlist[count].latest_mandate_id)-mandate-\(name).\(fileExtension)"
                        //self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")

                        
                        break
                    }
                    
                }
            }
        }
    
            
            do {
                let data = try Data(contentsOf: url)
                let base64str = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
               
                if id == "1"{
                    aof_base_64_string  = base64str
                    aof_extensions = fileExtension
                    textFieldAof.text = fileNameWithoutExtension + "." + fileExtension
                    uploadDocs(doc_value: aof_base_64_string, doc_ext: aof_extensions, id: "1",row:10,document_name:final_mand_name,doc_id:"")
                }
                else if id == "2"{
                    mandate_name = fileNameWithoutExtension + "." + fileExtension
                    let index = IndexPath(row: count, section: 0)
                    let cell = mandateTableView.cellForRow(at: index) as? uploadDocumentCell
                    cell?.bankmandatetf.text = mandate_name
                    if count == 0{
                        index0 = base64str
                        inadex_name_0 = fileNameWithoutExtension + "." + fileExtension
                        index0_ext = fileExtension
                        uploadDocs(doc_value: index0, doc_ext: index0_ext, id: "",row:count,document_name:final_mand_name,doc_id:final_mand_id)
                    }
                     if count == 1{
                        index1 = base64str
                        inadex_name_1 = fileNameWithoutExtension + "." + fileExtension
                        index1_ext = fileExtension
                        uploadDocs(doc_value: index1, doc_ext: index1_ext, id: "",row:count,document_name:final_mand_name,doc_id:final_mand_id)
                    }
                    if count == 2{
                        index2 = base64str
                        inadex_name_2 = fileNameWithoutExtension + "." + fileExtension
                        index2_ext = fileExtension
                        uploadDocs(doc_value: index2, doc_ext: index2_ext, id: "",row:count,document_name:final_mand_name,doc_id:final_mand_id)
                    }

                }
                
                
            }
            catch{
                print(error)
            }
        }
        else{
            textFieldAof.text = ""
            presentWindow.makeToast(message: "Invalid file type (Allowed file types are jpg, jpeg)")
            Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Invalid file type (Allowed file types are jpg, jpeg)")
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        textFieldAof.text = ""
    }
    @IBAction func uploadAof(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Upload Aof Button Clicked")
       if userDataArr[0].mobile != "" && userDataArr[0].email != "" {
        pickDoc()
        id = "1"
       }else {
            presentWindow.makeToast(message: "Please First Complete Personal Details!!")
            Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Please First Complete Personal Details!!")
        }
    }
    
    @IBAction func viewAof(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Upload Documents Screen :- View Aof Button Clicked")
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        var url = ""
        let memberid = UserDefaults.standard.value(forKey: "memberid") as? String ?? "0"
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        if memberid != "0" && memberid != parent_user_id {
            userid = flag
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.getBankDoc)\(aof_doc_name!)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload&aData=\(email_mobile.convertToBase64())&member=1"
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid") as! String
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.getBankDoc)\(aof_doc_name!)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload&aData=\(email_mobile.convertToBase64())"
            
        }
        print(url)
        if Connectivity.isConnectedToInternet {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "DocumentWebViewController") as! DocumentWebViewController
            destVC.url = url
            self.navigationController?.pushViewController(destVC, animated: true)
        } else {
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    @IBAction func Save(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Save Button Clicked")
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        if self.fatca_detail_flag {
            self.bseRegisteredFlag(userid: userid as! String)
        } else {
            self.presentWindow.hideToastActivity()
            self.presentWindow.makeToast(message: "For further process, please fill personal details.")
        }
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
//        self.navigationController?.pushViewController(destVC, animated: true)
        
    }
    func getUserBankDetails(){
        userBanklist.removeAll()
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading..")
        let url = "\(Constants.BASE_URL)\(Constants.API.getBank)\(userid!)/fintoo/3"
        print(url)
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
                // print(response.result.value)
                if let data = data as? [AnyObject]{
                    self.presentWindow.hideToastActivity()
                    print(data.isEmpty)
                    if data.isEmpty != true{
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
                                let state = type.value(forKey: "state_name") as? String
                            {
                                print("********************************************")
                                print("good")
                                let city = type.value(forKey: "city_name") as? String
                                let min_acc_number = type.value(forKey: "min_acc_number") as? String ?? "0"
                                let max_acc_number = type.value(forKey: "max_acc_number") as? String ?? "0"
                                let isip_allow = type.value(forKey: "isip_allow") as? String ?? "0"
                                let bank_mandate_type = type.value(forKey: "bank_mandate_type") as? String ?? "XSIP"
                                let max_trxn_limit = type.value(forKey: "max_trxn_limit") as? String ?? ""
                                account_type_id = bank_type
                                if banks_bd_code != nil{
//                                    if bank_mandate_document != ""{
                                        userBanklist.append(getBankObj.getUserBank(bank_acc_no: bank_acc_no, bank_branch: bank_branch, bank_cancel_cheque: bank_cancel_cheque, bank_city: bank_city, bank_country: bank_country, bank_current_txn_limit: bank_current_txn_limit, bank_id: bank_id, bank_ifsc_code: bank_ifsc_code, bank_joint_holder: bank_joint_holder, bank_mandate: bank_mandate, bank_mandate_document: bank_mandate_document, bank_name: bank_name, bank_state: bank_state, bank_txn_limit: bank_txn_limit, bank_type: bank_type, banks_bd_code: banks_bd_code, micr_code: micr_code, single_survivor: single_survivor, txn_exst: txn_exst, country_name:country ,state_name: state, city_name: city ?? "", bank_razorpay_code: "0", bank_razorpay_code_user: "0", min_acc_number: min_acc_number, max_acc_number: max_acc_number, isip_allow: isip_allow,bank_mandate_type: bank_mandate_type, max_trxn_limit: max_trxn_limit))
                                        
//                                    }else{
//                                        self.mandateMainView.isHidden = true
//                                    }
                                }
                                
                                
                            }
                        }
                        self.getBankMandates()
                        
                        self.mandateTableView.isHidden = false
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        userBanklist.append(getBankObj.getUserBank(bank_acc_no: "", bank_branch: "", bank_cancel_cheque: "", bank_city: "", bank_country: "0", bank_current_txn_limit: "", bank_id: "", bank_ifsc_code: "", bank_joint_holder: "", bank_mandate: "", bank_mandate_document: "", bank_name: "Select Bank", bank_state: "", bank_txn_limit: "", bank_type: "0", banks_bd_code: "", micr_code: "", single_survivor: "", txn_exst: "", country_name: "india", state_name: "State", city_name: "City", bank_razorpay_code: "0", bank_razorpay_code_user: "0", min_acc_number: "8", max_acc_number: "18", isip_allow: "0",bank_mandate_type: "XSIP", max_trxn_limit: ""))
                        
                        self.mandateTableView.isHidden = true
                        self.mandateMainView.isHidden = true
                        self.mandateTableView.reloadData()
                    }
                    
                   // self.mandateTableView.reloadData()
                }
                
               print(self.count,"count")
            }
            
           
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        print(userid ?? "")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        presentWindow.makeToastActivity(message: "Loading...")
         let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(covertToBase64(text: userid as? String ?? ""))/3"
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
               // let data = response.result.value
                if data != nil{
                    // print(data)
                    self.presentWindow.hideToastActivity()
                    if let dataArray = data as? NSArray{
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
                            let income_slab_id = (abc as AnyObject).value(forKey: "income_slab") as? String
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
    
    func getBankMandates() {
        MandateObjlist.removeAll()
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Loading..")
        let url = "\(Constants.BASE_URL)\(Constants.API.getBankMandateDocs)\(userid!)/3"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                let data = response.result.value as? [String:Any]
                self.presentWindow.hideToastActivity()
                print(data?.isEmpty)
                if data?.isEmpty != true{
                    for bank in userBanklist {
                        if let mobj = data?[bank.bank_id!] as? [String:Any] {
                            let transaction_bse_mandate_id = mobj["transaction_bse_mandate_id"] as? String ?? ""
                            //data.value(forKey: "transaction_bse_mandate_id") as? String ?? ""
                            let transaction_bank_id = mobj["transaction_bank_id"] as? String ?? ""
                            let bank_name =  mobj["bank_name"] as? String ?? ""
                            let transaction_user_id =  mobj["transaction_user_id"] as? String ?? ""
                            let mandates =  mobj["mandates"] as? [String:String]  ?? ["":""]
                            let m_name =  mobj["mandate_name"] as? [String:String]  ?? ["":""]
                            let m_date =  mobj["mandate_date"] as? [String:String]  ?? ["":""]
                            
                            self.MandateObjlist.append(MandateObj(transaction_bse_mandate_id: transaction_bse_mandate_id, transaction_bank_id: transaction_bank_id, bank_name: bank_name, transaction_user_id: transaction_user_id, m_name: m_name, mandates: mandates, m_dates: m_date))
                        }
                        
                    }
                    
                            
                        
                }
                    self.presentWindow.hideToastActivity()
                    self.mandateTableView.reloadData()
                    
                
            }
        }
    }
    func uploadFile(row:Int){
        if userDataArr[0].mobile != "" && userDataArr[0].email != "" {
            if row == 0{
                pickDoc()
                count = row
                
            }
            else if row == 1{
                pickDoc()
                count = row
                
            }
            else if row == 2{
                pickDoc()
                count = row
                
            }
             id = "2"
        }else{
            presentWindow.makeToast(message: "Please First Complete Personal Details!!")
        }
        
       
    }
    func viewMandate(row: Int) {
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        var url = ""
        let memberid = UserDefaults.standard.value(forKey: "memberid") as? String  ?? "0"
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        let latest_man_doc = self.MandateObjlist[row].latest_mandate_name
        if memberid != "0" && memberid != parent_user_id{
            userid = flag
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            
            
            url = "\(Constants.API.getBankDoc)\(latest_man_doc)&path=1&userId=\(userid.convertToBase64())&action=globalfiledownload&aData=\(email_mobile.convertToBase64())&member=1"
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid") as! String
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.getBankDoc)\(latest_man_doc)&path=1&userId=\(userid.convertToBase64())&action=globalfiledownload&aData=\(email_mobile.convertToBase64())"

        }
        print(url)
        if Connectivity.isConnectedToInternet {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "DocumentWebViewController") as! DocumentWebViewController
            destVC.url = url
            self.navigationController?.pushViewController(destVC, animated: true)
        } else {
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
                    if data?["status"] != nil && data?["status"] as? String == "Error" {
                        let bse_err_msg =  data?["bse_err_msg"] as? String ?? "FAIL"
                        let alert = UIAlertController(title: "Alert", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.setValue(bse_err_msg.htmlToAttributedString, forKey: "attributedMessage")
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                            print("Ok button clicked")
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                            self.navigationController?.pushViewController(destVC, animated: true)
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
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    //redirect to user data detail
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                    self.navigationController?.pushViewController(destVC, animated: true)
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
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
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
    
    func viewDownloadedMandate(row:Int){

        let phone = userDataArr[0].mobile
        let email = userDataArr[0].email
        let email_mobile = phone! + "|" + email!
        
        let downloaded_mandate_name = MandateObjlist[row].latest_mandate_name
        //let mandate_name = MandateObjlist[row].m_name![MandateObjlist[row].latest_mandate_id]
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        var url = ""
        let memberid = UserDefaults.standard.value(forKey: "memberid") as! String
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        if memberid != "0" && memberid != parent_user_id{
            userid = flag
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.kycViewDoc)\(downloaded_mandate_name)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownloadaData=\(email_mobile.convertToBase64())&member=1"
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid") as! String
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.kycViewDoc)\(downloaded_mandate_name)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload&aData=\(email_mobile.convertToBase64())"
            
        }
        
//        print(url)
//        if Connectivity.isConnectedToInternet {
//            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//            let destVC = storyBoard.instantiateViewController(withIdentifier: "DocumentWebViewController") as! DocumentWebViewController
//            destVC.url = url
//            self.navigationController?.pushViewController(destVC, animated: true)
//        } else {
//            presentWindow?.makeToast(message: "No Internet Connection")
//        }
        
        print(url)
        self.presentWindow.makeToastActivity(message: "Downloading..")
        
        if Connectivity.isConnectedToInternet {
            
            //let destination = DownloadRequest.suggestedDownloadDestination(for : .documentDirectory)
            let destination: DownloadRequest.DownloadFileDestination = { _,_ in
                var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                documentsURL.appendPathComponent(downloaded_mandate_name)
                print("documentsURL \(documentsURL)")
                return (documentsURL, [.removePreviousFile])
                
            }
            
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
    
    
    func uploadMandate(row:Int){
        if userDataArr[0].mobile != "" && userDataArr[0].email != "" {
            if row == 0{
                pickDoc()
                count = row
                
            }
            else if row == 1{
                pickDoc()
                count = row
                
            }
            else if row == 2{
                pickDoc()
                count = row
                
            }
            id = "2"
        }else{
            presentWindow.makeToast(message: "Please First Complete Personal Details!!")
        }
    }
}
class uploadDocumentCell : UITableViewCell
{
     weak var delegate: uploadDocumentCellDelegate?
    @IBOutlet weak var mandateIdLabel: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var mandateDateLabel: UILabel!
    @IBOutlet weak var bankmandatetf: UITextField!
    @IBOutlet weak var heightConstraintOfDateMandateView: NSLayoutConstraint!
    
    @IBOutlet weak var datemandateView: UIView!
    @IBOutlet weak var uploadmandateoutlet: UIButton!
    @IBOutlet weak var viewMandateForm: UIButton!
    
    @IBOutlet weak var noMandateLbl: UILabel!
    @IBOutlet weak var downloadMandateBtn: UIButton!
    
    @IBOutlet weak var uploadMandateBtn: UIButton!
    @IBAction func uploadmandate(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Upload Documents Screen :- Upload Mandate Button Clicked")
        delegate?.uploadFile(row: sender.tag)
    }
    @IBAction func viewMandateForm(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Upload Documents Screen :- View Mandate Button Clicked")
        delegate?.viewMandate(row: sender.tag)
    }
    
    
    @IBAction func downloadMandateButtonClicked(_ sender: UIButton) {
        delegate?.viewDownloadedMandate(row: sender.tag)


    }
    
    
    @IBAction func uploadMandateButtonClicked(_ sender: UIButton) {
        delegate?.uploadFile(row: sender.tag)
    }
}

