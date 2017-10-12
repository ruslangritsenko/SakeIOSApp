//
//  SideBarViewController.swift
//  SakeWiz
//
//  Created by TW welly on 12/12/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit
import Localize_Swift

protocol SideMenuProtocol {
    
    func shouldGoToNewController(fromVCName: String)
    
}

class SideBarViewController: UITableViewController {

    
    fileprivate class sideViewCellData
    {
        var displayName: String
        var icon: UIImage?
        
        init()
        {
            displayName = ""
            icon = nil
        }
        
        init(settingsName: String, iconImage: UIImage?)
        {
            displayName = settingsName
            icon = iconImage
        }
    }
    
    fileprivate let selections = [sideViewCellData(settingsName: "Search Places".localized(), iconImage: UIImage(named: "search_icon_white")), sideViewCellData(settingsName: "My Profile".localized(), iconImage: UIImage(named: "myprofile_icon")), sideViewCellData(settingsName: "Followers".localized(), iconImage: UIImage(named: "followers_icon")), sideViewCellData(settingsName: "Private Notes".localized(), iconImage: UIImage(named: "notes_icon")), sideViewCellData(settingsName: "Saved Sakes".localized(), iconImage: UIImage(named: "small_sake_bottle_white")), sideViewCellData(settingsName: "Newsfeed".localized(), iconImage: UIImage(named: "newsfeed_icon")), sideViewCellData(settingsName: "My Purchases".localized(), iconImage: UIImage(named: "shopping_basket_icon")), sideViewCellData(settingsName: "Inventory Add".localized(), iconImage: UIImage(named: "inventory_add_icon")), sideViewCellData(settingsName: "Settings".localized(), iconImage: UIImage(named: "settings_icon")), sideViewCellData(settingsName: "Logout".localized(), iconImage: UIImage(named: "logout_icon"))]
    
    var delegate: SideMenuProtocol?
    
    var fromVC: String = ""
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.navigationController?.isNavigationBarHidden = true
        
        if let from = SideViewHelperClass.sharedInstance.fromVC
        {self.fromVC = from}
        self.delegate = SideViewHelperClass.sharedInstance.passedDelegate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "SideBarTableViewCell", bundle: nil), forCellReuseIdentifier: "SideBarTableViewCell")
        self.tableView.register(UINib(nibName: "SideBarButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "SideBarButtonTableViewCell")
        
        let backgroundImage = UIImage(named: "dashboard_background_default")
        
        let imageView = UIImageView(image: backgroundImage)
        imageView.contentMode = .scaleAspectFill
        imageView.addOverlayWith(color: .black, alphaValue: 0.5)
        self.tableView.backgroundView = imageView

        // Do any additional setup after loading the view.
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
    
    
    // MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return (tableView.frame.height / (CGFloat(self.selections.count) + CGFloat(1.5)))
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.selections.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if selections.count == indexPath.row
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarButtonTableViewCell", for: indexPath) as? SideBarButtonTableViewCell
            {
            
                cell.selectionStyle = .none
                
                return cell
            }
            
        }
        else
        {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "SideBarTableViewCell", for: indexPath) as? SideBarTableViewCell
            {
            
                cell.selectionStyle = .none
                
                cell.menuLabel.text = selections[indexPath.row].displayName
                cell.iconImageHeight.constant = "k".height(withConstrainedWidth: cell.menuLabel.frame.width, font: cell.menuLabel.font)
                
                cell.iconImageView.image = selections[indexPath.row].icon
                
                
                
                
                return cell
            }
        }
        
        return UITableViewCell()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
        if indexPath.row != self.selections.count
        {
        
            print("Selected \(self.selections[indexPath.row].displayName)")
            switch self.selections[indexPath.row].displayName {
                
            case "Inventory Add".localized():
                SideViewHelperClass.setSharedInstance(moveToViewName: "Inventory Add", shouldMoveToView: true)
                self.dismiss(animated: true, completion: {self.delegate!.shouldGoToNewController(fromVCName: self.fromVC)})
            case "Settings".localized():
                SideViewHelperClass.setSharedInstance(moveToViewName: "Settings", shouldMoveToView: true)
                self.dismiss(animated: true, completion: {self.delegate!.shouldGoToNewController(fromVCName: self.fromVC)})
            case "Search Places".localized():
                SideViewHelperClass.setSharedInstance(moveToViewName: "Search", shouldMoveToView: true)
                self.dismiss(animated: true, completion: {self.delegate!.shouldGoToNewController(fromVCName: self.fromVC)})
            case "Newsfeed".localized():
                SideViewHelperClass.setSharedInstance(moveToViewName: "Newsfeed", shouldMoveToView: true)
                self.dismiss(animated: true, completion: {self.delegate!.shouldGoToNewController(fromVCName: self.fromVC)})
            case "Logout".localized():
                SideViewHelperClass.setSharedInstance(moveToViewName: "SplashScreen", shouldMoveToView: true)
                
                self.dismiss(animated: true, completion: {self.delegate!.shouldGoToNewController(fromVCName: self.fromVC)})
            default:
                SideViewHelperClass.setSharedInstance(moveToViewName: "", shouldMoveToView: false)
                
                self.dismiss(animated: true, completion: {self.delegate!.shouldGoToNewController(fromVCName: self.fromVC)})
            }
        
        }
        else
        {
            SideViewHelperClass.setSharedInstance(moveToViewName: "Camera", shouldMoveToView: true)
            
            self.dismiss(animated: true, completion: {self.delegate!.shouldGoToNewController(fromVCName: self.fromVC)})
        
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
