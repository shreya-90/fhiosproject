
//
//  TransactionDetailsViewController.swift
//  Fintoo
//
//  Created by Matchpoint  on 02/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel

protocol TransactionDetailDelegate: class {
    func expandView(row: Int)
    func expandLess(row : Int)
}
class TransactionDetailsViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource ,TransactionDetailDelegate{
    @IBOutlet weak var schemeName: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    @IBOutlet weak var gainLossLabel: UILabel!
    
    @IBOutlet weak var xirr: UILabel!
    
    @IBOutlet weak var investedSince: UILabel!
    
    @IBOutlet weak var current_nav: UILabel!
    
    @IBOutlet weak var purchaseNav: UILabel!
    
    @IBOutlet weak var units: UILabel!
    
    @IBOutlet weak var investCost: UILabel!
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var currentNav: UILabel!
    
    @IBOutlet weak var arrowImage: UIImageView!
    var nomineeIndex = -1
    var id : Int!
    @IBOutlet weak var gainLossTillDateLabel: UILabel!
    
    var transactionArr = [TransactionDetailObj]()
    @IBOutlet weak var tableView: UITableView!
    var is_exapanded : Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getTransactionDetail()
       // cellView.setShadow()
       addBackbutton()
        
        let dateFormatter = DateFormatter()
        let date = Date()
        dateFormatter.dateFormat = "dd-MM-yyyy"
       let date_String =  dateFormatter.string(from: date)

        gainLossTillDateLabel.text = "Gain/Loss till date \(date_String)"
        
