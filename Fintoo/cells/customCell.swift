 //
//  customCell.swift
//  ExpandTableCellDemo
//
//  Created by Arun on 4/25/16.
//  Copyright © 2016 Arun. All rights reserved.
//

import UIKit
 import Charts
 import Cosmos

protocol CustomCellDelegate: class {
    //func updateTableView(row: Int)
    //func defaultcellsize(row: Int)
    //func defaultcellsizelumpsum(row : Int)
    //func updateSIPTableView(row: Int)
    func navigate(row:Int)
    func buyLumpsum(row: Int)
    func buySip(row:Int)
    func CompareFund(row:Int)
}

 
 
class customCell: UITableViewCell {
    var cellTapped:Bool = false
    var sippress = false
    var lumpsum = false
    var mode = 1
    
    @IBOutlet weak var viewSpace: UIView!
    @IBOutlet weak var fundDetailbtnOutlet: UIButton!
    @IBOutlet weak var navLabel: UILabel!
    @IBOutlet weak var fundName: UILabel!
    @IBOutlet weak var sipOutlet: UIButton!
    @IBOutlet weak var buylumpsum: UIButton!
    @IBOutlet weak var lumpsumview: UIView!
    @IBOutlet weak var compareFundCheckBox: UIButton!
    @IBOutlet weak var CustomNav: UIView!
    weak var delegate: CustomCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func fundDetailbtn(_ sender: UIButton) {
        print(sender.tag)
        delegate?.navigate(row: sender.tag)
    }
    @IBAction func sipbutton(_ sender: UIButton) {
        delegate?.buySip(row: sender.tag)
    }
    @IBAction func buyLumpsum(_ sender: UIButton) {
        delegate?.buyLumpsum(row:sender.tag)
    }
    @IBAction func compareFundCheckBoxAction(_ sender: UIButton) {
        delegate?.CompareFund(row: sender.tag)
        
    }
    
}
