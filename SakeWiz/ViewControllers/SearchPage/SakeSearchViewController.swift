//
//  SakeSearchViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/31.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Localize_Swift
import EZLoadingActivity

protocol SakeSearchVCProtocol {
    func sortButtonWasPressed()
    func shouldMoveToProductDetails(product: ProductObject)
}

class SakeSearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SakeFilterProtocol, SortByBroadCaster {
    
    
    var sakeSearchDelegate: SakeSearchVCProtocol?
    
    var filterDictionary:[String:Array<String>]? = nil
    var sortByString: String? = nil
    
    
    var dataArray = Array<ProductObject>() {
    
        didSet {
        
            if dataArray.count > 0
            {
                SearchResultsLabel.isHidden = false
                
            }
            else
            {
                SearchResultsLabel.isHidden = true
            }
        
            tableView.reloadData()
        }
    
    
    }
    
    var firstEntry = true
    
    var canFetchMoreResults = true
    
    var currentFetchPage = 0
    
    var searchKeyword:String? = nil {
        
        didSet {
        
            if searchKeyword != nil
            {
                canFetchMoreResults = true
                currentFetchPage = 0
                
                dataArray.removeAll()
                
            }
        
        }
    }
    
    
    fileprivate var dataTask:URLSessionDataTask?
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var SearchResultsLabel: UILabel!
    
    @IBOutlet weak var searchTextField: AutoCompleteTextField!
    
