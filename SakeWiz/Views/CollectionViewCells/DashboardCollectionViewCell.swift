//
//  DashboardCollectionViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/25.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellTopLabel: UILabel!
    
    
    
    @IBOutlet weak var cellSakeImageView: UIImageView!
    
    @IBOutlet weak var SakeIdentifiedNumberLabel: UILabel!
    
    @IBOutlet weak var SakeIdentifiedLabel: UILabel!
    
    
    @IBOutlet weak var cellSmilyImageView: UIImageView!
    
    @IBOutlet weak var UnidentifiedSakeNumberLabel: UILabel!
    @IBOutlet weak var UnidentifiedLabel: UILabel!
    @IBOutlet weak var HelpfulMessageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.layer.cornerRadius = 5
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.clear.cgColor
        self.contentView.layer.masksToBounds = true
        
//        self.layer.shadowColor = UIColor.lightGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.layer.shadowRadius = 2.0
//        self.layer.shadowOpacity = 1.0
//        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
    }

}
