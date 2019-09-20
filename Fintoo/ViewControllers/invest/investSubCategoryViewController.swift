//
//  investSubCategoryViewController.swift
//  Fintoo
//
//  Created by Tabassum Sheliya on 03/06/19.
//  Copyright © 2019 iosdevelopermme. All rights reserved.
//

import UIKit

class investSubCategoryViewController: BaseViewController {
    var arrayMenuOptions = [Dictionary<String,String>]()
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        addBackbutton()
        addRightBarButtonItems(items: [cartButton])
        arrayMenuOptions.append(["title":"Mutual Funds", "icon":"invest"])
        arrayMenuOptions.append(["title":"Goal Based Investing", "icon":"my_portfolio"])
        // Do any additional setup after loading the view.
    }
    override func onBackButtonPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(destVC, animated: true)
    }
    override func onCartButtonPressed(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
        let destVC = storyBoard.instantiateViewController(withIdentifier: "CartViewController") as! CartViewController
        self.navigationController?.pushViewController(destVC, animated: true)
    }
}
extension investSubCategoryViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMenuOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! investSubCategoryCell
        cell.subCategoryImage.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
        cell.subCategoryLabel.text = arrayMenuOptions[indexPath.row]["title"]!
        cell.contentView.backgroundColor = UIColor.clear
        
        let whiteRoundedView : UIView = UIView(frame: CGRect(x:10, y:8, width:self.view.frame.size.width - 20, height:160))
        
        whiteRoundedView.layer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 1.0, 0.8])
        whiteRoundedView.layer.masksToBounds = false
        whiteRoundedView.layer.cornerRadius = 8.0
        whiteRoundedView.layer.shadowOffset = CGSize(width:-1, height:1)
        whiteRoundedView.layer.shadowOpacity = 0.2
        
        cell.contentView.addSubview(whiteRoundedView)
        cell.contentView.sendSubview(toBack: whiteRoundedView)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "investViewController") as! investViewController
            self.navigationController?.pushViewController(destVC, animated: true)
                            print("list")
        } else {
            let storyBoard = UIStoryboard(name: "ProductList", bundle: nil)
            let destVC = storyBoard.instantiateViewController(withIdentifier: "pickAndInvestViewController") as! pickAndInvestViewController
            
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
}
class investSubCategoryCell : UITableViewCell {
    @IBOutlet weak var subCategoryImage: UIImageView!
    @IBOutlet weak var subCategoryLabel: UILabel!
}
