//
//  lumpsumViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 10/04/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import Mixpanel
class lumpsumViewController: BaseViewController,ChartViewDelegate {
    @IBOutlet weak var containHeight: NSLayoutConstraint!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var reinvest_payout_stack: UIStackView!
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet weak var lumpsum_reinvest_stack: UIStackView!
    @IBOutlet weak var product_name: UILabel!
    
    @IBOutlet weak var amounttf: UITextField!
    
    @IBOutlet weak var reinvestOutlet: UIButton!
    
    @IBOutlet weak var payoutOutlet: UIButton!
    
    @IBOutlet weak var paymentMechanisam: UITextField!
    
    @IBOutlet weak var currentNav: UILabel!
    
    @IBOutlet weak var lumpsum_3: UILabel!
    
    @IBOutlet weak var lumpsum_5: UILabel!
    
    @IBOutlet weak var lumpsum_10: UILabel!
    
    @IBOutlet weak var chartLabel1: UILabel!
    @IBOutlet weak var chartLabel2: UILabel!
    @IBOutlet weak var chartLabel3: UILabel!
    
    @IBOutlet weak var percentValue: UILabel!
    
    weak var valueFormatter: IValueFormatter?
    
    
    var months: [String]!
    var years_3: [Double]!
    var years_10: [Double]!
    // let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0]
    var years_5 : [Double]!
    
    var value1 = [Int]()
    var value2 = [Int]()
    var value3 = [Int]()
    
    var p_name : String!
    var C_NAV : String!
    var OPT_code : String!
    var row : Int!
    var bseschemetype : String!
    var min_amount : String!
    var schemecode : String!
    var goal = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackbutton()
        addRightBarButtonItems(items: [cartButton])
        
