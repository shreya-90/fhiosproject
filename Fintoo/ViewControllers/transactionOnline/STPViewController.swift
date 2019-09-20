//
//  STPViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 11/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import DropDown
import  FSCalendar
import Alamofire
import Mixpanel
class STPViewController: BaseViewController,FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource,FSCalendarDelegateAppearance {
    
    var SI_t_id : Int!
   var transactionArrs = [String]()
    var swpcid : String!
    var no_of_units : String!
    var curr_value : String!
    var units = ""
    var toSchemeID = ""
    var similarFundLsitArr = [SimilarFundSchemeList]()
    var mininvest : String!
    var selectAction : String!
    var SchemeName : String!
    var Schemecode : String!
    var acc_no : String!
    var folio_no : String!
    var bank_acc_no_from_bank_list = [String: [String:String]]()
    var bank_id : String!
    var dateArr = [String]()
    var trxnnumber : String!
    var row : Int!
    var stptxnid : String!
    var stpcid : String!
    var bse_aof_status_code = ""
    var bse_reg_code = ""
    var SO_t_id : Int!
    var minredeemUnit = ""
    var minredeemAmt = ""
    var toMININVT = "0"
    var curr_nav = ""
    var swptxnid = ""
    @IBOutlet weak var selectActionTableView: UITableView!
    @IBOutlet weak var stpFrequencyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var monthlyTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var label_units: UILabel!
    
    @IBOutlet weak var stpPeriodFromTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var toSchemeTableView: UITableView!
    @IBOutlet weak var selectActionTf: UITextField!
    @IBOutlet weak var schemeNameTF: UITextField!
    
    @IBOutlet weak var schemeAmount: UITextField!
    @IBOutlet weak var toSchemeTf: UITextField!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var periodFrom: UITextField!
    @IBOutlet weak var calendar1: FSCalendar!
    
    @IBOutlet weak var periodToTf: UITextField!
    @IBOutlet weak var submitBtnOutlet: NSLayoutConstraint!
    
    let dropDownSelectAction = DropDown()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addBackbutton()
        let swptxnid1 = UserDefaults.standard.value(forKey: "swptxnid") as? String ?? ""
        if swptxnid1 != "" {
            swptxnid = swptxnid1
        }
        schemeNameTF.text = SchemeName
        selectActionTf.text = selectAction
        label_units.text = "Your max amount to start STP from this folio is Rs. \(curr_value!)"
        //toSchemeTF.text = toScheme
        selectActionTableView.delegate = self
        selectActionTableView.dataSource = self
        
        toSchemeTableView.delegate = self
        toSchemeTableView.dataSource = self
        
