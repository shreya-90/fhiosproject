//
//  upcomingViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 23/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import Mixpanel

var parent_pan = ""
class upcomingViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activeMember: UITextField!
    var get_member_list = [getMemberObj]()
    let dropDownMember = DropDown()
     var UserObjects = [UserObj]()
    var id = "0"
    
    @IBOutlet weak var notransactionView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        Mixpanel.mainInstance().track(event: "Upcoming Screen :- Upcoming Button Clicked")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewWillAppear(_ animated: Bool) {
       getUserData()
    }
    var upcomingArr = [upcomingTransactionObj]()
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingArr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "upcoming", for: indexPath) as? upcomingCell
        
        
        
        cell?.s_name.text = upcomingArr[indexPath.row].S_NAME
        cell?.amountTf.text = "₹ " + upcomingArr[indexPath.row].cart_amount!
        cell?.dateLabel.text = upcomingArr[indexPath.row].tdate
        let whiteRoundedView : UIView = UIView(frame: CGRect(x:5, y:5, width:Int(self.view.frame.size.width - 10), height:110))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 5.0
        whiteRoundedView.layer.shadowOffset = CGSize(width:-1, height:1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        cell?.contentView.addSubview(whiteRoundedView)
        cell?.contentView.sendSubview(toBack: whiteRoundedView)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func getUpcomingList(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        } else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        upcomingArr.removeAll()
       // let url = "\(Constants.BASE_URL)transaction/transaction_ws.php/get_upcoming_transactions/\(covertToBase64(text: userid as? String ?? ""))/3"
        let url1 = "http://www.financialhospital.in/adminpanel/transaction/transaction_ws.php/get_upcoming_transactions/\(covertToBase64(text: userid! as! String))/3"
        print(url1)
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url1).responseString { response in
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
                    print(data)
                    if !data.isEmpty{
                        self.notransactionView.isHidden = true
                        self.presentWindow.hideToastActivity()
                        for type in data{
                            if let S_NAME = type.value(forKey: "S_NAME") as? String,
                                let transaction_date = type.value(forKey: "transaction_date") as? String,
                                let tdate = type.value(forKey: "tdate") as? String,
                                let cart_amount = type.value(forKey: "cart_amount") as? String{
                                let formatter = NumberFormatter()
                                formatter.locale = Locale(identifier: "en_IN")
                                formatter.numberStyle = .decimal
                                let string = formatter.string(from: cart_amount.numberValue!)
                                self.upcomingArr.append(upcomingTransactionObj.getUpcomingTransactionDetail(scheme_name: S_NAME, transaction_date: transaction_date, tdate: tdate, cart_amount: string!))
                            }
                        }
                    self.tableView.reloadData()
                    } else{
                        self.notransactionView.isHidden = false
                        self.presentWindow.hideToastActivity()
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
                    if let response = data as? [[String:AnyObject]]{
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
                            
                            self.get_member_list.append(getMemberObj(id: id, name: full_name, pan: "'\(pan)'", dob: dob, member_display_flag: member_display_flag ))
                        }
                        
                        print("\(self.get_member_list.map { $0.pan! }.joined(separator: ","))")
                       // self.activeMember.text = "ALL"
                        
                        
                        let all_member = "\(self.get_member_list.map { $0.id! }.joined(separator: ","))"
                         let all_member_pan = "\(self.get_member_list.map { $0.pan! }.joined(separator: ","))"
                        print(all_member)
                        self.get_member_list.insert(getMemberObj(id:"\(all_member)", name: "ALL", pan: "\(all_member_pan)", dob: "", member_display_flag: "0"), at: 0)
                        self.dropDownMember.anchorView = sender
                        self.dropDownMember.dataSource = self.get_member_list.map { $0.name ?? ""}
                        self.dropDownMember.selectionAction = { [unowned self] (index: Int, item: String) in
                            //self.activeMember.text = self.get_member_list[index].name
                            if self.get_member_list[index].name == "ALL" {
                                self.activeMember.text = "ALL"
                                flag = "0" as? String ?? ""
                                print(flag)
                                all_flag = "0"
                                UserDefaults.standard.setValue(self.get_member_list[0].pan, forKey: "pan")
                                UserDefaults.standard.setValue(self.get_member_list[0].id, forKey: "userid")
                                NotificationCenter.default.post(name: Notification.Name("Cart_Count"),
                                                                object: nil)
                                Mixpanel.mainInstance().track(event: "Upcoming Screen :- ALL is selected")
                            } else{
                                let pan_no = self.get_member_list[index].pan!
                                let pan_no_1 = pan_no.replacingOccurrences(of: "'", with: "", options: [], range: nil)
                                self.activeMember.text = "\(self.get_member_list[index].name!) (\(pan_no_1))"
                                flag = self.get_member_list[index].id!
                                UserDefaults.standard.setValue(self.get_member_list[index].pan, forKey: "pan")
                                all_flag = "1"
                                NotificationCenter.default.post(name: Notification.Name("Cart_Count"),
                                                                object: nil)
                                let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
                                if self.get_member_list[index].id! == String(describing: p_userid!) {
                                    UserDefaults.standard.setValue("0", forKey: "memberid")
                                } else {
                                    UserDefaults.standard.setValue(self.get_member_list[index].id!, forKey: "memberid")
                                }
                                Mixpanel.mainInstance().track(event: "Upcoming Screen :-  \(self.activeMember.text ?? "") member is selected ")
                            }
                            self.getUpcomingList()
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
    
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.CHECK_PAN_DB)\(userid!)"
        presentWindow.makeToastActivity(message: "Loading...")
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                // self.presentWindow.hideToastActivity()
                if let data = response.result.value as? [[String: AnyObject]] {
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
                     //   UserDefaults.standard.set(pan, forKey: "pan")
                        parent_pan = pan
                        let UserObjs = UserObj(id: id, pan: pan, dob: dob, mobile: mobile, landline: landline, name: name, middle_name: middle_name, last_name: last_name, flat_no: flat_no, building_name: building_name, road_street: road_street, address: address, city: city, state: state, country: country, pincode: pincode, email: email)
                        let full_name = "\(name) \(middle_name) \(last_name)"
                        
                        self.UserObjects.append(UserObjs)
                       // UserDefaults.standard.setValue(pan, forKey: "pan")
                        if all_flag != "0"{
                            UserDefaults.standard.setValue(pan, forKey: "pan")
                            self.activeMember.text = "\(full_name) (\(pan))"
                            parent_pan = pan
                        }else{
                            print("flag set")
                            self.activeMember.text = "ALL"
                            let userid = UserDefaults.standard.value(forKey: "userid")
                            flag = userid as! String
                            print(flag)
                            
                        }
                        //self.activeMember.text = "\(full_name) (\(pan))"
                        self.getUpcomingList()
                    }
                 }
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }
    
    @IBAction func memberBtn(_ sender: UIButton) {
        getMemberList(sender: sender)
        id = "1"
    }
    

}
class upcomingCell : UITableViewCell
{
    @IBOutlet weak var s_name: UILabel!
    @IBOutlet weak var amountTf: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
}
