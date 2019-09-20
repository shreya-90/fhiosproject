//
//  noPopupViewController.swift
//  Minty
//
//  Created by iosdevelopermme on 07/12/17.
//  Copyright © 2017 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import Mixpanel

class noPopupViewController: UIViewController {
    var presentWindow : UIWindow?
    
    @IBOutlet weak var popupview: UIView!
    
    @IBOutlet weak var textview: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        presentWindow = UIApplication.shared.keyWindow
        popupview.layer.cornerRadius = 10
        popupview.layer.masksToBounds = true
        popupview.layer.borderWidth = 1
        //popupview.layer.borderColor = UIColor.black.cgColor
        textview.placeholder = "Share your experience with us"
        //self.textview.placeholder = "Enter your last name"
         //Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButton(_ sender: Any) {
 
        self.dismiss(animated: true, completion: nil)
        Mixpanel.mainInstance().track(event: "Feedback Screen :- Cancel button Pressed")
        
    }
    @IBAction func sendButton(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Feedback Screen :- Send Button Clicked")
       // Mixpanel.mainInstance().track(event: "Feedback Screen :-Send button Pressed")
        let email = UserDefaults.standard.value(forKey: "Email") as? String
        // print(email,"9999999999")
        let phone = UserDefaults.standard.value(forKey: "Mobile") as? String
        let userid = UserDefaults.standard.value(forKey: "userid") as? String
        if email == nil || phone == nil{
            self.presentWindow!.makeToast(message: "Please Login To Request A Callback From Our Expert")
           // self.navigationController?.view.makeToast("Please Login To Request A Callback From Our Expert", duration: 3.0, position: .center)
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let destVc = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            navigationController?.pushViewController(destVc, animated: true)
        }
        else{
            print(textview.text,"^^^^^^^^^^^^")
            
            let parameters = ["email" : "\(email!)"
                ,"mobile" :"\(phone!)",
                "flag": "0",
                "userid":"\(userid!)","description":"\(textview.text!)"]
            print(parameters)
            print("\(Constants.BASE_URL)\(Constants.API.Feedback)")
            if textview.text == ""{
                presentWindow!.makeToast(message: "Please Enter Some Feedback Before Submitting")
                Mixpanel.mainInstance().track(event: "Feedback Screen :- Please Enter Some Feedback Before Submitting")
            }
            else{
             if Connectivity.isConnectedToInternet{
             self.dismiss(animated: true, completion: nil)
            
           
                presentWindow?.makeToastActivity(message: "Posting..")
                Alamofire.request("\(Constants.BASE_URL)\(Constants.API.Feedback)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        print(response.result.value ?? "")
                        let data = response.result.value
                        //data.value(forKey: "result")
                        if (data as? Any) != nil{
                            print(data!)
                            if let code = data as? NSDictionary {
                                print(code,"@@@@@@@@@@@@@")
                              
                                let result = code.value(forKey: "result") as? Int

                                    print(result,"@@@@@")
                                   
                                    if result == 0 {
                                        self.presentWindow?.hideToastActivity()
                                        self.presentWindow!.makeToast(message: "Error Has Occurred Please Retry After Some Time")
                                        Mixpanel.mainInstance().track(event: "Feedback Screen :-Error Has Occurred Please Retry After Some Time")
                                        //self.navigationController?.view.makeToast("Error Has Occurred Please Retry After Some Time", duration: 3.0, position: .center)
                                    }
                                    else{
                                        self.presentWindow?.hideToastActivity()
                                        print("Thank You For Your Valuable Feedback!")
                                        //self.dismiss(animated: true, completion: nil)
                                       // DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
                                        
                                        //self.view.makeToast("Thank You For Your Valuable Feedback!", duration: 3.0, position: .center)
                                        
        
//                                            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                                self.presentWindow!.makeToast(message: "Thank You For Your Valuable Feedback!")
                                          Mixpanel.mainInstance().track(event: "Feedback Screen :- Thank You For Your Valuable Feedback")
                                               
                                        //})
                                    }
                              // }

                            }
                        }
                }
            }
            else{
                presentWindow?.hideToastActivity()
                self.presentWindow!.makeToast(message: "Connection Failed. Please Try Later!")
               Mixpanel.mainInstance().track(event: "Feedback Screen :- Connection Failed")
            }
        }
        }
    }
    
    

}
extension UITextView: UITextViewDelegate {
    // Code
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLbl = self.viewWithTag(50) as? UILabel {
                placeholderText = placeholderLbl.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
                placeholderLbl.text = newValue
                placeholderLbl.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        if let placeholderLbl = self.viewWithTag(50) as? UILabel {
            placeholderLbl.isHidden = self.text.characters.count > 0
        }
    }
    
    private func resizePlaceholder() {
        if let placeholderLbl = self.viewWithTag(50) as! UILabel? {
            let x = self.textContainer.lineFragmentPadding
            let y = self.textContainerInset.top - 2
            let width = self.frame.width - (x * 2)
            let height = placeholderLbl.frame.height
            
            placeholderLbl.frame = CGRect(x: x, y: y, width: width, height: height)
        }
    }
    
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLbl = UILabel()
        
        placeholderLbl.text = placeholderText
        placeholderLbl.sizeToFit()
        
        placeholderLbl.font = self.font
        placeholderLbl.textColor = UIColor.lightGray
        placeholderLbl.tag = 50
        
        placeholderLbl.isHidden = self.text.characters.count > 0
        
        self.addSubview(placeholderLbl)
        self.resizePlaceholder()
        self.delegate = self
    }
}
