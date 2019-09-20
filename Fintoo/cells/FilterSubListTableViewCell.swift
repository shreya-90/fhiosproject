//
//  FilterSubListTableViewCell.swift
//  Fintoo
//
//  Created by iosdevelopermme on 08/03/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit
protocol subCategoryDelegate: class {
    func subCategory(row: Int)
}
class FilterSubListTableViewCell: UITableViewCell {
    @IBOutlet weak var subcategorybtn: UIButton!

    @IBOutlet weak var lumpsum_sip: UIStackView!
    
    @IBOutlet weak var buttonBottom: NSLayoutConstraint!
    
    weak var delegate: subCategoryDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        //buttontop.constant = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    @IBAction func subCategorybtnAction(_ sender: UIButton) {
        delegate?.subCategory(row: sender.tag)
    }
    
}
