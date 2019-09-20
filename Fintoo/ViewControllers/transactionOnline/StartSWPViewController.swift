//
//  StartSWPViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 18/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import  FSCalendar
import Mixpanel

class StartSWPViewController: BaseViewController,FSCalendarDelegate,FSCalendarDataSource,UITableViewDelegate,UITableViewDataSource,FSCalendarDelegateAppearance{
    @IBOutlet weak var periodFrom: UITextField!
    
    @IBOutlet weak var label_units: UILabel!
    @IBOutlet weak var periodToTf: UITextField!
    
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBOutlet weak var calendar1: FSCalendar!
    
    @IBOutlet weak var submitBtnTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var submitBtnHeight: NSLayoutConstraint!
    var transactionArrs = [String]()
    var selectAction : String!
    var SchemeName : String!
    var Schemecode : String!
    var trxnnumber : String!
    var acc_no : String!
    var folio_no : String!
    var bank_acc_no_from_bank_list = [String: [String:String]]()
    var bank_id : String!
    var row : Int!
    var no_of_units : String!
    var curr_value : String!
    var swp_start_date  = "0"
    var swpcid : String!
    var stptxnid : String!
    var stpcid : String!
    var mininvest : String!
    var bse_aof_status_code = ""
    var bse_reg_code = ""
    var minredeemUnit = ""
    var minredeemAmt = ""
    var curr_nav = ""
    var swptxnid = ""
    @IBOutlet weak var selectActionTableview: UITableView!
    @IBOutlet weak var selectActiontf: UITextField!
    @IBOutlet weak var schemeNameTf: UITextField!
    @IBOutlet weak var amountTf: UITextField!
    @IBOutlet weak var monthltTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var PeriodFropmTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var swpDateTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var periodToTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(bank_id)
        addBackbutton()
        let swptxnid1 = UserDefaults.standard.value(forKey: "swptxnid") as? String ?? ""
        if swptxnid1 != "" {
            swptxnid = swptxnid1
        }
        selectActiontf.text =  selectAction!
        schemeNameTf.text = SchemeName
        label_units.text = "Your max amount to start SWP from this folio is Rs. \(curr_value!)"
        //bank_id = bank_acc_no_from_bank_list[acc_no]!["bank_id"]
        selectActionTableview.delegate = self
        selectActionTableview.dataSource = self
        
