//
//  pickAndInvestViewController.swift
//  Fintoo
//
//  Created by Tabassum Sheliya on 30/05/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import UIKit
import CarbonKit
import Alamofire
class pickAndInvestViewController: BaseViewController{
    
    var getPickInvestPlanArr = [GetPickInvestPlan]()
    override func viewDidLoad() {
        super.viewDidLoad()
        addBackbutton()
        let items = ["Most Popular", "Life Events", "Dreams and Desires","Risk Based","Age Based","Miscellaneous"]
        let carbonTabSwipeNavigation = CarbonTabSwipeNavigation(items: items, delegate: self)
        carbonTabSwipeNavigation.setNormalColor(UIColor(hexaString: "#00B4EC"))
        carbonTabSwipeNavigation.setSelectedColor(UIColor.black)
        carbonTabSwipeNavigation.setIndicatorColor(UIColor.black)
        carbonTabSwipeNavigation.insert(intoRootViewController: self)
    }
    override func viewWillAppear(_ animated: Bool) {
//getPickInvestPlan()
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

//#MARK: CarbonTabSwipeNavigationDelegate
extension pickAndInvestViewController  : CarbonTabSwipeNavigationDelegate {
    func carbonTabSwipeNavigation(_ carbonTabSwipeNavigation: CarbonTabSwipeNavigation, viewControllerAt index: UInt) -> UIViewController {
        if index == 0 {
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "pickAndInvestDetailViewController") as! pickAndInvestDetailViewController
            destVC.getPickInvestPlanArr = getPickInvestPlanArr
            destVC.subcategory_id = 0
            return destVC
        }
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "pickAndInvestDetailViewController") as! pickAndInvestDetailViewController
        destVC.subcategory_id = Int(index)
        
        return destVC
    }
}


