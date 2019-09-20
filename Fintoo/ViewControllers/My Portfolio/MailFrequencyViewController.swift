//
//  MailFrequencyViewController.swift
//  Fintoo
//
//  Created by Shreya Pallan on 23/07/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire

class MailFrequencyViewController: BaseViewController {

    @IBOutlet weak var weeklyBtn: UIButton!
    @IBOutlet weak var monthlyBtn: UIButton!
    @IBOutlet weak var unsubscribeBtn: UIButton!
    var frequencyMode : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        weeklyBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
        unsubscribeBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        monthlyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        frequencyMode = "1"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveBtnClicked(_ sender: UIButton) {
        if frequencyMode == "0" || frequencyMode == "1" || frequencyMode == "2"{
            sendEmailForRequestReport(mode:frequencyMode)
        }
        else  {
            presentWindow?.makeToast(message: "Select any one option")
        }
        
    }
    
    @IBAction func cancelBtnClicked(_ sender: UIButton) {
    }
    
    func sendEmailForRequestReport(mode: String){
        var userid = UserDefaults.standard.value(forKey: "userid")
        if flag != "0"{
            userid! = flag
            
        } else{
            userid = UserDefaults.standard.value(forKey: "userid")
        }
        
        let url = "\(Constants.BASE_URL)\(Constants.API.getRequestReport)"
        let parameters = ["user_id":"\(userid!)","req_report": frequencyMode!]
        print(url)
        print("\(userid) \(frequencyMode)")
        self.presentWindow.makeToastActivity(message: "Loading..")
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.getRequestReport)", method: .post,parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON{ response in
                    
                    print(response.value)
                    print("##\(response.result.value!)")
                   
                    let data =  response.result.value as? [String:Any]
                    
                    if let response_status = data?["status"] {
                        self.presentWindow.hideToastActivity()
                        if data?["status"] != nil {
                            if data?["message"] != nil {
                                if let message = data?["message"]! as? String {
                                    
                                    print("message: \(message)")
                                    
                                    
                                    let alert = UIAlertController(title: "Alert", message: "\(message)", preferredStyle: UIAlertControllerStyle.alert)
                                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { alert in
                                        print("Ok button clicked")
                                        let storyboard = UIStoryboard(name: "Portfolio", bundle: nil)
                                        let controller = storyboard.instantiateViewController(withIdentifier: "TransactionsViewController") as! TransactionsViewController
                                        self.navigationController?.pushViewController(controller, animated: true)
                                    }))
                                    self.present(alert, animated: true, completion: nil)
                                }
                            }
                           
                        }
                           
                            
                    }
            }
        }
    }
    
    @IBAction func weeklyBtnClicked(_ sender: UIButton) {
        unsubscribeBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        monthlyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        weeklyBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
        frequencyMode = "1"
    }
    @IBAction func monthlyBtnClicked(_ sender: UIButton) {
        unsubscribeBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        monthlyBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
        weeklyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        frequencyMode = "2"
    }
    @IBAction func unsubscribeBtnClicked(_ sender: UIButton) {
        unsubscribeBtn.setImage(UIImage(named: "check"), for: UIControlState.normal)
        monthlyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        weeklyBtn.setImage(UIImage(named: "uncheck"), for: UIControlState.normal)
        frequencyMode = "0"
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
