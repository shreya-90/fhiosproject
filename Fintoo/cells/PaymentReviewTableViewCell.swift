//
//  PaymentReviewTableViewCell.swift
//  Fintoo
//
//  Created by Dharmesh on 12/07/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class PaymentReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTenure: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var tfNominee: UITextField!
    @IBOutlet weak var btnDropDown: UIButton!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var sipStartDate: UILabel!
    
    @IBOutlet weak var folioNumberTf: UITextField!
    @IBOutlet weak var folioButtonOutlet: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
