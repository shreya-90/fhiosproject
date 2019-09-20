
//  ViewController.swift
//  Fintoodemo
//
//  Created by iosdevelopermme on 05/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Charts
import NVActivityIndicatorView
import Mixpanel
import Alamofire
import SVProgressHUD

class investViewController: BaseViewController, CustomCellDelegate, idDelegate,UITextFieldDelegate {

    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var txt_searcFund: UITextField!
    @IBOutlet weak var comapreFundCountLabel: UILabel!
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var noSchemeView: UIView!
    
    @IBOutlet weak var compareFundButtonView: UIView!
    //@IBOutlet weak var activityIndicatorView : UIActivityIndicatorView!
    
    @IBOutlet weak var newFilterButton: UIButton!

    @IBOutlet weak var suggestionsFilterView: UIView!
    @IBOutlet weak var suggestedFilterHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var recommendedBtn: UIButton!
    
    @IBOutlet weak var mostPopularBtn: UIButton!
    
    @IBOutlet weak var topRatedBtn: UIButton!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    var filterSuggestionArr = [ProductObj]()
    var slectedSearchIndex = ""
    var searchFlag = false
    
    var id = [String]()
    var selected_fund_id = [String]()
    var MODE = [Int]()
    var ASSETTYPE = [Int]()
    var CATEGORY = [String]()
    var FUND_OPTION = [Int]()
    var FUND_HOUSE = [Int]()
    var RISK_LEVEL = [String]()
    var MIN_INVESTMENT = [Int]()
    var mininv_for : String?
    var S_Goal = [Int]()
    var currentOffset = 0
    var row1 : Int!
    var s_row : Int!
    var productArr = [ProductObj]()
    var productArrForSearch = [ProductObj]()
    var count = 0
    var items : Int!
    var selectedIndex = -1
    var message = ""
    var pageCount = 1
    var firstTimeLoadFlag = 0
    var scheme_count : String = ""
    var suggestionsFilterNameArray = ["Recommended","Most Popular","Top Rated"]
    
    var recommendedSelected = "0"
    var mostPopularSelected = "0"
    var topRatedSelected = "0"
    //#MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTableView.delegate =  self
        searchTableView.dataSource = self
        
        //tableViewTopConstraint.constant = 0.0
        //suggestedFilterHeightConstraint.constant = 0.0
        txt_searcFund.isHidden = false
        txt_searcFund.delegate = self
        txt_searcFund.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if mininv_for == nil{
            mininv_for = ""
        }
        self.pageCount = 1
        firstTimeLoadFlag = 1
        //getSchemeListCount()
        getFirstPage()
        setWhiteNavigationBar()
        addBackbutton()
        addRightBarButtonItems(items: [cartButton])
        
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 40
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.allowsSelection = false
        
