//
//  BaseViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 13/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
import MIBadgeButton_Swift
private var kAssociationKeyMaxLength: Int = 0
class BaseViewController: UIViewController ,SlideMenuDelegate {
    var presentWindow : UIWindow!
    var btnBack : UIButton!
    var backButton : UIBarButtonItem!
    var btnShowMenu : UIButton!
    var menuButton : UIBarButtonItem!
    var btnCartMenu : UIButton!
    var cartButton : UIBarButtonItem!
    //var btnBell : MIBadgeButton!
    var btnCross : UIButton!
    var crossButton : UIBarButtonItem!
    //var menuButton : UIBarButtonItem!
    var btnCart : MIBadgeButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        backItem()
        menuItem()
        crossItem()
        cartItem()
        cart1Item()
         presentWindow = UIApplication.shared.keyWindow
       // presentWindow = UIApplication.shared.windows.first
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addBackbutton()
    {
        btnBack.setImage(#imageLiteral(resourceName: "icon-back-white"), for: .normal)
        self.navigationItem.leftBarButtonItem = backButton;
    }
    func backItem()
    {
        btnBack = UIButton(type: .custom)
        btnBack.frame = CGRect(x: 0, y: 0, width: 35, height: 30)
        btnBack.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 10)
        btnBack.setImage(UIImage(named: "icon-back"), for: .normal)
        btnBack.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        btnBack.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        btnBack.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnBack.addTarget(self, action: #selector(BaseViewController.onBackButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        
        backButton = UIBarButtonItem(customView: btnBack)
       backButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
    }
    func setWhiteNavigationBar()
    {
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color:#colorLiteral(red: 0.1764705882, green: 0.7058823529, blue: 0.9098039216, alpha: 1)), for: .default)
        //self.navigationController?.navigationBar.shadowImage = UIImage(color: UIColor.lightGray.withAlphaComponent(1.0))
        self.navigationController?.navigationBar.isTranslucent = false;
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 18)]
        
    }
    func setTransperntNavigationBar()
    {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true;
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
    }
    @objc func onBackButtonPressed(_ sender : UIButton)
    {
        // _ = navigationController?.popViewController(animated: true)
    }
    
    func addRightBarButtonItems(items:[UIBarButtonItem])
    {
        self.navigationItem.rightBarButtonItems = items //[menuButton, bellButton]
    }
    
    func addLeftBarButtonItems(items:[UIBarButtonItem])
    {
        self.navigationItem.leftBarButtonItems = items //[menuButton, bellButton]
    }
    func menuItem()
    {
        btnShowMenu = UIButton(type: .custom)
        btnShowMenu.frame = CGRect(x: 0, y: 0, width: 35, height: 18)
        //btnShowMenu.setImage(UIImage.defaultMenuImage(), for: .normal)
        btnShowMenu.setImage(#imageLiteral(resourceName: "menu-button"), for: .normal)
        btnShowMenu.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        btnShowMenu.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        btnShowMenu.imageView?.contentMode = .scaleAspectFit
        btnShowMenu.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        menuButton = UIBarButtonItem(customView: btnShowMenu)
        menuButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
    }
    func cartItem()
    {
        btnCartMenu = UIButton(type: .custom)
        btnCartMenu.frame = CGRect(x: 0, y: 0, width: 35, height: 18)
        //btnShowMenu.setImage(UIImage.defaultMenuImage(), for: .normal)
        btnCartMenu.setImage(#imageLiteral(resourceName: "cart"), for: .normal)
        btnCartMenu.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        btnCartMenu.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        btnCartMenu.imageView?.contentMode = .scaleAspectFit
        btnCartMenu.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnCartMenu.addTarget(self, action: #selector(BaseViewController.onCartButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        cartButton = UIBarButtonItem(customView: btnCartMenu)
        cartButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        //cartButton.badgeString = ""
    }
    func crossItem()
    {
        
        btnCross = UIButton(type: .custom)
        btnCross.frame = CGRect(x: 0, y: 0, width: 35, height: 18)
        //btnShowMenu.setImage(UIImage.defaultMenuImage(), for: .normal)
    
        btnCross.setImage(#imageLiteral(resourceName: "multiply (1)"), for: .normal)
        btnCross.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        btnCross.heightAnchor.constraint(equalToConstant: 18.0).isActive = true
        btnCross.imageView?.contentMode = .scaleAspectFit
        btnCross.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnCross.addTarget(self, action: #selector(BaseViewController.onCrossButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        crossButton = UIBarButtonItem(customView: btnCross)
        crossButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        
    }
    func cart1Item()
    {
        
        btnCart = MIBadgeButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        btnCart.setImage(UIImage(named: "cart"), for: .normal)
        btnCart.imageView?.contentMode = .scaleAspectFit
        btnCart.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnCart.addTarget(self, action: #selector(BaseViewController.onCart1ButtonPressed(_:)), for: UIControlEvents.touchUpInside);
        cartButton = UIBarButtonItem(customView: btnCart)
        cartButton.tintColor = #colorLiteral(red: 0.4789211154, green: 0.5131568313, blue: 0.5401799083, alpha: 1)
        btnCart.badgeString = ""
        
    }
    @objc func onCart1ButtonPressed(_ sender : UIButton)
    {
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    @objc func onCrossButtonPressed(_ sender : UIButton)
    {
    }
    @objc func onCartButtonPressed(_ sender : UIButton)
    {
    }
    @objc func onSlideMenuButtonPressed(_ sender : UIButton)
    {
        print("hello")
        
            if (sender.tag == 10)
            {
                // To Hide Menu If it already there
                self.slideMenuItemSelectedAtIndex(-1);
                
                sender.tag = 0;
                
                let viewMenuBack : UIView = view.subviews.last!
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    var frameMenu : CGRect = viewMenuBack.frame
                    frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
                    viewMenuBack.frame = frameMenu
                    viewMenuBack.layoutIfNeeded()
                    viewMenuBack.backgroundColor = UIColor.clear
                }, completion: { (finished) -> Void in
                    viewMenuBack.removeFromSuperview()
                })
                
                return
            }
            
            sender.isEnabled = false
            sender.tag = 10
            
            let menuVC : MenuViewController = self.storyboard!.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
            menuVC.btnMenu = sender
            menuVC.delegate = self
            self.view.addSubview(menuVC.view)
            self.addChildViewController(menuVC)
            menuVC.view.layoutIfNeeded()
            
            
            menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
                sender.isEnabled = true
            }, completion:nil)
        
    }
    func slideMenuItemSelectedAtIndex(_ index: Int32) {
        let topViewController : UIViewController = self.navigationController!.topViewController!
        print("View Controller is : \(topViewController) \n", terminator: "")
        print(index)
        switch(index){
        case 0:
            print("webinars\n", terminator: "")
            
            
            break
        case 1:
            print("expert\n", terminator: "")
            
            // self.openViewControllerBasedOnIdentifier("expert")
            
            break
        case 2 :
            print("coming\n", terminator: "")
            
            //            self.openViewControllerBasedOnIdentifier("coming")
            break
        default:
            print("default\n", terminator: "")
        }
    }
    func send_otp_on_mobile(mobile_number:String,msg:String,fourDigit:String){
        if Connectivity.isConnectedToInternet{
        let parameters = ["mobile" : "\(mobile_number)","msg" : "\(msg)"]
            print(fourDigit)
            
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_SMS)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseJSON { response in
                    
                    if (response.result.value as? Any) != nil{
                        let data = response.result.value
                        if let code = data as? NSArray {
                            //print(code)
                            for code in (code.value(forKey: "code") as? NSArray)! {
                                print(code)
                                let msg_code = String(code as! Int)
                                if msg_code != Constants.ERROR_CODE_1701{
                                    
                                    self.presentWindow!.makeToast(message: "Failed To Send OTP on Mobile")
                                    
                                }
                                else{
                                    print("otpScreen")
                                    
                                }
                                
                            }
                        }
                    }
                    else{
                        print(response.result.error ?? "")
                    }
            }
        }
        else{
           presentWindow?.makeToast(message: "Internet Connection not Available")
            // self.navigationController?.view.makeToast("Internet Connection not Available!", duration: 3.0, position: .center)
            }
    }
    //send email
    func send_otp_on_Email(ToEmailID:String,FromEmailID:String,Body:String,Subject:String){
       // print("\(tfEmail.text!) @@@@ \(fourDigit)")
        let parameters = ["ToEmailID" : "\(ToEmailID.covertToBase64())","FromEmailID" :"support@fintoo.in","Body" :"\(Body.covertToBase64())","Subject": "\(Subject.covertToBase64())","enc_resp":"M3lvdXJTZWNyZXRLZXk1A3Q2Z2wsx"]
       print(parameters,"email")
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.SEND_APP_EMAIL1)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
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
                    print(response.result.value ?? "register")
                    let data = dict
                    print(data ,"register")
                    //let data = response.result.value
                    if (data as? Any) != nil{
                        //print(data)
                        if let code = data as? NSArray {
                            //print(code)
                            for code in (code.value(forKey: "error") as? NSArray)! {
                                 print(code)
                                let email_code = code as! String
                                
                                if email_code == Constants.ERROR_CODE_1007{
                                    self.presentWindow?.makeToast(message: "OTP Failed To Sent on Mail")
                                    
                                }
                                else{
                                    print("OTP Send on mail")
                                    if flag == "1" {
                                    
                                    }
                                    //self.presentWindow!.makeToast(message: "OTP Failed To Sent on Mail")
                                    
                                }
                            }
                        }
                    }
            }
        }
        else{
        presentWindow!.makeToast(message: "Internet Connection not Available")
           
        }
    }
    func convertToDictionary(text: String) -> [Dictionary<String,Any>] {
        
        let data = text.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                return jsonArray
            } else {
                print("bad json")
                return [["error_in":"decryption"]]
            }
        } catch let error as NSError {
            print(error)
            
        }
        return [["error_in":"decryption"]]
    }
    func covertToBase64(text:String) -> String {
        let st = text
        let sk = st + "yourSecretKey"
        let data = (sk).data(using: String.Encoding.utf8)
        if data != nil {
            let enc_key = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let enc_idf = enc_key + "1A3Q2Z2wsx"
            return enc_idf
        } else {
            return ""
        }
    }
    func convertToDictionary3(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    func jsonToNSData(json: [Dictionary<String,Any>]) -> NSData?{
        do {
            return try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        } catch let myJSONError {
            print(myJSONError)
        }
        return nil;
    }
    
}


