//
//  StartSIPViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 06/04/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Charts
import Mixpanel
import Alamofire

class StartSIPViewController: BaseViewController,UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,ChartViewDelegate ,Delegate{
    
    var flags  = "0"
    @IBOutlet weak var barchartheight: NSLayoutConstraint!
    
    @IBOutlet weak var reinvest_payout_stack: UIStackView!
    @IBOutlet weak var product_name: UILabel!
    
    @IBOutlet weak var product_nav: UILabel!
    
    @IBOutlet weak var amounttf: UITextField!
    
    @IBOutlet weak var frequencytf: UITextField!
    
    @IBOutlet weak var SipStartDate: UITextField!
    
    @IBOutlet weak var perpetual_60_years_Outlet: UIButton!
    
    @IBOutlet weak var reinvestOutlet: UIButton!
    @IBOutlet weak var payouttf: UITextField!
    
    @IBOutlet weak var payoutOutlet: UIButton!
    @IBOutlet weak var siptenuretf: UITextField!
    
    @IBOutlet weak var sip_stack: UIStackView!
    @IBOutlet weak var containheight: NSLayoutConstraint!
    
    @IBOutlet weak var barChartViewTop: NSLayoutConstraint!
    @IBOutlet weak var barChartView: BarChartView!
    
    @IBOutlet weak var percentValue: UILabel!
    @IBOutlet weak var lumpsum_3: UILabel!
    
    @IBOutlet weak var lumpsum_5: UILabel!
    
    @IBOutlet weak var lumpsum_10: UILabel!
    
    @IBOutlet weak var chartLabel1: UILabel!
    
    @IBOutlet weak var chartLabel2: UILabel!
    
    @IBOutlet weak var chartLabel3: UILabel!
    
    weak var valueFormatter: IValueFormatter?
    var cellTapped:Bool = false
    var payoutBool : Bool = false
    var SIP_Start_date = [String]()
    var p_name : String!
    var c_nav : String!
    var OPT_code : String!
    var row : Int!
    var bseschemetype : String!
    var Scheme_code : String!
    let pickerView = UIPickerView()
    var months: [String]!
    var value1 = [Int]()
    var SIP_value = [Int]()
    var sipfreqs : String!
    var allsipamounts1 : String!
    var MAXINVT : String!
    var sipCalculationArr = [SIP_date_calculation]()
    var goal = ""
    var year = ""
   
    var scheme_ids = [String]()
    var id : String!
    let Siptenure = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59","60"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        addBackbutton()
        addRightBarButtonItems(items: [cartButton])
        
