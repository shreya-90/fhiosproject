//
//  TestViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 17/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class TestViewController: UITabBarController,UITabBarControllerDelegate {
    var selectIndexValue  = false
    var id : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(_ animated: Bool) {
        if selectIndexValue{
            if id == "1"{
                self.selectedIndex = 1
            }
            else if id == "2"{
                self.selectedIndex = 2
            }
            else if id == "3"{
                self.selectedIndex = 3
            }
        }
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
