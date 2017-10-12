//
//  SearchRootViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 12/19/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit
import MapKit
import Localize_Swift

protocol SortByBroadCaster {
    
    func shouldSort(by: String)
}

class SearchRootViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SortByProtocol, SakeSearchVCProtocol {

    var productToPass: ProductObject? = nil
    
    private var SortViewController: SortByViewController?
    
    var sortBroadCastDelegate: SortByBroadCaster?
    
    var sakeSort = "None".localized()
    var breweriesSort = "None".localized()
    var placesSort = "None".localized()
    
    var lineView = UIView()
    
    var breweriesArray = Array<ProductObject>()
    
    var placesArray = Array<ProductObject>()
    
    var viewState = 1 {
    
        didSet {
        
        
            self.changeViewState(buttonState: viewState)
        
        }
    
    }
    
    @IBOutlet weak var SakeButton: UIButton!
    @IBOutlet weak var SakeImageView: UIImageView!
    @IBOutlet weak var BreweriesButton: UIButton!
    @IBOutlet weak var BreweriesImageView: UIImageView!
    @IBOutlet weak var barButtonOutlet: UIButton!
    @IBOutlet weak var PlacesImageView: UIImageView!
    
    @IBOutlet weak var BreweriesAndPlacesView: UIView!
    
    
    @IBOutlet weak var sakeSearchView: UIView!
    
    @IBOutlet weak var SortContainerView: UIView!

    
    @IBAction func barButtonsAction(_ sender: UIButton) {
        
        if barsUnderView.isHidden {
        
            viewState = 3

        }
        
    }
    
    @IBAction func brewButtonsAction(_ sender: UIButton) {
        
        if breweriesUnderView.isHidden {
        
            viewState = 2

        }
        
    }
    
    
    @IBAction func sakeButtonAction(_ sender: UIButton) {
        
        if sakeUnderView.isHidden {
        
            viewState = 1
        }
        
    }
    
    @IBOutlet weak var barsUnderView: UIView!
    
    @IBOutlet weak var breweriesUnderView: UIView!
    
    @IBOutlet weak var sakeUnderView: UIView!
    
    @IBOutlet weak var searchTextField: AutoCompleteTextField!
    @IBOutlet weak var SearchResulstsLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "SEARCH".localized()
        
        
        SortContainerView.isHidden = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.white

        // Do any additional setup after loading the view.
        self.changeViewState(buttonState: 1)
        
        tableView.register(UINib(nibName: "AdditionsTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionsTableViewCell")
        
    
    }
    
    deinit {
        sortBroadCastDelegate = nil
        productToPass = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func shouldSortBy(sortBy: String)
    {
        SortContainerView.isHidden = true
        if !sakeSearchView.isHidden
        {
            self.sakeSort = sortBy
            sortBroadCastDelegate?.shouldSort(by: sortBy)
        }
        else
        {
            
        }
    
    }
    
    func sortButtonWasPressed()
    {
        if sakeSearchView.isHidden
        {
            self.SortViewController?.shouldSet = self.sakeSort
        }
        
        SortContainerView.isHidden = false
        
    }
    
    func shouldMoveToProductDetails(product: ProductObject) {
        
        productToPass = product
        
        performSegue(withIdentifier: "ToProductDetails", sender: self)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if let destinationVC = segue.destination as? SortByViewController
        {
            SortViewController = destinationVC
            destinationVC.containerDelegate = self
        }
        
        if let destinationVC = segue.destination as? SakeSearchViewController
        {
            destinationVC.sakeSearchDelegate = self
            sortBroadCastDelegate = destinationVC
        
        }
        
        
        if let destinationVC = segue.destination as? ProductDetailsViewController
        {
            destinationVC.passedProductObject = productToPass
            
        }
        
    }
    
    func changeViewState(buttonState: Int) {
        
        self.resetViews()
    
        switch buttonState {
        case 1:
            sakeUnderView.isHidden = false
            sakeSearchView.isHidden = false
            SakeImageView.image = UIImage(named: "green_sake_bottle")
            SakeButton.setTitleColor(DefaultConstants.greenColor, for: .normal)
            
        case 2:
            breweriesUnderView.isHidden = false
            BreweriesAndPlacesView.isHidden = false
            BreweriesButton.setTitleColor(DefaultConstants.greenColor, for: .normal)
            BreweriesImageView.image = UIImage(named: "factory_green_icon")
            tableView.reloadData()
        case 3:
            barsUnderView.isHidden = false
            BreweriesAndPlacesView.isHidden = false
            barButtonOutlet.setTitleColor(DefaultConstants.greenColor, for: .normal)
            PlacesImageView.image = UIImage(named: "location_icon")
            tableView.reloadData()
        default:
            return
        }
    
    }
    
    func resetViews() {
    
        breweriesUnderView.isHidden = true
        sakeUnderView.isHidden = true
        SakeImageView.image = UIImage(named: "gray_bottle")
        BreweriesImageView.image = UIImage(named: "factory_black_icon")
        PlacesImageView.image = UIImage(named: "location_pin_black")
        barsUnderView.isHidden = true
        sakeSearchView.isHidden = true
        
        SakeButton.setTitleColor(UIColor.lightGray, for: .normal)
        BreweriesButton.setTitleColor(UIColor.lightGray, for: .normal)
        barButtonOutlet.setTitleColor(UIColor.lightGray, for: .normal)
        
        BreweriesAndPlacesView.isHidden = true
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 150
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //return self.locationsArray.count
        
        if viewState == 2
        {
            return breweriesArray.count
        }
        else if viewState == 3 {
        
            return placesArray.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionsTableViewCell", for: indexPath)as? AdditionsTableViewCell
        {
            if viewState == 2
            {
                let currentLoc = breweriesArray[indexPath.row]
            }
            else if viewState == 3
            {
                let currentLoc = placesArray[indexPath.row]
            }
            
            return cell
        }
        
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let _ = tableView.cellForRow(at: indexPath) as? BarsMapTableViewCell
//        {
//            self.mapView.selectAnnotation(self.annotationsArray[indexPath.row], animated: true)
//        }
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