        valueFormatter = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        siptenuretf.delegate = self
        amounttf.delegate = self
        amounttf.addTarget(self, action: #selector(sipamount), for: UIControlEvents.editingChanged)
        
        let imageView1 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        siptenuretf.rightViewMode = UITextFieldViewMode.always
        let image1 = UIImage(named: "btn_dropdown")
        imageView1.image = image1
        siptenuretf.rightView = imageView1
        
        let imageView2 = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        SipStartDate.rightViewMode = UITextFieldViewMode.always
        let image2 = UIImage(named: "btn_dropdown")
        imageView2.image = image2
        SipStartDate.rightView = imageView2
        
        sip_stack.arrangedSubviews[1].isHidden = true
        product_name.text = p_name
        product_nav.text = c_nav
        print(MAXINVT)
        
        if OPT_code! == "2" {
            //checking for bseschemetype
            if bseschemetype == "reinvest"{
                sip_stack.arrangedSubviews[0].isHidden = false
                reinvest_payout_stack.arrangedSubviews[0].isHidden = false
                reinvest_payout_stack.arrangedSubviews[1].isHidden = true
            }else if bseschemetype == "both"{
                sip_stack.arrangedSubviews[0].isHidden = false
                reinvest_payout_stack.arrangedSubviews[0].isHidden = false
                reinvest_payout_stack.arrangedSubviews[1].isHidden = false
            }
          
        }
        else{
            containheight.constant = 250
            sip_stack.arrangedSubviews[0].isHidden = true
            sip_stack.arrangedSubviews[1].isHidden = true
        }
        print(Scheme_code!)
        SIP_Strat_date(scheme_code:Scheme_code!)
         SipStartDate.delegate = self
        Strat_SIP_Chart(row:row)
        if year != ""{
            siptenuretf.text = year
        }
        if goal != "" {
            amounttf.text = goal
            Strat_SIP_Chart(row: row)
        
        }
        // Do any additional setup after loading the view.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
//        Mixpanel.mainInstance().track(event: "Start SIP Screen :- Back Button Clicked")
//        //navigationController?.popViewController(animated: true)
        
//        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//        let destVC = storyBoard.instantiateViewController(withIdentifier: "CompareFundViewController") as! CompareFundViewController
//        destVC.id = scheme_ids
//        navigationController?.pushViewController(destVC, animated: false)
        
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addtocart(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Start SIP Screen :- Add To Cart Button Clicked")
        SIPaddToCart(row:row)
    }
    @IBAction func calculate_how_much(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Start SIP Screen :- Calculate How Much I Need Button Clicked")
        //view.backgroundColor = UIColor.clear
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CalculateHowMuchDoViewController") as! CalculateHowMuchDoViewController
        destVC.row = row
        
        destVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        destVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        destVC.delegate = self
        self.present(destVC, animated:true, completion: nil)
    }
 
    func doSomething(goal: String,year:String) {
        print(goal)
        amounttf.text = goal
        siptenuretf.text = year
         Strat_SIP_Chart(row: 0)
    }   
    override func viewWillAppear(_ animated: Bool) {
      
    }
    
    override func onCart1ButtonPressed(_ sender : UIButton)
    {
        self.getUserProfileStat()
    }
    
    override func onCartButtonPressed(_ sender: UIButton) {
        getUserProfileStat()
//        Mixpanel.mainInstance().track(event: "Start SIP Screen :- Cart Button Clicked")
//        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//
//        self.navigationController?.pushViewController(destVC, animated: true)
    }
    @IBAction func perpetual_60_years(_ sender: Any) {
        if cellTapped == false{
            let image1 = UIImage(named: "right") as UIImage?
            perpetual_60_years_Outlet.setImage(image1, for: .normal)
            siptenuretf.text = "60"
            siptenuretf.isEnabled = false
            cellTapped = true
            Strat_SIP_Chart(row: row)
            Mixpanel.mainInstance().track(event: "Start SIP Screen :- Perpetual Button Ticked")
        }
        else{
            siptenuretf.isEnabled = true
            let image1 = UIImage(named: "") as UIImage?
            perpetual_60_years_Outlet.setImage(image1, for: .normal)
            siptenuretf.text = "1"
            cellTapped = false
            Strat_SIP_Chart(row: row)
            Mixpanel.mainInstance().track(event: "Start SIP Screen :- Perpetual Button Unticked")
        }
        
    }
    @IBAction func reinvest(_ sender: Any) {
        
        payoutOutlet.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        reinvestOutlet.setImage(UIImage(named: "check"), for: UIControlState.normal)
        sip_stack.arrangedSubviews[1].isHidden = true
        payoutBool = false
        Mixpanel.mainInstance().track(event: "Start SIP Screen :- Re-invest Button Ticked")
    }
    @IBAction func payout(_ sender: Any) {
        payoutOutlet.setImage(UIImage(named: "check"), for: UIControlState.normal)
        reinvestOutlet.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        sip_stack.arrangedSubviews[1].isHidden = false
        payoutBool = true
        Mixpanel.mainInstance().track(event: "Start SIP Screen :- Payout Button Ticked")
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(textField.tag,"textfield")
        
        if textField == siptenuretf{
            
            siptenuretf.inputView = pickerView
            //items = textField.tag
            pickerView.tag = 2
            Mixpanel.mainInstance().track(event: "Start SIP Screen :- Sip Tenure Drop Down Clicked")
        }
        else if textField == SipStartDate{
            Mixpanel.mainInstance().track(event: "Start SIP Screen :- Sip Start Date Drop Down Clicked")
            SipStartDate.inputView = pickerView
            //items = textField.tag
            pickerView.tag = 4
            
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 2 {
            return Siptenure.count
        }
        else if pickerView.tag == 4{
            return SIP_Start_date.count
        }
        else{
            return 0
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 2 {
            return Siptenure[row]
        }
        else{
            return SIP_Start_date[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView.tag,"picker view tag")
        //print(items,"items")
        //let cell: customCell = tableview.cellForRow(at: IndexPath(row: items, section: 0)) as! customCell
        if pickerView.tag == 2{
            //print(Siptenure[row])
            
            siptenuretf.text = Siptenure[row]
            Strat_SIP_Chart(row:row)
        }
        else if pickerView.tag == 4{
            SipStartDate.text = SIP_Start_date[row]
        }
       
    }
    
    
    //sip start days api
    func SIP_Strat_date(scheme_code:String){
        print(scheme_code,"scheme_code")
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.Sip_start_days)\(scheme_code.covertToBase64())/monthly/3").responseString { response in
                let enc_response = response.result.value
                print(enc_response,"response")
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                    // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                }
                let data = dict
                print(data)
               // if let data = response.result.value as? [AnyObject]{
                    print(data.isEmpty)
                    if !data.isEmpty{
                        for sip_date in data as! [NSDictionary]{
                            print(sip_date)
                            self.SIP_Start_date.removeAll()
                            for i in 1..<8 {
                                //print(sip_date.value(forKey: "SIPDAYS\(i)"))
                                let sip_days = sip_date.value(forKey: "SIPDAYS\(i)") as? String
                                 print(sip_days!,"************")
                                if sip_days! != "0" && sip_days! != "29" && sip_days! != "30" && sip_days! != "31" {
                                     print(sip_days)
                                    self.SIP_Start_date.append(sip_days!)
                                    self.flags = "1"
                                }
                                
                            }
                        }
                    }
                    
                    if data.isEmpty || self.SIP_Start_date.isEmpty{
                        self.SIP_Start_date = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"]
                    }
                    if self.flags != "1"{
                        let date = Date()
                        let calendar = NSCalendar.current
                        let day = calendar.component(.day, from: date)
                        var d = 1
                        while(d<=28){
                            
                            if d == day {
                                self.SipStartDate.text = "\(d)"
                                
                            }
                            d += 1
                        }
                    }
                    
                    
                //}
            }
            
        }
            
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    @objc func sipamount(_textField: UITextField){
        Strat_SIP_Chart(row:row)
    }
    
    //bar chart
    func Strat_SIP_Chart(row:Int){
        var result_sip  = [Int]()
        print(row)
        value1.removeAll()
        months = ["10%", "12%", "15%"]
        //let cell: customCell = tbl.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        //let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        barChartView.delegate = self
        barChartView.isHidden = false
        barChartView.doubleTapToZoomEnabled = false
       // cell.SIPStackVIewDetail.isHidden = false
        
        barChartView.chartDescription?.enabled = false
        
        if amounttf.text != ""{
            barChartView.isHidden = false
            barChartView.data?.highlightEnabled = true
            //print(texindex,"texindex")
            print(row,"row")
            var year = [3.0,5.0,10.0]
            var rate_interest =  [10.0, 12.0,15.0]
            var principal_amount = Int(amounttf.text!)
            var frequency = Int(frequencytf.text!)
            var tenure = Int(siptenuretf.text!)
            print(siptenuretf.text!)
            for i in 0..<year.count {
                let time : Double = Double((tenure)! * 12);
                print(time)
                //Log.d("TAG", "A: ====" + time);
                let rate = (rate_interest[i] / 1200);
                print(rate)
                //Log.d("TAG", "B: ====" + rate);
                let math = pow(1 +  rate,time)
                print(math)
                let sip_amount = (math - 1) / rate;
                var Final_value = Double(principal_amount!) * sip_amount;
                print(Final_value)
                Final_value.round()
                //var Final_values =
                print(Final_value)
                // Log.d("TAG", "Final Value: ====" + Final_value);
                
                result_sip.append(Int(Final_value))
                print(result_sip)
                
            }
            
        }
        
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        //yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = true
        
        
        barChartView.rightAxis.enabled = false
        
        barChartView.noDataText = "You need to provide data for the chart."
        
        var dataEntries: [BarChartDataEntry] = []
        if result_sip.isEmpty {
            for i in 0..<months.count{
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(0), data: months[i] as AnyObject)
                dataEntries.append(dataEntry)
                //SIP_value.removeAll()
                //  SIP_value.append(0)
            }
        }
        else{
            SIP_value.removeAll()
            print(months.count)
            for i in 0..<months.count {
                // let dataEntry = BarChartDataEntry(value: values[i], xIndex: i) // argument labeld dont match
                
                
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(result_sip[i]), data: months[i] as AnyObject)
                dataEntries.append(dataEntry)
                print(result_sip[i])
                //SIP_value.removeAll()
                SIP_value.append(result_sip[i])
                
            }
        }
        // print()
        print(dataEntries)
        print(SIP_value)
        let chartDataSet = BarChartDataSet(values: dataEntries, label: "Projected amount")
        chartDataSet.valueFont = .systemFont(ofSize: 9)
        let dataSets: [BarChartDataSet] = [chartDataSet]
    
        chartDataSet.colors = [UIColor(red: 45/255, green: 180/255, blue: 232/255, alpha: 1)]
        chartDataSet.highlightColor = NSUIColor(red: 45/255, green: 180/255, blue: 232/255, alpha: 1)
        //chartDataSet.valueFormatter = "2,45666" as! IValueFormatter
        
        
        
        
        let chartData = BarChartData(dataSets: dataSets)
        
        let barWidth = 0.9
        
        chartData.barWidth = barWidth;
        barChartView.data = chartData
        barChartView.data?.setValueFormatter(valueFormatter)
        
        print(barChartView.data)
        
        let xaxis = barChartView.xAxis
        xaxis.valueFormatter = IndexAxisValueFormatter(values: months)
        //xaxis.labelCount = months.count
        xaxis.labelCount = months.count
        xaxis.labelPosition = .top
        
        xaxis.granularity = 1.0
        xaxis.drawGridLinesEnabled = false
        //background color
        barChartView.backgroundColor = UIColor.white
        
        //chart animation
        barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
    
        if SIP_value.count > 0{
            print(SIP_value.isEmpty)
            var sip_comma = [String]()
            for i in 0..<SIP_value.count {
                let intString = String(SIP_value[i])
                let fv = Double(intString)
                let formatter = NumberFormatter()              // Cache this,
                formatter.locale = Locale(identifier: "en_IN") // Here indian local
                formatter.numberStyle = .decimal
                let string = formatter.string(from: NSNumber(value: fv!))
                sip_comma.append(string!)
            }
            //abc.append(string!)
                lumpsum_10.text = "₹ " + String(sip_comma[2])
                lumpsum_5.text = "₹ " + String(sip_comma[1])
                lumpsum_3.text = "  ₹ " + String(sip_comma[0])
                percentValue.text = "Future Values"
            
            
        }
        else{
            print(SIP_value)
            chartLabel1.text = "10 %"
            chartLabel2.text = "12 %"
            chartLabel3.text = "15 %"
            lumpsum_3.text = "₹ 0"
            lumpsum_5.text = "₹ 0"
            lumpsum_10.text = "₹ 0"
            percentValue.text = "Future Values"
        }
        
    }
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        // var result_sip  = [Int]()
        
