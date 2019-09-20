//
//  PanAlertSuccessViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 31/10/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
import Mixpanel

class PanAlertSuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okBtn(_ sender: Any) {
        Mixpanel.mainInstance().track(event: "Pancard Screen :- Alert Ok Button Clicked")
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
        let navController = UINavigationController(rootViewController: destVC)
        self.present(navController, animated:true, completion: nil)
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