       // suggestionsFilterTableView.delegate =  self
       // suggestionsFilterTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getAllPages()
        if id.count != 0{
            tableViewTopConstraint.constant = 0
            comapreFundCountLabel.text = "\(id.count)"
        }
        cart_count()
    }
    
    override func onCartButtonPressed(_ sender: UIButton) {
        
        self.getUserProfileStat()
//        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    override func onCart1ButtonPressed(_ sender : UIButton)
    {
        self.getUserProfileStat()
//        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
//        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
//
//        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Invest Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "investSubCategoryViewController") as! investSubCategoryViewController
        filterList.removeAll()
        Lumpsum.removeAll()
        SIP.removeAll()
        modeSubCategoryList.removeAll()
        navigationController?.pushViewController(destVC, animated: true)
    }
    
    @IBAction func suggestionsFilterTapped(_ sender: UIButton) {
        suggestionsFilterView.isHidden = !suggestionsFilterView.isHidden
        if suggestionsFilterView.isHidden == false {
             suggestedFilterHeightConstraint.constant = 50.0
        }else{
            suggestedFilterHeightConstraint.constant = 0.0
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
    
    @IBAction func recommendedBtnClicked(_ sender: UIButton) {
        self.pageCount = 0
        self.txt_searcFund.text = ""
        self.productArr.removeAll()
        
        
        if sender.isSelected == false {
            recommendedSelected = "1"
            //recommendedBtn.backgroundColor = UIColor(red: 0, green: 180, blue: 236, alpha: 1)
//            recommendedBtn.backgroundColor = UIColor.red
             sender.backgroundColor = UIColor.darkGray
           
             sender.isSelected = true
            
            mostPopularBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
            mostPopularBtn.isSelected = false
            topRatedBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
            topRatedBtn.isSelected = false
            topRatedSelected = "0"
            mostPopularSelected = "0"
            self.count = 0
            self.scheme_count = "0"
            getSchemeListCount()
            tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            //tableview.scrollToRow(at: indexPath, at: .top, animated: true)
        } else {
            recommendedSelected = "0"
            //sender.backgroundColor = UIColor(red: 85, green: 85, blue: 85, alpha: 1)
             sender.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
            
             sender.isSelected = false
            self.count = 0
            self.scheme_count = "0"
            getSchemeListCount()
             tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            //tableview.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    @IBAction func mostPopularBtnClicked(_ sender: UIButton) {
         self.pageCount = 0
         self.txt_searcFund.text = ""
         self.productArr.removeAll()

        if sender.isSelected == false {
            mostPopularSelected = "1"
           // mostPopularBtn.backgroundColor = UIColor(red: 0, green: 180, blue: 236, alpha: 1)
            
            sender.backgroundColor = UIColor.darkGray
            sender.isSelected = true
            
            recommendedBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
            recommendedBtn.isSelected = false
            topRatedBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
            topRatedBtn.isSelected = false
            topRatedSelected = "0"
            recommendedSelected = "0"
            
            self.count = 0
            self.scheme_count = "0"
            getSchemeListCount()
         
            
             tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            //tableview.scrollToRow(at: indexPath, at: .top, animated: true)
            
        } else {
            mostPopularSelected = "0"
            //sender.backgroundColor = UIColor(red: 85, green: 85, blue: 85, alpha: 1)
            sender.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
            sender.isSelected = false
            self.count = 0
            self.scheme_count = "0"
            getSchemeListCount()
           
            
             tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            //tableview.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    @IBAction func topRatedBtnClicked(_ sender: UIButton) {
         self.pageCount = 0
         self.txt_searcFund.text = ""
         self.productArr.removeAll()

        if sender.isSelected == false {
            topRatedSelected = "1"
            //topRatedBtn.backgroundColor = UIColor(red: 0, green: 180, blue: 236, alpha: 1)
            sender.backgroundColor = UIColor.darkGray
            
            sender.isSelected = true
            
            recommendedBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
            recommendedBtn.isSelected = false
            mostPopularBtn.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
            mostPopularBtn.isSelected = false
            mostPopularSelected = "0"
            recommendedSelected = "0"
            self.count = 0
            self.scheme_count = "0"
            getSchemeListCount()
           
            tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            //tableview.scrollToRow(at: indexPath, at: .top, animated: true)
            
        } else {
            topRatedSelected = "0"
            //sender.backgroundColor = UIColor(red: 85, green: 85, blue: 85, alpha: 1)
            sender.isSelected = false
            //sender.backgroundColor = UIColor.darkGray
            sender.backgroundColor = #colorLiteral(red: 0, green: 0.7058823529, blue: 0.9411764706, alpha: 1)
            self.count = 0
            self.scheme_count = "0"
            getSchemeListCount()
           
            tableview.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            //tableview.scrollToRow(at: indexPath, at: .top, animated: true)
            
        }
    }
}

//#MARK: IBAction
extension investViewController{
    @IBAction func filterbtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Invest Screen :- Filter Button Clicked")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
        destVC.selected_id = id
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    @IBAction func searchIconBtn(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Invest Screen :- Search Button Clicked")
        self.txt_searcFund.resignFirstResponder()
        self.productArr.removeAll()
        self.count = 0
        self.pageCount = 0
        self.searchTableView.isHidden = true
        //self.searchFlag = true
        self.getFirstPage()
    }
    @IBAction func compareSelectedFund(_ sender: Any) {
       // id.removeAll()
        for i in 0..<productArr.count{
            if productArr[i].isSelected{
                if !id.contains(productArr[i].Scheme_code) {
                    id.append(productArr[i].Scheme_code)
                }
            }
        }
        if id.count == 1 {
            presentWindow.makeToast(message: "Please select atleast 2 schemes to compare.")
        }else if id.isEmpty {
            presentWindow.makeToast(message: "Please select atleast 2 schemes to compare.")
        }else if id.count < 4 {
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "CompareFundViewController") as! CompareFundViewController
            destVC.id = id
            destVC.delegate = self
            
            //var p_name_arr,c_nav_arr,OPT_code_arr,bseschemetype_arr,Scheme_code_arr,sipfreqs_arr,allsipamounts1_arr,MAXINVT_arr : [String]()
           var row = [Int]()
            var p_name_arr = [String]()
            var c_nav_arr = [String]()
            var OPT_code_arr = [String]()
            var bseschemetype_arr = [String]()
            var Scheme_code_arr = [String]()
            var sipfreqs_arr = [String]()
            var allsipamounts1_arr = [String]()
            var MAXINVT_arr = [String]()
            var SIPAvailable = [String]()
            var lumpsumMin = [String]()
            
            for i in 0..<productArr.count{
                if productArr[i].isSelected{
                    if id.contains(productArr[i].Scheme_code) {
                       
                        p_name_arr.append(productArr[i].p_name ?? "")
                        c_nav_arr.append(productArr[i].p_nav ?? "")
                        OPT_code_arr.append(productArr[i].OPT_Code ?? "")
                        bseschemetype_arr.append(productArr[i].bseschemetype ?? "")
                        Scheme_code_arr.append(productArr[i].Scheme_code )
                        sipfreqs_arr.append(productArr[i].sipfreq ?? "")
                        allsipamounts1_arr.append(productArr[i].allsipamounts ?? "")
                        MAXINVT_arr.append(productArr[i].MAXINVT ?? "")
                       row.append(i)
                        SIPAvailable.append(productArr[i].SIP ?? "")
                        lumpsumMin.append(productArr[i].lumpsum_Min ?? "")
                        
                        
                    }
                }
            }
            
            destVC.p_name_arr = p_name_arr
            destVC.c_nav_arr = c_nav_arr
            destVC.OPT_code_arr = OPT_code_arr
            destVC.row = row
            destVC.bseschemetype_arr = bseschemetype_arr
            destVC.Scheme_code_arr = Scheme_code_arr
            destVC.sipfreqs_arr = sipfreqs_arr
            destVC.allsipamounts1_arr = allsipamounts1_arr
            destVC.MAXINVT_arr = MAXINVT_arr
            destVC.SIPAvailable = SIPAvailable
            destVC.lumpsumMin = lumpsumMin
            
            self.navigationController?.pushViewController(destVC, animated: true)
        } else {
            presentWindow.makeToast(message: "Only three funds can be compared.")
        }
    }
    @IBAction func clearAll(_ sender: Any) {
        //tableViewTopConstraint.constant = 0.0
        for i in 0..<productArr.count{
            if productArr[i].isSelected{
                productArr[i].isSelected = false
            }
        }
        tableview.reloadData()
        comapreFundCountLabel.text = "0"
        id.removeAll()
    }
    
    
    
    
    
}

