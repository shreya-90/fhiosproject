//
//  CheckOutTableViewCell.swift
//  Fintoo
//
//  Created by Dharmesh on 11/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class CheckOutTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblMode: UILabel!
    @IBOutlet weak var lblTransactionDate: UILabel!
    @IBOutlet weak var tfMonth: UITextField!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var tfAmmount: UITextField!
    @IBOutlet weak var btnModify: UIButton!
    @IBOutlet weak var btnRemove: UIButton!
    @IBOutlet weak var btnStartDate: UIButton!
    @IBOutlet weak var tfStartDate: UITextField!
    @IBOutlet weak var imgDropDownForSIP: UIImageView!
    @IBOutlet weak var lblYears: UILabel!
    @IBOutlet weak var imgDropDownStartDate: UIImageView!
    @IBOutlet weak var btnTick: UIButton!
    @IBOutlet weak var lblPerpetual: UILabel!
    @IBOutlet weak var fundSelectBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
