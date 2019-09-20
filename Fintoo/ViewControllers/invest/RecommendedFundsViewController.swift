//
//  RecommendedFundsViewController.swift
//  Fintoo
//
//  Created by Tabassum Sheliya on 07/06/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
class RecommendedFundsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,recommendedCellDelegate {
    
    
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var targetAmtStackView: UIStackView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var heightConstraintsOfSearchView: NSLayoutConstraint!
    
    @IBOutlet weak var selectAllButtonOutlet: UIButton!
    @IBOutlet weak var cancelSearchViewButtton: UIButton!
    var flags  = "0"
    var SIP_Start_date = [String]()
    var sipCalculationArr = [SIP_date_calculation]()
    var recommendedFundArr = [recommendedFundObj]()
    var filterrecommendedFundArr = [recommendedFundObj]()
    var finalDisplayListArr = [recommendedFundObj]()
    var addSearchFundArr = [addRecommendFundObj]()
    var invest_value = ""
    var mode = 0
    var year =  ""
    var productArr = [ProductObj]()
    var divided_amount = 0
    var parameters = [String:Any]()
    var FundSubtype_LC = ["31","49","62","61","1"]
    var FundSubtype_MC = ["32","49","61","1"]
    var FundSubtype_SC = ["33","49","63","1"]
    var FundSubtype_LT = ["18","21","23","27","40","56","68","70","71","72"]
    var FundSubtype_MT = ["21","23","27","28","40","45","46","55","68","70","71"]
    var FundSubtype_ST = ["16","17","20","22","24","46","50","51","52","65","66","67","69"]
    var FundSubtype_H = ["11","12","13","14","15","19","47","54","57","74","75"]
    var common_list_arr = [String]()
    var reminder = 0
    var currentOffset = 0
    private var filterSearchArr = [ProductObj]()
    var divided_amount_arr =  [String]()
     var updated_amount_arr =  [String]()
    let tempArr = ["", "Lumpsum", "SIP", "Additional Purchase"]
    var cartObjects = [CartObject]()
    var rec_type_arr = [String:Any]()
    var slectedSearchIndex = ""
    var index_of_selected_fund = 0
    @IBOutlet weak var noSchemeView: UIView!
    
    @IBOutlet weak var addSelectedFundView: UIView!
    @IBOutlet weak var addFundTableView: UITableView!
    @IBOutlet weak var mainCellView: UIView!
    @IBOutlet weak var recommendedFundLabel: UILabel!
    @IBOutlet weak var targetAmountLabel: UILabel!
    @IBOutlet weak var fundListTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if filterList.count == 0 {
            filterList = [(category: "MODE",subCategory: [SubCategoryModel]()),(category: "ASSET TYPE",subCategory: [SubCategoryModel]()),(category: "CATEGORY",subCategory: [SubCategoryModel]()),(category: "FUND OPTION",subCategory: [SubCategoryModel]()),(category: "FUND HOUSE",subCategory: [SubCategoryModel]()),(category: "RISK LEVEL",subCategory: [SubCategoryModel]()),(category: "MIN INVESTMENT",subCategory: [SubCategoryModel]())]
            
        }
        if self.mode == 1{
            reminder = Int(self.invest_value)!/5000
        } else {
            reminder = Int(self.invest_value)!/12000
        }
        get_pick_logic(id:1)
        
