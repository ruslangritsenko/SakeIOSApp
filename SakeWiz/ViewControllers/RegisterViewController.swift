//
//  RegisterViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/23.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation
import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    
    weak var dashboardInformationToPass = DashboardObject()
    
    var keyboardHeight = CGFloat()
    
    var delegate: loginVCProtocol?
    
    @IBOutlet weak var ErrorLabel: UILabel!
    
    @IBOutlet weak var HandleTextField: UITextField!
    
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PasswordTextField: UITextField!
    
    
    @IBOutlet weak var GetStartedButton: UIButton!
    
    @IBAction func GetStartedButtonAction(_ sender: UIButton) {
        
        self.normalize()
        
        if let email = self.EmailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), email != ""
        {
            
            if let password = self.PasswordTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), password != ""
            {
                
                if let handle = self.HandleTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), handle != ""
                {
                    self.createUser(handle: handle, password: password, email: email)
                }
                else
                {
                    
                    self.ErrorLabel.text = NSLocalizedString("Please enter a handle", comment: "")
                    self.ErrorLabel.isHidden = false
                    self.HandleTextField.layer.borderWidth = 1
                    self.HandleTextField.layer.borderColor = self.ErrorLabel.backgroundColor?.cgColor
                }
            }
            else
            {
                 self.ErrorLabel.text = NSLocalizedString("Please enter a password", comment: "")
                self.ErrorLabel.isHidden = false
                self.PasswordTextField.layer.borderWidth = 1
                self.PasswordTextField.layer.borderColor = self.ErrorLabel.backgroundColor?.cgColor
            }
        }
        else
        {
            self.ErrorLabel.text = NSLocalizedString("Please enter a email", comment: "")
            self.ErrorLabel.isHidden = false
            self.EmailTextField.layer.borderWidth = 1
            self.EmailTextField.layer.borderColor = self.ErrorLabel.backgroundColor?.cgColor
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.topItem?.title = "Back".localized()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        
        
        
        self.ErrorLabel.isHidden = true
        
        PasswordTextField.delegate = self
        EmailTextField.delegate = self
        HandleTextField.delegate = self
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(notification:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name.UIKeyboardWillShow, object: nil)
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
        
        if let destinationVC = segue.destination as? DashboardViewController
        {
            print("passing Dashboard Info")
            if dashboardInformationToPass != nil
            {
                destinationVC.dashboardInformation = dashboardInformationToPass!
                
            }
            
        }
        
     }

    
    
    func createUser(handle: String, password: String, email: String)
    {
        print("CREATING USER")
        
        if let preferredLanguage = Locale.current.languageCode
        {
            print(preferredLanguage)
            
            let newUser = UserObject()
            newUser.email = email
            newUser.language = preferredLanguage
            newUser.password = password
            newUser.handle = handle
            
            API.newUser(user: newUser, completionHandler: {
                
                self.navigationController?.popViewController(animated: true)
                self.delegate?.loginWith(username: newUser.handle, password: newUser.password)
                
                
            }, failure: { errorMessage in
            
                self.ErrorLabel.text = errorMessage
                self.ErrorLabel.isHidden = false
                
                print(errorMessage)
            
            
            })
            
        }
        
    }
    
    func normalize()
    {
        self.ErrorLabel.isHidden = true
        
        self.HandleTextField.layer.borderWidth = 0
        self.PasswordTextField.layer.borderWidth = 0
        self.EmailTextField.layer.borderWidth = 0
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if PasswordTextField.isEditing {
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                keyboardHeight = keyboardSize.height
                self.view.window?.frame.origin.y = -1 * keyboardSize.height
                
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.view.window?.frame.origin.y != 0 {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                self.view.window?.frame.origin.y += keyboardSize.height
            }
        }
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if PasswordTextField == textField
        {
            if self.view.window?.frame.origin.y != 0 {
            
                self.view.window?.frame.origin.y += keyboardHeight
            }
        }
        return true
    }
    
    
}
