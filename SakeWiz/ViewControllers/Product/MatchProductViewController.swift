//
//  MatchProductViewController.swift
//  SakeWiz
//
//  Created by welly, TW on 2017/06/19.
//  Copyright © 2017 TW welly. All rights reserved.
//

import UIKit
import Kingfisher
import EZLoadingActivity

class MatchProductViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {

    
    var starRating:Double = 0
    {
        didSet {
        
            switch starRating {
            case  0..<0.5:
                starImage1.image = UIImage(named: "star_icon_gray")
                starImage2.image = UIImage(named: "star_icon_gray")
                starImage3.image = UIImage(named: "star_icon_gray")
                starImage4.image = UIImage(named: "star_icon_gray")
                starImage5.image = UIImage(named: "star_icon_gray")
            
            case 0.5..<1:
                starImage1.image = UIImage(named: "half_star_yellow")
                starImage2.image = UIImage(named: "star_icon_gray")
                starImage3.image = UIImage(named: "star_icon_gray")
                starImage4.image = UIImage(named: "star_icon_gray")
                starImage5.image = UIImage(named: "star_icon_gray")
                
            case 1..<1.5:
                starImage1.image = UIImage(named: "star_icon_yellow")
                starImage2.image = UIImage(named: "star_icon_gray")
                starImage3.image = UIImage(named: "star_icon_gray")
                starImage4.image = UIImage(named: "star_icon_gray")
                starImage5.image = UIImage(named: "star_icon_gray")
                
            case 1.5..<2:
                starImage1.image = UIImage(named: "star_icon_yellow")
                starImage2.image = UIImage(named: "half_star_yellow")
                starImage3.image = UIImage(named: "star_icon_gray")
                starImage4.image = UIImage(named: "star_icon_gray")
                starImage5.image = UIImage(named: "star_icon_gray")
            case 2..<2.5:
                starImage1.image = UIImage(named: "star_icon_yellow")
                starImage2.image = UIImage(named: "star_icon_yellow")
                starImage3.image = UIImage(named: "star_icon_gray")
                starImage4.image = UIImage(named: "star_icon_gray")
                starImage5.image = UIImage(named: "star_icon_gray")
                
            case 2.5..<3:
                starImage1.image = UIImage(named: "star_icon_yellow")
                starImage2.image = UIImage(named: "star_icon_yellow")
                starImage3.image = UIImage(named: "half_star_yellow")
                starImage4.image = UIImage(named: "star_icon_gray")
                starImage5.image = UIImage(named: "star_icon_gray")
                
            case 3..<3.5:
                starImage1.image = UIImage(named: "star_icon_yellow")
                starImage2.image = UIImage(named: "star_icon_yellow")
                starImage3.image = UIImage(named: "star_icon_yellow")
                starImage4.image = UIImage(named: "star_icon_gray")
                starImage5.image = UIImage(named: "star_icon_gray")
                
            case 3.5..<4:
                starImage1.image = UIImage(named: "star_icon_yellow")
                starImage2.image = UIImage(named: "star_icon_yellow")
                starImage3.image = UIImage(named: "star_icon_yellow")
                starImage4.image = UIImage(named: "half_star_yellow")
                starImage5.image = UIImage(named: "star_icon_gray")
                
            case 4..<4.5:
                starImage1.image = UIImage(named: "star_icon_yellow")
                starImage2.image = UIImage(named: "star_icon_yellow")
                starImage3.image = UIImage(named: "star_icon_yellow")
                starImage4.image = UIImage(named: "star_icon_yellow")
                starImage5.image = UIImage(named: "star_icon_gray")
                
            case 4.5..<5:
                starImage1.image = UIImage(named: "star_icon_yellow")
                starImage2.image = UIImage(named: "star_icon_yellow")
                starImage3.image = UIImage(named: "star_icon_yellow")
                starImage4.image = UIImage(named: "star_icon_yellow")
                starImage5.image = UIImage(named: "half_star_yellow")
                
            case 5..<Double.greatestFiniteMagnitude:
                starImage1.image = UIImage(named: "star_icon_yellow")
                starImage2.image = UIImage(named: "star_icon_yellow")
                starImage3.image = UIImage(named: "star_icon_yellow")
                starImage4.image = UIImage(named: "star_icon_yellow")
                starImage5.image = UIImage(named: "star_icon_yellow")
            default:
                starImage1.image = UIImage(named: "star_icon_gray")
                starImage2.image = UIImage(named: "star_icon_gray")
                starImage3.image = UIImage(named: "star_icon_gray")
                starImage4.image = UIImage(named: "star_icon_gray")
                starImage5.image = UIImage(named: "star_icon_gray")
            }
        
        }
    }
    
