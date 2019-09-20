//
//  ViewControllerCell.swift
//  Fintoo
//
//  Created by iosdevelopermme on 15/02/18.
//  Copyright © 2018 iosdevelopermme. All rights reserved.
//

import UIKit

class ViewControllerCell: UITableViewCell {
    @IBOutlet weak var namelabel: UILabel!
    
    @IBOutlet weak var imageview: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
