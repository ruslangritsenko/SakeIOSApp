//
//  NewFollowerTableViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/30.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit

protocol NewFollowerTableViewProtocol
{
    func acceptTappedAt(index: IndexPath)
    func declineTappedAt(index: IndexPath)
    func avatarTouchedAt(index: IndexPath)
}

class NewFollowerTableViewCell: UITableViewCell {

    var delegate: NewFollowerTableViewProtocol?
    var indexPath: IndexPath!
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var clockIcon: UIImageView!
    @IBOutlet weak var clockIconHeight: NSLayoutConstraint!
    
    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBAction func UserAvatarTouched(_ sender: UIButton) {
        
        delegate?.avatarTouchedAt(index: indexPath)
        
    }
    
    
    @IBOutlet weak var AcceptButton: UIButton!
    @IBAction func AcceptButtonAction(_ sender: UIButton) {
        
        delegate?.acceptTappedAt(index: self.indexPath)
    }
    
    @IBOutlet weak var DeclineButton: UIButton!
    @IBAction func DeclineButtonAction(_ sender: UIButton) {
        
        delegate?.declineTappedAt(index: self.indexPath)
        
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
        super.layoutSubviews()
        
        userAvatarImageView.image = userAvatarImageView.image?.circle
        
    }
    
}
