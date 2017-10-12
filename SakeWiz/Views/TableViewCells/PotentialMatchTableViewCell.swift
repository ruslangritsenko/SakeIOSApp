//
//  PotentialMatchTableViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/26.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit

protocol PotentialMatchTableViewCellProtocol {

    func matchWasSelectedAt(index: IndexPath)

}

class PotentialMatchTableViewCell: UITableViewCell {
    
    var delegate: PotentialMatchTableViewCellProtocol?
    var indexPath: IndexPath!

    @IBOutlet weak var sakeImageView: UIImageView!
    
    @IBOutlet weak var sakeNameLabel: UILabel!
    @IBOutlet weak var underSakeLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var messagesIcon: UIImageView!
    @IBOutlet weak var messagesLabel: UILabel!
    
    @IBOutlet weak var likesIcon: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    
    @IBOutlet weak var selectMatchLabel: UILabel!
    @IBOutlet weak var checkMarkIcon: UIImageView!
    
    @IBAction func selectMatchButtonAction(_ sender: UIButton) {
        
        delegate?.matchWasSelectedAt(index: indexPath)
        
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