       // fetchSchemeName(s_code: Schemecode!)
        getBankId()
        print(bank_acc_no_from_bank_list)
        print(acc_no)
         //bank_id = bank_acc_no_from_bank_list[acc_no]!["bank_id"]
        calendar.delegate = self
        calendar.dataSource = self
        calendar1.delegate = self
        calendar1.dataSource = self
        //print(transactionArr)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "STP Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
        destVC.selectIndexValue = true
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    @IBAction func selectActionBtnPrsd(_ sender: UIButton) {
        selectActionTableView.isHidden = !selectActionTableView.isHidden
       // selectActionTableView.isHidden = true
//        self.dropDownSelectAction.anchorView = sender
//        self.dropDownSelectAction.dataSource = self.transactionArrs
//        self.dropDownSelectAction.direction = .bottom
//        self.dropDownSelectAction.selectionAction = { [unowned self] (index: Int, item: String) in
//            self.selectActionTf.text = item
//            if self.selectActionTf.text  == "Additional Purchase"{
//                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "AdditionalPurchaseViewController") as! AdditionalPurchaseViewController
//                destVC.transactionArrs = transactionArr[self.row].valid_for
//                destVC.selectAction = "Additional Purchase"
//                destVC.SchemeName = transactionArr[self.row].scheme_name
//                destVC.Schemecode = transactionArr[self.row].schemecode
//                destVC.acc_no = transactionArr[self.row].account_no
//                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
//                destVC.folio_no = transactionArr[self.row].folio_no
//                destVC.no_of_units = transactionArr[self.row].no_of_units!
//                destVC.curr_value = transactionArr[self.row].curr_value1
//                destVC.trxnnumber = transactionArr[self.row].trxnnumber
//                destVC.mininvest = transactionArr[self.row].mininvest
//                destVC.self.row = self.row
//                destVC.swpcid = transactionArr[self.row].swpcid
//                destVC.stptxnid = transactionArr[self.row].stptxnid
//                destVC.stpcid = transactionArr[self.row].stpcid
//                self.navigationController?.pushViewController(destVC, animated: true)
//            }
//            else if self.selectActionTf.text == "Redeem"{
//                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "ReedemViewController") as! ReedemViewController
//                destVC.transactionArrs = transactionArr[self.row].valid_for
//                destVC.selectAction = "Redeem"
//                destVC.SchemeName = transactionArr[self.row].scheme_name
//                destVC.Schemecode = transactionArr[self.row].schemecode
//                destVC.acc_no = transactionArr[self.row].account_no
//                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
//                destVC.folio_no = transactionArr[self.row].folio_no
//                destVC.no_of_units = transactionArr[self.row].no_of_units!
//                destVC.curr_value = transactionArr[self.row].curr_value1
//                destVC.trxnnumber = transactionArr[self.row].trxnnumber
//                destVC.mininvest = transactionArr[self.row].mininvest
//                destVC.self.row = self.row
//                destVC.swpcid = transactionArr[self.row].swpcid
//                destVC.stptxnid = transactionArr[self.row].stptxnid
//                destVC.stpcid = transactionArr[self.row].stpcid
//                self.navigationController?.pushViewController(destVC, animated: true)
//            }
//            else if self.selectActionTf.text  == "Switch"{
//                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "transactSwitchViewController") as! transactSwitchViewController
//                destVC.transactionArrs = transactionArr[self.row].valid_for
//                destVC.selectAction = "Switch"
//                destVC.SchemeName = transactionArr[self.row].scheme_name
//                destVC.Schemecode = transactionArr[self.row].schemecode
//                destVC.acc_no = transactionArr[self.row].account_no
//                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
//                destVC.folio_no = transactionArr[self.row].folio_no
//                destVC.no_of_units = transactionArr[self.row].no_of_units!
//                destVC.curr_value = transactionArr[self.row].curr_value1
//                destVC.trxnnumber = transactionArr[self.row].trxnnumber
//                destVC.mininvest = transactionArr[self.row].mininvest
//                destVC.self.row = self.row
//                destVC.swpcid = transactionArr[self.row].swpcid
//                destVC.stptxnid = transactionArr[self.row].stptxnid
//                destVC.stpcid = transactionArr[self.row].stpcid
//                self.navigationController?.pushViewController(destVC, animated: true)
//            }
//            else if self.selectActionTf.text  == "Stop STP"{
//                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSTPViewController") as! StopSTPViewController
//                destVC.transactionArrs = transactionArr[self.row].valid_for
//                destVC.selectAction = "Stop STP"
//                destVC.SchemeName = transactionArr[self.row].scheme_name
//                destVC.Schemecode = transactionArr[self.row].schemecode
//                destVC.acc_no = transactionArr[self.row].account_no
//                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
//                destVC.folio_no = transactionArr[self.row].folio_no
//                destVC.no_of_units = transactionArr[self.row].no_of_units!
//                destVC.curr_value = transactionArr[self.row].curr_value1
//                destVC.trxnnumber = transactionArr[self.row].trxnnumber
//                destVC.self.row = self.row
//                destVC.mininvest = transactionArr[self.row].mininvest
//                destVC.swpcid = transactionArr[self.row].swpcid
//                destVC.stptxnid = transactionArr[self.row].stptxnid
//                destVC.stpcid = transactionArr[self.row].stpcid
//                self.navigationController?.pushViewController(destVC, animated: true)
//            }
//            else if self.selectActionTf.text == "Stop SWP"{
//                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSWPViewController") as! StopSWPViewController
//                destVC.transactionArrs = transactionArr[self.row].valid_for
//                destVC.selectAction = "Stop SWP"
//                destVC.SchemeName = transactionArr[self.row].scheme_name
//                destVC.Schemecode = transactionArr[self.row].schemecode
//                destVC.acc_no = transactionArr[self.row].account_no
//                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
//                destVC.folio_no = transactionArr[self.row].folio_no
//                destVC.no_of_units = transactionArr[self.row].no_of_units!
//                destVC.curr_value = transactionArr[self.row].curr_value1
//                destVC.trxnnumber = transactionArr[self.row].trxnnumber
//                destVC.self.row = self.row
//                destVC.mininvest = transactionArr[self.row].mininvest
//                destVC.swpcid = transactionArr[self.row].swpcid
//                destVC.stptxnid = transactionArr[self.row].stptxnid
//                destVC.stpcid = transactionArr[self.row].stpcid
//                self.navigationController?.pushViewController(destVC, animated: true)
//            }
//            else if self.selectActionTf.text == "Stop SIP"{
//                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSIPViewController") as! StopSIPViewController
//                destVC.transactionArrs = transactionArr[self.row].valid_for
//                destVC.selectAction = "Stop SIP"
//                destVC.SchemeName = transactionArr[self.row].scheme_name
//                destVC.Schemecode = transactionArr[self.row].schemecode
//                destVC.acc_no = transactionArr[self.row].account_no
//                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
//                destVC.folio_no = transactionArr[self.row].folio_no
//                destVC.no_of_units = transactionArr[self.row].no_of_units!
//                destVC.curr_value = transactionArr[self.row].curr_value1
//                destVC.trxnnumber = transactionArr[self.row].trxnnumber
//                destVC.self.row = self.row
//                destVC.mininvest = transactionArr[self.row].mininvest
//                destVC.swpcid = transactionArr[self.row].swpcid
//                destVC.stptxnid = transactionArr[self.row].stptxnid
//                destVC.stpcid = transactionArr[self.row].stpcid
//                self.navigationController?.pushViewController(destVC, animated: true)
//            }
//            else if self.selectActionTf.text == "Start SWP"{
//                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                let destVC = storyBoard.instantiateViewController(withIdentifier: "StartSWPViewController") as! StartSWPViewController
//                destVC.transactionArrs = transactionArr[self.row].valid_for
//                destVC.selectAction = "Start SWP"
//                destVC.SchemeName = transactionArr[self.row].scheme_name
//                destVC.Schemecode = transactionArr[self.row].schemecode
//                destVC.acc_no = transactionArr[self.row].account_no
//                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
//                destVC.folio_no = transactionArr[self.row].folio_no
//                destVC.no_of_units = transactionArr[self.row].no_of_units!
//                destVC.curr_value = transactionArr[self.row].curr_value1
//                destVC.trxnnumber = transactionArr[self.row].trxnnumber
//                destVC.self.row = self.row
//                destVC.mininvest = transactionArr[self.row].mininvest
//                destVC.swpcid = transactionArr[self.row].swpcid
//                destVC.stptxnid = transactionArr[self.row].stptxnid
//                destVC.stpcid = transactionArr[self.row].stpcid
//                self.navigationController?.pushViewController(destVC, animated: true)
//            }
//            else if self.selectActionTf.text  == "Start STP"{
//
//
//            }
//        }
//        self.dropDownSelectAction.show()
    }
    
