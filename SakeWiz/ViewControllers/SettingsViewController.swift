//
//  SettingsViewController.swift
//  SakeWiz
//
//  Created by TW welly on 12/12/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit
import Kingfisher
import Localize_Swift

class SettingsViewController: UITableViewController, UITextFieldDelegate, SwitchTableViewCellProtocol {

    let settingsUserObject = UserObject.sharedInstance
    
    let availableLanguages = Localize.availableLanguages()
    
    //ParallaxTableViewCell
    
    fileprivate let section1: Array<cellLayout> = [cellLayout(cellType: "image", image: UIImage(named: "background"))]
    fileprivate let section2: Array<cellLayout> = [cellLayout(cellType: "textfield", placeholder: "Phone Number"), cellLayout(cellType: "textfield", placeholder: "Email"), cellLayout(cellType: "textfield", placeholder: "Website")]
    
    fileprivate let section3: Array<cellLayout> = [cellLayout(cellType: "switch", display: "Only show comments in my language".localized(), defaultSwitchPosition: UserObject.sharedInstance.userSettings?.shouldShowCommentsInSelectedLanguageOnly), cellLayout(cellType: "switch", display: "Notify me when someone likes my comment".localized())]
    fileprivate let section4: Array<cellLayout> = [cellLayout(cellType: "switch", display: "Save my label photos to local storage".localized(), defaultSwitchPosition: UserObject.sharedInstance.userSettings?.canSavePhotosToLibrary)]
    fileprivate let section5: Array<cellLayout> = [cellLayout(cellType: "logoutButton", display: "Scanned labels will be saved on my device")]
    
    fileprivate var dataArray: Array<Array<cellLayout>> = Array<Array<cellLayout>>()
    
