//
//  NewsfeedViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/30.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Kingfisher
import Localize_Swift

class NewsfeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NewFollowerTableViewProtocol, LikeNotificationTableViewCellProtocol {

    var dataArray = Array<NotificationObject>()
    var canFetchMore = true
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        API.getNotifications(notificaitonAmount: "25", lastID: nil, completionHandler: {(notificationsArray, _) in
        
            self.dataArray = notificationsArray
            
            let testObject = NotificationObject()
            testObject.notificationType = "MANUAL_MATCH_NOTIFICATION"
            
            let manualMatch = ManualMatchNotificationObject()
            testObject.notification = manualMatch
            
            
            
            self.dataArray.append(testObject)
            self.tableView.reloadData()
        
        }, failure: {errorMessage in})
        
        
        tableView.register(UINib(nibName: "ProductNewsFeedTableViewCell", bundle: nil), forCellReuseIdentifier: "ProductNewsFeedTableViewCell")
        tableView.register(UINib(nibName: "NewFollowerTableViewCell", bundle: nil), forCellReuseIdentifier: "NewFollowerTableViewCell")
        tableView.register(UINib(nibName: "LikeNotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "LikeNotificationTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
//        if segue.destination is UISideMenuNavigationController
//        {
//            SideViewHelperClass.sharedInstance.passedDelegate = self
//            SideViewHelperClass.sharedInstance.fromVC = self.restorationIdentifier
//        }
    }
    
    
    // MARK: - Table view data source
    
    func acceptTappedAt(index: IndexPath) {
        
        print("accepted")
        
    }
    
    func declineTappedAt(index: IndexPath) {
        
        print("rejected")
        
    }
    
    func avatarTouchedAt(index: IndexPath) {
        print("touch me again baby")
    }
    
    func userTouchedAt(index: IndexPath) {
        print("that user followed you at Index: \(index.row)")
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.frame.height / 6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return self.dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNewsFeedTableViewCell", for: indexPath) as? ProductNewsFeedTableViewCell
//        {
//            
//        
//            return cell
//        }
        
        let notification = dataArray[indexPath.row]
        
        switch notification.notification {
        case let followerNotification as FollowerNotificationObject:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewFollowerTableViewCell", for: indexPath) as? NewFollowerTableViewCell
            {
                
                cell.delegate = self
                cell.indexPath = indexPath
                
                cell.clockIconHeight.constant = cell.timeStampLabel.text!.height(withConstrainedWidth: cell.timeStampLabel.frame.width, font: cell.timeStampLabel.font)
                
                
                let thisString = NSMutableAttributedString(string: followerNotification.followerUserHandle + " " + "wants to follow you".localized())
                thisString.setColorForText(followerNotification.followerUserHandle, with: DefaultConstants.greenColor)
                cell.messageLabel.attributedText = thisString
                
                
                return cell
            }
        case let likeNotification as LikeNotificationObject:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LikeNotificationTableViewCell", for: indexPath) as? LikeNotificationTableViewCell
            {
                
                cell.delegate = self
                cell.indexPath = indexPath
                
                cell.clockIconHeight.constant = cell.timeStampLabel.text!.height(withConstrainedWidth: cell.timeStampLabel.frame.width, font: cell.timeStampLabel.font)
                
                var thisString = NSMutableAttributedString()
                
                switch likeNotification.state {
                case .isUser:
                    thisString = NSMutableAttributedString(string: likeNotification.likedUserHandle + " " + "is now following you".localized())
                    thisString.setColorForText(likeNotification.likedUserHandle, with: DefaultConstants.greenColor)
                case .isBrewery:
                    thisString = NSMutableAttributedString(string: likeNotification.likedBreweryName + " " + "is now following you".localized())
                    thisString.setColorForText(likeNotification.likedBreweryName, with: DefaultConstants.greenColor)
                case .isBar:
                    thisString = NSMutableAttributedString(string: likeNotification.likedBarName + " " + "is now following you".localized())
                    thisString.setColorForText(likeNotification.likedBarName, with: DefaultConstants.greenColor)
                default:
                    thisString = NSMutableAttributedString(string: "")
                }
                
                cell.messageLabel.attributedText = thisString
                
                
                
                return cell
            }
        case let matchNotification as ManualMatchNotificationObject:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "ProductNewsFeedTableViewCell", for: indexPath) as? ProductNewsFeedTableViewCell
            {
                
                cell.sakeImageView.image = UIImage(named: "dummy_label2")
                
                
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
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
