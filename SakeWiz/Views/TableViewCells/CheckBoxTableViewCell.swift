//
//  CheckBoxTableViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/05.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit

class CheckBoxTableViewCell: UITableViewCell {

    
    @IBOutlet weak var CheckMarkImageView: UIImageView!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
