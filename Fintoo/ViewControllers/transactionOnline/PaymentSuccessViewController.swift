//
//  PaymentSuccessViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 09/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class PaymentSuccessViewController: BaseViewController {
    var success : String!
    var titles : String!
    var id : String!
    @IBOutlet weak var successLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        setWhiteNavigationBar()
        successLabel.text = success!
        self.title = titles
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func okBtnPressed(_ sender: UIButton) {
        //self.navigationController?.popViewController(animated: true)
        onBackButtonPressed(sender)
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        print("back")
        if id == "1"{
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            self.navigationController?.pushViewController(destVC, animated: true)
        }else{
            let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
            destVC.selectIndexValue = true
            self.navigationController?.pushViewController(destVC, animated: true)
        }
        
    }

}
