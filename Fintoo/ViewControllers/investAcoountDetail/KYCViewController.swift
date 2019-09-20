//
//  KYCViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 21/05/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import FlexibleSteppedProgressBar
import Alamofire
import FSCalendar
import Mixpanel
class KYCViewController: BaseViewController,FlexibleSteppedProgressBarDelegate,UITextFieldDelegate,UIDocumentPickerDelegate,UINavigationControllerDelegate,FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource,FSCalendarDelegateAppearance,UIDocumentInteractionControllerDelegate,DemoDelegate {
    
    
    func demo(row: String) {
        print(row,"flat no data ******")
    }
    var is_verified = false
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var viewPan: UIButton!
    @IBOutlet weak var viewPhoto: UIButton!
    
    @IBOutlet weak var panLabel: UILabel!
    @IBOutlet weak var viewAddressProof: UIButton!
    
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var calenderMainView: UIView!
    @IBOutlet weak var addressProofLabel: UILabel!
    
    @IBOutlet weak var downloadKYc: UIButton!
    
    @IBOutlet weak var timingTableView: UITableView!
    
    @IBOutlet weak var addressTypeTableView: UITableView!
    
//    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
//        self.calendarHeightConstraint.constant = bounds.height
//        self.view.layoutIfNeeded()
//    }
    var pan_base_64_string : String!
    var pan_extensions : String!
    var id : String!
    var photo_base_64_string : String!
    var photo_extensions : String!
    var address_base_64_string : String!
    var address_extensions : String!
    var pan_doc_id : String!
    var photo_doc_id : String!
    var adproof_doc_id : String!
    let pickerView = UIPickerView()
    var datePicker = UIDatePicker()
    var doc_sub_req : String!
    var address_type_id = ""
    var time_id : String!
    var user_id_all = ""
     var userDataArr = [UserDataObj]()
    var addressArr = [getSelectAddressObj]()
    var countriesArr = ["Passport","Ration Card","Registered Lease/Sale Agreement of Residence","Driving License","Voter Identity Card","Latest Bank A/c Statement/Passbook","Latest Telephone Bill (only Land Line)","Latest Electricity Bill","Latest Gas Bill","Others"]
    var doc_sub_req_time = [timeSlotObj]()
    var fatca_detail_flag = false
    var personal_details_alert = false
    @IBOutlet weak var pickUpOutlet: UIButton!
    
    @IBOutlet weak var timintBtnOutlet: UIButton!
    @IBOutlet weak var dateBtnOutlet: UIButton!
    @IBOutlet weak var courierOutlet: UIButton!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var datetf: UITextField!
    
    @IBOutlet weak var timingLabel: UILabel!
    
    @IBOutlet weak var kycView: UIView!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var calender: FSCalendar!
    
    @IBOutlet weak var uploadpantf: UITextField!
    
    @IBOutlet weak var uploadphototf: UITextField!
    
    @IBOutlet weak var uploadAddressProoftf: UITextField!
    
    @IBOutlet weak var selectAddressType: UITextField!
    
    @IBOutlet weak var verifiedView: UIView!
    
    @IBOutlet weak var addressTypeBtn: UIButton!
    
    @IBOutlet weak var timingtf: UITextField!
    
    var backgroundColor = UIColor(red: 218.0 / 255.0, green: 218.0 / 255.0, blue: 218.0 / 255.0, alpha: 1.0)
    var progressColor = UIColor(red: 45.0 / 255.0, green: 180.0 / 255.0, blue: 232.0 / 255.0, alpha: 1.0)
    var textColorHere = UIColor(red: 153.0 / 255.0, green: 153.0 / 255.0, blue: 153.0 / 255.0, alpha: 1.0)
    var bgcolor = UIColor(red: 235.0 / 255.0, green: 235.0 / 255.0, blue: 235.0 / 255.0, alpha: 1.0)
    var maxIndex = -1
    @IBOutlet weak var progressBar: FlexibleSteppedProgressBar!
    override func viewDidLoad() {
        super.viewDidLoad()
     //   delegate.delegate = self
      //  calender.calendarWeekdayView.isHidden = false
        //calender.appearance.wee
        for weekday in calender.calendarWeekdayView.weekdayLabels{
            print(weekday.text!,"weekday")

       
        }
        //getUserData()
        doc_sub_req = "courier"
        datetf.text = ""
        timingtf.text = "Pickup Time"
       // calender.scope = .week

        //panLabel.text  = uploadpantf.text
        downloadKYc.underline()
        getKycStatus()
       
        addBackbutton()
        kycView.isHidden = true
        progressBar.numberOfPoints = 5
        // progressBar.heightAnchor.constraint(equalToConstant: 100)
        progressBar.lineHeight = 6
        progressBar.radius = 10
        progressBar.progressRadius = 10
        progressBar.progressLineHeight = 3
        progressBar.backgroundColor = bgcolor
        progressBar.delegate = self
        progressBar.completedTillIndex = 3
        progressBar.useLastState = true
        
        progressBar.lastStateCenterColor = progressColor
        progressBar.selectedBackgoundColor = progressColor
        
        progressBar.selectedOuterCircleStrokeColor = backgroundColor
        progressBar.lastStateOuterCircleStrokeColor = backgroundColor
        progressBar.currentSelectedCenterColor = progressColor
        progressBar.currentSelectedTextColor = progressColor
        progressBar.stepTextColor = textColorHere
        progressBar.currentIndex = 3
        
        selectAddressType.delegate = self
        datetf.delegate = self
        timingtf.delegate = self
        
        
       // calender
        calender.delegate = self
        calender.dataSource = self
        
        
        //calender.is
        timingTableView.delegate = self
        timingTableView.dataSource = self
        
        addressTypeTableView.delegate = self
        addressTypeTableView.dataSource = self
        
        
        timingTableView.isHidden = true
        addressTypeTableView.isHidden = true
        
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        timingTableView.flashScrollIndicators()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag,"textfield")
        
