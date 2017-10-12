//
//  UserDetailsViewController.swift
//  SakeWiz
//
//  Created by TW welly on 7/9/17.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Localize_Swift
import Kingfisher

class UserDetailsViewController: UIViewController {
    
    var currentUser = UserObject()
    
    var passedUserHandle:String? = nil
    
    
    //Top UserView
    @IBOutlet weak var activitySpinner: UIActivityIndicatorView!
    @IBOutlet weak var backgroundUserImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userLocationLabel: UILabel!
    @IBOutlet weak var userRankLabel: UILabel!
    @IBOutlet weak var userRankIcon: UIImageView!

    @IBOutlet weak var reviewsButton: UIButton!
    @IBAction func reviewsButtonAction(_ sender: UIButton) {
        
        
    }
    
    @IBOutlet weak var followersButton: UIButton!
    @IBAction func followersButtonAction(_ sender: UIButton) {
        
        
    }
    
    //bottom information view
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followersDescriptionLabel: UILabel!
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var followingDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var reviewsDescriptionLabel: UILabel!
    
    @IBOutlet weak var savedSakesLabel: UILabel!
    @IBOutlet weak var savedSakesDescriptionLabel: UILabel!
    
    @IBOutlet weak var wizMomentsLabel: UILabel!
    @IBOutlet weak var wizMomentsDescriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        localize()
        
        if let handle = passedUserHandle
        {
            API.User.getUserBy(userHandle: handle, completionHandler: {[weak self] user in
                
                print(user.location)
                self?.currentUser = user
                
                self?.refreshView(user: user)
                
                
                }, failure: {errorMessage in print(errorMessage as Any)})
        }
        else
        {
            print("must inistintate the controller with a user handle")
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func localize()
    {
        followersDescriptionLabel.text = "Followers".localized()
        followingDescriptionLabel.text = "Following".localized()
        reviewsDescriptionLabel.text = "Reviews".localized()
        savedSakesDescriptionLabel.text = "Saved Sakes".localized()
        wizMomentsDescriptionLabel.text = "Wiz Moments".localized()
    }
    
    private func refreshView(user: UserObject)
    {
        
        activitySpinner.isHidden = false
        avatarImageView.kf.setImage(with: user.userAvatarURL, placeholder: UIImage(named: "screenshot_avatar"), options: nil, progressBlock: nil, completionHandler: {[weak self] completion in
                
                self?.activitySpinner.isHidden = true
                
                if completion.1 != nil
                {
                    self?.avatarImageView.image = UIImage(named: "screenshot_avatar")?.circle
                    print("KingFisher Fetch Error: \(String(describing: completion.1))")
                }
            
                self?.avatarImageView.image = completion.0?.circle
                
            })
        userNameLabel.text = user.handle
        userLocationLabel.text = user.location
        userRankLabel.text = user.userRank

        
        followersLabel.text = "0"
        followingLabel.text = "0"
        reviewsLabel.text = "0"
        savedSakesLabel.text = "0"
        wizMomentsLabel.text = "0"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
