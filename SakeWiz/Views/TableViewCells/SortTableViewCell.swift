//
//  SortTableViewCell.swift
//  SakeWiz
//
//  Created by TW welly on 6/11/17.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit

class SortTableViewCell: UITableViewCell {

    @IBOutlet weak var checkImageHeight: NSLayoutConstraint!
    
    @IBOutlet weak var checkImageView: UIImageView!
    
    @IBOutlet weak var cellLabel: UILabel!
    
    var isChecked = false
    {
        didSet{
        
            if isChecked
            {
                checkImageView.image = UIImage(named: "check_circle")
            }
            else
            {
                checkImageView.image = UIImage(named: "circle_empty")
            }
        }
    
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
