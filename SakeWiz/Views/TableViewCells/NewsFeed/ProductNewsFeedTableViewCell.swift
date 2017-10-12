//
//  ProductNewsFeedTableViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/30.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit

class ProductNewsFeedTableViewCell: UITableViewCell {

    @IBOutlet weak var sakeImageView: UIImageView!
    
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var clockIcon: UIImageView!
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var sakeNameLabel: UILabel!
    @IBOutlet weak var detailsLabel: UILabel!
    
    @IBOutlet weak var checkIcon: UIImageView!

    @IBOutlet weak var checkIconTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var checkIconTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        

        checkIconTopConstraint.constant = (checkIcon.frame.height / 2) * -1
        
        checkIconTrailingConstraint.constant = (checkIcon.frame.height / 2)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
