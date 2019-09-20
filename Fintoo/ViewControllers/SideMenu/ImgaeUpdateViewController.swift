//
//  ImgaeUpdateViewController.swift
//  Minty
//
//  Created by iosdevelopermme on 05/01/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import  Alamofire
import Mixpanel
class ImgaeUpdateViewController: BaseViewController {

    @IBOutlet weak var imageView: UIImageView!
    var toimage = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        presentWindow = UIApplication.shared.keyWindow
        imageView.image  = toimage
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnUpdate(_ sender: Any) {
         Mixpanel.mainInstance().track(event: "Navigation Bar :- uplaod profile (Alert) update button clicked ")
       // imageView.image = chosenImage //4
        //Mixpanel.mainInstance().track(event: "Image Update Screen :-  Upadte Button Pressed")
        var imageurl = ""
        let imageData:NSData = UIImageJPEGRepresentation(imageView.image!,0.5)! as NSData
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        print(imageStr)
        let uid = UserDefaults.standard.value(forKey: "parent_user_id")
        //let toEmail = UserDefaults.standard.value(forKey: "Email")
//        UserDefaults.standard.setValue(imageStr, forKey: "profile_img")
        print(uid,"UId")
        let parameters = ["id" : "\(uid!)","profile" : "\(imageStr)","enc_resp":"3"]
        print(parameters)
        presentWindow?.makeToastActivity(message: "Updating...")
        if Connectivity.isConnectedToInternet{
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.updateimg)", method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .responseString { response in
                    let enc_response = response.result.value
                    var dict = [Dictionary<String,Any>]()
                    let enc1 = enc_response?.replacingOccurrences(of: " " , with: "")
                    if let enc = enc1?.base64Decoded() {
                        dict = self.convertToDictionary(text: enc)
                    } else{
                        self.presentWindow.hideToastActivity()
                    }
                    let data = dict
                    print(response.result.value ?? "")
                    //let data = response.result.value

                    if (data as? Any) != nil{
                        print("@@@@@@@@@@@@@@@@",data)
                       if let code = data as? NSArray {
                        for a in data as! NSArray{
                            let error = (a as AnyObject).value(forKey: "error") as? String
                            print(error)
                            if error != "1006"{
                             imageurl = (a as AnyObject).value(forKey: "imgurl") as! String
                            print(imageurl,"done")
                            self.presentWindow?.hideToastActivity()
                           // self.profilePicture.image = chosenImage
                           // let toEmail = UserDefaults.standard.value(forKey: "Email")
                             Mixpanel.mainInstance().track(event: "Navigation Bar :- Profile Image Updated Successfully")
                            self.presentWindow!.makeToast(message: "Profile Image Updated Successfully")
                               // Mixpanel.mainInstance().track(event: "Image Update Screen :- Profile Updated Successfully")
                                
                            //self.profilePicture.hnk_setImageFromURL(URL(string:imageurl!)!)
                            UserDefaults.standard.setValue(imageurl, forKey: "profile_img")
                            }
                            else{
                                self.presentWindow?.hideToastActivity()
                                Mixpanel.mainInstance().track(event: "Navigation Bar :- Profile Image Was Not Updated In Our Database Please Try Again")
                                self.presentWindow?.makeToast(message:"Profile Image Was Not Updated In Our Database Please Try Again")
                              //  Mixpanel.mainInstance().track(event: "Image Update Screen :-  Profile Updation Failed")
                            }
                        }
                       }
                       else {
                        self.presentWindow?.hideToastActivity()
                            self.presentWindow!.makeToast(message: "Profile image was not uploaded")
                       // Mixpanel.mainInstance().track(event: "Image Update Screen :- Profile Updation Failed ")
                        }
                    }

            }

        }
        else{
            self.presentWindow?.hideToastActivity()
            self.presentWindow!.makeToast(message: "Connection Failed. Please Try Later ")
        }
        
        self.dismiss(animated: true, completion: nil)
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVc = storyBoard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        destVc.profile = imageurl
        navigationController?.pushViewController(destVc, animated: true)
    }
    
    @IBAction func btnCancel(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Navigation Bar :- uplaod profile (Alert) cancel button clicked ")
        self.dismiss(animated: true, completion: nil)
        //Mixpanel.mainInstance().track(event: "Image Update Screen :- Cancel Button Pressed ")
    }

}