        valueFormatter = self
        months = ["", "", ""]
        amounttf.addTarget(self, action: #selector(textFieldDidChange), for: UIControlEvents.editingChanged)
        lumpsum_reinvest_stack.arrangedSubviews[1].isHidden = true
        product_name.text = p_name
        currentNav.text = C_NAV
        print(OPT_code!,"#####")
        print("hello")
        buylumpusum_map(row: row)
        if OPT_code! == "2" {
            mainViewHeight.constant = 910
            if bseschemetype == "reinvest"{
                lumpsum_reinvest_stack.arrangedSubviews[0].isHidden = false
                reinvest_payout_stack.arrangedSubviews[0].isHidden = false
                reinvest_payout_stack.arrangedSubviews[1].isHidden = true
            }else if bseschemetype == "both"{
                lumpsum_reinvest_stack.arrangedSubviews[0].isHidden = false
                reinvest_payout_stack.arrangedSubviews[0].isHidden = false
                reinvest_payout_stack.arrangedSubviews[1].isHidden = false
            }
            //lumpsum_reinvest_stack.arrangedSubviews[1].isHidden = false

        }
        else{
            mainViewHeight.constant = 800
            containHeight.constant = 250.0
            lumpsum_reinvest_stack.arrangedSubviews[0].isHidden = true
            lumpsum_reinvest_stack.arrangedSubviews[1].isHidden = true
        }
        if goal != "" {
            amounttf.text = goal
            buylumpusum_map(row: row)
        }
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Back Button Clicked")
       // navigationController?.popViewController(animated: true)
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    override func onCart1ButtonPressed(_ sender : UIButton)
    {
         self.getUserProfileStat()
    }
    
    override func onCartButtonPressed(_ sender: UIButton) {
        
        self.getUserProfileStat()
        
        
//        Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Cart Button Clicked")
//        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//
//        self.navigationController?.pushViewController(destVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func reinvest(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Re-invest Button Clicked")
        payoutOutlet.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        reinvestOutlet.setImage(UIImage(named: "check"), for: UIControlState.normal)
        lumpsum_reinvest_stack.arrangedSubviews[1].isHidden = true
    }
    
    @IBAction func payout(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Payout Button Clicked")
        payoutOutlet.setImage(UIImage(named: "check"), for: UIControlState.normal)
        reinvestOutlet.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        lumpsum_reinvest_stack.arrangedSubviews[1].isHidden = false
    }
    @IBAction func addToCart(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Add To Cart Button Clicked")
        //let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        //print(cell.textfield.text,"textfield")
        
       // let productobj = productArr[row]
        amounttf.resignFirstResponder()
        let min_amount1:Int = Int(min_amount)!
        //        print(productobj.lumpsum_Min)
        
        print(min_amount1)
        if amounttf.text == "" {
            amounttf.resignFirstResponder()
            Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Please enter amount")
            self.presentWindow.makeToast(message: "Please enter amount")
        }
        else if Int(amounttf.text!)! < min_amount1 {
            print("min_amount")
            amounttf.resignFirstResponder()
            Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Minimum amount should be \(min_amount1)")
            self.presentWindow.makeToast(message: "Minimum amount should be \(min_amount1)")
            // print("hello")
        }
        else{
            lumpsum_addToCart(row:row)
            print("add to cart")
        }
        
    }
    
    @objc func textFieldDidChange(_textField: UITextField) {
        
        print("myTargetFunction")
        
//        value3.removeAll()
//        value2.removeAll()
//        value1.removeAll()
        
        buylumpusum_map(row:row)
        
        
    }
    
    func buylumpusum_map(row:Int){
        print(row ,"row data")
        var results  = [Int]()
        //let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        //let cell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        barChartView.delegate = self
        barChartView.isHidden = false
        barChartView.doubleTapToZoomEnabled = false
        barChartView.highlightPerTapEnabled = false
        barChartView.chartDescription?.enabled = false
        if amounttf.text != ""{
            barChartView.isHidden = false
            
            //print(texindex,"texindex")
            print(row,"row")
            var year = [3.0,5.0,10.0]
            var rate_interest =  [0.10, 0.12, 0.15]
            var principal_amount = Int(amounttf.text!)
            for i in 0..<year.count {
                // Log.d("TAG", "RATE OF INTEREST===" + rate_interest[i]);
                //loop for years
                for j in 0..<year.count {
                    let math = pow(1 + rate_interest[i], year[j])
                    var compund_interest = (Double(principal_amount!) * math );
                    print(compund_interest,"compund_interest")
                    results.append(Int(compund_interest.rounded()))
                }
            }
            
        }
        else{
            print("Please Enter")
            //presentWindow?.makeToast(message: "Please Enter")
        }
        print(results)
        
        let xaxis = barChartView.xAxis
        
        xaxis.drawGridLinesEnabled = false
        
        xaxis.centerAxisLabelsEnabled = true
        let formatter = CustomLabelsXAxisValueFormatter()//custom value formatter
        formatter.labels = self.months
        xaxis.valueFormatter = formatter
        //xaxis.valueFormatter = IndexAxisValueFormatter(values:months)
        
        xaxis.labelPosition = .bottom
        xaxis.granularity = 1
        xaxis.granularityEnabled = true
        xaxis.labelCount = 30
        
        xaxis.labelFont = .systemFont(ofSize: 10)
        // xaxis?.setLabelCount(, force: true)
        //xaxis?.valueFormatter = DefaultAxisValueFormatter { (value, axis) -> String in return self.months[Int(value)] }
        
        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.maximumFractionDigits = 1
        
        let yaxis = barChartView.leftAxis
        yaxis.spaceTop = 0.35
        yaxis.axisMinimum = 0
        yaxis.drawGridLinesEnabled = true
        
        barChartView.rightAxis.enabled = false
        barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        var dataEntries1: [BarChartDataEntry] = []
        var dataEntries2: [BarChartDataEntry] = []
        //dataEntries.append(results[0])
        if results.isEmpty {
            for i in 0..<months.count{
                let dataEntry = BarChartDataEntry(x: Double(i), y: Double(0), data: months[i] as AnyObject)
                dataEntries.append(dataEntry)
                
            }
            print(dataEntries)
            
//            let chartDataSet = BarChartDataSet(values: dataEntries, label: "Values")
//            let dataSets: [BarChartDataSet] = [chartDataSet]
            
            let chartDataSet = BarChartDataSet(values: dataEntries, label: "3 YEARS")
            let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "5 YEARS")
            let chartDataSet2 = BarChartDataSet(values: dataEntries2, label: "10 YEARS")
            
            let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1,chartDataSet2]
            chartDataSet.colors = [UIColor(red: 45/255, green: 180/255, blue: 232/255, alpha: 1)]
           // let chartData = BarChartData(dataSets: dataSets)
            chartDataSet.colors = [UIColor(red: 45/255, green: 180/255, blue: 232/255, alpha: 1)]
            chartDataSet1.colors = [UIColor(red: 116/255, green: 239/255, blue: 219/255, alpha: 1)]
            chartDataSet2.colors = [UIColor(red: 136/255, green: 187/255, blue: 79/255, alpha: 1)]
            
            chartDataSet.highlightColor = NSUIColor(red: 45/255, green: 180/255, blue: 232/255, alpha: 1)
            chartDataSet1.highlightColor = NSUIColor(red: 116/255, green: 239/255, blue: 219/255, alpha: 1)
            chartDataSet2.highlightColor = NSUIColor(red: 136/255, green: 187/255, blue: 79/255, alpha: 1)
            
            
            let chartData = BarChartData(dataSets: dataSets)
            let barWidth = 0.9
            let groupSpace = 0.8
            let barSpace = 0.05
            
            let groupCount = self.months.count
            let startYear = 0
            
            
            chartData.barWidth = barWidth;
            barChartView.xAxis.axisMinimum = Double(startYear)
            let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
            print("Groupspace: \(gg)")
            barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
            
            chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
            //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
            
            
            
            barChartView.notifyDataSetChanged()
            barChartView.data?.setValueFormatter(valueFormatter)
            barChartView.data = chartData
            
            barChartView.backgroundColor = UIColor.white
            
            lumpsum_3.text = "₹ 0"
            lumpsum_5.text = "₹ 0"
            lumpsum_10.text = "₹ 0"
            percentValue.text = "10%"
        }
        else{
            print("hello")
            barChartView.highlightPerTapEnabled = true
            if results.count > 0{
                var dataEntry = BarChartDataEntry(x: Double(0) , y: Double(results[0]))
                dataEntries.append(dataEntry)
                dataEntry = BarChartDataEntry(x: Double(0) , y: Double(results[3]))
                dataEntries.append(dataEntry)
                dataEntry = BarChartDataEntry(x: Double(0) , y: Double(results[6]))
                
                dataEntries.append(dataEntry)
                value1.removeAll()
                value1.append(results[0])
                value1.append(results[1])
                value1.append(results[2])
                
                var dataEntry1 = BarChartDataEntry(x: Double(0) , y: Double(results[1]))
                dataEntries1.append(dataEntry1)
                dataEntry1 = BarChartDataEntry(x: Double(0) , y: Double(results[4]))
                dataEntries1.append(dataEntry1)
                dataEntry1 = BarChartDataEntry(x: Double(0) , y: Double(results[7]))
                dataEntries1.append(dataEntry1)
                
                
                value2.removeAll()
                value2.append(results[3])
                value2.append(results[4])
                value2.append(results[5])
                
                var dataEntry2 = BarChartDataEntry(x: Double(0) , y: Double(results[2]))
                dataEntries2.append(dataEntry2)
                dataEntry2 = BarChartDataEntry(x: Double(0) , y: Double(results[5]))
                dataEntries2.append(dataEntry2)
                dataEntry2 = BarChartDataEntry(x: Double(0) , y: Double(results[8]))
                dataEntries2.append(dataEntry2)
                
                
                value3.removeAll()
                value3.append(results[6])
                value3.append(results[7])
                value3.append(results[8])
                //print(value3)
                let chartDataSet = BarChartDataSet(values: dataEntries, label: "3 YEARS")
                let chartDataSet1 = BarChartDataSet(values: dataEntries1, label: "5 YEARS")
                let chartDataSet2 = BarChartDataSet(values: dataEntries2, label: "10 YEARS")
                let dataSets: [BarChartDataSet] = [chartDataSet,chartDataSet1,chartDataSet2]
                chartDataSet.colors = [UIColor(red: 45/255, green: 180/255, blue: 232/255, alpha: 1)]
                chartDataSet1.colors = [UIColor(red: 116/255, green: 239/255, blue: 219/255, alpha: 1)]
                chartDataSet2.colors = [UIColor(red: 136/255, green: 187/255, blue: 79/255, alpha: 1)]
                
                chartDataSet.highlightColor = NSUIColor(red: 45/255, green: 180/255, blue: 232/255, alpha: 1)
                chartDataSet1.highlightColor = NSUIColor(red: 116/255, green: 239/255, blue: 219/255, alpha: 1)
                chartDataSet2.highlightColor = NSUIColor(red: 136/255, green: 187/255, blue: 79/255, alpha: 1)
                
                
                let chartData = BarChartData(dataSets: dataSets)
                
                
                let groupSpace = 0.8
                let barSpace = 0.05
                let barWidth = 0.9
                // (0.3 + 0.05) * 2 + 0.3 = 1.00 -> interval per "group"
                
                let groupCount = self.months.count
                let startYear = 0
                
                
                chartData.barWidth = barWidth;
                barChartView.xAxis.axisMinimum = Double(startYear)
                let gg = chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
                print("Groupspace: \(gg)")
                barChartView.xAxis.axisMaximum = Double(startYear) + gg * Double(groupCount)
                
                chartData.groupBars(fromX: Double(startYear), groupSpace: groupSpace, barSpace: barSpace)
                //chartData.groupWidth(groupSpace: groupSpace, barSpace: barSpace)
                
                
                
                barChartView.notifyDataSetChanged()
                
                barChartView.data = chartData
                barChartView.data?.setValueFormatter(valueFormatter)
                barChartView.backgroundColor = UIColor.white
                
                barChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .linear)
                let formatter = NumberFormatter()              // Cache this,
                formatter.locale = Locale(identifier: "en_IN") // Here indian local
                formatter.numberStyle = .decimal
                let intString = String(value1[0])
                let fv = Double(intString)
                let string = formatter.string(from: NSNumber(value: fv!))
                let intString1 = String(value1[1])
                let fv1 = Double(intString1)
                let string1 = formatter.string(from: NSNumber(value: fv1!))
                let intString2 = String(value1[2])
                let fv2 = Double(intString2)
                let string2 = formatter.string(from: NSNumber(value: fv2!))
                lumpsum_3.text = "₹ " + "\(string ?? "")"
                lumpsum_5.text = "₹ " + "\(string1 ?? "")"
                lumpsum_10.text = "₹ " + "\(string2 ?? "")"
                percentValue.text = "10%"
            }
            else{
                _ = amounttf.resignFirstResponder()
                //errorHighlightTextField(textField: cell.textfield
                barChartView.isHidden = true
                
                presentWindow?.makeToast(message: "Please Enter Amount")
            }
        }
        
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        // var result_sip  = [Int]()
        let pos = NSInteger(entry.x)
        if value1.count > 0 {
            if pos == 0  || pos == 1 || pos == 2{
                let formatter = NumberFormatter()              // Cache this,
                formatter.locale = Locale(identifier: "en_IN") // Here indian local
                formatter.numberStyle = .decimal
                let intString = String(value1[0])
                let fv = Double(intString)
                let string = formatter.string(from: NSNumber(value: fv!))
                let intString1 = String(value1[1])
                let fv1 = Double(intString1)
                let string1 = formatter.string(from: NSNumber(value: fv1!))
                let intString2 = String(value1[2])
                let fv2 = Double(intString2)
                let string2 = formatter.string(from: NSNumber(value: fv2!))
                lumpsum_3.text = "₹ " + "\(string ?? "")"
                lumpsum_5.text = "₹ " + "\(string1 ?? "")"
                lumpsum_10.text = "₹ " + "\(string2 ?? "")"
                percentValue.text = "10%"
                print(self.value1)
                Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- 10%  Chart Value Clicked")
                
            }
            else if pos == 4 || pos == 5 || pos == 6{
                print(self.value2)
                let formatter = NumberFormatter()              // Cache this,
                formatter.locale = Locale(identifier: "en_IN") // Here indian local
                formatter.numberStyle = .decimal
                let intString = String(value2[0])
                let fv = Double(intString)
                let string = formatter.string(from: NSNumber(value: fv!))
                let intString1 = String(value2[1])
                let fv1 = Double(intString1)
                let string1 = formatter.string(from: NSNumber(value: fv1!))
                let intString2 = String(value2[2])
                let fv2 = Double(intString2)
                let string2 = formatter.string(from: NSNumber(value: fv2!))
                lumpsum_3.text = "₹ " + "\(string ?? "")"
                lumpsum_5.text = "₹ " + "\(string1 ?? "")"
                lumpsum_10.text = "₹ " + "\(string2 ?? "")"
                percentValue.text = "12%"
                Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- 12%  Chart Value Clicked")
                
            }
            else if pos == 8 || pos == 9 || pos == 10 {
                print(self.value3)
                let formatter = NumberFormatter()              // Cache this,
                formatter.locale = Locale(identifier: "en_IN") // Here indian local
                formatter.numberStyle = .decimal
                let intString = String(value3[0])
                let fv = Double(intString)
                let string = formatter.string(from: NSNumber(value: fv!))
                let intString1 = String(value3[1])
                let fv1 = Double(intString1)
                let string1 = formatter.string(from: NSNumber(value: fv1!))
                let intString2 = String(value3[2])
                let fv2 = Double(intString2)
                let string2 = formatter.string(from: NSNumber(value: fv2!))
                lumpsum_3.text = "₹ " + "\(string ?? "")"
                lumpsum_5.text = "₹ " + "\(string1 ?? "")"
                lumpsum_10.text = "₹ " + "\(string2 ?? "")"
                percentValue.text = "15%"
                Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- 15%  Chart Value Clicked")
            }
        }
            
        
        else{
           // print(SIP_value)
            lumpsum_3.text = "₹ 0"
            lumpsum_5.text = "₹ 0"
            lumpsum_10.text = "₹ 0"
            percentValue.text = "15%"
        }
    }

    
    func lumpsum_addToCart(row:Int){
        var userid = UserDefaults.standard.value(forKey: "userid")  as? String
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        let amount = amounttf.text
        _ = "add"
        let type = "1"
        var payout = ""
        let invopt = "1"
        if  OPT_code == "2"{
            if lumpsum_reinvest_stack.arrangedSubviews[1].isHidden == false {
                payout = "payout"
                
            }
            else{
                payout = "reinvest"
                print(payout)
            }
            
        }
        let s_date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: s_date)
        print(date)
        let parameters = ["id":"\(schemecode!.covertToBase64())","amount":amount!.covertToBase64(),"type":type.covertToBase64(),"sessionid":sessionId!.covertToBase64(),"payout":invopt.covertToBase64(),"invopt":payout.covertToBase64(),"userid":userid!.covertToBase64(),"start_date":"\(date.covertToBase64())","enc_resp":"3"] as [String : Any]
        print(parameters)
        presentWindow.makeToastActivity(message: "Adding.")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.Add_To_Cart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value)
                    print(response.result.value!)
                    let r1 = response.result.value
                    let enc1 = r1?.replacingOccurrences(of: "\n" , with: "")
                    let response = enc1?.base64Decoded() ?? ""
                    if response == "\"true\""{
                        print("true response")
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Added to cart successfully!")
                        Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Added to cart successfully!")
                        
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
                            
                            Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Cart Button Clicked")
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
extension lumpsumViewController: IValueFormatter {
    func stringForValue(_ value: Double, entry: ChartDataEntry, dataSetIndex: Int, viewPortHandler: ViewPortHandler?) -> String {
        var abc = [String]()
        var abc1 = [String]()
        var abc2 = [String]()
        for i in 0..<value1.count {
            let intString = String(value1[i])
            let fv = Double(intString)
            let intString1 = String(value2[i])
            let fv1 = Double(intString1)
            let intString2 = String(value3[i])
            let fv2 = Double(intString2)
            let formatter = NumberFormatter()              // Cache this,
            formatter.locale = Locale(identifier: "en_IN") // Here indian local
            formatter.numberStyle = .decimal
            let string = formatter.string(from: NSNumber(value: fv!))
            abc.append("₹ \(string!)")
            let string1 = formatter.string(from: NSNumber(value: fv1!))
            abc1.append("₹ \(string1!)")
            let string2 = formatter.string(from: NSNumber(value: fv2!))
            abc2.append("₹ \(string2!)")
            print(string,"string")
            
        }
        if value1.count > 0 {
            switch value {
                
            case Double(value1[0]): return abc[0]
            case Double(value1[1]): return abc[1]
            case Double(value1[2]): return abc[2]
            case Double(value2[0]): return abc1[0]
            case Double(value2[1]): return abc1[1]
            case Double(value2[2]): return abc1[2]
            case Double(value3[0]): return abc2[0]
            case Double(value3[1]): return abc2[1]
            case Double(value3[2]): return abc2[2]
            default: return abc[2]
            }
            
        }
         return "0"
    }
    
    
}
