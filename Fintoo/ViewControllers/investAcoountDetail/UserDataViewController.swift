//
//  UserDataViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 09/04/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
var upload_flag = false
class UserDataViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource{
     var personal_detail = [Dictionary<String,String>]()
    var id = ""
    var data_empty = "0"
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        //rsetWhiteNavigationBar()
        addBackbutton()
        let userid = UserDefaults.standard.value(forKey: "userid") as? String ?? ""
        gettxnstatusbyuser(userid: userid)
        navigationController?.navigationBar.topItem?.title = "PERSONAL DETAILS"
       
        self.tabBarController?.tabBar.isHidden = true
        let userdefaults = UserDefaults.standard
        let savedValue = userdefaults.string(forKey: "pan")
        if savedValue != nil && savedValue != ""{
            print("Here you will get saved value")
        } else{
            checking_pancard()
        }
        
        
       // personal_detail.append(["title":"FATCA(Foregin Account Tax Compilance Act)","icon":"fatca"])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        // cell.?.text = personal_detail[indexPath.row]["title"]!
        return cell
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        print("testing")
        Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(destVC, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if  data_empty == "0" {
                Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Persoanl Details Clicked")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
                self.present(destVC, animated:true, completion: nil)
            } else {
                presentWindow.makeToast(message: "Something Went Wrong")
                checking_pancard()
            }
        }
        else if indexPath.row == 1{
            if  data_empty == "0" {
                Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Bank Details Clicked")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
                destVC.selectIndexValue = true
                destVC.id = "1"
                self.present(destVC, animated:true, completion: nil)
            } else {
                presentWindow.makeToast(message: "Something Went Wrong")
                checking_pancard()
            }
       
        }
        else if indexPath.row == 2{
            if  data_empty == "0" {
                Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Nominees Clicked")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
                destVC.selectIndexValue = true
                destVC.id = "2"
                self.present(destVC, animated:true, completion: nil)
            } else {
                presentWindow.makeToast(message: "Something Went Wrong")
                checking_pancard()
            }
        }
        else if indexPath.row == 3{
            if  data_empty == "0" {
                Mixpanel.mainInstance().track(event: "Personal Detail Screen :- Upload Documents Clicked")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "TestViewController") as! TestViewController
                destVC.selectIndexValue = true
                destVC.id = "3"
                self.present(destVC, animated:true, completion: nil)
            } else {
                presentWindow.makeToast(message: "Something Went Wrong")
                checking_pancard()
            }
        }

    }
    func checking_pancard(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        presentWindow.makeToastActivity(message: "Loading..")
        let url = "\(Constants.BASE_URL)\(Constants.API.CHECK_PAN_DB)\(userid!)/3"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseString { response in
                let enc_response = response.result.value
                print(enc_response)
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: " " , with: "")
                print(enc1)
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                    // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                }
                 let data = dict
                if data != nil{
                     self.presentWindow.hideToastActivity()
                    if let data = data as? [AnyObject]{
                        
                        for type in data{
                            if let pan = type.value(forKey: "pan") as? String,
                                let name = type.value(forKey: "name") as? String{
                                print(pan)
                                UserDefaults.standard.setValue(pan, forKey: "pan")
                                UserDefaults.standard.setValue(name, forKey: "name")
                                if pan == ""{
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "PanCardViewController") as! PanCardViewController
                                    
                                    self.navigationController?.pushViewController(destVC, animated: true)
                                }
                                else{
                                    print("pan is not empty")
                                }
                            }
                            
                        }
                    }
                    
                }
                else{
                    self.presentWindow.hideToastActivity()
                    self.data_empty = "1"
                    print("nill data")
                }
            }
            
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
            
        }
        //}
        
        
        
        
    }
    func gettxnstatusbyuser(userid:String){
        
        self.presentWindow.hideToastActivity()
        self.personal_detail.append(["title":"PERSONAL DETAILS", "icon":"personal-detail"])
        self.personal_detail.append(["title":"BANK DETAILS", "icon":"bank-detail"])
        self.personal_detail.append(["title":"NOMINEES","icon":"nominees"])
        self.personal_detail.append(["title":"UPLOAD DOCUMENTS","icon":"upload"])
        
//        let url = "\(Constants.BASE_URL)\(Constants.API.gettxnstatusbyuser)\(userid)"
//        print(url)
//        presentWindow.makeToastActivity(message: "Loading..")
//        if Connectivity.isConnectedToInternet{
//
//            Alamofire.request(url).responseJSON { response in
//                let data = response.result.value as? [String:String]
//                    if let transaction_id = data?["transaction_id"] {
//                        print(transaction_id)
//                        self.presentWindow.hideToastActivity()
//                        self.personal_detail.append(["title":"PERSONAL DETAILS", "icon":"personal-detail"])
//                        self.personal_detail.append(["title":"BANK DETAILS", "icon":"bank-detail"])
//                        self.personal_detail.append(["title":"NOMINEES","icon":"nominees"])
//                        self.personal_detail.append(["title":"UPLOAD DOCUMENTS","icon":"upload"])
//                        upload_flag = false
//                        self.tableview.reloadData()
//                    } else {
//                        self.presentWindow.hideToastActivity()
//                        self.personal_detail.append(["title":"PERSONAL DETAILS", "icon":"personal-detail"])
//                        self.personal_detail.append(["title":"BANK DETAILS", "icon":"bank-detail"])
//                        self.personal_detail.append(["title":"NOMINEES","icon":"nominees"])
//                        upload_flag = true
//                        self.tableview.reloadData()
//                   // personal_detail.append(["title":"UPLOAD DOCUMENTS","icon":"upload"])
//                }
//
//            }
//        } else {
//            presentWindow.hideToastActivity()
//            presentWindow!.makeToast(message: "Internet Connection not Available")
//        }
    }
}
