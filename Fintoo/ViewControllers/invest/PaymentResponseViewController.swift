//
//  PaymentResponseViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 06/09/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//


import UIKit
import Alamofire
import WebKit
import Mixpanel

class PaymentResponseViewController: BaseViewController,UIWebViewDelegate{
    var trnsarr = ""
    var titles : String!
    var totalCartValue = 0
    var cartSIPTotal = 0
    var selectedBank: getBankObj?
    var transactionObject = [gettransactiondetailsObject]()
    var isNeft = "0"
    var status = "D"
    var id = "0"
    var doc_id = ""
    var userDataArr = [UserDataObj]()
    var cartObjects = [CartObject]()
    var shouldCheckForNext = true
    var transaction_date_sms = ""
    var mandateid = ""
    var mandate_type = ""
    var fileName = ""
    var path = ""
    
    var upload_mandate_arr = [MandateDocDetail]()
    
    var paymentSuccessMessage = "A"
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var isipNoteHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var isipNoteView: UIView!
    @IBOutlet weak var totalAmount: UILabel!
    @IBOutlet weak var isipNoteLabel: UILabel!
    @IBOutlet weak var tfUploadMandate: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var downloadMandateForm: UIView!
    
    @IBOutlet weak var paymentSuccessMsgLabel: UILabel!
    @IBOutlet weak var downloadMandateHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadMandateFormHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadMandateFormView: UIView!
    @IBOutlet weak var paymentSuccessViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var downloadMandateTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var uploadMandateFormTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var totalAmountTopConstraint: NSLayoutConstraint!
    
    
    
