//
//  SideViewHelperClass.swift
//  SakeWiz
//
//  Created by welly, TW on 12/14/16.
//  Copyright © 2016 TW welly. All rights reserved.
//

import Foundation
import UIKit
import Localize_Swift

final class SideViewHelperClass {

    static let sharedInstance = SideViewHelperClass()
    
    var shouldMoveToView = false
    var moveToViewName: String? = nil
    var passedDelegate: SideMenuProtocol?
    var fromVC: String? = nil
    
    class func resetSharedInstance()
    {
        SideViewHelperClass.sharedInstance.moveToViewName = nil
        SideViewHelperClass.sharedInstance.shouldMoveToView = false
        SideViewHelperClass.sharedInstance.passedDelegate = nil
        SideViewHelperClass.sharedInstance.fromVC = nil
    }
    
    class func setSharedInstance(moveToViewName: String?, shouldMoveToView: Bool)
    {
        SideViewHelperClass.sharedInstance.moveToViewName = moveToViewName
        SideViewHelperClass.sharedInstance.shouldMoveToView = shouldMoveToView
    }
    
    class func checkAndMoveToNewVC(_ fromViewController: UIViewController)
    {
        if let moveToVCName = SideViewHelperClass.sharedInstance.moveToViewName, SideViewHelperClass.sharedInstance.shouldMoveToView == true
        {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         
            DispatchQueue.main.async(execute: {
            
                switch moveToVCName
                {
                    //            case "Logout".localized():
                //                fromViewController
                    
                case "Inventory Add":
                    SideViewHelperClass.resetSharedInstance()
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "AddProductDetailsViewController")
                    fromViewController.navigationController?.pushViewController(nextVC, animated: true)
                    fromViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
                    fromViewController.navigationController?.navigationBar.tintColor = UIColor.white
                    
                case "Newsfeed":
                    SideViewHelperClass.resetSharedInstance()
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "NewsfeedViewController")
                    fromViewController.navigationController?.pushViewController(nextVC, animated: true)
                    fromViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
                    fromViewController.navigationController?.navigationBar.tintColor = UIColor.white
                    
                case "Camera":
                    
                    
                    SideViewHelperClass.resetSharedInstance()
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "CameraViewController")
                    fromViewController.navigationController?.pushViewController(nextVC, animated: true)
                    fromViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
                    fromViewController.navigationController?.navigationBar.tintColor = UIColor.white
                    
                case "Search":
                    SideViewHelperClass.resetSharedInstance()
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "SearchRootViewController")
                    fromViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
                    fromViewController.navigationItem.backBarButtonItem?.tintColor = UIColor.white
                    fromViewController.navigationController?.pushViewController(nextVC, animated: true)
                case "Settings":
                    SideViewHelperClass.resetSharedInstance()
                    let nextVC = storyBoard.instantiateViewController(withIdentifier: "SettingsViewController")
                    fromViewController.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
                    fromViewController.navigationItem.backBarButtonItem?.tintColor = UIColor.white
                    fromViewController.navigationController?.pushViewController(nextVC, animated: true)
                    
                default:
                    SideViewHelperClass.resetSharedInstance()
                    return
                }
            
            
            })
        }
    }

}
