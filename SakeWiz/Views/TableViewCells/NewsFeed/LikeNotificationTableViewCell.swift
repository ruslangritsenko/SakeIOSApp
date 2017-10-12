//
//  LikeNotificationTableViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/29.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit

protocol LikeNotificationTableViewCellProtocol
{
    func userTouchedAt(index: IndexPath)
}

class LikeNotificationTableViewCell: UITableViewCell {

    var delegate: LikeNotificationTableViewCellProtocol?
    var indexPath: IndexPath!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var clockIconHeight: NSLayoutConstraint!
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBAction func UserAvatarTouched(_ sender: UIButton) {
        
        delegate?.userTouchedAt(index: indexPath)
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    override func layoutSubviews() {
        
        userAvatarImageView.image = userAvatarImageView.image?.circle
    }
    
}
