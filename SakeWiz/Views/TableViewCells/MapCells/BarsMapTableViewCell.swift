//
//  BarsMapTableViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 12/19/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit

class BarsMapTableViewCell: UITableViewCell {

    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var barNameLabel: UILabel!
    
    @IBOutlet weak var barLocationLabel: UILabel!
    
    @IBOutlet weak var barDescriptionLabel: UILabel!
    
    @IBOutlet weak var starLabel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var barTypeLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