    //@IBOutlet weak var paymentSuccessMsgLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        
        self.title = titles
        wkWebView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        
        download()
        

        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var wkWebView: UIWebView!
  
  
    override func viewWillAppear(_ animated: Bool) {
        
        if mandate_type != "" && mandate_type != "isip" {
            for cartObj in cartObjects {
                
                if shouldCheckForNext {
                    let type = cartObj.cart_purchase_type
                    if type == "Lumpsum" || type == "Additional Purchase" {
                        shouldCheckForNext = true
                        self.downloadMandateHeightConstraint.constant = 0
                        self.uploadMandateFormHeightConstraint.constant = 0
                        self.downloadMandateTopConstraint.constant = 0
                        self.uploadMandateFormTopConstraint.constant = 0
                        downloadMandateForm.isHidden = true
                        uploadMandateFormView.isHidden = true
                       // totalAmountTopConstraint.constant = 20
                        adjustMainHeight()
                    } else {
                        shouldCheckForNext = false
                        downloadMandateForm.isHidden = false
                        uploadMandateFormView.isHidden = false
                        self.uploadMandateFormHeightConstraint.constant = 150
                        self.downloadMandateHeightConstraint.constant = 170
                        self.downloadMandateTopConstraint.constant = 20
                        self.uploadMandateFormTopConstraint.constant = 20
                        adjustMainHeight()
                    }
                }
            }
        }else {
            self.downloadMandateHeightConstraint.constant = 0
            self.uploadMandateFormHeightConstraint.constant = 0
            self.downloadMandateTopConstraint.constant = 0
            self.uploadMandateFormTopConstraint.constant = 0
            
            self.isipNoteView.isHidden = false
            self.isipNoteHeightConstraint.constant = 80
            self.isipNoteLabel.text = "NOTE : Kindly ensure to register the Mandate ID as Biller ID in your internet banking account under Bill Pay facility - Biller name as BSE Ltd., with AUTO PAY within 7 days. Mandate ID \(self.mandateid) for Amount Rs. \(cartSIPTotal) with \(selectedBank?.bank_name ?? "")"

            downloadMandateForm.isHidden = true
            uploadMandateFormView.isHidden = true
           // totalAmountTopConstraint.constant = 20
            adjustMainHeight()
        }
        
//        tableViewHeightConstraint.constant = CGFloat(cartObjects.count) * tableViewHeightConstraint.constant
//        print(tableViewHeightConstraint.constant,"table")
//         adjustMainHeight()
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
       //let url = "\(Constants.BASE_URL)\(Constants.API.userDoc)\(covertToBase64(text: userid!))/fintoo/1"
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
                    print(data,"getDocDetail")
                
                    if !dataArray.isEmpty {
                        for abc in dataArray{
                            let document_type = (abc as AnyObject).value(forKey: "dt_identifier") as? String
                            _ = (abc as AnyObject).value(forKey: "doc_address_proof_type") as? String
                            _ = (abc as AnyObject).value(forKey: "doc_sub_req_time") as? String
                            _ = (abc as AnyObject).value(forKey: "doc_sub_req") as? String
                            print(document_type)
                            if document_type == "aof"{
                                
//                                let doc_name = (abc as AnyObject).value(forKey: "doc_name") as? String
//                                let doc_id = (abc as AnyObject).value(forKey: "doc_id") as? String
//                                print(doc_id)
//                                self.aof_id  = doc_id ?? ""
//                                self.aof_doc_name = doc_name!
//                                self.viewAofOutlet.isHidden = false
//                                self.textFieldAof.text = self.aof_doc_name
//                                self.uploadAofOutlet.isEnabled = false
//                                self.uploadAofOutlet.alpha =  0.3
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
                        print("mandateid::: \(self.mandateid)")
                        for doc in self.upload_mandate_arr {
                            print("$$$ \(doc.doc_id)")
                            
                            if self.mandateid == doc.doc_id {
                                print("mandateid is equal to docid")
                                break
                            }
                        }
                    
                        if self.mandate_type == "xsip" {
                            var final_mand_id = ""
                            var final_mand_name = ""
                            
                            var row = 0
                            var mname_flag = 0
                            for doc in self.upload_mandate_arr {
                                
                                if doc.dt_identifier == "mandate" {
                                    let doc_mand_id = doc.doc_name.components(separatedBy: "-")

                                    if doc_mand_id.contains(self.mandateid) {
                                        final_mand_id = self.mandateid
                                        let name = doc.doc_name.replacingOccurrences(of: "unsigned", with: "")
                                        final_mand_name = "\(doc_mand_id)-mandate-\(name)"
                                        break
                                    }
                                }
                            }
                            
                        
                            self.addDocDetails(document_name: final_mand_name, doc_id: final_mand_id, type: "mandate", address_type: "", doc_sub_req: "", doc_sub_req_date: "", doc_sub_req_time: "")
                        }
                       
                        
                        //self.getUserBankDetails()
                    } else {
                        self.presentWindow.hideToastActivity()
                        print("empty")
                        //self.getUserBankDetails()
                        //self.uploadAofOutlet.isEnabled = true
                        //self.viewAofOutlet.isHidden = true
                        //self.uploadAofOutlet.alpha =  1
                    }
                }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    
     func adjustMainHeight() {
        let total1 = self.paymentSuccessViewHeightConstraint.constant + self.uploadMandateFormHeightConstraint.constant + self.downloadMandateHeightConstraint.constant + tableViewHeightConstraint.constant
        
        mainViewHeightConstraint.constant = total1 + self.downloadMandateTopConstraint.constant + self.uploadMandateFormTopConstraint.constant + 100
        print(mainViewHeightConstraint.constant)
    }
    func download(){
       
         //$urlnew=NEW_MONEY_MITRA_SITE_HTTP_URL."/generate_pdf/generate_sip_pdf.php?id=".base64_encode($id)."&action=gmsc&bank_id=".base64_encode($_SESSION['bankid'])."=&final_mandate=".base64_encode($_SESSION['mandate_max_amt']);
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        guard let bankObj = self.selectedBank else {return}
        let selectedBankID = bankObj.bank_id ?? ""
        let mandateAmmount = "\(cartSIPTotal)"
        
        var cartIDArray = [String]()
        for cartObj in self.cartObjects {
            cartIDArray.append(cartObj.cart_id)
        }
        let url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=gmsc"
        if Connectivity.isConnectedToInternet{
             presentWindow.makeToastActivity(message: "Loading...")
            Alamofire.request(url).responseString { response in
                print(response.result.value)
                
                self.getUserData()
                let response = response.result.value?.replacingOccurrences(of: "\n", with: "") ?? ""
                if response != "" {
                    let theFileName = (response as NSString).lastPathComponent
                    let prefixFilenameArr = response.components(separatedBy: "\(theFileName)")
                    self.fileName = theFileName
                    self.path = prefixFilenameArr[0]
                    
                    if self.paymentSuccessMessage == "S"{
                        self.paymentSuccessMsgLabel.text = "Payment Successful"
                    }else{
                        self.paymentSuccessMsgLabel.text = "Awaiting Payment Confirmation"
                    }
                }
                
            }
        }
        
    }
    override func viewWillLayoutSubviews() {
        super.updateViewConstraints()
        self.tableViewHeightConstraint?.constant = self.tableView.contentSize.height
        adjustMainHeight()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Payment Receipt Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    @IBAction func continueInvesting(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Payment Receipt Screen :- Continue Investing Button Clicked")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func downloadReceipt(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Payment Receipt Screen :- Download Receipt Button Clicked")
        tableView.reloadData()
        presentWindow.makeToastActivity(message: "Loading..")
        var html = "<html><body><div><img src='https://www.fintoo.in/img_new/Logo.png'></div><br><br><table border ='1' cellspacing='0' cellpadding='10'><thead><tr><th style='width:25%'>Fund Name</th><th style='width:15%'>Mode</th><th style='width:15%'>Date</th><th  style='width:10%'>SIP Tenure</th><th style='width:25%'>Bank</th><th style='width:15%'>Amount</th></tr></thead>"
       if transactionObject.count <= 5 {
        print(transactionObject.count)
            for i in 0..<transactionObject.count {
                var cart_purchase_type = ""
                if transactionObject[i].cart_purchase_type == "1"{
                    cart_purchase_type = "Lumpsum"
                } else if transactionObject[i].cart_purchase_type == "2"{
                    cart_purchase_type = "SIP"
                } else if  transactionObject[i].cart_purchase_type == "3" {
                    cart_purchase_type = "Additional Purchase"
                }
                html = html + "<tbody><tr> <td align='center'>\(transactionObject[i].S_NAME)</td> <td align='center'>\(cart_purchase_type)</td> <td data-label='Date'align='center'>\(transactionObject[i].transaction_date)</td> <td data-label='SIP Tenure' align='center'>\(transactionObject[i].cart_tenure )</td> <td align='center' data-label='Bank'>\(transactionObject[i].bank_name)</td> <td data-label='Amount' align='center'>\(transactionObject[i].cart_amount)</td></tr>"
                
            }
            html = html + "<tr><th colspan='5'>Total</th><th>\(totalAmount.text ?? "")</th></tr></tbody></table></body></html>"
            //print(html)
            wkWebView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
       } else{
         print("hello")
        }
        //self.loadIntoUIWebView(data)
    }
    
    @IBAction func downloadMandateButtonClick(_ sender: Any) {
            var userid = UserDefaults.standard.value(forKey: "userid") as? String
            if flag != "0"{
                userid! = flag
            } else{
                userid = UserDefaults.standard.value(forKey: "userid") as? String
            }
            guard let bankObj = self.selectedBank else {return}
            let selectedBankID = bankObj.bank_id ?? ""
            let mandateAmmount = "\(cartSIPTotal)"
            
            var cartIDArray = [String]()
            for cartObj in self.cartObjects {
                cartIDArray.append(cartObj.cart_id)
            }
            
            self.presentWindow.makeToastActivity(message: "Loading...")
            print(self.userDataArr[0].mobile)
            var url = ""
            if self.userDataArr[0].mobile != "" && self.userDataArr[0].email != "" {
                let memberid = UserDefaults.standard.value(forKey: "memberid") as? String ?? "0"
                let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
                if memberid != "0" && memberid != parent_user_id {
                    userid! = flag
                    let phone = self.userDataArr[0].mobile
                    let email = self.userDataArr[0].email
                    print(email)
                    let email_mobile = phone! + "|" + email!
                    url = "\(Constants.API.getUsedMandateForm)\(userid!.convertToBase64())&bank_id=\(selectedBankID.convertToBase64())&cid=\(cartIDArray.joined(separator: ",").convertToBase64())&final_mandate=\(mandateAmmount.convertToBase64())&action=app&aData=\(email_mobile.convertToBase64())&member=1"
                    print(url,"mandate")
                    //presentWindow.hideToastActivity()
                } else{
                    let phone = self.userDataArr[0].mobile
                    let email = self.userDataArr[0].email
                    let email_mobile = phone! + "|" + email!
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
    
    func showFileWithPath(path: String){
        let isFileFound:Bool? = FileManager.default.fileExists(atPath: path)
        if isFileFound == true{
            let viewer = UIDocumentInteractionController(url: URL(fileURLWithPath: path))
            viewer.delegate = self
            presentWindow.hideToastActivity()
            viewer.presentPreview(animated: true)
        }
    }
    
    @IBAction func btnUploadMandateTapped(_ sender: Any) {
        self.getDocDetail()
        //pickDoc()
        
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
                    }
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func pickDoc(){
        
        let documentPicker = UIDocumentPickerViewController(documentTypes:["public.image", "public.composite-content", "public.text"], in: .import)
        documentPicker.delegate = self
        documentPicker.modalPresentationStyle = .formSheet
        present(documentPicker, animated: true, completion: nil)
    }
    func uploadDocs(doc_value:String,doc_ext:String,doc_name:String){
        
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
                "enc_resp":"3",
                "mandate_filename":doc_name
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
                                
                                if self.mandate_type == "xsip" {
                                    var final_mand_id = ""
                                    var final_mand_name = ""
                                    
                                    var row = 0
                                   
                                    for doc in self.upload_mandate_arr {
                                        if doc.dt_identifier == "mandate" {
                                            print(doc.doc_id)
                                            // let doc_mand_id = doc.doc_name.split(separator: "-")
                                            let doc_mand_id = doc.doc_name.components(separatedBy: "-")
                                            
                                            if doc_mand_id.count > 1 && //self.MandateObjlist[row].latest_mandate_id == doc_mand_id[1] {
                                                doc_mand_id.contains(self.mandateid) {
                                                final_mand_id = self.mandateid
                                                
                                                let name = doc.doc_name.replacingOccurrences(of: "unsigned", with: "")
                                                final_mand_name = "\(self.mandateid)-mandate-\(name)"
                                                //self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
                                                break
                                            }
                                            
                                        }
                                    }
                                    
                                   
                                   
                                    self.addDocDetails(document_name: final_mand_name, doc_id: final_mand_id, type: "mandate", address_type: "", doc_sub_req: "", doc_sub_req_date: "", doc_sub_req_time: "")
                                    // self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
                                    
                                    Mixpanel.mainInstance().track(event: "Additional Details : Mandate Uploaded Successfully")
                                }
                                else {
                               
                                    self.addDocDetails(document_name: doc_name, doc_id: self.mandateid, type: "mandate", address_type: "", doc_sub_req: "", doc_sub_req_date: "", doc_sub_req_time: "")
                                   // self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
                                
                                    Mixpanel.mainInstance().track(event: "Additional Details : Mandate Uploaded Successfully")
                                }
                                
                                    }
                                }
                            }
                        }
                    }
            else{
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
                    if enc == "\"true\""{
                            //self.presentWindow.hideToastActivity()
                        self.tfUploadMandate.text = document_name
                       // self.addMandateForForSelectedBank(document_name: document_name,scan_mandate_flag:"1")
                        self.updateLatestBankMandate( doc_name: document_name, doc_id: doc_id)
                    } else {
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
                    
                    
            }
        } else {
            self.presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func updateLatestBankMandate(doc_name:String,doc_id:String) {
        
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
                "id":"\(userid!.covertToBase64())",
                "document_name":"\(doc_name)",
                "bankid":"\(selectedBank?.bank_id!)",
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
                        self.ScanMandateImageUpload()
                        
                    }
                    else {
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
                    
            }
        }
    }
    
