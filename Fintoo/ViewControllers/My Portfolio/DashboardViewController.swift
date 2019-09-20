//
//  DashboardViewController.swift
//  Fintoo
//
//  Created by Matchpoint  on 02/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Charts
import Alamofire
import DropDown
import Mixpanel
protocol LegendCellDelegate: class {
    func legendClick(row: Int,sender:UIButton)
}

class DashboardViewController: BaseViewController,ChartViewDelegate,LegendCellDelegate {
    @IBOutlet weak var gainLossLabel: UILabel!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var legends_click_label: UILabel!
    
    @IBOutlet weak var scrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var legend_label: UILabel!
    @IBOutlet weak var activeMember: UITextField!
    
    @IBOutlet weak var sectorAllocationOutlet: UIButton!
    
    @IBOutlet weak var startinvestingview: UIView!
    @IBOutlet weak var investingBtn: UIButton!
    
    @IBOutlet weak var investingLabel: UILabel!
    
    
    @IBOutlet weak var assetAllocationOutlet: UIButton!
    
    @IBOutlet weak var chartView: PieChartView!
    
    @IBOutlet weak var investValLabel: UILabel!
    
    @IBOutlet weak var currentValLabel: UILabel!
    @IBOutlet weak var gainLabel: UILabel!
    @IBOutlet weak var xirrLabel: UILabel!
    var names = [String]()
    var id = "0"
    var UserObjects = [UserObj]()
    var Values = [Double]()
    var assetArr = [AssetObj]()
    let dropDownMember = DropDown()
    var get_member_list = [getMemberObj]()
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    var unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    var colors  : [UIColor] = []
    var sector_btn = "0"
    var loading_flag = "0"
     var colors_random = [UIColor(red: CGFloat(5.0/255.0), green: CGFloat(141.0/255.0), blue: CGFloat(199.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(105.0/255.0), green: CGFloat(205.0/255.0), blue: CGFloat(75.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(240.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(128.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(192.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(247.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(140.0/255.0), green: CGFloat(234.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(147.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(80.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(50.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(128.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(128.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(247.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(105.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(140.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(80.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(125.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(250.0/255.0), green: CGFloat(246.0/255.0), blue: CGFloat(147.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(144.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(140.0/255.0), green: CGFloat(243.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(157.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(246.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(195.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(172.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(42.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(219.0/255.0), green: CGFloat(190.0/255.0), blue: CGFloat(137.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(189.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(141.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(156.0/255.0), green: CGFloat(206.0/255.0), blue: CGFloat(160.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(225.0/255.0), green: CGFloat(178.0/255.0), blue: CGFloat(227.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(251.0/255.0), green: CGFloat(174.0/255.0), blue: CGFloat(171.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(246.0/255.0), green: CGFloat(173.0/255.0), blue: CGFloat(200.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(160.0/255.0), green: CGFloat(173.0/255.0), blue: CGFloat(200.0/255.0), alpha: 1.0),UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(80.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(125.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(250.0/255.0), green: CGFloat(246.0/255.0), blue: CGFloat(147.0/255.0), alpha: 1.0),UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(80.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(125.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(250.0/255.0), green: CGFloat(246.0/255.0), blue: CGFloat(147.0/255.0), alpha: 1.0),UIColor(red: CGFloat(5.0/255.0), green: CGFloat(141.0/255.0), blue: CGFloat(199.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(105.0/255.0), green: CGFloat(205.0/255.0), blue: CGFloat(75.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(240.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(128.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(192.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(247.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(140.0/255.0), green: CGFloat(234.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(147.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(80.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(50.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(128.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(128.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(247.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(105.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),UIColor(red: CGFloat(5.0/255.0), green: CGFloat(141.0/255.0), blue: CGFloat(199.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(105.0/255.0), green: CGFloat(205.0/255.0), blue: CGFloat(75.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(240.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(128.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(192.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(247.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(140.0/255.0), green: CGFloat(234.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(147.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(80.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(50.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(128.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(128.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(255.0/255.0), green: CGFloat(247.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                          UIColor(red: CGFloat(105.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0)]

    var legend_flag = ""
    var txnIDstr = ""
    var cart_mst_IDstr = ""
    var cartObjects = [CartObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        chartView.delegate = self
        addRightBarButtonItems(items: [cartButton])
        
        let button = UIButton()
        button.isHidden = true
        getMemberList(sender: button)
    }
    override func onCart1ButtonPressed(_ sender: UIButton) {
        print("cart")
        Mixpanel.mainInstance().track(event: "Dashboard Screen :- Cart Button Clicked")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        
        self.navigationController?.pushViewController(destVC, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
         getUserData()
       
        
    }
    
    func getTransactionDetail(){
        if loading_flag == "1"{
          self.presentWindow.makeToastActivity(message: "Loading..")
        }
        
        
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let panid = UserDefaults.standard.value(forKey: "pan") as? String
       let new_pan = panid?.replacingOccurrences(of: "'',", with: "")
        let new_pan1 = new_pan?.replacingOccurrences(of: ",''", with: "")
        //presentWindow.makeToast(message: "\(panid!)")
        let url = "\(Constants.BASE_URL)\(Constants.API.getTransactionDetail)\(new_pan1!.covertToBase64())/3"
        print(url)
        
        self.presentWindow.makeToastActivity(message: "Loading..")
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
                if let data = data as? NSDictionary{
                    self.presentWindow.hideToastActivity()
                    self.startinvestingview.isHidden = true
                    self.investingBtn.isHidden = true
                    self.investingLabel.isHidden = true
                    print(data)
                    self.months.removeAll()
                    self.unitsSold.removeAll()
                    self.colors.removeAll()
                    self.assetArr.removeAll()
                    if let dataDetail = data.value(forKey: "grand_total") as? NSDictionary{
                      
                        print(dataDetail.value(forKey: "gtotal_cur_value") ?? "")
                         let currentVal = dataDetail.value(forKey: "gtotal_cur_value") as? String
                            let investVal = dataDetail.value(forKey: "gtotal_investment") as? String
                            let gain = dataDetail.value(forKey:"gtotal_gain_loss") as? String
                            let xirr = dataDetail.value(forKey:"gtotal_xirr") as? Double
                            let asset_allocation = dataDetail.value(forKey:"asset_allocation") as?  [AnyObject]
                        var count = 0
                        if let asset_allocation = asset_allocation as? [AnyObject]{
                        for asset in asset_allocation{
                            
                            if let name = asset.value(forKey: "name") as? String,
                                let value = asset.value(forKey: "y") as? Double {
                           print(name,value)
                           if value > 0  {
                            let assetObj = AssetObj(name: name, y: value, is_selected: false, colors: self.colors_random[count],values : value)
                             self.assetArr.append(assetObj)
                            self.months.append(name)
                            self.colors.append(self.colors_random[count])
                            self.unitsSold.append(value)
                            count = count + 1
                            }
                        }
                        }
                        }
                        
                        
                            let formatter = NumberFormatter()              // Cache this,
                            formatter.locale = Locale(identifier: "en_IN") // Here indian local
                            formatter.numberStyle = .decimal
                            let investVal1 = formatter.string(from: (investVal?.numberValue)!)
                            let currentVal1 = formatter.string(from: (currentVal?.numberValue)!)
                            let gain1 = formatter.string(from: gain!.numberValue!)
                            let xirr1 =  formatter.string(from: NSNumber(value: xirr!))
                        self.investValLabel.text = "₹ \(investVal1 ?? "")"
                            self.currentValLabel.text = "₹ \(currentVal1 ?? "")"
                            self.gainLabel.text = "₹" + gain1!
                            //self.gainLabel.text = gain1
                            self.xirrLabel.text = String(xirr1!) + " %"
                        if (self.gainLabel.text?.contains(find: "-"))!{
                            //self.gainLabel.textColor = UIColor(hexaString: "#FF2600")
                            self.gainLossLabel.text = "Loss"
                        }
                        else{
                            //self.gainLabel.textColor = UIColor(hexaString: "#05A9E8")
                            self.gainLossLabel.text = "Gain"
                            
                        }
                         // self.presentWindow.hideToastActivity()
                        print(self.assetAllocationOutlet.currentTitleColor)
                        if self.sectorAllocationOutlet.currentTitle == "Sector Allocation" && self.sector_btn == "1" {
                            self.getSectorCharts()
                        } else {
                            self.backToAssetBtnOutlet.isHidden = true
                            //self.getAssetCharts()
                            if self.assetArr.count < 4{
                                self.scrollViewHeight.constant = 350
                            } else{
                                self.scrollViewHeight.constant = 350
                            }
                            self.setChart(dataPoints: self.months, values: self.unitsSold)
                        }
                        if investVal == "0.00"{
                            self.presentWindow.hideToastActivity()
                            self.startinvestingview.isHidden = false
                            self.investingBtn.isHidden = false
                            self.investingLabel.isHidden = false
                        }
                       // self.getUserData()
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                        self.startinvestingview.isHidden = false
                        self.investingBtn.isHidden = false
                        self.investingLabel.isHidden = false
                    }

                 }else{
                 self.presentWindow.hideToastActivity()
                  self.startinvestingview.isHidden = false
                    self.investingBtn.isHidden = false
                    self.investingLabel.isHidden = false
                    
                }
                }
               
                
            }
          else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getUserData(){
        loading_flag = "0"
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.CHECK_PAN_DB)\(covertToBase64(text: userid! as? String ?? ""))/3"
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
                        
                        let UserObjs = UserObj(id: id, pan: pan, dob: dob, mobile: mobile, landline: landline, name: name, middle_name: middle_name, last_name: last_name, flat_no: flat_no, building_name: building_name, road_street: road_street, address: address, city: city, state: state, country: country, pincode: pincode, email: email)
                        let full_name = "\(name) \(middle_name) \(last_name)"
                       print(data)
                        parent_pan = pan
                        self.UserObjects.append(UserObjs)
                        if all_flag != "0"{
                            UserDefaults.standard.setValue(pan, forKey: "pan")
                            self.activeMember.text = "\(full_name) (\(pan))"
                            parent_pan = pan
                        }else{
                            print("flag set")
                            self.activeMember.text = "ALL"
                        }
                        
                       // self.activeMember.text = "\(full_name) (\(pan))"
                         self.getTransactionDetail()
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
    @IBAction func tapBtnTransaction(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Dashboard Screen :- Dashbored Transaction Detail Clicked")
        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
        destVC.selectIndexValue = true
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func getMemberList(sender: UIButton){
        Mixpanel.mainInstance().track(event: "Dashboard Screen :- Memeber DropDown Button Clicked")
        get_member_list.removeAll()
        let userid = UserDefaults.standard.value(forKey: "userid")
        let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
        let url1 = "\(Constants.BASE_URL)\(Constants.API.getmemberswithparent)/\(p_userid!)"
        let url = "\(Constants.BASE_URL)\(Constants.API.Member_List)\(userid!)"
        print(url)
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url1).responseJSON { response in
                let data = response.result.value
                if data != nil{
                    if let response = data as? [[String:AnyObject]]{
                        // print(dataArray)
                        var pan1 = ""
                      //  self.presentWindow.hideToastActivity()
                        for memberIdData in response {
                             let id = memberIdData["id"] as? String ?? ""
                             let name = memberIdData["name"] as? String ?? ""
                            let middle_name = memberIdData["middle_name"] as? String ?? ""
                            let last_name = memberIdData["last_name"] as? String ?? ""
                            let pan = memberIdData["pan"] as? String ?? ""
                            pan1 = pan
                            let dob = memberIdData["dob"] as? String ?? ""
                            let member_display_flag = memberIdData["member_display_flag"] as? String ?? ""
                            let full_name = "\(name) \(middle_name) \(last_name)"
                            self.get_member_list.append(getMemberObj(id: id, name: full_name, pan: "'\(pan)'", dob: dob,member_display_flag:member_display_flag))
                        }
                        
                        print("\(self.get_member_list.map { $0.pan! }.joined(separator: ","))")
                        self.activeMember.text = "ALL"
                        
                        
                        let all_member = "\(self.get_member_list.map { $0.pan! }.joined(separator: ","))"
                        let all_member_id = "\(self.get_member_list.map { $0.id! }.joined(separator: ","))"
                        self.get_member_list.insert(getMemberObj(id:"\(all_member_id)", name: "ALL", pan: "\(all_member)", dob: "",member_display_flag : "" ), at: 0)
                        if self.activeMember.text == "ALL" {
                            print(flag)
                            if self.cartObjects.count != 0 {
                                self.updateCartData(txnid: self.txnIDstr, userid: flag, cart_mst_ids: self.cart_mst_IDstr)
                            }
                            
//                            flag = p_userid as? String ?? ""
//                            if self.get_member_list[0].pan != "" {
//                             UserDefaults.standard.setValue(self.get_member_list[0].pan, forKey: "pan")
//                            }
//                            all_flag = "0"
//                            UserDefaults.standard.setValue(self.get_member_list[0].id, forKey: "userid")
//                            NotificationCenter.default.post(name: Notification.Name("Cart_Count"),
//                                                            object: nil)
                        }
                        self.dropDownMember.anchorView = sender
                        self.dropDownMember.dataSource = self.get_member_list.map { $0.name ?? ""}
                        self.dropDownMember.selectionAction = { [unowned self] (index: Int, item: String) in
                           self.getrandomstring()
                            if self.get_member_list[index].name == "ALL" {
                                self.activeMember.text = "ALL"
                                flag = p_userid as? String ?? ""
                                if self.get_member_list[0].pan != "" {
                                 UserDefaults.standard.setValue(self.get_member_list[0].pan, forKey: "pan")
                                }
                                all_flag = "0"
                                
                                UserDefaults.standard.setValue(self.get_member_list[0].id, forKey: "userid")
                                NotificationCenter.default.post(name: Notification.Name("Cart_Count"),
                                                                object: nil)
                                Mixpanel.mainInstance().track(event: "Dashboard Screen :- Memeber DropDown All Selected")
                             } else{
                                
                                let pan_no = self.get_member_list[index].pan!
                                let pan_no_1 = pan_no.replacingOccurrences(of: "'", with: "", options: [], range: nil)
                                self.activeMember.text = "\(self.get_member_list[index].name!) (\(pan_no_1))"
                                UserDefaults.standard.setValue(self.get_member_list[index].pan, forKey: "pan")
                                flag = self.get_member_list[index].id!
                                print(flag)
                                all_flag = "1"
                                let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
                                if self.get_member_list[index].id! == String(describing: p_userid!) {
                                    UserDefaults.standard.setValue("0", forKey: "memberid")
                                } else {
                                    UserDefaults.standard.setValue(self.get_member_list[index].id!, forKey: "memberid")
                                }
                                NotificationCenter.default.post(name: Notification.Name("Cart_Count"),
                                                                object: nil)
                                Mixpanel.mainInstance().track(event: "Dashboard Screen :- Memeber DropDown \(self.activeMember.text!)  Selected")
                                
                            }
                            
                            print(flag)
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
                    
                    self.presentWindow?.hideToastActivity()
                    
                    dict = enc1
                    print("dict \(dict)")
                    if dict == "\"true\"" || dict == "true"{
                        let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
                        flag = p_userid as? String ?? ""
                        if self.get_member_list[0].pan != "" {
                            UserDefaults.standard.setValue(self.get_member_list[0].pan, forKey: "pan")
                        }
                        all_flag = "0"
                        UserDefaults.standard.setValue(self.get_member_list[0].id, forKey: "userid")
                        NotificationCenter.default.post(name: Notification.Name("Cart_Count"),
                                                        object: nil)
                        
                    }
                    else {
//                        let alert = UIAlertController(title: "Alert", message: "Error in updateCartData", preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
                        print("FAIL: updateCartData failed...")
                        self.presentWindow?.hideToastActivity()
                        totalCountFlag = "0"
                    }
            }
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
    func setChart(dataPoints: [String], values: [Double]) {
        print(dataPoints.count)
        print(colors_random.count)
        print(colors_random)
        print(values)
        var chartDataEntries: [ChartDataEntry] = []
        chartView.holeRadiusPercent = 0.3
        chartView.transparentCircleRadiusPercent = 0
        chartView.chartDescription?.text = ""
        chartView.legend.enabled = false
        chartView.notifyDataSetChanged()
        
        for i in 0..<dataPoints.count {
           let chartDataEntry = PieChartDataEntry(value : values[i], label: dataPoints[i])
           chartDataEntries.append(chartDataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: chartDataEntries, label: "")
        _ = [ NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 12.0)! ]
        pieChartDataSet.colors = colors
        
        if legend_flag == "1"{
            chartView.isUserInteractionEnabled = false
            
        } else {
            chartView.isUserInteractionEnabled = true
            
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        
     
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
       
        self.chartView.data = pieChartData
        chartView.drawEntryLabelsEnabled = false
        pieChartDataSet.drawValuesEnabled = false
       
    }
    
//    func setChart(dataPoints: [String], values: [Double])
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        if let dataSet = chartView.data?.dataSets[ highlight.dataSetIndex] {
            
            let sliceIndex: Int = dataSet.entryIndex( entry: entry)
            chartView.highlightValue(nil, callDelegate: false)
            legend_flag = "1"
            sector_btn = "0"
            backToAssetBtnOutlet.isHidden = false
            getAssetSubCategory(name :self.assetArr[sliceIndex].name)
           // if self.assetArr[sliceIndex].name ==
        }
    }
    @IBAction func memberBtn(_ sender: UIButton) {
        getMemberList(sender: sender)
        id = "1"
    }
    
    
    
    @IBOutlet weak var backToAssetBtnOutlet: UIButton!
    
    @IBAction func backToAssetBtn(_ sender: UIButton) {
         legend_flag = ""
        backToAssetBtnOutlet.isHidden = true
        
        //getAssetCharts()
        getTransactionDetail()
       
        Mixpanel.mainInstance().track(event: "Dashboard Screen :- Back To Asset Allocation Button Clicked")
    }
    
    @IBAction func assetAllocation(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Dashboard Screen :- Asset Allocation Button Clicked")
        sector_btn = "0"
        backToAssetBtnOutlet.isHidden = true
        legend_flag = ""
        sectorAllocationOutlet.backgroundColor = UIColor(red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1)
        assetAllocationOutlet.backgroundColor = UIColor.white
        
        sectorAllocationOutlet.setTitleColor(UIColor.white, for: .normal)
        assetAllocationOutlet.setTitleColor(UIColor.black, for: .normal)
       // scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        //getAssetCharts()
        months.removeAll()
        unitsSold.removeAll()
        colors.removeAll()
        assetArr.removeAll()
        //self.presentWindow.makeToastActivity(message: "Loading..")
        
        getTransactionDetail()
        //self.presentWindow.hideToastActivity()
    }
    @IBAction func sectorAllocation(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Dashboard Screen :- Sector Allocation Button Clicked")
        sector_btn = "1"
         backToAssetBtnOutlet.isHidden = true
        legend_flag = "1"

        assetAllocationOutlet.backgroundColor = UIColor(red: 66/255.0, green: 66/255.0, blue: 66/255.0, alpha: 1)
        sectorAllocationOutlet.backgroundColor = UIColor.white
        sectorAllocationOutlet.setTitleColor(UIColor.black, for: .normal)
        assetAllocationOutlet.setTitleColor(UIColor.white, for: .normal)
        print("hii")
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        getSectorCharts()
    }
    
    func getAssetCharts(){
        legends_click_label.text = "Click on the Asset category within pie to view asset allocation breakdown on a fund level"
        legend_label.text = "Click the legend to disable particular assets category"
        print(assetAllocationOutlet.isSelected)
       // presentWindow.makeToastActivity(message: "Loading..")
        let panid = UserDefaults.standard.value(forKey: "pan") as? String ?? ""
        let new_pan = panid.replacingOccurrences(of: "'',", with: "")
        let new_pan1 = new_pan.replacingOccurrences(of: ",''", with: "")
        var url = ""
        if self.activeMember.text == "ALL" {
            url = "\(Constants.BASE_URL)\(Constants.API.getAssettype)\(new_pan1.covertToBase64())/3"
        } else{
            let str = new_pan1 as! String
           let str1 =  str.replacingOccurrences(of: "'", with: "")
           UserDefaults.standard.setValue(str1, forKey: "pan")
           print("\(str)")
           url = "\(Constants.BASE_URL)\(Constants.API.getAssettype)\(covertToBase64(text: "'\(str1)'"))/3"
        }
        print(url)
        months.removeAll()
        unitsSold.removeAll()
        colors.removeAll()
        assetArr.removeAll()
        
        if Connectivity.isConnectedToInternet{
            var count = 0
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
                //print(response.result.value)
                self.presentWindow.hideToastActivity()
                if let data = data as? [AnyObject]{
                    for type in data{
                        print(count,"Count")
                        if let name = type.value(forKey: "name") as? String,
                            let value = type.value(forKey: "y") as? Double {
                            print(name,value)
                            if value > 0  {
                                let assetObj = AssetObj(name: name, y: value, is_selected: false, colors: self.colors_random[count],values : value)
                                self.assetArr.append(assetObj)
                                self.months.append(name)
                                self.colors.append(self.colors_random[count])
                                self.unitsSold.append(value)
                            }
                            count = count + 1
                                
                            
                        }
                        
                    }
                    if self.assetArr.count < 4{
                        self.scrollViewHeight.constant = 350
                    } else{
                        self.scrollViewHeight.constant = 350
                    }
                }
                self.setChart(dataPoints: self.months, values: self.unitsSold)
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getSectorCharts(){
        legends_click_label.text = ""
        legend_label.text = "Click the legend to disable particular sector"
        let panid = UserDefaults.standard.value(forKey: "pan") as? String
        let new_pan = panid?.replacingOccurrences(of: "'',", with: "")
        let new_pan1 = new_pan?.replacingOccurrences(of: ",''", with: "")
        var url = ""
        if self.activeMember.text == "ALL" {
            url = "\(Constants.BASE_URL)settings/cutoffservice_ws.php/getSectortype/\(new_pan1!.covertToBase64())/3"
        } else{
            let str = new_pan as! String
            let str1 =  str.replacingOccurrences(of: "'", with: "")
            UserDefaults.standard.setValue(str1, forKey: "pan")
            url = "\(Constants.BASE_URL)settings/cutoffservice_ws.php/getSectortype/\(covertToBase64(text: "'\(str)'"))/3"
        }
        print(url)
        months.removeAll()
        unitsSold.removeAll()
        colors.removeAll()
        assetArr.removeAll()
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url,method: .get).responseString { response in
                let enc_response = response.result.value
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                //print(response.result.value)
                self.presentWindow.hideToastActivity()
                var count = 0
                if let data = data as? [AnyObject]{
                    for type in data{
                        if let name = type.value(forKey: "name") as? String,
                            let value = type.value(forKey: "y") as? Double {
                            if value != 0 {
                                let assetObj = AssetObj(name: name, y: value, is_selected: false, colors: self.colors_random[count], values: value)
                                self.assetArr.append(assetObj)
                                self.months.append(name)
                                self.colors.append(self.colors_random[count])
                                self.unitsSold.append(value)
                            }
                            count = count + 1
                            
                            
                        }
                    }
                    if self.assetArr.count < 4{
                        self.scrollViewHeight.constant = 350
                    } else{
                        self.scrollViewHeight.constant = 350
                    }
                }
                self.setChart(dataPoints: self.months, values: self.unitsSold)
                //print(self.names)
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getAssetSubCategory(name:String){
        assetArr.removeAll()
        months.removeAll()
        unitsSold.removeAll()
        colors.removeAll()
        legends_click_label.text = ""
        legend_label.text = "Click the legend to disable particular assets"
        let panid = UserDefaults.standard.value(forKey: "pan") as? String
        let new_pan = panid?.replacingOccurrences(of: "'',", with: "")
        let new_pan1 = new_pan?.replacingOccurrences(of: ",''", with: "")
        var url = ""
        if self.activeMember.text == "ALL" {
            url = "\(Constants.BASE_URL)settings/cutoffservice_ws.php/getCategorytype/\(new_pan1!.covertToBase64())/3"
        } else{
            let str = new_pan1 as! String
            let str1 =  str.replacingOccurrences(of: "'", with: "")
            UserDefaults.standard.setValue(str1, forKey: "pan")
            url = "\(Constants.BASE_URL)settings/cutoffservice_ws.php/getCategorytype/\(covertToBase64(text: "'\(str)'"))/3"
        }
        print(url)
        presentWindow.makeToastActivity(message: "Loading..")
         if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseString{ response in
                let enc_response = response.result.value
                print(enc_response)
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                }
                let data = dict
                print(data)
            self.presentWindow.hideToastActivity()
            let response = self.jsonToNSData(json: data)
                let declarationInfoElement = try? JSONDecoder().decode(Delivery.self, from: response! as Data)
                if let declarationInfoElement = declarationInfoElement {
                    var count = 0
                    for i in 0..<declarationInfoElement.count {
                        for n in 0..<declarationInfoElement[i].appdata.count{
                            if name == declarationInfoElement[i].name {
                                print(declarationInfoElement[i].appdata[n].schmemeName)
                               
                                let assetObj = AssetObj(name: declarationInfoElement[i].appdata[n].schmemeName, y: Double(declarationInfoElement[i].appdata[n].schemeAmount), is_selected: false, colors: self.colors_random[count], values: Double(declarationInfoElement[i].appdata[n].schemeAmount))
                                //if declarationInfoElement[i].appdata[n].schemeAmount != 0{
                                self.assetArr.append(assetObj)
                                
                                self.months.append(declarationInfoElement[i].appdata[n].schmemeName)
                                self.colors.append(self.colors_random[count])
                                self.unitsSold.append(Double(declarationInfoElement[i].appdata[n].schemeAmount))
                               // }
                                
                               
                            }
                            count = count + 1
                        }
                        
                        if self.assetArr.count < 4{
                            self.scrollViewHeight.constant = 350
                        } else{
                            self.scrollViewHeight.constant = 350
                        }
                    }
                }
                DispatchQueue.main.async {
                 self.setChart(dataPoints: self.months, values: self.unitsSold)
                }
                print("@@@@@")
            
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    @IBAction func clichToProceed(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Dashboard Screen :- Click Here To Proceed Button Clicked")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
        navigationController?.pushViewController(destVC, animated: true)
    }
    func legendClick(row: Int,sender:UIButton) {
         Mixpanel.mainInstance().track(event: "Dashboard Screen :- Legend Clicked")
        let index = IndexPath(row: row, section: 0)
        let cell = tableView.cellForRow(at: index) as? legendCell
       print(row)
        if sender.isSelected {
            sender.isSelected = false
            cell?.colorLabel.backgroundColor = assetArr[row].colors
            cell?.legendName.textColor = UIColor.black
            cell?.legendPrice.textColor = UIColor.black
            assetArr[row].is_selected = false
            print(assetArr[row].name)
            print(assetArr[row].y)
            print(assetArr[row].is_selected)
            
            months.removeAll()
            unitsSold.removeAll()
            colors.removeAll()
            for i in 0..<assetArr.count {
                print(assetArr[i].is_selected)
                if assetArr[i].is_selected  == false {
                    months.append(assetArr[i].name)
                    unitsSold.append(assetArr[i].y)
                    colors.append(assetArr[i].colors)
                
                    
                }
            }
            self.scrollView.scrollToTop(animated: true)
            setChart(dataPoints:months, values: unitsSold)
        }
        else{
            
             cell?.colorLabel.backgroundColor = UIColor.darkGray
             cell?.legendName.textColor = UIColor.darkGray
             cell?.legendPrice.textColor = UIColor.darkGray
             sender.isSelected = true
            assetArr[row].is_selected = true
            print(assetArr[row].name)
            print(assetArr[row].y)
            months.removeAll()
            unitsSold.removeAll()
            colors.removeAll()
            for i in 0..<assetArr.count {
                print(assetArr[i].is_selected)
                if assetArr[i].is_selected  == false {
                    months.append(assetArr[i].name)
                    unitsSold.append(assetArr[i].y)
                    colors.append(assetArr[i].colors)
//                    let totalSum = unitsSold.reduce(0, +)
//                    let P_Calculation = assetArr[i].y/totalSum * 100
//                    let text = String(format: "%.1f", arguments: [P_Calculation])
//                    assetArr[i].y = Double(text)!
                    
                }
            }
            self.scrollView.scrollToTop(animated: true)
            setChart(dataPoints:months, values: unitsSold)
        }
    }
    
    
}
extension UIScrollView {
    
    // Scroll to a specific view so that it's top is at the top our scrollview
    func scrollToView(view:UIView, animated: Bool) {
        if let origin = view.superview {
            // Get the Y position of your child view
            let childStartPoint = origin.convert(view.frame.origin, to: self)
            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
        }
    }
    
    // Bonus: Scroll to top
    func scrollToTop(animated: Bool) {
        let topOffset = CGPoint(x: 0, y: -contentInset.top)
        setContentOffset(topOffset, animated: animated)
        
    }
    
    // Bonus: Scroll to bottom
    func scrollsToBottom() {
        let bottomOffset = CGPoint(x: 0, y: contentSize.height - bounds.size.height + contentInset.bottom)
        if(bottomOffset.y > 0) {
            setContentOffset(bottomOffset, animated: true)
        }
    }
    
}

//#MARK: TableViewDelegates

extension DashboardViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "schemeInfo", for: indexPath) as! legendCell
        if assetArr.count > 0 {
        cell.colorLabel.backgroundColor = assetArr[indexPath.row].colors
        let summary = assetArr[indexPath.row].name
        let str = summary.replacingOccurrences(of: "<[^>]+>", with: " ", options: .regularExpression, range: nil)
        cell.legendName.text =  str
        if assetArr[indexPath.row].is_selected  == false {
            let totalSum = unitsSold.reduce(0, +)
            let P_Calculation = assetArr[indexPath.row].y/totalSum * 100
            let text = String(format: "%.2f", arguments: [P_Calculation])
            cell.legendPrice.text = text + " %"
        } else{
            let totalSum = unitsSold.reduce(0, +)
            let P_Calculation = assetArr[indexPath.row].y/totalSum * 100
            let text = String(format: "%.2f", arguments: [P_Calculation])
            cell.legendPrice.text = text + " %"
        }
        
        let formatter = NumberFormatter()              // Cache this,
        formatter.locale = Locale(identifier: "en_IN") // Here indian local
        formatter.numberStyle = .decimal
        let string = formatter.string(from: NSNumber(value:assetArr[indexPath.row].values))
        cell.legendPriceRs.text = "₹ " + string!
        cell.cellBtn.tag = indexPath.row
        if assetArr[indexPath.row].is_selected  == true {
            cell.colorLabel.backgroundColor = UIColor.darkGray
            cell.legendName.textColor = UIColor.darkGray
            cell.legendPrice.textColor = UIColor.darkGray
        }else{
            cell.colorLabel.backgroundColor = assetArr[indexPath.row].colors
            cell.legendName.textColor = UIColor.black
            cell.legendPrice.textColor = UIColor.black
        }
       
        }
        cell.delegate = self
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assetArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 53
    }
    

}

//
class legendCell : UITableViewCell
{
    @IBOutlet weak var legendPriceRs: UILabel!
    weak var delegate: LegendCellDelegate?
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var legendName: UILabel!
    @IBOutlet weak var legendPrice: UILabel!
    @IBOutlet weak var cellBtn: UIButton!
    @IBAction func cellBtn(_ sender: UIButton) {
       
        delegate?.legendClick(row: sender.tag,sender:sender)
      
        
    }
    
}
