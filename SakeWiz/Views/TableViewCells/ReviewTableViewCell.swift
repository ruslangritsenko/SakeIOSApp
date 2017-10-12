//
//  ReviewTableViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/26.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit

protocol ReviewTableViewCellProtocol {
    
    func likeButtonPressedAt(index: IndexPath)
    
    func userWasPressedAt(index: IndexPath)
    
}


class ReviewTableViewCell: UITableViewCell {

    
    var delegate: ReviewTableViewCellProtocol?
    var indexPath: IndexPath!
    
    var isLiked = false
    {
        didSet {
        
            if isLiked
            {
                self.heartIcon.image = UIImage(named: "thumbs_icon_green")
            }
            else
            {
                self.heartIcon.image = UIImage(named: "empty_thumbs")
            }
        
        }
    }
    
    var rating: Double = 0
    {
        didSet {
        
            switch rating {
            case  0..<0.5:
                star1.image = UIImage(named: "star_icon_gray")
                star2.image = UIImage(named: "star_icon_gray")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
            case 0.5..<1:
                star1.image = UIImage(named: "half_star_yellow")
                star2.image = UIImage(named: "star_icon_gray")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 1..<1.5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_gray")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 1.5..<2:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "half_star_yellow")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
            case 2..<2.5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 2.5..<3:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "half_star_yellow")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 3..<3.5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 3.5..<4:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "half_star_yellow")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 4..<4.5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "star_icon_yellow")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 4.5..<5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "star_icon_yellow")
                star5.image = UIImage(named: "half_star_yellow")
                
            case 5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "star_icon_yellow")
                star5.image = UIImage(named: "star_icon_yellow")
            default:
                star1.image = UIImage(named: "star_icon_gray")
                star2.image = UIImage(named: "star_icon_gray")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
            }
        
        
        }
    
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBAction func userNameButtonAction(_ sender: UIButton) {
        
        delegate?.userWasPressedAt(index: self.indexPath)
        
    }
    @IBOutlet weak var locationLabel: UILabel!
    
    //stars
    @IBOutlet weak var star5: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star1: UIImageView!
    
    @IBOutlet weak var specialUserLabel: UILabel!
    @IBOutlet weak var levelIconImage: UIImageView!
    
    
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    @IBOutlet weak var reviewTextLabelHeight: NSLayoutConstraint!

    
    @IBOutlet weak var heartIcon: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    
    

    @IBOutlet weak var affiliateLogoImageView: UIImageView!
    
    @IBAction func likeAction(_ sender: UIButton) {
        
        self.delegate?.likeButtonPressedAt(index: self.indexPath)
        
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