    func ScanMandateImageUpload(){
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let bankid = selectedBank?.bank_id! ?? ""
        let url = "\(Constants.BASE_URL)\(Constants.API.scanmandateimageupload)\(userid!)/\(bankid)"
        print(url)
        Alamofire.request(url).responseJSON { response in
            let data =  response.result.value as? [String:Any]
            print(data!)
            if data?["bse_err_status"] != nil && data?["bse_err_status"] as? String  == "FAIL" {
                let alert = UIAlertController(title: "Alert", message: "\(data!["bse_err_status"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                    print("Ok button clicked")
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                    self.navigationController?.pushViewController(destVC, animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
            }else{ //success
                print("else scanMandateImageUpload")
          
            }
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
                "bank_current_txn_limit":"",
               // "bank_current_txn_limit": self.lblMandateAmount2.text!.components(separatedBy: " ").last ?? "",
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
                        self.ScanMandateImageUpload(userid: userid!, bank_id: self.selectedBank?.bank_id ?? "")
                        //self.updatemandatetype(userid: userid!, bank_id: self.selectedBank?.bank_id ?? "", mandate_type: "xsip", scan_mandate_flag: "1")
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
                        self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
                        self.downloadMandateHeightConstraint.constant = 0
                        self.uploadMandateFormHeightConstraint.constant = 0
                        self.downloadMandateTopConstraint.constant = 0
                        self.uploadMandateFormTopConstraint.constant = 0
                        self.downloadMandateForm.isHidden = true
                        self.uploadMandateFormView.isHidden = true
                        //self.totalAmountTopConstraint.constant = 20
                        self.adjustMainHeight()
//                        let name = UserDefaults.standard.value(forKey: "name") ?? ""
//                        let email = UserDefaults.standard.value(forKey: "Email") ?? ""
//                        let address = self.UserObjects[0].flat_no + " " + self.UserObjects[0].building_name + " " + self.UserObjects[0].road_street + " " + self.UserObjects[0].address + " " + self.city_name + " " + self.state_name + " " + self.country_name + "-" + self.UserObjects[0].pincode
//                        let fullname = self.UserObjects[0].name + " " +  self.UserObjects[0].middle_name + " " + self.UserObjects[0].last_name
//                        if self.btnPickup.currentImage == #imageLiteral(resourceName: "check") {
//                            self.send_otp_on_Email(ToEmailID: "support@fintoo.in", FromEmailID: "\(email)", Body: "Hey Team,The documents for \(name), registered with email id\(email) have been picked up.Kindly review this and pass this to the concerned department, so that due diligence is done", Subject: "Documents picked up for \(name) on Fintoo")
//                            //8976565077
//                            let dateFormatter1 = DateFormatter()
//                            dateFormatter1.dateFormat = "yyyy-MM-dd"
//                            let startTime = dateFormatter1.date(from: "\(self.tfDate.text!)")
//                            dateFormatter1.dateFormat = "MMMM dd, yyyy"
//
//                            print(dateFormatter1.string(from: startTime!))
//                            let date_time = dateFormatter1.string(from: startTime!) + " " + self.tfTiming.text!
//                            self.send_otp_on_mobile(mobile_number: "8976565077", msg: "\(fullname) has placed pickup document request - Address: \(address) Date: \(date_time)", fourDigit: "")
//                        }
//                        else if self.btnCourier.currentImage == #imageLiteral(resourceName: "check"){
//
//                            self.send_otp_on_mobile(mobile_number: "8976565077", msg: "\(fullname) with address: \(address) has selected courier option so no need to go there for document collection.", fourDigit: "")
//                        }
                    } else {
                        self.presentWindow.hideToastActivity()
                    }
                    
                }
            }
        }
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        let render = UIPrintPageRenderer()
        render.addPrintFormatter(webView.viewPrintFormatter(), startingAtPageAt: 0);
        
