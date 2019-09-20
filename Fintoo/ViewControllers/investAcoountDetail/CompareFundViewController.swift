//
//  CompareFundViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 09/02/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import DropDown
import Charts

protocol idDelegate {
    func idReceived(id_received : [String])
}

class CompareFundViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    @IBOutlet weak var addbuttonOutlet: UIButton!
    @IBOutlet weak var legendTableView: UITableView!
    @IBOutlet weak var footerMainLabel: NSLayoutConstraint!
    @IBOutlet weak var headerMainLabel: NSLayoutConstraint!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var fundName1: UILabel!
    @IBOutlet weak var fundName2: UILabel!
    @IBOutlet weak var fundName3: UILabel!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTf: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var footerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet weak var alphaView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var tableViewTopConstraints: NSLayoutConstraint!
    @IBOutlet weak var searchViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraingTopHolding: NSLayoutConstraint!
    @IBOutlet weak var topHoldingTableView: UITableView!
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var heightConstraintOfSecondView: NSLayoutConstraint!
    @IBOutlet weak var heightConstarintOfFirstView: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraintForMaxLabel: NSLayoutConstraint!
    @IBOutlet weak var maxFundLabelMsg: UILabel!
    var p_name_arr : [String]?
    var c_nav_arr : [String]?
    var OPT_code_arr : [String]?
    var row : [Int]?
    var bseschemetype_arr : [String]?
    var Scheme_code_arr : [String]?
    var sipfreqs_arr : [String]?
    var allsipamounts1_arr : [String]?
    var MAXINVT_arr: [String]?
    var SIPAvailable : [String]?
    var lumpsumMin : [String]?
    
    var assetArr = [AssetObj]()
    let suggestionListDropDown = DropDown()
    var id = [String]()
    var compareFundArr : CompareFundObj?
    var compareFundArr1 : CompareFundObj?
    var searchFundArr : SearchFundObj?
    let dropDownSearch = DropDown()
    var slectedSearchIndex = ""
    var colors: [UIColor] = []
    var productArr = [ProductObj]()
    var months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
    var delegate : idDelegate?
    var currentOffset = 0
    var unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
    private var filterSuggestionArr = [ProductObj]()
    var colors_random = [UIColor(red: CGFloat(5.0/255.0), green: CGFloat(141.0/255.0), blue: CGFloat(199.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(105.0/255.0), green: CGFloat(205.0/255.0), blue: CGFloat(75.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(240.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(128.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(192.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(255.0/255.0), green: CGFloat(247.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(255.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(140.0/255.0), green: CGFloat(234.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(147.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(80.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(50.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(128.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(128.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(255.0/255.0), green: CGFloat(247.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(105.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(140.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(140.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(80.0/255.0), green: CGFloat(180.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(125.0/255.0), green: CGFloat(128.0/255.0), blue: CGFloat(113.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(250.0/255.0), green: CGFloat(246.0/255.0), blue: CGFloat(147.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(255.0/255.0), green: CGFloat(208.0/255.0), blue: CGFloat(144.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(140.0/255.0), green: CGFloat(243.0/255.0), blue: CGFloat(255.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(255.0/255.0), green: CGFloat(140.0/255.0), blue: CGFloat(157.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(246.0/255.0), green: CGFloat(255.0/255.0), blue: CGFloat(195.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(172.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(42.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(219.0/255.0), green: CGFloat(190.0/255.0), blue: CGFloat(137.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(189.0/255.0), green: CGFloat(199.0/255.0), blue: CGFloat(141.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(156.0/255.0), green: CGFloat(206.0/255.0), blue: CGFloat(160.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(225.0/255.0), green: CGFloat(178.0/255.0), blue: CGFloat(227.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(251.0/255.0), green: CGFloat(174.0/255.0), blue: CGFloat(171.0/255.0), alpha: 1.0),
                         UIColor(red: CGFloat(246.0/255.0), green: CGFloat(173.0/255.0), blue: CGFloat(200.0/255.0), alpha: 1.0)]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        comapreFund(id: id)
        addBackbutton()
        searchTf.delegate = self
        searchTf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        searchTableView.delegate =  self
        searchTableView.dataSource = self
        
        topHoldingTableView.delegate = self
        topHoldingTableView.dataSource = self
        alphaView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        heightConstarintOfFirstView.constant = heightConstarintOfFirstView.constant + 5 * 30
        heightConstraingTopHolding.constant = heightConstraingTopHolding.constant + heightConstarintOfFirstView.constant + heightConstraintOfSecondView.constant - 130
        suggestionListDropDown.anchorView = self.searchTf
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        slectedSearchIndex = ""
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        widthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
        footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
        if id.count > 2 {
            //searchView.isHidden = true
            searchTf.isHidden = false
            addbuttonOutlet.isHidden = false
            searchTf.isUserInteractionEnabled = false
            addbuttonOutlet.isUserInteractionEnabled = false
            searchTf.text = ""
            //tableViewTopConstraints.constant = 8.0
            //searchViewHeightConstraint.constant = 0
            self.getFirstPage()
            
        } else {
            self.getFirstPage()
            searchView.isHidden = false
            searchTf.isHidden = false
            addbuttonOutlet.isHidden = false
//            tableViewTopConstraints.constant = 0.0
//            searchViewHeightConstraint.constant = 42.0
        }
    }
    
    @IBAction func fundCheckbox(_ sender: Any) {
        print()
        if id.count > 2 {
            id.remove(at:0)
            widthConstraint.constant = (UIScreen.main.bounds.width - 90)/id.count
            footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/id.count
            searchView.isHidden = false
            searchTf.text = ""
            searchTf.isHidden = false
            addbuttonOutlet.isHidden = false
            //searchTf.isHidden = true
            //addbuttonOutlet.isHidden = true
            self.maxFundLabelMsg.isHidden = true
            if id.count == 3 {
                searchTf.isUserInteractionEnabled = false
                addbuttonOutlet.isUserInteractionEnabled = false
            }else {
                searchTf.isUserInteractionEnabled = true
                addbuttonOutlet.isUserInteractionEnabled = true
            }
                
//            tableViewTopConstraints.constant = 8.0
//            searchViewHeightConstraint.constant = 42.0
            comapreFund(id: id)
        }else{
            searchTf.isHidden = false
            addbuttonOutlet.isHidden = false
            searchTf.isUserInteractionEnabled = true
            addbuttonOutlet.isUserInteractionEnabled = true
            presentWindow.makeToast(message: "Minimum two funds are required to compare.")
        }
    }
    @IBAction func fundCheckbox1(_ sender: Any) {
        if id.count > 2 {
            id.remove(at:1)
            widthConstraint.constant = (UIScreen.main.bounds.width - 90)/id.count
            footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/id.count
            searchView.isHidden = false
            searchTf.text = ""
            searchTf.isHidden = false
            addbuttonOutlet.isHidden = false
            self.maxFundLabelMsg.isHidden = true
            if id.count == 3 {
                searchTf.isUserInteractionEnabled = false
                addbuttonOutlet.isUserInteractionEnabled = false
            }else {
                searchTf.isUserInteractionEnabled = true
                addbuttonOutlet.isUserInteractionEnabled = true
            }
           
            
            
            
//            tableViewTopConstraints.constant = 8.0
//            searchViewHeightConstraint.constant = 42.0
            comapreFund(id: id)
        }else{
            searchTf.isHidden = false
            addbuttonOutlet.isHidden = false
            searchTf.isUserInteractionEnabled = true
            addbuttonOutlet.isUserInteractionEnabled = true
            presentWindow.makeToast(message: "Minimum two funds are required to compare.")
        }
    }
    @IBAction func fundCheckbox2(_ sender: Any) {
        if id.count > 2 {
            id.remove(at:2)
            widthConstraint.constant = (UIScreen.main.bounds.width - 90)/id.count
            footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/id.count
            searchView.isHidden = false
            searchTf.text = ""
            searchTf.isHidden = false
            addbuttonOutlet.isHidden = false
            self.maxFundLabelMsg.isHidden = true
            //searchTf.isHidden = true
            //addbuttonOutlet.isHidden = true
            searchTf.isUserInteractionEnabled = false
            addbuttonOutlet.isUserInteractionEnabled = false
            
            if id.count == 3 {
                searchTf.isUserInteractionEnabled = false
                addbuttonOutlet.isUserInteractionEnabled = false
            }else {
                searchTf.isUserInteractionEnabled = true
                addbuttonOutlet.isUserInteractionEnabled = true
            }
           
//            tableViewTopConstraints.constant = 8.0
//            searchViewHeightConstraint.constant = 42.0
            comapreFund(id: id)
        }else{
            searchTf.isHidden = false
            addbuttonOutlet.isHidden = false
            searchTf.isUserInteractionEnabled = true
            addbuttonOutlet.isUserInteractionEnabled = true
            presentWindow.makeToast(message: "Minimum two funds are required to compare.")
        }
    }
    @IBAction func searchAddButton(_ sender: Any) {
        print(id.contains(slectedSearchIndex))
        if !searchTf.text!.isEmpty{
            if slectedSearchIndex != "" {
                if !id.contains(slectedSearchIndex) {
                    if compareFundArr!.schemedet.count == 2 {
                        id.append(slectedSearchIndex)
                        //searchView.isHidden = true
                        searchTf.isHidden = false
                        addbuttonOutlet.isHidden = false
                        searchTf.text = ""
                        searchTf.resignFirstResponder()
                        //tableViewTopConstraints.constant = 8.0
                        //searchViewHeightConstraint.constant = 0.0
                        comapreFund(id: id)
                        self.maxFundLabelMsg.isHidden = false
                    } else {
                        presentWindow.makeToast(message: "Only three funds can be compared")
                    }
                } else {
                    presentWindow.makeToast(message: "Same Fund Can Not Be Compared")
                }
            }else{
                let alert = UIAlertController(title: "Alert", message: "Fund not found", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                
                //presentWindow.makeToastActivity(message: "Fund not found")
            }
        }
    }
    @IBAction func sectorAllocation1(_ sender: UIButton) {
        let s_code = compareFundArr?.schemedet[sender.tag]["SCHEMECODE"] as? String ?? ""
        comapreFund_holding(id: s_code)
        alphaView.isHidden = false
        //topHoldingTableView.reloadData()
    }
    @IBAction func sectorAllocation2(_ sender: UIButton) {
        let s_code = compareFundArr?.schemedet[sender.tag]["SCHEMECODE"] as? String ?? ""
        comapreFund_holding(id: s_code)
        alphaView.isHidden = false
    }
    @IBAction func sectorAllocation3(_ sender: UIButton) {
        let s_code = compareFundArr?.schemedet[sender.tag]["SCHEMECODE"] as? String ?? ""
        comapreFund_holding(id: s_code)
        alphaView.isHidden = false
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        delegate?.idReceived(id_received: id)
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == legendTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "schemeInfo") as? legendDetailCell
            let totalSum = unitsSold.reduce(0, +)
            let P_Calculation = unitsSold[indexPath.row]/totalSum * 100
            let text = String(format: "%.2f", arguments: [P_Calculation])
            cell?.colorLabel.backgroundColor = colors[indexPath.row]
            cell?.legendName.text = months[indexPath.row]
            cell?.legendPrice.text = String(unitsSold[indexPath.row]).decimalString
            return cell!
        } else if tableView ==  searchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1")
            cell?.textLabel!.text = filterSuggestionArr[indexPath.row].p_name
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.font = UIFont(
                name: "Helvetica Neue",
                size: 14.0)
            return cell!
        } else if tableView ==  topHoldingTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "holding") as? holdingCell
            cell?.holdingLabel.text = compareFundArr1?.holdings[indexPath.row].holdpercentage.decimalString
            cell?.sectorLabel.text = compareFundArr1?.holdings[indexPath.row].sector ?? "nodata"
            cell?.companyNameLabel.text = compareFundArr1?.holdings[indexPath.row].compname
            return cell!
        }else  {
            let cell = tableview.dequeueReusableCell(withIdentifier: "Cell") as? compareFundCell
            
            if indexPath.section == 0 {
                
                let count = compareFundArr?.schemedet.count
                switch count {
                    case 2 :
                        headerMainLabel.constant = 70
                        footerMainLabel.constant = 70
                        widthConstraint.constant = (UIScreen.main.bounds.width - 90)/2
                        footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/2
                        cell?.view3.isHidden = true
                        cell?.currentNav3.isHidden = true
                        cell?.mainLabel.constant = 70
                        switch indexPath.row {
                        case 0 :
                            var c_nav = [String]()
                            for (i,g) in id.enumerated(){
                                let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                c_nav.append(compareFundArr?.navhistory[abc!].currentnav ?? "0.0000")
                            }
                           let currnt_nav = c_nav[0]
                           let currnt_nav_1 = c_nav[1]
                           cell?.currentNav1.text = "₹ " + currnt_nav
                           cell?.currentNav2.text = "₹ " + currnt_nav_1
                           cell?.label.text = "Current NAV"
                        case 1 :
                            var c_nav = [String]()
                            for (i,g) in id.enumerated(){
                                let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                c_nav.append(compareFundArr?.navhistory[abc!].sixmonthsnav ?? "0.0000")
                            }
                            let currnt_nav = c_nav[0]
                            let currnt_nav_1 = c_nav[1]
                            cell?.currentNav1.text = "₹ " + currnt_nav
                            cell?.currentNav2.text = "₹ " + currnt_nav_1
                            cell?.label.text = "Before 6 Months"
                        case 2 :
                            //oneyrnav
                            var c_nav = [String]()
                            for (i,g) in id.enumerated(){
                                let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                c_nav.append(compareFundArr?.navhistory[abc!].oneyearnav ?? "0.0000")
                            }
                            let currnt_nav = c_nav[0]
                            let currnt_nav_1 = c_nav[1]
                            cell?.currentNav1.text = "₹ " + currnt_nav
                            cell?.currentNav2.text = "₹ " + currnt_nav_1
                            cell?.label.text = "Before 1 Year"
                        case 3 :
                            var c_nav = [String]()
                            for (i,g) in id.enumerated(){
                                let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                c_nav.append(compareFundArr?.navhistory[abc!].threeyearsnav ?? "0.0000")
                            }
                            let currnt_nav = compareFundArr?.navhistory[0].threeyearsnav ?? "0.0000"
                            let currnt_nav_1 = compareFundArr?.navhistory[1].threeyearsnav ?? "0.0000"
                            cell?.currentNav1.text = "₹ " + currnt_nav
                            cell?.currentNav2.text = "₹ " + currnt_nav_1
                            cell?.label.text = "Before 3 Years"
                        case 4 :
                            var c_nav = [String]()
                            for (i,g) in id.enumerated(){
                                let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                c_nav.append(compareFundArr?.navhistory[abc!].fiveyearsnav ?? "0.0000")
                            }
                            let currnt_nav = c_nav[0]
                            let currnt_nav_1 = c_nav[1]
                            cell?.currentNav1.text = "₹ " + currnt_nav
                            cell?.currentNav2.text = "₹ " + currnt_nav_1
                            cell?.label.text = "Before 5 Years"
                        default :
                            print("Failed")
                    }
                    case 3 :
                        headerMainLabel.constant = 50
                        footerMainLabel.constant = 50
                        widthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
                        footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
                        cell?.view3.isHidden = false
                        cell?.currentNav3.isHidden = false
                        cell?.mainLabel.constant = 50
                        switch indexPath.row {
                            case 0 :
                                var c_nav = [String]()
                                for (i,g) in id.enumerated(){
                                    let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                    c_nav.append(compareFundArr?.navhistory[abc!].currentnav ?? "0.0000")
                                }
                                let currnt_nav = c_nav[0]
                                let currnt_nav_1 = c_nav[1]
                                let currnt_nav_2 = c_nav[2]
                                cell?.currentNav1.text = "₹ " + currnt_nav
                                cell?.currentNav2.text = "₹ " + currnt_nav_1
                                cell?.currentNav3.text = "₹ " + currnt_nav_2
                                
                                cell?.label.text = "Current NAV"
                            case 1 :
                                var c_nav = [String]()
                                for (i,g) in id.enumerated(){
                                    let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                    c_nav.append(compareFundArr?.navhistory[abc!].sixmonthsnav ?? "0.0000")
                                }
                                let currnt_nav = c_nav[0]
                                let currnt_nav_1 = c_nav[1]
                                let currnt_nav_2 = c_nav[2]
                                cell?.currentNav1.text = "₹ " + currnt_nav
                                cell?.currentNav2.text = "₹ " + currnt_nav_1
                                cell?.currentNav3.text = "₹ " + currnt_nav_2
                                cell?.label.text = "Before 6 Months"
                            case 2 :
                                //oneyrnav
                                var c_nav = [String]()
                                for (i,g) in id.enumerated(){
                                    let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                    c_nav.append(compareFundArr?.navhistory[abc!].oneyearnav ?? "0.0000")
                                }
                                let currnt_nav = c_nav[0]
                                let currnt_nav_1 = c_nav[1]
                                let currnt_nav_2 = c_nav[2]
                                cell?.currentNav1.text = "₹ " + currnt_nav
                                cell?.currentNav2.text =  "₹ " + currnt_nav_1
                                cell?.currentNav3.text = "₹ " + currnt_nav_2
                                cell?.label.text = "Before 1 Year"
                            case 3 :
                                var c_nav = [String]()
                                for (i,g) in id.enumerated(){
                                    let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                    c_nav.append(compareFundArr?.navhistory[abc!].threeyearsnav ?? "0.0000")
                                }
                                let currnt_nav =  c_nav[0]
                                let currnt_nav_1 = c_nav[1]
                                let currnt_nav_2 = c_nav[2]
                                cell?.currentNav1.text = "₹ " + currnt_nav
                                cell?.currentNav2.text = "₹ " + currnt_nav_1
                                cell?.currentNav3.text = "₹ " + currnt_nav_2
                                cell?.label.text = "Before 3 Years"
                            case 4 :
                                var c_nav = [String]()
                                for (i,g) in id.enumerated(){
                                    let abc = compareFundArr?.navhistory.index(where: {$0.navhisSchemecode == compareFundArr?.schemedet[i]["SCHEMECODE"]})
                                    c_nav.append(compareFundArr?.navhistory[abc!].fiveyearsnav ?? "0.0000")
                                }
                                let currnt_nav = c_nav[0]
                                let currnt_nav_1 = c_nav[1]
                                let currnt_nav_2 = c_nav[2]
                                cell?.currentNav1.text = "₹ " + currnt_nav
                                cell?.currentNav2.text = "₹ " + currnt_nav_1
                                cell?.currentNav3.text = "₹ " + currnt_nav_2
                                cell?.label.text = "Before 5 Years"
                            default :
                                print("Failed")
                    }
                    default :
                        print("Failed")
                }
                return cell!
            } else if indexPath.section == 1 {
                let count = compareFundArr?.schemedet.count
                switch count {
                case 2 :
                    widthConstraint.constant = (UIScreen.main.bounds.width - 90)/2
                    footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/2
                    cell?.view3.isHidden = true
                    cell?.currentNav3.isHidden = true
                    cell?.mainLabel.constant = 70
                    headerMainLabel.constant = 70
                    footerMainLabel.constant = 70
                    switch indexPath.row {
                    case 0 :
                        let currnt_nav = compareFundArr?.schemedet[1]["threemonthret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["threemonthret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.label.text = "3 Months"
                    case 1 :
                        let currnt_nav = compareFundArr?.schemedet[1]["sixmonthret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["sixmonthret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.label.text = "6 Months"
                    case 2 :
                        let currnt_nav = compareFundArr?.schemedet[1]["oneyearret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["oneyearret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.label.text = "1 Year"
                    case 3 :
                        let currnt_nav = compareFundArr?.schemedet[1]["threeyearret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["threeyearret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.label.text = "3 Years"
                    case 4 :
                        let currnt_nav = compareFundArr?.schemedet[1]["fiveyearret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["fiveyearret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.label.text = "5 Years"
                    default :
                        print("Failed")
                    }
                case 3 :
                    headerMainLabel.constant = 50
                    footerMainLabel.constant = 50
                    widthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
                    footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
                    cell?.view3.isHidden = false
                    cell?.currentNav3.isHidden = false
                    cell?.mainLabel.constant = 50
                    switch indexPath.row {
                    case 0 :
                        let currnt_nav = compareFundArr?.schemedet[1]["threemonthret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["threemonthret"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["threemonthret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.currentNav3.text = currnt_nav_2?.decimalString
                        cell?.label.text = "3 months"
                    case 1 :
                        let currnt_nav = compareFundArr?.schemedet[1]["sixmonthret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["sixmonthret"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["sixmonthret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.currentNav3.text = currnt_nav_2?.decimalString
                        cell?.label.text = "6 months"
                    case 2 :
                        //oneyrnav
                        let currnt_nav = compareFundArr?.schemedet[1]["oneyearret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["oneyearret"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["oneyearret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.currentNav3.text = currnt_nav_2?.decimalString
                        cell?.label.text = "1 Year"
                    case 3 :
                        let currnt_nav = compareFundArr?.schemedet[1]["threeyearret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["threeyearret"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["threeyearret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.currentNav3.text = currnt_nav_2?.decimalString
                        cell?.label.text = "3 Years"
                    case 4 :
                        let currnt_nav = compareFundArr?.schemedet[1]["fiveyearret"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["fiveyearret"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["fiveyearret"] as? String
                        cell?.currentNav2.text = currnt_nav?.decimalString
                        cell?.currentNav1.text = currnt_nav_1?.decimalString
                        cell?.currentNav3.text = currnt_nav_2?.decimalString
                        cell?.label.text = "5 Years"
                    default :
                        print("Failed")
                    }
                default :
                    print("Failed")
                }
                return cell!
            } else if indexPath.section == 2 {
                let count = compareFundArr?.schemedet.count
                switch count {
                case 2 :
                    widthConstraint.constant = (UIScreen.main.bounds.width - 90)/2
                    footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/2
                    cell?.view3.isHidden = true
                    cell?.currentNav3.isHidden = true
                    cell?.mainLabel.constant = 70
                    headerMainLabel.constant = 70
                    footerMainLabel.constant = 70
                    switch indexPath.row {
                    case 0 :
                        let currnt_nav = compareFundArr?.schemedet[1]["fund_house"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["fund_house"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.label.text = "Fund House"
                    case 1 :
                        let currnt_nav = compareFundArr?.schemedet[1]["launchdate"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["launchdate"] as? String
                        cell?.currentNav2.text = currnt_nav?.toDate()
                        cell?.currentNav1.text = currnt_nav_1?.toDate()
                        cell?.label.text = "Launch Date"
                    case 2 :
                        //oneyrnav
                        let currnt_nav = compareFundArr?.schemedet[1]["riskometer"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["riskometer"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.label.text = "Riskometer"
                    case 3 :
                        let currnt_nav = compareFundArr?.schemedet[1]["turnover_ratio"] as? String ?? "N/A"
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["turnover_ratio"] as? String ?? "N/A"
                        if currnt_nav != "0" && currnt_nav_1 != "0" {
                            cell?.currentNav2.text = currnt_nav + " %"
                            cell?.currentNav1.text = currnt_nav_1 + " %"
                        } else if currnt_nav == "0" {
                            cell?.currentNav2.text = "N/A"
                            cell?.currentNav1.text = currnt_nav_1 + " %"
                        } else if currnt_nav_1 == "0"{
                            cell?.currentNav2.text = currnt_nav + " %"
                            cell?.currentNav1.text = "N/A"
                        }
                        cell?.label.text = "Turnover"
                    case 4 :
                        let currnt_nav = compareFundArr?.schemedet[1]["fund_type"] as? String ?? "N/A"
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["fund_type"] as? String ?? "N/A"
                        if currnt_nav == "1" {
                            cell?.currentNav2.text = "Open-ended"
                        } else {
                            cell?.currentNav2.text = "Close-ended"
                        }
                        if currnt_nav_1 == "1"{
                            cell?.currentNav1.text = "Open-ended"
                            
                        } else {
                            cell?.currentNav1.text = "Close-ended"
                        }
                        
                        cell?.label.text = "Scheme Type"
                    case 5 :
                        let currnt_nav = compareFundArr?.schemedet[1]["CATEGORY"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["CATEGORY"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.label.text = "Scheme Category"
                    case 6 :
                        let currnt_nav = compareFundArr?.schemedet[1]["RT_NAME"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["RT_NAME"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.label.text = "Registrar Name"
                    case 7 :
                        let currnt_nav = compareFundArr?.schemedet[1]["fundmanager"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["fundmanager"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.label.text = "Fund Manager"
                    case 8 :
                        let currnt_nav = compareFundArr?.schemedet[1]["CLASSNAME"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["CLASSNAME"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.label.text = "Fund Class"
                    case 9 :
                        let currnt_nav = compareFundArr?.schemedet[1]["mininvt"] as? String ?? "0"
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["mininvt"] as? String ?? "0"
                        cell?.currentNav2.text = "₹ " + currnt_nav
                        cell?.currentNav1.text = "₹ " + currnt_nav_1
                        cell?.label.text = "Min. Lumpsum Investment"
                    case 10 :
                        let currnt_nav = compareFundArr?.schemedet[1]["minsipinvt"] as? String ?? "0"
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["minsipinvt"] as? String ?? "0"
                        cell?.currentNav2.text = "₹ " + currnt_nav
                        cell?.currentNav1.text = "₹ " + currnt_nav_1
                        cell?.label.text = "Min. SIP Investment"
                    case 11 :
                        let currnt_nav = compareFundArr?.schemedet[1]["corpus"] as? String ?? "0"
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["corpus"] as? String ?? "0"
                        let date  = compareFundArr?.schemedet[1]["corpus_date"] as? String ?? ""
                        let date1  = compareFundArr?.schemedet[0]["corpus_date"] as? String ?? ""
                        cell?.currentNav2.text = "₹ " + currnt_nav + " cr (As on \(date.toDateWithFormat()!))"
                        cell?.currentNav1.text = "₹ " + currnt_nav_1 + " cr (As on \(date1.toDateWithFormat()!))"
                        cell?.label.text = "Corpus"
                    case 12 :
                        let currnt_nav = compareFundArr?.schemedet[1]["scheme_benchmark"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["scheme_benchmark"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.label.text = "Scheme Benchmark"
                    case 13 :
                        let currnt_nav = compareFundArr?.expenceRatio[1].expRatio ?? ""
                        let currnt_nav_1 = compareFundArr?.expenceRatio[0].expRatio ?? ""
                        let date  = compareFundArr?.expenceRatio[1].ratioDate ?? ""
                        let date1  = compareFundArr?.expenceRatio[0].ratioDate ?? ""
                        cell?.currentNav1.text = currnt_nav + " (As on \(date.toDateWithFormat()!))"
                        cell?.currentNav2.text = currnt_nav_1 + " (As on \(date1.toDateWithFormat()!))"
                        
                        cell?.label.text = "Expense Ratio"
                    default :
                        print("Failed")
                    }
                case 3 :
                    headerMainLabel.constant = 50
                    footerMainLabel.constant = 50
                    widthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
                    footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
                    cell?.view3.isHidden = false
                    cell?.currentNav3.isHidden = false
                    cell?.mainLabel.constant = 50
                    switch indexPath.row {
                    case 0 :
                        let currnt_nav = compareFundArr?.schemedet[1]["fund_house"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["fund_house"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["fund_house"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.currentNav3.text = currnt_nav_2
                        cell?.label.text = "Fund House"
                    case 1 :
                        let currnt_nav = compareFundArr?.schemedet[1]["launchdate"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["launchdate"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["launchdate"] as? String
                        cell?.currentNav2.text = currnt_nav?.toDate()
                        cell?.currentNav1.text = currnt_nav_1?.toDate()
                        cell?.currentNav3.text = currnt_nav_2?.toDate()
                        cell?.label.text = "Launch Date"
                    case 2 :
                        //oneyrnav
                        let currnt_nav = compareFundArr?.schemedet[1]["riskometer"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["riskometer"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["riskometer"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.currentNav3.text = currnt_nav_2
                        cell?.label.text = "Riskometer"
                    case 3 :
                        let currnt_nav = compareFundArr?.schemedet[1]["turnover_ratio"] as? String ?? "N/A"
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["turnover_ratio"] as? String ?? "N/A"
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["turnover_ratio"] as? String ?? "N/A"
                        if currnt_nav != "0" && currnt_nav_1 != "0" && currnt_nav_2 != "0"{
                            cell?.currentNav2.text = currnt_nav + " %"
                            cell?.currentNav1.text = currnt_nav_1 + " %"
                            cell?.currentNav3.text = currnt_nav_2 + " %"
                        } else if currnt_nav == "0" {
                            cell?.currentNav2.text = "N/A"
                            cell?.currentNav1.text = currnt_nav_1 + " %"
                            cell?.currentNav3.text = currnt_nav_2 + " %"
                        } else if currnt_nav_1 == "0"{
                            cell?.currentNav2.text = currnt_nav + " %"
                            cell?.currentNav1.text = "N/A"
                            cell?.currentNav3.text = currnt_nav_2 + " %"
                        } else if currnt_nav_2 == "0"{
                            cell?.currentNav2.text = currnt_nav + " %"
                            cell?.currentNav1.text = currnt_nav_1 + " %"
                            cell?.currentNav3.text = "N/A"
                        }
                        
                        cell?.label.text = "Turnover"
                    case 4 :
                        let currnt_nav = compareFundArr?.schemedet[1]["fund_type"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["fund_type"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["fund_type"] as? String
                        //cell?.currentNav1.text = currnt_nav
                       // cell?.currentNav2.text = currnt_nav_1
                       // cell?.currentNav3.text = currnt_nav_2
                        if currnt_nav == "1" {
                            cell?.currentNav2.text = "Open-ended"
                        } else {
                            cell?.currentNav2.text = "Close-ended"
                        }
                        if currnt_nav_1 == "1"{
                            cell?.currentNav1.text = "Open-ended"
                            
                        } else {
                            cell?.currentNav1.text = "Close-ended"
                        }
                        if currnt_nav_2 == "1"{
                            cell?.currentNav3.text = "Open-ended"
                            
                        } else {
                            cell?.currentNav3.text = "Close-ended"
                        }
                        cell?.label.text = "Scheme Type"
                    case 5 :
                        let currnt_nav = compareFundArr?.schemedet[1]["CATEGORY"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["CATEGORY"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["CATEGORY"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.currentNav3.text = currnt_nav_2
                        cell?.label.text = "Scheme Category"
                    case 6 :
                        let currnt_nav = compareFundArr?.schemedet[1]["RT_NAME"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["RT_NAME"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["RT_NAME"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.currentNav3.text = currnt_nav_2
                        cell?.label.text = "Registrar Name"
                    case 7 :
                        let currnt_nav = compareFundArr?.schemedet[1]["fundmanager"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["fundmanager"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["fundmanager"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.currentNav3.text = currnt_nav_2
                        cell?.label.text = "Fund Manager"
                    case 8 :
                        let currnt_nav = compareFundArr?.schemedet[1]["CLASSNAME"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["CLASSNAME"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["CLASSNAME"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.currentNav3.text = currnt_nav_2
                        cell?.label.text = "Fund Class"
                    case 9 :
                        let currnt_nav = compareFundArr?.schemedet[1]["mininvt"] as? String ?? "0"
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["mininvt"] as? String ?? "0"
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["mininvt"] as? String ?? "0"
                        cell?.currentNav2.text = "₹ " + currnt_nav
                        cell?.currentNav1.text = "₹ " + currnt_nav_1
                        cell?.currentNav3.text = "₹ " + currnt_nav_2
                        cell?.label.text = "Min. Lumpsum Investment"
                    case 10 :
                        let currnt_nav = compareFundArr?.schemedet[1]["minsipinvt"] as? String ?? "0"
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["minsipinvt"] as? String ?? "0"
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["minsipinvt"] as? String ?? "0"
                        cell?.currentNav2.text = "₹ " + currnt_nav
                        cell?.currentNav1.text = "₹ " + currnt_nav_1
                        cell?.currentNav3.text = "₹ " + currnt_nav_2
                        cell?.label.text = "Min. SIP Investment"
                        
                    case 11 :
                        let currnt_nav = compareFundArr?.schemedet[1]["corpus"] as? String ?? "0"
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["corpus"] as? String ?? "0"
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["corpus"] as? String ?? "0"
                        let date  = compareFundArr?.schemedet[0]["corpus_date"] as? String ?? ""
                        let date1  = compareFundArr?.schemedet[1]["corpus_date"] as? String ?? ""
                        let date2  = compareFundArr?.schemedet[2]["corpus_date"] as? String ?? ""
                        cell?.currentNav2.text = "₹ " + currnt_nav + " cr (As on \(date.toDateWithFormat()!))"
                        cell?.currentNav1.text = "₹ " + currnt_nav_1 + " cr (As on \(date1.toDateWithFormat()!))"
                        cell?.currentNav3.text = "₹ " + currnt_nav_2 + " cr (As on \(date2.toDateWithFormat()!))"
                        cell?.label.text = "Corpus"
                    case 12 :
                        let currnt_nav = compareFundArr?.schemedet[1]["scheme_benchmark"] as? String
                        let currnt_nav_1 = compareFundArr?.schemedet[0]["scheme_benchmark"] as? String
                        let currnt_nav_2 = compareFundArr?.schemedet[2]["scheme_benchmark"] as? String
                        cell?.currentNav2.text = currnt_nav
                        cell?.currentNav1.text = currnt_nav_1
                        cell?.currentNav3.text = currnt_nav_2
                        cell?.label.text = "Scheme Benchmark"
                    case 13 :
                        let currnt_nav = compareFundArr?.expenceRatio[0].expRatio ?? ""
                        let currnt_nav_1 = compareFundArr?.expenceRatio[1].expRatio ?? ""
                        let currnt_nav_2 = compareFundArr?.expenceRatio[2].expRatio ?? ""
                        let date  = compareFundArr?.expenceRatio[0].ratioDate ?? ""
                        let date1  = compareFundArr?.expenceRatio[1].ratioDate ?? ""
                        let date2  = compareFundArr?.expenceRatio[2].ratioDate ?? ""
                        print(date.toDateWithFormat()!)
                        cell?.currentNav1.text = currnt_nav + " (As on \(date.toDateWithFormat()!))"
                        cell?.currentNav2.text = currnt_nav_1 + " (As on \(date1.toDateWithFormat()!))"
                        cell?.currentNav3.text = currnt_nav_2 + " (As on \(date2.toDateWithFormat()!))"
                        cell?.label.text = "Expense Ratio"
                    default :
                        print("Failed")
                    }
                default :
                    print("Failed")
                }
                return cell!
            } else if indexPath.section == 3 {
                let count = compareFundArr?.schemedet.count
                switch count {
                case 2 :
                    headerMainLabel.constant = 70
                    footerMainLabel.constant = 70
                    widthConstraint.constant = (UIScreen.main.bounds.width - 90)/2
                    footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/2
                    cell?.view3.isHidden = true
                    cell?.currentNav3.isHidden = true
                    cell?.mainLabel.constant = 70
                    switch indexPath.row {
                    case 0 :
                        let s_code = compareFundArr?.schemedet[0]["SCHEMECODE"] as? String
                        let assetAllocationArr = compareFundArr?.assetAllocation
                        let filterHoldSchemecode = assetAllocationArr!.filter { $0.asset == "Equity"}
                        print(filterHoldSchemecode)
                        switch filterHoldSchemecode.count {
                            case 0 :
                                
                                cell?.currentNav1.text = "0.00 %"
                                cell?.currentNav2.text = "0.00 %"
                            case 1 :
                            
                                let holdSchemecode = filterHoldSchemecode[0].holdSchemecode
                                if s_code == holdSchemecode {
                                    cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                                    cell?.currentNav2.text = "0.00 %"
                                } else {
                                    cell?.currentNav1.text = "0.00 %"
                                    cell?.currentNav2.text = filterHoldSchemecode[0].holding.decimalString
                                }
                            case 2 :
                                cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                                cell?.currentNav2.text = filterHoldSchemecode[1].holding.decimalString
                            
                        default:
                            break
                        }
                        cell?.label.text = "Equity"
                    case 1 :
                        let s_code = compareFundArr?.schemedet[0]["SCHEMECODE"] as? String
                        let assetAllocationArr = compareFundArr?.assetAllocation
                        let filterHoldSchemecode = assetAllocationArr!.filter { $0.asset == "Debt"}
                        print(filterHoldSchemecode)
                        switch filterHoldSchemecode.count {
                        case 0 :
                            cell?.currentNav1.text = "0.00 %"
                            cell?.currentNav2.text = "0.00 %"
                        case 1 :
                            let holdSchemecode = filterHoldSchemecode[0].holdSchemecode
                            if s_code == holdSchemecode {
                                cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                                cell?.currentNav2.text = "0.00 %"
                            } else {
                                cell?.currentNav1.text = "0.00 %"
                                cell?.currentNav2.text = filterHoldSchemecode[0].holding.decimalString
                            }
                            case 2 :
                                cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                                cell?.currentNav2.text = filterHoldSchemecode[1].holding.decimalString
                            
                        default:
                            break
                        }

                        cell?.label.text = "Debt"
                    case 2 :
                        //oneyrnav
                        let s_code = compareFundArr?.schemedet[0]["SCHEMECODE"] as? String
                        let assetAllocationArr = compareFundArr?.assetAllocation
                        let filterHoldSchemecode = assetAllocationArr!.filter { $0.asset == "Others"}
                        print(filterHoldSchemecode)
                        switch filterHoldSchemecode.count {
                        case 0 :
                            cell?.currentNav1.text = "0.00 %"
                            cell?.currentNav2.text = "0.00 %"
                        case 1 :
                            let holdSchemecode = filterHoldSchemecode[0].holdSchemecode
                            if s_code == holdSchemecode {
                                cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                                cell?.currentNav2.text = "0.00 %"
                            } else {
                                cell?.currentNav1.text = "0.00 %"
                                cell?.currentNav2.text = filterHoldSchemecode[0].holding.decimalString
                            }
                        case 2 :
                            cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                            cell?.currentNav2.text = filterHoldSchemecode[1].holding.decimalString
                            
                        default:
                            break
                        }
                        cell?.label.text = "Others"
                    default :
                        print("Failed")
                    }
                case 3 :
                    headerMainLabel.constant = 50
                    footerMainLabel.constant = 50
                    widthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
                    footerWidthConstraint.constant = (UIScreen.main.bounds.width - 90)/3
                    cell?.view3.isHidden = false
                    cell?.currentNav3.isHidden = false
                    cell?.mainLabel.constant = 50
                    switch indexPath.row {
                    case 0 :
                        let s_code1 = compareFundArr?.schemedet[0]["SCHEMECODE"] as? String
                        let s_code2 = compareFundArr?.schemedet[1]["SCHEMECODE"] as? String
                        let assetAllocationArr = compareFundArr?.assetAllocation
                        let filterHoldSchemecode = assetAllocationArr!.filter { $0.asset == "Equity"}
                        print(filterHoldSchemecode)
                        switch filterHoldSchemecode.count {
                        case 0 :
                            cell?.currentNav1.text = "0.00 %"
                            cell?.currentNav2.text = "0.00 %"
                            cell?.currentNav3.text = "0.00 %"
                        case 1 :
                            let holdSchemecode = filterHoldSchemecode[0].holdSchemecode
                            if holdSchemecode == s_code1 {
                                cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                                cell?.currentNav2.text = "0.00 %"
                                cell?.currentNav3.text = "0.00 %"
                            } else if holdSchemecode == s_code2 {
                                cell?.currentNav1.text = "0.00 %"
                                cell?.currentNav2.text = filterHoldSchemecode[0].holding.decimalString
                                cell?.currentNav3.text = "0.00 %"
                            } else{
                                cell?.currentNav1.text = "0.00 %"
                                cell?.currentNav2.text = "0.00 %"
                                cell?.currentNav3.text = filterHoldSchemecode[0].holding.decimalString
                            }
                        case 2 :
                            var lbl1 = false
                            var lbl2 = false
                            var lbl3 = false
                            for (index, object) in filterHoldSchemecode.enumerated() {
                                if object.holdSchemecode == s_code1{
                                    cell?.currentNav1.text = filterHoldSchemecode[index].holding.decimalString
                                    lbl1 = true
                                } else if object.holdSchemecode == s_code2{
                                    cell?.currentNav2.text = filterHoldSchemecode[index].holding.decimalString
                                    lbl2 = true
                                } else {
                                    cell?.currentNav3.text = filterHoldSchemecode[index].holding.decimalString
                                    lbl3 = true
                                }
                            }
                            if !lbl1 {
                                cell?.currentNav1.text = "0.00 %"
                            } else if !lbl2 {
                                cell?.currentNav2.text = "0.00 %"
                            } else if !lbl3 {
                                cell?.currentNav3.text = "0.00 %"
                            }
                        case 3 :
                            cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                            cell?.currentNav2.text = filterHoldSchemecode[1].holding.decimalString
                            cell?.currentNav3.text = filterHoldSchemecode[2].holding.decimalString
                        default:
                            break
                        }
                         cell?.label.text = "Equity"
                    case 1 :
                        let s_code1 = compareFundArr?.schemedet[0]["SCHEMECODE"] as? String
                        let s_code2 = compareFundArr?.schemedet[1]["SCHEMECODE"] as? String
                        let assetAllocationArr = compareFundArr?.assetAllocation
                        let filterHoldSchemecode = assetAllocationArr!.filter { $0.asset == "Debt"}
                        print(filterHoldSchemecode)
                        switch filterHoldSchemecode.count {
                        case 0 :
                            cell?.currentNav1.text = "0.00 %"
                            cell?.currentNav2.text = "0.00 %"
                            cell?.currentNav3.text = "0.00 %"
                        case 1 :
                            let holdSchemecode = filterHoldSchemecode[0].holdSchemecode
                            if holdSchemecode == s_code1 {
                                cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                                cell?.currentNav2.text = "0.00 %"
                                cell?.currentNav3.text = "0.00 %"
                            } else if holdSchemecode == s_code2 {
                                cell?.currentNav1.text = "0.00 %"
                                cell?.currentNav2.text = filterHoldSchemecode[0].holding.decimalString
                                cell?.currentNav3.text = "0.00 %"
                            } else{
                                cell?.currentNav1.text = "0.00 %"
                                cell?.currentNav2.text = "0.00 %"
                                cell?.currentNav3.text = filterHoldSchemecode[0].holding.decimalString
                            }
                        case 2 :
                            var lbl1 = false
                            var lbl2 = false
                            var lbl3 = false
                            for (index, object) in filterHoldSchemecode.enumerated() {
                                if object.holdSchemecode == s_code1{
                                    cell?.currentNav1.text = filterHoldSchemecode[index].holding.decimalString
                                    lbl1 = true
                                } else if object.holdSchemecode == s_code2{
                                    cell?.currentNav2.text = filterHoldSchemecode[index].holding.decimalString
                                    lbl2 = true
                                } else {
                                    cell?.currentNav3.text = filterHoldSchemecode[index].holding.decimalString
                                    lbl3 = true
                                }
                            }
                            if !lbl1 {
                                cell?.currentNav1.text = "0.00 %"
                            } else if !lbl2 {
                                cell?.currentNav2.text = "0.00 %"
                            } else if !lbl3 {
                                cell?.currentNav3.text = "0.00 %"
                            }
                        case 3 :
                            cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                            cell?.currentNav2.text = filterHoldSchemecode[1].holding.decimalString
                            cell?.currentNav3.text = filterHoldSchemecode[2].holding.decimalString
                        default:
                            break
                        }
                        cell?.label.text = "Debt"
                    case 2 :
                        let s_code1 = compareFundArr?.schemedet[0]["SCHEMECODE"] as? String
                        let s_code2 = compareFundArr?.schemedet[1]["SCHEMECODE"] as? String
                        let assetAllocationArr = compareFundArr?.assetAllocation
                        let filterHoldSchemecode = assetAllocationArr!.filter { $0.asset == "Others"}
                        print(filterHoldSchemecode)
                        switch filterHoldSchemecode.count {
                        case 0 :
                            cell?.currentNav1.text = "0.00 %"
                            cell?.currentNav2.text = "0.00 %"
                            cell?.currentNav3.text = "0.00 %"
                        case 1 :
                            let holdSchemecode = filterHoldSchemecode[0].holdSchemecode
                            if holdSchemecode == s_code1 {
                                cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                                
                                cell?.currentNav2.text = "0.00 %"
                                cell?.currentNav3.text = "0.00 %"
                            } else if holdSchemecode == s_code2 {
                                cell?.currentNav1.text = "0.00 %"
                                cell?.currentNav2.text = filterHoldSchemecode[0].holding.decimalString
                                cell?.currentNav3.text = "0.00 %"
                            } else{
                                cell?.currentNav1.text = "0.00 %"
                                cell?.currentNav2.text = "0.00 %"
                                cell?.currentNav3.text = filterHoldSchemecode[0].holding.decimalString
                            }
                        case 2 :
                            var lbl1 = false
                            var lbl2 = false
                            var lbl3 = false
                            for (index, object) in filterHoldSchemecode.enumerated() {
                                if object.holdSchemecode == s_code1{
                                    cell?.currentNav1.text = filterHoldSchemecode[index].holding.decimalString
                                    lbl1 = true
                                } else if object.holdSchemecode == s_code2{
                                    cell?.currentNav2.text = filterHoldSchemecode[index].holding.decimalString
                                    lbl2 = true
                                } else {
                                    cell?.currentNav3.text = filterHoldSchemecode[index].holding.decimalString
                                    lbl3 = true
                                }
                            }
                            if !lbl1 {
                                cell?.currentNav1.text = "0.00 %"
                            } else if !lbl2 {
                                cell?.currentNav2.text = "0.00 %"
                            } else if !lbl3 {
                                cell?.currentNav3.text = "0.00 %"
                            }
                        case 3 :
                            cell?.currentNav1.text = filterHoldSchemecode[0].holding.decimalString
                            cell?.currentNav2.text = filterHoldSchemecode[1].holding.decimalString
                            cell?.currentNav3.text = filterHoldSchemecode[2].holding.decimalString
                        default:
                            break
                        }
                        cell?.label.text = "Others"
                    default :
                        print("Failed")
                    }
                default :
                    print("Failed")
                }
                return cell!
            } else {
               // cell?.currentNav1.text = NavTrend[indexPath.row]
                return cell!
            }
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == legendTableView {
            return 50
        } else if tableView == searchTableView {
            return 60
        } else if tableView == topHoldingTableView {
             return UITableViewAutomaticDimension
        }else {
            return 90
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == legendTableView {
            return colors.count
        } else if tableView == searchTableView {
            return filterSuggestionArr.count
        } else if tableView == topHoldingTableView {
            return compareFundArr1?.holdings.count ?? 0
        }else {
            if section == 0 {
                return  5
            } else if section == 1{
                return 5
            } else if section == 2{
                return 14
            }else if section == 3{
                return 3
            } else {
                return 0
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if tableView == searchTableView  || tableView == legendTableView || tableView == topHoldingTableView{
            return 1
        } else  {
            return 5
        }
            
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?{
        if tableView == searchTableView || tableView == legendTableView {
            return ""
        } else if tableView == topHoldingTableView {
             return "Top 5 Holdings"
        } else {
            if section == 0 {
                return "Nav Trend"
            } else if section == 1 {
                return "Performance History (CAGR)"
            } else if section == 2 {
                return "BASIC DETAILS"
            } else if section == 3 {
                return "Asset Allocation"
            } else {
                return "Top 5 Holdings & SECTOR ALLOCATION"
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == searchTableView{
            searchTf.text = filterSuggestionArr[indexPath.row].p_name
            slectedSearchIndex = filterSuggestionArr[indexPath.row].Scheme_code
            searchTf.resignFirstResponder()
            DispatchQueue.main.async {
                self.searchTableView.isHidden = true
            }
            
        } else {
            print("did select")
        }
    }
    @objc func textFieldDidChange(_ textField: UITextField) {
        if searchTf.text!.count > 2 {
            self.filterSuggestionArr = self.productArr.filter { $0.p_name!.lowercased().contains(searchTf.text!.lowercased()) }
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
    
    func comapreFund(id:[String]) {
        presentWindow.makeToastActivity(message: "Loading..")
        let parameters = ["id": id] as [String : Any]
        let url = "\(Constants.BASE_URL)\(Constants.API.showscheme)"
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(url)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                    self.presentWindow.hideToastActivity()
                    self.compareFundArr = try? JSONDecoder().decode(CompareFundObj.self, from: response.data!)
                    print(self.compareFundArr?.schemedet.count)
                    if self.compareFundArr?.schemedet.count != nil {
                        if self.compareFundArr!.schemedet.count == 3 {
                            self.fundName2.text = self.compareFundArr!.schemedet[1]["sname"] as? String
                            self.fundName1.text = self.compareFundArr!.schemedet[0]["sname"] as? String
                            self.fundName3.text = self.compareFundArr!.schemedet[2]["sname"] as? String
                            self.fundName3.isHidden = false
                            self.searchTf.isUserInteractionEnabled = false
                            self.addbuttonOutlet.isUserInteractionEnabled = false
                            self.maxFundLabelMsg.isHidden = false
                            self.heightConstraintForMaxLabel.constant = 20.33
                        } else {
                            self.fundName2.text = self.compareFundArr!.schemedet[1]["sname"] as? String
                            self.fundName1.text = self.compareFundArr!.schemedet[0]["sname"] as? String
                            //self.headerView3.isHidden = true
                            self.fundName3.isHidden = true
                            self.maxFundLabelMsg.isHidden = true
                            self.heightConstraintForMaxLabel.constant = 0
                        }
                        self.tableview.delegate = self
                        self.tableview.dataSource = self
                        self.tableview.reloadData()
                        self.presentWindow.hideToastActivity()
                    }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func comapreFund_holding(id:String) {
        presentWindow.makeToastActivity(message: "Loading..")
        let parameters = ["id": id] as [String : Any]
        let url = "\(Constants.BASE_URL)\(Constants.API.showscheme)"
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(url)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                    self.presentWindow.hideToastActivity()
                    self.compareFundArr1 = try? JSONDecoder().decode(CompareFundObj.self, from: response.data!)
                    print(self.compareFundArr1!.schemedet.count)
                    
                    self.topHoldingTableView.reloadData()
                    //self.presentWindow.hideToastActivity()
                    self.getSectorCharts(Scheme_code: id)
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func searchFund(text:String){
        let url = "\(Constants.BASE_URL)schemedata/schemedata_ws.php/searchfund?term=\(text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")"
        print(url)
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseString { response in
                self.searchFundArr = try? JSONDecoder().decode(SearchFundObj.self, from: response.data!)
                //searchFundArr?.append(id)
                if !self.searchFundArr!.isEmpty {
                   // if self.searchFundArr!.contains(where: { $0.value.contains("\(self.searchTf.text!)")}) {
                        self.searchTableView.isHidden = false
                        self.searchTableView.reloadData()
//                    } else {
//                        // not
                    self.searchTableView.isHidden = true
//                    }
                    
                }
                
            }
            
        }
    }
    @IBAction func crossButtonClick(_ sender: Any) {
        alphaView.isHidden = true
    }
    func setChart(dataPoints: [String], values: [Double]) {
        print(dataPoints.count)
        print(colors_random.count)
        print(colors_random)
        print(values)
        var chartDataEntries: [ChartDataEntry] = []
        pieChartView.holeRadiusPercent = 0.3
        pieChartView.transparentCircleRadiusPercent = 0
        pieChartView.chartDescription?.text = ""
        pieChartView.legend.enabled = false
        pieChartView.notifyDataSetChanged()
        
        for i in 0..<dataPoints.count {
            let chartDataEntry = PieChartDataEntry(value : values[i], label: dataPoints[i])
            chartDataEntries.append(chartDataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: chartDataEntries, label: "")
        _ = [ NSAttributedStringKey.font: UIFont(name: "Helvetica Neue", size: 12.0)! ]
        pieChartDataSet.colors = colors
        
       
        
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        self.pieChartView.data = pieChartData
        pieChartView.drawEntryLabelsEnabled = false
        pieChartDataSet.drawValuesEnabled = false
        pieChartView.backgroundColor = UIColor.white
        legendTableView.delegate = self
        legendTableView.dataSource = self
        legendTableView.reloadData()
        legendTableView.flashScrollIndicators()
        
    }
    func getSectorCharts(Scheme_code:String){
        let parameters = ["id":"\(Scheme_code)"]
        months.removeAll()
        unitsSold.removeAll()
        colors.removeAll()
        assetArr.removeAll()
        if Connectivity.isConnectedToInternet{
            var count = 0
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.showschemeAsset)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                    //print(response.value!)
                    self.presentWindow.hideToastActivity()
                    if let data = response.result.value as? [AnyObject]{
                        if !data.isEmpty{
                            for type in data{
                                    let name = type.value(forKey: "name") as? String ?? "Slice"
                                    let value = type.value(forKey: "y") as? Double ?? 0.0
                                
                                    if value != 0 {
                                        let assetObj = AssetObj(name: name, y: value, is_selected: false, colors: self.colors_random[count], values: value)
                                        self.assetArr.append(assetObj)
                                        self.months.append(name)
                                        self.colors.append(self.colors_random[count])
                                        self.unitsSold.append(value)
                                    }
                                    count = count + 1
                                
                            }
                            self.setChart(dataPoints: self.months, values: self.unitsSold)
                        }
                    }
            }
                //print(self.names)
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    @IBAction func clearALLButtonClicked(_ sender: Any) {
        id.removeAll()
        delegate?.idReceived(id_received: id)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func buyButttonClicked(_ sender: UIButton) {
        let s_name = compareFundArr?.schemedet[sender.tag]["sname"] as? String ?? ""
        let s_code = compareFundArr?.schemedet[sender.tag]["SCHEMECODE"] as? String ?? ""
        
        print(s_name)
        let index = self.Scheme_code_arr?.index(of: s_code)
        print(index," index")
        let alert = UIAlertController(title: "Alert", message: "Do you want buy \(s_name)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
            //self.navigationController?.popViewController(animated: true)
        if let index = index{
            if self.SIPAvailable?[index] == "T"{
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "StartSIPViewController") as! StartSIPViewController
               
//            destVC.p_name = self.p_name_arr?[sender.tag] ?? ""
//            destVC.c_nav = self.c_nav_arr?[sender.tag] ?? ""
//            destVC.OPT_code = self.OPT_code_arr?[sender.tag] ?? ""
//            destVC.row = self.row?[sender.tag] ?? 0
//            destVC.bseschemetype = self.bseschemetype_arr?[sender.tag] ?? ""
//            destVC.Scheme_code = self.Scheme_code_arr?[sender.tag] ?? ""
//            destVC.sipfreqs = self.sipfreqs_arr?[sender.tag] ?? ""
//            destVC.allsipamounts1 = self.allsipamounts1_arr?[sender.tag] ?? ""
//            destVC.MAXINVT = self.MAXINVT_arr?[sender.tag] ?? ""
//            destVC.scheme_ids = self.id
               
                destVC.p_name = self.p_name_arr?[index] ?? ""
                destVC.c_nav = self.c_nav_arr?[index] ?? ""
                destVC.OPT_code = self.OPT_code_arr?[index] ?? ""
                destVC.row = self.row?[sender.tag] ?? 0
                destVC.bseschemetype = self.bseschemetype_arr?[index] ?? ""
                destVC.Scheme_code = self.Scheme_code_arr?[index] ?? ""
                destVC.sipfreqs = self.sipfreqs_arr?[index] ?? ""
                destVC.allsipamounts1 = self.allsipamounts1_arr?[index] ?? ""
                destVC.MAXINVT = self.MAXINVT_arr?[index] ?? ""
                destVC.scheme_ids = self.id
            //}
           self.navigationController?.pushViewController(destVC, animated: true)
                }
            else{
                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "lumpsumViewController") as! lumpsumViewController
//                destVC.p_name = self.p_name_arr?[sender.tag] ?? ""
//                destVC.C_NAV =  self.c_nav_arr?[sender.tag] ?? ""
//                destVC.OPT_code = self.OPT_code_arr?[sender.tag] ?? ""
//                destVC.row = self.row?[sender.tag] ?? 0
//                destVC.bseschemetype = self.bseschemetype_arr?[sender.tag] ?? ""
//                destVC.min_amount = self.lumpsumMin?[sender.tag] ?? ""
//                destVC.schemecode = self.Scheme_code_arr?[sender.tag] ?? ""
                //if let index = index{
                destVC.p_name = self.p_name_arr?[index] ?? ""
                destVC.C_NAV =  self.c_nav_arr?[index] ?? ""
                destVC.OPT_code = self.OPT_code_arr?[index] ?? ""
                destVC.row = self.row?[sender.tag] ?? 0
                destVC.bseschemetype = self.bseschemetype_arr?[index] ?? ""
                destVC.min_amount = self.lumpsumMin?[index] ?? ""
                destVC.schemecode = self.Scheme_code_arr?[index] ?? ""
           // }
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        }
            }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { alert in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func buy2ButtonClicked(_ sender: UIButton) {
        let s_name = compareFundArr?.schemedet[sender.tag]["sname"] as? String ?? ""
        print(s_name)
         let s_code = compareFundArr?.schemedet[sender.tag]["SCHEMECODE"] as? String ?? ""
        let index = self.Scheme_code_arr?.index(of: s_code)
        print(index," index")
        
        let alert = UIAlertController(title: "Alert", message: "Do you want buy \(s_name)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
           //self.navigationController?.popViewController(animated: true)
            if let index = index{
            if self.SIPAvailable?[index] == "T"{
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "StartSIPViewController") as! StartSIPViewController
            destVC.p_name = self.p_name_arr?[index] ?? ""
            destVC.c_nav = self.c_nav_arr?[index] ?? ""
            destVC.OPT_code = self.OPT_code_arr?[index] ?? ""
            destVC.row = self.row?[index] ?? 0
            destVC.bseschemetype = self.bseschemetype_arr?[index] ?? ""
            destVC.Scheme_code = self.Scheme_code_arr?[index] ?? ""
            destVC.sipfreqs = self.sipfreqs_arr?[index] ?? ""
            destVC.allsipamounts1 = self.allsipamounts1_arr?[index] ?? ""
            destVC.MAXINVT = self.MAXINVT_arr?[index] ?? ""
             destVC.scheme_ids = self.id
            self.navigationController?.pushViewController(destVC, animated: true)
            }else{
                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "lumpsumViewController") as! lumpsumViewController
                destVC.p_name = self.p_name_arr?[index] ?? ""
                destVC.C_NAV =  self.c_nav_arr?[index] ?? ""
                destVC.OPT_code = self.OPT_code_arr?[index] ?? ""
                destVC.row = self.row?[index] ?? 0
                destVC.bseschemetype = self.bseschemetype_arr?[index] ?? ""
                destVC.min_amount = self.lumpsumMin?[index] ?? ""
                destVC.schemecode = self.Scheme_code_arr?[index] ?? ""
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        }
    }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { alert in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func buy1ButtonClicked(_ sender: UIButton
        ) {
        let s_name = compareFundArr?.schemedet[sender.tag]["sname"] as? String ?? ""
        print(s_name)
        let s_code = compareFundArr?.schemedet[sender.tag]["SCHEMECODE"] as? String ?? ""
        let index = self.Scheme_code_arr?.index(of: s_code)
        print(index," index")
        
        let alert = UIAlertController(title: "Alert", message: "Do you want buy \(s_name)", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { alert in
            //self.navigationController?.popViewController(animated: true)
       if let index = index{
            if self.SIPAvailable?[index] == "T"{
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "StartSIPViewController") as! StartSIPViewController
            destVC.p_name = self.p_name_arr?[index] ?? ""
            destVC.c_nav = self.c_nav_arr?[index] ?? ""
            destVC.OPT_code = self.OPT_code_arr?[index] ?? ""
            destVC.row = self.row?[index] ?? 0
            destVC.bseschemetype = self.bseschemetype_arr?[index] ?? ""
            destVC.Scheme_code = self.Scheme_code_arr?[index] ?? ""
            destVC.sipfreqs = self.sipfreqs_arr?[index] ?? ""
            destVC.allsipamounts1 = self.allsipamounts1_arr?[index] ?? ""
            destVC.MAXINVT = self.MAXINVT_arr?[index] ?? ""
             destVC.scheme_ids = self.id
            self.navigationController?.pushViewController(destVC, animated: true)
            }else{
                let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "lumpsumViewController") as! lumpsumViewController
                destVC.p_name = self.p_name_arr?[index] ?? ""
                destVC.C_NAV =  self.c_nav_arr?[index] ?? ""
                destVC.OPT_code = self.OPT_code_arr?[index] ?? ""
                destVC.row = self.row?[index] ?? 0
                destVC.bseschemetype = self.bseschemetype_arr?[index] ?? ""
                destVC.min_amount = self.lumpsumMin?[index] ?? ""
                destVC.schemecode = self.Scheme_code_arr?[index] ?? ""
                self.navigationController?.pushViewController(destVC, animated: true)
            }
        }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: { alert in
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func getFirstPage(){
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
                        self.presentWindow?.hideToastActivity()
                    } else{
                        self.presentWindow?.hideToastActivity()
                        
                    }
            }
        } else{
            self.presentWindow?.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
}
class compareFundCell:  UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var currentNav1: UILabel!
    @IBOutlet weak var currentNav3: UILabel!
    @IBOutlet weak var currentNav2: UILabel!
    @IBOutlet weak var view3: UIView!
    @IBOutlet weak var view2: UIView!
    @IBOutlet weak var view1: UIView!
    @IBOutlet weak var mainLabel: NSLayoutConstraint!
    
    
}
class holdingCell:  UITableViewCell {
    
    @IBOutlet weak var holdingLabel: UILabel!
    @IBOutlet weak var sectorLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
}
class legendDetailCell : UITableViewCell
{
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var legendName: UILabel!
    @IBOutlet weak var legendPrice: UILabel!
    
}
