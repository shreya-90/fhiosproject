//
//  FilterViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 07/03/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel
struct FilterType {
    static let MODE = 0,ASSETTYPE = 1,CATEGORY = 2,
    FUND_OPTION = 3,FUND_HOUSE = 4,RISK_LEVEL = 5,MIN_INVESTMENT = 6
}
 var filterList = [(category: "MODE",subCategory: [SubCategoryModel]()),(category: "ASSET TYPE",subCategory: [SubCategoryModel]()),(category: "CATEGORY",subCategory: [SubCategoryModel]()),(category: "FUND OPTION",subCategory: [SubCategoryModel]()),(category: "FUND HOUSE",subCategory: [SubCategoryModel]()),(category: "RISK LEVEL",subCategory: [SubCategoryModel]()),(category: "MIN INVESTMENT",subCategory: [SubCategoryModel]())]
var modeSubCategoryList = [SubCategoryModel.getFilterListModelInstance(subCategoryName: "SIP", subCategoryId: "2"),SubCategoryModel.getFilterListModelInstance(subCategoryName: "LUMPSUM", subCategoryId: "1")]

var SIP = [Int]()
var Lumpsum = [Int]()
var sip_bool = false
var lumpsum_bool = false
class FilterViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,subCategoryDelegate{
    
    @IBOutlet weak var lumpsum_sip: UIStackView!
    
    @IBOutlet weak var lumpsumOutlet: UIButton!
    var selectedFilterIndex = FilterType.MODE

    @IBOutlet weak var sipoutlet: UIButton!
    