        // Do any additional setup after loading the view.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        Mixpanel.mainInstance().track(event: "Transaction Detail Screen :- Back Button Clicked")
        navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactionArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "details", for: indexPath) as? transactionDetailsCell
        let formatter = NumberFormatter()              // Cache this,
        formatter.locale = Locale(identifier: "en_IN") // Here indian local
        formatter.numberStyle = .decimal
        //let invested_cost1 = formatter.string(from: (invested_cost.numberValue)!)
        cell?.srNo.text = String(indexPath.row + 1) + "."
        cell?.expandButton.tag = indexPath.row
        cell?.expandLess.tag = indexPath.row
        cell?.underLIneView.setShadow()
        cell?.cornerRadius = 5.0
        //cell?.transaction_type.text = transactionArr[indexPath.row].transaction_type! + "\n" +
        //"(\(transactionArr[indexPath.row].trans_sell_buy!))"
        
       
        cell?.transaction_type.text = transactionArr[indexPath.row].transaction_type! + "\n"
        let attr = [ NSAttributedStringKey.foregroundColor : UIColor.lightGray ]
        let myNewLabelText = NSMutableAttributedString(string: "(\(transactionArr[indexPath.row].trans_sell_buy!))", attributes: attr)
        let txntype = NSMutableAttributedString(string: (cell?.transaction_type.text)!)
        txntype.append(myNewLabelText)
        cell?.transaction_type.attributedText = txntype
      
        
        
        
        cell?.inv_since.text = transactionArr[indexPath.row].inv_since
        cell?.amount.text  = formatter.string(from: (transactionArr[indexPath.row].inv_amount?.numberValue)!)
        cell?.price.text = transactionArr[indexPath.row].price
        cell?.units.text = transactionArr[indexPath.row].units
        cell?.curNav.text = transactionArr[indexPath.row].curNav
        cell?.curValue.text = transactionArr[indexPath.row].curValue
        cell?.cummUnit.text = transactionArr[indexPath.row].cummUnits
        cell?.gainLosa.text = transactionArr[indexPath.row].gainLoss
        cell?.days.text = transactionArr[indexPath.row].days
        cell?.internal_cagr.text = transactionArr[indexPath.row].internal_cagr! + "%"
        if !self.transactionArr[indexPath.row].is_exapanded{
            print(self.transactionArr[indexPath.row].is_exapanded)
            cell?.expandButton.isHidden = true
            cell?.lastUnderline.setShadow()
            cell?.underLIneView.hideShadow()
            cell?.expandLess.imageView?.transform = CGAffineTransform(rotationAngle: .pi * 1.5)
        }
        else{
            cell?.expandButton.isHidden = false
            cell?.underLIneView.setShadow()
        }
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(!self.transactionArr[indexPath.row].is_exapanded){
            return 300
        }
        else{
            return 100
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.transactionArr[indexPath.row].is_exapanded = !self.transactionArr[indexPath.row].is_exapanded
        self.tableView.reloadData()
    }
    
    func expandView(row: Int) {
        Mixpanel.mainInstance().track(event: "Transaction Detail Screen :- Expand Button Clicked")
        self.transactionArr[row].is_exapanded = false
      
        self.tableView.reloadData()
    }
    func expandLess(row: Int) {
        Mixpanel.mainInstance().track(event: "Transaction Detail Screen :- Minimize Button Clicked")
        self.transactionArr[row].is_exapanded = true
        tableView.reloadData()
        
    }
    
    func getTransactionDetail(){
       // let userid = UserDefaults.standard.value(forKey: "userid")
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        }
        else{
            // flag = "0"
            userid = UserDefaults.standard.value(forKey: "userid") as? String
        }
        let panid = UserDefaults.standard.value(forKey: "pan") as? String
        let url = "\(Constants.BASE_URL)\(Constants.API.getTransactionDetail)\(panid!.covertToBase64())/3"
        print(url)
        presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet{
            
            Alamofire.request(url).responseString { response in
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
                let data = dict
                //let data = data1
                // print(response.result.value)
                if let data = data as? NSDictionary{
                    self.presentWindow.hideToastActivity()
                    print(data.count,"TAG","COUNT")
                    let countForCell = data.count - 1
                    //for i in (0..<countForCell){
                        if let dataDetail = data.value(forKey: String(self.id!)) as? NSDictionary{
                            //  print(dataDetail.value(forKey: "scheme_name"))
                            if let scheme_name = dataDetail.value(forKey: "scheme_name") as? String,
                                let curr_value = dataDetail.value(forKey: "curr_value") as? String,
                                let gain_loss = dataDetail.value(forKey: "gain_loss") as? String,
                                let xirr = dataDetail.value(forKey: "xirr") as? String,
                                let invested_since = dataDetail.value(forKey: "invested_since") as? String,
                                let purchse_nav = dataDetail.value(forKey: "purchse_nav") as? String,
                                let curr_nav = dataDetail.value(forKey: "curr_nav") as? String,
                                let units = dataDetail.value(forKey: "units") as? String,
                                let invested_cost = dataDetail.value(forKey: "invested_cost") as? String {
                                //print(dataDetail.value(forKey: "transactin_detail") as? NSArray)
                                let tr = dataDetail.value(forKey: "transactin_detail") as? [AnyObject]
                                let formatter1 = NumberFormatter()              // Cache this,
                                formatter1.locale = Locale(identifier: "en_IN") // Here indian local
                                formatter1.numberStyle = .decimal
                                let curr_value_comma = formatter1.string(from: (curr_value.numberValue)!)
                                print(curr_value_comma)
                                self.schemeName.text = scheme_name
                                self.currentNav.text = "₹ " + curr_value_comma!
                                self.xirr.text = xirr + "%  (CAGR)"
                                if (self.xirr.text?.contains(find: "-"))!{
                                    self.arrowImage.image = UIImage(named: "red_arrow_down")
                                    self.xirr.textColor = UIColor(hexaString: "#FF2600")
                                    self.gainLossLabel.textColor = UIColor(hexaString: "#FF2600")
                                }
                                else{
                                   self.arrowImage.image = UIImage(named: "green_arrow_up")
                                 self.xirr.textColor = UIColor(hexaString: "#008F00")
                                    self.gainLossLabel.textColor = UIColor(hexaString: "#008F00")
                                    
                                }
                                self.investedSince.text = invested_since
                                self.purchaseNav.text = purchse_nav
                                self.current_nav.text = curr_nav
                                let formatter = NumberFormatter()              // Cache this,
                                formatter.locale = Locale(identifier: "en_IN") // Here indian local
                                formatter.numberStyle = .decimal
                                let invested_cost1 = formatter.string(from: (invested_cost.numberValue)!)
                                let units1 = formatter.string(from: (units.numberValue)!)
                                let curr_value1 = formatter.string(from: (curr_value.numberValue)!)
                                let gain_loss1 = formatter.string(from: (gain_loss.numberValue)!)
                                self.investCost.text = invested_cost1
                                self.units.text = units1
                                self.currentValue.text = curr_value1!
                                self.gainLossLabel.text = "₹ " + gain_loss1!
                               
                                print(tr?.count)
                               // print(gain_loss)
                                for i in tr! {
                                    print("forlopp")
                                     if let transaction_type = i.value(forKey: "transaction_type") as? String,
                                        let inv_since = i.value(forKey: "inv_since") as? String,
                                        let inv_amount = i.value(forKey: "inv_amount") as? String ,
                                        let purchase_price = i.value(forKey: "purchase_price") as? String,
                                        let units = i.value(forKey: "units") as? String,
                                        let comm_units = i.value(forKey: "comm_units") as? String,
                                        let curr_nav = i.value(forKey: "curr_nav") as? String,
                                        let curr_value = i.value(forKey: "curr_value") as? String,
                                        let gain_loss = i.value(forKey: "gain_loss") as? String,
                                        let days = i.value(forKey: "days") as? Int,
                                        
                                        let internal_cagr = i.value(forKey: "internal_cagr") as? String{
                                        let trans_sell_buy = i.value(forKey: "trans_sell_buy") as? String
                                        print(trans_sell_buy)
                                        print(transaction_type)
                                        let formatter = NumberFormatter()              // Cache this,
                                        formatter.locale = Locale(identifier: "en_IN") // Here indian local
                                        formatter.numberStyle = .decimal
                                        let gain_loss1 = formatter.string(from: (gain_loss.numberValue)!)
                                        let curr_value1 = formatter.string(from: (curr_value.numberValue)!)
                                        let purchase_price1 = formatter.string(from: (purchase_price.numberValue)!)
                                        let units1 = formatter.string(from: (units.numberValue)!)
                                        let comm_units1 = formatter.string(from: (comm_units.numberValue)!)
                                        self.transactionArr.append(TransactionDetailObj.getTransactionDetailS(transaction_type: transaction_type, inv_amount: inv_amount, inv_since: inv_since, purchase_price: purchase_price1!, units: units1!, comm_units: comm_units1!, curr_nav: curr_nav, curr_value: curr_value1!, gain_loss: gain_loss1!, days: String(days),trans_sell_buy:trans_sell_buy ?? "",internal_cagr:internal_cagr))
                                    }
                                  
                                }
                                self.tableView.reloadData()
                                print(self.transactionArr.count,"count")
                            }
                        }
                    //}
                    
                    
                }
            }
            
            
        }
        else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
}

class transactionDetailsCell : UITableViewCell
{ 
    @IBOutlet weak var underLIneView: UIView!
    
    @IBOutlet weak var lastUnderline: UIView!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var units: UILabel!
    @IBOutlet weak var cummUnit: UILabel!
    
    @IBOutlet weak var curNav: UILabel!
    @IBOutlet weak var curValue: UILabel!
    @IBOutlet weak var gainLosa: UILabel!
    
    @IBOutlet weak var days: UILabel!
    @IBOutlet weak var expandButton: UIButton!
    weak var delegate: TransactionDetailDelegate?
    @IBOutlet weak var expandLess: UIButton!
    @IBOutlet weak var transaction_type: UILabel!
    @IBOutlet weak var inv_since: UILabel!
    @IBOutlet weak var amount: UILabel!
    
    @IBOutlet weak var internal_cagr: UILabel!
    @IBOutlet weak var srNo: UILabel!
    @IBAction func expandButton(_ sender: UIButton) {
        delegate?.expandView(row: sender.tag)
    }
    @IBAction func expandLess(_ sender: UIButton) {
        delegate?.expandLess(row: sender.tag)
    }
}