extension String {
    func isValidEmail() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: characters.count)) != nil
    }
    var isEmptyField: Bool {
        return trimmingCharacters(in: NSCharacterSet.whitespaces) == ""
    }
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespaces).joined()
    }
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
    var decimalString:String {
        let a = Double(self)
        let formatedstring = String(format: "%.2f", a!)
        let string = formatedstring + " %"
        return string
    }
    
    
}
extension UITextField {
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}
extension UIButton {
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSRange(location: 0, length: text.count))
        
        self.setAttributedTitle(attributedString, for: .normal)
    }
}
extension UIImage{
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1))
    {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
}
extension UIView {
    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutAttribute = .height) -> Void {
        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
            constraint.constant = gone ? 0.0 : dimension
            self.layoutIfNeeded()
            self.isHidden = gone
        }
    }
    @IBInspectable var shadowOffset: CGSize{
        get{
            return self.layer.shadowOffset
        }
        set{
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor{
        get{
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set{
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        get{
            return self.layer.shadowRadius
        }
        set{
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        get{
            return self.layer.shadowOpacity
        }
        set{
            self.layer.shadowOpacity = newValue
        }
    }
//    func visiblity(gone: Bool, dimension: CGFloat = 0.0, attribute: NSLayoutAttribute = .height) -> Void {
//        if let constraint = (self.constraints.filter{$0.firstAttribute == attribute}.first) {
//            constraint.constant = gone ? 0.0 : dimension
//            self.layoutIfNeeded()
//            self.isHidden = gone
//        }
//    }
    
        
        // OUTPUT 1
        func dropShadow(scale: Bool = true) {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = 0.5
            layer.shadowOffset = CGSize(width: -1, height: 1)
            layer.shadowRadius = 1
            
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue?.cgColor
        }
    }
}
extension String {
    
    var withoutHtmlTags: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMMM d, yyyy"
        let strMonth = dateFormatter1.string(from: date!)
        return strMonth
        
    }
    func toDateWithFormat(withFormat format: String = "yyyy-MM-dd")-> String?{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: self)
        
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "MMM d, yyyy"
        let strMonth = dateFormatter1.string(from: date!)
        return strMonth
        
    }
    
    func fileName() -> String {
        return NSURL(fileURLWithPath: self).deletingPathExtension?.lastPathComponent ?? ""
    }
    
    func fileExtension() -> String {
        return NSURL(fileURLWithPath: self).pathExtension ?? ""
    }
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    func convertToBase64() -> String {
        let data = (self).data(using: String.Encoding.utf8)
        if data != nil {
            let enc_key = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            return enc_key
        } else {
            return ""
        }
    }
    func covertToBase64() -> String {
        let st = self
        let sk = st + "yourSecretKey"
        let data = (sk).data(using: String.Encoding.utf8)
        if data != nil {
            let enc_key = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let enc_idf = enc_key + "1A3Q2Z2wsx"
            return enc_idf
        } else {
            return ""
        }
    }
    func covertToBase64(text:String) -> String {
        let st = text
        let sk = st + "yourSecretKey"
        let data = (sk).data(using: String.Encoding.utf8)
        if data != nil {
            let enc_key = data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
            let enc_idf = enc_key + "1A3Q2Z2wsx"
            return enc_idf
        } else {
            return ""
        }
    }
    func convertToObjBase64() -> [String] {
        let data = (self).data(using: String.Encoding.utf8)
        if data != nil {
            return [data!.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))]
        } else {
            return [""]
        }
    }
    func base64Decoded() -> String? {
        var st = self
        st += String(repeating: "=", count: (self.count % 4))
        guard let data = Data(base64Encoded: st) else { return nil }
        return String(data: data, encoding: .utf8)
    }