        let pos = NSInteger(entry.x)
        print(pos)
       // let cell: customCell = tableview.cellForRow(at: IndexPath(row: row1, section: 0)) as! customCell
        
        // cell.barChartView.data?.highlightEnabled = true
        print(value1)
        print(SIP_value.count)
        print(SIP_value)
         if SIP_value.count > 0{
            print(SIP_value.isEmpty)
            var sip_comma = [String]()
            for i in 0..<SIP_value.count {
                let intString = String(SIP_value[i])
                let fv = Double(intString)
                let formatter = NumberFormatter()              // Cache this,
                formatter.locale = Locale(identifier: "en_IN") // Here indian local
                formatter.numberStyle = .decimal
                let string = formatter.string(from: NSNumber(value: fv!))
                sip_comma.append(string!)
            }
            //abc.append(string!)
            if pos == 2 || pos == 1 || pos == 0{
                lumpsum_10.text = "₹ " + String(sip_comma[2])
                lumpsum_5.text = "₹ " + String(sip_comma[1])
                lumpsum_3.text = "₹ " + String(sip_comma[0])
                percentValue.text = "Feature Values"
            }
            
        }
        else{
            print(SIP_value)
            chartLabel1.text = "10 %"
            chartLabel2.text = "12 %"
            chartLabel3.text = "15 %"
            lumpsum_3.text = "₹ 0"
            lumpsum_5.text = "₹ 0"
            lumpsum_10.text = "₹ 0"
            percentValue.text = "Future Values"
        }
    }
    
    func SIPaddToCart(row: Int) {
        //let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        //let productobj = productArr[row]
        //print(productobj.sipfreq)
        //print(productobj.allsipamounts)
        var sipfreq = sipfreqs
        var sipfreq_arr = sipfreq?.components(separatedBy: ",")
        var allsipamounts = allsipamounts1
        var allsipamounts_arr = allsipamounts?.components(separatedBy: ",")
        let sipfreq_index = sipfreq_arr?.index(of: "Monthly")
        let min_amount = Int(allsipamounts_arr![sipfreq_index!])
        if amounttf.text == "" {
            amounttf.resignFirstResponder()
            Mixpanel.mainInstance().track(event: "Start SIP Screen :- Please enter amount")
            self.presentWindow.makeToast(message: "Please enter amount")
        }
        else if Int(amounttf.text!)! < min_amount! && min_amount! > 500{
            Mixpanel.mainInstance().track(event: "Start SIP Screen :- Minimum amount should be \(min_amount!)")
            amounttf.resignFirstResponder()
            self.presentWindow.makeToast(message: "Minimum amount should be \(min_amount!)")
            // print("hello")
        }
        else if Int(amounttf.text!)! < 500 {
            Mixpanel.mainInstance().track(event: "Start SIP Screen :- Minimum amount should be 500")
            amounttf.resignFirstResponder()
            self.presentWindow.makeToast(message: "Minimum amount should be 500")
            // print("hello")
        }
        else if MAXINVT != "" && Int(amounttf.text!)! > Int(MAXINVT)! {
            Mixpanel.mainInstance().track(event: "Start SIP Screen :- Your maximum investment limit for this fund is \(MAXINVT!)")
            self.presentWindow.makeToast(message: "Your maximum investment limit for this fund is \(MAXINVT!)")
        }
        else{
            amounttf.resignFirstResponder()
            SIP_add_to_cart(start_date:SipStartDate.text!,type:"2",tenure:siptenuretf.text!, row: row)
            print("add to cart")
        }
    }
    
    func SIP_add_to_cart(start_date:String,type:String,tenure:String,row :Int){
        let parameters = ["stdate":"\(start_date.covertToBase64())","type":"2","tenure":"\(tenure.covertToBase64())","enc_resp":"3"] as [String : Any]
        print(parameters)
        print("\(Constants.BASE_URL)\(Constants.API.calculatesipdate)")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.calculatesipdate)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    //print(response.value!)
                    print(response.result.value)
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
                    if !data.isEmpty {
                        print(data)
                        for SIP_detail in data as [NSDictionary]{
                            // print(SIP_detail.value(forKey: "end_date"))
                            let SIP_start_date = SIP_detail.value(forKey: "start_date") as? String ?? ""
                            let SIP_end_date = SIP_detail.value(forKey: "end_date") as? String ?? ""
                            let SIP_totalins = SIP_detail.value(forKey: "totalins") as! Int
                            let SIP_remaininginsins = SIP_detail.value(forKey: "remainingins") as! Int
                            let SIP_sip_reg_no = SIP_detail.value(forKey: "sip_reg_no") as! Int
                            print(SIP_sip_reg_no)
                            self.sipCalculationArr.append(SIP_date_calculation.getSIP_date_calculation_ModelInstance(start_date: SIP_start_date, end_date: SIP_end_date, totalins: String(SIP_totalins), remainingins: String(SIP_remaininginsins), sip_reg_no: String(SIP_sip_reg_no)))
                               self.SIP_addtocart(row:row)
                        }
                    }
            }
            
        }
            
        else{
            print("hello")
            
            self.presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func SIP_addtocart(row:Int){
        
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        //let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        var perpetual1 = "N"
        var payout = ""
        if siptenuretf.text == "60"{
            perpetual1 = "Y"
        }
       // let productobj = productArr[row]
        //print(SIP_sip_reg_no)
        let SIPCalculationobj = sipCalculationArr[0]
        print(SIPCalculationobj.start_date!)
        //print(productobj.Scheme_code)
        let schemecode = Scheme_code
        let tenure = siptenuretf.text
        let amount = amounttf.text
        let type = "2"
        let frequency = "Monthly"
        let sessionid = sessionId
        let perpetual = perpetual1
        let start_date = SIPCalculationobj.start_date
        let end_date = SIPCalculationobj.end_date
        let total_installment = SIPCalculationobj.totalins
        let remaining_installment = SIPCalculationobj.remainingins
        
        //let payout = "invest"
        let invopt = "1"
        let userId = userid
        let sip_reg_no = SIPCalculationobj.sip_reg_no
        let cart_rm_ref_id = ""
        //print(cell.reinvestOutlet.currentTitle)
        //print(cell.SIP_reinvest_stack.isHidden)
        if OPT_code == "2"{
            //rint(payoutStack.arrangedSubviews[0].isHidden)
            if payoutBool == true {
                payout = "payout"
                
            }
            else{
                payout = "reinvest"
                print(payout)
            }
            
        }
        print(payout)
      //  print(randomString)
        print(schemecode)
        print("\(Constants.BASE_URL)\(Constants.API.addToCart)")
        let parameters = ["id":"\(schemecode!.covertToBase64())","tenure":tenure!.covertToBase64(),"amount":amount!.covertToBase64(),"type":type.covertToBase64(),"frequency":frequency.covertToBase64(),"sessionid":sessionid!.covertToBase64(),"perpetual":perpetual.covertToBase64(),"start_date":start_date!.covertToBase64(),"end_date":end_date!.covertToBase64(),"total_installment":total_installment!.covertToBase64(),"remaining_installment":remaining_installment!.covertToBase64(),"payout":invopt.covertToBase64(),"invopt":payout.covertToBase64(),"userid":userId!.covertToBase64(),"sip_reg_no":sip_reg_no!.covertToBase64(),"cart_rm_ref_id":"","enc_resp":"3"] as [String : Any]
        print(parameters)
        presentWindow.makeToastActivity(message: "Adding.")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addToCart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value)
                    //let response = response.value?.base64Decoded() ?? ""
                    let r1  = response.value
                    let enc1 = r1?.replacingOccurrences(of: "\n" , with: "")
                    let response = enc1?.base64Decoded() ?? ""
                    print(response)
                    if response == "\"true\""{
                        print("true response")
                        self.presentWindow.hideToastActivity()
                        Mixpanel.mainInstance().track(event: "Start SIP Screen :- Added to cart successfully!")
                        self.presentWindow.makeToast(message: "Added to cart successfully!")
                        self.cart_count()
                    }
                    else if response == "false"{
                        self.presentWindow.hideToastActivity()
                        print("false response")
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        print("")
                    }
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
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
           let url = "\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3"
           print(url)
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
                    self.btnCart.badgeString = String(data.count)
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
                                
                                
                            }
                                
                                
                            else {
                                
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
extension StartSIPViewController: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        //print(value)
        print(SIP_value,"##")
        var abc = [String]()
        for i in 0..<SIP_value.count {
            let intString = String(SIP_value[i])
            let fv = Double(intString)
            let formatter = NumberFormatter()              // Cache this,
            formatter.locale = Locale(identifier: "en_IN") // Here indian local
            formatter.numberStyle = .decimal
            let string = formatter.string(from: NSNumber(value: fv!))
            abc.append("₹ \(string!)")
            print(string)
            
        }
        
        //logic to print string at required point or value
        if SIP_value.count > 0 {
            switch value {
                
            case Double(SIP_value[0]): return abc[0]
            case Double(SIP_value[1]): return abc[1]
            default: return abc[2]
            }
            
        }
        return "0"
    }
    
}
