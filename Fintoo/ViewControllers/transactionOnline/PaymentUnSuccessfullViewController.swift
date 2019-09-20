//
//  PaymentUnSuccessfullViewController.swift
//  Fintoo
//
//  Created by iosdevelopermme on 09/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class PaymentUnSuccessfullViewController: BaseViewController {
    @IBOutlet weak var successLabel: UILabel!
    
    @IBOutlet weak var descLabel: UILabel!
    var success : String!
    var titles : String!
    var desc : String!
    var id : String!
    override func viewDidLoad() {
        print("PaymentUnsuccessful id: \(id)")
        super.viewDidLoad()
        addBackbutton()
        setWhiteNavigationBar()
        successLabel.text = success!
        self.title = titles
        if id == "1"{
            descLabel.text = desc!
            okbtn.isHidden = false
            descLabel.isHidden = false
        }
        else{
//            descLabel.isHidden = true
//            okbtn.isHidden = true
            
            //descLabel.text = desc!
            okbtn.isHidden = false
            //descLabel.isHidden = false
        }
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var okbtn: UIButton!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        print("back")
        
        
        if id == "1"{
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
            
            navigationController?.pushViewController(destVC, animated: true)
        }else{
            let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
            destVC.selectIndexValue = true
            
            
            self.navigationController?.pushViewController(destVC, animated: true)
        }
        
    }
    @IBAction func ok(_ sender: UIButton) {
        if id == "1"{
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(destVC, animated: true)
        }
        else {
            let storyBoard = UIStoryboard(name: "Portfolio", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "DashbordTabBarViewController") as! DashbordTabBarViewController
            destVC.selectIndexValue = true
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }

}
