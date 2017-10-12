//
//  ProductDetailsCollectionViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/12.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit

class ProductDetailsCollectionViewCellTop: UICollectionViewCell {

    var cellImage: UIImage? = nil
    {
        didSet{
        
            userAvatarImageView.image = cellImage?.circle
        
        }
    }
    
    @IBOutlet weak var GradeDescriptionLabel: UILabel!
    
    @IBOutlet weak var GradeLabel: UILabel!
    
    @IBOutlet weak var CountryDescriptionLabel: UILabel!
    @IBOutlet weak var CountryLabel: UILabel!
    
    @IBOutlet weak var RegionDescriptionLabel: UILabel!
    @IBOutlet weak var RegionLabel: UILabel!
    
    
    @IBOutlet weak var SMVDescriptionLabel: UILabel!
    @IBOutlet weak var SMVLabel: UILabel!
    
    
    @IBOutlet weak var PolishRateDescriptionLabel: UILabel!
    @IBOutlet weak var PolishRateLabel: UILabel!
    
    
    @IBOutlet weak var ByDescriptionLabel: UILabel!
    @IBOutlet weak var ByLabel: UILabel!

    @IBOutlet weak var AlchoholContentDescriptionLabel: UILabel!
    
    @IBOutlet weak var AlchoholContentLabel: UILabel!
    
    @IBOutlet weak var userDescriptionLabel: UILabel!
    @IBOutlet weak var userAvatarImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
