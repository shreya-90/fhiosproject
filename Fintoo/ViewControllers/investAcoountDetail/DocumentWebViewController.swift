//
//  DocumentWebViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 15/06/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class DocumentWebViewController: BaseViewController,UIWebViewDelegate {
    var url : String!
    
    @IBOutlet weak var webView: UIWebView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        webView.delegate = self
        
        presentWindow?.makeToastActivity(message:"Requesting..")
        
        
        if let url1 = URL(string: "\(url!)") {
            print(url1,"url")
            let request = URLRequest(url: url1)
            presentWindow?.hideToastActivity()
            webView.loadRequest(request)
            self.webView.scrollView.decelerationRate = UIScrollViewDecelerationRateNormal;
            // Do any additional setup after loading the view.
        }
        else{
            presentWindow?.hideToastActivity()
            print(url!,"url")
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func onBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.webView.scrollView.minimumZoomScale = 1.0
        self.webView.scrollView.maximumZoomScale = 5.0
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
