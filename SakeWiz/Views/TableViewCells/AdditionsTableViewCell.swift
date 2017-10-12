//
//  AdditionsTableViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 12/8/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit

class AdditionsTableViewCell: UITableViewCell {
    
    var starRating = Double()
        {
    
        didSet {
            
            switch starRating {
            case  0..<0.5:
                starIconPosition1.image = UIImage(named: "star_icon_gray")
                starIconPosition2.image = UIImage(named: "star_icon_gray")
                starIconPosition3.image = UIImage(named: "star_icon_gray")
                starIconPosition4.image = UIImage(named: "star_icon_gray")
                starIconPosition5.image = UIImage(named: "star_icon_gray")

            case 0.5..<1:
                starIconPosition1.image = UIImage(named: "half_star_yellow")
                starIconPosition2.image = UIImage(named: "star_icon_gray")
                starIconPosition3.image = UIImage(named: "star_icon_gray")
                starIconPosition4.image = UIImage(named: "star_icon_gray")
                starIconPosition5.image = UIImage(named: "star_icon_gray")
                
            case 1..<1.5:
                starIconPosition1.image = UIImage(named: "star_icon_yellow")
                starIconPosition2.image = UIImage(named: "star_icon_gray")
                starIconPosition3.image = UIImage(named: "star_icon_gray")
                starIconPosition4.image = UIImage(named: "star_icon_gray")
                starIconPosition5.image = UIImage(named: "star_icon_gray")
                
            case 1.5..<2:
                starIconPosition1.image = UIImage(named: "star_icon_yellow")
                starIconPosition2.image = UIImage(named: "half_star_yellow")
                starIconPosition3.image = UIImage(named: "star_icon_gray")
                starIconPosition4.image = UIImage(named: "star_icon_gray")
                starIconPosition5.image = UIImage(named: "star_icon_gray")
            case 2..<2.5:
                starIconPosition1.image = UIImage(named: "star_icon_yellow")
                starIconPosition2.image = UIImage(named: "star_icon_yellow")
                starIconPosition3.image = UIImage(named: "star_icon_gray")
                starIconPosition4.image = UIImage(named: "star_icon_gray")
                starIconPosition5.image = UIImage(named: "star_icon_gray")
                
            case 2.5..<3:
                starIconPosition1.image = UIImage(named: "star_icon_yellow")
                starIconPosition2.image = UIImage(named: "star_icon_yellow")
                starIconPosition3.image = UIImage(named: "half_star_yellow")
                starIconPosition4.image = UIImage(named: "star_icon_gray")
                starIconPosition5.image = UIImage(named: "star_icon_gray")
                
            case 3..<3.5:
                starIconPosition1.image = UIImage(named: "star_icon_yellow")
                starIconPosition2.image = UIImage(named: "star_icon_yellow")
                starIconPosition3.image = UIImage(named: "star_icon_yellow")
                starIconPosition4.image = UIImage(named: "star_icon_gray")
                starIconPosition5.image = UIImage(named: "star_icon_gray")
                
            case 3.5..<4:
                starIconPosition1.image = UIImage(named: "star_icon_yellow")
                starIconPosition2.image = UIImage(named: "star_icon_yellow")
                starIconPosition3.image = UIImage(named: "star_icon_yellow")
                starIconPosition4.image = UIImage(named: "half_star_yellow")
                starIconPosition5.image = UIImage(named: "star_icon_gray")
                
            case 4..<4.5:
                starIconPosition1.image = UIImage(named: "star_icon_yellow")
                starIconPosition2.image = UIImage(named: "star_icon_yellow")
                starIconPosition3.image = UIImage(named: "star_icon_yellow")
                starIconPosition4.image = UIImage(named: "star_icon_yellow")
                starIconPosition5.image = UIImage(named: "star_icon_gray")
                
            case 4.5..<5:
                starIconPosition1.image = UIImage(named: "star_icon_yellow")
                starIconPosition2.image = UIImage(named: "star_icon_yellow")
                starIconPosition3.image = UIImage(named: "star_icon_yellow")
                starIconPosition4.image = UIImage(named: "star_icon_yellow")
                starIconPosition5.image = UIImage(named: "half_star_yellow")
                
            case 5:
                starIconPosition1.image = UIImage(named: "star_icon_yellow")
                starIconPosition2.image = UIImage(named: "star_icon_yellow")
                starIconPosition3.image = UIImage(named: "star_icon_yellow")
                starIconPosition4.image = UIImage(named: "star_icon_yellow")
                starIconPosition5.image = UIImage(named: "star_icon_yellow")
            default:
                starIconPosition1.image = UIImage(named: "star_icon_gray")
                starIconPosition2.image = UIImage(named: "star_icon_gray")
                starIconPosition3.image = UIImage(named: "star_icon_gray")
                starIconPosition4.image = UIImage(named: "star_icon_gray")
                starIconPosition5.image = UIImage(named: "star_icon_gray")
            }
        }
    }

    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var brandLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationPinIconHeight: NSLayoutConstraint!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    //MARK: - InfoBar
    
    
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var MessagesLabel: UILabel!
    
    @IBOutlet weak var messagesIconHeight: NSLayoutConstraint!
    @IBOutlet weak var likesIconHeight: NSLayoutConstraint!
    @IBOutlet weak var clockIconHeight: NSLayoutConstraint!
    

    
    
    @IBOutlet weak var starIconPosition1: UIImageView!
    @IBOutlet weak var starIconPosition2: UIImageView!
    @IBOutlet weak var starIconPosition3: UIImageView!
    @IBOutlet weak var starIconPosition4: UIImageView!
    @IBOutlet weak var starIconPosition5: UIImageView!
    
    @IBOutlet weak var locationPinIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