    @IBAction func searchTextFieldEnterWasPressed(_ sender: UITextField) {
        
       searchTextField.endEditing(true)
        if let newKeyword = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), newKeyword != ""
        {
            searchKeyword = newKeyword
            fetchDataFrom(index: 0, filters: filterDictionary, sort: sortByString)
            
        }
        else
        {
            searchKeyword = nil
        }
        
        
    }

    @IBAction func searchTextFieldDidChange(_ sender: UITextField) {
        
        
    }
    @IBAction func searchTextFieldDidEndEditing(_ sender: UITextField) {
        
        print("did trigger")
        
        if let newKeyword = searchTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), newKeyword != ""
        {
            searchKeyword = newKeyword
            fetchDataFrom(index: 0, filters: filterDictionary, sort: sortByString)
        
        }
        else
        {
            searchKeyword = nil
        }
        
    }
    
    @IBOutlet weak var filterButton: UIButton!
    @IBAction func FilterButtonAction(_ sender: UIButton) {
        
        if filterDictionary != nil
        {
            filterButton.setTitle("FilterBy", for: .normal)
            filterDictionary = nil
        }
        else
        {
            self.performSegue(withIdentifier: "Filter", sender: self)
            filterButton.setTitle("Clear Filters".localized(), for: .normal)
            
            if searchKeyword != nil
            {
                fetchDataFrom(index: 0, filters: filterDictionary, sort: sortByString)
            }
        }
        
    }
    
    
    @IBOutlet weak var SortButton: UIButton!
    @IBAction func SortButtonAction(_ sender: UIButton) {
        
        sakeSearchDelegate?.sortButtonWasPressed()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        tableView.register(UINib(nibName: "AdditionsTableViewCell", bundle: nil), forCellReuseIdentifier: "AdditionsTableViewCell")
        
        self.searchTextField.delegate = self
        
        //autocomplete
        configureTextField()
        handleTextFieldInterfaces()
        
        
        
        SearchResultsLabel.isHidden = true
        
        //hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        sakeSearchDelegate = nil
        filterDictionary = nil
        sortByString = nil
        dataTask = nil
        searchKeyword = nil
        
    }
    
    func shouldSort(by: String)
    {
        
        if by == "None"
        {
            sortByString = nil
        }
        else
        {
            sortByString = by
        }
        print("sortby: \(String(describing: sortByString))")
        
        fetchDataFrom(index: 0, filters: filterDictionary, sort: by)
        
    }
    
    fileprivate func fetchDataFrom(index: Int, filters: [String:Array<String>]?, sort: String?)
    {
        print("fetchDataFrom: \(index)")
        //get data
        
        if searchKeyword != nil
        {
            API.searchProducts(keyword: searchKeyword!, page: String(currentFetchPage), size: String(DefaultConstants.InfiniteScroller.fetchLimit), filters: filters, sortOrder: sortByString, completionHandler: { newProductsArray in
                
                
                self.dataArray.append(contentsOf: newProductsArray)
                
                self.canFetchMoreResults = !(newProductsArray.count < DefaultConstants.InfiniteScroller.fetchLimit)
                self.currentFetchPage += 1
                
                self.SearchResultsLabel.isHidden = false
                
                self.tableView.reloadData()
                
                
            }, failure: {errorMessage in
                
                print(errorMessage)
                
                
                
            })
        }
    
    }
    
    func didSelectFiltersWith(types: Array<String>, filteredWaters: Array<String>, yeasts: Array<String>, pressAndSqueezes: Array<String>) {
        
        currentFetchPage = 0
        self.dataArray.removeAll()
        canFetchMoreResults = true
        
        var filters = [String:Array<String>]()
        
        if !types.isEmpty
        {
            filters.updateValue(types, forKey: "types")
            
            print(types)
        
        }
        
        if !filteredWaters.isEmpty
        {
            filters.updateValue(filteredWaters, forKey: "filteredWaters")
            
        }
        
        if !yeasts.isEmpty
        {
            filters.updateValue(yeasts, forKey: "yeasts")
            
        }
        
        if !pressAndSqueezes.isEmpty
        {
            filters.updateValue(pressAndSqueezes, forKey: "pressAndSqueezes")
            
        }
        
        print(filters)
        
        if !filters.isEmpty
        {
            
            filterDictionary = filters
            
            fetchDataFrom(index: 0, filters: filters, sort: sortByString)
        }
        
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        searchKeyword = nil
        dataArray.removeAll()
        return true 
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        if let destinationVC = segue.destination as? SakeTypeFilterViewController
        {
            destinationVC.sakeFilterDelegate = self
        }
    }
    
    fileprivate func configureTextField()
    {
        
        searchTextField.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        searchTextField.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        searchTextField.autoCompleteCellHeight = 50
        searchTextField.autoCompleteTableHeight = self.view.frame.height * 0.5
        searchTextField.maximumAutoCompleteCount = 20
        searchTextField.hidesWhenSelected = true
        searchTextField.hidesWhenEmpty = true
        searchTextField.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.black
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        searchTextField.autoCompleteAttributes = attributes
    
    }
    
    fileprivate func handleTextFieldInterfaces(){
        searchTextField.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if let dataTask = self?.dataTask {
                    dataTask.cancel()
                }
                self?.fetchAutocompletePlaces(keyword: text)
            }
        }
        
        searchTextField.onSelect = {[weak self] text, indexpath in

            self?.searchTextField.text = text
            self?.searchKeyword = text
            
            self?.searchTextField.endEditing(true)
            
                
            self?.fetchDataFrom(index: 0, filters: self?.filterDictionary, sort: self?.sortByString)
            
        }
    }
    
    
    private func fetchAutocompletePlaces(keyword:String) {
        
        print("fetching autocomplete")
        
        let urlString = APIConstants.baseURL + APIConstants.SearchSuggestedProducts + "?text=\(keyword)"
        var s = CharacterSet.urlQueryAllowed
        //let s = NSCharacterSet.URLQueryAllowedCharacterSet.mutableCopy() as! NSMutableCharacterSet
        s.insert(charactersIn: "+&")
        //s.addCharactersInString("+&")
        
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: s)
        {
            if let url = URL(string: encodedString) {
                let request = URLRequest(url: url)
                dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                    if let data = data{
                        
                        do{
                            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                            
                            print(result)
                            
                            if let autoCompleteArray = result as? Array<String>
                            {
                                DispatchQueue.main.async(execute: { () -> Void in
                                    
                                    if autoCompleteArray.count > 0
                                    {
                                        self.searchTextField.autoCompleteStrings = autoCompleteArray
                                    }
                                    else
                                    {
                                        self.searchTextField.autoCompleteStrings = nil
                                    }
                                })
                                return
                            
                            }
                            
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.searchTextField.autoCompleteStrings = nil
                            })
                        }
                        catch let error as NSError{
                            print("Error: \(error.localizedDescription)")
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.searchTextField.autoCompleteStrings = nil
                            })
                        }
                    }
                })
                dataTask?.resume()
            }
        }
    }

    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //return (tableView.frame.height / (CGFloat(dataArray.count) + CGFloat(1.5)))
        if UserObject.sharedInstance.userSettings != nil
        {
            return UserObject.sharedInstance.userSettings!.tableViewCellHeight
        }
        
        return 120
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionsTableViewCell", for: indexPath) as? AdditionsTableViewCell
        {
            
            cell.selectionStyle = .none
            
            let currentProduct = dataArray[indexPath.row]
            cell.brandLabel.text = currentProduct.sakeName
            
            if let url = URL(string: currentProduct.mainImageURLString)
            {
                cell.itemImageView.kf.setImage(with: url, placeholder: UIImage(named:"screenshot_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            
            
            cell.nameLabel.text = ProductObject.presentStringForType(serverString: currentProduct.type)
            let someFont = UIFont.systemFont(ofSize: cell.brandLabel.font.pointSize * 0.6)
            cell.nameLabel.font = someFont
            
            
            
            cell.likesLabel.text = String(currentProduct.likeCount)
            cell.likesIconHeight.constant = "0".height(withConstrainedWidth: cell.likesLabel.frame.width, font: cell.likesLabel.font)
            
            cell.MessagesLabel.text = String(currentProduct.reviewCount)
            cell.messagesIconHeight.constant = "0".height(withConstrainedWidth: cell.MessagesLabel.frame.width, font: cell.MessagesLabel.font)
            
            cell.timeStampLabel.text = currentProduct.createTimeDate.shortTimeAgoSinceNow
            cell.clockIconHeight.constant = "Today".height(withConstrainedWidth: cell.MessagesLabel.frame.width, font: cell.MessagesLabel.font)
            
            
            if ProductObject.currentNameForDic(productDic: currentProduct.regionDic) != nil
            {
                cell.locationLabel.text = ProductObject.currentNameForDic(productDic: currentProduct.regionDic)!
                
                if ProductObject.currentNameForDic(productDic: currentProduct.countryDic) != nil
                {
                    
                    cell.locationLabel.text = cell.locationLabel.text! + ", " + ProductObject.currentNameForDic(productDic: currentProduct.countryDic)!
                }
                
            }
            
            
            cell.locationPinIconHeight.constant = "0".height(withConstrainedWidth: cell.locationLabel.frame.width, font: cell.locationLabel.font)
            
            cell.starRating = currentProduct.rating
            
            
            
            return cell
        }
            
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        EZLoadingActivity.Settings.LoadOverApplicationWindow = true
        EZLoadingActivity.show("Fetching Details...", disableUI: true)
        
        API.getProductDetailsBy(ID: dataArray[indexPath.row].id, completionHandler: {[weak self] product in
        
            EZLoadingActivity.hide()
        
            self?.sakeSearchDelegate?.shouldMoveToProductDetails(product: product)
        
        }, failure: {[weak self] errorMessage in
            
            EZLoadingActivity.hide(false, animated: true)
            
            print(errorMessage)})
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (dataArray.count - indexPath.row) == DefaultConstants.InfiniteScroller.fetchThreashold && canFetchMoreResults {
            fetchDataFrom(index: dataArray.count, filters: filterDictionary, sort: sortByString)
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