    @IBOutlet weak var FilterList: UITableView!
    @IBOutlet weak var FilterSubList: UITableView!
    var selected_id  = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if filterList.count == 0 {
        filterList = [(category: "MODE",subCategory: [SubCategoryModel]()),(category: "ASSET TYPE",subCategory: [SubCategoryModel]()),(category: "CATEGORY",subCategory: [SubCategoryModel]()),(category: "FUND OPTION",subCategory: [SubCategoryModel]()),(category: "FUND HOUSE",subCategory: [SubCategoryModel]()),(category: "RISK LEVEL",subCategory: [SubCategoryModel]()),(category: "MIN INVESTMENT",subCategory: [SubCategoryModel]())]
        modeSubCategoryList = [SubCategoryModel.getFilterListModelInstance(subCategoryName: "SIP", subCategoryId: "2"),SubCategoryModel.getFilterListModelInstance(subCategoryName: "LUMPSUM", subCategoryId: "1")]
        }
        FilterList.delegate = self
        FilterList.dataSource = self
        FilterList.separatorStyle = UITableViewCellSeparatorStyle.none
        FilterSubList.separatorStyle = UITableViewCellSeparatorStyle.none
        FilterSubList.delegate = self
        FilterSubList.dataSource = self
     
        
        filterList[FilterType.MODE].subCategory = modeSubCategoryList
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        addRightBarButtonItems(items:[crossButton])
        if !Lumpsum.isEmpty{
            lumpsumOutlet.setImage(UIImage(named: "check"), for: UIControlState.normal)
            
        }
        else if !SIP.isEmpty {
            sipoutlet.setImage(UIImage(named: "check"), for: UIControlState.normal)
        }
//        else{
//
//        }
        
     
        }
        

    //}
    
    override func viewWillAppear(_ animated: Bool) {
        lumpsum_sip.arrangedSubviews[0].isHidden = true
        lumpsum_sip.arrangedSubviews[1].isHidden = true
        lumpsum_sip.arrangedSubviews[2].isHidden = true
        let indexPath = IndexPath(row: 0, section: 0)
        FilterList.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        
    }
    
    override func onCrossButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Filter Screen :- Cross Button Clicked.")
        navigationController?.popViewController(animated: true)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == FilterList{
            return filterList.count
        }
        else{
            return filterList[selectedFilterIndex].subCategory.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == FilterList{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.textLabel?.text = filterList[indexPath.row].category
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.textColor = UIColor.white
            cell?.selectionStyle = UITableViewCellSelectionStyle.gray
            let bgColorView = UIView()
            bgColorView.backgroundColor = UIColor.white
            cell?.selectedBackgroundView = bgColorView
            UITableViewCell.appearance().textLabel?.textColor = UIColor.blue
            cell?.textLabel?.highlightedTextColor = UIColor.black
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
            return cell!
        }
        else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! FilterSubListTableViewCell
            let unChecked = UIImage(named: "square-blue") as UIImage!
            let checked = UIImage(named: "check-blue") as UIImage!
            cell.subcategorybtn.setImage(unChecked, for: .normal)
            print(selectedFilterIndex)
            print(filterList.count)
            print(indexPath.row)
            if filterList[selectedFilterIndex].subCategory.count > 0{
            print(filterList[selectedFilterIndex].subCategory.count)
            print(filterList[selectedFilterIndex].subCategory[1].subCategoryName)
            cell.subcategorybtn.setTitle(filterList[selectedFilterIndex].subCategory[indexPath.row].subCategoryName, for: .normal)
            cell.subcategorybtn.tag = indexPath.row
            if(filterList[selectedFilterIndex].subCategory[indexPath.row].isSelected){
                cell.subcategorybtn.setImage(checked, for: .normal)
            }
            }
            cell.delegate = self
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == FilterList{
            
          //  let cell: customCell = tableview.cellForRow(at: IndexPath(row: row, section: 0)) as! customCell
            
            selectedFilterIndex = indexPath.row
            switch(selectedFilterIndex){
            case FilterType.ASSETTYPE:
                lumpsum_sip.arrangedSubviews[0].isHidden = true
                lumpsum_sip.arrangedSubviews[1].isHidden = true
                lumpsum_sip.arrangedSubviews[2].isHidden = true
               // cell.lumpsum_sip.arrangedSubviews[0].isHidden = true
                getAssetType()
                Mixpanel.mainInstance().track(event: "Filter Screen :- Asset Type Clicked.")
            case FilterType.CATEGORY:
                lumpsum_sip.arrangedSubviews[0].isHidden = true
                lumpsum_sip.arrangedSubviews[1].isHidden = true
                lumpsum_sip.arrangedSubviews[2].isHidden = true
                getCategory()
                Mixpanel.mainInstance().track(event: "Filter Screen :- Category Clicked.")
            case FilterType.FUND_OPTION:
                lumpsum_sip.arrangedSubviews[0].isHidden = true
                lumpsum_sip.arrangedSubviews[1].isHidden = true
                lumpsum_sip.arrangedSubviews[2].isHidden = true
                //cell.lumpsum_sip.arrangedSubviews[0].isHidden = true
                Mixpanel.mainInstance().track(event: "Filter Screen :- Fund Option Clicked.")
                getFundOptions()
            case FilterType.FUND_HOUSE:
                lumpsum_sip.arrangedSubviews[0].isHidden = true
                lumpsum_sip.arrangedSubviews[1].isHidden = true
                lumpsum_sip.arrangedSubviews[2].isHidden = true
               // cell.lumpsum_sip.arrangedSubviews[0].isHidden = true
                getFundHouse()
                Mixpanel.mainInstance().track(event: "Filter Screen :- Fund House Clicked.")
            case FilterType.RISK_LEVEL:
                lumpsum_sip.arrangedSubviews[0].isHidden = true
                lumpsum_sip.arrangedSubviews[1].isHidden = true
                lumpsum_sip.arrangedSubviews[2].isHidden = true
               // cell.lumpsum_sip.arrangedSubviews[0].isHidden = true
                getRiskLevel()
                Mixpanel.mainInstance().track(event: "Filter Screen :- Risk Level Clicked.")
            case FilterType.MIN_INVESTMENT:
                lumpsum_sip.arrangedSubviews[0].isHidden = false
                lumpsum_sip.arrangedSubviews[1].isHidden = false
                lumpsum_sip.arrangedSubviews[2].isHidden = false
                getMinInvestment()
                Mixpanel.mainInstance().track(event: "Filter Screen :- Min Investment Clicked.")
            default:
                lumpsum_sip.arrangedSubviews[0].isHidden = true
                lumpsum_sip.arrangedSubviews[1].isHidden = true
                lumpsum_sip.arrangedSubviews[2].isHidden = true
                self.FilterSubList.reloadData()
                Mixpanel.mainInstance().track(event: "Filter Screen :- Filter Mode Clicked.")
            }
        }
    }
    
    
    func subCategory(row: Int) {
        let cell: FilterSubListTableViewCell = FilterSubList.cellForRow(at: IndexPath(row: row, section: 0)) as! FilterSubListTableViewCell
        if(filterList[selectedFilterIndex].subCategory[row].isSelected){
            let image1 = UIImage(named: "square-blue") as UIImage!
            cell.subcategorybtn.setImage(image1, for: .normal)
            filterList[selectedFilterIndex].subCategory[row].isSelected = false
            print(filterList[selectedFilterIndex].subCategory[row].subCategoryName!)
            Mixpanel.mainInstance().track(event: "Filter Screen :- Filter Sub Category \(filterList[selectedFilterIndex].subCategory[row].subCategoryName! ) unticked.")
        }else{
            let image1 = UIImage(named: "check-blue") as UIImage!
            cell.subcategorybtn.setImage(image1, for: .normal)
            filterList[selectedFilterIndex].subCategory[row].isSelected = true
            //print(filterList[FilterType.ASSETTYPE].subCategory[row].subCategoryName)
            Mixpanel.mainInstance().track(event: "Filter Screen :- Filter Sub Category \(filterList[selectedFilterIndex].subCategory[row].subCategoryName! ) Ticked.")
            print("heelllo")
        }
    }
    
    
    @IBAction func clearFilter(_ sender: Any) {
        lumpsumOutlet.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        sipoutlet.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        selectedFilterIndex = FilterType.MODE
        filterList[FilterType.ASSETTYPE].subCategory.removeAll()
        filterList[FilterType.CATEGORY].subCategory.removeAll()
        filterList[FilterType.FUND_OPTION].subCategory.removeAll()
        filterList[FilterType.FUND_HOUSE].subCategory.removeAll()
        filterList[FilterType.RISK_LEVEL].subCategory.removeAll()
        filterList[FilterType.MIN_INVESTMENT].subCategory.removeAll()
        filterList[FilterType.MODE].subCategory[0].isSelected = false
        filterList[FilterType.MODE].subCategory[1].isSelected = false
        let indexPath = IndexPath(row: 0, section: 0)
        FilterList.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        FilterSubList.reloadData()
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
        destVC.id = selected_id
        self.navigationController?.pushViewController(destVC, animated: true)
        Mixpanel.mainInstance().track(event: "Filter Screen :- Clear All Filter Button Pressed")
        
        print("heelllo")
    }
    
    
    @IBAction func applyFilter(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Filter Screen :- Apply Filter Button Pressed")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController

        for a in filterList{
            print(a)
            for b in a.subCategory{
               // print(b.isSelected)
                if b.isSelected == true{
                    
                    if a.category == "MODE"{
                        destVC.MODE.append(Int(b.subCategoryId!)!)
                     }
                    if a.category == "FUND OPTION"{
                        destVC.FUND_OPTION.append(Int(b.subCategoryId!)!)
                        print("HRR")
                    }
                    if a.category == "ASSET TYPE"{
                        destVC.ASSETTYPE.append(Int(b.subCategoryId!)!)
                    }
                    if a.category == "CATEGORY"{
                        //destVC.CATEGORY.append(b.subCategoryId!)
                        destVC.CATEGORY.append(b.subCategoryId!)
                    }
                    if a.category == "FUND HOUSE"{
                        destVC.FUND_HOUSE.append(Int(b.subCategoryId!)!)
                    }
                    if a.category == "RISK LEVEL"{
                        print(b.subCategoryId!)
                       // destVC.RISK_LEVEL.append(Int(b.subCategoryId!)!)
                        if b.subCategoryId == "1"{
                            destVC.RISK_LEVEL.append("High,Brown")
                        }
                        if b.subCategoryId == "2"{
                            destVC.RISK_LEVEL.append("Moderately High")
                        }
                        if b.subCategoryId == "3"{
                            destVC.RISK_LEVEL.append("Moderate,Yellow")
                        }
                        if b.subCategoryId == "4"{
                            destVC.RISK_LEVEL.append("Moderately Low")
                        }
                        if b.subCategoryId == "5"{
                            destVC.RISK_LEVEL.append("Low,Blue")
                        }
//                        <div class="innercheck"><input type="checkbox" name="fltrisklevel[]" class="risklevel" value="High,Brown">High</div>
//                        <div class="innercheck"><input type="checkbox" name="fltrisklevel[]" class="risklevel" value="Moderately High">Moderately High</div>
//                        <div class="innercheck"><input type="checkbox" name="fltrisklevel[]" class="risklevel" value="Moderate,Yellow">Moderate</div>
//                        <div class="innercheck"><input type="checkbox" name="fltrisklevel[]" class="risklevel" value="Moderately Low">Moderately Low</div>
//                        <div class="innercheck"><input type="checkbox" name="fltrisklevel[]" class="risklevel" value="Low,Blue">Low</div>
                        // MIN INVESTMENT
                    }
                    if a.category == "MIN INVESTMENT"{
                        // MIN INVESTMENT
                        if lumpsum_bool == true{
                            destVC.mininv_for = "1"
                            Lumpsum.append(1)
                            SIP.removeAll()
                            destVC.MIN_INVESTMENT.append(Int(b.subCategoryName!)!)
                        }
                        if sip_bool == true{
                            Lumpsum.removeAll()
                            SIP.append(2)
                            destVC.mininv_for = "2"
                            destVC.MIN_INVESTMENT.append(Int(b.subCategoryName!)!)
                        }
                        
                    }
                   
                }
                else{
                    //print(applyfilterList[])
                    print("false array")
                }
            }
        }
        destVC.id = selected_id
         self.navigationController?.pushViewController(destVC, animated: true)
    }
   
    
    
    
    @IBAction func lumpsumBtn(_ sender: Any) {
        lumpsumOutlet.setImage(UIImage(named: "check"), for: UIControlState.normal)
        sipoutlet.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        lumpsum_bool = true
        sip_bool = false
        
        Mixpanel.mainInstance().track(event: "Filter Screen :- Min Investment Lumpsum Button Pressed")
    }
    @IBAction func SIPbtn(_ sender: Any) {
        lumpsumOutlet.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        sipoutlet.setImage(UIImage(named: "check"), for: UIControlState.normal)
        lumpsum_bool = false
        sip_bool = true
        Mixpanel.mainInstance().track(event: "Filter Screen :- Min Investment Sip Button Pressed")
    }
    
    
    
}
extension FilterViewController{
    
