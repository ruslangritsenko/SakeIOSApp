//
//  DashboardViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/23.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Kingfisher
import Localize_Swift
import SideMenu
import AVFoundation
import Photos
import EZLoadingActivity
import DateToolsSwift

protocol LoggedOutProtocol {

    func loggedOut()
}

class DashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, SideMenuProtocol {

    
    var delegate: LoggedOutProtocol?
    
    var dashboardInformation = DashboardObject()
    
    var refreahControl = UIRefreshControl()
    
    var collectionCellHeight = CGFloat()
    
    weak var productObjectToPass: ProductObject? = nil
    
    // MARK: - Views Outlets
    
    @IBOutlet weak var CollectionViewContainerView: UIView!
    @IBOutlet weak var ProfileContainerView: UIView!
    @IBOutlet weak var StatusBarContainerView: UIView!
    
    
    @IBOutlet weak var DashboardScrollView: UIScrollView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var SearchButton: UIBarButtonItem!
    @IBAction func SearchButtonAction(_ sender: UIBarButtonItem) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyBoard.instantiateViewController(withIdentifier: "SearchRootViewController")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @IBOutlet weak var NotificationsButton: UIBarButtonItem!
    func NotificationsButtonAction(_ sender: UIBarButtonItem) {
        
        print("pressed")
        
        performSegue(withIdentifier: "ToNotifications", sender: self)
        
    }
    
    @IBOutlet weak var AvatarImageView: UIImageView!
    @IBOutlet weak var AvatarActivitySpinner: UIActivityIndicatorView!
    
    // MARK - TOP PART
    @IBOutlet weak var topStatusLabel: UILabel!
    @IBOutlet weak var topPointsLabel: UILabel!
    @IBOutlet weak var topStatusImageIcon: UIImageView!
    
    // MARK - FAV things Outlets
    @IBOutlet weak var FavSakeNumber: UILabel!
    @IBOutlet weak var FavSakeUnderLabel: UILabel!
    
    
    @IBOutlet weak var FavPlacesNumberLabel: UILabel!
    @IBOutlet weak var FavPlacesUnderLabel: UILabel!
    
    
    // MARK - Toolbar Outlets
    
    
    @IBOutlet weak var FollowersNumberLabel: UILabel!
    @IBOutlet weak var FollowersUnderLabel: UILabel!
    
    @IBOutlet weak var FollowingNumberLabel: UILabel!
    @IBOutlet weak var FollowingUnderLabel: UILabel!
    
    @IBOutlet weak var LabelsScannedNumberLabel: UILabel!
    @IBOutlet weak var LabelsScannedUnderLabel: UILabel!
    
    
    @IBOutlet weak var WizCreditsNumberLabel: UILabel!
    @IBOutlet weak var WizCreditsUnderLabel: UILabel!
    
    
    // MARK - CollectionView Outlets

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    // MARK - TableView Outlets
    
    @IBOutlet weak var LatestRecommendationsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        
        
        navigationController?.navigationBar.isHidden = false
        
        title = NSLocalizedString("DASHBOARD", comment: "")
        
        AvatarActivitySpinner.isHidden = true
        