    var passedScanID: String = ""
    
    var matchedProductString: String? = nil
    
    var currentProductIndex = 0
    
    var currentProductObject: ProductObject = ProductObject(){
    
        didSet{
            
            print("did set")
            
            if let url = URL(string: currentProductObject.mainImageURLString)
            {
                print(url)
                SakeImageView.kf.setImage(with: url, placeholder: UIImage(named: "screenshot_avatar"), options: nil, progressBlock: nil, completionHandler: {completion in
                    
                    
                    if completion.1 != nil
                    {
                        print("KingFisher Fetch Error: \(String(describing: completion.1))")
                    }
                    
                })
                
            }
            
            self.starRating = currentProductObject.rating
            self.ratingsLabel.text = "\(currentProductObject.rating) " + "rating".localized()
            
            self.SakeNameLabel.text = ProductObject.currentNameForDic(productDic: currentProductObject.sakeNameDic)
            
            if let breweryNameDic = currentProductObject.breweryName
            {
                self.BreweryNameLabel.text = ProductObject.currentNameForDic(productDic: breweryNameDic)
            }
            else
            {
                self.BreweryNameLabel.text = ""
            }
            
            collectionView.reloadData()
        
        }
    
    }
    
    
    // MARK: - Views Outlets
    
    @IBOutlet weak var sakeBackgroundView: UIView!
    @IBOutlet weak var ProductView: UIView!
    
    @IBOutlet weak var SakeImageView: UIImageView!
    @IBOutlet weak var SakeNameLabel: UILabel!
    @IBOutlet weak var BreweryNameLabel: UILabel!
    
    @IBOutlet weak var ratingsLabel: UILabel!

    @IBOutlet weak var starImage1: UIImageView!
    @IBOutlet weak var starImage2: UIImageView!
    @IBOutlet weak var starImage3: UIImageView!
    @IBOutlet weak var starImage4: UIImageView!
    @IBOutlet weak var starImage5: UIImageView!

    // MARK - FAV things Outlets
    

    
    
    // MARK - Toolbar Outlets
    @IBOutlet weak var notesView: UIView!
    @IBOutlet weak var notesLabel: UILabel!
    @IBOutlet weak var notesImageView: UIImageView!
    
    
    
    @IBOutlet weak var chartsView: UIView!
    @IBOutlet weak var chartsLabel: UILabel!
    @IBOutlet weak var chartsImageView: UIImageView!
    
    
    @IBOutlet weak var favoritesView: UIView!
    @IBOutlet weak var favoritesImageView: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    
    @IBAction func favoritesButtonAction(_ sender: UIButton) {
        
        
    }
    
    
    // MARK - Buttons
    @IBAction func NotAMatchButtonAction(_ sender: UIButton) {

        
    }
    
    
    var canMatch = true
    @IBAction func MatchButtonAction(_ sender: UIButton) {
        
        canMatch = false
        
        API.Match.reportMatchWith(scanID: passedScanID, productID: currentProductObject.id, completionHandler: {[weak self] in
        
            self?.canMatch = true
        
            }, failure: {errorMessage in print(errorMessage as Any)})
        
        self.performSegue(withIdentifier: "ToProductDetails", sender: self)
        
    }
    
    // MARK - CollectionView Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.sakeBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        