        let page = CGRect(x: 0, y: 0, width: 595.2, height: 841.8)
        //let page = CGRect(x: 0, y: 10, width: webView.frame.size.width, height: webView.frame.size.height) // take the size of the webView
        let printable = page.insetBy(dx: 0, dy: 0)
        render.setValue(NSValue(cgRect: page), forKey: "paperRect")
        render.setValue(NSValue(cgRect: printable), forKey: "printableRect")
        
        // 4. Create PDF context and draw
        let pdfData = NSMutableData()
        UIGraphicsBeginPDFContextToData(pdfData, CGRect.zero, nil)
        for i in 1...render.numberOfPages {
            
            UIGraphicsBeginPDFPage();
            let bounds = UIGraphicsGetPDFContextBounds()
            render.drawPage(at: i - 1, in: bounds)
        }
        UIGraphicsEndPDFContext();
        let documentsPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        
        print(documentsPath)
        
       // pdfData.write(toFile: "\(documentsPath)/pdfName.pdf", atomically: true)
        
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("fintoo-receipt.pdf")
        print(docURL)
        pdfData.write(to: docURL as URL, atomically: true)
        presentWindow.hideToastActivity()
        self.showFileWithPath(path: docURL.path)
    }
    
    func gettransactiondetails(trnsarr:String){
        
        let url = "\(Constants.BASE_URL)\(Constants.API.gettransactiondetails)/\(trnsarr)"
        print(url)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url).responseJSON { response in
                //self.presentWindow.hideToastActivity()
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
                            self.totalCartValue = self.totalCartValue + Int(cart_amount)!
                            let cart_tenure = transactionIdData["cart_tenure"] as? String ?? ""
                            let cart_tenure_perpetual = transactionIdData["cart_tenure_perpetual"] as? String ?? ""
                            let bank_name = transactionIdData["bank_name"] as? String ?? ""
                            let bank_acc_no = transactionIdData["bank_acc_no"] as? String ?? ""
                            let cart_payout_opt = transactionIdData["cart_payout_opt"] as? String ?? "N/A"
                            self.transaction_date_sms = transaction_date
                            let bse_reg_order_id = transactionIdData["bse_reg_order_id"] as? String ?? ""
                            var cart_payout_opt1 = ""
                            if cart_payout_opt == "" {
                                cart_payout_opt1 = "N/A"
                            }
                            let transactionObj = gettransactiondetailsObject(S_NAME: S_NAME,cart_purchase_type: cart_purchase_type,transaction_id: transaction_id, transaction_date: transaction_date, cart_id: cart_id, cart_amount: cart_amount, cart_tenure: cart_tenure, cart_tenure_perpetual: cart_tenure_perpetual, bank_name: bank_name, bank_acc_no: bank_acc_no, bse_reg_order_id: bse_reg_order_id,cart_payout_opt:cart_payout_opt1)
                            
                            self.transactionObject.append(transactionObj)
                        }
                        self.tableView.reloadData()
                        self.presentWindow.hideToastActivity()
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = NumberFormatter.Style.decimal
                        let formattedNumber = numberFormatter.string(from: NSNumber(value:self.totalCartValue))
                        guard let number = formattedNumber else {return}
                        self.totalAmount.text = "₹ \(number)"
                        
                        self.sendPaymentSuccessEmailToUser(username: self.userDataArr[0].fname ?? "", email: self.userDataArr[0].email ?? "", amount: "\(number)");
                        if self.mandateid != "" {
                            self.sendMandateRegisterEmailToUser(username: self.userDataArr[0].fname ?? "", email: self.userDataArr[0].email ?? "", mandate_id: self.mandateid)
                            self.getDocDetail()
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
    func pdfDataWithTableView(tableView: UITableView) {
        presentWindow.makeToastActivity(message: "Loading..")
         tableView.tableHeaderView = UIImageView(image: UIImage(named: "logo"))
            let footer = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 160))
            footer.backgroundColor = UIColor.clear
            let lbl = UILabel(frame: CGRect(x: 0, y: 30, width: UIScreen.main.bounds.width, height: 70))
            lbl.backgroundColor = UIColor.clear
            lbl.text = "Thank you choosing Fintoo for valuable investing."
            lbl.numberOfLines = 2
            lbl.textAlignment = .left
        
            lbl.font = UIFont(name: "Helvetica Neue", size: 14.0) //font size and style
            lbl.textColor = UIColor.black
            let lbl1 = UILabel(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70))
            lbl1.backgroundColor = UIColor.clear
            lbl1.text = "Total: \(totalCartValue)"
            lbl1.numberOfLines = 0
            lbl1.textAlignment = .left
            lbl1.font = UIFont(name: "Helvetica Neue-Bold", size: 17.0) //font size and style
            lbl1.textColor = UIColor.black
            footer.addSubview(lbl1)
            footer.addSubview(lbl)
        
       
        tableView.tableFooterView = footer
        let priorBounds = tableView.bounds
        
        let fittedSize = tableView.sizeThatFits(CGSize(width:priorBounds.size.width, height:tableView.contentSize.height))
        tableView.bounds = CGRect(x:0, y:0, width:fittedSize.width, height:fittedSize.height)
        let pdfPageBounds = CGRect(x:0, y:0, width:tableView.frame.width, height:self.view.frame.height)
        
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, pdfPageBounds,nil)
        var pageOriginY: CGFloat = 0
        while pageOriginY < fittedSize.height {
            UIGraphicsBeginPDFPageWithInfo(pdfPageBounds, nil)
            UIGraphicsGetCurrentContext()!.saveGState()
            UIGraphicsGetCurrentContext()!.translateBy(x: 0, y: -pageOriginY)
            tableView.layer.render(in: UIGraphicsGetCurrentContext()!)
            UIGraphicsGetCurrentContext()!.restoreGState()
            pageOriginY += pdfPageBounds.size.height
        }
        UIGraphicsEndPDFContext()
        tableView.bounds = priorBounds
        var docURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL
        docURL = docURL.appendingPathComponent("fintoo-receipt.pdf")
        print(docURL)
        pdfData.write(to: docURL as URL, atomically: true)
        self.showFileWithPath(path: docURL.path)
        
    }
    
    
}