        getBankId()
        calendar.delegate = self
        calendar.dataSource = self
        calendar1.delegate = self
        calendar1.dataSource = self
       
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = "TRANSACT ONLINE"
        if UIDevice().screenType == .iPhone5 {
            submitBtnHeight.constant = 35.0
        } else{
            monthltTopConstraint.constant = 10
            swpDateTopConstraint.constant = 10
            PeriodFropmTopConstraint.constant = 10
            periodToTopConstraint.constant = 10
            submitBtnTopConstraint.constant = 25
            
        }
    }
    override func onBackButtonPressed(_ sender: UIButton) {
       Mixpanel.mainInstance().track(event: "Start SWP Screen :- Back Button Clicked")
        let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
        destVC.selectIndexValue = true
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    
   
    
    @IBAction func submit(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Start SWP Screen :- Submit Button Clicked")
        calendar.isHidden = true
        calendar1.isHidden = true
        var userid = UserDefaults.standard.value(forKey: "userid") as? String
        let sessionId = UserDefaults.standard.value(forKey: "sessionId") as? String
        if flag != "0"{
            userid! = flag
            
        }
        else{
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        if amountTf.text == ""{
           presentWindow.makeToast(message: "Please enter SWP Investment amount")
           Mixpanel.mainInstance().track(event: "Start SWP Screen :- Please enter SWP Investment amount")
        }else if amountTf.text == "0"{
            presentWindow.makeToast(message: "Please enter SWP Investment amount")
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- Please enter SWP Investment amount")
        }else if Int(amountTf.text!)! >  Int(Double(curr_value!)!) {
            presentWindow.makeToast(message: "You have only \(curr_value!) Rs. to start SWP from this folio")
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- You have only \(curr_value!) Rs. to start SWP from this folio")
        }else if swp_start_date == "0"{
            presentWindow.makeToast(message: "Please select SWP date")
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- Please select SWP date")
         }
 //           else if Int(amountTf.text!)! < Int(minredeemAmt)! {
//            presentWindow.makeToast(message: "You need minimum \(minredeemAmt) Rs. to SWP into selected scheme")
//            Mixpanel.mainInstance().track(event: "Redeem Screen :- You need minimum \(minredeemAmt) Rs. to redeem into selected scheme")
//        }
        else if perpetualbtn.currentImage == #imageLiteral(resourceName: "check-blue"){
            _ = Date()
            let dateFormatter = DateFormatter()
            
            let userCalendar = Calendar.current
            
            let requestedComponent: Set<Calendar.Component> = [.month,.day,.year]
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let st_date = dateFormatter.string(from: Date())
            let startTime = dateFormatter.date(from: "\(st_date)")
            print(startTime ?? "start time")
            let endTime = Calendar.current.date(byAdding: .year, value: 60, to: startTime!)
            print(dateFormatter.string(from: endTime!),"end time")
            let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime!, to: endTime!)
            let totalInstallment = (timeDifference.year! * 12 ) + timeDifference.month!
            print(totalInstallment,"totalInstallment")
            print(totalInstallment - 1,"remaining_installment")
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "yyyy-MM-dd"
            self.addtocart(id: self.Schemecode!, tenure: "", amount: self.amountTf.text!, type: "7", frequency: "Monthly", userid: "\(userid!)", sessionid: "\(sessionId!)", perpetual: "Y", cartsipstart: dateFormatter1.string(from: startTime!), cartsipend: dateFormatter1.string(from: endTime!), total_installment: "\(totalInstallment)", remaining_installment: "\((totalInstallment - 1))", SI_id: "")
        }
        else if periodFrom.text == ""{
            if perpetualbtn.currentImage == #imageLiteral(resourceName: "check-blue"){
                
            }else{
                presentWindow.makeToast(message: "Please Select SWP From Date")
                Mixpanel.mainInstance().track(event: "Start SWP Screen :- Please Select SWP From Date")
            }
        }else if periodToTf.text == ""{
            if perpetualbtn.currentImage == #imageLiteral(resourceName: "check-blue"){
                
            }else{
                presentWindow.makeToast(message: "Please Select SWP To Date")
                Mixpanel.mainInstance().track(event: "Start SWP Screen :- Please Select SWP To Date")
            }
            
        }else{
        
        _ = Date()
        let dateFormatter = DateFormatter()
        
        let userCalendar = Calendar.current
        
        let requestedComponent: Set<Calendar.Component> = [.month,.day,.year]
        dateFormatter.dateFormat = "dd-MM-yyyy"
       print(periodFrom.text!)
        print(swp_start_date)
            
            let startTime = dateFormatter.date(from: "\(swp_start_date)-\(String(describing: periodFrom.text!))")
            print(startTime ?? "start time")
            let endTime = dateFormatter.date(from: "\(swp_start_date)-\(String(describing: periodToTf.text!))")
        print(endTime ?? "end time")
        let timeDifference = userCalendar.dateComponents(requestedComponent, from: startTime!, to: endTime!)
        
        let totalInstallment = (timeDifference.year! * 12 ) + timeDifference.month!
        print(totalInstallment,"totalInstallment")
        print(totalInstallment - 1,"remaining_installment")
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        //id="schemecode",tenure="",amount,type=7,frequency="Monthly",userid,sessionid="",perpetual="Y/N",cartsipstart,cartsipend,total_installment,remaining_installment
        self.addtocart(id: self.Schemecode!, tenure: "", amount: self.amountTf.text!, type: "7", frequency: "Monthly", userid: "\(userid!)", sessionid: "\(sessionId!)", perpetual: "Y/N", cartsipstart: dateFormatter1.string(from: startTime!), cartsipend: dateFormatter1.string(from: endTime!), total_installment: "\(totalInstallment)", remaining_installment: "\((totalInstallment - 1))", SI_id: "")
        }
    }
    
    @IBOutlet weak var First_date: UIButton!
    
    @IBAction func First_date(_ sender: UIButton) {
        
        calendar.isHidden = true
        calendar1.isHidden = true
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- 1st SWP  Date Unchecked")
        }
        else{
             Mixpanel.mainInstance().track(event: "Start SWP Screen :- 1st SWP  Date Checked")
            sender.isSelected = true
            First_date.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            Five_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Ten_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Fifteen_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_25.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_20.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            swp_start_date = "1"
            periodFrom.text = ""
            periodToTf.text = ""
            calendar.reloadData()
            let date = Date()
            let components = Calendar.current.dateComponents([.day], from: date)
            let day = components.day ?? 0
            if day <= Int(swp_start_date)!{
                self.calendar.setCurrentPage(date, animated: false)
            }
        }
        
    }
    @IBOutlet weak var Five_date: UIButton!
    @IBAction func Five_date(_ sender: UIButton) {
        calendar.isHidden = true
        calendar1.isHidden = true
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
             Mixpanel.mainInstance().track(event: "Start SWP Screen :- 5th SWP Date Unchecked")
        }
        else{
             Mixpanel.mainInstance().track(event: "Start SWP Screen :- 5th SWP  Date Checked")
            sender.isSelected = true
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            First_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Ten_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Fifteen_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_25.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_20.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            swp_start_date = "5"
            periodFrom.text = ""
            periodToTf.text = ""
            calendar.reloadData()
            let date = Date()
            let components = Calendar.current.dateComponents([.day], from: date)
            let day = components.day ?? 0
            if day <= Int(swp_start_date)!{
                self.calendar.setCurrentPage(date, animated: false)
            }
        }
    }
    @IBOutlet weak var Ten_date: UIButton!
    @IBAction func Ten_date(_ sender: UIButton) {
        calendar.isHidden = true
        calendar1.isHidden = true
        if sender.isSelected {
            sender.isSelected = false
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- 10th SWP  Date Unchecked")
        }
        else{
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- 10th SWP  Date Checked")
            sender.isSelected = true
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            First_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Five_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Fifteen_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_25.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_20.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            swp_start_date = "10"
            periodFrom.text = ""
            periodToTf.text = ""
            calendar.reloadData()
            let date = Date()
            let components = Calendar.current.dateComponents([.day], from: date)
            let day = components.day ?? 0
            if day <= Int(swp_start_date)!{
                self.calendar.setCurrentPage(date, animated: false)
            }
        }
    }
    @IBOutlet weak var Fifteen_date: UIButton!
    @IBAction func Fifteen_date(_ sender: UIButton) {
        calendar.isHidden = true
        calendar1.isHidden = true
        if sender.isSelected {
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- 15th SWP  Date Unchecked")
            sender.isSelected = false
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        }
        else{
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- 15th SWP  Date Checked")
            sender.isSelected = true
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            First_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Five_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Ten_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_25.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_20.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            swp_start_date = "15"
            periodFrom.text = ""
            periodToTf.text = ""
            calendar.reloadData()
            let date = Date()
            let components = Calendar.current.dateComponents([.day], from: date)
            let day = components.day ?? 0
            if day <= Int(swp_start_date)!{
                self.calendar.setCurrentPage(date, animated: false)
            }
        }
    }
    @IBOutlet weak var date_20: UIButton!
    @IBAction func date_20(_ sender: UIButton) {
        calendar.isHidden = true
        calendar1.isHidden = true
        if sender.isSelected {
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- 20th SWP Date Unchecked")
            sender.isSelected = false
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        }
        else{
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- 20th SWP Date Unchecked")
            sender.isSelected = true
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            First_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Five_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Ten_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Fifteen_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_25.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            swp_start_date = "20"
            periodFrom.text = ""
            periodToTf.text = ""
            calendar.reloadData()
            let date = Date()
            let components = Calendar.current.dateComponents([.day], from: date)
            let day = components.day ?? 0
            if day <= Int(swp_start_date)!{
                self.calendar.setCurrentPage(date, animated: false)
            }
            
        }
    }
    
    @IBOutlet weak var date_25: UIButton!
    @IBAction func date_25(_ sender: UIButton) {
        calendar.isHidden = true
        calendar1.isHidden = true
        if sender.isSelected {
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- 25th SWP Date Unchecked")
            sender.isSelected = false
            sender.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
        }
        else{
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- 25th SWP Date Unchecked")
            sender.isSelected = true
            sender.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            First_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Five_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Ten_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            Fifteen_date.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            date_20.setImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            swp_start_date = "25"
            periodFrom.text = ""
            periodToTf.text = ""
            calendar.reloadData()
            let date = Date()
            let components = Calendar.current.dateComponents([.day], from: date)
            let day = components.day ?? 0
            if day <= Int(swp_start_date)!{
                self.calendar.setCurrentPage(date, animated: false)
            }
        }
    }
 
    @IBAction func selectActionBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Start SWP Screen :- DropDown Button Clicked")
        calendar.isHidden = true
        calendar1.isHidden = true
        selectActionTableview.isHidden = !selectActionTableview.isHidden
        
    }
    
    @IBOutlet weak var perpetualbtn: UIButton!
    @IBAction func perpetualBtn(_ sender: UIButton) {
        if sender.isSelected{
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- Perpetual Unticked")
            sender.isSelected = false
            sender.setImage(#imageLiteral(resourceName: "square"), for: .normal)
            frombtn.isEnabled = true
            tobtn.isEnabled = true
            periodFrom.isEnabled = true
            periodToTf.isEnabled = true
        }else{
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- Perpetual Ticked")
            sender.isSelected = true
           sender.setImage(#imageLiteral(resourceName: "check-blue"), for: .normal)
            frombtn.isEnabled = false
            tobtn.isEnabled = false
            periodFrom.isEnabled = false
            periodToTf.isEnabled = false
            periodFrom.text = ""
            periodToTf.text = ""
            
        }
        
    }
    
    @IBAction func fromBtn(_ sender: UIButton) {
        if swp_start_date != "0"{
            if sender.isSelected{
                Mixpanel.mainInstance().track(event: "Start SWP Screen :- SWP Period From Calender Show")
                calendar1.isHidden = true
                calendar.isHidden = true
                sender.isSelected = false
            }else{
                Mixpanel.mainInstance().track(event: "Start SWP Screen :- SWP Period From Calender Hide")
                calendar.isHidden = false
                calendar1.isHidden = true
                sender.isSelected = true
            }
        }
        else{
            presentWindow.makeToast(message: "Please First Check SWP Date")
            Mixpanel.mainInstance().track(event: "Start SWP Screen :- Please First Check SWP Date")
        }
        
    }
    @IBOutlet weak var frombtn: UIButton!
    
    @IBOutlet weak var tobtn: UIButton!
    
    @IBAction func toBtn(_ sender: UIButton) {
        if periodFrom.text != ""{
            if sender.isSelected {
                Mixpanel.mainInstance().track(event: "Start SWP Screen :- SWP Period To Calender Show")
                calendar1.isHidden = true
                calendar.isHidden = true
                sender.isSelected = false
            }
            else{
                Mixpanel.mainInstance().track(event: "Start SWP Screen :- SWP Period To Calender Hide")
                calendar1.isHidden = false
                calendar.isHidden = true
                sender.isSelected = true
                
            }
        }
        else{
             Mixpanel.mainInstance().track(event: "Start SWP Screen :- Please First Select SWP From Date")
            presentWindow.makeToast(message: "Please First Select SWP From Date")
        }
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        if calendar == calendar1{
            
            guard let newDate = dateFormatter1.date(from: periodFrom.text!) else { return Date()}
            let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: newDate)!
            
            return nextMonthDate
        }
        else{
            
           // return Date()
            
            let date = Date()
            let components = Calendar.current.dateComponents([.day], from: date)
            let day = components.day ?? 0
            if day <= Int(swp_start_date)!{
                return date
            }
            else{
                let nextMonthDate = Calendar.current.date(byAdding: .month, value: 1, to: Date())!
                self.calendar.setCurrentPage(nextMonthDate, animated: false)
                return nextMonthDate
            }
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if calendar == calendar1{
            let dateFormatter1 = DateFormatter()
            
            dateFormatter1.dateFormat = "MM-yyyy"
            periodToTf.text = dateFormatter1.string(from: date)
            calendar1.isHidden = true
            
        }
        else {
            dateFormatter1.dateFormat = "MM-yyyy"
            periodFrom.text = dateFormatter1.string(from: date)
            self.calendar1.reloadData()
            calendar.isHidden = true
        }
    }
    
    fileprivate let gregorian: Calendar = Calendar(identifier: .gregorian)
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-yyyy"
        return formatter
    }()
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArrs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "selectaction", for: indexPath)
        cell.textLabel?.text = transactionArrs[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == selectActionTableview{
            let cell = tableView.cellForRow(at: indexPath)
            selectActiontf.text = cell?.textLabel?.text
            if selectActiontf.text  == "Additional Purchase"{
                // transacttf.text = "Additional Purchase"
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "AdditionalPurchaseViewController") as! AdditionalPurchaseViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Additional Purchase"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text == "Redeem"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "ReedemViewController") as! ReedemViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Redeem"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text  == "Switch"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "transactSwitchViewController") as! transactSwitchViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Switch"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text  == "Stop SIP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSIPViewController") as! StopSIPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Stop SIP"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text == "Stop SWP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSWPViewController") as! StopSWPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Stop SWP"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text  == "Stop STP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "StopSTPViewController") as! StopSTPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Stop STP"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
            }
            else if selectActiontf.text == "Start SWP"{
               
            }
            else if selectActiontf.text  == "Start STP"{
                let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                let destVC = storyBoard.instantiateViewController(withIdentifier: "STPViewController") as! STPViewController
                destVC.transactionArrs = transactionArr[row].valid_for
                destVC.selectAction = "Start STP"
                destVC.SchemeName = transactionArr[row].scheme_name
                destVC.Schemecode = transactionArr[row].schemecode
                destVC.acc_no = transactionArr[row].account_no
                destVC.bank_acc_no_from_bank_list = self.bank_acc_no_from_bank_list
                destVC.folio_no = transactionArr[row].folio_no
                destVC.no_of_units = transactionArr[row].no_of_units!
                destVC.curr_value = transactionArr[row].curr_value1
                destVC.trxnnumber = transactionArr[row].trxnnumber
                destVC.mininvest = transactionArr[row].mininvest
                destVC.row = row
                destVC.swpcid = transactionArr[row].swpcid
                destVC.stptxnid = transactionArr[row].stptxnid
                destVC.stpcid = transactionArr[row].stpcid
                destVC.bse_aof_status_code = self.bse_aof_status_code
                destVC.bse_reg_code = self.bse_reg_code
                destVC.minredeemAmt = transactionArr[row].minredeemAmt ?? "0"
                destVC.minredeemUnit = transactionArr[row].minredeemUnit ?? "0"
                destVC.curr_nav = transactionArr[row].curr_nav ?? "0"
                self.navigationController?.pushViewController(destVC, animated: true)
                
            }
            
            selectActionTableview.isHidden = true
            //return cell
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
                                if self.bse_reg_code != "Y"{
                                    self.clientregistrationBse(userid: userid as! String)
                                } else {
                                    self.presentWindow.hideToastActivity()
                                }
                               // self.fetchSchemeName(s_code: self.Schemecode!)
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
    func addtocart(id:String,tenure: String,amount:String,type:String,frequency:String, userid: String, sessionid:String, perpetual:String,cartsipstart:String,cartsipend : String,total_installment:String,remaining_installment:String,SI_id:String){
        //id="schemecode",tenure="",amount,type=7,frequency="Monthly",userid,sessionid="",perpetual="Y/N",cartsipstart,cartsipend,total_installment,remaining_installment
        
        let parameters = ["id":"\(id.covertToBase64())","tenure":tenure.covertToBase64(),"amount":amount.covertToBase64(),"type":type.covertToBase64(),"frequency":frequency.covertToBase64(),"userid":userid.covertToBase64(),"sessionid":sessionid.covertToBase64(),"perpetual":perpetual.covertToBase64(),"cartsipstart":cartsipstart.covertToBase64(),"cartsipend":cartsipend.covertToBase64(),"total_installment":total_installment.covertToBase64(),"remaining_installment":remaining_installment.covertToBase64(),"enc_resp":"3"] as [String : Any]
        print(parameters,"")
        presentWindow.makeToastActivity(message: "Processing..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.addtostpswpcart)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    let cart_id1 = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                    let cart_id = Int(cart_id1!)
                    if cart_id != nil {
                        self.addtransaction(cart_id: cart_id!, user_id: userid, folio_no: "\(self.folio_no!)", bank_id: "\(self.bank_id!)", trxntype: "RU", SI_id: "")
                    }
                   
                    //txn_id="", user_id, cart_id = response from above web service, bank_id, status="", trxntype="RU", trxndate=cartsipdate, transaction_folio_no
            
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
        
    }
    func addtransaction(cart_id:Int,user_id:String,folio_no:String,bank_id:String,trxntype:String,SI_id:String){
        
        
        // as [String : Any]
        
        presentWindow.makeToastActivity(message: "Adding.")
        //addswpstptransaction
        let url = "transaction/transaction_ws.php/addswpstptransaction"
        let date_cuurent = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let t_date  = dateFormatter.date(from: "\(swp_start_date)-\(String(describing: periodFrom.text!))")
        print(t_date)
        let dateFormatter2 = DateFormatter()
        dateFormatter2.dateFormat = "yyyy-MM-dd"
        let t_date1 =  dateFormatter2.date(from: "\(date_cuurent)")
        print(t_date1)
        //  txn_id="", user_id, cart_id = response from above web service, bank_id, status="", trxntype="SOU", trxndate=cartsipdate, transaction_folio_no
        let parameters = ["txn_id":"","user_id":"\(user_id.covertToBase64())","cart_id":"\(cart_id)","bank_id":"\(bank_id.covertToBase64())","status":"", "trxntype":"\(trxntype.covertToBase64())", "trxndate":"\(dateFormatter1.string(from: t_date ?? date_cuurent))","transaction_folio_no":"\(folio_no.covertToBase64())","enc_resp":"3"]
        print(parameters,"transaction>>>>>>")
        
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(url)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseString{ response in
                    print(response.value!)
                    self.presentWindow.hideToastActivity()
                    let transaction_id = response.value?.replacingOccurrences(of: "\n", with: "").base64Decoded()
                    if let transactionid = Int(transaction_id!){
                        print(transactionid)
                        print("hello")
                        self.bseSWPRegistration(transaction_id: transactionid)
                        
                        
                    }
                    else{
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                        destVC.success = "Start SWP Request Placed Unsuccessfully"
                        destVC.titles = "Start SWP Request"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        destVC.id = "2"
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                    
                    
                    
            }
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func bseSWPRegistration(transaction_id:Int){
        //https://www.financialhospital.in/adminpanel/bse/bse_ws.php/SWPRegistration/transaction_id
        let url = "\(Constants.BASE_URL)\(Constants.API.SWPRegistration)\(transaction_id)"
        if Connectivity.isConnectedToInternet{
            Alamofire.request(url).responseJSON { response in
                print(response.result.value as? [String:Any])
                let data = response.result.value as? [String:Any]
                if let bse_reg_status = data?["status"] as? String{
                    if bse_reg_status != "Error" {
                        let name = UserDefaults.standard.value(forKey: "name") as? String
                        let email = UserDefaults.standard.value(forKey: "Email") as? String
                        let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
                        self.sendSWPRequestEmailToSupport(username: name!, email: email!, S_NAME: "\(self.SchemeName!)")
                        self.sendSmsToUSer(mobile: phone!, transaction_date: "")
                        self.sendSWPRequestEmailToUser(username: name!, email: email!, S_NAME: "\(self.SchemeName!)", transaction_date: "")
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentSuccessViewController") as! PaymentSuccessViewController
                        destVC.success = "Start SWP Request Placed Successfully"
                        destVC.titles = "Start SWP Request"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        self.navigationController?.pushViewController(destVC, animated: true)
                    } else {
                        let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                        let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                        destVC.success = "Start SWP Request Placed Unsuccessfully"
                        destVC.titles = "Start SWP Request"
                        //destVC.successLabel!.text = "Reedem Request Placed Successfully"
                        self.navigationController?.pushViewController(destVC, animated: true)
                    }
                } else {
                    let storyBoard = UIStoryboard(name: "transactOnline", bundle: nil)
                    let destVC = storyBoard.instantiateViewController(withIdentifier: "PaymentUnSuccessfullViewController") as! PaymentUnSuccessfullViewController
                    destVC.success = "Start SWP Request Placed Unsuccessfully"
                    destVC.titles = "Start SWP Request"
                    self.navigationController?.pushViewController(destVC, animated: true)
                }
            }
        } else {
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    func sendSWPRequestEmailToUser(username:String,email:String,S_NAME:String,transaction_date:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        if Connectivity.isConnectedToInternet{
            
            //{
            var parameters = [String:Any]()
            if perpetualbtn.currentImage == #imageLiteral(resourceName: "check-blue"){
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                parameters = [
                    "ToEmailID":"\(email.covertToBase64())",
                    "FromEmailID":"",
                    "Subject" :"Your swp request has been submitted successfully - Fintoo",
                    "template_name": "swpsuccess",
                    "username":"\(username.covertToBase64())",
                    "txn_date":"\(dateFormatter.string(from: Date()))",
                    "table":"1",
                    "scheme_name":"\(S_NAME.covertToBase64())",
                    "scheme_type":"SWP",
                    "scheme_amount":"\(String(describing: amountTf.text!).covertToBase64())",
                    "enc_resp":"3"
                    
                ]
            }else{
                 parameters = [
                    "ToEmailID":"\(email.covertToBase64())",
                    "FromEmailID":"",
                    "Subject" :"Your swp request has been submitted successfully - Fintoo",
                    "template_name": "swpsuccess",
                    "username":"\(username.covertToBase64())",
                    "txn_date":"\(swp_start_date)-\(String(describing: periodFrom.text!)))",
                    "table":"1",
                    "scheme_name":"\(S_NAME.covertToBase64())",
                    "scheme_type":"SWP",
                    "scheme_amount":"\(String(describing: amountTf.text!).covertToBase64())",
                    "enc_resp":"3"
                    
                ]
            }
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
                            self.sendSWPRequestEmailToSupport(username: username, email: email, S_NAME: S_NAME)
                        }
                    }
                    
                    
            }
        }
        else{
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
    
    
    //send suuport mail
    func sendSWPRequestEmailToSupport(username:String,email:String,S_NAME:String){
        //let email = UserDefaults.standard.value(forKey: "Email") as? String
        
        
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "ToEmailID":"\(covertToBase64(text:"support@fintoo.in"))",
                "FromEmailID":"",
                "Subject" :"\(covertToBase64(text: "\(username) has made a SWP request on Fintoo"))",
                "template_name": "\(covertToBase64(text: "swpsuccessonline"))",
                "email":"\(email.covertToBase64())",
                "username":"\(username.covertToBase64())",
                "table":"1",
                "scheme_name":"\(S_NAME.covertToBase64())",
                "scheme_type":"\(covertToBase64(text: "SWP"))",
                "scheme_amount":"\(amountTf.text!.covertToBase64())",
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
                            print("send message")
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
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy-MM-dd"
        let c_date = Date()
        if Connectivity.isConnectedToInternet{
            let parameters = [
                "mobile":"\(mobile)",
                "msg":"Your SWP request on Fintoo has been successfully placed on \(dateFormatter1.string(from: c_date)). You will receive the confirmation shortly, subjected to funds realisation from Fund House. For any urgent query, call us directly on 9699 800600","enc_resp":"3"
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
    // BSE API
    
    func clientregistrationBse(userid:String){
        print("Modify ucc data")
        //https://www.financialhospital.in/adminpanel/bse/bse_ws.php/clientregistration/userid
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
    
}
