//
//  ProductDetailInfoViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 08/03/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import Mixpanel
class ProductDetailInfoViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,ChartViewDelegate,ExpandableHeaderViewDelegate {
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var tableViewNav: UITableView!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var sectorAllocation: UILabel!
    
    @IBOutlet weak var expenseRatio: UILabel!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
   
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var schemeName: UILabel!
    @IBOutlet weak var fundHouse: UILabel!
    
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var turnOver: UILabel!
    @IBOutlet weak var riskoMeter: UILabel!
    @IBOutlet weak var launchDate: UILabel!
    
    @IBOutlet weak var minimumInvestment: UILabel!
    
    @IBOutlet weak var minimumAdditionalInvestment: UILabel!
    
    @IBOutlet weak var minimumSIPInvestment: UILabel!
    @IBOutlet weak var NAVViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var minimumCheques: UILabel!
    var Scheme_code : String!
    var Scheme_name : String!
    var holdings_arr = [Dictionary<String,String>]()
    var assets_arr = [Dictionary<String,String>]()
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    var unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    var colors: [UIColor] = []
    var sections = [Section]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        top5Tableview.delegate = self
        top5Tableview.dataSource = self
        print(Scheme_name)
        NAVViewHeight.constant = 0.0
        topFiveHoldingHeight.constant = 0.0
        performanceHistoryHeightConstant.constant = 0.0
        //mainViewHeight.constant = 1200.0
        schemeName.text = Scheme_name!
        getSchemeDetail(Scheme_code: Scheme_code!)
        getSchemeAsset(Scheme_code: Scheme_code!)
        addBackbutton()
        pieChartView.delegate = self
        pieChartView.backgroundColor = UIColor.white
        

        // Do any additional setup after loading the view.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Fund Info Screen :- Back Button Clicked")
        navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == top5Tableview {
            return holdings_arr.count
        } else {
            return colors.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         if tableView == top5Tableview {
            return UITableViewAutomaticDimension
         }else{
            return 50
        }
        
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if tableView == top5Tableview {
            let cell = tableView.dequeueReusableCell(withIdentifier: "top5", for: indexPath) as? top5Fund
            cell?.compName.text = holdings_arr[indexPath.row]["Compname"]
            cell?.holding.text = holdings_arr[indexPath.row]["Holdpercentage"]
            cell?.sector.text = holdings_arr[indexPath.row]["sector"]
            return cell!
        }else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "schemeInfo", for: indexPath) as? productDetailCell
            