        refreahControl = DashboardScrollView.addRefreshControl(target: self, action: #selector(self.refresh(sender:)))
        
        refreahControl.tintColor = UIColor.black
        
        refreahControl.attributedTitle = NSAttributedString(string: "Pull to refresh".localized(), attributes: nil)
        
        topPointsLabel.text = "\(UserObject.sharedInstance.points) " + "Wiz Credits until next level".localized()
        topStatusLabel.text = UserObject.sharedInstance.userRank.capitalized
        
    
        adjustTotalViewHeight()
        
        
        tableView.register(UINib(nibName: "AdditionsTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionsTableViewCell")
        collectionView.register(UINib(nibName: "DashboardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "DashboardCollectionViewCell")

        // Do any additional setup after loading the view.
        
        

        setDashboard(dashboardObject: dashboardInformation)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        delegate = nil
        productObjectToPass = nil
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print("NOW GOING TO \(segue.destination)")
        
        if segue.destination is UISideMenuNavigationController
        {
            SideViewHelperClass.sharedInstance.passedDelegate = self
            SideViewHelperClass.sharedInstance.fromVC = self.restorationIdentifier
        }
        
        if let destinationVC = segue.destination as? ProductDetailsViewController
        {
            destinationVC.passedProductObject = productObjectToPass
            destinationVC.isFromDashboard = true
            
        }
    }
    
    // Mark: - Standard Functions
    
    
    func refresh(sender:AnyObject)
    {
        
        API.getDashboard(completionHandler: {dashboardObject in
            
            self.dashboardInformation = dashboardObject
            self.setDashboard(dashboardObject: dashboardObject)
            
            self.refreahControl.endRefreshing()
            
        }, failure: {errorMessage in
            
            if let message = errorMessage
            {
                if message == "unauthed"
                {
                    API.authenticate(username: UserObject.sharedInstance.handle, password: UserObject.sharedInstance.password, completionHandler: {
                    
                        API.getDashboard(completionHandler: {dashboardObject in
                            
                            self.dashboardInformation = dashboardObject
                            self.setDashboard(dashboardObject: dashboardObject)
                            
                            self.refreahControl.endRefreshing()
                            
                        }, failure: {anotherErrorMessage in
                        
                            self.refreahControl.endRefreshing()
                            if let someError = anotherErrorMessage
                            {
                                if someError == "unauthed"
                                {
                                    let alertController = UIAlertController(title: "Internal Error".localized(), message: "An error has occured and we cannot refresh this view. Would you like to return to login again?".localized(), preferredStyle: .alert)
                                    
                                    let OKAction = UIAlertAction(title: "OK".localized(), style: .default, handler: {alertAction in
                                    
                                        
                                        SideViewHelperClass.setSharedInstance(moveToViewName: "SplashScreen", shouldMoveToView: true)
                                        self.shouldGoToNewController(fromVCName: self.restorationIdentifier!)
                                    
                                    })
                                    
                                    let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
                                    
                                    alertController.addAction(OKAction)
                                    alertController.addAction(cancelAction)
                                    self.present(alertController, animated: true, completion: nil)
                                }
                            }
                        
                        })
                    
                    }, failure: {anotherErrorMessage in
                        
                        self.refreahControl.endRefreshing()
                        if let _ = anotherErrorMessage
                        {
                            let alertController = UIAlertController(title: "Internal Error".localized(), message: "An error has occured and we cannot refresh this view. Would you like to return to login again?".localized(), preferredStyle: .alert)
                            
                            let OKAction = UIAlertAction(title: "OK".localized(), style: .default, handler: {alertAction in
                                
                                SideViewHelperClass.setSharedInstance(moveToViewName: "SplashScreen", shouldMoveToView: true)
                                self.shouldGoToNewController(fromVCName: self.restorationIdentifier!)
                                
                            })
                            
                            let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .cancel, handler: nil)
                            alertController.addAction(OKAction)
                            alertController.addAction(cancelAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    
                    
                    })
                }
                else
                {
                    self.refreahControl.endRefreshing()
                    self.alert(message: message, completionHandler: nil)
                }
            }
            
        })
        
    }
    
    func changeNotificationsButton(notificationsNumber: Int)
    {
        
        if notificationsNumber <= 0
        {
            self.NotificationsButton.isEnabled = false
            self.NotificationsButton.tintColor = UIColor.clear
            self.NotificationsButton.customView = UIView()
            
        }
        else
        {
            let newButton = UIButton(type: UIButtonType.custom)
            newButton.setBackgroundImage(UIImage(named: "pink_background")?.circle, for: .normal)
            newButton.frame = CGRect(x: 280, y: 25, width: 30, height: 30)
            newButton.layer.cornerRadius = 100
            newButton.setTitle(String(notificationsNumber), for: .normal)
            newButton.addTarget(self, action: #selector(DashboardViewController.NotificationsButtonAction(_:)), for: UIControlEvents.touchUpInside)

            
            self.NotificationsButton.customView = newButton
            self.NotificationsButton.isEnabled = true
            self.NotificationsButton.tintColor = UIColor.white
            
            NotificationsButton.action = #selector(DashboardViewController.NotificationsButtonAction(_:))
        }
        
    }
    
    fileprivate func localize()
    {
    
    }
    
    fileprivate func adjustTotalViewHeight()
    {
         self.viewHeightConstraint.constant = self.CollectionViewContainerView.frame.height + self.ProfileContainerView.frame.height + self.StatusBarContainerView.frame.height + (self.view.frame.height / 5)
        
        if UIScreen.main.traitCollection.userInterfaceIdiom == .pad
        {
            self.viewHeightConstraint.constant += self.view.frame.height * 0.5
        }
    }
    
    fileprivate func setDashboard(dashboardObject: DashboardObject)
    {
        
        
        
        changeNotificationsButton(notificationsNumber: dashboardObject.notificationCount)
        
        
        if let url = URL(string: dashboardObject.userProfileImageURL)
        {
            AvatarActivitySpinner.isHidden = false
            AvatarImageView.kf.setImage(with: url, placeholder: UIImage(named: "screenshot_avatar"), options: nil, progressBlock: nil, completionHandler: {completion in
                
                self.AvatarActivitySpinner.isHidden = true
                
                if completion.1 != nil
                {
                    print("KingFisher Fetch Error: \(String(describing: completion.1))")
                }
                
                self.AvatarImageView.image = self.AvatarImageView.image?.circleWithColor

            })
            
        }
        else
        {
            AvatarImageView.image = UIImage(named: "screenshot_avatar")?.circle
        }
        
        FollowersNumberLabel.text = String(dashboardObject.followerCount)
        
        FollowingNumberLabel.text = String(dashboardObject.followingCount)
        
        LabelsScannedNumberLabel.text = String(dashboardObject.labelCount)
        
        WizCreditsNumberLabel.text = String(dashboardObject.wizCredits)
        
        FavSakeNumber.text = String(dashboardObject.favSakeCount)
        
        FavPlacesNumberLabel.text = String(dashboardObject.favBreweryCount)
        
        
    }
    
    // MARK: - Side Menu
    
    fileprivate func setupSideMenu() {
        // Define the menus
        SideMenuManager.menuLeftNavigationController = storyboard!.instantiateViewController(withIdentifier: "LeftMenuNavigationController") as? UISideMenuNavigationController
        
        // Enable gestures. The left and/or right menus must be set up above for these to work.
        // Note that these continue to work on the Navigation Controller independent of the View Controller it displays!
        //        SideMenuManager.menuAddPanGestureToPresent(toView: self.navigationController!.navigationBar)
        //        SideMenuManager.menuAddScreenEdgePanGesturesToPresent(toView: self.navigationController!.view)
        
    }
    
    func shouldGoToNewController(fromVCName: String) {
        
        
        
        //if fromVCName == self.restorationIdentifier
        //{
        
        
        if SideViewHelperClass.sharedInstance.shouldMoveToView
        {
            print("Should Move")
            if SideViewHelperClass.sharedInstance.moveToViewName == "SplashScreen"
            {
                self.navigationController?.popToRootViewController(animated: true)
                self.delegate = LogoutHelperClass.sharedInstance.passedDelegate
                self.delegate?.loggedOut()
                
                LogoutHelperClass.resetSharedInstance()
            }else if SideViewHelperClass.sharedInstance.moveToViewName == "Camera"
            {
                switch AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
                {
                case .authorized:
                    
                    checkForPhotoPermissionAndMove()
                    
                case .denied:
                    SideViewHelperClass.resetSharedInstance()
                    
                    let alertController = UIAlertController (title: "Not Authorized to use Camera", message: "Sake-Wiz must be able to access your camera to use this feature", preferredStyle: .alert)
                    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        
                        DispatchQueue.main.async(execute: {
                            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                
                                UIApplication.shared.openURL(settingsUrl)
                            }
                            
                        })
                    }
                    
                    let cancelAction = UIAlertAction(title: "Later", style: .default, handler: nil)
                    
                    alertController.addAction(settingsAction)
                    alertController.addAction(cancelAction)
                    
                    present(alertController, animated: true, completion: nil)
                    
                    return
                case .notDetermined:
                    
                    AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {[weak self] granted in
                        if granted {
                            
                            DispatchQueue.main.async(execute: {[weak self] () -> Void in
                            
                                self?.checkForPhotoPermissionAndMove()
                            })
                            
                        } else {
                            
                            SideViewHelperClass.resetSharedInstance()
                            self?.alert(message: "Sake-Wiz must be able to access your camera to use this feature", title: "Not Authorized to use Camera", OKButtonTitle: "OK", completionHandler: nil)
                            return
                            
                        }
                    })
                    
                default:
                    return
                
                }
                
            }
            else
            {
                
                SideViewHelperClass.checkAndMoveToNewVC(self)
            }
            
        }
        else
        {
            self.alert(message: "This feature has not been implemented yet. Please check up with Sake-Wiz later as we continue our development process. Keep on Wizzing, Wizzers", title: nil, OKButtonTitle: "OK", completionHandler: nil)
            
        }
            //SideViewHelperClass.checkAndMoveToNewVC(self)
        //}
    }
    
    func checkForPhotoPermissionAndMove()
    {
        
        switch PHPhotoLibrary.authorizationStatus()
        {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({[weak self] _ in
                
                DispatchQueue.main.async(execute: {[weak self] in
                    
                    if self != nil
                    {
                        SideViewHelperClass.checkAndMoveToNewVC(self!)
                    }
                    else
                    {
                        SideViewHelperClass.resetSharedInstance()
                    }
                    
                })
                
            })
            
        default:
        
            SideViewHelperClass.checkAndMoveToNewVC(self)
        }
    
    }
    
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {

        if tableView.frame.height / 3 > 100
        {

            UserObject.sharedInstance.userSettings?.tableViewCellHeight = tableView.frame.height / 3
            return tableView.frame.height / 3
        }
        UserObject.sharedInstance.userSettings?.tableViewCellHeight = 100
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        if dashboardInformation.recommendedProducts != nil
        {
            return dashboardInformation.recommendedProducts!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionsTableViewCell", for: indexPath) as? AdditionsTableViewCell
        {
            let product = dashboardInformation.recommendedProducts![indexPath.row]
            
            cell.selectionStyle = .none
            
            let url = URL(string: product.mainImageURLString)
            cell.itemImageView.kf.setImage(with: url, placeholder: UIImage(named:"screenshot_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
            
            cell.brandLabel.text = product.sakeName
            
            
            cell.nameLabel.text = ProductObject.presentStringForType(serverString: product.type)
            let someFont = UIFont.systemFont(ofSize: cell.brandLabel.font.pointSize * 0.7)
            cell.nameLabel.font = someFont
            
            
            
            cell.likesLabel.text = String(product.likeCount)
            cell.likesIconHeight.constant = "0".height(withConstrainedWidth: cell.likesLabel.frame.width, font: cell.likesLabel.font)
            
            cell.MessagesLabel.text = String(product.reviewCount)
            cell.messagesIconHeight.constant = "0".height(withConstrainedWidth: cell.MessagesLabel.frame.width, font: cell.MessagesLabel.font)
            
            cell.timeStampLabel.text = product.createTimeDate.shortTimeAgoSinceNow + " ago".localized()
            cell.clockIconHeight.constant = "0".height(withConstrainedWidth: cell.MessagesLabel.frame.width, font: cell.MessagesLabel.font)
            
            cell.locationLabel.text = ""
            

            if ProductObject.currentNameForDic(productDic: product.regionDic) != nil
            {
                cell.locationLabel.text = ProductObject.currentNameForDic(productDic: product.regionDic)!
                
                if ProductObject.currentNameForDic(productDic: product.countryDic) != nil
                {
                    
                    cell.locationLabel.text = cell.locationLabel.text! + ", " + ProductObject.currentNameForDic(productDic: product.countryDic)!
                }
                
            }
            
            cell.locationPinIconHeight.constant = cell.locationLabel.text!.height(withConstrainedWidth: cell.locationLabel.frame.width, font: cell.locationLabel.font)
            
            cell.starRating = product.rating
            
            
            
            
            
            
            return cell
        
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.productObjectToPass = dashboardInformation.recommendedProducts![indexPath.row]
        
        self.performSegue(withIdentifier: "ToProductDetails", sender: self)
        
    }
    
    
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9, height: collectionView.frame.height * 0.93)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalGraphCollectionViewCell", for: indexPath) as! HorizontalGraphCollectionViewCell
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath) as? DashboardCollectionViewCell
        {
            
            cell.SakeIdentifiedNumberLabel.text = String(dashboardInformation.sakeIdentified)
            cell.UnidentifiedSakeNumberLabel.text = String(dashboardInformation.sakeUnidentified)
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
    
    
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float(collectionView.contentOffset.x + (self.collectionView!.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<collectionView.visibleCells.count {
            let cell = collectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = collectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.collectionView!.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
            //self.collectionViewPageControl.currentPage = closestCellIndex
        }
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView == collectionView
        {
            scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView == collectionView
        {
        if !decelerate {
            scrollToNearestVisibleCollectionViewCell()
        }
        }
    }

}
