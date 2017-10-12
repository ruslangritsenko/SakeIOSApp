//
//  TextEntryTableViewCell.swift
//  SakeWiz
//
//  Created by welly, TW on 12/14/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit

protocol TextEntryTableViewCellProtocol {
    
    func FieldDidEndEditingAt(indexPath: IndexPath, newText: String?)
}

class TextEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var cellTextField: UITextField!
    
    @IBAction func cellTextFieldDidEndEditing(_ sender: UITextField) {
        
        
        if self.indexPath != nil
        {
            delegate?.FieldDidEndEditingAt(indexPath: self.indexPath!, newText: sender.text)
        
        }
    }
    
    
    var indexPath: IndexPath?
    var delegate: TextEntryTableViewCellProtocol?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
