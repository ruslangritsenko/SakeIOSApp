//
//  SwitchTableViewCell.swift
//  SakeWiz
//
//  Created by TW welly on 12/14/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit


protocol SwitchTableViewCellProtocol {
    func cellSwitchDidChangeAt(indexPath: IndexPath, isOn: Bool, cellText: String?)
}

class SwitchTableViewCell: UITableViewCell {

    
    @IBOutlet weak var cellLabel: UILabel!
    
    @IBOutlet weak var cellSwitch: UISwitch!
    
    @IBAction func SwitchDidChange(_ sender: UISwitch) {
        
        if self.indexPath != nil
        {
            
            delegate?.cellSwitchDidChangeAt(indexPath: self.indexPath!, isOn: sender.isOn, cellText: self.cellLabel.text)
        }
        
    }
    
    var indexPath: IndexPath?
    var delegate: SwitchTableViewCellProtocol?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