//    func base64Decoded() -> String? {
//        var st = self;
//        print(self.count % 4)
//        if (self.count % 4 <= 2){
//            st += String(repeating: "=", count: (self.count % 4))
//        }
//        guard let data = Data(base64Encoded: st) else { return nil }
//        return String(data: data, encoding: .utf8)
//    }
//    func base64Decoded() -> String? {
//        guard let data = Data(base64Encoded: self) else { return nil }
//        return String(data: data, encoding: .utf8)
//    }
    
   
    func convertToDictionary(text: String) -> [Dictionary<String,Any>] {
        
        let data = text.data(using: .utf8)!
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                print(jsonArray)
                     
                print("aa gaya output")// use the json here
            } else {
                print("bad json")
                return [["error_in":"decryption"]]
            }
        } catch let error as NSError {
            print(error)
            
        }
        return [["error_in":"decryption"]]
    }
}

extension UITableView {
    
    func scrollToBottom() {
        let rows = self.numberOfRows(inSection: 0)
        
        let indexPath = IndexPath(row: rows - 1, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: true)
    }
}

extension UIView {
    func setShadow()
    {
        self.layer.shadowOpacity = 1.0
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 2.0, height: 5.0)
        self.layer.shadowRadius = 2.0
        self.layer.shadowColor = UIColor.darkGray.cgColor
    }
    
    func hideShadow(){
        self.layer.shadowOpacity = 0.0
        self.clipsToBounds = false
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 0.0
        self.layer.shadowColor = UIColor.white.cgColor
    }
}
extension Date {
    static func getFormattedDate(string: String , formatter:String) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"
        
        let date: Date? = dateFormatterGet.date(from: "2018-02-01T19:10:04+00:00")
        print("Date",dateFormatterPrint.string(from: date!)) // Feb 01,2018
        return dateFormatterPrint.string(from: date!);
    }
}
extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}
