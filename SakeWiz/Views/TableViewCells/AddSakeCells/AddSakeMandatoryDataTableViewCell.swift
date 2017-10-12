//
//  AddSakeMandatoryDataTableViewCell.swift
//  SakeWiz
//
//  Created by TW welly on 7/23/17.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Localize_Swift

protocol AddSakeMandatoryDataTableViewCellProtocol
{
    func mandatorySaveDataWasPressed(passedProduct: ProductObject?)

}

class AddSakeMandatoryDataTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {
    
    var delegate: AddSakeMandatoryDataTableViewCellProtocol?
    var indexPath: IndexPath!
    
    fileprivate var isShowingDropDown = false
    
    fileprivate var dropDownState = 0
    
    fileprivate var dropDownTableView = UITableView()
    fileprivate var dataArray = Array<String>()
    

    @IBOutlet weak var MandatoryDataLabel: UILabel!
    
    @IBOutlet weak var MessageToTheUserLabel: UILabel!
    
    @IBOutlet weak var SaveDataButton: UIButton!
    @IBAction func SaveDataButtonAction(_ sender: UIButton) {
        
        print("touched")
        
        var productObject: ProductObject? = nil
        
        if let sakeName = SakeNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), sakeName != ""
        {
            if let classification = ClassificationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), classification != ""
            {
                if let volume = VolumeWeightTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), volume != ""
                {
                    print(volume)
                    
                    if let volumeNumber = Int(volume)
                    {
                        if let brew = BrewingYearTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                        {
                            if let brewYear = Int(brew)
                            {
                                if let acidity = AcidityTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), acidity != "" && Int(acidity) != nil
                                {
                                    if let alcoholPercent = AlcoholPercentageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), alcoholPercent != "" && Int(alcoholPercent) != nil
                                    {
                                        if let filteration = FilterationTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines), filteration != ""
                                        {
                                            productObject = ProductObject()
                                            productObject?.sakeName = sakeName
                                            productObject?.type = classification
                                            productObject?.brewYear = brewYear
                                            productObject?.alcPerc = alcoholPercent
                                            productObject?.filterWater = filteration
                                            productObject?.acidity = acidity
                                        }
                                        else
                                        {
                                            self.MessageToTheUserLabel.text = "Please select a filteration method".localized()
                                            self.addPinkTo(view: FilterationTextField)
                                        }
                                    }
                                    else
                                    {
                                        self.MessageToTheUserLabel.text = "Please fill in an alcohol percentage using a number".localized()
                                        self.addPinkTo(view: AlcoholPercentageTextField)
                                    }
                                
                                }
                                else
                                {
                                    self.MessageToTheUserLabel.text = "Please fill in an acidity value using numbers".localized()
                                    self.addPinkTo(view: AcidityTextField)
                                }
                            }
                            else
                            {
                                self.MessageToTheUserLabel.text = "Please use a number".localized()
                                self.addPinkTo(view: BrewingYearTextField)
                            }
                        }
                        else
                        {
                            self.MessageToTheUserLabel.text = "Please fill in a brew year using numbers".localized()
                            self.addPinkTo(view: BrewingYearTextField)
                        }
                    }
                    else
                    {
                        print("OK")
                        self.MessageToTheUserLabel.text = "Please use a number".localized()
                        self.addPinkTo(view: VolumeWeightTextField)
                    }
                }
                else
                {
                    print("hi")
                    self.MessageToTheUserLabel.text = "Please fill in a Volume with a number".localized()
                    self.addPinkTo(view: VolumeWeightTextField)
                }
            }
            else
            {
                self.MessageToTheUserLabel.text = "Please select a classification".localized()
                self.addPinkTo(view: ClassificationTextField)
            }
        }
        else
        {
            self.MessageToTheUserLabel.text = "Please fill in a Sake Name".localized()
            self.addPinkTo(view: SakeNameTextField)
        }
        
        self.delegate?.mandatorySaveDataWasPressed(passedProduct: productObject)
    }
    
    @IBOutlet weak var SakeNameLabel: UILabel!
    @IBOutlet weak var SakeNameTextField: UITextField!
    
    @IBOutlet weak var ClassificationLabel: UILabel!
    @IBOutlet weak var ClassificationTextField: UITextField!
    @IBAction func ClassificationButtonAction(_ sender: UIButton) {
        
        dataArray = ["Junmai Daiginjoshu".localized(), "Junmai Ginjoshu".localized(), "Tokubetsu Junmaishu".localized(), "Junmaishu".localized(), "Daijinjoshu".localized(), "Ginjoshu".localized(), "Tokubetsu Honjozoshu".localized(), "Honjozoshu".localized(), "Sparkling".localized(), "Amazake".localized(), "Mixed Liquor".localized()]
        
        dropDownState = 1
        
        showDropdownAt(passedView: sender, atBottom: false)

    }
    
    
    @IBOutlet weak var VolumeWeightLabel: UILabel!
    @IBOutlet weak var VolumeWeightTextField: UITextField!
    @IBOutlet weak var VolumeWeightDescriptorTextField: UITextField!
    @IBAction func VolumeWeightDescriptorButtonAction(_ sender: UIButton) {

        dataArray = []
        
        dropDownState = 2
        showDropdownAt(passedView: sender, atBottom: false)

        
    }
    
    @IBOutlet weak var BrewingYearLabel: UILabel!
    @IBOutlet weak var BrewingYearTextField: UITextField!
    
    @IBOutlet weak var AlcoholPercentageLabel: UILabel!
    @IBOutlet weak var AlcoholPercentageTextField: UITextField!
    
    @IBOutlet weak var AcidityLabel: UILabel!
    @IBOutlet weak var AcidityTextField: UITextField!
    
    @IBOutlet weak var FilterationLabel: UILabel!
    @IBOutlet weak var FilterationTextField: UITextField!
    @IBAction func FilterationButtonAction(_ sender: UIButton) {
        
        dataArray = []
        
        dropDownState = 3
        showDropdownAt(passedView: sender, atBottom: true)

        
    }
    
    fileprivate func addPinkTo(view: UIView)
    {
        normalize()
        view.borderWidth = 1
        view.borderColor = DefaultConstants.pinkColor
    }
    
    fileprivate func normalize()
    {
        self.SakeNameTextField.borderWidth = 0
        self.ClassificationTextField.borderWidth = 0
        self.FilterationTextField.borderWidth = 0
        self.VolumeWeightTextField.borderWidth = 0
        self.AcidityTextField.borderWidth = 0
        self.BrewingYearTextField.borderWidth = 0
        self.VolumeWeightDescriptorTextField.borderWidth = 0
    }
    
    fileprivate func showDropdownAt(passedView: UIView, atBottom: Bool)
    {
        if isShowingDropDown
        {
            self.dropDownTableView.removeFromSuperview()
        }
        if let globalPoint = passedView.superview?.convert(passedView.frame.origin, to: nil)
        {
            if atBottom
            {
                self.dropDownTableView.frame = CGRect(x: globalPoint.x, y: (globalPoint.y - (passedView.frame.height * 3)), width: passedView.frame.width, height: passedView.frame.height * 2)
            }
            else
            {
                self.dropDownTableView.frame = CGRect(x: globalPoint.x, y: (globalPoint.y + (passedView.frame.height / 3) + 4), width: passedView.frame.width, height: passedView.frame.height * 3)
            }
            
            //self.dropDownTableView.frame = CGRect(x: passedView.bounds.midX, y: passedView.bounds.midY, width: passedView.bounds.size.width, height: self.frame.height / 2)
            
            self.isShowingDropDown = true
            self.dropDownTableView.reloadData()
            self.addSubview(dropDownTableView)
        }
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        dropDownTableView.register(UINib(nibName: "TestTableViewCell", bundle: nil), forCellReuseIdentifier: "TestTableViewCell")
        
        dropDownTableView.delegate = self
        dropDownTableView.dataSource = self
        dropDownTableView.borderWidth = 1
        dropDownTableView.borderColor = UIColor.lightGray
        dropDownTableView.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return self.FilterationTextField.frame.height
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
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TestTableViewCell", for: indexPath) as? TestTableViewCell
        {
            cell.cellLabel.font = UIFont.systemFont(ofSize: 14)
            cell.cellLabel.textColor = .black
            cell.cellLabel.backgroundColor = .clear
            cell.cellLabel.textAlignment = .left
            
            cell.cellLabel.text = dataArray[indexPath.row]
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch dropDownState {
        case 1:
            self.ClassificationTextField.text = dataArray[indexPath.row]
        case 2:
            self.VolumeWeightTextField.text = dataArray[indexPath.row]
        case 3:
            self.FilterationTextField.text = dataArray[indexPath.row]
        default:
            return
        }
        
        self.dropDownTableView.removeFromSuperview()
        self.isShowingDropDown = false
        
    }
    
}