            let totalSum = unitsSold.reduce(0, +)
            print(unitsSold[indexPath.row]/totalSum * 100)
            let P_Calculation = unitsSold[indexPath.row]
            let text = String(format: "%.2f", arguments: [P_Calculation])
            cell?.colorLabel.backgroundColor = colors[indexPath.row]
            cell?.legendName.text = months[indexPath.row]
            cell?.legendPrice.text = text + " %"
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tableViewNav {
            print("did select")
        }
        
    }
   
    func getSchemeDetail(Scheme_code:String){
        //let url = "http://www.erokda.in/adminpanel/schemedata/schemedata_ws.php/showscheme
        
        //  txn_id="",user_id, cart_id = "response off above web service", bank_id, status="", trxntype="R", folio_no
        
        let parameters = ["id":"\(Scheme_code)","enc_resp":"3"]
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.showscheme)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    print(enc_response)
                    var dict = [String:Any]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    print(enc1)
                    if let enc = enc1?.base64Decoded() {
                        print(enc)
                        dict = self.convertToDictionary3(text: enc)!
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    print(response.result.value ?? "showscheme")
                    let data1 = dict
                    print(data1["schemedet"])
                    //print(data.value)
                   
                    //print(response.value!)
                    //self.presentWindow.hideToastActivity()
                    if let data = data1 as? NSDictionary{
                        if let schemedet =  data.value(forKey: "schemedet") as? [AnyObject]{
                            print(schemedet)
                            self.presentWindow.hideToastActivity()
                            for schemedetDetail in schemedet{
                                if let fund_house = schemedetDetail.value(forKey: "fund_house") as? String,
                                    let launchdate = schemedetDetail.value(forKey: "launchdate") as? String,
                                     let riskometer = schemedetDetail.value(forKey: "riskometer") as? String,
                                     let fund_type = schemedetDetail.value(forKey: "fund_type") as? String,
                                     let mininvt = schemedetDetail.value(forKey: "mininvt") as? String{
                                    let SIPADDNINVEST = schemedetDetail.value(forKey: "SIPADDNINVEST") as? String ?? ""
                                    let SIPFREQUENCYNO = schemedetDetail.value(forKey: "SIPFREQUENCYNO") as? String ?? ""
                                     let minsipinvt = schemedetDetail.value(forKey: "minsipinvt") as? String ?? "0"
                                     let tr_mode = schemedetDetail.value(forKey : "tr_mode") as? String ?? ""
                                     let turnover_ratio = schemedetDetail.value(forKey: "turnover_ratio") as? String  ?? ""
                                     let currnt_nav = schemedetDetail.value(forKey: "currnt_nav") as? String ?? "0.00"
                                     let sixmonthnav = schemedetDetail.value(forKey: "sixmonthnav") as? String ?? "0.00"
                                     let oneyrnav = schemedetDetail.value(forKey: "oneyrnav") as? String ?? "0.00"
                                     let threeyrnav = schemedetDetail.value(forKey: "threeyrnav") as? String ?? "0.00"
                                    let fiveyrnav = schemedetDetail.value(forKey: "fiveyrnav") as? String ?? "0.00"
                                    let sixmonthret = schemedetDetail.value(forKey: "sixmonthret") as? String ?? "0.00"
                                    let threemonthret = schemedetDetail.value(forKey: "threemonthret") as? String ?? "0.00"
                                    let oneyearret = schemedetDetail.value(forKey: "oneyearret") as? String ?? "0.00"
                                    let threeyearret = schemedetDetail.value(forKey: "threeyearret") as? String ?? ""
                                    let fiveyearret = schemedetDetail.value(forKey: "fiveyearret") as? String ?? ""
                                    let category = schemedetDetail.value(forKey: "CATEGORY") as? String ?? ""
                                    let RT_NAME = schemedetDetail.value(forKey: "RT_NAME") as? String ?? ""
                                    let fundmanager = schemedetDetail.value(forKey: "fundmanager") as? String ?? ""
                                    let class_name = schemedetDetail.value(forKey: "CLASSNAME") as? String ?? ""
                                    let benchmark = schemedetDetail.value(forKey: "scheme_benchmark") as? String ?? ""
                                    let corpus = schemedetDetail.value(forKey: "corpus") as? String ?? ""
                                    let maxexitload = schemedetDetail.value(forKey: "maxexitload") as? String ?? "0"
                                    let maxentryload = schemedetDetail.value(forKey: "maxentryload") as? String ?? "0"
                                    let corpus_date = schemedetDetail.value(forKey: "corpus_date") as? String ?? ""
                                   /// CATEGORY RT_NAME benchmark
                                    self.registrarName.text = RT_NAME
                                    self.fundManager.text = fundmanager
                                    //self.fundClass.text = class_name
                                    
                                    let corpus_per = Double(corpus)!/100
                                    let doubleStr3 = String(format: "%.2f", corpus_per)
                                    if benchmark != "" {
                                        self.schemeBenchmark.text = benchmark
                                    } else{
                                        self.schemeBenchmark.text = "N/A"
                                    }
                                    if corpus != "" {
                                        self.corpus.text = "\(doubleStr3) cr (As on \(corpus_date.toDateWithFormat()!))"
                                    } else{
                                        self.corpus.text = "N/A"
                                    }
                                    
                                    
                                  //  self.entryLoad.text = maxentryload
                                    self.exitLoad.text = maxexitload
                                    
                                    
                                   
                                    
                                    
                                    if threemonthret != "" {
                                        let roundthreemonthret = Float(threemonthret)
                                        let tm = (roundthreemonthret! * 100).rounded() / 100
                                        self.threeMonthret.text = String(tm) + " %"
                                    } else{
                                        self.threeMonthret.text =  "0.00%"
                                    }
                                    if sixmonthret != "" {
                                        let roundsixmonthret = Float(sixmonthret)
                                        let sm = (roundsixmonthret! * 100).rounded() / 100
                                       self.sixMonthRet.text = String(sm) + " %"
                                    } else{
                                        self.sixMonthRet.text = "0.00%"
                                    }
                                    if oneyearret != "" && oneyearret != "0" {
                                         let roundoneyearret = Float(oneyearret)
                                         let oy = (roundoneyearret! * 100).rounded() / 100
                                        self.oneYearRet.text = String(oy) + " %"
                                    } else{
                                        self.oneYearRet.text = "0.00%"
                                    }
                                    if threeyearret != "" && threeyearret != "0" {
                                        let roundthreeyearret = Double(threeyearret)
                                        let doubleStr3 = String(format: "%.2f", roundthreeyearret!)
                                        let ty = (roundthreeyearret! * 100).rounded() / 100
                                        self.threeYearRet.text = String(doubleStr3) + " %"
                                    } else{
                                        self.threeYearRet.text = "0.00%"
                                    }
                                    if fiveyearret != "" && fiveyearret != "0" {
                                        let roundfiveyearret = Float(fiveyearret)
                                        let fy = (roundfiveyearret! * 100).rounded() / 100
                                        self.fiveYearRet.text = String(fy) + " %"
                                    } else {
                                       self.fiveYearRet.text  = "0.00%"
                                    }
                                    if turnover_ratio == nil || turnover_ratio == "0"  || turnover_ratio == ""{
                                        self.turnOver.text = "N/A"
                                    }else if  tr_mode == "times"{
                                        print(turnover_ratio)
                                        //print(Double(turnover_ratio)! * 100)
                                        let turnoer_P = Double(turnover_ratio)! * 100
                                        self.turnOver.text = "\(turnoer_P)%"
                                    }
                                    else{
                                        self.turnOver.text = "\(turnover_ratio)%"
                                    }
                                    
                                    
                                    if fund_type == "1"{
                                         self.type.text = "Open-ended"
                                    }else{
                                         self.type.text = "Close-ended"
                                    }
                                    let dateFormatter = DateFormatter()
                                    
                                    dateFormatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                                    let startTime = dateFormatter.date(from: "\(launchdate)")
                                    let dateFormatter1 = DateFormatter()
                                    
                                    dateFormatter1.dateFormat = "MMMM dd, yyyy"
                                    print(dateFormatter1.string(from: startTime!))
                                    print(dateFormatter.string(from: startTime!))
                                    print(fund_house)
                                   // self.fundHouse.text = "\(fund_house)"
                                    self.launchDate.text = "\(dateFormatter1.string(from: startTime!))"
                                   // self.riskoMeter.text = "\(riskometer)"
                                    self.lumpsumInvestment.text = "₹ \(mininvt)"
                                    self.sipInvestment.text = "₹ \(minsipinvt)"
                                   // self.category.text = category
                                   // self.minimumInvestment.text = "\(mininvt)"
                                  //  self.minimumSIPInvestment.text = "\(minsipinvt)"
                                  //  self.minimumCheques.text = "\(SIPFREQUENCYNO)"
                                 //   self.minimumAdditionalInvestment.text = "\(SIPADDNINVEST)"
                                    var NAV_Trend_detail_arr = [Dictionary<String,String>]()
                                    var performence_history = [Dictionary<String,String>]()
                                    NAV_Trend_detail_arr = [["currnt_nav":currnt_nav,"sixmonthnav":sixmonthnav,"oneyrnav":oneyrnav,"threeyrnav":threeyrnav,"fiveyrnav":fiveyrnav]]
                                    performence_history = [["currnt_nav":threemonthret,"sixmonthnav":sixmonthret,"oneyrnav":oneyearret,"threeyrnav":threeyearret,"fiveyrnav":fiveyearret]]
//                                    NAV_Trend_detail_arr.append(["currnt_nav":currnt_nav])
//                                    NAV_Trend_detail_arr.append(["sixmonthnav":sixmonthnav])
//                                    NAV_Trend_detail_arr.append(["oneyrnav":oneyrnav])
//                                    NAV_Trend_detail_arr.append(["threeyrnav":threeyrnav])
//                                    NAV_Trend_detail_arr.append(["fiveyrnav":fiveyrnav])
                                    print(NAV_Trend_detail_arr,"NAVARR")
                                    self.sections.append(Section(genre: "NAV Trend", movies: NAV_Trend_detail_arr, expanded: false))
                                    self.sections.append(Section(genre: "Performance History", movies: performence_history, expanded: false))
                                    print(self.sections)
                                    //self.mainViewHeight.constant  = 1000.0
                                }
                            }
                            
                        }
                        if let holdings =  data.value(forKey: "holdings") as? [AnyObject]{
                            
                            for holdingsDetail in holdings{
                                if let Holdpercentage = holdingsDetail.value(forKey: "Holdpercentage") as? String,
                                    let Compname = holdingsDetail.value(forKey: "Compname") as? String{
                                    let roundHoldpercentage = Float(Holdpercentage)
                                    let hp = (roundHoldpercentage! * 100).rounded() / 100
                                    let sector = holdingsDetail.value(forKey: "Sector") as? String ?? ""
                                    self.holdings_arr.append(["Holdpercentage":String(hp) + "%","Compname":Compname,"sector":sector])
                                   
                                }
                             }
                            self.top5Tableview.reloadData()
                        } else{
                            self.top5HoldingLabel.isHidden = true
                            self.top5Image.isHidden = true
                            //self.mainViewHeight.constant  = 1200.0
                        }
                        if let holdings =  data.value(forKey: "asset_allocation") as? [AnyObject]{
                            var text = ""
                            for holdingsDetail in holdings{
                                if let Holdpercentage = holdingsDetail.value(forKey: "holding") as? String,
                                    let Compname = holdingsDetail.value(forKey: "asset") as? String{
                                    self.assets_arr.append(["Holdpercentage":Holdpercentage,"Compname":Compname])
                                    let roundHoldpercentage = Double(Holdpercentage)
                                    let doubleStr = String(format: "%.2f", roundHoldpercentage!)
                                    //let hp = (roundHoldpercentage! * 100).rounded() / 100
                                    if text.isEmpty {
                                        text = Compname + " : \(doubleStr)%"
                                    } else {
                                        text += " , \(Compname) : \(doubleStr)%"
                                    }
                                }
                            }
                           // let sentence = assets_arr.joinWithSeparator(separator: ",")
                            self.assetAllocation.text = text
                        }
                        if let navhistory =  data.value(forKey: "navhistory") as? [AnyObject] {
                            for navhistoryDetail in navhistory {
                                let currnt_nav = navhistoryDetail.value(forKey: "currentnav") as? String ?? "0.00"
                                let sixmonthnav = navhistoryDetail.value(forKey: "sixmonthsnav") as? String ?? "0.00"
                                let oneyrnav = navhistoryDetail.value(forKey: "oneyearnav") as? String ?? "0.00"
                                let threeyrnav = navhistoryDetail.value(forKey: "threeyearsnav") as? String ?? "0.00"
                                let fiveyrnav = navhistoryDetail.value(forKey: "fiveyearsnav") as? String ?? "0.00"
                                if currnt_nav != "" {
                                    let round = Double(currnt_nav)
                                    let doubleStr = String(format: "%.4f", round!)
                                    self.lates_nave.text  = "₹ " + doubleStr
                                }else {
                                    self.lates_nave.text  = "₹ 0.0000"
                                }
                                if sixmonthnav != "" {
                                    let round = Double(sixmonthnav)
                                    let doubleStr = String(format: "%.4f", round!)
                                    self.sixMonth.text = "₹ " + doubleStr
                                } else {
                                    self.sixMonth.text = "₹ 0.0000"
                                }
                                if threeyrnav != "" {
                                    let round = Double(threeyrnav)
                                    let doubleStr = String(format: "%.4f", round!)
                                    self.threeYearNav.text = "₹ " + doubleStr
                                } else {
                                    self.threeYearNav.text = "₹ 0.0000"
                                }
                                if oneyrnav != ""{
                                    let round = Double(oneyrnav)
                                    let doubleStr = String(format: "%.4f", round!)
                                    self.oneYearNav.text = "₹ " + doubleStr
                                } else{
                                    self.oneYearNav.text = "₹ 0.0000"
                                }
                                if fiveyrnav != "" {
                                    let round = Double(fiveyrnav)
                                    let doubleStr = String(format: "%.4f", round!)
                                    self.fiveYearNav.text = "₹ " + doubleStr
                                } else {
                                    self.fiveYearNav.text = "₹ 0.0000"
                                }
                            }
                        }
                        if let exit_load =  data.value(forKey: "exit_load") as? [AnyObject] {
                            for exit_load_Detail in exit_load {
                                let exit_load = exit_load_Detail.value(forKey: "exit_load") as? String ?? "0.00"
                                 let exit_load_remarks = exit_load_Detail.value(forKey: "exit_load_remarks") as? String ?? "0.00"
                                self.exitLoad.text = "\(exit_load_remarks)"
                                
                            }
                        }
                        if let expence_ratio =  data.value(forKey: "expence_ratio") as? [AnyObject] {
                            for expence_ratio_Detail in expence_ratio {
                                let exp_ratio = expence_ratio_Detail.value(forKey: "exp_ratio") as? String ?? "0.00"
                                let ratio_date = expence_ratio_Detail.value(forKey: "ratio_date") as? String ?? "0.00"
                                self.expenseRatio.text = "\(exp_ratio)% (As on \(ratio_date.toDateWithFormat()!))"
                                
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
    
    func getSchemeAsset(Scheme_code:String){
        //let url = "http://www.erokda.in/adminpanel/schemedata/schemedata_ws.php/showscheme
        
        //  txn_id="",user_id, cart_id = "response off above web service", bank_id, status="", trxntype="R", folio_no
        
        let parameters = ["id":"\(Scheme_code)"]
        print(parameters)
        months.removeAll()
        unitsSold.removeAll()
        colors.removeAll()
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.showschemeAsset)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                    //print(response.value!)
                    self.presentWindow.hideToastActivity()
                    print(response.result.value)
                    if let data = response.result.value as? [AnyObject]{
                        if !data.isEmpty{
                             self.mainViewHeight.constant = 1500.0
                            // self.tableViewHeight.constant = 500.0
                            //print(schemedet)
                            for type in data{
                               print(type)
                                if let name = type.value(forKey: "name") as? String,
                                    let value = type.value(forKey: "y") as? Double {
                                    print(name,value)
                                    self.months.append(name)
                                    self.unitsSold.append(value)
                                    
                                }
                        }
                            self.sectorAllocation.isHidden = false
                            self.setChart(dataPoints: self.months, values: self.unitsSold)
                        }
                        else{
                            self.mainViewHeight.constant = 920.0
                            self.pieCahrtViewHeight.constant = 0.0
                           // self.tableViewHeight.constant = 0.0
                            self.sectorAllocation.isHidden = true
                            self.pieChartView.isHidden = true
                            self.tableView.isHidden = true
                        }
                    }
                    
                    
            }
            
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        print(dataPoints,"data",values)
       // tableView.reloadData()
        var chartDataEntries: [ChartDataEntry] = []
        pieChartView.holeRadiusPercent = 0.3
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.chartDescription?.text = ""
        pieChartView.legend.enabled = false
        pieChartView.notifyDataSetChanged()

        for i in 0..<dataPoints.count {
            
            let chartDataEntry = PieChartDataEntry(value : values[i], label: dataPoints[i])
            //  PieChartDataEntry(value: values[i], label: dataPoints[i])
            //let chartDataEntry1 = chartDataEntry()
            chartDataEntries.append(chartDataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: chartDataEntries, label: "")
        let chartAttribute = [ NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 12.0)! ]
        let chartAttrString = NSAttributedString(string: "", attributes: chartAttribute)
        pieChartView.centerAttributedText = chartAttrString
        var colors1 : [UIColor] = [UIColor(red: CGFloat(192/255), green: CGFloat(255/255), blue: CGFloat(140/255), alpha: 1),
                                   UIColor(red: CGFloat(255/255), green: CGFloat(247/255), blue: CGFloat(140/255), alpha: 1),
                                   UIColor(red: CGFloat(255/255), green: CGFloat(208/255), blue: CGFloat(140/255), alpha: 1),
                                   UIColor(red: CGFloat(140/255), green: CGFloat(234/255), blue: CGFloat(255/255), alpha: 1),
                                   UIColor(red: CGFloat(255/255), green: CGFloat(140/255), blue: CGFloat(157/255), alpha: 1),
                                   UIColor(red: CGFloat(80/255), green: CGFloat(180/255), blue: CGFloat(50/255), alpha: 1),
                                   UIColor(red: CGFloat(5/255), green: CGFloat(141/255), blue: CGFloat(199/255), alpha: 1),
                                   UIColor(red: CGFloat(106/255), green: CGFloat(249/255), blue: CGFloat(196/255), alpha: 1),
                                   UIColor(red: CGFloat(0/255), green: CGFloat(0/255), blue: CGFloat(139/255), alpha: 1),
                                   UIColor(red: CGFloat(255/255), green: CGFloat(160/255), blue: CGFloat(122/255), alpha: 1)]
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
            
            
            pieChartDataSet.colors = colors
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.flashScrollIndicators()
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
     
        self.pieChartView.data = pieChartData
        pieChartView.drawEntryLabelsEnabled = false
        pieChartDataSet.drawValuesEnabled = false
       
    }
    @IBAction func navButton(_ sender: Any) {
        if NAVView.isHidden {
            self.curr_nav_label.text = "Latest Nav"
            self.six_monthNav_label.text = "6 Months"
            self.one_yearNav_label.text = "1 Year "
            self.three_month_year_label.text = "3 Years"
            self.five_yearNav_label.text = "5 Years"
            self.lates_nave.isHidden = false
            self.six_monthNav_label.isHidden = false
            self.sixMonth.isHidden = false
            self.threeYearNav.isHidden =  false
            self.oneYearNav.isHidden  = false
            self.fiveYearNav.isHidden = false
            self.curr_nav_label.isHidden = false
            self.five_yearNav_label.isHidden = false
            self.three_month_year_label.isHidden = false
            self.one_yearNav_label.isHidden  = false
            NAVViewHeight.constant = 200.0
            mainViewHeight.constant = mainViewHeight.constant + 200.0
            NAVView.isHidden  = false
            //minus
            navTrend.image = UIImage(named: "minus")
            Mixpanel.mainInstance().track(event: "Fund Info Screen :- Nav Trend Collapse Button Clicked")
            
        } else {
            navTrend.image = UIImage(named: "plus")
            
            Mixpanel.mainInstance().track(event: "Fund Info Screen :- Nav Trend Expand Button Clicked")
            NAVViewHeight.constant = 0.0
            mainViewHeight.constant = mainViewHeight.constant - 200.0
             NAVView.isHidden  = true
        }
    }
    @IBAction func performanceHistory(_ sender: Any) {
        if performanceHistoryView.isHidden {
            performanceHistoryView.isHidden  = false
            performanceHistoryHeightConstant.constant = 200.0
            mainViewHeight.constant = mainViewHeight.constant + 200.0
            self.threeMonthRetLabel.text = "3 Months"
            self.sixMonthRetLabel.text = "6 Months"
            self.oneYearLabel.text = "1 Year "
            self.threeYearRetLabel.text = "3 Years"
            self.fiveYearRetLabel.text = "5 Years"
            self.threeMonthRetLabel.isHidden = false
            self.sixMonthRetLabel.isHidden = false
            self.oneYearLabel.isHidden = false
            self.threeYearRetLabel.isHidden = false
            self.fiveYearRetLabel.isHidden = false
            self.threeMonthret.isHidden = false
            self.sixMonthRet.isHidden = false
            self.oneYearRet.isHidden = false
            self.threeYearRet.isHidden = false
            self.fiveYearRet.isHidden = false
            phImage.image = UIImage(named: "minus")
            Mixpanel.mainInstance().track(event: "Fund Info Screen :- Performance History Expand Button Clicked")
        }else{
            phImage.image = UIImage(named: "plus")
            Mixpanel.mainInstance().track(event: "Fund Info Screen :- Performance History Collapse Button Clicked")
            performanceHistoryView.isHidden  = true
            performanceHistoryHeightConstant.constant = 0.0
            mainViewHeight.constant = mainViewHeight.constant - 200.0
            
        }
    }
    @IBOutlet weak var performanceHistoryOutlet: UIButton!
    
    @IBAction func topFiveHolding(_ sender: Any) {
        if topFiveHoldingView.isHidden {
            if holdings_arr.count >  0 {
                for i in 0..<holdings_arr.count {
                    //top_\(i).isHidden = false
                }
                top_1.isHidden = false
                top_2.isHidden = false
                top_3.isHidden = false
                top_4.isHidden = false
                top_5.isHidden = false
                top1.isHidden = false
                top2.isHidden = false
                top3.isHidden = false
                top4.isHidden = false
                top5.isHidden = false
                print(holdings_arr)
                
                topFiveHoldingView.isHidden  = false
                topFiveHoldingHeight.constant = 300.0
                mainViewHeight.constant = mainViewHeight.constant + 300.0
                top5Image.image = UIImage(named: "minus")
                Mixpanel.mainInstance().track(event: "Fund Info Screen :- Top 5 Holdings Collapse Button Clicked")
            }
        }else{
            top5Image.image = UIImage(named: "plus")
            
            Mixpanel.mainInstance().track(event: "Fund Info Screen :- Top 5 Holdings Expand Button Clicked")
            topFiveHoldingView.isHidden  = true
            topFiveHoldingHeight.constant = 0.0
            mainViewHeight.constant = mainViewHeight.constant - 300.0
        }
    }
    @IBOutlet weak var performanceHistory: UILabel!
    @IBOutlet weak var performanceHistoryHeightConstant: NSLayoutConstraint!
    
    @IBOutlet weak var topFiveHoldingView: UIView!
    @IBOutlet weak var topFiveHoldingHeight: NSLayoutConstraint!
    @IBOutlet weak var performanceHistoryView: UIView!
    @IBOutlet weak var navButtonOutlet: UIButton!
    
    func toggleSection(header: ExpandableHeaderView, section: Int) {
        sections[section].expanded = !sections[section].expanded
        
        
        tableViewNav.beginUpdates()
        for i in 0 ..< sections[section].movies.count {
            tableViewNav.reloadRows(at: [IndexPath(row: i, section: section)], with: .automatic)
        }
        tableViewNav.endUpdates()
    }
    @IBOutlet weak var lates_nave: UILabel!
    @IBOutlet weak var sixMonth: UILabel!
    @IBOutlet weak var oneYearNav: UILabel!
    @IBOutlet weak var threeYearNav: UILabel!
    @IBOutlet weak var top5Tableview: UITableView!
    
    @IBOutlet weak var fiveYearNav: UILabel!
    @IBOutlet weak var curr_nav_label: UILabel!
    @IBOutlet weak var six_monthNav_label: UILabel!
    @IBOutlet weak var one_yearNav_label: UILabel!
    @IBOutlet weak var three_month_year_label: UILabel!
    @IBOutlet weak var five_yearNav_label: UILabel!
    @IBOutlet weak var NAVView: UIView!
    @IBOutlet weak var threeMonthret: UILabel!
    @IBOutlet weak var threeMonthRetLabel: UILabel!
    @IBOutlet weak var sixMonthRetLabel: UILabel!
    @IBOutlet weak var sixMonthRet: UILabel!
    @IBOutlet weak var oneYearLabel: UILabel!
    @IBOutlet weak var oneYearRet: UILabel!
    @IBOutlet weak var threeYearRetLabel: UILabel!
    @IBOutlet weak var threeYearRet: UILabel!
    @IBOutlet weak var fiveYearRetLabel: UILabel!
    @IBOutlet weak var pieCahrtViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var fiveYearRet: UILabel!
    @IBOutlet weak var top2: UILabel!
    @IBOutlet weak var top3: UILabel!
    @IBOutlet weak var top4: UILabel!
    @IBOutlet weak var top5: UILabel!
    @IBOutlet weak var top1: UILabel!
    @IBOutlet weak var top_1: UILabel!
    @IBOutlet weak var top_2: UILabel!
    @IBOutlet weak var top_3: UILabel!
    @IBOutlet weak var top_4: UILabel!
    @IBOutlet weak var top_5: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var fundManager: UILabel!
    @IBOutlet weak var fundClass: UILabel!
    @IBOutlet weak var lumpsumInvestment: UILabel!
    @IBOutlet weak var sipInvestment: UILabel!
    @IBOutlet weak var schemeBenchmark: UILabel!
    @IBOutlet weak var corpus: UILabel!
    @IBOutlet weak var exitLoad: UILabel!
    @IBOutlet weak var phImage: UIImageView!
    @IBOutlet weak var top5Image: UIImageView!
    @IBOutlet weak var top5HoldingLabel: UILabel!
    @IBOutlet weak var assetAllocation: UILabel!
    
    @IBOutlet weak var navTrend: UIImageView!
    @IBOutlet weak var entryLoad: UILabel!
    @IBOutlet weak var registrarName: UILabel!
}
class productDetailCell : UITableViewCell
{
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var legendName: UILabel!
    @IBOutlet weak var legendPrice: UILabel!
    
}
class top5Fund : UITableViewCell{
    
    @IBOutlet weak var compName: UILabel!
    @IBOutlet weak var holding: UILabel!
    @IBOutlet weak var sector: UILabel!
    
    
}
