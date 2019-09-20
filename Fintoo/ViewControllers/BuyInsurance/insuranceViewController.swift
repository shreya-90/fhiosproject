
//
//  insuranceViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 21/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import  FSCalendar
import Mixpanel

class insuranceViewController: BaseViewController,UITextFieldDelegate {


    var genderNum : Int?
    var gender : String?
    var  smokeNum : Int?
    var smoke : String?
     var datePicker = UIDatePicker()
    @IBOutlet weak var calanderView: FSCalendar!
    @IBOutlet weak var calanderMainView: UIView!

    @IBOutlet weak var dobTop: NSLayoutConstraint!

    @IBOutlet weak var constraint1: NSLayoutConstraint!//5 16

    @IBOutlet weak var constraint2: NSLayoutConstraint!//5 15

    @IBOutlet weak var constraint3: NSLayoutConstraint! //5 10

    @IBOutlet weak var constarint: NSLayoutConstraint! // 5 -5

    @IBOutlet weak var dobtf: UITextField!

    @IBOutlet weak var constarint4: NSLayoutConstraint!//5 7

    @IBOutlet weak var constraint5: NSLayoutConstraint! //5 5

    @IBOutlet weak var constarint6: NSLayoutConstraint! //5 5

    @IBOutlet weak var constarint7: NSLayoutConstraint! // 5 5
    @IBOutlet weak var maleBtn: UIButton!

    @IBAction func malebtn(_ sender: Any) {
        maleBtn.backgroundColor = UIColor(hexaString: "#2DB4E8")

        femaleBtn.backgroundColor = UIColor(hexaString: "#D6D6D6")
        gender = "Male"
        calculate()
        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Male Button Clicked")
    }
    @IBOutlet weak var femaleBtn: UIButton!

    @IBAction func femaleBtn(_ sender: Any) {
        gender = "Female"
        femaleBtn.backgroundColor = UIColor(hexaString: "#2DB4E8")

        maleBtn.backgroundColor = UIColor(hexaString: "#D6D6D6")
        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Female Button Clicked")
         calculate()
    }
    @IBOutlet weak var non_smoker_btn: UIButton!

    @IBAction func non_smoker_btn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- No Button Clicked")
        non_smoker_btn.backgroundColor = UIColor(hexaString: "#2DB4E8")

        smoker_btn.backgroundColor = UIColor(hexaString: "#D6D6D6")
        smoke = "Non-Smoker"
         calculate()
    }

    @IBOutlet weak var smoker_btn: UIButton!

    @IBAction func smoker_btn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Yes Button Clicked")
        smoker_btn.backgroundColor = UIColor(hexaString: "#2DB4E8")
        non_smoker_btn.backgroundColor = UIColor(hexaString: "#D6D6D6")
        smoke = "Smoker"
        calculate()
    }
    @IBOutlet weak var tfcover: UITextField!
    @IBOutlet weak var yearLabel: UILabel!

    @IBOutlet weak var cover_slider: myCustomSlider!

    @IBOutlet weak var monthLabel: UILabel!
