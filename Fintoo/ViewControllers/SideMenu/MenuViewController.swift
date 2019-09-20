//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit
import Haneke

import Alamofire
import Mixpanel

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}
var flag = "0"
var totalCountFlag = "0"

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate {


    @IBOutlet weak var memberTableHeight: NSLayoutConstraint!

    var selectedIndex = -1
    @IBOutlet weak var emailId: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    /**
    *  Array to display menu options
    */
    var presentWindow : UIWindow?

    @IBOutlet var tblMenuOptions : UITableView!

    @IBOutlet weak var memberList: UITableView!
    /**
    *  Transparent button to hide menu
    */
    @IBOutlet var btnCloseMenuOverlay : UIButton!

    /**
    *  Array containing menu options
    */
    var arrayMenuOptions = [Dictionary<String,String>]()
    var arrayMenuOptions1 = [Dictionary<String,String>]()

    /**
    *  Menu button which was tapped to display the menu
    */
    var btnMenu : UIButton!

    /**
    *  Delegate of the MenuVC
    */
    var delegate : SlideMenuDelegate?
    var picker = UIImagePickerController()
    var imageStr = ""
    var profile = ""
    var cartObjects = [CartObject]()
    let tempArr = ["", "Lumpsum", "SIP", "Additional Purchase"]

    override func viewDidLoad() {
       
        super.viewDidLoad()
        picker.delegate = self
        tblMenuOptions.delegate = self
        tblMenuOptions.dataSource = self
        self.picker.mediaTypes = ["public.image"]
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MenuViewController.imageTapped(gesture:)))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
        
        updateArrayMenuOptions()
        tblMenuOptions.estimatedRowHeight = 40
        tblMenuOptions.rowHeight = UITableViewAutomaticDimension
        presentWindow = UIApplication.shared.keyWindow
        self.automaticallyAdjustsScrollViewInsets = false

        self.profilePicture.layer.cornerRadius = self.profilePicture.frame.size.width / 2;
        self.profilePicture.clipsToBounds = true
        //        print(toProfile!)

        let email = UserDefaults.standard.value(forKey: "Email") as? String
        let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        self.phoneNumber.text = phone!
        self.emailId.text = email!
        profile = UserDefaults.standard.value(forKey: "profile_img") as! String
        print(profile)

        if profile != ""{
            print(profile,"viewwill123")
            if let code = profile as? String {
                self.profilePicture.hnk_setImageFromURL(URL(string:code)!)
            }
            else{
                print("profile uploaded")

            }
        }

        // Do any additional setup after loading the view.
    }
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        Mixpanel.mainInstance().track(event: "Navigation Bar :- Upload Profile Clicked")
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            
            print("Image Tapped")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            destVc.p_id = "12"
            navigationController?.pushViewController(destVc, animated: true)


        }else{
            print("not image")
            print("%%%")
        }

    }


    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
        let assetPath = info[UIImagePickerControllerReferenceURL] as! NSURL
        if (assetPath.absoluteString?.hasSuffix("JPG"))! {
            print("JPG")
        }
        else if (assetPath.absoluteString?.hasSuffix("PNG"))! {
            print("PNG")
        }
        else if (assetPath.absoluteString?.hasSuffix("GIF"))! {
            print("GIF")
        }
        else {
            print("Unknown")
            presentWindow?.makeToast(message: "only jpg, png, gif allowed")
             dismiss(animated:true, completion: nil)
            return
        }
        
        
        
        print("!!!!!!!")
        profilePicture.contentMode = .scaleAspectFit //3
        dismiss(animated:true, completion: nil) //5

        //btn.tag = indexPath.row


    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //updateArrayMenuOptions()
        let profile = UserDefaults.standard.value(forKey: "profile_img") as? String
       // print(profile,"profileimageviewwillappear")
        if profile != ""{
            self.profilePicture.hnk_setImageFromURL(URL(string:profile!)!)
        }
        else{
            print("hello")
        }
        getUserData()
    }

    func updateArrayMenuOptions(){
        arrayMenuOptions.append(["title":"My Profile", "icon":"my_profile"])
        arrayMenuOptions.append(["title":"Members", "icon":"members"])
        arrayMenuOptions.append(["title":"About Us","icon":"about"])
        arrayMenuOptions.append(["title":"Feedback","icon":"feedback"])
        arrayMenuOptions.append(["title":"Contact Us","icon":"contact-us"])
        arrayMenuOptions.append(["title":"FAQ's","icon":"faq"])
        arrayMenuOptions.append(["title":"Terms & Conditions","icon":"terms_conditions"])
        arrayMenuOptions.append(["title":"Change Password","icon":"change_password_nav"])
        arrayMenuOptions.append(["title":"Logout","icon":"logout"])
        tblMenuOptions.reloadData()
    }

    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        //Mixpanel.mainInstance().track(event: "Side Menu Screen :- Side Menu Closed")
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }

        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tblMenuOptions{
        let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear

        let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
        let imgIcon : UIImageView = cell.contentView.viewWithTag(100) as! UIImageView

            imgIcon.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
            lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!

            if indexPath.row == 1{
                let imgIcon : UIImageView = cell.contentView.viewWithTag(102) as! UIImageView
                imgIcon.isHidden = false
                imgIcon.image = UIImage(named: "ic_expand_more")
            } else{
                let imgIcon : UIImageView = cell.contentView.viewWithTag(102) as! UIImageView
                imgIcon.isHidden = true
            }
            return cell
        }
        else {
            tableView.indicatorStyle = UIScrollViewIndicatorStyle.white
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "MemberListTableViewCell")!
            cell.textLabel?.text = arrayMenuOptions2[indexPath.row]["title"]!
            cell.imageView?.image = UIImage(named:"ic_filter_nav_arrow")
            cell.textLabel?.textColor = .white
            return cell
        }


        //return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tblMenuOptions{
            return arrayMenuOptions.count
        }
        else{
            print("arrayMenuOptions2.count \(arrayMenuOptions2.count)")
            return arrayMenuOptions2.count
        }
    }



    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        if tableView == tblMenuOptions{
            let cell: UITableViewCell = tableView.cellForRow(at: IndexPath(row: indexPath.row, section: 0)) as! UITableViewCell
           // let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
            if indexPath.row == 0{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                let userid = UserDefaults.standard.value(forKey: "userid") as? String
                flag = userid ?? "0"
                let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
                if userid == String(describing: p_userid!) {
                    UserDefaults.standard.setValue("0", forKey: "memberid")
                }

                navigationController?.pushViewController(destVC, animated: true)
               // getrandomstring()
                Mixpanel.mainInstance().track(event: "Navigation Bar :- My Profile Clicked")
                self.onCloseMenuClick(btn)
            }
            if indexPath.row == 1{
               // getMemberList()

                let imgIcon : UIImageView = cell.contentView.viewWithTag(102) as! UIImageView
                imgIcon.isHidden = false
                if(selectedIndex == indexPath.row) {
                    imgIcon.image = UIImage(named: "ic_expand_more")

                    selectedIndex = -1
                } else {
                    imgIcon.image = UIImage(named: "up_arrow_white")
                    selectedIndex = indexPath.row
                }
                self.tblMenuOptions.beginUpdates()
                self.tblMenuOptions.endUpdates()

            }
            if indexPath.row == 2{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "AboutUsViewController") as! AboutUsViewController
                //  let navController = UINavigationController(rootViewController: destVC)
                navigationController?.pushViewController(destVC, animated: true)
               // self.present(destVC, animated:true, completion: nil)
                Mixpanel.mainInstance().track(event: "Navigation Bar :- About Us Clicked")
                self.onCloseMenuClick(btn)
            }
            if indexPath.row == 3{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVc = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                destVc.id = "20"
                navigationController?.pushViewController(destVc, animated: true)
                Mixpanel.mainInstance().track(event: "Navigation Bar :- Feedback Clicked")
                 self.onCloseMenuClick(btn)
            }
            if indexPath.row == 4{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                //  let navController = UINavigationController(rootViewController: destVC)
                navigationController?.pushViewController(destVC, animated: true)
                // self.present(destVC, animated:true, completion: nil)
                Mixpanel.mainInstance().track(event: "Navigation Bar :- Contact Us Clicked")
                self.onCloseMenuClick(btn)
            }
            if indexPath.row == 5{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "FAQViewController") as! FAQViewController
                //  let navController = UINavigationController(rootViewController: destVC)
                navigationController?.pushViewController(destVC, animated: true)
                Mixpanel.mainInstance().track(event: "Navigation Bar :- FAQ's Clicked")
                // self.present(destVC, animated:true, completion: nil)
                self.onCloseMenuClick(btn)
            }
            if indexPath.row == 6{
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "TermsConditionViewController") as! TermsConditionViewController
                destVC.id = "12"
                //  let navController = UINavigationController(rootViewController: destVC)
                navigationController?.pushViewController(destVC, animated: true)
                Mixpanel.mainInstance().track(event: "Navigation Bar :- Terms & Condition Clicked")
                // self.present(destVC, animated:true, completion: nil)
                self.onCloseMenuClick(btn)
            }
            if indexPath.row == 7{

                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVc = storyBoard.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                let phone = UserDefaults.standard.value(forKey: Constants.User_Defaults.MOBILE_NUMBER) as? String
                //let userid = UserDefaults.standard.value(forKey: Constants.User_Defaults.USER_ID) as? String
                destVc.toid = "1"
                destVc.tophone = phone
                navigationController?.pushViewController(destVc, animated: true)
                Mixpanel.mainInstance().track(event: "Navigation Bar :- Change Password Clicked")
                self.onCloseMenuClick(btn)
            }
            if indexPath.row == 8{
                UserDefaults.standard.removeObject(forKey: Constants.User_Defaults.USER_LOGIN)
                UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
                arrayMenuOptions2.removeAll()
                flag = "0"
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)

                let destVc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController

                self.present(destVc, animated:true, completion: nil)
                Mixpanel.mainInstance().track(event: "Navigation Bar :- Logout Clicked")

                self.onCloseMenuClick(btn)
            }
        }
        else{
            if indexPath.row == 0 {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "AddMemberViewController") as! AddMemberViewController
                navigationController?.pushViewController(destVC, animated: true)
                // self.present(destVC, animated:true, completion: nil)
                self.onCloseMenuClick(btn)
                Mixpanel.mainInstance().track(event: "Navigation Bar :- Add Member Clicked")

            }
            else{

                var olduserid = UserDefaults.standard.value(forKey: "userid") as! String
                print("olduserid \(olduserid)")
                self.getCartData(olduserid:olduserid,row:indexPath.row)



//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
//
//
//                flag = arrayMenuOptions2[indexPath.row]["id"]!
//                print(arrayMenuOptions2[indexPath.row]["pan"]!)
//                UserDefaults.standard.setValue(arrayMenuOptions2[indexPath.row]["id"]!, forKey: "memberid")
//                UserDefaults.standard.setValue(arrayMenuOptions2[indexPath.row]["pan"]!, forKey: "pan")
//                UserDefaults.standard.setValue(arrayMenuOptions2[indexPath.row]["id"]!, forKey: "userid")
//                getrandomstring()
//               Mixpanel.mainInstance().track(event: "Navigation Bar :- Member \(arrayMenuOptions2[indexPath.row]["title"]!) Clicked")
//                navigationController?.pushViewController(destVC, animated: true)
//                // self.present(destVC, animated:true, completion: nil)
//                self.onCloseMenuClick(btn)
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if tableView != tblMenuOptions{
//            if arrayMenuOptions2.count == 1{
//                return 50
//            } else{
//                return 128
//            }
//        } else{
//            return tblMenuOptions.rowHeight
//        }
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tblMenuOptions{
            if(selectedIndex == indexPath.row) {
                print(arrayMenuOptions2.count)
                if arrayMenuOptions2.count == 1 {
                    return tableView.rowHeight
                }else {
                     return tableView.rowHeight
                 }
            } else {
                return 50;
            }
        }
        else{
            return 60
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

    func getUserData(){
        let uid = UserDefaults.standard.value(forKey: "parent_user_id")
       // presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.GetUserData)\(uid!)"

        if Connectivity.isConnectedToInternet{

            Alamofire.request(url).responseJSON { response in
                //self.presentWindow.hideToastActivity()
                let data = response.result.value
                if data != nil{
                print(data,"profile")
                  //  self.presentWindow.hideToastActivity()
                    if let dataArray = data as? NSArray{
                        // print(dataArray)
                        //print(dataArray.value(forKey: "name"))
                        for abc in dataArray{

                            let profile_picture = (abc as AnyObject).value(forKey: "profile_picture") as? String
                            if profile_picture != ""{
                                self.profilePicture.hnk_setImageFromURL(URL(string:profile_picture ?? "")!)
                                UserDefaults.standard.setValue(profile_picture, forKey: Constants.User_Defaults.PROFILE_IMG)
                            }else {
                                self.profilePicture.image = UIImage(named: "image")
                            }

                            //print(self.userDataArr)
                            //self.postUserData()

                        }
                    }
                }

            }
        }

        else{
           // presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")

        }
    }

}


extension MenuViewController {
    func getCartData(olduserid:String,row:Int) {


        let url1 = "\(Constants.BASE_URL)\(Constants.API.GetCartData)\(olduserid)"
        print(url1)

        let url = "\(Constants.BASE_URL)\(Constants.API.GetCartData)\(olduserid.covertToBase64())/3"
        print(url)
        self.presentWindow?.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
            //self.totalCartValue = 0

            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(olduserid.covertToBase64())/3").responseString { response in
            //Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(olduserid////.covertToBase64())/3").responseString { response in
                let enc_response = response.result.value
                print(enc_response)
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                // print(enc1)
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow?.hideToastActivity()
                    // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                }
                //print(response.result.value ?? "cart detail")
                let data = dict

                //let data = response.result.value
                if !data.isEmpty {
                    var transaction_id = ""
                    var cart_mst_id = ""
                    var txnIDstr = ""
                    var cart_mst_IDstr : String = ""
                    var txnID = [String]()
                    var cart_mst_ID = [String]()
                    self.presentWindow?.hideToastActivity()

                    if let response = data as? [[String: AnyObject]] {
                        print(response)

                        if !response.isEmpty {
                            for cartItem in response {

                                cart_mst_id = cartItem["cart_mst_id"] as? String ?? ""
                                transaction_id = cartItem["transaction_id"] as? String ?? ""

                                txnID.append(transaction_id)
                                cart_mst_ID.append(cart_mst_id)


                            }
                            txnIDstr = txnID.joined(separator: ",")
                            cart_mst_IDstr = cart_mst_ID.joined(separator: ",")

                            print("txnidStr \(txnIDstr)")
                            print("cart_mst_IDstr \(cart_mst_IDstr)")
                            let newUser =  arrayMenuOptions2[row]["id"]!
                            print("newUser \(newUser)")
                            self.updateCartData(txnid: txnIDstr, userid: newUser, cart_mst_ids: cart_mst_IDstr,row:row)
                        }else {
                            let btn = UIButton(type: UIButtonType.custom)
                            btn.tag = row
                            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                            flag = arrayMenuOptions2[row]["id"]!
                            print(arrayMenuOptions2[row]["pan"]!)
                            UserDefaults.standard.setValue(arrayMenuOptions2[row]["id"]!, forKey: "memberid")
                            UserDefaults.standard.setValue(arrayMenuOptions2[row]["pan"]!, forKey: "pan")
                            UserDefaults.standard.setValue(arrayMenuOptions2[row]["id"]!, forKey: "userid")
                            self.getrandomstring()
                            Mixpanel.mainInstance().track(event: "Navigation Bar :- Member \(arrayMenuOptions2[row]["title"]!) Clicked")
                            self.navigationController?.pushViewController(destVC, animated: true)
                            // self.present(destVC, animated:true, completion: nil)
                            self.onCloseMenuClick(btn)
                        }

                        for cartItem in response {

                            cart_mst_id = cartItem["cart_mst_id"] as? String ?? ""
                            transaction_id = cartItem["transaction_id"] as? String ?? ""

                            txnID.append(transaction_id)
                            cart_mst_ID.append(cart_mst_id)

                            /////
                            let MAXINVT = cartItem["MAXINVT"] as? String ?? ""
                            let MININVT = cartItem["MININVT"] as? String ?? ""
                            let SCHEMECODE = cartItem["SCHEMECODE"] as? String ?? ""
                            let SIPMININVT = cartItem["SIPMININVT"] as? String ?? ""
                            let S_NAME = cartItem["S_NAME"] as? String ?? ""
                            let cart_added = cartItem["cart_added"] as? String ?? ""
                            let cart_amount = cartItem["cart_amount"] as? String ?? ""
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
                            let AMC_CODE = cartItem["AMC_CODE"] as? String ?? ""

                            let cartObj = CartObject(MAXINVT: MAXINVT, MININVT: MININVT, SCHEMECODE: SCHEMECODE, SIPMININVT: SIPMININVT, S_NAME: S_NAME, cart_added: cart_added, cart_amount: cart_amount, cart_folio_no: cart_folio_no, cart_frequency: cart_frequency, cart_id: cart_id, cart_mst_id: cart_mst_id, cart_mst_session_id: cart_mst_session_id, cart_purchase_type: cart_purchase_type, cart_scheme_code: cart_scheme_code, cart_sip_start_date: cart_sip_start_date, cart_tenure: cart_tenure, cart_tenure_perpetual: cart_tenure_perpetual, multiples: multiples, transaction_bank_id: transaction_bank_id, transaction_id: transaction_id,cart_sip_start_date1: originalDate, mode: mode, is_save: false, AMC_CODE: AMC_CODE, CLASSCODE: CLASSCODE, nominee: nil)
                            self.cartObjects.append(cartObj)

                        }

                        if totalCountFlag == "1" {
                            UserDefaults.standard.setValue("\(self.cartObjects.count)", forKey: "totalcartcount")
                        }
                        else {
                            UserDefaults.standard.setValue("", forKey: "totalcartcount")
                        }
                        txnIDstr = txnID.joined(separator: ",")
                        cart_mst_IDstr = cart_mst_ID.joined(separator: ",")

                        print("txnidStr \(txnIDstr)")
                        print("cart_mst_IDstr \(cart_mst_IDstr)")
                        var newUser =  arrayMenuOptions2[row]["id"]!
                        print("newUser \(newUser)")
                        //self.updateCartData(txnid: txnIDstr, userid: newUser, cart_mst_ids: cart_mst_IDstr,row:row)


                    }


                } else {
                        print("empty")
                        let btn = UIButton(type: UIButtonType.custom)
                        btn.tag = row
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                        flag = arrayMenuOptions2[row]["id"]!
                        print(arrayMenuOptions2[row]["pan"]!)
                        UserDefaults.standard.setValue(arrayMenuOptions2[row]["id"]!, forKey: "memberid")
                        UserDefaults.standard.setValue(arrayMenuOptions2[row]["pan"]!, forKey: "pan")
                        UserDefaults.standard.setValue(arrayMenuOptions2[row]["id"]!, forKey: "userid")
                        self.getrandomstring()
                        Mixpanel.mainInstance().track(event: "Navigation Bar :- Member \(arrayMenuOptions2[row]["title"]!) Clicked")
                        self.navigationController?.pushViewController(destVC, animated: true)
                        // self.present(destVC, animated:true, completion: nil)
                        self.onCloseMenuClick(btn)

                }
            }
        } else{
//            presentWindow!.hideToastActivity()
//            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }

    func updateCartData(txnid:String,userid:String,cart_mst_ids:String,row:Int) {
        print("updateCartData called with txnid : \(txnid) userid:\(userid) cart_mst_ids:\(cart_mst_ids)")
        let url = "\(Constants.BASE_URL)\(Constants.API.UpdateCartData)"
        let parameters = ["transaction_ids":"\(txnid)","newuser":"\(userid)","cart_mst_ids":"\(cart_mst_ids)"]

        print(url)
        self.presentWindow?.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    let enc_response = response.result.value!
                    print(enc_response)
                    var dict = ""
                    let enc1 = enc_response.replacingOccurrences(of: "\n" , with: "")
                    //                    if let enc = enc1.base64Decoded() {
                    //                        dict = enc
                    //                    } else{
                    self.presentWindow?.hideToastActivity()
                    // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    //}
                    dict = enc1
                    print("dict \(dict)")
                    if dict == "\"true\"" || dict == "true"{
                        totalCountFlag = "1"
                        let btn = UIButton(type: UIButtonType.custom)
                        btn.tag = row

                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                        flag = arrayMenuOptions2[row]["id"]!
                        print(arrayMenuOptions2[row]["pan"]!)
                        UserDefaults.standard.setValue(arrayMenuOptions2[row]["id"]!, forKey: "memberid")
                        UserDefaults.standard.setValue(arrayMenuOptions2[row]["pan"]!, forKey: "pan")
                        UserDefaults.standard.setValue(arrayMenuOptions2[row]["id"]!, forKey: "userid")
                        self.getrandomstring()
                        Mixpanel.mainInstance().track(event: "Navigation Bar :- Member \(arrayMenuOptions2[row]["title"]!) Clicked")
                        self.navigationController?.pushViewController(destVC, animated: true)
                        // self.present(destVC, animated:true, completion: nil)
                        self.onCloseMenuClick(btn)
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
                return jsonArray
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