//MARK: UIDocumentPickerDelegate
extension PaymentResponseViewController: UIDocumentPickerDelegate{
    
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
                    
//                    if self.isMandateTappedForUpload {
//                        self.tfUploadAOF.text = "\(fileNameWithoutExtension).\(fileExtension)"
//                    } else {
//                        self.textFieldAof.text = "\(fileNameWithoutExtension).\(fileExtension)"
//                    }
                    self.tfUploadMandate.text = "\(fileNameWithoutExtension).\(fileExtension)"
                    var final_mand_id = ""
                    var final_mand_name = ""
                    
                    for doc in self.upload_mandate_arr {
                        if doc.dt_identifier == "mandate" {
                            print(doc.doc_id)
                            // let doc_mand_id = doc.doc_name.split(separator: "-")
                            let doc_mand_id = doc.doc_name.components(separatedBy: "-")
                            
                            if doc_mand_id.count > 1 && //self.MandateObjlist[row].latest_mandate_id == doc_mand_id[1] {
                                doc_mand_id.contains(self.mandateid) {
                                final_mand_id = self.mandateid
                                
                                let name = doc.doc_name.replacingOccurrences(of: "unsigned", with: "")
                                final_mand_name = "\(self.mandateid)-mandate-\(name)"
                                //self.presentWindow.makeToast(message: "Mandate Uploaded Successfully")
                                break
                            }
                            
                        }
                    }
                    
                    
                    