        if textField == selectAddressType{
            
            selectAddressType.inputView = pickerView
            //items = textField.tag
            pickerView.tag = 1
        }
        else if textField == datetf{
            pickUpDate(datetf)
        }
        else{
            timingtf.inputView = pickerView
            //items = textField.tag
            pickerView.tag = 2
        }
    }
    
  
   
   
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     didSelectItemAtIndex index: Int) {
        progressBar.currentIndex = index
        if index > maxIndex {
            maxIndex = index
            progressBar.completedTillIndex = maxIndex
        }
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     canSelectItemAtIndex index: Int) -> Bool {
        return true
    }
    
    func progressBar(_ progressBar: FlexibleSteppedProgressBar,
                     textAtIndex index: Int, position: FlexibleSteppedProgressBarTextLocation) -> String {
        if progressBar == self.progressBar  {
            if position == FlexibleSteppedProgressBarTextLocation.top {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                case 4: return ""
                default: return ""
                    
                }
            } else if position == FlexibleSteppedProgressBarTextLocation.bottom {
                switch index {
                    
                case 0: return ""
                case 1: return ""
                case 2: return ""
                case 3: return ""
                case 4: return ""
                default: return ""
                    
                }
                
            } else if position == FlexibleSteppedProgressBarTextLocation.center {
                switch index {
                    
                case 0: return "1"
                case 1: return "2"
                case 2: return "3"
                case 3: return "4"
                case 4: return "5"
                default: return ""
                    
                }
            }
        }
        
        return ""
    }
    override func onBackButtonPressed(_ sender: UIButton) {
         Mixpanel.mainInstance().track(event: "KYC Screen :- Back Button Clicked")
        if personal_details_alert == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
            navigationController?.popViewController(animated: true)
        }
       
        
        
    }

    @IBAction func pickup(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Pickup Button Clicked")
        doc_sub_req = "pickup"
        addressLabel.isHidden = true
        dateLabel.isHidden = false
        datetf.isHidden = false
        timingtf.isHidden = false
        timingLabel.isHidden = false
        dateBtnOutlet.isHidden = false
        courierOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
        pickUpOutlet.setImage(UIImage(named: "check"), for: .normal)

        timintBtnOutlet.isHidden = false
    }
    
    @IBAction func courier(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Courier Button Clicked")
        datetf.text = ""
        timingtf.text = "Pickup Time"
        doc_sub_req = "courier"
        addressLabel.isHidden = false
        dateLabel.isHidden = true
        datetf.isHidden = true
        timingtf.isHidden = true
        timingLabel.isHidden = true
        dateBtnOutlet.isHidden = true
        timingTableView.isHidden = true
        timintBtnOutlet.isHidden = true
        
        courierOutlet.setImage(UIImage(named: "check"), for: .normal)
        pickUpOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
    }
    
    @IBAction func uploadPan(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Upload Pancard Button Clicked")
         id = "1"
        if doc_sub_req == "courier" || (doc_sub_req == "pickup" && datetf.text != "" && timingtf.text != "Pickup Time"){
              pickDoc()
        }
        else{
            if datetf.text == ""{
                presentWindow.makeToast(message: "Please Enter Date")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Enter Date")
            }
            else{
                presentWindow.makeToast(message: "Please Select Timing")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Select Timing")
            }
        }
        
    }
    @IBAction func uploadPhoto(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Upload Photo Button Clicked")
        id = "2"
        if doc_sub_req == "courier" || (doc_sub_req == "pickup" && datetf.text != "" && timingtf.text != "Pickup Time"){
            
            pickDoc()
        }
        else{
            if datetf.text == ""{
                presentWindow.makeToast(message: "Please Enter Date")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Enter Date")
            }
            else{
                presentWindow.makeToast(message: "Please Select Timing")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Select Timing")
            }
        }
        //pickDoc()
        
       // uploadDocs(doc_value:photo_base_64_string,doc_ext:photo_extensions, id: "2")
        
    }
    @IBAction func uploadAddressProof(_ sender: Any) {
        //pickDoc()
        Mixpanel.mainInstance().track(event: "KYC Screen :- Upload Address Photo Button Clicked")
        print(selectAddressType.text)
         id = "3"
        if selectAddressType.text == "Select Type"{
            presentWindow.makeToast(message: "Please Select Address proof Type")
        }else if doc_sub_req == "courier" || (doc_sub_req == "pickup" && datetf.text != "" && timingtf.text != "Pickup Time") && selectAddressType.text != "Select Type" {
            pickDoc()
        }
        else{
            if datetf.text == ""{
                presentWindow.makeToast(message: "Please Enter Date")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Enter Date")
            }
            else if selectAddressType.text == "Select Type"{
                presentWindow.makeToast(message: "Please Select Address proof Type")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Select Address proof Type")
            }
            else{
                presentWindow.makeToast(message: "Please Select Timing")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Select Timing")
            }
        }
       
        
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
       //return Date()
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
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
        let pdfData  = NSData(contentsOfFile: file)
        print(pdfData)
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
                if id == "1"{
                    pan_base_64_string = base64str
                    pan_extensions = fileExtension
                    uploadpantf.text = fileNameWithoutExtension + "." + fileExtension
                    //panLabel.text = fileNameWithoutExtension + "." + fileExtension
                   // if doc_sub_req == "courier" || (doc_sub_req == "pickup" && datetf.text != ""){
                        uploadDocs(doc_value:pan_base_64_string,doc_ext:pan_extensions, id: "1")
//                    }
//                    else{
//                        presentWindow.makeToast(message: "Please Enter Date")
//                    }
                }
                else if id == "2"{
                    photo_base_64_string = base64str
                    photo_extensions =  fileExtension
                    uploadphototf.text = fileNameWithoutExtension + "." + fileExtension
                    //photoLabel.text = fileNameWithoutExtension + "." + fileExtension
                     uploadDocs(doc_value:photo_base_64_string,doc_ext:photo_extensions, id: "2")
                }
                else if id == "3"{
                    address_base_64_string = base64str
                    address_extensions = fileExtension
                    uploadAddressProoftf.text = fileNameWithoutExtension + "." + fileExtension
                   // addressProofLabel.text = fileNameWithoutExtension + "." + fileExtension
                    uploadDocs(doc_value:address_base_64_string,doc_ext:address_extensions, id: "3")
                }
                
                
            }
            catch{
                print(error)
            }
            // self.imageView.image = UIImage(data: data)
            
        }
        else{
            //uploadpantf.text = ""
            presentWindow.makeToast(message: "Invalid file type (Allowed file types are jpg, jpeg, png, pdf, tiff)")
        }
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Document Picker Cancel Button CLicked")
        if id == "1"{
           // uploadpantf.text = ""
            
        }
        else if id == "2"{
            //uploadphototf.text = ""
            }
        else if id == "3"{
            //uploadAddressProoftf.text = ""
        }
    }
   
    @IBAction func save(_ sender: Any) {
        //print(photo_base_64_string)
        print(doc_sub_req)
        Mixpanel.mainInstance().track(event: "KYC Screen :- Save Button CLicked")
        if is_verified
        {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            
            let destVC = storyBoard.instantiateViewController(withIdentifier: "FatcaDetailViewController") as! FatcaDetailViewController
            
            self.navigationController?.pushViewController(destVC, animated: true)
            
        } else {
            if doc_sub_req! != "courier" &&  datetf.text == ""{
                //if datetf.text == ""{
                presentWindow.makeToast(message: "Please Select Date")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Select Date")
                // }
            }
            else if doc_sub_req! != "courier" && timingtf.text == "Pickup Time"{
                presentWindow.makeToast(message: "Please Select Timing")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Select Timing")
            }
            else if uploadpantf.text == ""{
                presentWindow.makeToast(message: "Please Upload Pan Card")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Upload Pan Card")
            }
            else if uploadphototf.text == "" {
                 presentWindow.makeToast(message: "Please Upload Photo")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Upload Photo")
            }
            else if uploadAddressProoftf.text == "" {
                presentWindow.makeToast(message: "Please Upload Address Proof")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Upload Address Proof")
            }
            else if selectAddressType.text == "Select Type"{
                presentWindow.makeToast(message: "Please Select Address Type")
                Mixpanel.mainInstance().track(event: "KYC Screen :- Please Select Address Type")
            }
           
            else {
                if self.fatca_detail_flag {
                    self.bseRegisteredFlag(userid: user_id_all)
                } else {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "FatcaDetailViewController") as! FatcaDetailViewController
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
            }
        
        }
    }
    func uploadDocs(doc_value:String,doc_ext:String,id:String){
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as! String
        }
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "doc_value":"\(doc_value)",
                "user_id":"\(userid!)",
                "doc_ext":"\(doc_ext)",
                "enc_resp":"3"
            ]
            print(parameters)
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
                    print("@@@@@")
                   // let data = response.result.value
                   if let data = data as? [AnyObject]{
                        if data.isEmpty != true{
                            for type in data{
                                if let doc_name = type.value(forKey: "doc_name") as? String,
                                   let error = type.value(forKey: "error") as? String {
                                    print(doc_name)
                                    if error == ""{
                                        print("Success")
                                        print(id)
                                        if id == "1" {
                                            print(self.pan_doc_id)
                                            if self.pan_doc_id == nil{
                                                self.pan_doc_id = ""
                                            }
                                            if self.pan_doc_id != nil{
                                            // let file_name = uploadpantf.text! + "." + pan_extensions
                                              print(self.pan_doc_id,"pandocid")
                                                print(self.address_type_id,"addressid")
                                                print(self.doc_sub_req,"docsubreq")
                                                print(self.datetf.text!,"date")
                                                print(self.time_id,"time")
                                                print(id)
                                                if self.time_id == nil{
                                                    self.time_id = ""
                                                }
                                                self.addDocDetails(document_name: doc_name, doc_id: self.pan_doc_id!, type: "pan", address_type: self.address_type_id, doc_sub_req: self.doc_sub_req!, doc_sub_req_date: "\(self.datetf.text!)", doc_sub_req_time: self.time_id!,id:"\(id)")
                                                self.panLabel.text = doc_name
                                            }
                                        }
                                        if id == "2" {
                                            print(self.photo_doc_id)
                                            if self.photo_doc_id == nil{
                                                self.photo_doc_id = ""
                                            }
                                            if self.photo_doc_id != nil{
                                                
                                                if self.time_id == nil{
                                                    self.time_id = ""
                                                }
                                                self.addDocDetails(document_name: doc_name, doc_id: self.photo_doc_id!, type: "photo", address_type: self.address_type_id, doc_sub_req: self.doc_sub_req!, doc_sub_req_date: "\(self.datetf.text!)", doc_sub_req_time: self.time_id!,id:"\(id)")
                                                self.photoLabel.text = doc_name
                                            }
                                        }
                                        if id == "3"{
                                            if self.adproof_doc_id == nil{
                                                self.adproof_doc_id = ""
                                            }
                                            if self.doc_sub_req != ""{
                                            if self.adproof_doc_id != nil{
                                                if self.time_id == nil{
                                                    self.time_id = ""
                                                }
                                                self.addDocDetails(document_name: doc_name, doc_id: self.adproof_doc_id!, type: "adproof", address_type: self.address_type_id, doc_sub_req: self.doc_sub_req!, doc_sub_req_date: "\(self.datetf.text!)", doc_sub_req_time: self.time_id!,id:"\(id)")
                                                self.addressProofLabel.text = doc_name
                                            }
                                            }
                                        }
                                        
                                    }
                                    else{
                                        print("Failed")
                                        self.presentWindow?.makeToast(message: "Something Went wrong!")
                                    }
                                }
                            }
                        }
                    }
             }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getKycStatus(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        print(userid)
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let panid = UserDefaults.standard.value(forKey: "pan")
        presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.kycStatus)\(panid!)/\(userid!)/3"
        print(url)
        if Connectivity.isConnectedToInternet{
            
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
               // let data = response.result.value
                print(data)
                if let dataArray = data as? NSDictionary{
                    let status = dataArray.value(forKey: "status") as? String
                    if status! == "002" || status! == "102" || status! == "202" || status! == "302" || status! == "402"{
                        print("verified")
                        self.kycView.isHidden = false
                        self.verifiedView.isHidden = false
                        self.is_verified = true
                        //self.getUserData()
                    }
                    else{
                        self.kycView.isHidden = false
                        self.verifiedView.isHidden = true
                        print("Not verified")
                        self.getDocDetail()
                        self.getUserData()
                        
                    }
                    
                }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    func getDocDetail(){
         presentWindow.makeToastActivity(message: "Loading...")
        var userid = UserDefaults.standard.value(forKey: "userid")
        print(userid)
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.userDoc)\(covertToBase64(text: userid as! String))/fintoo/3"
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
                if let dataArray = data as? NSArray{
                    print(dataArray)
                    //print(dataArray.value(forKey: "name"))
                    if dataArray != []{
                        print("hello")
                    
                    for abc in dataArray{
                        let document_type = (abc as AnyObject).value(forKey: "dt_identifier") as? String
                        let doc_other_address_type = (abc as AnyObject).value(forKey: "doc_address_proof_type") as? String
                        let doc_sub_req_time = (abc as AnyObject).value(forKey: "doc_sub_req_time") as? String
                        let doc_sub_req = (abc as AnyObject).value(forKey: "doc_sub_req") as? String
                        let doc_sub_req_date1 = (abc as AnyObject).value(forKey: "doc_sub_req_date") as? String
                        if doc_sub_req != ""{
                            self.pickUpOutlet.isUserInteractionEnabled = false
                            self.courierOutlet.isUserInteractionEnabled = false
                            self.datetf.isEnabled = false
                            self.timintBtnOutlet.isEnabled = false
                            self.dateBtnOutlet.isEnabled = false
                            self.timingtf.isEnabled = false
                            if doc_sub_req == "pickup"{
                                self.doc_sub_req  = doc_sub_req!
                                self.courierOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
                                self.pickUpOutlet.setImage(UIImage(named: "check"), for: .normal)
                                self.addressLabel.isHidden = true
                                self.dateLabel.isHidden = false
                                self.datetf.isHidden = false
                                self.timingtf.isHidden = false
                                self.timingLabel.isHidden = false
                                self.dateBtnOutlet.isHidden = false
                                self.timintBtnOutlet.isHidden = false
                                self.datetf.text = doc_sub_req_date1!
                            }
                            else{
                                self.doc_sub_req  = doc_sub_req!
                                self.courierOutlet.setImage(UIImage(named: "check"), for: .normal)
                                self.pickUpOutlet.setImage(UIImage(named: "uncheck"), for: .normal)
                                //self.pickUpOutlet.setImage(UIImage(named: "check"), for: .normal)
                                self.addressLabel.isHidden = false
                                self.dateLabel.isHidden = true
                                self.datetf.isHidden = true
                                self.timingtf.isHidden = true
                                self.timingLabel.isHidden = true
                                self.dateBtnOutlet.isHidden = true
                                self.timintBtnOutlet.isHidden = true
                                
                                }
                            
                        }
                        else{
                            self.pickUpOutlet.isUserInteractionEnabled = true
                            self.courierOutlet.isUserInteractionEnabled = true
                            self.datetf.isEnabled = true
                            self.timintBtnOutlet.isEnabled = true
                            self.timingtf.isEnabled = true
                            self.dateBtnOutlet.isEnabled = true
                        }
                       
                        self.time_id = doc_sub_req_time!
                        print(document_type)
                        if document_type == "pan"{
                            let pan_doc_name = (abc as AnyObject).value(forKey: "doc_name") as? String
                            self.uploadpantf.text = pan_doc_name!
                            self.panLabel.text  = pan_doc_name!
                            self.pan_doc_id = (abc as AnyObject).value(forKey: "doc_id") as! String
                            print(self.pan_doc_id)
                            if  doc_other_address_type != nil{
                                self.address_type_id = doc_other_address_type!
                                self.viewPan.isHidden = false
                            }
                            else{
                                self.address_type_id = ""
                                self.viewPan.isHidden = true
                            }
                        }
                        else if document_type == "photo"{
                            let photo_doc_name = (abc as AnyObject).value(forKey: "doc_name") as? String
                            self.uploadphototf.text = photo_doc_name!
                            self.photoLabel.text = photo_doc_name!
                        
                            self.photo_doc_id = (abc as AnyObject).value(forKey: "doc_id") as! String
                            if  doc_other_address_type != nil{
                                self.address_type_id = doc_other_address_type!
                            }
                            else{
                                self.address_type_id = ""
                            }
                        }
                        else if document_type == "adproof"{
                            let adproof_doc_name = (abc as AnyObject).value(forKey: "doc_name") as? String
                            self.uploadAddressProoftf.text = adproof_doc_name!
                            self.adproof_doc_id = (abc as AnyObject).value(forKey: "doc_id") as! String
                            print(doc_other_address_type)
                            self.addressProofLabel.text =  adproof_doc_name!
                            if  doc_other_address_type != nil{
                                self.address_type_id = doc_other_address_type!
                                self.selectAddressType.isEnabled = false
                                self.addressTypeBtn.isUserInteractionEnabled = false
                            }
                            else{
                                self.address_type_id = ""
                                self.selectAddressType.isEnabled = true
                                 self.addressTypeBtn.isUserInteractionEnabled = true
                            }
                        }
                        
                    }
                    
                    self.getSelectAddressType()
                    self.getTimeSlot()
                    }
                    else{
                        self.pan_doc_id = ""
                        self.adproof_doc_id = ""
                        self.photo_doc_id = ""
                        self.adproof_doc_id = ""
                        self.address_type_id = ""
                        self.viewPan.isHidden = true
                        self.viewPhoto.isHidden = true
                        self.viewAddressProof.isHidden = true
                        self.getSelectAddressType()
                        self.getTimeSlot()
                    }
                }
                
      
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    func addDocDetails(document_name:String,doc_id:String,type:String,address_type:String,doc_sub_req:String,doc_sub_req_date:String,doc_sub_req_time:String,id:String){
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
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
                        print("success@@@")
                        
                    }
                    else {
                        self.presentWindow.makeToast(message: "Something Went Wrong!!")
                    }
                }
            }
                    
                    
            
        
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        let weekday = Calendar.current.component(.weekday, from: date)
        print(weekday)
        if weekday == 1 || weekday == 7 {
           // calendar.appearance.titleWeekendColor = UIColor.red
            //return false
        }
       // return true
    }
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        let weekday = Calendar.current.component(.weekday, from: date)
        print(weekday)
        if weekday == 1 || weekday == 7 {
        
            return false
        }
        return true
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        
        let weekday = Calendar.current.component(.weekday, from: date)
        print(weekday)
        if weekday == 1 || weekday == 7 {
           
            
                return UIColor.darkGray
            }
            else{
                return nil
            }
        
    }
    func pickUpDate(_ textField : UITextField){
        
        // DatePicker
        
        // Mixpanel.mainInstance().track(event: "Premium Calculator :-Picking Date")
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        
        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        //datePicker.date
        //datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 10, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .weekday, value: 1, to: Date())
        //  let calcAge = calendar.dateComponents(.year,from:birthdayDate!, to: now, options: [])
        // let age = calcAge.year
        //  let age = calcAge.year
        print(datePicker.minimumDate)
        textField.inputView = self.datePicker
        
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(MydetailsViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(MydetailsViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolBar
        print("hiiii")
    }
    @objc func doneClick() {
        
        Mixpanel.mainInstance().track(event: "KYC Screen :- Date Done Clicked")
        let dateFormatter1 = DateFormatter()
        //yyyy-MM-dd
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        //dateFormatter1.dateStyle = .medium
        //  dateFormatter1.timeStyle = .none
        
        datetf.text = dateFormatter1.string(from: datePicker.date)
        datetf.resignFirstResponder()
    }
    @objc func cancelClick() {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Cancel Done Clicked")
        //Mixpanel.mainInstance().track(event: "Premium Calculator :-Date Cancel Pressed")
        datetf.text = ""
        datetf.resignFirstResponder()
    }
    func addNotification(){
        
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let dateFormatter1 = DateFormatter()
        //yyyy-MM-dd
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        //dateFormatter1.dateStyle = .medium
        //  dateFormatter1.timeStyle = .none
        
        datetf.text = dateFormatter1.string(from: date)
        calenderMainView.isHidden = true
        calendar.isHidden = true
      //  datetf.resignFirstResponder()
    }
    
    func getUserData(){
        presentWindow.makeToastActivity(message: "Loading...")
        var userid = UserDefaults.standard.value(forKey: "userid")
        print(userid)
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        print(countriesArr.count)
        
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
                if data != nil{
                    // print(data)
                    self.presentWindow.hideToastActivity()
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
                            
                            self.userDataArr.append(UserDataObj.getUserData(salutation: salutations!, fname: fname!, mname: mname!, lname: lname!, gender: gender1!, dob: dob!, mobile: mobile!, landline: landline!, email: email!, aadhar: "", pan: pan!, flat_no: flat_no!, building_name: building_name!, road_street: road_street!, address: address!, Country: country!, State:state!, City: city!, pincode:pincode!, occupation: occupation!, location: location!, marital_status: marital_status!, spouse_name: spouse_name!, residential_status: residential_status!, user_tax_status: user_tax_status!, tax_slab: income_slab ?? "", IncomeSlabID: income_slab_id!))
                            
                            //print(self.userDataArr)
                            //self.postUserData()
                            
                        }
                        self.presentWindow.hideToastActivity()
                        //self.getKycStatus()
                    }
                } else{
                     self.presentWindow.hideToastActivity()
                }
                
            }
        }
            
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == timingTableView{
            return doc_sub_req_time.count
        }
        else{
            return addressArr.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == timingTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "timing", for: indexPath)
            cell.textLabel?.text = doc_sub_req_time[indexPath.row].time_slot_value
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "address", for: indexPath)
            cell.textLabel?.text = addressArr[indexPath.row].dt_name
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == timingTableView{
            let cell = timingTableView.cellForRow(at: indexPath)
            timingtf.text = cell?.textLabel?.text
           time_id = doc_sub_req_time[indexPath.row].time_slot_id
            print(time_id)
            self.timingTableView.isHidden = true
            Mixpanel.mainInstance().track(event: "KYC Screen :- Timing : \(timingtf.text!) is Clicked")
        }
        else{
            let cell = addressTypeTableView.cellForRow(at: indexPath)
            selectAddressType.text = cell?.textLabel?.text
           // print()
            address_type_id = addressArr[indexPath.row].dt_id!
            self.addressTypeTableView.isHidden = true
            Mixpanel.mainInstance().track(event: "KYC Screen :- Address Type : \(selectAddressType.text!) is Clicked")
            
        }
    }
    
    @IBAction func dateBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Date Button Clicked")
        calenderMainView.isHidden = false
        calender.isHidden = !self.calender.isHidden
        
       // self.cityTableView.isHidden = !self.cityTableView.isHidden
        timingTableView.isHidden = true
        addressTypeTableView.isHidden = true
        
    }
    
    @IBAction func timingBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Timing Button Clicked")
        timingTableView.flashScrollIndicators()
        timingTableView.isHidden = !self.timingTableView.isHidden
        calender.isHidden = true
        addressTypeTableView.isHidden = true
        
    }
    @IBAction func addressTypeBtnPrsd(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Address Type Button Clicked")
        addressTypeTableView.isHidden = !self.addressTypeTableView.isHidden
        self.timingTableView.isHidden = true
        calender.isHidden = true
        
    }
    func getSelectAddressType(){
       
        let url = "\(Constants.BASE_URL)\(Constants.API.getSelectAddressType)"
        print(url)
        print(address_type_id)
        addressArr.removeAll()
        addressArr.append(getSelectAddressObj.getAddressType(dt_id: "00", dt_name: "Select Type"))
            //getuserdata(country_name: "Select Country", country_id: "0"))
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    if data.isEmpty != true{
                        for type in data{
                            if let dt_id = type.value(forKey: "dt_id") as? String,
                                let dt_name = type.value(forKey: "dt_name") as? String{
                                print(dt_name)
                                self.addressArr.append(getSelectAddressObj.getAddressType(dt_id: dt_id, dt_name: dt_name))
                                if self.address_type_id != nil{
                                    if self.address_type_id == dt_id{
                                        self.selectAddressType.text = dt_name
                                    }
                                }
                                else{
                                    print("none")
                                    self.selectAddressType.text = "Select Type"
                                }
                            }
                        }
                    }
                    else{
                       
                        
                    }
                }
                self.addressTypeTableView.reloadData()
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getTimeSlot(){
        //let userid = UserDefaults.standard.value(forKey: "userid")
        let url = "\(Constants.BASE_URL)\(Constants.API.getTimeSlot)"
        print(url)
        //print(address_type_id)
        doc_sub_req_time.removeAll()
        doc_sub_req_time.append(timeSlotObj.getTimeSlot(time_slot_id: "00", time_slot_value: "Pickup Time"))
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    if data.isEmpty != true{
                        for type in data{
                            if let time_slot_id = type.value(forKey: "time_slot_id") as? String,
                                let time_slot_value = type.value(forKey: "time_slot_value") as? String{
                                print(time_slot_value)
                                self.doc_sub_req_time.append(timeSlotObj.getTimeSlot(time_slot_id: time_slot_id, time_slot_value: time_slot_value))
                                //print(time_id)
                                 if self.time_id != nil{
                                    if self.time_id! == time_slot_id{
                                        self.timingtf.text = time_slot_value
                                    }
                                }
                                 else{
                                    self.timingtf.text = "Pickup Time"
                                }
                            }
                        }
                    }
                    else{
                        
                        
                    }
                }
                print(self.doc_sub_req_time.count)
                self.timingTableView.reloadData()
                
            }
            
            
            
        }
        else{
            //presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
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
        user_id_all = userid as! String
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
                            if let fatca_id = type.value(forKey: "fatca_id") as? String,
                                let fatca_networth = type.value(forKey: "fatca_networth") as? String, let fatca_networth_date = type.value(forKey: "fatca_networth_date") as? String , let fatca_politically_exposed = type.value(forKey: "fatca_politically_exposed") as? String,let fatca_nationality = type.value(forKey: "fatca_nationality") as? String,let fatca_other_nationality = type.value(forKey: "fatca_other_nationality") as? String,let fatca_tax_resident = type.value(forKey: "fatca_tax_resident") as? String ,let fatca_resident_country = type.value(forKey: "fatca_resident_country") as? String,let fatca_tax_player_id = type.value(forKey: "fatca_tax_player_id") as? String,let fatca_id_type = type.value(forKey: "fatca_id_type") as? String,let fatca_resident_country_1 = type.value(forKey: "fatca_resident_country_1") as? String, let fatca_tax_player_id_1 = type.value(forKey: "fatca_tax_player_id_1") as? String,let fatca_id_type_1 = type.value(forKey: "fatca_id_type_1") as? String,let fatca_resident_country_2 = type.value(forKey: "fatca_resident_country_2") as? String,let fatca_tax_player_id_2 = type.value(forKey: "fatca_tax_player_id_2") as? String,let fatca_id_type_2 = type.value(forKey: "fatca_id_type_2") as? String{
                                
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
    func clientregistrationBse(userid:String){
        print("Modify ucc data")
        //https://www.financialhospital.in/adminpanel/bse/bse_ws.php/clientregistration/userid
        let url = "\(Constants.BASE_URL)\(Constants.API.clientregistration)\(userid)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value as? [String:Any]
                if let response_status = data?["response"] {
                    if data?["status"] != nil && data?["status"] as? String  == "Error" {
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
                    let alert = UIAlertController(title: "Alert", message: "\(data!["response"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                        print("Ok button clicked")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    //redirect to address detail
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "FatcaDetailViewController") as! FatcaDetailViewController
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
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "FatcaDetailViewController") as! FatcaDetailViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    @IBAction func downloadKYC(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- Download KYC Form Button Clicked")
         var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        presentWindow.makeToastActivity(message: "Downloading")
       // http://www.erokda.in/adminpanel/
        let fileURL = URL(string: "\(Constants.API.downloadKyc)\(userid!)&action=app")
        print(fileURL ?? "")
        
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            var documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            documentsURL.appendPathComponent("aof-\(userid!)-0-unsigned.pdf")
            return (documentsURL, [.removePreviousFile])
        }
        
        Alamofire.download(fileURL!, to: destination).responseData { response in
            if let destinationUrl = response.destinationURL {
                print("destinationUrl \(destinationUrl.absoluteURL)")
                let destinationURLForFile = destinationUrl.absoluteURL
                self.showFileWithPath(path: destinationURLForFile.path)
                
            }
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
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController
    {
        
        UINavigationBar.appearance().tintColor = UIColor.black
        return self
    }
    @IBAction func viewPan(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- View Pancard Button Clicked")
        //http://www.erokda.in/img/mftdocs/120747/Budget%202018-19%20Benefits.pdf
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        let memberid = UserDefaults.standard.value(forKey: "memberid") as! String
        var url = ""
//        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
//        if memberid != "0" && memberid != parent_user_id {
//            userid = flag
//            let phone = userDataArr[0].mobile
//            let email = userDataArr[0].email
//            let email_mobile = phone! + "|" + email!
//            url = "\(Constants.API.kycViewDoc)\(panLabel.text!)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload"
//        }
//        else{
//            userid = UserDefaults.standard.value(forKey: "userid") as! String
//            let phone = userDataArr[0].mobile
//            let email = userDataArr[0].email
//            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.kycViewDoc)\(panLabel.text!)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload"
            
       // }
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
    @IBAction func viewPhot(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- View Photo Button Clicked")
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        var url = ""
        let memberid = UserDefaults.standard.value(forKey: "memberid") as! String
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        if memberid != "0" && memberid != parent_user_id{
            userid = flag
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.kycViewDoc)\(photoLabel.text!)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload"
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid") as! String
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.kycViewDoc)\(photoLabel.text!)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload"
            
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
    @IBAction func viewAddressProof(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "KYC Screen :- View Address Proof Button Clicked")
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        let memberid = UserDefaults.standard.value(forKey: "memberid") as! String
        var url = ""
        let parent_user_id = UserDefaults.standard.value(forKey: "parent_user_id") as? String
        if memberid != "0" && memberid != parent_user_id {
            userid = flag
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.kycViewDoc)\(addressProofLabel.text!)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload"
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid") as! String
            let phone = userDataArr[0].mobile
            let email = userDataArr[0].email
            let email_mobile = phone! + "|" + email!
            url = "\(Constants.API.kycViewDoc)\(addressProofLabel.text!)&path=1&userId=\(String(describing: userid.convertToBase64()))&action=globalfiledownload"
            
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
    
}
extension Date {
    var isWeekend: Bool {
        return NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!.isDateInWeekend(self)
    }
}
