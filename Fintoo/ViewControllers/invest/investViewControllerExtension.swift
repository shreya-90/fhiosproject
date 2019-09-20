//
//  investViewControllerExtension.swift
//  Fintoo
//
//  Created by Tabassum Sheliya on 31/05/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import Foundation
import Mixpanel
import Alamofire
import SVProgressHUD
//#MARK: Helper Method
extension investViewController{
    func buyLumpsum(row: Int) {
        Mixpanel.mainInstance().track(event: "Invest Screen :- Buy Lumpsum Button Clicked")
        let productobj = productArr[row]
        let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "lumpsumViewController") as! lumpsumViewController
        destVC.p_name = cell.fundName.text
        destVC.C_NAV =  cell.navLabel.text
        destVC.OPT_code = productobj.OPT_Code!
        destVC.row = row
        destVC.bseschemetype = productobj.bseschemetype
        destVC.min_amount = productobj.lumpsum_Min!
        destVC.schemecode = productobj.Scheme_code
        navigationController?.pushViewController(destVC, animated: true)
    }

    func buySip(row: Int){
        Mixpanel.mainInstance().track(event: "Invest Screen :- Start SIP Button Clicked")
        let productobj = productArr[row]
        let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "StartSIPViewController") as! StartSIPViewController
        destVC.p_name = cell.fundName.text
        destVC.c_nav =  cell.navLabel.text
        destVC.OPT_code = productobj.OPT_Code!
        destVC.row = row
        destVC.bseschemetype = productobj.bseschemetype
        destVC.Scheme_code = productobj.Scheme_code
        destVC.sipfreqs = productobj.sipfreq!
        destVC.allsipamounts1 = productobj.allsipamounts
        destVC.MAXINVT = productobj.MAXINVT

        navigationController?.pushViewController(destVC, animated: true)
    }

    func navigate(row: Int) {
        Mixpanel.mainInstance().track(event: "Invest Screen :- Scheme Info Button Clicked")
        let productobj = productArr[row]
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "ProductDetailInfoViewController") as! ProductDetailInfoViewController
        destVC.Scheme_code = productobj.Scheme_code
        destVC.Scheme_name = productobj.p_name
        self.navigationController?.pushViewController(destVC, animated: true)

    }

    func idReceived(id_received: [String]) {
        if id_received.count == 0 {
            //tableViewTopConstraint.constant = 45.0
        }
        if id_received.count < 3{
            comapreFundCountLabel.text = "\(id_received.count)"
        }
        for (index, element) in productArr.enumerated() {
            if id_received.contains(element.Scheme_code){
                productArr[index].isSelected = true
            } else {
                productArr[index].isSelected = false
            }
        }
         id = id_received
        tableview.reloadData()
    }
}
//#MARK: UITableViewDelegate
extension investViewController  : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if tableView ==  searchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1")
            cell?.textLabel!.text = filterSuggestionArr[indexPath.row].p_name
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.font = UIFont(
                name: "Helvetica Neue",
                size: 14.0)
            return cell!
        }else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as? customCell
        cell?.buylumpsum.tag = indexPath.row
        cell?.sipOutlet.tag = indexPath.row
        cell?.fundDetailbtnOutlet.tag = indexPath.row
        cell?.compareFundCheckBox.tag  = indexPath.row
        if indexPath.row < productArr.count{
            let productobj = productArr[indexPath.row]
            print(id.contains(productArr[indexPath.row].Scheme_code),"containsscode")
            let scode = id.contains(productArr[indexPath.row].Scheme_code)
            if scode == true {
                let checked = UIImage(named: "check-blue")
                cell?.compareFundCheckBox.setImage(checked, for: .normal)
                productobj.isSelected = true
            } else  {
                let image1 = UIImage(named: "square")
                cell?.compareFundCheckBox.setImage(image1, for: .normal)
            }
            cell?.fundName.text = productobj.p_name
            cell?.navLabel.text = productobj.p_nav
            if productobj.IsPurchaseAvailable == "N"{
                cell?.buylumpsum.alpha = 0.5
                cell?.buylumpsum.isEnabled = false
            } else{
                cell?.buylumpsum.alpha = 1.0
                cell?.buylumpsum.isEnabled = true
            }
            if productobj.SIP == "T"{
                cell?.sipOutlet.alpha = 1.0
                cell?.sipOutlet.isEnabled = true
            } else{
                cell?.sipOutlet.alpha = 0.5
                cell?.sipOutlet.isEnabled = false
            }
        }
        if(indexPath.row % 2 == 0) {
            cell?.lumpsumview.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
            cell?.CustomNav.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
            cell?.sipOutlet.borderColor =  UIColor(red: 45/255, green: 180/255, blue: 232/255, alpha: 1)
        } else {
            cell?.sipOutlet.borderColor =  UIColor(red: 45/255, green: 180/255, blue: 232/255, alpha: 1)
            cell?.lumpsumview.backgroundColor = UIColor.white
            cell?.CustomNav.backgroundColor = UIColor.white
        }
        cell?.delegate = self
        return cell!
        }

    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {


            if(indexPath.row % 2 == 0) {
                cell.backgroundColor = UIColor(red: 244/255, green: 244/255, blue: 244/255, alpha: 1)
            } else {
                cell.backgroundColor = UIColor.white
            }
            if tableView == tableview {
                if productArr.count > 9 {
                    if indexPath.row + 1 == productArr.count {
                        self.currentOffset += 10
                        getFirstPage()
                        self.firstTimeLoadFlag = 0
                    }
                }
            }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView{
            txt_searcFund.text = filterSuggestionArr[indexPath.row].p_name
            slectedSearchIndex = filterSuggestionArr[indexPath.row].Scheme_code
            txt_searcFund.resignFirstResponder()
            searchFlag = true
            DispatchQueue.main.async {
                self.searchTableView.isHidden = true
            }
            
           
            self.productArr.removeAll()
            self.count = 0
            self.pageCount = 0
            self.searchTableView.isHidden = true
            //self.searchFlag = true
            self.getFirstPage()
            
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if txt_searcFund.text!.count > 2 {
            self.filterSuggestionArr = self.productArrForSearch.filter { $0.p_name!.lowercased().contains(txt_searcFund.text!.lowercased()) }
            if self.filterSuggestionArr.count == 0 {
                DispatchQueue.main.async {
                    self.searchTableView.isHidden = true
                    self.searchTableView.reloadData()
                }
            }else{
                DispatchQueue.main.async {
                    self.searchTableView.isHidden = false
                    self.searchTableView.reloadData()
                }
            }
        } else {
            DispatchQueue.main.async {
                self.searchTableView.isHidden = true
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        slectedSearchIndex = ""
    }

    func getSchemeListCount() {
        print("get schemelist count called")
//        if Connectivity.isConnectedToInternet {
//
//            let url = "\(Constants.BASE_URL)\(Constants.API.getSchemeListCount)"
//            Alamofire.request(url, method: .post, encoding: JSONEncoding.default)
//                .responseString { response in
//
//                    let resp = response.result.value
//                    let enc1 = resp?.replacingOccurrences(of: "\n" , with: "")
//                    var dict = [Dictionary<String,Any>]()
//                    dict = self.convertToDictionary(text: enc1 ?? "")
//                    let data = dict
//                    if !data.isEmpty {
//                        for a in data {
//                            self.scheme_count = a["cnt"] as? String ?? ""
//                            print(self.scheme_count)
//                        }
//                        if self.scheme_count == "" {
//                            self.scheme_count = "0"
//                        }
//                        self.getFirstPage()
//                    }
//            }
//
//        }
         self.getFirstPage()

    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == searchTableView {
            return 60
        }else{
            if(selectedIndex == indexPath.row) {
                selectedIndex = -1
                return 900
            } else {
                return 130;
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == searchTableView {
            return filterSuggestionArr.count
        }else{
        return productArr.count
        }

    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
}
//#MARK: API Calls
extension investViewController{

//    func showActivityIndicator() {
//        let viewForActivityIndicator = UIView()
//        let view: UIView
//        let loadingTextLabel = UILabel()
//
//        viewForActivityIndicator.frame = CGRect(x: 0.0, y: 0.0, width: 50, height: 50)
//        viewForActivityIndicator.backgroundColor = UIColor.white
//        viewForActivityIndicator.addSubview(viewForActivityIndicator)
//
//        activityIndicatorView.center = CGPoint(x: self.view.frame.size.width / 2.0, y: self.view.frame.size.height / 2.0)
//
//        loadingTextLabel.textColor = UIColor.black
//        loadingTextLabel.text = "LOADING"
//        loadingTextLabel.font = UIFont(name: "Avenir Light", size: 10)
//        loadingTextLabel.sizeToFit()
//        loadingTextLabel.center = CGPoint(x: activityIndicatorView.center.x, y: activityIndicatorView.center.y + 30)
//        viewForActivityIndicator.addSubview(loadingTextLabel)
//
//        activityIndicatorView.hidesWhenStopped = true
//        activityIndicatorView.activityIndicatorViewStyle = .gray
//        viewForActivityIndicator.addSubview(activityIndicatorView)
//        activityIndicatorView.startAnimating()
//    }

    func getFirstPage(){
        
        var search = ""
        
        if searchFlag == true && slectedSearchIndex != ""{
            search = ""
        }else{
            search = txt_searcFund.text!
        }
        
        
        count += 1
        print("recommended \(recommendedSelected),mostpopular \(mostPopularSelected) toprated \(topRatedSelected)")
        let parameters = ["page": count, "per_page": 10,"fundoptionarray": "\(FUND_OPTION)","modearray":"\(MODE)","assetarray":"\(ASSETTYPE)","catarray":"\(CATEGORY)","fundhousearray":"\(FUND_HOUSE)","risklevelarray":"\(RISK_LEVEL)","mininvestmentarray":"\(MIN_INVESTMENT)","mininv_for":mininv_for!,"srch":"\(search)","enc_resp" : "3","recommended":recommendedSelected,"mostpopular":mostPopularSelected,"toprated":topRatedSelected,"schemeidsrch":"\(slectedSearchIndex)"] as [String : Any]

        print(parameters)
        
        var total_count :  String = ""
        total_count = "\(productArr.count)"

        var noOfPages = Int(self.scheme_count) ?? 0
        //print(noOfPages/10.0)
        noOfPages = Int((Double(noOfPages)/10.0).rounded(.up))
        if firstTimeLoadFlag == 1 {
            print("count not increased")
        }else {
            if pageCount <= noOfPages - 1 {
                self.pageCount = self.pageCount + 1
                firstTimeLoadFlag = 0
                print("count is increased")
            }
        }
        if noOfPages != 0 && searchFlag != true{
            presentWindow.makeToastActivity(message: "page \(self.pageCount)/\(noOfPages)")
        }else {
            presentWindow.makeToastActivity(message: "Loading..")
        }
        searchFlag =  false
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.PRODUCT_LIST)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        //SVProgressHUD.dismiss()
                        self.presentWindow.hideToastActivity()
                    }
                    let data = dict
                    if !data.isEmpty {
                        print(data)
                        self.noSchemeView.isHidden = true
                        self.presentWindow.hideToastActivity()
                        //SVProgressHUD.dismiss()
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
                            print(totalcount,"*****")
                            let product_obj = ProductObj(p_name: p_name, p_rating: Int(p_rating)!, p_nav: p_NAV, SIP: p_SIP, lumpsum_Min: p_lumpsum_Min, lumpsum_Max: p_lumpsum_Max, SIP_Min: p_SIP_Min, SIP_Max: p_SIP_Max, OPT_Code: p_OPT_Code, Scheme_code: p_SCHEMECODE, sipfreq:p_sipfreq , allsipamounts:  p_allsipamounts, offset: self.currentOffset, MAXINVT: MAXINVT,IsPurchaseAvailable:IsPurchaseAvailable, isSelected: false,bseschemetype:bseschemetype,totalcount:totalcount)
                            self.productArr.append(product_obj)
                            self.scheme_count = totalcount
                        }

                        self.tableview.isHidden = false
                        self.tableview.reloadData()
                        self.presentWindow?.hideToastActivity()
                        
                    } else{
                        self.presentWindow?.hideToastActivity()
                        if self.productArr.isEmpty{
                            self.noSchemeView.isHidden = false
                        }
                    }
            }
        } else{
            self.presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
         self.txt_searcFund.text = ""
         self.txt_searcFund.resignFirstResponder()
        self.searchTableView.isHidden = true
        self.count = 0
        self.searchFlag = true
        self.productArr.removeAll()
        getFirstPage()
       
       
        return false
    }
    func getAllPages(){
        
        print("recommended \(recommendedSelected),mostpopular \(mostPopularSelected) toprated \(topRatedSelected)")
        let parameters = ["page": "", "per_page": 10,"fundoptionarray": "","modearray":"","assetarray":"","catarray":"","fundhousearray":"","risklevelarray":"","mininvestmentarray":"","mininv_for":"","srch":"","enc_resp" : "3","limit_type":"1"] as [String : Any]
        
        print(parameters)
        
        var total_count :  String = ""
        total_count = "\(productArr.count)"
        
       
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

                            print(totalcount,"*****")
                            let product_obj = ProductObj(p_name: p_name, p_rating: Int(p_rating)!, p_nav: p_NAV, SIP: p_SIP, lumpsum_Min: p_lumpsum_Min, lumpsum_Max: p_lumpsum_Max, SIP_Min: p_SIP_Min, SIP_Max: p_SIP_Max, OPT_Code: p_OPT_Code, Scheme_code: p_SCHEMECODE, sipfreq:p_sipfreq , allsipamounts:  p_allsipamounts, offset: self.currentOffset, MAXINVT: MAXINVT,IsPurchaseAvailable:IsPurchaseAvailable, isSelected: false,bseschemetype:bseschemetype,totalcount:totalcount)
                            self.productArrForSearch.append(product_obj)
                            
                        }
                        
                      
                        
                    } else{
                        self.presentWindow?.hideToastActivity()
                       
                    }
            }
        } else{
            self.presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    func CompareFund(row: Int) {
       // id.removeAll()
        //tableViewTopConstraint.constant = 45.0
        let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
        let productobj = productArr[row]
        id = Array(Set(id))
        for i in 0..<productArr.count{
            if productArr[row].isSelected{
                print(id,"idarr",productArr[row].Scheme_code)
                print(!id.contains(productArr[row].Scheme_code))
                if !id.contains(productArr[row].Scheme_code) {
                    id.append(productArr[row].Scheme_code)
                }
            }
        }
        if id.count < 3  {

            if productobj.isSelected {
                let image1 = UIImage(named: "square")
                cell.compareFundCheckBox.setImage(image1, for: .normal)
                productobj.isSelected = false
                comapreFundCountLabel.text = "\(id.count - 1)"
                if id.count == 1 {
                    compareFundButtonView.isHidden = true
                    tableViewTopConstraint.constant = -43.5
                }
                if let index = id.index(of: productArr[row].Scheme_code) {
                    print(id,index,"remove")
                    id.remove(at: index)
                }
                if id.count - 1 == 0 {
                    tableViewTopConstraint.constant = -43.5
                }
                
                
            }else {
                let checked = UIImage(named: "check-blue")
                tableViewTopConstraint.constant = 0
                compareFundButtonView.isHidden = false
                productobj.isSelected = true
                print(id,"idarrfirsttime",productArr[row].Scheme_code)
                print(!id.contains(productArr[row].Scheme_code))
                if !id.contains(productArr[row].Scheme_code) {
                    id.append(productArr[row].Scheme_code)
                }
                cell.compareFundCheckBox.setImage(checked, for: .normal)
                comapreFundCountLabel.text = "\(id.count)"
                
            }
        }else {
            if productobj.isSelected {
                let image1 = UIImage(named: "square")
                //selected_fund_id.remove(at: row)
                cell.compareFundCheckBox.setImage(image1, for: .normal)
                productobj.isSelected = false
                if let index = id.index(of: productArr[row].Scheme_code) {
                    print(id,index)
                    id.remove(at: index)
                }
                comapreFundCountLabel.text = "\(id.count)"
            } else {
                presentWindow.makeToast(message: "Only three funds can be compared.")
            }
        }

    }
    func cart_count(){
        var userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
        if flag != "0"{
            userid = flag
        } else{
            userid = "\(UserDefaults.standard.value(forKey: "userid")!)"
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
                }
                let data = dict
                if !data.isEmpty {

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
