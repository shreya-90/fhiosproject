//
//  PersonalDetailTableViewCell.swift
//  Fintoo
//
//  Created by iosdevelopermme on 21/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class PersonalDetailTableViewCell: UITableViewCell {
    @IBOutlet weak var personalimageview: UIImageView!
    
    @IBOutlet weak var detailLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