        if let productString = matchedProductString
        {
        
            print("getting from matched Products")
            API.getProductDetailsBy(ID: productString, completionHandler: {[weak self] product in
                
                print("returned")
                self?.currentProductObject = product
                
                }, failure: {[weak self] errorMessage in
            
                    print(errorMessage as Any)
            })
        }

        
        collectionView.register(UINib(nibName: "ProductDetailsCollectionViewCellTop", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCollectionViewCellTop")
        collectionView.register(UINib(nibName: "ProductDetailsCollectionViewCellMiddle", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCollectionViewCellMiddle")
        collectionView.register(UINib(nibName: "ProductDetailsCollectionViewCellEnd", bundle: nil), forCellWithReuseIdentifier: "ProductDetailsCollectionViewCellEnd")
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
        
        if let destinationVC = segue.destination as? ProductDetailsViewController
        {
            destinationVC.passedProductObject = self.currentProductObject
        }
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width * 0.9, height: collectionView.frame.height )
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HorizontalGraphCollectionViewCell", for: indexPath) as! HorizontalGraphCollectionViewCell
        
        switch indexPath.row
        {
        case 0:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailsCollectionViewCellTop", for: indexPath) as? ProductDetailsCollectionViewCellTop
            {

                    cell.CountryDescriptionLabel.text = "Country".localized()
                    cell.CountryLabel.text = ProductObject.currentNameForDic(productDic: currentProductObject.countryDic)
                    
                    cell.RegionDescriptionLabel.text = "Region".localized()
                    cell.RegionLabel.text = ProductObject.currentNameForDic(productDic: currentProductObject.regionDic)
                    
                    cell.SMVDescriptionLabel.text = "SMV".localized()
                    if currentProductObject.smv > 0
                    {
                        cell.SMVLabel.text = "+\(currentProductObject.smv)"
                    }
                    else
                    {
                        cell.SMVLabel.text = "\(currentProductObject.smv)"
                    }
                    
                    cell.PolishRateDescriptionLabel.text = "Polish Rate".localized()
                    cell.PolishRateLabel.text = "\(currentProductObject.kakeRatio)%"
                    
                    cell.AlchoholContentDescriptionLabel.text = "Alcohol Content".localized()
                    cell.AlchoholContentLabel.text = currentProductObject.alcPerc + "%"
                    
                    cell.ByDescriptionLabel.text = "By".localized()
                    cell.ByLabel.text = String(currentProductObject.brewYear)
                    
                    cell.GradeDescriptionLabel.text = "Grade".localized()
                    cell.GradeLabel.text = ProductObject.presentStringForType(serverString: currentProductObject.type)
                
                
                cell.cellImage = UIImage(named: "some_handsome_guy")
                
                let thisString = NSMutableAttributedString(string: "TW welly earned 1 Wiz Credit for this data")
                thisString.setColorForText("TW welly", with: DefaultConstants.greenColor)
                cell.userDescriptionLabel.attributedText = thisString
                
                
                return cell
            }
        case 1:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailsCollectionViewCellMiddle", for: indexPath) as? ProductDetailsCollectionViewCellMiddle
            {
                    cell.FiltrationDescriptionLabel.text = "Filtration".localized()
                    cell.FiltrationLabel.text = ProductObject.presentStringForFilterAndWater(serverString: currentProductObject.filterWater)
                    
                    cell.PressAndSqueezeDescriptionLabel.text = "Press & Squeeze".localized()
                    cell.PressAndSqueezeLabel.text = ProductObject.presentStringForPressAndSqueeze(serverString: currentProductObject.pressAndSqueeze)
                    
                    cell.StorageTypeDescriptionLabel.text = "Storage Type".localized()
                    cell.StorageTypeLabel.text = ProductObject.presentStringForPasturizationAndTankStorage(serverString: currentProductObject.pastorizeTankStorage)
                    
                    return cell
            }
            
        case 2:
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductDetailsCollectionViewCellEnd", for: indexPath) as? ProductDetailsCollectionViewCellEnd
            {

                    cell.ServingSuggestionsLabel.text = "SUGGESTIONS"
                    cell.ServingSuggestionsTitle.text = "STUFF"
                    
                    return cell

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