    func getAssetType(){
        
        if filterList[FilterType.ASSETTYPE].subCategory.count == 0{
            presentWindow?.makeToastActivity(message: "Loading")
            if Connectivity.isConnectedToInternet{
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetAssetType)/3").responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc  = enc1?.base64Decoded()
                    let dict = self.convertToDictionary(text: enc!)
                   // if let data = response.result.value as? [AnyObject]{
                        if let data = dict as? [AnyObject]{
                        for type in data{
                            if let subCategoryName = type.value(forKey: "ASSET_TYPE") as? String,
                                let subCategoryId = type.value(forKey: "ASSET_CODE") as? String{
                                self.presentWindow.hideToastActivity()
                                filterList[FilterType.ASSETTYPE].subCategory.append(SubCategoryModel.getFilterListModelInstance(subCategoryName: subCategoryName, subCategoryId: subCategoryId))
                            }
                        }
                    }
                    self.FilterSubList.reloadData()
                }
            }
            else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }else{
            presentWindow.hideToastActivity()
            self.FilterSubList.reloadData()
        }
    }
    
    
    func getCategory(){
       print(filterList[FilterType.CATEGORY].subCategory.count,"Sub category count")
        if filterList[FilterType.CATEGORY].subCategory.count == 0{
             presentWindow?.makeToastActivity(message: "Loading")
            if Connectivity.isConnectedToInternet{
                print("\(Constants.BASE_URL)\(Constants.API.GetCategory)")
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetCategory)/3").responseString { response in
                    print("@@@@@@")
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc  = enc1?.base64Decoded()
                    let dict = self.convertToDictionary(text: enc!)
                    if let data = dict as? [AnyObject]{
                        print(data)
                        for type in data{
                            if  let subCategoryName = type.value(forKey: "CATEGORY") as? String,
                                let subCategoryId = type.value(forKey: "CLASSCODE") as? String{
                                self.presentWindow.hideToastActivity()
                                filterList[FilterType.CATEGORY]
                                    .subCategory
                                    .append(SubCategoryModel
                                        .getFilterListModelInstance(subCategoryName: subCategoryName, subCategoryId: subCategoryId))
                                
                            }
                        }
                    }
                    self.FilterSubList.reloadData()
                }
            }
            else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }else{
            presentWindow.hideToastActivity()
            self.FilterSubList.reloadData()
        }
    }
    
    
    func getFundOptions(){
       
        if filterList[FilterType.FUND_OPTION].subCategory.count == 0{
             presentWindow?.makeToastActivity(message: "Loading")
            if Connectivity.isConnectedToInternet{
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetFundOptions)/3").responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc  = enc1?.base64Decoded()
                    let dict = self.convertToDictionary(text: enc!)
                    
                    if let data = dict as? [AnyObject]{
                        for type in data{
                            if let subCategoryName = type.value(forKey: "OPTION") as? String,
                                let subCategoryId = type.value(forKey: "OPT_CODE") as? String{
                                self.presentWindow.hideToastActivity()
                                if subCategoryName != "Bonus" {
                                filterList[FilterType.FUND_OPTION]
                                    .subCategory
                                    .append(SubCategoryModel
                                        .getFilterListModelInstance(subCategoryName: subCategoryName, subCategoryId: subCategoryId))
                                }
                            }
                        }
                    }
                    self.FilterSubList.reloadData()
                }
            }
            else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }else{
            presentWindow.hideToastActivity()
            self.FilterSubList.reloadData()
        }
    }
    
    
    func getFundHouse(){
        
        if filterList[FilterType.FUND_HOUSE].subCategory.count == 0{
            presentWindow?.makeToastActivity(message: "Loading")
            if Connectivity.isConnectedToInternet{
                print("\(Constants.BASE_URL)\(Constants.API.GetFundHouse)/3")
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetFundHouse)/3").responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc  = enc1?.base64Decoded()
                    let dict = self.convertToDictionary(text: enc!)
                    if let data = dict as? [AnyObject]{
                        for type in data{
                            if let subCategoryName = type.value(forKey: "AMC") as? String,
                                let subCategoryId = type.value(forKey: "AMC_CODE") as? String{
                                self.presentWindow.hideToastActivity()
                                filterList[FilterType.FUND_HOUSE]
                                    .subCategory
                                    .append(SubCategoryModel
                                        .getFilterListModelInstance(subCategoryName: subCategoryName, subCategoryId: subCategoryId))
                            }
                        }
                    }
                    self.FilterSubList.reloadData()
                }
            }
            else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }else{
            presentWindow.hideToastActivity()
            self.FilterSubList.reloadData()
        }
    }
    
    
    func getRiskLevel(){
        
        if filterList[FilterType.RISK_LEVEL].subCategory.count == 0{
            presentWindow?.makeToastActivity(message: "Loading")
            if Connectivity.isConnectedToInternet{
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetRiskLevel)/3").responseString { response in
                    let enc_response = response.result.value
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    let enc  = enc1?.base64Decoded()
                    let dict = self.convertToDictionary(text: enc!)
                    if let data = dict as? [AnyObject]{
                        print(data)
                        //if let type = data as? [AnyObject]{
                        
                        for type in data{
                            if let subCategoryName = type.value(forKey: "risk_name") as? String,
                                let subCategoryId = type.value(forKey: "risk_id") as? String{
                                self.presentWindow.hideToastActivity()
                                filterList[FilterType.RISK_LEVEL]
                                    .subCategory
                                    .append(SubCategoryModel
                                        .getFilterListModelInstance(subCategoryName: subCategoryName, subCategoryId: subCategoryId))
                            }
                        }
                    }
                    self.FilterSubList.reloadData()
                    
                }
            }
            else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }else{
            presentWindow.hideToastActivity()
            self.FilterSubList.reloadData()
        }
    }
    
    
    
    func getMinInvestment(){
        
        if filterList[FilterType.MIN_INVESTMENT].subCategory.count == 0{
            presentWindow?.makeToastActivity(message: "Loading")
            if Connectivity.isConnectedToInternet{
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.GetMinInvestment)/3").responseString { response in
                let enc_response = response.result.value
                let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                let enc  = enc1?.base64Decoded()
                let dict = self.convertToDictionary(text: enc!)
                if let data = dict as? [AnyObject]{
                        for type in data{
                            if let subCategoryName = type.value(forKey: "MININVT") as? String,
                                let subCategoryId = type.value(forKey: "SCHEMECODE") as? String{
                                self.presentWindow.hideToastActivity()
                                filterList[FilterType.MIN_INVESTMENT]
                                    .subCategory
                                    .append(SubCategoryModel
                                        .getFilterListModelInstance(subCategoryName: subCategoryName, subCategoryId: subCategoryId))
                            }
                        }
                    }
                    self.FilterSubList.reloadData()
                    
                }
            }
            else{
                presentWindow.hideToastActivity()
                presentWindow?.makeToast(message: "No Internet Connection")
            }
        }else{
            presentWindow.hideToastActivity()
            self.FilterSubList.reloadData()
        }
    }
   
}



