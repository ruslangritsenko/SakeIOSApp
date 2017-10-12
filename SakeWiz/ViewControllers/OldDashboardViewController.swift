//
//  DashboardViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 12/8/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit
import SideMenu



class OldDashboardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, SideMenuProtocol, UIScrollViewDelegate {

    
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var hamburgerButton: UIBarButtonItem!
    
    @IBOutlet weak var collectionViewPageControl: UIPageControl!
    
    @IBAction func pageControllAction(_ sender: UIPageControl) {
        
        self.updatesCollectionView!.scrollToItem(at: IndexPath(row: sender.currentPage, section: 0), at: .centeredHorizontally, animated: true)
        
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userTableView: UITableView!
    
    @IBOutlet weak var additionsTableView: UITableView!
    
    @IBOutlet weak var updatesCollectionView: UICollectionView!
    
    
    fileprivate var collectionViewArray: Array<UIImage> = [UIImage(named:"Dummy_Chart")!, UIImage(named:"some_handsome_guy")!]
    
    fileprivate var additionsArray: Array<AdditionsObject> = [AdditionsObject(brand: "Junmai-shu", name: "Gorin Junmaishu", stars: "★★★", timeStamp: "32 mins", image: UIImage(named: "dummy_label1")), AdditionsObject(brand: "Junmai-Daiginjo-shu", name: "Junmai Daiginjo 50", stars: "★★★", timeStamp: "1 hour ago", image: UIImage(named: "dummy_label2"))]
    
    fileprivate class AdditionsObject {
        
        var brand: String
        var name: String
        var stars: String
        var timeStamp: String
        var image: UIImage?
        
        init(brand: String, name: String, stars: String, timeStamp: String, image: UIImage? = nil)
        {
            self.brand = brand
            self.name = name
            self.stars = stars
            self.timeStamp = timeStamp
            self.image = image
        }
    }
    
    fileprivate var userDataArray: Array<CustomerUserData> = [CustomerUserData(label: "Labels Scanned", number: 5, image: UIImage(named: "labels_scanned_icon")), CustomerUserData(label: "Saved Sake", number: 12, image: UIImage(named: "sake_icon")), CustomerUserData(label: "Saved Bars", number: 20, image: UIImage(named: "star_icon")), CustomerUserData(label: "Fav Breweries", number: 10, image: UIImage(named: "brew_wheat_icon"))]
    
    fileprivate class CustomerUserData {
    
        var label: String
        var number: Int
        var image: UIImage?
        
        init(label: String, number: Int, image: UIImage?)
        {
            self.label = label
            self.number = number
            self.image = image
        }
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        
        self.navigationController?.isNavigationBarHidden = false
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.userImageView.image = UIImage(named: "some_handsome_guy")?.circle
        
        // Do any additional setup after loading the view.
        self.userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserTableViewCell")
        self.additionsTableView.register(UINib(nibName: "AdditionsTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionsTableViewCell")
        
        self.updatesCollectionView.register(UINib(nibName: "ImageViewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageViewCollectionViewCell")
        
        self.collectionViewPageControl.currentPage = 0
        self.collectionViewPageControl.numberOfPages = self.collectionViewArray.count
        
        self.setupSideMenu()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        print("INSTRUCTIONS RECIEVED CAPTAIN")
        
        if fromVCName == self.restorationIdentifier
        {
            
            
            if SideViewHelperClass.sharedInstance.shouldMoveToView
            {
                print("Should Move")
            }
            SideViewHelperClass.checkAndMoveToNewVC(self)
        }
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
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == self.userTableView
        {
            if (tableView.frame.height / CGFloat(4)) > 40
            {
                tableView.isScrollEnabled = false
                return (tableView.frame.height / CGFloat(4))
            }
            else
            {
                tableView.isScrollEnabled = true
                return 40
            }
        }
        else if tableView == self.additionsTableView
        {
            if tableView.frame.height / CGFloat(2) > 80
            {
                return (tableView.frame.height / CGFloat(2))
            }
            else
            {
                return 80
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if userTableView == tableView
        {
            return self.userDataArray.count
        }
        else if tableView == self.additionsTableView {
            return self.additionsArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.userTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
            let currentObject = self.userDataArray[indexPath.row]
            
            cell.nameLabel.text = currentObject.label
            cell.iconImageView.image = currentObject.image
            cell.numberLabel.text = String(currentObject.number)
        
            return cell
        }
        else if tableView == self.additionsTableView
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionsTableViewCell", for: indexPath) as! AdditionsTableViewCell
            let currentObject = self.additionsArray[indexPath.row]
            
            cell.brandLabel.text = currentObject.brand
            cell.itemImageView.image = currentObject.image
            cell.nameLabel.text = currentObject.name
            cell.brandLabel.text = currentObject.stars
            cell.timeStampLabel.text = currentObject.timeStamp
            
            
            return cell
        }
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
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

    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.updatesCollectionView.frame.size
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.collectionViewArray.count > 0
        {
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalGraphCollectionViewCell", for: indexPath) as! HorizontalGraphCollectionViewCell
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCollectionViewCell", for: indexPath) as! ImageViewCollectionViewCell
        
        cell.cellImageView.image = self.collectionViewArray[indexPath.row]
        
        self.collectionViewPageControl.currentPage = indexPath.row
        
        return cell
    }
    
    func scrollToNearestVisibleCollectionViewCell() {
        let visibleCenterPositionOfScrollView = Float(updatesCollectionView.contentOffset.x + (self.updatesCollectionView!.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = FLT_MAX
        for i in 0..<updatesCollectionView.visibleCells.count {
            let cell = updatesCollectionView.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = updatesCollectionView.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.updatesCollectionView!.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
            self.collectionViewPageControl.currentPage = closestCellIndex
        }
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollToNearestVisibleCollectionViewCell()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            scrollToNearestVisibleCollectionViewCell()
        }
    }

}
