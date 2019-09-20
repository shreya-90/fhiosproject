//
//  DashbordTabBarViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 21/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import MIBadgeButton_Swift
import Alamofire
class DashbordTabBarViewController: UITabBarController,UITabBarControllerDelegate {

    var selectIndexValue  = false
    var dashboardIndex = false
    var btnCart : MIBadgeButton!
    var cartButton : UIBarButtonItem!
    let presentWindow = UIApplication.shared.keyWindow
    //
    var cartObjects = [CartObject]()
    var totalCartValue = 0
     let tempArr = ["", "Lumpsum", "SIP", "Additional Purchase"]
    //
    @IBInspectable var indicatorColor: UIColor = UIColor()
    
    @IBInspectable var onTopIndicator: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        let imgBack = UIImage(named: "icon-back-white")
        let backButton = UIBarButtonItem (image: UIImage(named: "icon-back-white")!, style: .plain, target: self, action: #selector(GoToBack))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.hidesBackButton = true
        btnCart = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnCart.setImage(UIImage(named: "cart"), for: .normal)
        btnCart.imageView?.contentMode = .scaleAspectFit
        btnCart.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnCart.addTarget(self, action: #selector(BaseViewController.onCart1ButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        cartButton = UIBarButtonItem(customView: btnCart)
        cartButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnCart.badgeString = ""
       NotificationCenter.default.addObserver(self, selector: #selector(yourfunction(notfication:)), name: NSNotification.Name(rawValue: "Cart_Count"), object: nil)

        
        self.navigationItem.rightBarButtonItems = [cartButton]
    }
    @objc func yourfunction(notfication: NSNotification) {
        print("xxx")
        cart_count()
    }
    @objc func onCart1ButtonPressed(_ sender: UIButton) {
        print("cart")
        print(flag)
        print(all_flag)
        print(totalCountFlag)
        print(UserDefaults.standard.value(forKey: "userid"))
        if all_flag != "0" {
            print(flag)
            let pan_no =  UserDefaults.standard.value(forKey: "pan") as! String
            UserDefaults.standard.setValue(pan_no, forKey: "pan")
            if flag != "0" {
                UserDefaults.standard.setValue(flag, forKey: "userid")
            }else {
                let p_userid = UserDefaults.standard.value(forKey: "parent_user_id") as? String
                UserDefaults.standard.setValue(p_userid, forKey: "userid")
            }
        }else {
            if totalCountFlag == "1"{
                print(flag)
                if flag != "0" {
                    UserDefaults.standard.setValue(flag, forKey: "userid")
                }else {
                    let p_userid = UserDefaults.standard.value(forKey: "parent_user_id") as? String
                    UserDefaults.standard.setValue(p_userid, forKey: "userid")
                }
            }else{
                let pan_no =  UserDefaults.standard.value(forKey: "parent_pan") as! String
                UserDefaults.standard.setValue(pan_no, forKey: "pan")
                let p_userid = UserDefaults.standard.value(forKey: "parent_user_id") as? String
                UserDefaults.standard.setValue(p_userid, forKey: "userid")
            }
            
        }
        if all_flag == "0"{
            flag = "0"
        }
        all_flag = "1"
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        
        self.navigationController?.pushViewController(destVC, animated: true)
        
    }
    @objc func GoToBack(sender: UIBarButtonItem) {
        // Perform your custom actions
        // ...
        // Go back to the previous ViewController
        print("back")
        print(flag)
        print(all_flag)
        if all_flag != "0" {
            print(flag)
            let pan_no =  UserDefaults.standard.value(forKey: "pan") as! String
            UserDefaults.standard.setValue(pan_no, forKey: "pan")
            if flag != "0" {
                UserDefaults.standard.setValue(flag, forKey: "userid")
            }else {
                let p_userid = UserDefaults.standard.value(forKey: "parent_user_id") as? String
                UserDefaults.standard.setValue(p_userid, forKey: "userid")
            }
        }else {
           let pan_no =  UserDefaults.standard.value(forKey: "parent_pan") as! String
            UserDefaults.standard.setValue(pan_no, forKey: "pan")
            let p_userid = UserDefaults.standard.value(forKey: "parent_user_id") as? String
            UserDefaults.standard.setValue(p_userid, forKey: "userid")
            
        }
        if all_flag == "0"{
             flag = "0"
        }
        all_flag = "1"
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        cart_count()
        if selectIndexValue{
            self.selectedIndex = 1
        }
        if dashboardIndex{
            self.selectedIndex = 0
        }
    }
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
       
        var tabFrame:CGRect = self.tabBar.frame
        tabFrame.origin.y = self.view.frame.origin.y
        self.tabBar.frame = tabFrame
        
        guard let numberOfTabs = tabBar.items?.count else {
            return
        }
        
        let numberOfTabsFloat = CGFloat(numberOfTabs)
        let imageSize = CGSize(width: tabBar.frame.width / numberOfTabsFloat,
                               height: tabBar.frame.height)
        
        
        let indicatorImage = UIImage.drawTabBarIndicator(color: indicatorColor,
                                                         size: imageSize,
                                                         onTop: onTopIndicator)
        self.tabBar.selectionIndicatorImage = indicatorImage
    }
    func cart_count(){
        var userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        if flag != "0"{
            userid = flag
            print("member \(flag)")
        }
        else{
            // flag = "0"
            userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
            print("user \(userid)")
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
                    self.presentWindow?.hideToastActivity()
                    // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                }
                print(response.result.value ?? "cart count")
                let data = dict
                print(data)
                if data != nil {
                     //here
                    var transaction_id = ""
                    var cart_mst_id = ""
                    
                    self.presentWindow?.hideToastActivity()
                    
                    if let response = data as? [[String: AnyObject]] {
                    print(response)
                    if !response.isEmpty {
                        for cartItem in response {
                    
                    
                        let MAXINVT = cartItem["MAXINVT"] as? String ?? ""
                        let MININVT = cartItem["MININVT"] as? String ?? ""
                        let SCHEMECODE = cartItem["SCHEMECODE"] as? String ?? ""
                        let SIPMININVT = cartItem["SIPMININVT"] as? String ?? ""
                        let S_NAME = cartItem["S_NAME"] as? String ?? ""
                        let cart_added = cartItem["cart_added"] as? String ?? ""
                        let cart_amount = cartItem["cart_amount"] as? String ?? ""
                        self.totalCartValue = self.totalCartValue + Int(cart_amount)!
                        let cart_folio_no = cartItem["cart_folio_no"] as? String ?? ""
                        let cart_frequency = cartItem["cart_frequency"] as? String ?? ""
                        let cart_id = cartItem["cart_id"] as? String ?? ""
                        cart_mst_id = cartItem["cart_mst_id"] as? String ?? ""
                        let cart_mst_session_id = cartItem["cart_mst_session_id"] as? String ?? ""
                        let CLASSCODE = cartItem["CLASSCODE"] as? String ?? ""
                        let mode = cartItem["cart_purchase_type"] as? String ?? ""
                        let cart_purchase_type = self.tempArr[Int(mode) ?? 0]
                        
                        let cart_scheme_code = cartItem["cart_scheme_code"] as? String ?? ""
                        
                        let originalDate = cartItem["cart_sip_start_date"] as? String ?? ""
                        var cart_sip_start_date = ""
                        if mode == "1" || mode == "3" {
                            cart_sip_start_date = "NA"
                        } else {
                            if originalDate == "0000-00-00" {
                                cart_sip_start_date = "NA"
                            } else {
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy-mm-dd"
                                let date = dateFormatter.date(from: originalDate)
                                let calendar = Calendar.current
                                let day = calendar.component(.day, from: date!)
                                
                                cart_sip_start_date = "\(day)"
                            }
                        }
                        
                        let cart_tenure = cartItem["cart_tenure"] as? String ?? ""
                        let cart_tenure_perpetual = cartItem["cart_tenure_perpetual"] as? String ?? ""
                        let multiples = cartItem["multiples"] as? String ?? ""
                        let transaction_bank_id = cartItem["transaction_bank_id"] as? String ?? ""
                        transaction_id = cartItem["transaction_id"] as? String ?? ""
                        let AMC_CODE = cartItem["AMC_CODE"] as? String ?? ""
                        let cartObj = CartObject(MAXINVT: MAXINVT, MININVT: MININVT, SCHEMECODE: SCHEMECODE, SIPMININVT: SIPMININVT, S_NAME: S_NAME, cart_added: cart_added, cart_amount: cart_amount, cart_folio_no: cart_folio_no, cart_frequency: cart_frequency, cart_id: cart_id, cart_mst_id: cart_mst_id, cart_mst_session_id: cart_mst_session_id, cart_purchase_type: cart_purchase_type, cart_scheme_code: cart_scheme_code, cart_sip_start_date: cart_sip_start_date, cart_tenure: cart_tenure, cart_tenure_perpetual: cart_tenure_perpetual, multiples: multiples, transaction_bank_id: transaction_bank_id, transaction_id: transaction_id,cart_sip_start_date1: originalDate, mode: mode, is_save: false, AMC_CODE: AMC_CODE, CLASSCODE: CLASSCODE, nominee: nil)
                            self.cartObjects.append(cartObj)
                    
                   
                        }
                    }
                    }
                   
                   
                    var txnID = [String]()
                    var cart_mst_ID = [String]()
                    for obj in self.cartObjects {
                        txnID.append(obj.transaction_id)
                        cart_mst_ID.append(obj.cart_mst_id)
                    }
                    let txnIDstr = txnID.joined(separator: ",")
                    let cart_mst_IDstr = cart_mst_ID.joined(separator: ",")
                    
                    print("txnidStr \(txnIDstr)")
                    print("cart_mst_IDstr \(cart_mst_IDstr)")
                    //self.updateCartData(txnid: txnIDstr, userid: userid, cart_mst_ids: cart_mst_IDstr)
                    //end
                    
                    print(data.count)
                    
                    let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "DashboardViewController") as! DashboardViewController
                    destVC.txnIDstr =  txnIDstr
                    destVC.cart_mst_IDstr = cart_mst_IDstr
                    destVC.cartObjects = self.cartObjects
                    
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
            self.presentWindow?.hideToastActivity()
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
//                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
//                        controller.cartObjects = self.cartObjects
//                        self.navigationController?.pushViewController(controller, animated: false)
                        
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
    func convertToDictionary(text: String) -> [Dictionary<String,Any>] {
        
        let data = text.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                print(jsonArray)
                return jsonArray
                print("aa gaya output")// use the json here
            } else {
                print("bad json")
                return [["error_in":"decryption"]]
            }
        } catch let error as NSError {
            print(error)
            
        }
        return [["error_in":"decryption"]]
    }
}
extension UIImage{
    //Draws the top indicator by making image with filling color
    class func drawTabBarIndicator(color: UIColor, size: CGSize, onTop: Bool) -> UIImage {
        let indicatorHeight = size.height / 30
        let yPosition = onTop ? 0 : (size.height - indicatorHeight)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: yPosition, width: size.width, height: indicatorHeight))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
//    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
//        UIGraphicsBeginImageContextWithOptions(size, false, 0)
//        color.setFill()
//        UIRectFill(CGRect(origin: CGPoint(x: 0,y :size.height - lineWidth), size: CGSize(width: size.width, height: lineWidth)))
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return image!
//    }
}
