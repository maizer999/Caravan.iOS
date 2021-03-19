//
//  MarvelCategoryTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 27/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol MarvelCategoryDetailDelegate {
    func goToCategoryDetail(id: Int)
    func goToSubCategoryDetail(id:Int,hasChild:Bool )
}

class MarvelCategoryTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var lblCatsHeading: UILabel!
    @IBOutlet weak var btnViewAllCats: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                btnViewAllCats.backgroundColor = UIColor.clear
                    //Constants.hexStringToUIColor(hex: mainColor)
                btnViewAllCats.setTitleColor(Constants.hexStringToUIColor(hex: mainColor), for: .normal)
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            if Constants.isiPadDevice {
                collectionView.isScrollEnabled = true
                collectionView.showsHorizontalScrollIndicator = false
            }else {
                collectionView.showsHorizontalScrollIndicator = false
                collectionView.isScrollEnabled = true
            }
            if Constants.isiPadDevice {
                if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
                    layout.scrollDirection = .horizontal
                }
            }
        }
    }
    @IBOutlet weak var ContainerView: UIView!
    
    
    //MARK:- Properties
    var categoryArray = [CatIcon]()
    var delegate : MarvelCategoryDetailDelegate?
    var btnViewAll: (()->())?
    
    
    
    //MARK:- Properties
    var dataArray = [LocationDetailTerm]()
    var currentPage = 0
    var maximumPage = 0
    var searchController = UISearchController(searchResultsController: nil)
    var filteredArray = [LocationDetailTerm]()
    var shouldShowSearchResults = false
    var termId = 0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if UserDefaults.standard.bool(forKey: "isRtl") {
            lblCatsHeading.textAlignment = .right
        }else{
            lblCatsHeading.textAlignment = .left
            
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    //MARK:- Delegate Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MarvelCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelCategoryCollectionViewCell", for: indexPath) as! MarvelCategoryCollectionViewCell
        let objData = categoryArray[indexPath.row]
        
        if let name = objData.name {
            cell.lblName.text = name
        }
        if let imgUrl = URL(string: objData.img.encodeUrl()) {
            cell.imgPicture.sd_setShowActivityIndicatorView(true)
            cell.imgPicture.sd_setIndicatorStyle(.gray)
            cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
        }
        cell.btnFullAction = { () in
            if objData.hasSub == true {
                self.delegate?.goToSubCategoryDetail(id: objData.catId, hasChild: objData.hasSub)

            }
            else{
                self.delegate?.goToCategoryDetail(id:objData.catId)

            }
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            //            UIView.animate(withDuration: 0.5, delay: 0.5 * Double(indexPath.row), usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: indexPath.row % 2 == 0 ? .transitionFlipFromLeft : .transitionFlipFromRight, animations: {
            //
            ////                if indexPath.row % 2 == 0 {
            ////                    AnimationUtility.viewSlideInFromLeft(toRight: cell)
            ////                }
            ////                else {
            //                    AnimationUtility.viewSlideInFromRight(toLeft: cell)
            ////                }
            //
            //            }, completion: { (done) in
            //            })
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let width = collectionView.frame.size.width
////        return CGSize(width: width, height: 115)
//    }
    //MARK:- IBActions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }


    
}
class AnimationUtility: UIViewController, CAAnimationDelegate {
    
    static let kSlideAnimationDuration: CFTimeInterval = 0.4
    
    static func viewSlideInFromRight(toLeft views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition?.type = kCATransitionPush
        transition?.subtype = kCATransitionFromRight
        //        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }
    
    static func viewSlideInFromLeft(toRight views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition?.type = kCATransitionPush
        transition?.subtype = kCATransitionFromLeft
        //        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }
    
    static func viewSlideInFromTop(toBottom views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition?.type = kCATransitionPush
        transition?.subtype = kCATransitionFromBottom
        //        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }
    
    static func viewSlideInFromBottom(toTop views: UIView) {
        var transition: CATransition? = nil
        transition = CATransition.init()
        transition?.duration = kSlideAnimationDuration
        transition?.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition?.type = kCATransitionPush
        transition?.subtype = kCATransitionFromTop
        //        transition?.delegate = (self as! CAAnimationDelegate)
        views.layer.add(transition!, forKey: nil)
    }
}
