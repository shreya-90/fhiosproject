//
//  pickAndInvestDetailViewController.swift
//  Fintoo
//
//  Created by Tabassum Sheliya on 30/05/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import UIKit
import Alamofire
class pickAndInvestDetailViewController: BaseViewController {
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    var subcategory_id = 0
    var getPickInvestPlanArr = [GetPickInvestPlan]()
    var mostPopularArr = [String]()
    var mostPopularImage = [String]()
    var mostPopularPackageId = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        getPickInvestPlan()
        
    }
}

//#MARK: CarbonTabSwipeNavigationDelegate
extension pickAndInvestDetailViewController  : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mostPopularArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! pickAndInvestCell
        if mostPopularArr.count == mostPopularImage.count {
            cell.pickLabel.text = mostPopularArr[indexPath.row]
            cell.pickImage.setImageFromURl(stringImageUrl: mostPopularImage[indexPath.row])
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.categoryCollectionView.frame.size.width/2)-10, height: 155)
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "pickAndInvestFormViewController") as! pickAndInvestFormViewController
        destVC.titles = mostPopularArr[indexPath.row]
        destVC.id_package = mostPopularPackageId[indexPath.row]
        self.navigationController?.pushViewController(destVC, animated: true)
        print("list")
    }
}
class pickAndInvestCell : UICollectionViewCell {
    @IBOutlet weak var pickImage: UIImageView!
    
    @IBOutlet weak var pickLabel: UILabel!
}
//#MARK: API Calls
extension pickAndInvestDetailViewController {
    func getPickInvestPlan(){
        presentWindow.makeToastActivity(message: "Loading..")
        mostPopularArr.removeAll()
        mostPopularImage.removeAll()
        if Connectivity.isConnectedToInternet {
            Alamofire.request("\(Constants.BASE_URL)\(Constants.API.get_pick_invest_plans)").responseJSON { response in
                let response = response.result.value as? [[String:Any]] ?? [[:]]
                for data in response {
                    self.presentWindow.hideToastActivity()
                    let id = data["id"] as? String ?? ""
                    let invest_plans = data["invest_plans"] as? String ?? ""
                    let plans_img_url = data["plans_img_url"] as? String ?? ""
                    let plans_categroy_id = data["plans_categroy_id"] as? String ?? ""
                    let is_most_popular = data["is_most_popular"] as? String ?? ""
                    let getPick = GetPickInvestPlan(id: id, invest_plans: invest_plans, plans_img_url: plans_img_url, plans_categroy_id: plans_categroy_id, is_most_popular: is_most_popular)
                    if is_most_popular == "1" && self.subcategory_id == 0{
                        self.mostPopularArr.append(invest_plans)
                        self.mostPopularImage.append("https://www.fintoo.in/\(plans_img_url)")
                        self.mostPopularPackageId.append(id)
                    } else {
                        if self.subcategory_id == 1 && plans_categroy_id == "1"{
                            self.mostPopularArr.append(invest_plans)
                            self.mostPopularImage.append("https://www.fintoo.in/\(plans_img_url)")
                            self.mostPopularPackageId.append(id)
                        }
                        if self.subcategory_id == 2 && plans_categroy_id == "2"{
                            self.mostPopularArr.append(invest_plans)
                            self.mostPopularImage.append("https://www.fintoo.in/\(plans_img_url)")
                            self.mostPopularPackageId.append(id)
                        }
                        if self.subcategory_id == 3 && plans_categroy_id == "3"{
                            self.mostPopularArr.append(invest_plans)
                            self.mostPopularImage.append("https://www.fintoo.in/\(plans_img_url)")
                            self.mostPopularPackageId.append(id)
                        }
                        if self.subcategory_id == 4 && plans_categroy_id == "4"{
                            self.mostPopularArr.append(invest_plans)
                            self.mostPopularImage.append("https://www.fintoo.in/\(plans_img_url)")
                            self.mostPopularPackageId.append(id)
                        }
                        if self.subcategory_id == 5 && plans_categroy_id == "5"{
                            self.mostPopularArr.append(invest_plans)
                            self.mostPopularImage.append("https://www.fintoo.in/\(plans_img_url)")
                            self.mostPopularPackageId.append(id)
                        }
                     }
                    self.getPickInvestPlanArr.append(getPick)
                    
                }
                self.categoryCollectionView.reloadData()
            }
        } else{
            presentWindow.hideToastActivity()
            presentWindow?.makeToast(message: "No Internet Connection")
        }
    }
}