    var sectionHeaders = ["", "YOUR INFO", "REVIEW SETTINGS".localized(), "LABEL SETTINGS".localized(), "REVIEW SETTINGS".localized()]
    
    
    fileprivate class cellLayout {
        
        var cellType: String
        var display: String?
        var placeholder: String?
        var defaultSwitchPosition: Bool?
        var image: UIImage?
    
        init()
        {
            self.cellType = ""
            self.display = ""
            self.placeholder = ""
            self.image = nil
        }
        
        init(cellType: String, display: String? = nil, placeholder: String? = nil, defaultSwitchPosition: Bool? = nil, image: UIImage? = nil)
        {
            self.cellType = cellType
            self.display = display
            self.placeholder = placeholder
            self.image = image
            self.defaultSwitchPosition = defaultSwitchPosition
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dataArray = [section1, section2, section3, section4, section5]
        

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "ParallaxTableViewCell", bundle: nil), forCellReuseIdentifier: "ParallaxTableViewCell")
        self.tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "TestTableViewCell")
        self.tableView.register(UINib(nibName: "TextEntryTableViewCell", bundle: nil), forCellReuseIdentifier: "TextEntryTableViewCell")
        self.tableView.register(UINib(nibName: "SwitchTableViewCell", bundle: nil), forCellReuseIdentifier: "SwitchTableViewCell")
        self.tableView.register(UINib(nibName: "LogoutTableViewCell", bundle: nil), forCellReuseIdentifier: "LogoutTableViewCell")
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func doChangeLanguage() {
        let actionSheet = UIAlertController(title: nil, message: "Switch Language".localized(), preferredStyle: UIAlertControllerStyle.actionSheet)
        for language in availableLanguages {
            let displayName = Localize.displayNameForLanguage(language)
            let languageAction = UIAlertAction(title: displayName, style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                Localize.setCurrentLanguage(language)
            })
            actionSheet.addAction(languageAction)
        }
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertActionStyle.cancel, handler: {
            (alert: UIAlertAction) -> Void in
        })
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
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
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell") as? TestTableViewCell
        {
            cell.cellLabel.text = self.sectionHeaders[section]
            
            return cell
        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if self.sectionHeaders[section] == ""
        {
            return 0
        }
        
        return 50
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionHeaders[section]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if indexPath.section == 0 && indexPath.row == 0
        {
            return cellHeight
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return self.dataArray.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if section == 0
        {
            return 1
        }
        
        return self.dataArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellContent = self.dataArray[indexPath.section][indexPath.row]
        
        switch  cellContent.cellType {
        case "image":
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParallaxTableViewCell", for: indexPath) as! ParallaxTableViewCell
            cell.parallaxImageView.image = cellContent.image
            cell.parallaxHeightConstraint.constant = parallaxImageHeight
            cell.parallaxTopConstraint.constant = parallaxOffsetFor(newOffsetY: tableView.contentOffset.y, cell: cell)
            
            cell.backgroundColor = .white
            
            cell.usernameLabel.text = UserObject.sharedInstance.handle
            
            
            if let url = UserObject.sharedInstance.userAvatarURL
            {
                cell.profilePicture.kf.setImage(with: url, placeholder: UIImage(named: "screenshot_avatar"), options: nil, progressBlock: nil, completionHandler: {completion in
                    
                    if completion.1 != nil
                    {
                        print("KingFisher Fetch Error: \(String(describing: completion.1))")
                    }
                    cell.profilePicture.image = completion.0?.circle
                    
                })
                
            }
            
            
            return cell
        case "textfield":
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextEntryTableViewCell", for: indexPath) as! TextEntryTableViewCell
            
            cell.cellTextField.delegate = self
            
            cell.cellTextField.placeholder = cellContent.placeholder
            cell.cellTextField.text = cellContent.display
            
            cell.backgroundColor = .white
            return cell
            
        case "switch":
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell
            cell.cellLabel.text = cellContent.display
            
            cell.cellSwitch.isOn = cellContent.defaultSwitchPosition ?? true
            
            cell.delegate = self
            cell.indexPath = indexPath
            
            return cell
            
        case "logoutButton":
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoutTableViewCell", for: indexPath) as! LogoutTableViewCell
            
            cell.logoutButton.removeTarget(nil, action: nil, for: .allEvents)

            cell.logoutButton.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
                
            cell.backgroundColor = .white
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as! TestTableViewCell
            cell.cellLabel.text = cellContent.display
            
            cell.backgroundColor = .white
            return cell
        }
    }
    
    func logoutAction(sender: UIButton)
    {
        self.navigationController!.popViewController(animated: true)
    }
    
    func cellSwitchDidChangeAt(indexPath: IndexPath, isOn: Bool, cellText: String?) {
        
        if let text = cellText
        {
            switch text
            {
            case "Only show comments in my language".localized():
                settingsUserObject.userSettings?.shouldShowCommentsInSelectedLanguageOnly = isOn
            case "Save my label photos to local storage".localized():
                settingsUserObject.userSettings?.canSavePhotosToLibrary = isOn
            default:
                return
            }
        
        }
        
    }
    
    func applyChanges()
    {
        UserObject.sharedInstance = settingsUserObject
    
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
    
    //
    //MARK : - Parallax Scroller
    // Change the ratio or enter a fixed value, whatever you need
    var cellHeight: CGFloat {
        //return self.tableView.frame.width * 9 / 16
        return tableView.frame.height * 0.345
    }
    
    // Just an alias to make the code easier to read
    var imageVisibleHeight: CGFloat {
        return cellHeight
    }
    
    // Change this value to whatever you like (it sets how "fast" the image moves when you scroll)
    let parallaxOffsetSpeed: CGFloat = 55
    
    // This just makes sure that whatever the design is, there's enough image to be displayed, I let it up to you to figure out the details, but it's not a magic formula don't worry :)
    var parallaxImageHeight: CGFloat {
        let maxOffset = (sqrt(pow(cellHeight, 2) + 4 * parallaxOffsetSpeed * tableView.frame.height) - cellHeight) / 2
        return imageVisibleHeight + maxOffset
    }
    
    // Used when the table dequeues a cell, or when it scrolls
    func parallaxOffsetFor(newOffsetY: CGFloat, cell: UITableViewCell) -> CGFloat {
        return ((newOffsetY - cell.frame.origin.y) / parallaxImageHeight) * parallaxOffsetSpeed
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = tableView.contentOffset.y
        
        for cell in tableView.visibleCells {
            
            if let thisCell = cell as? ParallaxTableViewCell
            {
                thisCell.parallaxTopConstraint.constant = parallaxOffsetFor(newOffsetY: offsetY, cell: cell)
            }
        }
    }
    
    // Mark: - TextField Delegate
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let cellIndexPath = indexPathForCellContainingView(view: textField, inTableView: tableView)
        {
            if let cell = tableView.cellForRow(at: cellIndexPath) as? TextEntryTableViewCell
            {
                self.dataArray[cellIndexPath.section][cellIndexPath.row].display = cell.cellTextField.text
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Return pressed")
        
        textField.resignFirstResponder()
        self.textFieldDidEndEditing(textField)
        return true
    }
    
    func indexPathForCellContainingView(view: UIView, inTableView tableView:UITableView) -> IndexPath? {
        
        let viewMidPoint = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        
        let viewInTableView = tableView.convert(viewMidPoint, from: view)
        
        return tableView.indexPathForRow(at: viewInTableView) as IndexPath?
    }


}