//    @IBAction func cover_slider(_ sender: Any) {
//        let tfcover_Comma1 = cover_slider.label.text?.replacingOccurrences(of: "₹ ", with: "")
//        tfcover.text = tfcover_Comma1
//        calculate()
//    }
    @objc func sliderDidEndSliding(notification: NSNotification)
    {
        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Slider Clicked")
        print("Hello-->\(cover_slider.label.text)")
        let tfcover_Comma1 = cover_slider.label.text?.replacingOccurrences(of: "₹ ", with: "")
        tfcover.text = tfcover_Comma1
        calculate()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setWhiteNavigationBar()
        addBackbutton()
        addRightBarButtonItems(items: [cartButton])
        cover_slider.minimumValue = 5000000
        cover_slider.maximumValue = 20000000
        cover_slider.value = 5000000
        tfcover.text = "50,00,000"
        tfcover.delegate = self
        calanderView.dataSource = self
        calanderView.delegate = self
        dobtf.delegate = self
        self.cover_slider.addTarget(self, action: #selector(self.sliderDidEndSliding(notification:)), for: ([.touchUpInside,.touchUpOutside]))

       calculate()
    }
    override func viewWillAppear(_ animated: Bool) {
        if UIDevice().screenType == .iPhone6
        {
            constarint4.constant = 1.0
            constraint5.constant = 20.0
            constarint6.constant = 20.0
            constarint7.constant = 20.0
            //dobTop.constant =  32.0
            print("OTHER DEVICES")



        }
        cart_count()

    }
    func cart_count(){
        var userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        if flag != "0"{
            userid = flag

        }
        else{
            // flag = "0"
            userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        }
        // let userid = UserDefaults.standard.value(forKey: Constants.User_Defaults.USER_ID) as? String
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3").responseString { response in
                let enc_response = response.result.value
                print(enc_response)
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                print(enc1)
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                    // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                }
                print(response.result.value ?? "cart count")
                let data = dict
                print(data)
                if !data.isEmpty {
                    print("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3")
                    // print(response.value)
                    print(data.count)
                    if totalCountFlag == "1" {
                        var count = ""
                        if let cnt = UserDefaults.standard.value(forKey: "totalcartcount") {
                            count = "\(cnt)"
                        }
                        //var count = "\(UserDefaults.standard.value(forKey: "totalcartcount"))"
                        if count != "" {
                            self.btnCart.badgeString = count
                        }
                        else {
                            self.btnCart.badgeString = String(data.count)
                        }
                    } else {
                        self.btnCart.badgeString = String(data.count)
                    }
                } else {
                    self.btnCart.badgeString = String(data.count)
                }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    override func onCart1ButtonPressed(_ sender: UIButton) {

        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Cart Count Button Clicked")
        self.getUserProfileStat()
        print("cart")
//        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//
//        self.navigationController?.pushViewController(destVC, animated: true)
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Back Button Clicked")
        navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func continues(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Continue Button Clicked")
        UIApplication.shared.openURL(NSURL(string: "https://goo.gl/bUp6qm")! as URL)
        //calculate()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- End editing amount textfield")
        let abc = tfcover.text?.replacingOccurrences(of: ",", with: "")
        print(abc)
        let formatter = NumberFormatter()              // Cache this,
        formatter.locale = Locale(identifier: "en_IN") // Here indian local
        formatter.numberStyle = .decimal
        let string = formatter.string(from: abc!.numberValue!)
        tfcover.text = string
        cover_slider.setValue(Float(abc!)!, animated: true)

        let tfcover_Comma1 = tfcover.text?.replacingOccurrences(of: ",", with: "")
        print(tfcover_Comma1)
        if  5000000  >= Double(tfcover_Comma1!)!{
            // presentWindow?.makeToast(message: "Minimum Amount Should Be 50,00,000 ")

            tfcover.text = "50,00,000"
            calculate()
        }
        else if 20000000 <= Double(tfcover_Comma1!)!{
            tfcover.text = "2,00,00,000"
            calculate()
        }
        else{
            print(tfcover.text)
            cover_slider.label.text = tfcover.text
            print(cover_slider.label.text)
            calculate()
        }

    }
    @IBAction func datePicker(_ sender: Any) {
      Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Date Picker Button Clicked")
       // pickUpDate()
        dobtf.becomeFirstResponder()
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Begin editing amount textfield")
        self.pickUpDate(self.dobtf)
        // print("oooooooo")
    }
    func calculate(){
        let tfcover_Comma1 = tfcover.text?.replacingOccurrences(of: ",", with: "")
        print(tfcover_Comma1!)
        if tfcover.text!.count <= 6{

           // presentWindow?.makeToast(message: "Minimum Amount Should Be 50,00,000 ")
            tfcover.text = "50,00,000"
        }
        else if Connectivity.isConnectedToInternet{


            if gender == nil{
                gender = "Male"
            }
            if smoke == nil{
                smoke = "Non-Smoker"
            }
            var tabacco: String?
            var fixedval:Int?
            var newai: Int?
            if gender == "Male"{
                genderNum = 1;
            }
            else{
                genderNum=0;
            }
            print(genderNum!)
            if smoke == "Non-Smoker" {
                smokeNum = 0;
            }else{
                smokeNum=1;
            }

            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let showDate = inputFormatter.date(from: dobtf.text!)
            inputFormatter.dateFormat = "dd-MM-yyyy"
            let now = Date()
            let calendar = Calendar.current
            let showdateyear = calendar.component(.year, from: showDate!)
            let nowyear = calendar.component(.year, from: now)
            var age = nowyear - showdateyear
            let resultString = inputFormatter.string(from: showDate!)
            let tfcover_Comma = tfcover.text?.replacingOccurrences(of: ",", with: "")
            let ai = Double(tfcover_Comma!)

            if(genderNum == 0){
                if(age>20){
                    print(age,"age")
                    age = age-3;
                }
            }
            if(smokeNum == 1){
                tabacco = "S";
                fixedval = 65;
            }else{
                tabacco = "NS";
                fixedval = 75;
            }
            if(ai! >= 5000000) && (ai! <= 7400000){
                newai = 50;

            }
            if(ai! > 7400000) && (ai! <= 9900000){
                newai = 75;
            }
            if(ai! > 9900000) && (ai! <= 20000000){
                newai = 100;
            }
            if(ai! > 20000000){
                newai = 200;
            }
            let  term = abs(fixedval! - age);


            let parameters = [
                "tabacco" :"\(tabacco!)",
                "term" : "\(term)",
                "ai" : "\(newai!)",
                "age" : "\(age)",
                "fixValue":"\(fixedval!)"]


            presentWindow?.makeToastActivity(message: "Loading..")
            //gettermvalue
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.gettermvalue)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    if let data :Double = response.result.value as? Double{
                        print(data)
                        self.presentWindow?.hideToastActivity()
                        self.navigationController?.view.hideToastActivity()
                        let final_value = (data * ai!)/1000.00;

                        let year_data = final_value+((final_value*18)/100);
                        let addwithoutgst=(final_value*8.83)/100;
                        let month_data=addwithoutgst+((addwithoutgst*18)/100);
                        let formatter = NumberFormatter()              // Cache this,
                        formatter.locale = Locale(identifier: "en_IN") // Here indian local
                        formatter.numberStyle = .decimal
                        print(month_data)
                        print(year_data)
                        let monthstring = formatter.string(from: NSNumber(value:month_data))
                        let yearString = formatter.string(from: NSNumber(value:year_data))
                        print(monthstring,yearString)
                        let round_month_value = String(format:"%.f", month_data)
                        let round_year_value = String(format:"%.f", year_data)

                        self.yearLabel.text = "₹ " + formatter.string(from: round_year_value.numberValue!)! + " PER YEAR"
                        self.monthLabel.text = "(₹ \(formatter.string(from: round_month_value.numberValue!)!) PER MONTH)"
                        self.cover_slider.label.text = self.tfcover.text
                    }
                    else{
                        self.presentWindow?.hideToastActivity()

                    }
            }
        }
        else{
            self.presentWindow?.hideToastActivity()
            Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- No Internet Connection")
            presentWindow!.makeToast(message: "Please Check Your Internet Connection")
            //self.navigationController?.view.makeToast("Internet Connection not Available!", duration: 3.0, position: .center)
        }
    }
    func pickUpDate(_ textField : UITextField){

        // DatePicker


        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))

        self.datePicker.backgroundColor = UIColor.white
        self.datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -56, to: Date())

        dobtf.inputView = self.datePicker

        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()

        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(insuranceViewController.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(insuranceViewController.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        dobtf.inputAccessoryView = toolBar
        print("hiiii")
    }
    @objc func doneClick() {
       Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Date Picker Done Button Clicked")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "dd-MM-yyyy"

        dobtf.text = dateFormatter1.string(from: datePicker.date)
        calculate()
        dobtf.resignFirstResponder()
    }
    @objc func cancelClick() {
       Mixpanel.mainInstance().track(event: "Buy Insurance Screen :- Date Picker Cancel Button Clicked")
        dobtf.resignFirstResponder()
    }

    func getUserProfileStat() {

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


                        } else {

                            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController

                            self.navigationController?.pushViewController(destVC, animated: true)


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
extension insuranceViewController: FSCalendarDelegate, FSCalendarDataSource {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        self.calanderView.isHidden = true

        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let myString = formatter.string(from: date)
        //self.tfDate.text = myString
        dobtf.text = myString
    }

    func minimumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .year, value: -56, to: Date())!
    }
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    }

//    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
//        let weekday = Calendar.current.component(.weekday, from: date)
//        if weekday == 1 || weekday == 7 {
//
//            return false
//        }
//        return true
//    }
}
