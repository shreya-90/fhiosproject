//
//  FAQViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 04/04/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class FAQViewController: BaseViewController,UIWebViewDelegate{
   //  var webView: UIWebView!
    
    @IBOutlet weak var webView: UIWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
       
        webView.delegate = self
        
        presentWindow?.makeToastActivity(message:"Requesting..")
      
        if let url = URL(string: "https://www.financialhospital.in/mobileapp/fintoofaq.html") {
            print(url,"url")
            let request = URLRequest(url: url)
            presentWindow?.hideToastActivity()
            webView.loadRequest(request)
            self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
        // Do any additional setup after loading the view.
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