    @IBOutlet weak var toSchemeBtnPrsd: UIButton!
    
    @IBAction func toSchemeBtnPrsd(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "STP Screen :- To Scheme Button Clicked")
        self.toSchemeTableView.isHidden = !self.toSchemeTableView.isHidden
       // self.selectActionTableView.isHidden = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "TRANSACT ONLINE"
        if UIDevice().screenType == .iPhone5 {
            submitBtnOutlet.constant = 30.0
            topConstraint.constant = 4
        } else{
            submitBtnOutlet.constant = 40.0
            topConstraint.constant = 24
            stpFrequencyTopConstraint.constant = 10
            stpPeriodFromTopConstraint.constant = 12
            monthlyTopConstraint.constant =  7
        }
        
    }
    @IBAction func periodFrom(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "STP Screen :- STP Period From Button Clicked")
        if sender.isSelected{
            calendar1.isHidden = true
            calendar.isHidden = true
            sender.isSelected = false
        }else{
            calendar.isHidden = false
            calendar1.isHidden = true
            sender.isSelected = true
        }
    }
    @IBAction func periodTo(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "STP Screen :- STP Period To Button Clicked")
        if periodFrom.text != ""{
            if sender.isSelected {
                calendar1.isHidden = true
                calendar.isHidden = true
                sender.isSelected = false
            }
            else{
                calendar1.isHidden = false
                calendar.isHidden = true
                sender.isSelected = true
                
            }
        }
        else{
            Mixpanel.mainInstance().track(event: "STP Screen :- Please First Select STP From Date")
            presentWindow.makeToast(message: "Please First Select STP From Date")
        }
    }
    
    @IBAction func submitBtn(_ sender: Any) {
       //  calendar.isHidden = false
        if schemeAmount.text == "" {
            presentWindow.makeToast(message: "Please enter amount")
            Mixpanel.mainInstance().track(event: "STP Screen :- Please enter amount")
        } else if schemeAmount.text == "0"{
            presentWindow.makeToast(message: "Please enter amount")
            Mixpanel.mainInstance().track(event: "STP Screen :- Please enter amount")
        }
        else if Int(schemeAmount.text!)! > Int(truncating: curr_value.numberValue!){
            //  You have only 58854 Rs. to redeem from this folio
            presentWindow.makeToast(message: "You have only \(curr_value!) RS. to start STP from this folio")
            Mixpanel.mainInstance().track(event: "You have only \(curr_value!) RS. to start STP from this folio")
        }
        else if toSchemeTf.text == "Select"{
            presentWindow.makeToast(message: "Please Select STP To Scheme Name")
            Mixpanel.mainInstance().track(event: "Please Select STP To Scheme Name")
        }
        else if Int(schemeAmount.text!)! < Int(toMININVT)!{
            //  You have only 58854 Rs. to redeem from this folio
            presentWindow.makeToast(message: "You need minimum \(toMININVT) Rs. to switch into selected scheme")
            Mixpanel.mainInstance().track(event: "Switch Screen :- You have only \(toMININVT) RS. to switch from this folio")
        }
        else if periodFrom.text == ""{
            presentWindow.makeToast(message: "Please Select STP from date")
            Mixpanel.mainInstance().track(event: "Please Select STP from date")
        }
        else if periodToTf.text == ""{
            presentWindow.makeToast(message: "Please Select STP to date")
            Mixpanel.mainInstance().track(event: "Please Select STP to date")
        }
        
        else{
            var userid = UserDefaults.standard.value(forKey: "userid") as? String
            let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
            if flag != "0"{
                userid! = flag
                
            }
            else{
                // flag = "0"
                userid = UserDefaults.standard.value(forKey: "userid") as? String
            }
            _ = Date()
            let dateFormatter = DateFormatter()
            
            let userCalendar = Calendar.current
           
            let requestedComponent: Set<Calendar.Component> = [.month,.day,.year]
            dateFormatter.dateFormat = "dd-MM-yyyy"
            print(periodFrom.text!)
            let startTime = dateFormatter.date(from: "\(periodFrom.text!)")
            print(startTime ?? "startTime")
            let endTime = dateFormatter.date(from: "\(periodToTf.text!)")
            let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime!, to: endTime!)
            
            let totalInstallment = (timeDifference.year! * 12 ) + timeDifference.month!
            print(totalInstallment,"totalInstallment")
            print(totalInstallment - 1,"remaining_installment")
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            
            self.addtocart(id: self.Schemecode!, tenure: "", amount: self.schemeAmount.text!, type: "9", frequency: "Monthly", userid: "\(userid!)", sessionid: "\(sessionId!)", perpetual: "N", cartsipstart: dateFormatter1.string(from: startTime!), cartsipend: dateFormatter1.string(from: endTime!), total_installment: "\(totalInstallment)", remaining_installment: "\((totalInstallment))", SI_id: "")
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == selectActionTableView{
            return transactionArrs.count
        } else {
            return similarFundLsitArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == selectActionTableView{
            let cell  = tableView.dequeueReusableCell(withIdentifier: "selectAction", for: indexPath)
            cell.textLabel?.text = transactionArrs[indexPath.row]
            return cell
        } else {
            let cell  = tableView.dequeueReusableCell(withIdentifier: "toScheme", for: indexPath)
            cell.textLabel?.text = similarFundLsitArr[indexPath.row].scheme
            print(toSchemeID)
            cell.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
            cell.textLabel?.numberOfLines = 0;
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == selectActionTableView{
            let cell = tableView.cellForRow(at: indexPath)
            selectActionTf.text = cell?.textLabel?.text
            if self.selectActionTf.text  == "Additional Purchase"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "AdditionalPurchaseViewController") as! AdditionalPurchaseViewController
                destVC.transactionArrs = transactionArr[self.row].valid_for
                destVC.selectAction = "Additional Purchase"
                destVC.SchemeName = transactionArr[self.row].scheme_name
                destVC.Schemecode = transactionArr[self.row].schemecode
                destVC.acc_no = transactionArr[self.row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[self.row].folio_no
                destVC.no_of_units = transactionArr[self.row].no_of_units!
                destVC.curr_value = transactionArr[self.row].curr_value1
                destVC.trxnnumber = transactionArr[self.row].trxnnumber
                destVC.mininvest = transactionArr[self.row].mininvest
                destVC.self.row = self.row
                destVC.swpcid = transactionArr[self.row].swpcid
                destVC.stptxnid = transactionArr[self.row].stptxnid
                destVC.stpcid = transactionArr[self.row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if self.selectActionTf.text == "Redeem"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "ReedemViewController") as! ReedemViewController
                destVC.transactionArrs = transactionArr[self.row].valid_for
                destVC.selectAction = "Redeem"
                destVC.SchemeName = transactionArr[self.row].scheme_name
                destVC.Schemecode = transactionArr[self.row].schemecode
                destVC.acc_no = transactionArr[self.row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[self.row].folio_no
                destVC.no_of_units = transactionArr[self.row].no_of_units!
                destVC.curr_value = transactionArr[self.row].curr_value1
                destVC.trxnnumber = transactionArr[self.row].trxnnumber
                destVC.mininvest = transactionArr[self.row].mininvest
                destVC.self.row = self.row
                destVC.swpcid = transactionArr[self.row].swpcid
                destVC.stptxnid = transactionArr[self.row].stptxnid
                destVC.stpcid = transactionArr[self.row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if self.selectActionTf.text  == "Switch"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "transactSwitchViewController") as! transactSwitchViewController
                destVC.transactionArrs = transactionArr[self.row].valid_for
                destVC.selectAction = "Switch"
                destVC.SchemeName = transactionArr[self.row].scheme_name
                destVC.Schemecode = transactionArr[self.row].schemecode
                destVC.acc_no = transactionArr[self.row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[self.row].folio_no
                destVC.no_of_units = transactionArr[self.row].no_of_units!
                destVC.curr_value = transactionArr[self.row].curr_value1
                destVC.trxnnumber = transactionArr[self.row].trxnnumber
                destVC.mininvest = transactionArr[self.row].mininvest
                destVC.self.row = self.row
                destVC.swpcid = transactionArr[self.row].swpcid
                destVC.stptxnid = transactionArr[self.row].stptxnid
                destVC.stpcid = transactionArr[self.row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if self.selectActionTf.text  == "Stop STP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSTPViewController") as! StopSTPViewController
                destVC.transactionArrs = transactionArr[self.row].valid_for
                destVC.selectAction = "Stop STP"
                destVC.SchemeName = transactionArr[self.row].scheme_name
                destVC.Schemecode = transactionArr[self.row].schemecode
                destVC.acc_no = transactionArr[self.row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[self.row].folio_no
                destVC.no_of_units = transactionArr[self.row].no_of_units!
                destVC.curr_value = transactionArr[self.row].curr_value1
                destVC.trxnnumber = transactionArr[self.row].trxnnumber
                destVC.self.row = self.row
                destVC.mininvest = transactionArr[self.row].mininvest
                destVC.swpcid = transactionArr[self.row].swpcid
                destVC.stptxnid = transactionArr[self.row].stptxnid
                destVC.stpcid = transactionArr[self.row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if self.selectActionTf.text == "Stop SWP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSWPViewController") as! StopSWPViewController
                destVC.transactionArrs = transactionArr[self.row].valid_for
                destVC.selectAction = "Stop SWP"
                destVC.SchemeName = transactionArr[self.row].scheme_name
                destVC.Schemecode = transactionArr[self.row].schemecode
                destVC.acc_no = transactionArr[self.row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[self.row].folio_no
                destVC.no_of_units = transactionArr[self.row].no_of_units!
                destVC.curr_value = transactionArr[self.row].curr_value1
                destVC.trxnnumber = transactionArr[self.row].trxnnumber
                destVC.self.row = self.row
                destVC.mininvest = transactionArr[self.row].mininvest
                destVC.swpcid = transactionArr[self.row].swpcid
                destVC.stptxnid = transactionArr[self.row].stptxnid
                destVC.stpcid = transactionArr[self.row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if self.selectActionTf.text == "Stop SIP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSIPViewController") as! StopSIPViewController
                destVC.transactionArrs = transactionArr[self.row].valid_for
                destVC.selectAction = "Stop SIP"
                destVC.SchemeName = transactionArr[self.row].scheme_name
                destVC.Schemecode = transactionArr[self.row].schemecode
                destVC.acc_no = transactionArr[self.row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[self.row].folio_no
                destVC.no_of_units = transactionArr[self.row].no_of_units!
                destVC.curr_value = transactionArr[self.row].curr_value1
                destVC.trxnnumber = transactionArr[self.row].trxnnumber
                destVC.self.row = self.row
                destVC.mininvest = transactionArr[self.row].mininvest
                destVC.swpcid = transactionArr[self.row].swpcid
                destVC.stptxnid = transactionArr[self.row].stptxnid
                destVC.stpcid = transactionArr[self.row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if self.selectActionTf.text == "Start SWP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StartSWPViewController") as! StartSWPViewController
                destVC.transactionArrs = transactionArr[self.row].valid_for
                destVC.selectAction = "Start SWP"
                destVC.SchemeName = transactionArr[self.row].scheme_name
                destVC.Schemecode = transactionArr[self.row].schemecode
                destVC.acc_no = transactionArr[self.row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[self.row].folio_no
                destVC.no_of_units = transactionArr[self.row].no_of_units!
                destVC.curr_value = transactionArr[self.row].curr_value1
                destVC.trxnnumber = transactionArr[self.row].trxnnumber
                destVC.self.row = self.row
                destVC.mininvest = transactionArr[self.row].mininvest
                destVC.swpcid = transactionArr[self.row].swpcid
                destVC.stptxnid = transactionArr[self.row].stptxnid
                destVC.stpcid = transactionArr[self.row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if self.selectActionTf.text  == "Start STP"{
                
                
            }
        } else {
            let cell = toSchemeTableView.cellForRow(at: indexPath)
            toSchemeTf.text = cell?.textLabel?.text
            toSchemeID = similarFundLsitArr[indexPath.row].schemecode!
            toMININVT = similarFundLsitArr[indexPath.row].schemecode!
            toSchemeTableView.isHidden = true
        }
      //  }
    }
    
    func addtocart(id:String,tenure: String,amount:String,type:String,frequency:String, userid: String, sessionid:String, perpetual:String,cartsipstart:String,cartsipend : String,total_installment:String,remaining_installment:String,SI_id:String){
       
        let parameters = ["id":"\(id)","tenure":tenure.covertToBase64(),"amount":amount.covertToBase64(),"type":type.covertToBase64(),"frequency":frequency.covertToBase64(),"userid":userid.covertToBase64(),"sessionid":sessionid.covertToBase64(),"perpetual":perpetual.covertToBase64(),"cartsipstart":cartsipstart.covertToBase64(),"cartsipend":cartsipend.covertToBase64(),"total_installment":total_installment.covertToBase64(),"remaining_installment":remaining_installment.covertToBase64(),"enc_resp":"3"] as [String : Any]
        print(parameters,"")
        presentWindow.makeToastActivity(message: "Processing..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addtostpswpcart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    let cart_id1 = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                    let cart_id = Int(cart_id1!)
                    print(cart_id)
                    if cart_id != nil {
                    
                        if SI_id == "1"{
                             //presentWindow.hideToastActivity()
                            self.addtransaction(cart_id: cart_id!, user_id: userid, folio_no: "", bank_id: "\(self.bank_id!)", trxntype: "SIU", SI_id: "1", userid: userid, transaction_SI_for_SO: self.SI_t_id)
                            
                        }
                        else{
                            // presentWindow.hideToastActivity()
                           
                            self.addtransaction(cart_id: cart_id!, user_id: userid, folio_no: "\(self.folio_no!)", bank_id: "\(self.bank_id!)", trxntype: "SOU", SI_id: "", userid: userid, transaction_SI_for_SO: 0)
                        }
                    }
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    
    func addtransaction(cart_id:Int,user_id:String,folio_no:String,bank_id:String,trxntype:String,SI_id:String,userid:String,transaction_SI_for_SO:Int){
        
        
        // as [String : Any]
        
        //presentWindow.makeToastActivity(message: "Adding.")
        //addswpstptransaction
        let url = "transaction/transaction_ws.php/addswpstptransaction"
        
        //  txn_id="", user_id, cart_id = response from above web service, bank_id, status="", trxntype="SOU", trxndate=cartsipdate, transaction_folio_no
        //  txn_id="", user_id, cart_id = response from above web service, bank_id, status="", trxntype="SIU", trxndate=cartsipdate, transaction_folio_no,transaction_SI_for_SO = generated txn id from SOU
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let t_date  = dateFormatter.date(from: periodFrom.text!)
        let parameters = ["txn_id":"","user_id":"\(user_id.covertToBase64())","cart_id":"\(cart_id)","bank_id":"\(bank_id.covertToBase64())","status":"", "trxntype":"\(trxntype.covertToBase64())", "trxndate":"\(String(describing: dateFormatter1.string(from: t_date!)).covertToBase64())","transaction_folio_no":"\(folio_no.covertToBase64())","transaction_SI_for_SO":"\(transaction_SI_for_SO)","enc_resp" :"3"]
        print(parameters,"transaction>>>>>>")
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(url)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value!)
                    let transaction_id = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                    if let transactionid = Int(transaction_id!){
                        print(transactionid)

                        if SI_id == "1"{
//                            self.presentWindow.hideToastActivity()
//                            let name = UserDefaults.standard.value(forKey: "name") as? String
//                            let email = UserDefaults.standard.value(forKey: "Email") as? String
//                            let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
//                            self.sendSTPRequestEmailToUser(username: name!, email: email!, S_NAME: self.SchemeName!, transaction_date: "")
//                            self.sendSmsToUSer(mobile: phone!, transaction_date: "")
//                            let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
//                            let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as! PaymentSuccessViewController
//                            destVC.success = "STP Request Placed Successfully"
//                            destVC.titles = "STP Request"
//
//                            self.navigationController?.pushViewController(destVC, animated: true)
                            self.bseSTPRegistration(transaction_arr: "trnsarr[0]=\(self.SO_t_id!)&trnsarr[1]=\(transactionid)")
                          
                        }
                        else{
                            //self.presentWindow.hideToastActivity()
                            self.SI_t_id = transactionid
                            self.SO_t_id = transactionid
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            //print(periodFrom.text!)
                             let userCalendar = Calendar.current
                            let requestedComponent: Set<Calendar.Component> = [.month,.day,.year]
                            let startTime = dateFormatter.date(from: "\(self.periodFrom.text!)")
                            print(dateFormatter.date(from: "\(self.periodToTf.text!)") ?? "")
                            let endTime = dateFormatter.date(from: "\(self.periodToTf.text!)")
                            let dateFormatter1 = DateFormatter()
                            dateFormatter1.dateFormat = "yyyy-MM-dd"
                            let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime!, to: endTime!)
                             let totalInstallment = (timeDifference.year! * 12 ) + timeDifference.month!
                            self.addtocart(id: self.toSchemeID, tenure: "", amount: self.schemeAmount.text!, type: "8", frequency: "Monthly", userid: "\(userid)", sessionid: "\(sessionId!)", perpetual: "N", cartsipstart: dateFormatter1.string(from: startTime!), cartsipend: dateFormatter1.string(from: endTime!), total_installment: "\(totalInstallment)", remaining_installment: "\(totalInstallment)", SI_id: "1")
                        }
                    }
                    else{
                        self.presentWindow.hideToastActivity()
                    }
                    
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    

    func sendSTPRequestEmailToUser(username:String,email:String,S_NAME:String,transaction_date:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            
            //{
           
            let parameters = [
                "ToEmailID":"\(email.covertToBase64())",
                "FromEmailID":"",
                "Subject" :"\(covertToBase64(text: "Your Systematic Transfer Plan request submitted successfully - Fintoo"))",
                "template_name": "\(covertToBase64(text: "stpsuccess"))",
                "username":"\(username.covertToBase64())",
                "txn_date":"\(transaction_date.covertToBase64())",
                "table":"1",
                "scheme_name":"\(covertToBase64(text: "\(schemeNameTF.text ?? "") to \(toSchemeTf.text ?? "")"))",
                "scheme_type":"\(covertToBase64(text: "STP"))",
                "scheme_amount":"\(String(describing: schemeAmount.text!))",
                "enc_resp":"3"
                
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.templates)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    print(response.result.value ?? "value")
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                    }
                    let data = dict
                    if let response = data as? [[String: AnyObject]] {
                        let msg_code = response[0]["error"] as? String ?? ""
                        if msg_code != "" {
                            self.presentWindow!.makeToast(message: "Failed To Send Message On Mobile")
                        }
                        else{
                            print("Success")
                            self.sendSTPRequestEmailToSupport(username: username, email: email, S_NAME: S_NAME)
                        }
                    }
                    
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    
    //send suuport mail
    func sendSTPRequestEmailToSupport(username:String,email:String,S_NAME:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        //\(username) has made a Switch request on Fintoo
       
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "ToEmailID":"\(covertToBase64(text: "support@fintoo.in"))",
                "FromEmailID":"",
                "Subject" :"\(covertToBase64(text: "\(username) has made a STP request on Fintoo"))",
                "template_name": "\(covertToBase64(text: "stpsuccessonline"))",
                "email":"\(email.covertToBase64())",
                "username":"\(username.covertToBase64())",
                "table":"1",
                "scheme_name":"\(covertToBase64(text: "\(schemeNameTF.text ?? "") to \(toSchemeTf.text ?? "")"))",
                "scheme_type":"\(covertToBase64(text: "STP"))",
                "scheme_amount":"\(covertToBase64(text: "\(String(describing: schemeAmount.text!))"))",
                "enc_resp":"3"
                
            ]
            print(parameters)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.templates)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    print(response.result.value ?? "value")
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                    }
                    let data = dict
                    if let response = data as? [[String: AnyObject]] {
                        let msg_code = response[0]["error"] as? String ?? ""
                        if msg_code != "" {
                            self.presentWindow!.makeToast(message: "Failed To Send Message On Mobile")
                        }
                        else{
                            print("Success")
                        }
                    }
                    
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func sendSmsToUSer(mobile:String,transaction_date:String){
        //let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        //Your STP request (Ref No - >>Insert ref. No here<<) on Fintoo has been successfully placed on dd/mm/yyyy. You will receive the confirmation shortly. For any urgent query, call us directly on 9699 800600
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let c_date = Date()
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "mobile":"\(mobile)",
                "msg":"Your STP request on Fintoo has been successfully placed on \(dateFormatter1.string(from: c_date)). You will receive the confirmation shortly. For any urgent query, call us directly on 9699 800600.",
                "enc_resp":"3"
            ]
            print(parameters)
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_SMS)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: "\n" , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                        // self.PresentWindows.makeToast(message: "Please Enter A Valid Password")
                    }
                    let data = dict
                    if let response = data as? [[String: AnyObject]] {
                        let msg_code = String(response[0]["code"] as! Int)
                        print(msg_code)
                        if msg_code != Constants.ERROR_CODE_1701 {
                            self.presentWindow!.makeToast(message: "Failed To Send Message On Mobile")
                        }
                        else{
                            print("send message")
                        }
                    }
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    
    func fetchSchemeName(s_code:String){
        
        
        let url = "\(Constants.BASE_URL)\(Constants.API.showschemes)\(s_code)/app"
        
        print(url)
        //similarFundLsitArr.removeAll()
       // similarFundLsitArr.append(SimilarFundSchemeList.getSchemeFund(schemecode: "00", scheme: "Select"))
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                //print(response.result.value)
                
                if let data = response.result.value as? [AnyObject]{
                    if !data.isEmpty {
                    for type in data{
                        //print(data)
                        self.presentWindow.hideToastActivity()
                        if let  schemecode = type.value(forKey: "schemecode") as? String,
                            let scheme = type.value(forKey: "scheme") as? String{
                            let MININVT = type.value(forKey: "MININVT") as? String ?? "0"
                            self.similarFundLsitArr.append(SimilarFundSchemeList.getSchemeFund(schemecode: schemecode, scheme: scheme, MININVT: MININVT))
                            
                        }
                    }
                    // print(self.countriesArr)
                    }else {
                        self.similarFundLsitArr.append(SimilarFundSchemeList.getSchemeFund(schemecode: "0", scheme: "Select Scheme", MININVT: "0"))
                        
                        self.presentWindow.hideToastActivity()
                    }
                }
                //  self.cityTableView.reloadData()
                self.toSchemeTableView.reloadData()
            }
            
            
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func getBankId(){
        //http://www.erokda.in/adminpanel/settings/cutoffservice_ws.php/getShemecodeWBR/2766,ABBPV7175K,feed
        var userid = UserDefaults.standard.value(forKey: "userid")
        let pan = UserDefaults.standard.value(forKey: "pan") as? String
        if flag != "0"{
            userid! = flag
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        let pan1 = pan?.replacingOccurrences(of: "'", with: "")
        let url = "\(Constants.BASE_URL)settings/cutoffservice_ws.php/getShemecodeWBR/\(Schemecode!),\(pan1!),feed"
        print(url,"bank")
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                print(response.result.value)
                if let data = response.result.value as? [AnyObject]{
                    print(data.isEmpty)
                    if data.isEmpty != true{
                        for type in data{
                            if let bank_id_1 = type.value(forKey: "bank_id") as? String
                            {
                                print(bank_id_1)
                                print("$$$$$")
                                self.bank_id = bank_id_1
                                self.fetchSchemeName(s_code: self.Schemecode!)
                                if self.bse_reg_code != "Y"{
                                    self.clientregistrationBse(userid: userid as! String)
                                } else {
                                    self.presentWindow.hideToastActivity()
                                }
                            }
                        }
                    } else{
                        print("hello")
                    }
                }
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func minimumDate(for calendar: FSCalendar) -> Date {
        if calendar == calendar1 {
            guard let newDate = dateFormatter1.date(from: periodFrom.text!) else { return Date()}
            let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: newDate)!
            return nextMonthDate
        }
        return Date()
    
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
       if calendar == calendar1{
            let dateFormatter1 = DateFormatter()
        
            dateFormatter1.dateFormat = "dd-MM-yyyy"
            periodToTf.text = dateFormatter1.string(from: date)
            calendar1.isHidden = true
        
        }
        else {
           let calendar1 = NSCalendar.current
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MM-yyyy"
            periodFrom.text = dateFormatter1.string(from: date)
        
            let abc = calendar1.date(byAdding: .year, value: 10, to: dateFormatter1.date(from: periodFrom.text!)!)
            print(abc ?? "hello")
            let secondDate = dateFormatter1.string(from: abc!)
            print(secondDate)
        
        
            var date = dateFormatter1.date(from: periodFrom.text!)!
            let endDate = dateFormatter1.date(from: secondDate)!
            let fmt = DateFormatter()
            fmt.dateFormat = "dd-MM-yyyy"
            dateArr.removeAll()
            while date <= endDate {
               // print(fmt.string(from: date))
                date = calendar1.date(byAdding: .day, value: 1, to: date)!
                let date1Day = calendar1.component(.day, from: date)
                let date2Day = calendar1.component(.day, from: dateFormatter1.date(from: periodFrom.text!)!)
                
                if date1Day != date2Day {
                    
                    let strDate = dateFormatter1.string(from: date)
                    self.dateArr.append(strDate)
                }
            }
            self.calendar1.reloadData()
            calendar.isHidden = true
        }
        //  datetf.resignFirstResponder()
    }
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if calendar == calendar1{
            let dateString = dateFormatter1.string(from:date)
            
            if self.dateArr.contains(dateString)
            {
                return UIColor.darkGray
            } else {
                return nil
            }
        }
        else{
            return nil
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if calendar == calendar1{
            let dateString = dateFormatter1.string(from:date)
            print(dateArr)
            if !dateArr.contains(dateString) {
                return true
            } else {
                return false
            }
        }
        else {
            return true
        }
    }
    var somedays : Array = [String]()
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    // BSE API
    
    func clientregistrationBse(userid:String){
        print("Modify ucc data")
        let url = "\(Constants.BASE_URL)\(Constants.API.clientregistration)\(userid)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value as? [String:Any]
                if let response_status = data?["response"] {
                    if data?["status"] != nil && data?["status"] as? String == "Error" {
                        self.presentWindow.hideToastActivity()
                        let bse_err_msg =  data?["bse_err_msg"] as? String ?? "FAIL"
                        
                        let alert = UIAlertController(title: "Alert", message: "", preferredStyle: UIAlertControllerStyle.alert)
                        alert.setValue(bse_err_msg.htmlToAttributedString, forKey: "attributedMessage")
                        
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                            print("Ok button clicked")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                            self.navigationController?.pushViewController(controller, animated: true)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    } else  {
                        //fatca called after success ucc else no required.
                        self.fatcaUploadBse(userid: userid)
                    }
                }
            }
        } else {
            
        }
    }
    func fatcaUploadBse(userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.FATCAUpload)\(userid)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                let data =  response.result.value as? [String:Any]
                if data?["bse_err_status"] != nil && data?["bse_err_status"] as? String  == "FAIL" {
                    self.presentWindow.hideToastActivity()
                    let alert = UIAlertController(title: "Alert", message: "\(data!["bse_err_status"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                        print("Ok button clicked")
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let controller = storyboard.instantiateViewController(withIdentifier: "PersonalDetailViewController") as! PersonalDetailViewController
                        self.navigationController?.pushViewController(controller, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    if self.bse_aof_status_code != "1" {
                        self.AOFImageUpload(userid: userid)
                    }else {
                    }
                }
            }
        } else {
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func AOFImageUpload(userid:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.AOFImageUpload)\(userid)"
        print(url)
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseJSON { response in
                let data = response.result.value as? [String:String]
                if data?["bse_err_status"] != nil && data?["bse_err_status"]  == "FAIL" {
                    self.presentWindow.hideToastActivity()
                    let alert = UIAlertController(title: "Alert", message: "\(data!["bse_err_status"] ?? "Error occurred")", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                        print("Ok button clicked")
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "UserDataViewController") as! UserDataViewController
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else {
                    self.presentWindow.hideToastActivity()
                    //self.presentWindow.makeToast(message: "AOF Uploaded Successfully")
                }
                
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow!.makeToast(message: "Internet Connection not Available")
        }
    }
    func bseSTPRegistration(transaction_arr:String){
        let url = "\(Constants.BASE_URL)\(Constants.API.STPRegistration)\(transaction_arr)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                print(response.result.value as? [String:Any])
                let data = response.result.value as? [String:Any]
                if let bse_reg_status = data?["bse_err_status"] as? String{
                    if bse_reg_status != "FAIL" {
                        self.presentWindow.hideToastActivity()
                        let name = UserDefaults.standard.value(forKey: "name") as? String
                        let email = UserDefaults.standard.value(forKey: "Email") as? String
                        let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
                        self.sendSTPRequestEmailToUser(username: name!, email: email!, S_NAME: self.SchemeName!, transaction_date: "")
                        self.sendSmsToUSer(mobile: phone!, transaction_date: "")
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as! PaymentSuccessViewController
                        destVC.success = "STP Request Placed Successfully"
                        destVC.titles = "STP Request"

                        self.navigationController?.pushViewController(destVC, animated: true)
                    } else {
                        self.presentWindow.hideToastActivity()
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                        destVC.success = "STP Request Placed Unsuccessfully"
                        destVC.titles = "STP Request"
                        destVC.id = "2"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                } else {
                    
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
}

