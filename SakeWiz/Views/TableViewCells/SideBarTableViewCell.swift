//
//  SideBarTableViewCell.swift
//  SakeWiz
//
//  Created by TW welly on 12/12/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit

class SideBarTableViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var iconImageHeight: NSLayoutConstraint!
    @IBOutlet weak var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
