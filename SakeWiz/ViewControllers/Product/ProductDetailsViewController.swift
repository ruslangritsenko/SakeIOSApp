//
//  ProductDetailsViewController.swift
//  SakeWiz
//
//  Created by TW welly on 6/12/17.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Kingfisher
import Localize_Swift
import FloatRatingView



class ProductDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource, FloatRatingViewDelegate, ReviewTableViewCellProtocol
{
    
    weak var passedProductObject: ProductObject?
    
    var userHandleToPass: String? = nil
    
    var isFromDashboard = false
    
    var refreahControl = UIRefreshControl()
    
    var collectionCellHeight = CGFloat()
    
    var reviewRate:Double = 0
    
    var isFavored = false
    {
        didSet {
        
            if isFavored
            {
                self.favoritesImageView.image = UIImage(named: "heart_icon_red")
            }
            else
            {
                self.favoritesImageView.image = UIImage(named: "heart_icon_gray")
            }
        }
    }
    
    var prevReviewPresent = false
    {
        didSet{
        
            if prevReviewPresent
            {
                self.reviewDescriptionLabel.text = "Update your review?".localized()
            }
            else
            {
                self.reviewDescriptionLabel.text = "How did you like it?".localized()
            }
        
            
        }
    }
    
    var reviewCollapsed = true
    {
        didSet{
        
            if reviewCollapsed
            {
                self.expandReview()
            }
            else
            {
                self.hideReview()
            }
            
        }
    }
    
