//
//  ViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 09/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
import CryptoSwift
var arrayMenuOptions2 = [Dictionary<String,String>]()
class ViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    var arrayMenuOptions = [Dictionary<String,String>]()
    var id:String!
    var id1 : Int!
    @IBOutlet weak var tableview: UITableView!
    var p_id = ""
    var picker = UIImagePickerController()
    var notification_kill = [AnyHashable : Any]()

    var cartObjects = [CartObject]()
    let tempArr = ["", "Lumpsum", "SIP", "Additional Purchase"]

    override func viewDidLoad() {

        super.viewDidLoad()
        arrayMenuOptions2.removeAll()
        self.tabBarController?.tabBar.isHidden = true
        picker.delegate = self
        self.picker.sourceType = .savedPhotosAlbum
        //self.picker.mediaTypes = ["public.image"]
        setWhiteNavigationBar()
        addLeftBarButtonItems(items:[menuButton])
        addRightBarButtonItems(items: [cartButton])
        tableview.delegate = self
        tableview.dataSource = self
        arrayMenuOptions.append(["title":"INVEST", "icon":"invest"])
        arrayMenuOptions.append(["title":"MY PORTFOLIO", "icon":"my_portfolio"])
        arrayMenuOptions.append(["title":"BUY INSURANCE", "icon":"buy_insurance"])
        self.tableview.separatorStyle = UITableViewCellSeparatorStyle.none

        if p_id == "12"{
            pick_image()
        }
        if  id == "20"{
            let refreshAlert = UIAlertController(title: "Are you Happy With Fintoo?", message: "", preferredStyle: UIAlertControllerStyle.alert)

            refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle no logic here")
                //Crashlytics.sharedInstance().crash()
                Mixpanel.mainInstance().track(event: "Feedback Screen :- No Button Clicked")
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVc = storyBoard.instantiateViewController(withIdentifier: "noPopupViewController") as! noPopupViewController
                //destVc.id = "20"``````
                //self.navigationController?.pushViewController(destVc, animated: true)
                self.present(destVc, animated: true)


            }))

            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Yes Logic here")
                self.presentWindow!.makeToast(message: "Let's Share Your Happiness With Others!")
                 Mixpanel.mainInstance().track(event: "Feedback Screen :- Yes Button Clicked")

                //fatalError()
                //Crashlytics.sharedInstance().crash()
                //self.navigationController?.view.makeToast("Lets Share Your Happiness With Others", duration: 3.0, position: .bottom)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                    //UIApplication.shared.openURL(NSURL(string: "https://itunes.apple.com/us/app/minty/id1339092462?ls=1&mt=8")! as URL)
                    guard let url = URL(string: "https://itunes.apple.com/us/app/minty/id1339092462?ls=1&mt=8"), !url.absoluteString.isEmpty else {
                        return
                    }
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                })
            }))

            present(refreshAlert, animated: true, completion: nil)
        } else if id == "kill"{
             kill_stage_notification(notification: notification_kill)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(self.showBackgroundNotification), name: NSNotification.Name(rawValue: "notificationName"), object: nil)
        cart_count()
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        if sessionId == nil{
            getrandomstring()
        }
        arrayMenuOptions2.removeAll()
        if arrayMenuOptions2.isEmpty{
            arrayMenuOptions2.append(["title":"ADD MEMBER", "icon":"ic_filter_nav_arrow"])
        }
        
        let userid = UserDefaults.standard.value(forKey: "userid")
        let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
        print("@@@\(userid)\(p_userid)")
        getMemberList()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)

    }
    func kill_stage_notification(notification:[AnyHashable:Any]){
        print("notif")
        print(notification,"data")
        let activity = notification["activity"] as? String
        if activity == "webinar" {
            let link = notification["link1"] as? String
            UIApplication.shared.open(NSURL(string: link!) as! URL)
            Mixpanel.mainInstance().track(event: "Landing Page Screen :- Webinar Notification")
        }else if activity == "general"{
            let content =  notification["content"] as? String
            let alertController = UIAlertController(title: "", message: content, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            Mixpanel.mainInstance().track(event: "Landing Page Screen :- General Notification")
        }
        else if activity == "update"{
            let update =  notification["update"] as? String
            let alertController = UIAlertController(title: "", message: update, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction!) in
                UIApplication.shared.open(NSURL(string: "https://itunes.apple.com/us/app/minty/id1339092462?ls=1&mt=8")! as URL)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            Mixpanel.mainInstance().track(event: "Landing Page Screen :- Update Notification")
        }else if activity == "calculator"{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "insuranceViewController") as! insuranceViewController

            self.navigationController?.pushViewController(destVC, animated: true)
            Mixpanel.mainInstance().track(event: "Landing Page Screen :- Calculator Notification")

        }else if activity == "productlist" {
            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {
                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                checking_pancard()
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
        }else if activity == "goalbased" {
            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {
                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "pickAndInvestViewController") as! pickAndInvestViewController

                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                checking_pancard()
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
        }else if activity == "dashboard" {
            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
                    destVC.dashboardIndex = true
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
            } else {
                checking_pancard()
                id1  = 1
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
        } else if activity == "invest" {
            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "investSubCategoryViewController") as! investSubCategoryViewController
                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                checking_pancard()
                id1  = 1
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
        } else if activity == "myprofile" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    @objc func showBackgroundNotification(_ notification: NSNotification) {
        let activity = notification.userInfo?["activity"] as? String
        if activity == "webinar" {
            let link = notification.userInfo?["link1"] as? String
            UIApplication.shared.open(NSURL(string: link!) as! URL)
            Mixpanel.mainInstance().track(event: "Landing Page Screen :- Webinar Notification")
        }else if activity == "general"{
            let content =  notification.userInfo?["content"] as? String
            let alertController = UIAlertController(title: "", message: content, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            Mixpanel.mainInstance().track(event: "Landing Page Screen :- General Notification")
        }
        else if activity == "update"{
            let update =  notification.userInfo?["update"] as? String
            let alertController = UIAlertController(title: "", message: update, preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "Update", style: .default) { (action:UIAlertAction!) in
                UIApplication.shared.open(NSURL(string: "https://itunes.apple.com/us/app/minty/id1339092462?ls=1&mt=8")! as URL)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            Mixpanel.mainInstance().track(event: "Landing Page Screen :- Update Notification")
        }else if activity == "calculator"{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "insuranceViewController") as! insuranceViewController

            self.navigationController?.pushViewController(destVC, animated: true)
            Mixpanel.mainInstance().track(event: "Landing Page Screen :- Calculator Notification")

        }else if activity == "productlist" {
            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {
                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                checking_pancard()
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
        }else if activity == "goalbased" {
            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {
                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "pickAndInvestViewController") as! pickAndInvestViewController

                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                checking_pancard()
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
        }else if activity == "dashboard" {
            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {
                let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
                destVC.dashboardIndex = true
                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                checking_pancard()
                id1  = 1
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
        } else if activity == "invest" {
            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {
                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "investSubCategoryViewController") as! investSubCategoryViewController
                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                checking_pancard()
                id1  = 1
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
        } else if activity == "myprofile" {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
            navigationController?.pushViewController(destVC, animated: true)
        }
    }
    override func onCart1ButtonPressed(_ sender: UIButton) {
        print("cart")
        Mixpanel.mainInstance().track(event: "Landing Page :- Cart Button Clicked")
        let userdefaults = UserDefaults.standard
        let savedValue = userdefaults.string(forKey: "pan")
        if savedValue != nil && savedValue != "" {
            //self.getUserProfileStat(id:4)
            self.getTransactionDetail(id: 4)
//            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//            let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//            self.navigationController?.pushViewController(destVC, animated: true)
        } else {
            self.id1 = 2
            checking_pancard()
            print("No value in Userdefault,Either you can save value here or perform other operation")

        }

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ViewControllerCell
        cell.imageview.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        cell.namelabel.text = arrayMenuOptions[indexPath.row]["title"]!

        cell.contentView.backgroundColor = UIColor.clear

        let whiteRoundedView : UIView = UIView(frame: CGRect(x:10, y:8, width:self.view.frame.size.width - 20, height:160))

        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 8.0
        whiteRoundedView.layer.shadowOffset = CGSize(width:-1, height:1)
        whiteRoundedView.layer.shadowOpacity = 0.2

        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)

        return cell
        //return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        if indexPath.row == 0{

            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {

                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "investSubCategoryViewController") as! investSubCategoryViewController
                self.navigationController?.pushViewController(destVC, animated: true)
                                print("list")
            } else {
                checking_pancard()
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
        }
        if indexPath.row == 1{
//            checking_pancard()
//            id1  = 1
            let userdefaults = UserDefaults.standard
            let savedValue = userdefaults.string(forKey: "pan")
            if savedValue != nil && savedValue != "" {
                //self.getUserProfileStat(id:1)
                self.getTransactionDetail(id: 1)
//                let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
//                destVC.dashboardIndex = true
//                self.navigationController?.pushViewController(destVC, animated: true)
            } else {
                checking_pancard()
                 id1  = 1
                print("No value in Userdefault,Either you can save value here or perform other operation")

            }
         }
        if indexPath.row == 2{
            let userid = UserDefaults.standard.value(forKey: "userid")
            //UserDefaults.standard.setValue(userid!, forKey: "parent_user_id")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "insuranceViewController") as! insuranceViewController

            self.navigationController?.pushViewController(destVC, animated: true)
            // self.present(navController, animated:true, completion: nil)
        }

    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    func checking_pancard(){
        var userid = UserDefaults.standard.value(forKey: "userid")
        //UserDefaults.standard.setValue(userid!, forKey: "parent_user_id")
        if flag != "0"{
            userid! = flag

        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid")
        }
       presentWindow.makeToastActivity(message: "Loading..")
        let url = "\(Constants.BASE_URL)\(Constants.API.CHECK_PAN_DB)\(userid!)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data = response.result.value
                if data != nil{
                    if let data = response.result.value as? [AnyObject]{

                        for type in data {
                            if let pan = type.value(forKey: "pan") as? String,
                                let name = type.value(forKey: "name") as? String{
                                print(name)
                                UserDefaults.standard.setValue(pan, forKey: "pan")
                                UserDefaults.standard.setValue(name, forKey: "name")
                                if pan == ""{
                                    self.presentWindow.hideToastActivity()
                                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                    let destVC = storyBoard.instantiateViewController(withIdentifier: "PanCardViewController") as! PanCardViewController

                                    self.navigationController?.pushViewController(destVC, animated: true)
                                }
                                else{
                                   
                                    if self.id1 == 1{

                                        //self.presentWindow.hideToastActivity()
                                        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
                                        let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
                                        destVC.dashboardIndex = true
                                        self.navigationController?.pushViewController(destVC, animated: true)
                                        print("list")
                                    }
                                    else if self.id1 == 2 {
                                        // self.getUserProfileStat(id:4)
                                        self.getTransactionDetail(id: 4)
                                    }else{
                                        self.presentWindow.hideToastActivity()
                                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                                        let destVC = storyBoard.instantiateViewController(withIdentifier: "investSubCategoryViewController") as! investSubCategoryViewController

                                        self.navigationController?.pushViewController(destVC, animated: true)
                                        print("list")
                                    }

                                }
                                // self.stopSIP(transaction_cart_id: "\(transaction_cart_id)")
                            }

                        }
                    }

                }
                else{
                    self.presentWindow.hideToastActivity()
                    print("nill data")
                }
            }

        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")

        }
    }



    func pick_image(){

        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
       // picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!

        present(picker, animated: true, completion: nil)
        // Mixpanel.mainInstance().track(event: "Side Menu Screen :- Profile Pic Selected")

    }
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage //2
        print("!!!!!!!")
        //profilePicture.contentMode = .scaleAspectFit //3
        dismiss(animated:true, completion: nil) //5

        //btn.tag = indexPath.row
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
            presentWindow?.makeToast(message: "Only jpg, png, gif allowed")
            print("Unknown")
            return
        }
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVc = storyBoard.instantiateViewController(withIdentifier: "ImgaeUpdateViewController") as! ImgaeUpdateViewController
        destVc.toimage = chosenImage!

        self.present(destVc, animated: true)

        // Mixpanel.mainInstance().track(event: "Side Menu Screen :- Profile Pic Selected")

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         Mixpanel.mainInstance().track(event: "Image Picker  :- Cancel button Clicked")
        dismiss(animated: true, completion: nil)
        //Mixpanel.mainInstance().track(event: "Side Menu Screen :- Cancel Button Pressed On Image Picker")
    }
    func getMemberList(){
        presentWindow.makeToastActivity(message: "Loading..")
        let userid = UserDefaults.standard.value(forKey: "userid")
        let p_userid = UserDefaults.standard.value(forKey: "parent_user_id")
        var url1 = ""
        let userdefaults = UserDefaults.standard
        if userdefaults.string(forKey: "parent_user_id") != nil{
            url1 = "\(Constants.BASE_URL)\(Constants.API.getmemberswithparent)/\(p_userid!)"
        } else {
            url1 = "\(Constants.BASE_URL)\(Constants.API.getmemberswithparent)/\(userid!)"
        }

        //let url1 = "\(Constants.BASE_URL)\(Constants.API.getmemberswithparent)/\(p_userid!)"
       // let url = "\(Constants.BASE_URL)\(Constants.API.Member_List)\(userid!)"
        print(url1)
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url1).responseJSON { response in
                self.presentWindow.hideToastActivity()
                let data = response.result.value
                if data != nil{
                    if let dataArray = data as? NSArray{
                        // print(dataArray)
                        print(dataArray.value(forKey: "name"))
                        for abc in dataArray{
                            let name = (abc as AnyObject).value(forKey: "name")
                            let id = (abc as AnyObject).value(forKey: "id") as? String
                            let pan = (abc as AnyObject).value(forKey: "pan") as? String
                            if id == String(describing: p_userid!) {
                                arrayMenuOptions2.insert(["title":"\(name!) (User)", "icon":"my_profile","id":"\(id!)","pan":"\(pan!)"], at: 1)
                                //arrayMenuOptions2.append(["title":"\(name!) (User)", "icon":"my_profile","id":"\(id!)"])
                            } else {
                                arrayMenuOptions2.append(["title":"\(name!)", "icon":"my_profile","id":"\(id!)","pan":"\(pan!)"])
                            }
                            //print(arrayMenuOptions2)
                            //self.tblMenuOptions.reloadData()
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
    func getTransactionDetail(id:Int){
       
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
       
        let url = "\(Constants.BASE_URL)\(Constants.API.getTransactionDetail)\(new_pan1!.covertToBase64())/3"
        print(url)
        //self.presentWindow.makeToastActivity(message: "Loading..")
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
                if !data.isEmpty {
                    if id == 4 {
                        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                        
                    } else {
                        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
                        destVC.dashboardIndex = true
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                }else{
                   self.getUserProfileStat(id: id)
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
                        UserDefaults.standard.setValue(randomstring, forKey: "sessionId")
                    }
                }
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func cart_count(){
        print(UserDefaults.standard.value(forKey: "userid")!)
        var userid = "\(String(describing: UserDefaults.standard.value(forKey: "userid")!))"
        if flag != "0"{
            userid = flag

        }
        else{
            // flag = "0"
            userid = "\(String(describing: UserDefaults.standard.value(forKey: "userid")!))"
        }
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3").responseString { response in
                let enc_response = response.result.value
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
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

                    if let response = data as? [[String: AnyObject]]{
                        print(response)
                        if !response.isEmpty{

                    print("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3")
                    print(data.count)

                    var transaction_id = ""
                    var cart_mst_id = ""


                    for cartItem in response {
                        let MAXINVT = cartItem["MAXINVT"] as? String ?? ""
                        let MININVT = cartItem["MININVT"] as? String ?? ""
                        let SCHEMECODE = cartItem["SCHEMECODE"] as? String ?? ""
                        let SIPMININVT = cartItem["SIPMININVT"] as? String ?? ""
                        let S_NAME = cartItem["S_NAME"] as? String ?? ""
                        let cart_added = cartItem["cart_added"] as? String ?? ""
                        let cart_amount = cartItem["cart_amount"] as? String ?? ""
                        //self.totalCartValue = self.totalCartValue + Int(cart_amount)!
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

                                    //}
                                //}
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
            }else{
                    self.btnCart.badgeString = String(data.count)
            }
                }
            }

                } else {
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
                    }else{
                        self.btnCart.badgeString = String(data.count)
                    }
                }
            }
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func getUserProfileStat(id:Int){
        
        let panid = UserDefaults.standard.value(forKey: "pan") as? String
        let new_pan = panid?.replacingOccurrences(of: "'", with: "")
        
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        
        let url = "\(Constants.BASE_URL)\(Constants.API.CHECK_USER_STAT)\(new_pan!)"
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
                            
                            
                        }else {
                           
                            if id == 4 {
                            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                            let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
                            self.navigationController?.pushViewController(destVC, animated: true)
                                
                            } else {
                                let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
                                let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
                                destVC.dashboardIndex = true
                                self.navigationController?.pushViewController(destVC, animated: true)
                            }
                            
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
extension UIColor {
    convenience init(hexaString: String, alpha: CGFloat = 1) {
        let chars = Array(hexaString.characters)
        self.init(red:   CGFloat(strtoul(String(chars[1...2]),nil,16))/255,
                  green: CGFloat(strtoul(String(chars[3...4]),nil,16))/255,
                  blue:  CGFloat(strtoul(String(chars[5...6]),nil,16))/255,
                  alpha: alpha)}
}
extension Data {
    func aesEncrypt(key: String, iv: String) throws -> Data{
        let encypted = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).encrypt(self.bytes)
        return Data(bytes: encypted)
    }

    func aesDecrypt(key: String, iv: String) throws -> Data {
        let decrypted = try AES(key: key.bytes, blockMode: CBC(iv: iv.bytes), padding: .pkcs7).decrypt(self.bytes)
        return Data(bytes: decrypted)
    }
}
extension String {
    var utf8Array: [UInt8] {
        return Array(utf8)
    }
}
