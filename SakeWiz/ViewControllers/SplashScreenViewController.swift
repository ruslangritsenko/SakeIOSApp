//
//  SplashScreenViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 12/16/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import UIKit
import SwiftyGif
import Localize_Swift

class SplashScreenViewController: UIViewController, LoggedOutProtocol, loginVCProtocol {
    
    weak var dashboardInformationToPass = DashboardObject()
    
    var loginError: String? = nil

    @IBOutlet weak var sakeWizImageView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let preferredLanguage = Locale.current.languageCode
        {
            Localize.setCurrentLanguage(preferredLanguage)
            
        }
        
        
        let gifmanager = SwiftyGifManager(memoryLimit:5)
        let gif = UIImage(gifName: "SakeWizAnimation")
        sakeWizImageView.setGifImage(gif, manager: gifmanager)

        
        
        
        tryToLogin()

        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func goDirectlyToNewView()
    {
        
        //sakeWizImageView.layer.removeAllAnimations()
        
        //sakeWizImageView.stopAnimatingGif()
        
        performSegue(withIdentifier: "ToLogin", sender: self)
    
    }
    
    func tryToLogin()
    {
        print("checking User defaults")
        
        if let user = UserObject.getUserDefaults()
        {
            print("found")
            
            UserObject.sharedInstance = user
            Localize.setCurrentLanguage(user.language)
            if user.userSettings != nil
            {
                if user.userSettings!.autoSignInEnabled
                {
                    API.login(username: user.handle, password: user.password, completionHandler: {
                        
                        API.getDashboard(completionHandler: { dashboardInformation in
                            
                            self.dashboardInformationToPass = dashboardInformation
                            UserObject.sharedInstance.userAvatarURL = URL(string: dashboardInformation.userProfileImageURL)
                            UserObject.setAvatarURL()
                            
                            self.performSegue(withIdentifier: "ToHome", sender: self)
                        }, failure: { errorMessage in
                            
                            print(errorMessage as Any)
                            self.goDirectlyToNewView()
                            
                        })
                        
                    }, failure: {errorMessage in
                        
                        if let message = errorMessage
                        {
                            self.loginError = "Auto-Login Failed: ".localized() + message
                        }
                        self.goDirectlyToNewView()
                    })
                    
                }
                else
                {
                    print("auto login disabled")
                    goDirectlyToNewView()
                    
                }
            }
            else
            {
                print("no userSettings")
                goDirectlyToNewView()
            }
            
        }
        else
        {
            print("not found")
            goDirectlyToNewView()
        }
    
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        LogoutHelperClass.sharedInstance.passedDelegate = self
        
        if let destinationVC = segue.destination as? DashboardViewController
        {
            print("passing Dashboard Info")
            if dashboardInformationToPass != nil
            {
                destinationVC.dashboardInformation = dashboardInformationToPass!
                
            }
        
        } else if let destinationVC = segue.destination as? LoginViewController
        {
            destinationVC.delegate = self
            
            if let error = loginError
            {
                destinationVC.anyError = error
            
            }
        
        
        }
    }
    
    func loggedOut() {
        
        goDirectlyToNewView()
    }
    
    func loginWith(username: String, password: String) {
        
        loginError = nil
        
        API.login(username: username, password: password, completionHandler: {
            
            API.getDashboard(completionHandler: {dashboardObject in
                
                self.dashboardInformationToPass = dashboardObject
                
                UserObject.sharedInstance.userAvatarURL = URL(string: dashboardObject.userProfileImageURL)
                UserObject.setAvatarURL()
                
                self.performSegue(withIdentifier: "ToHome", sender: self)
                
            }, failure: {errorMessage in
                
                if let message = errorMessage
                {
                    self.loginError = message
                    self.goDirectlyToNewView()
                    
                }
                
            })
            
        }, failure: {errorMessage in
            
            if let message = errorMessage
            {
                self.loginError = message
                self.goDirectlyToNewView()
            }
        })
    }

}
