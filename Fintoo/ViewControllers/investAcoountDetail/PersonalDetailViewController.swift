//
//  PersonalDetailViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 17/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
protocol DemoDelegate : class {
    func demo(row: String)
    
}

class PersonalDetailViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    
    var personal_detail = [Dictionary<String,String>]()
    var flatno:String!
    var mobile : String!
    var pincode : String!
    var occupation : String!
    var pan: String!
    var personal_details_alert : Bool = false
     weak var delegate: DemoDelegate?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setWhiteNavigationBar()
        addBackbutton()
       // getUserData()
        personal_detail.append(["title":"MY PROFILE", "icon":"mydetails"])
        personal_detail.append(["title":"ADDRESS DETAILS (As Per Your AADHAR)", "icon":"address_detail"])
        personal_detail.append(["title":"OTHER DETAILS","icon":"other_detail"])
        personal_detail.append(["title":"KYC(Know Your Customer)","icon":"kyc"])
        personal_detail.append(["title":"FATCA(Foregin Account Tax Compilance Act)","icon":"fatca"])
//        if upload_flag && tabBarController?.viewControllers?.count ?? 0 > 3{
//            let indexToRemove = 3
//            if var tabs = self.tabBarController?.viewControllers {
//                tabs.remove(at: indexToRemove)
//                self.tabBarController?.viewControllers = tabs
//            } else {
//                print("There is something wrong with tabbar controller")
//            }
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        getUserData()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personal_detail.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PersonalDetailTableViewCell
        cell.detailLabel.text = personal_detail[indexPath.row]["title"]!
        cell.personalimageview.image = UIImage(named: personal_detail[indexPath.row]["icon"]!)
        cell.detailLabel.numberOfLines = 0
       // cell.?.text = personal_detail[indexPath.row]["title"]!
        return cell
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Back Button Clicked")
        if personal_details_alert == true {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
            self.navigationController?.pushViewController(controller, animated: true)
        }else{
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
        navigationController?.pushViewController(destVC, animated: true)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0{
            Mixpanel.mainInstance().track(event: "Personal Detail Screen :- My Profile Clicked")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "MydetailsViewController") as! MydetailsViewController
            navigationController?.pushViewController(destVC, animated: true)
        }
        if indexPath.row == 1{
            print(mobile)
            Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Address Details Clicked")
            if mobile! != "" && pan != ""{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "addressDetailViewController") as! addressDetailViewController
                navigationController?.pushViewController(destVC, animated: true)
            }
            else{
                Mixpanel.mainInstance().track(event: "Please First Complete Profile Details!!")
                presentWindow.makeToast(message: "Please First Complete Profile Details!!")
            }
        }
        if indexPath.row == 2{
            print(flatno)
            if flatno != "" && mobile! != "" {
                Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Other Details Clicked")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "OtherDetailViewController") as! OtherDetailViewController
                navigationController?.pushViewController(destVC, animated: true)
            }
            else{
                if flatno == ""{
                    Mixpanel.mainInstance().track(event: "Please First Complete Address Details!!")
                    presentWindow.makeToast(message: "Please First Complete Address Details!!")
                }
                else if mobile! == ""{
                    Mixpanel.mainInstance().track(event: "Please First Complete Profile Details!!")
                    presentWindow.makeToast(message: "Please First Complete Profile Details!!")
                }
              
            }
        }
        if indexPath.row == 3{
            print(occupation)
            if flatno != "" && mobile! != "" && pincode! != ""  && occupation! != "0"{
                Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Kyc  Clicked")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "KYCViewController") as! KYCViewController
                navigationController?.pushViewController(destVC, animated: true)
            }
            else{
                if flatno == ""{
                    Mixpanel.mainInstance().track(event: "Please First Complete Address Details!!")
                    presentWindow.makeToast(message: "Please First Complete Address Details!!")
                }
                else if mobile! == ""{
                    presentWindow.makeToast(message: "Please First Complete Profile Details!!")
                    Mixpanel.mainInstance().track(event: "Please First Complete Profile Details!!")
                }
                else if occupation! == "0"{
                    presentWindow.makeToast(message: "Please First Complete Other Details!!")
                    Mixpanel.mainInstance().track(event: "Please First Complete Other Details!!")
                }
            }
        }
        if indexPath.row == 4{
            if flatno != "" && mobile! != "" && pincode! != "" && occupation! != "0" {
                Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Fatca Clicked")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "FatcaDetailViewController") as! FatcaDetailViewController
                navigationController?.pushViewController(destVC, animated: true)
            }
            else{
                if flatno == ""{
                    presentWindow.makeToast(message: "Please First Complete Address Details!!")
                    Mixpanel.mainInstance().track(event: "Please First Complete Address Details!!")
                }
                else if mobile! == ""{
                    presentWindow.makeToast(message: "Please First Complete Profile Details!!")
                    Mixpanel.mainInstance().track(event: "Please First Complete Profile Details!!")
                }
                else if occupation! == "0"{
                    presentWindow.makeToast(message: "Please First Complete Other Details!!")
                    Mixpanel.mainInstance().track(event: "Please First Complete Other Details!!")
                }
            }
        }
    }
    func getUserData(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid = flag
        } else{
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
                if data != nil{
                    self.presentWindow.hideToastActivity()
                    if let dataArray = data as? NSArray{
                        for abc in dataArray{
                            let mobile = (abc as AnyObject).value(forKey: "mobile") as? String
                            let pan = (abc as AnyObject).value(forKey: "pan") as? String
                            let flat_no = (abc as AnyObject).value(forKey: "flat_no") as? String
                            let pincode = (abc as AnyObject).value(forKey: "pincode") as? String
                            let occupation = (abc as AnyObject).value(forKey: "occupation") as? String
                            self.flatno = flat_no!
                            self.mobile = mobile!
                            self.pincode = pincode!
                            self.occupation = occupation!
                            self.pan = pan ?? ""
                            
                        }
                        self.delegate?.demo(row:self.flatno!)
                    }
                } else {
                     self.presentWindow.hideToastActivity()
                }
                
            }
        }
            
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
    }

}
