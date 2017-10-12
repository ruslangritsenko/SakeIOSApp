//
//  UIViewControllerExtensions.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/05/23.
//  Copyright © 2017 TW welly. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {

    func alert(message: String, title: String? = nil, OKButtonTitle: String? = "OK", completionHandler: (() ->Void)?)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OKAction = UIAlertAction(title: OKButtonTitle, style: .default, handler: nil)
        alertController.addAction(OKAction)
        self.present(alertController, animated: true, completion: {completionHandler?()})
    
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }


}
