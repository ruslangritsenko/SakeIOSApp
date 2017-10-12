//
//  ParallaxTableViewCell.swift
//  SakeWiz
//
//  Created by TW welly on 12/12/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit

class ParallaxTableViewCell: UITableViewCell {

    @IBOutlet weak var parallaxImageView: UIImageView!
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    // MARK: ParallaxCell
    
    @IBOutlet weak var parallaxHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var parallaxTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        clipsToBounds = true
        //parallaxImageView.contentMode = .scaleAspectFill
        parallaxImageView.clipsToBounds = false
    }
}
