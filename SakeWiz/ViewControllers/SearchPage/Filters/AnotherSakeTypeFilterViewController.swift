//
//  AnotherSakeTypeFilterViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/05.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift

class AnotherSakeTypeFilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let sectionHeaders = ["CLASSIFICATION".localized(), "FILTRATION METHOD".localized(), "PRESS AND SQUEEZE".localized()]
    
    let dataArray = [0:["JUNMAIDAIGINJOSHU".localized(),
                        "JUNMAIGINJOSHU".localized(),
                        "TOKUBETSUJUNMAISHU".localized(),
                        "JUNMAISHU".localized(),
                        "DAIJINJOSHU".localized(),
                        "GINJOSHU".localized(),
                        "TOKEBETSUHONJOZOSHU".localized(),
                        "HONJOZOSHU".localized(),
                        "SPARKING".localized(),
                        "MIXEDLIQUOR".localized(),"OTHER".localized()],
                     1: ["MUROKAGENSHU".localized(),"MUROKA".localized(),"GENSHUMUKASHI".localized(),"OTHER".localized()],
                     2: ["ARABASHIRI".localized(),"NAKADORI_NAKAGUMO_NAKADARE".localized(),
                         "SEME_OSHIKIRI".localized(),
                         "FUKUROTURI_FUKUROSHIBORI_TSURUSHIZAKE".localized(),
                         "TOBINDORI_TOBINKAKOI".localized(),
                         "ORIGARAMI".localized(),
                         "NIGORIZAKE".localized(),
                         "OTHER".localized()]]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var applyButton: UIButton!
    @IBAction func ApplyButtonAction(_ sender: UIButton) {
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "TestTableViewCell")
        tableView.register(UINib(nibName: "CheckBoxTableViewCell", bundle: nil), forCellReuseIdentifier: "CheckBoxTableViewCell")
        
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.sectionHeaders.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return self.applyButton.frame.height * 0.7
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell") as? TestTableViewCell
        {
            cell.cellLabel.text = sectionHeaders[section]
            
            return cell
        }
        return nil
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        //return (tableView.frame.height / (CGFloat(dataArray.count) + CGFloat(1.5)))
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return dataArray[section]!.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxTableViewCell", for: indexPath) as? CheckBoxTableViewCell
        {
            if let currentString = dataArray[indexPath.section]?[indexPath.row]
            {
                cell.cellLabel.text = currentString
                
            }
            
            
            
            
            return cell
        }
        
        return UITableViewCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
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
