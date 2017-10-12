//
//  LoginViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/22.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Localize_Swift

protocol loginVCProtocol {
    
    func loginWith(username: String, password: String)
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    var anyError: String? = nil
    
    var delegate: loginVCProtocol?
    
    weak var dashboardObjectToPass = DashboardObject()
    
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var ErrorMessageLabel: UILabel!
    
    @IBOutlet weak var SignInButton: UIButton!
    @IBAction func SignInButtonAction(_ sender: UIButton) {
        
        normalize()
        if let email = self.EmailTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), email != ""
        {
            
            if let password = self.PasswordTextField.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines), password != ""
            {
                navigationController?.popToRootViewController(animated: true)
                self.delegate?.loginWith(username: email, password: password)
                
            }
            else
            {
                displayError(errorMessage: "Please enter a password".localized(), viewToHighlight: self.PasswordTextField)
            }
        }
        else
        {
            displayError(errorMessage: "Please enter a handle".localized(), viewToHighlight: self.EmailTextField)
        }
    }
    
    @IBOutlet weak var RegisterWithEmailButton: UIButton!
    @IBAction func RegisterWithEmailButtonAction(_ sender: UIButton) {
        
        self.standardLogin()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = true
        
        normalize()
        
        if anyError != nil
        {
            displayError(errorMessage: anyError!)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        ErrorMessageLabel.isHidden = true
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton

        // Do any additional setup after loading the view.
        
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        
        if UserObject.sharedInstance.handle != "" && UserObject.sharedInstance.password != ""
        {
            PasswordTextField.text = UserObject.sharedInstance.password
            EmailTextField.text = UserObject.sharedInstance.handle
        }
        
        self.hideKeyboardWhenTappedAround()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        
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
            if dashboardObjectToPass != nil
            {
                destinationVC.dashboardInformation = dashboardObjectToPass!
            }
        } else if let destinationVC = segue.destination as? RegisterViewController
        {
        
            destinationVC.delegate = delegate
        
        }
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func normalize()
    {
        self.ErrorMessageLabel.isHidden = true

        self.PasswordTextField.layer.borderWidth = 0
        self.EmailTextField.layer.borderWidth = 0
    }
    
    func displayError(errorMessage: String, viewToHighlight: UITextField? = nil)
    {
        self.ErrorMessageLabel.text = errorMessage
        self.ErrorMessageLabel.isHidden = false
        
        if viewToHighlight != nil
        {
            viewToHighlight!.layer.borderWidth = 1
            viewToHighlight!.layer.borderColor = self.ErrorMessageLabel.backgroundColor?.cgColor
        
        }
        
    
    
    }
    
    func standardLogin()
    {
        API.authenticate(username: APIConstants.system_user, password: APIConstants.user_creation_pass, completionHandler: {
        
            print("done with login")
            self.performSegue(withIdentifier: "ToCreateUser", sender: self)
        
        }, failure: { errorMessage in
        
            if let message = errorMessage
            {
                self.ErrorMessageLabel.text = message
                self.ErrorMessageLabel.isHidden = false
            }
        
        })
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if PasswordTextField.isEditing {
            
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
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

}