    var overallRating: Double = 0
    {
        didSet {
            
            self.ratingLabelInSakeView.text = String(overallRating) + " " + "rating".localized()
            if passedProductObject?.reviews != nil
            {
                if passedProductObject!.reviews!.count < 1
                {
                    star1.isHidden = true
                    star2.isHidden = true
                    star3.isHidden = true
                    star4.isHidden = true
                    star5.isHidden = true
                    
                    ratingLabelInSakeView.isHidden = true
                }
                else
                {
                    star1.isHidden = false
                    star2.isHidden = false
                    star3.isHidden = false
                    star4.isHidden = false
                    star5.isHidden = false
                    
                    ratingLabelInSakeView.isHidden = false
                }
            }
            
            switch overallRating {
            case  0..<0.5:
                star1.image = UIImage(named: "star_icon_gray")
                star2.image = UIImage(named: "star_icon_gray")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 0.5..<1:
                star1.image = UIImage(named: "half_star_yellow")
                star2.image = UIImage(named: "star_icon_gray")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 1..<1.5:
                star1.image = UIImage(named: "half_star_yellow")
                star2.image = UIImage(named: "star_icon_gray")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 1.5..<2:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "half_star_yellow")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
            case 2..<2.5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 2.5..<3:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "half_star_yellow")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 3..<3.5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 3.5..<4:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "half_star_yellow")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 4..<4.5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "star_icon_yellow")
                star5.image = UIImage(named: "star_icon_gray")
                
            case 4.5..<5:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "star_icon_yellow")
                star5.image = UIImage(named: "half_star_yellow")
                
            case 5..<Double.greatestFiniteMagnitude:
                star1.image = UIImage(named: "star_icon_yellow")
                star2.image = UIImage(named: "star_icon_yellow")
                star3.image = UIImage(named: "star_icon_yellow")
                star4.image = UIImage(named: "star_icon_yellow")
                star5.image = UIImage(named: "star_icon_yellow")
            default:
                star1.image = UIImage(named: "star_icon_gray")
                star2.image = UIImage(named: "star_icon_gray")
                star3.image = UIImage(named: "star_icon_gray")
                star4.image = UIImage(named: "star_icon_gray")
                star5.image = UIImage(named: "star_icon_gray")
            }
            
            
        }
        
    }
    
    
    // MARK: - Views Outlets
    
    @IBOutlet weak var reviewStarsView: FloatRatingView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        
        self.reviewCollapsed = false
    }
    
    @IBOutlet weak var cancelButtonHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var sakeBackgroundView: UIView!
    @IBOutlet weak var CollectionViewContainerView: UIView!
    @IBOutlet weak var SakeContainerView: UIView!
    @IBOutlet weak var StatusBarContainerView: UIView!
    @IBOutlet weak var TableViewContainerView: UIView!
    
    @IBOutlet weak var SakeImageView: UIImageView!
    
    @IBOutlet weak var ProductScrollView: UIScrollView!
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var reviewView: UIView!
    
    @IBOutlet weak var reviewViewHeight: NSLayoutConstraint!
    @IBOutlet weak var submitReviewButton: UIButton!
    @IBAction func submitReviewButton(_ sender: UIButton) {
        
        self.reviewCollapsed = false
        
        let ratingToSend = self.reviewRate
        
        let reviewText = reviewTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
            if passedProductObject != nil
            {
                print("now submitting review with rating: \(self.reviewRate)")
                
                API.ReviewService.submitProductReviewWith(productID: passedProductObject!.id, comment: reviewText, rating: ratingToSend, completionHandler: {[weak self] returnedID, newRate in
                    
                    
                    let newReviewObject = ReviewObject()
                    
                    newReviewObject.creationTime = Date()
                    
                    if returnedID != nil
                    {
                        newReviewObject.id = returnedID!
                    }
                    
                    newReviewObject.rating = ratingToSend
                    newReviewObject.userHandle = UserObject.sharedInstance.handle
                    newReviewObject.reviewDic = [UserObject.sharedInstance.language:reviewText]
                    //newReviewObject.userAddress = UserObject.sharedInstance.location
                    
                    
                    

                    if let updateReview = self?.prevReviewPresent, updateReview == true
                    {
                        if let reviews = self?.passedProductObject?.reviews, reviews.count > 0
                        {
                            for (index, review) in reviews.enumerated()
                            {
                                if review.userHandle == UserObject.sharedInstance.handle
                                {
                                    self?.passedProductObject?.reviews?[index] = newReviewObject
                                }
                            }
                        }
                    }
                    else
                    {
                        self?.passedProductObject?.reviews?.insert(newReviewObject, at: 0)
                    }
                    
                    if let thisRate = newRate
                    {
                        print("not nil")
                        self?.overallRating = thisRate
                        
                    }
                    
                    
                    self?.tableView.reloadData()
                    
                    
                    }, failure: {[weak self] errorMessage in print(errorMessage as Any)})
    
            }
        
    }
    @IBOutlet weak var submitReviewButtonHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewTextViewHeight: NSLayoutConstraint!
    @IBOutlet weak var reviewTextView: UITextView!
    //@IBOutlet weak var reviewStarsViewToTextView: NSLayoutConstraint!
    @IBOutlet weak var reviewStarsViewToTextView: NSLayoutConstraint!
    @IBOutlet weak var reviewTextViewToButton: NSLayoutConstraint!
    
    @IBOutlet weak var reviewDescriptionLabel: UILabel!
    @IBOutlet weak var ReviewButton: UIButton!
    @IBAction func ReviewButtonAction(_ sender: UIButton) {
        
        
        self.reviewCollapsed = true
        
    }
    // MARK - FAV things Outlets

    //@IBOutlet weak var ratingsView: UIView!
    
    
    // MARK - Toolbar Outlets
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesImageView: UIImageView!
    
    
    
    @IBOutlet weak var chartsView: UIView!
    @IBOutlet weak var chartsLabel: UILabel!
    @IBOutlet weak var chartsImageView: UIImageView!
    
    @IBAction func chartsButtonAction(_ sender: UIButton) {
        
        
        self.performSegue(withIdentifier: "ToUserDetails", sender: self)
        
    }
    
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var favoritesImageView: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    private var canFavor = true
    @IBAction func favoritesButtonAction(_ sender: UIButton) {
        
        if canFavor
        {
            canFavor = false
            
            if self.passedProductObject!.userHasFavored
            {
                API.ProductDetailsService.unfavorProductWith(ID: passedProductObject!.id, completionHandler: {[weak self] in
                    
                    self?.canFavor = true
                    
                    self?.passedProductObject?.userHasFavored = false
                    self?.isFavored = false
                    
                    
                    }, failure: {[weak self] errorMessage in
                        
                        self?.canFavor = true
                        print(errorMessage as Any)
                })
            }
            else
            {
                API.ProductDetailsService.favorProductWith(ID: passedProductObject!.id, completionHandler: {[weak self] in
                    
                    self?.canFavor = true
                    
                    self?.passedProductObject?.userHasFavored = true
                    self?.isFavored = true
                    
                    }, failure: {[weak self] errorMessage in
                        
                        self?.canFavor = true
                        print(errorMessage as Any)
                })
                
            }
        }
        
        
    }
    
    @IBOutlet weak var sakeNameLabelInSakeView: UILabel!
    
    @IBOutlet weak var ratingLabelInSakeView: UILabel!
    
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    
    
    // MARK - CollectionView Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    // MARK - TableView Outlets
    
    @IBOutlet weak var ReviewsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sakeBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.title = ""
        
        navigationController?.navigationBar.isHidden = false
        
        title = "PRODUCT DETAILS".localized()
        
        collectionView.register(UINib(nibName: "ProductDetailsCollectionViewCellTop", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCollectionViewCellTop")
        collectionView.register(UINib(nibName: "ProductDetailsCollectionViewCellMiddle", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCollectionViewCellMiddle")
        collectionView.register(UINib(nibName: "ProductDetailsCollectionViewCellEnd", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCollectionViewCellEnd")
        
        adjustTotalViewHeight()
        
        reviewStarsView.delegate = self
        
        
        tableView.register(UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "ReviewTableViewCell")
        
        
        
        // Do any additional setup after loading the view.
        self.cancelButtonHeight.constant = self.reviewDescriptionLabel.text!.height(withConstrainedWidth:  self.reviewDescriptionLabel.frame.width, font:  self.reviewDescriptionLabel.font)
        self.cancelButton.isHidden = true
        reviewDescriptionLabel.textColor = DefaultConstants.greenColor
        
        if passedProductObject != nil
        {
            
            if isFromDashboard
            {
                API.getProductBy(ID: passedProductObject!.id, completionHandler: {[weak self] returnedProduct in
                    
                    let product = returnedProduct
                    product.reviews = self?.passedProductObject?.reviews
                    self?.setProduct(productObject: product)
                    
                    }, failure: {errorMessage in
                
                        print(errorMessage as Any)
                })
            }
            else
            {
                setProduct(productObject: passedProductObject!)
            }
        }
        else
        {
            
            print("Must have a ProductObject class initiated for the ViewController to be instansiated")
            self.navigationController?.popViewController(animated: true)
        }
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
        super.prepare(for: segue, sender: sender)
        
        if let destinationVC = segue.destination as? UserDetailsViewController
        {
            destinationVC.passedUserHandle = userHandleToPass
        }
    }
    
    // Mark: - Standard Functions
    
    
    func refresh(sender:AnyObject)
    {
        self.refreahControl.endRefreshing()
        
    }
    
    
    
    fileprivate func localize()
    {
        
    }
    
    fileprivate func adjustTotalViewHeight()
    {
        self.reviewViewHeight.constant = self.view.frame.height * 0.2
        
        self.ReviewButton.isHidden = false
        
        self.reviewStarsViewToTextView.constant = 8
        self.reviewTextViewToButton.constant = 0
        self.submitReviewButtonHeight.constant = 0
        self.reviewTextViewHeight.constant = 0
        
        //self.viewHeightConstraint.constant = self.CollectionViewContainerView.frame.height + self.SakeContainerView.frame.height + self.StatusBarContainerView.frame.height + self.reviewViewHeight.constant
        
        
        self.viewHeightConstraint.constant = 1.9 * self.view.frame.height
        
    }
    
    fileprivate func setProduct(productObject: ProductObject)
    {
        
        API.getProductReviewsBy(ID: productObject.id, size: nil, lastID: nil, completionHandler: {[weak self] reviews, avgRate in
            
            self?.passedProductObject?.reviews = reviews
            
            DispatchQueue.main.async(execute: {[weak self] in
            
                for review in reviews
                {
                    if review.userHandle == UserObject.sharedInstance.handle
                    {
                        self?.prevReviewPresent = true
                        if let reviewDic = review.reviewDic
                        {
                            self?.reviewTextView.text = ReviewObject.currentLanguageForDic(reviewDic: reviewDic)
                        }
                        self?.reviewStarsView.rating = Float(review.rating.round(nearest: 0.5))
                    }
                }
            
            })
            
            self?.tableView.reloadData()
            
                if reviews.count < 1
                {
                    self?.overallRating = 0
                }
                else if let rating = avgRate
                {
                    self?.overallRating = rating
                }
            
            
            
            }, failure: {[weak self] errorMessage in print(errorMessage)})
        
        if let url = URL(string: productObject.mainImageURLString)
        {
            SakeImageView.kf.setImage(with: url, placeholder: UIImage(named: "screenshot_avatar"), options: nil, progressBlock: nil, completionHandler: {completion in
                
                
                if completion.1 != nil
                {
                    print("KingFisher Fetch Error: \(String(describing: completion.1))")
                }
                
            })
            
        }
        
        self.sakeNameLabelInSakeView.text = ProductObject.currentNameForDic(productDic: productObject.sakeNameDic)
        
        self.isFavored = self.passedProductObject?.userHasFavored ?? false
        
        self.overallRating = productObject.rating
        print("setting rating: \(productObject.rating)")
        
       
        
        
    }
    
    func expandReview()
    {
        
        self.ReviewButton.isHidden = true
        
        self.cancelButton.isHidden = false
        
        self.reviewStarsViewToTextView.constant = 8
        self.reviewTextViewToButton.constant = 8
        
        self.submitReviewButtonHeight.constant = 50
        self.reviewTextViewHeight.constant = 120
    
        self.reviewViewHeight.constant = self.reviewViewHeight.constant + self.reviewTextViewHeight.constant + self.submitReviewButtonHeight.constant
        
        
    }
    
    func hideReview()
    {
        self.ReviewButton.isHidden = false
        
        self.cancelButton.isHidden = true
        
        self.reviewStarsViewToTextView.constant = 8
        self.reviewTextViewToButton.constant = 0
        
        let buttonHeight = self.submitReviewButtonHeight.constant
        
        self.submitReviewButtonHeight.constant = 0
        
        let textHeight = self.reviewTextViewHeight.constant
        self.reviewTextViewHeight.constant = 0
        
        self.reviewViewHeight.constant = self.reviewViewHeight.constant - textHeight - buttonHeight
        
        self.reviewTextView.endEditing(true)
    }
    
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating:Float) {
        
        print("did update to: \(rating)")
        
        self.reviewRate = Double(rating)
    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Float) {
        
        print("did update to: \(rating)")
        
        self.reviewRate = Double(rating)
        
    }
    
    
    // MARK: - ReviewCell Delgate
    func userWasPressedAt(index: IndexPath) {
        print("user was tapped at: \(index.row)")
        
        if let userHandle = self.passedProductObject?.reviews?[index.row].userHandle
        {
            userHandleToPass = userHandle
            self.performSegue(withIdentifier: "ToUserDetails", sender: self)
        
        }
        
    }
    
    
    private var canLike = true
    func likeButtonPressedAt(index: IndexPath)
    {
        print("like Button Pressed at: \(index.row)")
        
        if let likedCell = tableView.cellForRow(at: index)as? ReviewTableViewCell
        {
            if likedCell.userNameLabel.text != UserObject.sharedInstance.handle
            {
                if let thisReview = passedProductObject?.reviews?[index.row], canLike == true
                {
                    canLike = false
                    
                    print(thisReview.isLiked)
                    if thisReview.isLiked
                    {
                        API.unlikeReviewWith(EntityID: thisReview.id, completionHandler: {[weak self] likeCount in
                            
                            self?.canLike = true
                            
                            self?.passedProductObject?.reviews?[index.row].isLiked = false
                            likedCell.isLiked = false
                            
                            if likeCount != nil
                            {
                                self?.passedProductObject?.reviews?[index.row].likes = likeCount!
                                likedCell.likesLabel.text = String(describing: likeCount!)
                            }
                            
                            
                            }, failure: {[weak self] errorMessage in
                                self?.canLike = true
                                
                                print(errorMessage)})
                    }
                    else
                    {
                        API.likeReviewWith(EntityID: thisReview.id, completionHandler: {[weak self] likeCount in
                            
                            self?.canLike = true
                            self?.passedProductObject?.reviews?[index.row].isLiked = true
                            likedCell.isLiked = true
                            
                            if likeCount != nil
                            {
                                self?.passedProductObject?.reviews?[index.row].likes = likeCount!
                                likedCell.likesLabel.text = String(describing: likeCount!)
                            }
                            
                            }, failure: {[weak self] errorMessage in
                                self?.canLike = true
                                print(errorMessage)})
                    }
                }
            
            }
        }
    }
    
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if passedProductObject?.reviews != nil
        {
            let review = passedProductObject!.reviews![indexPath.row]
            
            if let reviewTextDic = review.reviewDic
            {
                if let reviewText = ReviewObject.currentLanguageForDic(reviewDic: reviewTextDic)
                {
                    let font = UIFont.systemFont(ofSize: 15.0)
                    return 160 + heightForView(text: reviewText, font: font, width: self.tableView.frame.width - 32.0)
                }
                else
                {
                    return 160
                }
            }
            else
            {
                return 160
            }
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        if passedProductObject?.reviews != nil
        {
            return passedProductObject!.reviews!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "UserTableViewCell", for: indexPath) as! UserTableViewCell
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell", for: indexPath) as? ReviewTableViewCell
        {
            let review = passedProductObject!.reviews![indexPath.row]
            
            if review.userHandle == UserObject.sharedInstance.handle
            {
                prevReviewPresent = true
                cell.isLiked = true
            }
            else
            {
                prevReviewPresent = false
                cell.isLiked = review.isLiked
            }
            
            if review.isAffiliate
            {
                review.isSpecialUser = true
            }
            
            cell.selectionStyle = .none
            
            cell.delegate = self
            cell.indexPath = indexPath
            
            
            
            
            
            cell.rating = review.rating
            
            cell.userNameLabel.text = review.userHandle
            cell.locationLabel.text = review.userAddress
            let someFont = UIFont.systemFont(ofSize: cell.userNameLabel.font.pointSize * 0.7)
            cell.locationLabel.font = someFont
            
            cell.levelIconImage.isHidden = true
            cell.specialUserLabel.isHidden = true
            
            
            cell.likesLabel.text = String(review.likes)
            
            if let reviewDic = review.reviewDic
            {
                cell.reviewTextLabelHeight.constant = 20
                if let reviewText = ReviewObject.currentLanguageForDic(reviewDic: reviewDic)
                {
                    let font = UIFont.systemFont(ofSize: 15.0)
                    let height = heightForView(text: reviewText, font: font, width: tableView.frame.width - 32)
                    
                    if height > 20.0
                    {
                        cell.reviewTextLabelHeight.constant = height
                    }
                    else
                    {
                        cell.reviewTextLabelHeight.constant = 20
                    }
                }
                
                cell.reviewTextLabel.text = ReviewObject.currentLanguageForDic(reviewDic: reviewDic)
            }
            else
            {
                cell.reviewTextLabel.text = ""
            }
            
            
            if review.isAffiliate
            {
                cell.affiliateLogoImageView.isHidden = false
            }
            else
            {
                cell.affiliateLogoImageView.isHidden = true
            }
            
            if review.isSpecialUser
            {
                cell.specialUserLabel.isHidden = false
                cell.levelIconImage.isHidden = false
            }
            else
            {
                cell.specialUserLabel.isHidden = true
                cell.levelIconImage.isHidden = true
            }
            

            return cell
            
        }
        
        return UITableViewCell()
    }
    
    
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9, height: collectionView.frame.height )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let sideInset = (collectionView.frame.size.width - (collectionView.frame.width * 0.9)) / 2
        return UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if passedProductObject != nil
        {
            return 3
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalGraphCollectionViewCell", for: indexPath) as! HorizontalGraphCollectionViewCell
        
        switch indexPath.row
        {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailsCollectionViewCellTop", for: indexPath) as? ProductDetailsCollectionViewCellTop
            {
                if let product = passedProductObject
                {
                    cell.CountryDescriptionLabel.text = "Country".localized()
                    cell.CountryLabel.text = ProductObject.currentNameForDic(productDic: product.countryDic)
                    
                    cell.RegionDescriptionLabel.text = "Region".localized()
                    cell.RegionLabel.text = ProductObject.currentNameForDic(productDic: product.regionDic)
                    
                    cell.SMVDescriptionLabel.text = "SMV".localized()
                    if product.smv > 0
                    {
                        cell.SMVLabel.text = "+\(product.smv)"
                    }
                    else
                    {
                        cell.SMVLabel.text = "\(product.smv)"
                    }
                    
                    cell.PolishRateDescriptionLabel.text = "Polish Rate".localized()
                    cell.PolishRateLabel.text = "\(product.kakeRatio)%"
                    
                    cell.AlchoholContentDescriptionLabel.text = "Alcohol Content".localized()
                    cell.AlchoholContentLabel.text = product.alcPerc + "%"
                    
                    cell.ByDescriptionLabel.text = "By".localized()
                    cell.ByLabel.text = String(product.brewYear)
                    
                    cell.GradeDescriptionLabel.text = "Grade".localized()
                    cell.GradeLabel.text = ProductObject.presentStringForType(serverString: product.type)
                    
                }
                
                cell.cellImage = UIImage(named: "some_handsome_guy")
                
                let thisString = NSMutableAttributedString(string: "TW welly earned 1 Wiz Credit for this data")
                thisString.setColorForText("TW welly", with: DefaultConstants.greenColor)
                cell.userDescriptionLabel.attributedText = thisString
                
                
                return cell
            }
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailsCollectionViewCellMiddle", for: indexPath) as? ProductDetailsCollectionViewCellMiddle
            {
                if let product = passedProductObject
                {
                    cell.FiltrationDescriptionLabel.text = "Filtration".localized()
                    cell.FiltrationLabel.text = ProductObject.presentStringForFilterAndWater(serverString: product.filterWater)
                    
                    cell.PressAndSqueezeDescriptionLabel.text = "Press & Squeeze".localized()
                    cell.PressAndSqueezeLabel.text = ProductObject.presentStringForPressAndSqueeze(serverString: product.pressAndSqueeze)
                    
                    cell.StorageTypeDescriptionLabel.text = "Storage Type".localized()
                    cell.StorageTypeLabel.text = ProductObject.presentStringForPasturizationAndTankStorage(serverString: product.pastorizeTankStorage)
                
                    return cell
                }
            }
            
        case 2:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailsCollectionViewCellEnd", for: indexPath) as? ProductDetailsCollectionViewCellEnd
            {
                if let product = passedProductObject
                {
                    cell.ServingSuggestionsLabel.text = "SUGGESTIONS"
                    cell.ServingSuggestionsTitle.text = "STUFF"
                    
                    return cell
                }
            }
        default:
        return UICollectionViewCell()
        }
        return UICollectionViewCell()
    }
    
    
    private var page = CGFloat()
    private var startingScrollingOffset = CGPoint.zero
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        startingScrollingOffset = scrollView.contentOffset // 1
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // [...]
        
        let cellWidth = collectionView.frame.width * 0.9
        
        let offset = scrollView.contentOffset.x + scrollView.contentInset.left // 2
        let proposedPage = offset / max(1, cellWidth)
        let snapPoint: CGFloat = 0.1
        let snapDelta: CGFloat = offset > startingScrollingOffset.x ? (1 - snapPoint) : snapPoint
        
        if floor(proposedPage + snapDelta) == floor(proposedPage) { // 3
            page = floor(proposedPage) // 4
            self.pageControl.currentPage = Int(page)
        }
        else {
            page = floor(proposedPage + 1) // 5
            self.pageControl.currentPage = Int(page)
        }
        
        targetContentOffset.pointee = CGPoint(
            x: cellWidth * page,
            y: targetContentOffset.pointee.y
        )
    }
    
    
//    func scrollToNearestVisibleCollectionViewCell() {
//        let visibleCenterPositionOfScrollView = Float(collectionView.contentOffset.x + (self.collectionView!.bounds.size.width / 2))
//        var closestCellIndex = -1
//        var closestDistance: Float = .greatestFiniteMagnitude
//        for i in 0..<collectionView.visibleCells.count {
//            let cell = collectionView.visibleCells[i]
//            let cellWidth = cell.bounds.size.width
//            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
//            
//            // Now calculate closest cell
//            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
//            if distance < closestDistance {
//                closestDistance = distance
//                closestCellIndex = collectionView.indexPath(for: cell)!.row
//            }
//        }
//        if closestCellIndex != -1 {
//            self.collectionView!.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
//            //self.collectionViewPageControl.currentPage = closestCellIndex
//        }
//    }
//    
//    //MARK: - ScrollView Delegate
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        if scrollView == collectionView
//        {
//            scrollToNearestVisibleCollectionViewCell()
//        }
//    }
//    
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        if scrollView == collectionView
//        {
//            if !decelerate {
//                scrollToNearestVisibleCollectionViewCell()
//            }
//        }
//    }
    
}

