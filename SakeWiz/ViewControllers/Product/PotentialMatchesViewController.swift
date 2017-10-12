//
//  PotentialMatchesViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/26.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Kingfisher

class PotentialMatchesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PotentialMatchTableViewCellProtocol {

    var passedIDs: Array<String>? = nil
    
    var productMatches = Array<ProductObject>()
    
    weak var productToPass:ProductObject? = nil
    
    
    
    
    @IBAction func retryScanButtonAction(_ sender: UIButton) {
        
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let theseIDs = passedIDs, theseIDs.count > 0
        {
            for idString in theseIDs
            {
                API.getProductBy(ID: idString, completionHandler: {[weak self] newProduct in
                    
                    self?.productMatches.append(newProduct)
                    self?.tableView.reloadData()
                    
                    }, failure: {errorMessage in print(errorMessage)})
            }
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        tableView.register(UINib(nibName: "PotentialMatchTableViewCell", bundle: nil), forCellReuseIdentifier: "PotentialMatchTableViewCell")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - PotentialMatchTableViewCellProtocol
    func matchWasSelectedAt(index: IndexPath)
    {
        
    
        print("Product: \(String(describing: productMatches[index.row].sakeName)) selected")
        
        productToPass = self.productMatches[index.row]
        
        self.performSegue(withIdentifier: "ToDetails", sender: self)
    
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        
        if let destinationVC = segue.destination as? ProductDetailsViewController
        {
            destinationVC.passedProductObject = productToPass
        }
        
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 175
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if productMatches.count > 0
        {
            return productMatches.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PotentialMatchTableViewCell", for: indexPath) as? PotentialMatchTableViewCell
        {
            cell.delegate = self
            cell.indexPath = indexPath
            
            let product = productMatches[indexPath.row]
            
            cell.selectionStyle = .none
            
            let url = URL(string: product.mainImageURLString)
            cell.sakeImageView.kf.setImage(with: url, placeholder: UIImage(named:"screenshot_avatar"), options: nil, progressBlock: nil, completionHandler: nil)
            
            cell.selectMatchLabel.text = "Select Match".localized()
            
            cell.sakeNameLabel.text = product.sakeName
            
            
            cell.underSakeLabel.text = ProductObject.presentStringForType(serverString: product.type)
            let someFont = UIFont.systemFont(ofSize: cell.sakeNameLabel.font.pointSize * 0.7)
            cell.underSakeLabel.font = someFont
            
            
            
            cell.likesLabel.text = String(product.likeCount)
            
            cell.messagesLabel.text = String(product.reviewCount)


            if product.shortDescription != nil
            {
                cell.descriptionLabel.text = ProductObject.currentNameForDic(productDic: product.shortDescription!)
            }
            else
            {
                cell.descriptionLabel.text = ""
            }
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}