        fundListTableView.delegate = self
        fundListTableView.dataSource = self
        addFundTableView.delegate = self
        addFundTableView.dataSource = self
        fundListTableView.estimatedRowHeight = 40
        fundListTableView.rowHeight = UITableViewAutomaticDimension
        addBackbutton()
        searchTf.delegate = self
        searchTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        targetAmountLabel.text = invest_value
        addRightBarButtonItems(items: [cartButton])
        heightConstraintsOfSearchView.constant = 110
    }
    override func viewWillAppear(_ animated: Bool) {
        getCartData()
        self.cart_count()
        //fundListTableView.reloadData()
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    override func onCartButtonPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == addFundTableView {
               return filterSearchArr.count

        } else {
            return finalDisplayListArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == addFundTableView {
            //if !filterSearchArr.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
                cell?.textLabel?.text = filterSearchArr[indexPath.row].p_name
                cell?.textLabel?.numberOfLines = 0
                return cell!
//            } else {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
//                cell?.textLabel?.text = addSearchFundArr[indexPath.row].value
//                cell?.textLabel?.numberOfLines = 0
//                return cell!
//            }
            
        } else  {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! recommendedCell
            cell.lumpsumButtonOutlet.tag = indexPath.row
            cell.startSipButtonOutlet.tag = indexPath.row
            cell.amountTf.tag = indexPath.row
            cell.amountTf.delegate = self
            cell.removeFundOutlet.tag = indexPath.row
            cell.fundCheckButtonOutlet.tag = indexPath.row
            cell.fundDetailButtonOutlet.tag = indexPath.row
           // print(filterrecommendedFundArr[indexPath.row].is_deleted,"is_deleted")
            
            if !finalDisplayListArr.isEmpty {
                noSchemeView.isHidden = true
                fundListTableView.isHidden = false
                cell.schemeNameLabel.text = finalDisplayListArr[indexPath.row].S_NAME
                cell.amountTf.text = finalDisplayListArr[indexPath.row].amount_value
                
                if finalDisplayListArr[indexPath.row].IsPurchaseAvailable == "Y" && (mode == 1 || mode == 3 ){
                    // $pick_logic['pick_logic']['rec_type'][$data['ASSET_TYPE']] == 1
                    //if finalDisplayListArr[indexPath.row].ASSET_TYPE?.contains(find: rec_type[indexPath.row])
                    if mode == 3 && finalDisplayListArr[indexPath.row].asset_type_value == "1"{
                        cell.lumpsumButtonOutlet.backgroundColor = #colorLiteral(red: 0.5254901961, green: 0.7450980392, blue: 0.231372549, alpha: 1)
                        cell.lumpsumButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                        cell.lumpsumButtonOutlet.borderWidth = 0
                    }
                    cell.lumpsumButtonOutlet.isHidden = false
                }
                if finalDisplayListArr[indexPath.row].SIP == "T" && (mode == 2 || mode == 3 ) {
                    if mode == 3 && finalDisplayListArr[indexPath.row].asset_type_value == "2"{
                        cell.startSipButtonOutlet.backgroundColor = #colorLiteral(red: 0.5254901961, green: 0.7450980392, blue: 0.231372549, alpha: 1)
                        cell.startSipButtonOutlet.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
                        cell.startSipButtonOutlet.borderWidth = 0
                    }
                    cell.startSipButtonOutlet.isHidden = false
                }
                if finalDisplayListArr[indexPath.row].isSelected == true {
                    let checked = UIImage(named: "check-blue")
                    cell.fundCheckButtonOutlet.setImage(checked, for: .normal)
                } else  {
                    let image1 = UIImage(named: "square")
                    cell.fundCheckButtonOutlet.setImage(image1, for: .normal)
                }
                let cobj_scode = cartObjects.map  { $0.SCHEMECODE}
                if cobj_scode.contains(finalDisplayListArr[indexPath.row].SCHEMECODE!){
                    cell.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                    cell.mainCellView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                    cell.navView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                }else {
                    cell.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    cell.mainCellView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    cell.navView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                }
                if finalDisplayListArr[indexPath.row].addedtocart_flag {
                    cell.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                    cell.mainCellView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                    cell.navView.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)
                    
                }
                
                //recommendedFundLabel.text = String(finalDisplayListArr.count)
                //let sum4 = finalDisplayListArr.reduce(0) { $0 + Int($1.amount_value ?? "0")! }
                let sum = finalDisplayListArr.reduce(0) { $0 + Double($1.amount_value ?? "0")! }
                //targetAmountLabel.text = String(sum4)
                let val = (Double(cell.amountTf.text ?? "0")! * 100) / sum
                cell.assetAllocationLabel.text = String(val).decimalString
            } else {
                fundListTableView.isHidden = true
                noSchemeView.isHidden = false
            }

            cell.delegate = self
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == addFundTableView {
            searchTf.text = filterSearchArr[indexPath.row].p_name
            slectedSearchIndex = filterSearchArr[indexPath.row].Scheme_code
            index_of_selected_fund = indexPath.row
            self.heightConstraintsOfSearchView.constant = 110
            searchTf.resignFirstResponder()
            
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == addFundTableView {
            return 50
        } else {
           return 130
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let index = IndexPath(row: textField.tag, section: 0)
        print(index)
        
        let cell = fundListTableView.cellForRow(at: index) as? recommendedCell
        
        if textField == cell?.amountTf{
           // divided_flag = true
            
            for (index1, _) in self.finalDisplayListArr.enumerated() {
                
                
                if index1 == textField.tag {
                    if cell?.amountTf.text != "" {
                         finalDisplayListArr[index1].amount_value = cell?.amountTf.text
                    }else {
                         finalDisplayListArr[index1].amount_value = "0"
                    }
                   
                    //updated_amount_arr[index1] = (cell?.amountTf.text)!
                } else {
                   // updated_amount_arr[index1] = updated_amount_arr[index1]
                }
            }
            
        }
        fundListTableView.reloadData()
    }
    @IBAction func resetButtonClicked(_ sender: Any) {
        updated_amount_arr.removeAll()
        selectAllButtonOutlet.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        slectedSearchIndex = ""
        updated_amount_arr = divided_amount_arr
        if self.mode == 1{
            reminder = Int(self.invest_value)!/5000
        } else {
            reminder = Int(self.invest_value)!/12000
        }
       // fundListTableView.reloadData()
        get_pick_logic(id:1)
        getCartData()
        //self.cart_count()
    }
    @IBAction func addSelectedFund(_ sender: Any) {
        self.selectAllButtonOutlet.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        var amount_details_flag=true
        for i in 0..<finalDisplayListArr.count{
            let index = IndexPath(row: i, section: 0)
            let cell = fundListTableView.cellForRow(at: index) as? recommendedCell
            if cell != nil{
                if finalDisplayListArr[i].amount_value == ""  {
                    amount_details_flag = false
                    presentWindow.makeToast(message: "Please Enter Amount")
                    break
                } else if finalDisplayListArr[i].amount_value == "0"{
                    amount_details_flag = false
                    presentWindow.makeToast(message: "Please Enter Amount")
                    break
                
                }
            }else{
                
                print("sssss")
            }
            
        }
       
        if amount_details_flag {
            for i in 0..<finalDisplayListArr.count{
                print("")
                let index = IndexPath(row: i, section: 0)
                let cell = fundListTableView.cellForRow(at: index) as? recommendedCell
                if finalDisplayListArr[i].isSelected {
                   // print(cell!.amountTf.text!,"cell  value")
                   
                    
                        let index = IndexPath(row: i, section: 0)
                        let cell = fundListTableView.cellForRow(at: index) as? recommendedCell

                            if mode == 2 {
                                SIP_Strat_date(scheme_code: finalDisplayListArr[i].SCHEMECODE!, row: i)
                            } else if mode == 1 {
                                lumpsum_addToCart(row: i,amount:finalDisplayListArr[i].amount_value!)
                            }else {
                                SIP_Strat_date(scheme_code: finalDisplayListArr[i].SCHEMECODE!, row: i)
                           }
                    
                } else{
                    //presentWindow.makeToast(message: "Please Select The Fund")
                    print("%%%%%")
                   
                }
            }
            
//            if nofunselectedflag == 1 {
//                presentWindow.makeToast(message: "Please Select The Fund")
//            }
            var select_count = 0
            for i in 0..<finalDisplayListArr.count{
                if finalDisplayListArr[i].isSelected == true{
                    select_count += 1
                }
            }
            if select_count == 0 {
                 presentWindow.makeToast(message: "Please Select The Fund")
            }
        } else {
            print("$$$$$")
        }
    }
    
    @IBAction func selectAllButton(_ sender: UIButton) {
        
        if sender.currentImage ==  #imageLiteral(resourceName: "square"){
            for i in 0..<finalDisplayListArr.count{
                self.finalDisplayListArr[i].isSelected = true
            }
            sender.setImage(#imageLiteral(resourceName: "check-blue"), for: .normal)
        }else {
            for i in 0..<finalDisplayListArr.count{
                self.finalDisplayListArr[i].isSelected = false
            }
            sender.setImage(#imageLiteral(resourceName: "square"), for: .normal)
        }
        
        fundListTableView.reloadData()
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.alphaView.isHidden = true
    }
    @IBAction func addMoreFundButton(_ sender: Any) {
        self.searchTf.text = ""
        //addsearchfund()
        getFirstPage()
       // self.view.alpha = 0.3
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        slectedSearchIndex = ""
        if searchTf.text!.count > 2 {
             self.addFundTableView.isHidden = false
            self.heightConstraintsOfSearchView.constant = 250
            self.filterSearchArr = self.productArr.filter { $0.p_name!.lowercased().contains(searchTf.text!.lowercased()) }
            DispatchQueue.main.async {
                //self.a.isHidden = false
                self.addFundTableView.reloadData()
            }
        } else {
            self.filterSearchArr.removeAll()
            if searchTf.text!.count == 0{
                self.slectedSearchIndex = ""
                self.searchTf.resignFirstResponder()
            }
            DispatchQueue.main.async {
                self.addFundTableView.isHidden = true
                self.heightConstraintsOfSearchView.constant = 110
                
            }
        }
    }
    @IBAction func addButton(_ sender: Any) {
        self.searchTf.resignFirstResponder()
         let scode = finalDisplayListArr.map  { $0.SCHEMECODE}
        if scode.contains(slectedSearchIndex) {
            presentWindow.makeToast(message: "This fund already exists in list")
        }else {
            if slectedSearchIndex != "" {
                let alert = UIAlertController(title: "Alert", message: "Are you sure you want to add this?", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
                   // self.present(alert, animated: true, completion: nil)
                    self.get_pick_logic(id:2)
                    self.alphaView.isHidden = true
                }))
                alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { action in
                  //  Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Delete Item No Button Clicked")
                }))
               self.present(alert, animated: true, completion: nil)
            }else{
                self.searchTf.resignFirstResponder()
                self.presentWindow.makeToast(message: "Fund Not Found")
            }
        }
    }
    
}
//#MARK: API Calls
extension RecommendedFundsViewController{
    func getFirstPage(){
        self.presentWindow.makeToastActivity(message: "Loading..")
        let parameters = ["page": "", "per_page": 10,"fundoptionarray": "","modearray":"","assetarray":"","catarray":"","fundhousearray":"","risklevelarray":"","mininvestmentarray":"","mininv_for":"","srch":"","enc_resp" : "3","limit_type":"1"] as [String : Any]
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.PRODUCT_LIST)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                    }
                    let data = dict
                    if !data.isEmpty {
                        //self.presentWindow.hideToastActivity()
                        for a in data{
                            let p_name = a["S_NAME"] as? String ?? ""
                            let p_rating = a["scheme_rating_value"] as? String ?? "0"
                            let p_NAV = a["NAVRS"] as? String ?? ""
                            let p_SIP = a["SIP"] as? String ?? ""
                            let p_lumpsum_Min = a["MININVT"] as? String ?? ""
                            let p_lumpsum_Max = a["SIPMININVT"] as? String ?? ""
                            let p_SIP_Min = a["SIPMININVT"] as? String ?? ""
                            let p_SIP_Max = a["SIPMININVT"] as? String ?? ""
                            let p_OPT_Code = a["OPT_CODE"] as? String ?? ""
                            let p_SCHEMECODE =  a["SCHEMECODE"] as? String ?? ""
                            let p_sipfreq = a["sipfreq"] as? String ?? ""
                            let p_allsipamounts =  a["allsipamounts"] as? String ?? ""
                            let MAXINVT = a["MAXINVT"] as? String ?? ""
                            let IsPurchaseAvailable = a["IsPurchaseAvailable"] as? String ?? ""
                            let bseschemetype = a["bseschemetype"] as? String ?? ""
                            let totalcount = a["totalcount"] as? String ?? ""
                            let product_obj = ProductObj(p_name: p_name, p_rating: Int(p_rating)!, p_nav: p_NAV, SIP: p_SIP, lumpsum_Min: p_lumpsum_Min, lumpsum_Max: p_lumpsum_Max, SIP_Min: p_SIP_Min, SIP_Max: p_SIP_Max, OPT_Code: p_OPT_Code, Scheme_code: p_SCHEMECODE, sipfreq:p_sipfreq , allsipamounts:  p_allsipamounts, offset: self.currentOffset, MAXINVT: MAXINVT,IsPurchaseAvailable:IsPurchaseAvailable, isSelected: false,bseschemetype:bseschemetype,totalcount:totalcount)
                            self.productArr.append(product_obj)
                        }
                        self.presentWindow.hideToastActivity()
                        self.alphaView.isHidden = false
                        self.selectAllButtonOutlet.isHidden = false
                        self.addFundTableView.reloadData()
                    } else{
                        self.presentWindow?.hideToastActivity()
                        
                    }
            }
        } else{
            self.presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func addsearchfund(){
        self.presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)schemedata/schemedata_ws.php/searchfund?asset=equity").responseJSON
                { response in
                let data = response.result.value as? [[String:Any]] ?? [[:]]
                if !data.isEmpty {
                    for a in data{
                        let id = a["id"] as? String ?? ""
                        let value = a["value"] as? String ?? ""
                        let obj = addRecommendFundObj(id: id, value: value)
                        self.addSearchFundArr.append(obj)
                    }
                    self.presentWindow.hideToastActivity()
                    self.alphaView.isHidden = false
                    self.addFundTableView.reloadData()
                } else {
                    self.presentWindow.hideToastActivity()
                }
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getCartData() {
        var userid = UserDefaults.standard.value(forKey: "userid") as! String
        if flag != "0"{
            userid = flag
        } else{
            userid = UserDefaults.standard.value(forKey: "userid") as! String
        }
        //
        let url = "\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid)"
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetCartData)\(userid.covertToBase64())/3").responseString { response in
                let enc_response = response.result.value
                print(enc_response)
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                // print(enc1)
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                    // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                }
                //print(response.result.value ?? "cart detail")
                let data = dict
                
                //let data = response.result.value
                if data != nil {
                    //self.presentWindow.hideToastActivity()
                    if let response = data as? [[String: AnyObject]] {
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
                            let cart_mst_id = cartItem["cart_mst_id"] as? String ?? ""
                            let cart_mst_session_id = cartItem["cart_mst_session_id"] as? String ?? ""
                            
                            let mode = cartItem["cart_purchase_type"] as? String ?? ""
                            let cart_purchase_type = self.tempArr[Int(mode) ?? 0]
                            
                            let cart_scheme_code = cartItem["cart_scheme_code"] as? String ?? ""
                            
                            let originalDate = cartItem["cart_sip_start_date"] as? String ?? ""
                            let CLASSCODE = cartItem["CLASSCODE"] as? String ?? ""
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
                            let transaction_id = cartItem["transaction_id"] as? String ?? ""
                            let AMC_CODE = cartItem["AMC_CODE"] as? String ?? ""
                            let cartObj = CartObject(MAXINVT: MAXINVT, MININVT: MININVT, SCHEMECODE: SCHEMECODE, SIPMININVT: SIPMININVT, S_NAME: S_NAME, cart_added: cart_added, cart_amount: cart_amount, cart_folio_no: cart_folio_no, cart_frequency: cart_frequency, cart_id: cart_id, cart_mst_id: cart_mst_id, cart_mst_session_id: cart_mst_session_id, cart_purchase_type: cart_purchase_type, cart_scheme_code: cart_scheme_code, cart_sip_start_date: cart_sip_start_date, cart_tenure: cart_tenure, cart_tenure_perpetual: cart_tenure_perpetual, multiples: multiples, transaction_bank_id: transaction_bank_id, transaction_id: transaction_id,cart_sip_start_date1: originalDate, mode: mode, is_save: false, AMC_CODE: AMC_CODE, CLASSCODE: CLASSCODE, nominee: nil)
                            self.cartObjects.append(cartObj)
                        }
                        self.fundListTableView.reloadData()
                    }
                }
                
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func get_pick_logic(id:Int){
        DispatchQueue.main.async {
            self.presentWindow.makeToastActivity(message: "Loading..")
        }
        var userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        if flag != "0"{
            userid = flag
        } else{
            userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        }
        let url = "\(Constants.BASE_URL)\(Constants.API.get_pick_logic)"
        let parameters = ["user_id":"\(userid)"] as [String : Any]
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                   // self.presentWindow.hideToastActivity()
                    let data = response.result.value as? [String:Any]
                    print(data ?? "")
                    if data != nil {
                        if !data!.isEmpty {
                            //self.getPickInvestList(data: data ?? [:])
                            self.getAssetType(data:data ?? [:],id:id)
                        } else{
                            self.presentWindow.hideToastActivity()
                        }
                    }
                    
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getPickInvestList(data : [String:Any],fund_types:[String:Any],amount:String){
        self.presentWindow.makeToastActivity(message: "Loading...")
        let url = "\(Constants.BASE_URL)\(Constants.API.getPickInvestList)"
        let pick_logic = data["pick_logic"] as? [String:Any]
        let priority = pick_logic!["priority"] as? String ?? ""
        let priority_arr = priority.split(separator: ",")
        let rec_type = pick_logic?["rec_type"] as? [String:Any] ??  [:]
        rec_type_arr = rec_type
        parameters["pick_logic"] = data
        parameters["fund_types"] = fund_types
        if slectedSearchIndex !=  ""{
            parameters["searchedFund"] = ["\(slectedSearchIndex)"]
            
        } else {
            parameters.removeValue(forKey: "searchedFund")
            recommendedFundArr.removeAll()
            self.filterrecommendedFundArr.removeAll()
            self.finalDisplayListArr.removeAll()
            self.divided_amount_arr.removeAll()
            self.updated_amount_arr.removeAll()
        }
        print(parameters)
        if Connectivity.isConnectedToInternet {
            Alamofire.request(url, method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                    
                    let data = response.result.value as? [[String:Any]] ?? [[:]]
                    if !data.isEmpty {
                        for a in data{
                            let CLASSCODE = a["CLASSCODE"] as? String ?? ""
                            let ASSET_TYPE = a["ASSET_TYPE"] as? String ?? ""
                            let S_NAME = a["S_NAME"] as? String ?? ""
                            let SCHEMECODE = a["SCHEMECODE"] as? String ?? ""
                            let NAVRS = a["NAVRS"] as? String ?? ""
                            let scheme_rating_value = a["scheme_rating_value"] as? String ?? ""
                            let firstyear = a["firstyear"] as? String ?? ""
                            let thirdyear = a["thirdyear"] as? String ?? ""
                            let fifthyear = a["fifthyear"] as? String ?? ""
                            let SIP = a["SIP"] as? String ?? ""
                            let PRIMARY_FUND = a["PRIMARY_FUND"] as? String ?? ""
                            let scheme_most_popular = a["scheme_most_popular"] as? String ?? ""
                            let scheme_recommended = a["scheme_recommended"] as? String ?? ""
                            let scheme_best_seller = a["scheme_best_seller"] as? String ?? ""
                            let MININVT = a["MININVT"] as? String ?? ""
                            let SIPMININVT = a["SIPMININVT"] as? String ?? ""
                            let allsipamounts = a["allsipamounts"] as? String ?? ""
                            let sipfreq = a["sipfreq"] as? String ?? ""
                            let OPT_CODE = a["OPT_CODE"] as? String ?? ""
                            let MAXINVT = a["MAXINVT"] as? String ?? ""
                            let multiples = a["multiples"] as? String ?? ""
                            let IsPurchaseAvailable = a["IsPurchaseAvailable"] as? String ?? ""
                            let searchedFund = a["searchedFund"] as? String ?? ""
                            let bseschemename = a["bseschemename"] as? String ?? ""
                            let Dividendoptionflag = a["Dividendoptionflag"] as? String ?? ""
                            let bseschemetype = a["bseschemetype"] as? String ?? ""
                            let recommendedObj = recommendedFundObj(CLASSCODE: CLASSCODE, ASSET_TYPE: ASSET_TYPE, S_NAME: S_NAME, SCHEMECODE: SCHEMECODE, NAVRS: NAVRS, scheme_rating_value: scheme_rating_value, firstyear: firstyear, thirdyear: thirdyear, fifthyear: fifthyear, SIP: SIP, PRIMARY_FUND: PRIMARY_FUND, scheme_most_popular: scheme_most_popular, scheme_recommended: scheme_recommended, scheme_best_seller: scheme_best_seller, MININVT: MININVT, SIPMININVT: SIPMININVT, allsipamounts: allsipamounts, sipfreq: sipfreq, OPT_CODE: OPT_CODE, MAXINVT: MAXINVT, multiples: multiples, IsPurchaseAvailable: IsPurchaseAvailable, searchedFund: searchedFund,bseschemename: bseschemename,Dividendoptionflag:Dividendoptionflag,bseschemetype:bseschemetype, divided_amount: "", isSelected: false,asset_type_value:"0", amount_value: amount,addedtocart_flag:false)
                            if self.slectedSearchIndex ==  ""{
                                self.recommendedFundArr.append(recommendedObj)
                            } else {
                                self.finalDisplayListArr.append(recommendedObj)
                            }
                            
                        }
                        print(priority_arr)
                        var amount1 = 0
                        if self.mode == 1{
                            amount1 = 5000
                        } else {
                            amount1 = 12000
                        }
                        if self.slectedSearchIndex !=  ""{
                            self.updated_amount_arr.append(String(12000))
                            self.presentWindow.hideToastActivity()
                            self.fundListTableView.reloadData()
                        } else {
                        let abc = Int(self.invest_value)!/amount1
                        let priority_use = abc < self.recommendedFundArr.count ? true : false
                        if !priority_use {
                            self.finalDisplayListArr = self.recommendedFundArr
                            self.presentWindow.hideToastActivity()
                            self.fundListTableView.reloadData()
                            self.divided_amount =  Int(self.invest_value)!/self.finalDisplayListArr.count
                            if amount == "" {
                                for i in 0..<self.finalDisplayListArr.count {
                                    self.divided_amount_arr.append(String(self.divided_amount))
                                    self.updated_amount_arr.append(String(self.divided_amount))
                                    self.finalDisplayListArr[i].amount_value = String(self.divided_amount)
                                    
                                }
                                for (index, _) in self.finalDisplayListArr.enumerated() {
                                    for (index1, _) in self.rec_type_arr.enumerated() {
                                        if self.rec_type_arr.keys.contains(self.finalDisplayListArr[index].ASSET_TYPE ?? ""){
                                            self.finalDisplayListArr[index].asset_type_value = self.rec_type_arr[self.finalDisplayListArr[index].ASSET_TYPE!] as? String ?? "0"
                                        }
                                    }
                                }
                            }else {
                                self.updated_amount_arr.append(String(12000))
                            }
                        }else {
                            for (index, _) in priority_arr.enumerated() {
                                if priority_arr[index].contains("H"){
                                    self.common_list_arr = self.common_list_arr + self.FundSubtype_H
                                } else if priority_arr[index].contains("LC"){
                                    self.common_list_arr = self.common_list_arr + self.FundSubtype_LC
                                } else if priority_arr[index].contains("MC"){
                                    self.common_list_arr = self.common_list_arr + self.FundSubtype_MC
                                } else if priority_arr[index].contains("SC"){
                                    self.common_list_arr = self.common_list_arr + self.FundSubtype_SC
                                } else if priority_arr[index].contains("LT"){
                                    self.common_list_arr = self.common_list_arr + self.FundSubtype_LT
                                } else if priority_arr[index].contains("MT"){
                                   self.common_list_arr = self.common_list_arr + self.FundSubtype_MT
                                } else if priority_arr[index].contains("ST"){
                                    self.common_list_arr = self.common_list_arr + self.FundSubtype_ST
                                }
                            }
                            print(self.common_list_arr)
                            let uniqueStrings = self.uniqueElementsFrom(array:self.common_list_arr)
                            print(uniqueStrings)
                            for (index1, _) in self.recommendedFundArr.enumerated() {
                                print(self.reminder,"reminder count",index1)
                                for (index, element) in uniqueStrings.enumerated() {
                                    //print(index)
                                    
                                    if uniqueStrings[index] == self.recommendedFundArr[index1].CLASSCODE {
                                        let recommendedObj = recommendedFundObj(CLASSCODE: self.recommendedFundArr[index1].CLASSCODE ?? "", ASSET_TYPE: self.recommendedFundArr[index1].ASSET_TYPE ??  "", S_NAME: self.recommendedFundArr[index1].S_NAME ?? "", SCHEMECODE: self.recommendedFundArr[index1].SCHEMECODE ?? "", NAVRS: self.recommendedFundArr[index1].NAVRS ?? "", scheme_rating_value: self.recommendedFundArr[index1].scheme_rating_value  ?? "", firstyear: self.recommendedFundArr[index1].firstyear ?? "", thirdyear: self.recommendedFundArr[index1].thirdyear ?? "", fifthyear: self.recommendedFundArr[index1].fifthyear ?? "", SIP: self.recommendedFundArr[index1].SIP ?? "", PRIMARY_FUND: self.recommendedFundArr[index1].PRIMARY_FUND ?? "", scheme_most_popular: self.recommendedFundArr[index1].scheme_most_popular ?? "", scheme_recommended: self.recommendedFundArr[index1].scheme_recommended ?? "", scheme_best_seller: self.recommendedFundArr[index1].scheme_best_seller ?? "", MININVT: self.recommendedFundArr[index1].MININVT ?? "", SIPMININVT: self.recommendedFundArr[index1].SIPMININVT ?? "", allsipamounts: self.recommendedFundArr[index1].allsipamounts ?? "", sipfreq: self.recommendedFundArr[index1].sipfreq ?? "", OPT_CODE: self.recommendedFundArr[index1].OPT_CODE ?? "", MAXINVT: self.recommendedFundArr[index1].MAXINVT ?? "", multiples: self.recommendedFundArr[index1].multiples ?? "",IsPurchaseAvailable: self.recommendedFundArr[index1].IsPurchaseAvailable ?? "", searchedFund: self.recommendedFundArr[index1].searchedFund ?? "",bseschemename: self.recommendedFundArr[index1].bseschemename ?? "",Dividendoptionflag:self.recommendedFundArr[index1].Dividendoptionflag ?? "",bseschemetype:self.recommendedFundArr[index1].bseschemetype ?? "", divided_amount: "0", isSelected: false,asset_type_value:"0", amount_value: self.recommendedFundArr[index1].amount_value ?? "",addedtocart_flag:false)
                                            self.filterrecommendedFundArr.append(recommendedObj)
                                    }
                                }
                            }
                            if self.reminder <= 5{
                                //print(self.reminder,"reminder count",index1)
                                for index1 in 0..<self.filterrecommendedFundArr.count {
                                    let recommendedObj = recommendedFundObj(CLASSCODE: self.filterrecommendedFundArr[index1].CLASSCODE ?? "", ASSET_TYPE: self.filterrecommendedFundArr[index1].ASSET_TYPE ??  "", S_NAME: self.filterrecommendedFundArr[index1].S_NAME ?? "", SCHEMECODE: self.filterrecommendedFundArr[index1].SCHEMECODE ?? "", NAVRS: self.filterrecommendedFundArr[index1].NAVRS ?? "", scheme_rating_value: self.filterrecommendedFundArr[index1].scheme_rating_value  ?? "", firstyear: self.filterrecommendedFundArr[index1].firstyear ?? "", thirdyear: self.filterrecommendedFundArr[index1].thirdyear ?? "", fifthyear: self.filterrecommendedFundArr[index1].fifthyear ?? "", SIP: self.filterrecommendedFundArr[index1].SIP ?? "", PRIMARY_FUND: self.filterrecommendedFundArr[index1].PRIMARY_FUND ?? "", scheme_most_popular: self.filterrecommendedFundArr[index1].scheme_most_popular ?? "", scheme_recommended: self.filterrecommendedFundArr[index1].scheme_recommended ?? "", scheme_best_seller: self.filterrecommendedFundArr[index1].scheme_best_seller ?? "", MININVT: self.filterrecommendedFundArr[index1].MININVT ?? "", SIPMININVT: self.filterrecommendedFundArr[index1].SIPMININVT ?? "", allsipamounts: self.filterrecommendedFundArr[index1].allsipamounts ?? "", sipfreq: self.filterrecommendedFundArr[index1].sipfreq ?? "", OPT_CODE: self.filterrecommendedFundArr[index1].OPT_CODE ?? "", MAXINVT: self.filterrecommendedFundArr[index1].MAXINVT ?? "", multiples: self.filterrecommendedFundArr[index1].multiples ?? "",IsPurchaseAvailable: self.filterrecommendedFundArr[index1].IsPurchaseAvailable ?? "", searchedFund: self.filterrecommendedFundArr[index1].searchedFund ?? "",bseschemename: self.filterrecommendedFundArr[index1].bseschemename ?? "",Dividendoptionflag:self.filterrecommendedFundArr[index1].Dividendoptionflag ?? "",bseschemetype:self.filterrecommendedFundArr[index1].bseschemetype ?? "", divided_amount: "0", isSelected: false,asset_type_value:"0",amount_value: self.recommendedFundArr[index1].amount_value ?? "",addedtocart_flag:false)
                                    self.finalDisplayListArr.append(recommendedObj)
                                }
                            } else {
                                for index1 in 0..<self.filterrecommendedFundArr.count {
                                    let recommendedObj = recommendedFundObj(CLASSCODE: self.filterrecommendedFundArr[index1].CLASSCODE ?? "", ASSET_TYPE: self.filterrecommendedFundArr[index1].ASSET_TYPE ??  "", S_NAME: self.filterrecommendedFundArr[index1].S_NAME ?? "", SCHEMECODE: self.filterrecommendedFundArr[index1].SCHEMECODE ?? "", NAVRS: self.filterrecommendedFundArr[index1].NAVRS ?? "", scheme_rating_value: self.filterrecommendedFundArr[index1].scheme_rating_value  ?? "", firstyear: self.filterrecommendedFundArr[index1].firstyear ?? "", thirdyear: self.filterrecommendedFundArr[index1].thirdyear ?? "", fifthyear: self.filterrecommendedFundArr[index1].fifthyear ?? "", SIP: self.filterrecommendedFundArr[index1].SIP ?? "", PRIMARY_FUND: self.filterrecommendedFundArr[index1].PRIMARY_FUND ?? "", scheme_most_popular: self.filterrecommendedFundArr[index1].scheme_most_popular ?? "", scheme_recommended: self.filterrecommendedFundArr[index1].scheme_recommended ?? "", scheme_best_seller: self.filterrecommendedFundArr[index1].scheme_best_seller ?? "", MININVT: self.filterrecommendedFundArr[index1].MININVT ?? "", SIPMININVT: self.filterrecommendedFundArr[index1].SIPMININVT ?? "", allsipamounts: self.filterrecommendedFundArr[index1].allsipamounts ?? "", sipfreq: self.filterrecommendedFundArr[index1].sipfreq ?? "", OPT_CODE: self.filterrecommendedFundArr[index1].OPT_CODE ?? "", MAXINVT: self.filterrecommendedFundArr[index1].MAXINVT ?? "", multiples: self.filterrecommendedFundArr[index1].multiples ?? "",IsPurchaseAvailable: self.filterrecommendedFundArr[index1].IsPurchaseAvailable ?? "", searchedFund: self.filterrecommendedFundArr[index1].searchedFund ?? "",bseschemename: self.filterrecommendedFundArr[index1].bseschemename ?? "",Dividendoptionflag:self.filterrecommendedFundArr[index1].Dividendoptionflag ?? "",bseschemetype:self.filterrecommendedFundArr[index1].bseschemetype ?? "", divided_amount: "0", isSelected: false,asset_type_value:"0", amount_value: self.recommendedFundArr[index1].amount_value ?? "",addedtocart_flag:false)
                                    self.finalDisplayListArr.append(recommendedObj)
                                }
                            }
                            for (index, _) in self.finalDisplayListArr.enumerated() {
                                for (index1, _) in self.rec_type_arr.enumerated() {
                                    if self.rec_type_arr.keys.contains(self.finalDisplayListArr[index].ASSET_TYPE ?? ""){
                                        self.finalDisplayListArr[index].asset_type_value = self.rec_type_arr[self.finalDisplayListArr[index].ASSET_TYPE!] as? String ?? "0"
                                    }
                                }
                            }
                            self.presentWindow.hideToastActivity()
                            self.fundListTableView.reloadData()
                            
                           // self.recommendedFundLabel.text = "\(self.filterrecommendedFundArr.count)"
                            self.divided_amount =  Int(self.invest_value)!/self.finalDisplayListArr.count
                            for i in 0..<self.finalDisplayListArr.count {
                                self.divided_amount_arr.append(String(self.divided_amount))
                                self.updated_amount_arr.append(String(self.divided_amount))
                                self.finalDisplayListArr[i].amount_value = String(self.divided_amount)
                            }
                            if amount != ""{
                                self.updated_amount_arr.append(String(12000))
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
    func getAssetType(data:[String:Any],id:Int){
        if filterList.count > 0 {
        if filterList[FilterType.ASSETTYPE].subCategory.count == 0{
           // presentWindow?.makeToastActivity(message: "Loading")
            if Connectivity.isConnectedToInternet{
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetAssetType)/3").responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc  = enc1?.base64Decoded()
                    let dict = self.convertToDictionary(text: enc!)
                    // if let data = response.result.value as? [AnyObject]{
                    var demo_obj = [String:Any]()
                    if let data = dict as? [AnyObject]{
                        for type in data{
                            if let subCategoryName = type.value(forKey: "ASSET_TYPE") as? String,
                                let subCategoryId = type.value(forKey: "ASSET_CODE") as? String{
                                //self.presentWindow.hideToastActivity()
                                demo_obj.updateValue(subCategoryId, forKey: subCategoryName)
                            }
                        }
                        
                    }
                    if id == 1 {
                        self.getPickInvestList(data: data,fund_types: demo_obj,amount:"")
                    }else {
                        self.getPickInvestList(data: data,fund_types: demo_obj,amount:"12000")
                        
                    }
                }
            }
            else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }else{
            presentWindow.hideToastActivity()
        }
        }else{
            
            presentWindow.hideToastActivity()
        }
    }
    func uniqueElementsFrom(array: [String]) -> [String] {
        //Create an empty Set to track unique items
        var set = Set<String>()
        let result = array.filter {
            guard !set.contains($0) else {
                //If the set already contains this object, return false
                //so we skip it
                return false
            }
            //Add this item to the set since it will now be in the array
            set.insert($0)
            //Return true so that filtered array will contain this item.
            return true
        }
        return result
    }
    func buySip(row: Int){
       // Mixpanel.mainInstance().track(event: "Invest Screen :- Start SIP Button Clicked")
        let productobj = finalDisplayListArr[row]
        let cell: recommendedCell = fundListTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! recommendedCell
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "StartSIPViewController") as! StartSIPViewController
        let amt = productobj.amount_value ?? ""
        let c_amt = (Int(amt)! * Int(year)!) / (Int(year)! * 12)
        destVC.p_name = cell.schemeNameLabel.text
        destVC.c_nav =  productobj.NAVRS
        destVC.OPT_code = productobj.OPT_CODE!
        destVC.row = row
        destVC.bseschemetype = productobj.bseschemetype
        destVC.Scheme_code = productobj.SCHEMECODE!
        destVC.sipfreqs = productobj.sipfreq!
        destVC.allsipamounts1 = productobj.allsipamounts
        destVC.MAXINVT = productobj.MAXINVT
        destVC.year = year
        destVC.goal = String(c_amt)
        navigationController?.pushViewController(destVC, animated: true)
    }
    func buyLumpsum(row: Int) {
        print("lumpsum butoon clicked")
        let productobj = finalDisplayListArr[row]
        let cell: recommendedCell = fundListTableView.cellForRow(at: IndexPath(row: row, section: 0)) as! recommendedCell
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "lumpsumViewController") as! lumpsumViewController
        destVC.p_name = productobj.S_NAME
        destVC.C_NAV =  productobj.NAVRS
        destVC.OPT_code = productobj.OPT_CODE
        destVC.row = row
        destVC.goal = productobj.amount_value ?? ""
        destVC.bseschemetype = productobj.bseschemetype
        destVC.min_amount = productobj.MININVT
        destVC.schemecode = productobj.SCHEMECODE
        navigationController?.pushViewController(destVC, animated: true)
    }
    func navigate(row: Int) {
        let productobj = finalDisplayListArr[row]
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "ProductDetailInfoViewController") as! ProductDetailInfoViewController
        destVC.Scheme_code = productobj.SCHEMECODE
        destVC.Scheme_name = productobj.S_NAME
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func CheckUncheckFund(row: Int) {
        let fundObj = self.finalDisplayListArr[row]
        if !fundObj.isSelected {
            fundObj.isSelected = true
        } else {
            
            selectAllButtonOutlet.setImage(#imageLiteral(resourceName: "square"), for: .normal)
            fundObj.isSelected = false
        }
        
        fundListTableView.reloadData()
    }
    func removeFundObject(fundObjIndex: Int) {
        let alert = UIAlertController(title: "Alert", message: "Are you sure you want to delete this?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: { action in
            self.updated_amount_arr.remove(at: fundObjIndex)
            self.finalDisplayListArr.remove(at: fundObjIndex)
            if self.finalDisplayListArr.isEmpty{
                self.noSchemeView.isHidden = false
                self.fundListTableView.isHidden = true
                self.recommendedFundLabel.text = "0"
                self.selectAllButtonOutlet.setImage(#imageLiteral(resourceName: "square"), for: .normal)
                self.selectAllButtonOutlet.isHidden = true
            }
            self.fundListTableView.reloadData()
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: { action in
            //  Mixpanel.mainInstance().track(event: "Cart Detail Screen :- Delete Item No Button Clicked")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func SIP_add_to_cart(start_date:String,type:String,tenure:String,row :Int){
        let parameters = ["stdate":"\(start_date.covertToBase64())","type":"2","tenure":"\(tenure.covertToBase64())","enc_resp":"3"] as [String : Any]
        print(parameters)
        print("\(Constants.BASE_URL)\(Constants.API.calculatesipdate)")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.calculatesipdate)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    //print(response.value!)
                    print(response.result.value)
                    let enc_response = response.result.value
                    print(enc_response,"response")
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    print(enc1)
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    let data = dict
                    if !data.isEmpty {
                        print(data)
                        for SIP_detail in data as [NSDictionary]{
                            // print(SIP_detail.value(forKey: "end_date"))
                            let SIP_start_date = SIP_detail.value(forKey: "start_date") as? String ?? ""
                            let SIP_end_date = SIP_detail.value(forKey: "end_date") as? String ?? ""
                            let SIP_totalins = SIP_detail.value(forKey: "totalins") as! Int
                            let SIP_remaininginsins = SIP_detail.value(forKey: "remainingins") as! Int
                            let SIP_sip_reg_no = SIP_detail.value(forKey: "sip_reg_no") as! Int
                            print(SIP_sip_reg_no)
                            self.sipCalculationArr.append(SIP_date_calculation.getSIP_date_calculation_ModelInstance(start_date: SIP_start_date, end_date: SIP_end_date, totalins: String(SIP_totalins), remainingins: String(SIP_remaininginsins), sip_reg_no: String(SIP_sip_reg_no)))
                            self.SIP_addtocart(row:row)
                        }
                    }
            }
            
        }
            
        else{
            print("hello")
            
            self.presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func SIP_addtocart(row:Int){
         let fundObj = self.finalDisplayListArr[row]
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        //let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        var perpetual1 = "N"
        var payout = ""
        if year == "60"{
            perpetual1 = "Y"
        }
        // let productobj = productArr[row]
        //print(SIP_sip_reg_no)
        let SIPCalculationobj = sipCalculationArr[0]
        print(SIPCalculationobj.start_date!)
        //print(productobj.Scheme_code)
        let schemecode = fundObj.SCHEMECODE
        let tenure = year
        let amount = fundObj.amount_value
        let type = "2"
        let frequency = "Monthly"
        let sessionid = sessionId
        let perpetual = perpetual1
        let start_date = SIPCalculationobj.start_date
        let end_date = SIPCalculationobj.end_date
        let total_installment = SIPCalculationobj.totalins
        let remaining_installment = SIPCalculationobj.remainingins
        
        //let payout = "invest"
        let invopt = "1"
        let userId = userid
        let sip_reg_no = SIPCalculationobj.sip_reg_no
        let cart_rm_ref_id = ""
        //print(cell.reinvestOutlet.currentTitle)
        //print(cell.SIP_reinvest_stack.isHidden)
        let payoutBool = false
        if fundObj.OPT_CODE == "2"{
            //rint(payoutStack.arrangedSubviews[0].isHidden)
            if payoutBool == true {
                payout = "payout"
            }else{
                payout = "reinvest"
                print(payout)
            }
            
        }
        print(payout)
        //  print(randomString)
        print(schemecode)
        print("\(Constants.BASE_URL)\(Constants.API.addToCart)")
        let parameters = ["id":"\(schemecode!.covertToBase64())","tenure":tenure.covertToBase64(),"amount":amount!.covertToBase64(),"type":type.covertToBase64(),"frequency":frequency.covertToBase64(),"sessionid":sessionid!.covertToBase64(),"perpetual":perpetual.covertToBase64(),"start_date":start_date!.covertToBase64(),"end_date":end_date!.covertToBase64(),"total_installment":total_installment!.covertToBase64(),"remaining_installment":remaining_installment!.covertToBase64(),"payout":invopt.covertToBase64(),"invopt":payout.covertToBase64(),"userid":userId!.covertToBase64(),"sip_reg_no":sip_reg_no!.covertToBase64(),"cart_rm_ref_id":"","enc_resp":"3"] as [String : Any]
        print(parameters,"sip parameters")
        presentWindow.makeToastActivity(message: "Adding.")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addToCart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value)
                    let r1  = response.value
                    let enc1 = r1?.replacingOccurrences(of: "\n" , with: "")
                    let response = enc1?.base64Decoded() ?? ""
                    print(response)
                    if response == "\"true\""{
                        print("true response")
                        self.presentWindow.hideToastActivity()
                       // Mixpanel.mainInstance().track(event: "Start SIP Screen :- Added to cart successfully!")
                        self.presentWindow.makeToast(message: "Added to cart successfully!")
                        fundObj.addedtocart_flag = true
                        fundObj.isSelected = false
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
                 self.fundListTableView.reloadData()
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func SIP_Strat_date(scheme_code:String,row :Int){
        print(scheme_code,"scheme_code")
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.Sip_start_days)\(scheme_code.covertToBase64())/monthly/3").responseString { response in
                let enc_response = response.result.value
                print(enc_response,"response")
                var dict = [Dictionary<String,Any>]()
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                if let enc = enc1?.base64Decoded() {
                    dict = self.convertToDictionary(text: enc)
                } else{
                    self.presentWindow.hideToastActivity()
                    // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                }
                let data = dict
                print(data)
                // if let data = response.result.value as? [AnyObject]{
                print(data.isEmpty)
                if !data.isEmpty{
                    for sip_date in data as! [NSDictionary]{
                        print(sip_date)
                        self.SIP_Start_date.removeAll()
                        for i in 1..<8 {
                            //print(sip_date.value(forKey: "SIPDAYS\(i)"))
                            let sip_days = sip_date.value(forKey: "SIPDAYS\(i)") as? String
                            print(sip_days!,"************")
                            if sip_days! != "0" && sip_days! != "29" && sip_days! != "30" && sip_days! != "31" {
                                print(sip_days)
                                self.SIP_Start_date.append(sip_days!)
                                self.flags = "1"
                            }
                            
                        }
                    }
                }
                
                if data.isEmpty || self.SIP_Start_date.isEmpty{
                    self.SIP_Start_date = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28"]
                }
                if self.flags != "1"{
                    let date = Date()
                    let calendar = NSCalendar.current
                    let day = calendar.component(.day, from: date)
                    var d = 1
                    while(d<=28){
                        
                        if d == day {
                          //  self.SipStartDate.text = "\(d)"
                            print("\(d)")
                          // self.SIP_add_to_cart(start_date: "\(d)", type: "2", tenure: self.year, row: row)
                        }
                        d += 1
                    }
                    self.SIP_add_to_cart(start_date: "\(d)", type: "2", tenure: self.year, row: row)
                }
                
            }
            
        }else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func lumpsum_addToCart(row:Int,amount:String){
        let fundObj = self.finalDisplayListArr[row]
        var userid = UserDefaults.standard.value(forKey: "userid")  as? String
        if flag != "0"{
            userid! = flag
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        let amount = amount
        let type = "1"
        var payout = ""
        let invopt = "1"
        if  fundObj.OPT_CODE == "2"{
                payout = "reinvest"
                print(payout)
            
        }
        let s_date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.string(from: s_date)
        print(date)
        let parameters = ["id":"\(fundObj.SCHEMECODE!.covertToBase64())","amount":amount.covertToBase64(),"type":type.covertToBase64(),"sessionid":sessionId!.covertToBase64(),"payout":invopt.covertToBase64(),"invopt":payout.covertToBase64(),"userid":userid!.covertToBase64(),"start_date":"\(date.covertToBase64())","enc_resp":"3"] as [String : Any]
        print(parameters)
        presentWindow.makeToastActivity(message: "Adding.")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.Add_To_Cart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.result.value!)
                    let r1 = response.result.value
                    let enc1 = r1?.replacingOccurrences(of: "\n" , with: "")
                    let response = enc1?.base64Decoded() ?? ""
                    if response == "\"true\""{
                        print("true response")
                        self.presentWindow.hideToastActivity()
                        self.presentWindow.makeToast(message: "Added to cart successfully!")
                        Mixpanel.mainInstance().track(event: "Buy Lumpsum Screen :- Added to cart successfully!")
                        fundObj.addedtocart_flag = true
                        fundObj.isSelected = false
                        
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
                    self.fundListTableView.reloadData()
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
}
class recommendedCell : UITableViewCell {
     weak var delegate: recommendedCellDelegate?
    
    @IBOutlet weak var mainCellView: UIView!
    @IBOutlet weak var fundDetailButtonOutlet: UIButton!
    @IBOutlet weak var assetAllocationLabel: UILabel!
    @IBOutlet weak var fundCheckButtonOutlet: UIButton!
    @IBOutlet weak var schemeNameLabel: UILabel!
    @IBOutlet weak var startSipButtonOutlet: UIButton!
    @IBOutlet weak var lumpsumButtonOutlet: UIButton!
    @IBOutlet weak var amountTf: UITextField!
    @IBAction func startSip(_ sender: UIButton) {
        delegate?.buySip(row: sender.tag)
    }
    @IBAction func buyLumpsum(_ sender: UIButton) {
       delegate?.buyLumpsum(row:sender.tag)
    }
    @IBAction func removeFund(_ sender: UIButton) {
        delegate?.removeFundObject(fundObjIndex: sender.tag)
    }
    @IBAction func checkBoxClicked(_ sender: UIButton) {
        delegate?.CheckUncheckFund(row: sender.tag)
    }
    @IBOutlet weak var navView: UIView!
    
    @IBOutlet weak var removeFundOutlet: UIButton!
    @IBAction func fundDetailbtn(_ sender: UIButton) {
        print(sender.tag)
        delegate?.navigate(row: sender.tag)
    }
}
protocol recommendedCellDelegate: class {
    func buyLumpsum(row: Int)
    func buySip(row:Int)
    func removeFundObject(fundObjIndex: Int)
    func CheckUncheckFund(row:Int)
    func navigate(row:Int)
}
