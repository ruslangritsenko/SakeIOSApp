//
//  SortByViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/06.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Localize_Swift

protocol SortByProtocol {

    func shouldSortBy(sortBy: String)
    
}

class SortByViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let sortOptions = ["Highest Rated".localized(), "Lowest Rated".localized(), "Most Comments".localized(), "Least Comments".localized(), "Most Favored".localized(), "Most Reviewed".localized()]
    
    
    var selected = "None".localized()
    var shouldDeselect = true
    
    public var shouldSet = String()
    {
        didSet{
            shouldDeselect = true
            selected = shouldSet
            self.tableView.reloadData()
        }
    }
    
    
    var containerDelegate: SortByProtocol?
    
    @IBOutlet weak var doneButton: UIButton!
    @IBAction func doneButtonAction(_ sender: UIButton) {
        
        containerDelegate?.shouldSortBy(sortBy: selected)
        
    }

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var sortByLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "SortTableViewCell", bundle: nil), forCellReuseIdentifier: "SortTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func dismissView()
    {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //return (tableView.frame.height / (CGFloat(dataArray.count) + CGFloat(1.5)))
        
        return tableView.frame.height / CGFloat(sortOptions.count)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return sortOptions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SortTableViewCell", for: indexPath) as? SortTableViewCell
        {
        
            if self.selected == self.sortOptions[indexPath.row]
            {
                cell.isChecked = true
            }
            
            cell.cellLabel.text = sortOptions[indexPath.row]
            
            cell.checkImageHeight.constant = sortOptions[indexPath.row].height(withConstrainedWidth: cell.cellLabel.frame.width, font: cell.cellLabel.font)
            
            return cell
        }
//        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionsTableViewCell", for: indexPath) as? AdditionsTableViewCell
//        {
//            let currentProduct = dataArray[indexPath.row]
//            cell.brandLabel.text = currentProduct.sakeName
//            
//            if let url = URL(string: currentProduct.mainImageURLString)
//            {
//                cell.itemImageView.kf.setImage(with: url, placeholder: UIImage(named:"screenshot_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
//            }
//            
//            
//            let someFont = UIFont.systemFont(ofSize: cell.brandLabel.font.pointSize * 0.6)
//            cell.nameLabel.font = someFont
//            
//            
//            cell.likesLabel.text = String(currentProduct.likeCount)
//            cell.likesIconHeight.constant = "0".height(withConstrainedWidth: cell.likesLabel.frame.width, font: cell.likesLabel.font)
//            
//            cell.MessagesLabel.text = String(currentProduct.messageCount)
//            cell.messagesIconHeight.constant = "0".height(withConstrainedWidth: cell.MessagesLabel.frame.width, font: cell.MessagesLabel.font)
//            
//            cell.timeStampLabel.text = "Today"
//            cell.clockIconHeight.constant = "Today".height(withConstrainedWidth: cell.MessagesLabel.frame.width, font: cell.MessagesLabel.font)
//            
//            
//            cell.locationPinIconHeight.constant = "0".height(withConstrainedWidth: cell.locationLabel.frame.width, font: cell.locationLabel.font)
//            
//            cell.starRating = currentProduct.rating
//            
//            
//            
//            return cell
//        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("selected")
        
        if selected == sortOptions[indexPath.row]
        {
            selected = "None".localized()
            if let cell = tableView.cellForRow(at: indexPath) as? SortTableViewCell
            {
                cell.isChecked = false
            }
        }
        else
        {
            selected = sortOptions[indexPath.row]
            if let cell = tableView.cellForRow(at: indexPath) as? SortTableViewCell
            {
                cell.isChecked = true
            }
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        print("deselect")
        if let cell = tableView.cellForRow(at: indexPath) as? SortTableViewCell
        {
            cell.isChecked = false
        }

    }
    
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */

}
