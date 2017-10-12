//
//  SakeTypeFilterViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/05.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Localize_Swift

protocol SakeFilterProtocol {

    func didSelectFiltersWith(types: Array<String>, filteredWaters: Array<String>, yeasts: Array<String>, pressAndSqueezes: Array<String>)

}

class SakeTypeFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var types = Array<String>()
    var filteredWaters = Array<String>()
    var yeasts = Array<String>()
    var pressAndSqueezes = Array<String>()
    
    var sakeFilterDelegate: SakeFilterProtocol?
    
    
    let topTableData = ["JUNMAIDAIGINJOSHU".localized(),
                        "JUNMAIGINJOSHU".localized(),
                        "TOKUBETSUJUNMAISHU".localized(),
                        "JUNMAISHU".localized(),
                        "DAIJINJOSHU".localized(),
                        "GINJOSHU".localized(),
                        "TOKEBETSUHONJOZOSHU".localized(),
                        "HONJOZOSHU".localized(),
                        "SPARKING".localized(),
                        "MIXEDLIQUOR".localized(),
                        "OTHER".localized()]
    
    let middleTableData = ["MUROKAGENSHU".localized(),"MUROKA".localized(),"GENSHUMUKASHI".localized(),"OTHER".localized()]
    
    let bottomTableData = ["ARABASHIRI".localized(),
                           "NAKADORI_NAKAGUMO_NAKADARE".localized(),
                           "SEME_OSHIKIRI".localized(),
                           "FUKUROTURI_FUKUROSHIBORI_TSURUSHIZAKE".localized(),
                           "TOBINDORI_TOBINKAKOI".localized(),
                           "ORIGARAMI".localized(),
                           "NIGORIZAKE".localized(),
                           "OTHER".localized()]
    
    var viewState = 1
    {
        didSet {
        
            changeState(state: viewState)
        
        }
    
    }
    
    @IBOutlet weak var topTableView: UITableView!
    @IBOutlet weak var middleTableview: UITableView!
    @IBOutlet weak var bottomTableView: UITableView!
    
    @IBOutlet weak var topTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var middleTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomTableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var topButton: UIButton!
    @IBAction func topButtonAction(_ sender: UIButton) {
        
        if viewState != 1
        {
            viewState = 1
            
        }
//        else
//        {
//            if topTableViewHeight.constant == 0
//            {
//                topTableViewHeight.constant = (view.frame.height - applyButton.frame.height - topButton.frame.height - middleButton.frame.height - topButton.frame.height - 90)
//            }
//            else
//            {
//                topTableViewHeight.constant = 0
//            }
//        }
    }
    
    @IBOutlet weak var middleButton: UIButton!
    @IBAction func middleButtonAction(_ sender: UIButton) {
        
        if viewState != 2
        {
            viewState = 2
            
        }
//        else
//        {
//            if middleTableViewHeight.constant == 0
//            {
//                middleTableViewHeight.constant = (view.frame.height - applyButton.frame.height - topButton.frame.height - middleButton.frame.height - topButton.frame.height - 90)
//            }
//            else
//            {
//                middleTableViewHeight.constant = 0
//            }
//        }
    }
    
    @IBOutlet weak var bottomButton: UIButton!
    @IBAction func bottomButtonAction(_ sender: UIButton) {
        
        if viewState != 3
        {
            viewState = 3
        
        }
//        else
//        {
//            if bottomTableViewHeight.constant == 0
//            {
//                bottomTableViewHeight.constant = (view.frame.height - applyButton.frame.height - topButton.frame.height - middleButton.frame.height - topButton.frame.height - 90)
//            }
//            else
//            {
//                bottomTableViewHeight.constant = 0
//            }
//        }
        
    }
    
    @IBOutlet weak var applyButton: UIButton!
    @IBAction func ApplyButtonAction(_ sender: UIButton) {
        
        if !types.isEmpty || !filteredWaters.isEmpty || !pressAndSqueezes.isEmpty || !yeasts.isEmpty
        {
            print("filter Set. going back..")
            
            self.sakeFilterDelegate?.didSelectFiltersWith(types: types, filteredWaters: filteredWaters, yeasts: yeasts, pressAndSqueezes: pressAndSqueezes)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        localizeView()
        viewState = 1
        
        
        topTableView.register(UINib(nibName: "CheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckBoxTableViewCell")
        middleTableview.register(UINib(nibName: "CheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckBoxTableViewCell")
        bottomTableView.register(UINib(nibName: "CheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckBoxTableViewCell")
        
        topTableView.allowsMultipleSelection = true
        middleTableview.allowsMultipleSelection = true
        bottomTableView.allowsMultipleSelection = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        
        sakeFilterDelegate = nil
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    func localizeView()
    {
        topButton.setTitle("CLASSIFICATION".localized(), for: .normal)
        middleButton.setTitle("FILTERATION METHOD".localized(), for: .normal)
        bottomButton.setTitle("PRESS AND SQUEEZE".localized(), for: .normal)
        
        applyButton.setTitle("Apply".localized(), for: .normal)
    
    }
    
    func changeState(state: Int)
    {
        switch state {
        case 1:
            topButton.backgroundColor = DefaultConstants.filterButtonTappedColor
            middleButton.backgroundColor = DefaultConstants.filterButtonNotTappedColor
            bottomButton.backgroundColor = DefaultConstants.filterButtonNotTappedColor
            
            middleTableViewHeight.constant = 0
            bottomTableViewHeight.constant = 0
            topTableViewHeight.constant = (view.frame.height - applyButton.frame.height - topButton.frame.height - middleButton.frame.height - topButton.frame.height - 90)
        case 2:
            
            topButton.backgroundColor = DefaultConstants.filterButtonNotTappedColor
            middleButton.backgroundColor = DefaultConstants.filterButtonTappedColor
            bottomButton.backgroundColor = DefaultConstants.filterButtonNotTappedColor
            
            topTableViewHeight.constant = 0
            bottomTableViewHeight.constant = 0
            middleTableViewHeight.constant = (view.frame.height - applyButton.frame.height - topButton.frame.height - middleButton.frame.height - topButton.frame.height - 90)
        case 3:
            
            topButton.backgroundColor = DefaultConstants.filterButtonNotTappedColor
            middleButton.backgroundColor = DefaultConstants.filterButtonNotTappedColor
            bottomButton.backgroundColor = DefaultConstants.filterButtonTappedColor
            
            topTableViewHeight.constant = 0
            middleTableViewHeight.constant = 0
            bottomTableViewHeight.constant = (view.frame.height - applyButton.frame.height - topButton.frame.height - middleButton.frame.height - topButton.frame.height - 90)
        default:
            return
        }
    
    
    }
    
    
    // MARK: - Table view data source
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //return (tableView.frame.height / (CGFloat(dataArray.count) + CGFloat(1.5)))
        
        if tableView == topTableView
        {
            return (tableView.frame.height / (CGFloat(topTableData.count)))
            
        } else if tableView == middleTableview
        {
            return (tableView.frame.height / (CGFloat(middleTableData.count)))
        }
        else if tableView == bottomTableView
        {
            return (tableView.frame.height / (CGFloat(bottomTableData.count)))
        }
        
        return 40
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if tableView == topTableView
        {
            return topTableData.count
        
        } else if tableView == middleTableview
        {
            return middleTableData.count
        
        }
        else if tableView == bottomTableView
        {
            return bottomTableData.count
        }
        
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxTableViewCell", for: indexPath) as? CheckBoxTableViewCell
        {
            cell.selectionStyle = .none
        
            var setString = String()
            
            if tableView == topTableView
            {
                setString = topTableData[indexPath.row]
                
            } else if tableView == middleTableview
            {
                setString = middleTableData[indexPath.row]
                
            }
            else if tableView == bottomTableView
            {
                setString = bottomTableData[indexPath.row]
            }
        
            cell.cellLabel.text = setString
        
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("Cell Selected ")
        
        if let cell = tableView.cellForRow(at: indexPath) as? CheckBoxTableViewCell
        {
        
            if tableView == topTableView
            {
                if types.count > 0
                {
                    if let index = types.index(of: topTableData[indexPath.row])
                    {
                        types.remove(at: index)
                        //deselect
                        print("removed")
                        
                        cell.CheckMarkImageView.image = UIImage(named: "empty_checkbox")
                    }
                    else
                    {
                        types.append(topTableData[indexPath.row])
                        //select
                        print("added")
                        cell.CheckMarkImageView.image = UIImage(named: "checked_checkbox")
                    }
                
                }
                else
                {
                    types.append(topTableData[indexPath.row])
                    //select
                    print("added")
                    cell.CheckMarkImageView.image = UIImage(named: "checked_checkbox")
                }
                
            } else if tableView == middleTableview
            {
                if filteredWaters.count > 0
                {
                    if let index = types.index(of: middleTableData[indexPath.row])
                    {
                        filteredWaters.remove(at: index)
                        //deselect
                        print("removed")
                        cell.CheckMarkImageView.image = UIImage(named: "empty_checkbox")
                    }
                    else
                    {
                        filteredWaters.append(middleTableData[indexPath.row])
                        //select
                        print("added")
                        cell.CheckMarkImageView.image = UIImage(named: "checked_checkbox")
                    }
                    
                }
                else
                {
                    filteredWaters.append(middleTableData[indexPath.row])
                    //select
                    print("added")
                    cell.CheckMarkImageView.image = UIImage(named: "checked_checkbox")
                }
                
            }
            else if tableView == bottomTableView
            {
                if types.count > 0
                {
                    if let index = types.index(of: bottomTableData[indexPath.row])
                    {
                        types.remove(at: index)
                        //deselect
                        
                        print("removed")
                        cell.CheckMarkImageView.image = UIImage(named: "empty_checkbox")
                    }
                    else
                    {
                        types.append(bottomTableData[indexPath.row])
                        //select
                        print("added")
                        cell.CheckMarkImageView.image = UIImage(named: "checked_checkbox")
                    }
                    
                }
                else
                {
                    types.append(bottomTableData[indexPath.row])
                    //select
                    print("added")
                    cell.CheckMarkImageView.image = UIImage(named: "checked_checkbox")
                }
                
            }
        
        }
        
    }
    
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return false
//    }
    
    
    
    
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
