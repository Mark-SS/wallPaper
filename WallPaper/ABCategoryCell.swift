//
//  ABCategoryCell.swift
//  WallPaper
//
//  Created by gongliang on 15/12/8.
//  Copyright © 2015年 AB. All rights reserved.
//

import UIKit

class ABCategoryCell: UITableViewCell {

    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