                    self.uploadDocs(doc_value: base64str, doc_ext: fileExtension,doc_name:final_mand_name)
                }
                
                
            } catch{
                print(error)
            }
        }
        else{
            self.tfUploadMandate.text = ""
            presentWindow.makeToast(message: "Invalid file type (Allowed file types are jpg, jpeg)")
            Mixpanel.mainInstance().track(event: "Additional Details : Invalid file type (Allowed file types are jpg, jpeg)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        self.tfUploadMandate.text = ""
    }
}

//#MARK: @IBActions
extension PaymentResponseViewController: UIDocumentInteractionControllerDelegate {
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        UINavigationBar.appearance().tintColor = UIColor.black
        return self
    }
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        print("done btn")
//        tableView.tableHeaderView = UIImageView(image: UIImage(named: ""))
//        tableView.tableFooterView?.isHidden = true
        tableView.reloadData()
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
                    let enc1 = enc_response?.replacingOccurrences(of: " " , with: "")
                    let enc = enc1?.base64Decoded()
                    print(response.result.value ?? "")
                    if enc ==  "\"true\""{
                        print("Success")
                        //self.fetchTransactionIdData(trnsarr:trns_arr)
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
    func sendMandateRegisterEmailToUser(username:String,email:String,mandate_id:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            
            
            let parameters = [
                "ToEmailID":"\(email.covertToBase64())",
                "FromEmailID":"",
                "Subject" :"\(covertToBase64(text: "\(mandate_type.uppercased()) Mandate Registration Success"))",
                "template_name": "\(covertToBase64(text: "\(mandate_type)mandateregister"))",
                "username":"\(username.covertToBase64())",
                "mandateid":"\(mandate_id.covertToBase64())",
                "mandateamount":"\(cartSIPTotal)",
                "mandatebank":"\(selectedBank?.bank_name ?? "")",
                "mandatedatetime":"",
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
                            self.presentWindow!.makeToast(message: "Failed To Send Email On Mobile")
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
    func sendPaymentSuccessEmailToUser(username:String,email:String,amount:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            var tableContent = ""
           // if self.cartObjects.count <= 5 {
                for i in 0..<transactionObject.count{
                    var ctype = ""
                    if transactionObject[i].cart_purchase_type == "2" {
                        ctype  = "SIP"
                    }else if transactionObject[i].cart_purchase_type == "1" {
                        ctype  = "Lumpsum"
                    }else {
                        ctype  = "Additional Purchase"
                    }
                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(transactionObject[i].S_NAME)</td><td data-label='Type'>\(ctype)</td><td data-label='Type'>\(transactionObject[i].cart_payout_opt)</td><td data-label='Amount'>\(transactionObject[i].cart_amount)</td></tr>"
                }
//            }
//            else{
//                let first5 = self.cartObjects.prefix(5)
//                for i in 0..<first5.count{
//                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
//                }
//            }
            var parameters = [String:Any]()
            if mandate_type == "xsip" {
                if isNeft == "1" {
                    //email = "tabassumbanumusa@gmail.com"
                     parameters = [
                        "ToEmailID":"\(email)",
                        "FromEmailID":"support@fintoo.in",
                        "Subject" :"Your purchase request has been submitted successfully - Fintoo",
                        "template_name": "neftpayment",
                        "username":"\(username)",
                        "tableContent":"\(tableContent)",
                        "amount":"\(amount)",
                        "neft_note":"<b>Note :</b> If you dont complete your NEFT payment till tomorrow your order will be reversed.",
                        "filename":"\(self.fileName)",
                        "path":"\(self.path)"
                        
                    ]
                } else {
                    parameters = [
                        "ToEmailID":"\(email)",
                        "FromEmailID":"support@fintoo.in",
                        "Subject" :"Your purchase request has been submitted successfully - Fintoo",
                        "template_name": "txnsuccess",
                        "username":"\(username)",
                        "tableContent":"\(tableContent)",
                        "filename":"\(self.fileName)",
                        "path":"\(self.path)"
                    ]
                }
            }else {
                if isNeft == "1" {
                    //email = "tabassumbanumusa@gmail.com"
                    parameters = [
                        "ToEmailID":"\(email)",
                        "FromEmailID":"",
                        "Subject" :"Your purchase request has been submitted successfully - Fintoo",
                        "template_name": "neftpayment",
                        "username":"\(username)",
                        "tableContent":"\(tableContent)",
                        "amount":"\(amount)",
                        "neft_note":"<b>Note :</b> If you dont complete your NEFT payment till tomorrow your order will be reversed."
                        
                    ]
                } else {
                    parameters = [
                        "ToEmailID":"\(email)",
                        "FromEmailID":"",
                        "Subject" :"Your purchase request has been submitted successfully - Fintoo",
                        "template_name": "txnsuccess",
                        "username":"\(username)",
                        "tableContent":"\(tableContent)"
                    ]
                }
            }
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
          //  if self.cartObjects.count <= 5 {
                for i in 0..<transactionObject.count{
                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(transactionObject[i].S_NAME)</td><td data-label='Type'>\(transactionObject[i].cart_purchase_type)</td><td data-label='Type'>\(transactionObject[i].cart_payout_opt)</td><td data-label='Amount'>\(transactionObject[i].cart_amount)</td></tr>"
                }
//            }
//            else{
//                let first5 = self.cartObjects.prefix(5)
//                for i in 0..<first5.count{
//                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
//                }
//            }
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
                        self.gettransactiondetails(trnsarr: self.trnsarr)
                    }
                }
                
            }
        }
            
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    func sendPaymentFailureEmailToUser(username:String,email:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        var tableContent = ""
        if Connectivity.isConnectedToInternet{
            //if self.cartObjects.count <= 5 {
                for i in 0..<cartObjects.count{
                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
                }
//            }
//            else{
//                let first5 = self.cartObjects.prefix(5)
//                for i in 0..<first5.count{
//                    print(cartObjects[i].cart_purchase_type)
//                    tableContent = tableContent + "<tr class='outertr'><td data-label='Fund Name'>\(cartObjects[i].S_NAME)</td><td data-label='Type'>\(cartObjects[i].cart_purchase_type)</td><td data-label='Amount'>\(cartObjects[i].cart_amount)</td></tr>"
//                }
//            }
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
}
//#MARK: UITableViewDelegate
extension PaymentResponseViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionObject.count
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewWillLayoutSubviews()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "responce", for: indexPath) as! responseCell
        if transactionObject[indexPath.row].cart_purchase_type == "1"{
            cell.modeLabel.text = "Lumpsum"
        } else if transactionObject[indexPath.row].cart_purchase_type == "2"{
            cell.modeLabel.text = "SIP"
        } else if transactionObject[indexPath.row].cart_purchase_type == "3"{
            cell.modeLabel.text = "Additional Purchase"
        }
        cell.fundName.text = transactionObject[indexPath.row].S_NAME
        cell.dateLabel.text = transactionObject[indexPath.row].transaction_date
        cell.sipTenure.text = transactionObject[indexPath.row].cart_tenure
        cell.bankNameLabel.text = transactionObject[indexPath.row].bank_name
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_IN")
        formatter.numberStyle = .decimal
        let string = formatter.string(from: transactionObject[indexPath.row].cart_amount.numberValue!)
        cell.amountLabel.text = "₹ \(string ?? "")"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if shouldCheckForNext {
            return 200
        } else {
            return 260
        }
        
    }
    
}
class responseCell : UITableViewCell{
    @IBOutlet weak var fundName: UILabel!
    @IBOutlet weak var modeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sipTenure: UILabel!
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
}
