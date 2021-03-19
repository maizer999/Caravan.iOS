//
//  MarvelHomeFeatureDefaultTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 19/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelHomeFeatureDefaultTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    
    //MARK:- Properties
    var delegate: AddDetailDelegate?
    var dataArray = [HomeAdd]()
    
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var serverTime = ""
    var isEndTime = ""
    var featuredAdLayout: String = UserDefaults.standard.string(forKey: "featuredAdsLayout")!
    var fromMarvelHome = false
    var fromMarvelDefault = false
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        //        self.startTimer()
        self.layoutLatest()
        self.layoutHorizontalSingleAd()
        
    }
    
    //MARK:- Custom
    func startTimer() {
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNextCell() {
        let cellSize = CGSize(width: frame.width, height: frame.height)
        let contentOffset = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
    }
    
    //MARK:- Collection View Delegate Methods
    func layoutHorizontalSingleAd(){
        if featuredAdLayout == "horizental" {
            let layout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.isScrollEnabled = false
            let  height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.reloadData()
        }
    }
    
    func layoutLatest(){
        if featuredAdLayout == "vertical"{
            //    let cellSize = CGSize(width:80 , height:180)
            
            let layout = UICollectionViewFlowLayout()
            //       layout.scrollDirection = .vertical //.horizontal
            //       layout.itemSize = cellSize
            
            //            let width = (view.frame.width-20)/2
            //            let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
            //layout.itemSize = CGSize(width: 334, height: 500)
            layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView.isScrollEnabled = false
            //                let  height = self.collectionView.collectionViewLayout.collectionViewContentSize.height;
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  MarvelHomeFeatureDefaultCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelHomeFeatureDefaultCollectionViewCell", for: indexPath) as! MarvelHomeFeatureDefaultCollectionViewCell
        let objData = dataArray[indexPath.row]
        
        if featuredAdLayout == "horizental" {
            for item in objData.adImages {
                if let imgUrl = URL(string: item.thumb.encodeUrl()) {
                    cell.imageView.sd_setShowActivityIndicatorView(true)
                    cell.imageView.sd_setIndicatorStyle(.gray)
                    cell.imageView.sd_setImage(with: imgUrl, completed: nil)
                }
            }
            
            if let name = objData.adTitle {
                cell.lblTitle.text = name
                if objData.adTimer.isShow {
                    cell.futureDate = objData.adTimer.timer
                    
                    cell.lblTimer.isHidden = true
                    cell.lblBidTimer.isHidden = false
                }else{
                    cell.lblBidTimer.isHidden = true
                }
                
            }
            if let location = objData.adLocation.address {
                cell.lblLocs.text = location
            }
            if let price = objData.adPrice.price {
                cell.lblPriceHori.text = price
            }
            if let featurText = objData.adStatus.featuredTypeText {
                cell.lblFeature.text = featurText
                cell.lblFeature.backgroundColor = Constants.hexStringToUIColor(hex: "#E52D27")
            }
            cell.btnFullAction = { () in
                self.delegate?.goToAddDetail(ad_id: objData.adId)
            }
            
        } else{
            if fromMarvelDefault == true{
                cell.containerView.marvelRoundCorners()
                cell.imgPicture.marvelRoundCorners()
                cell.imgPicture.clipsToBounds = true
                if UserDefaults.standard.bool(forKey: "isRtl") {
                    cell.imgFeatured.featuredRoundCorners(.topLeft, radius: 10)
                    cell.imgFeatured.image = UIImage(named: "featured_stars_rtl_round")
                }else{
                    cell.imgFeatured.featuredRoundCorners(.topRight, radius: 10)
                    cell.imgFeatured.image = UIImage(named: "featured_stars_round")

                }
            }
            for images in objData.adImages {
                if let imgUrl = URL(string: images.thumb.encodeUrl()) {
                    cell.imgPicture.sd_setShowActivityIndicatorView(true)
                    cell.imgPicture.sd_setIndicatorStyle(.gray)
                    cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                }
            }
            if let name = objData.adTitle {
                cell.lblName.text = name
                if objData.adTimer.isShow {
                    cell.futureDate = objData.adTimer.timer
                    
                    cell.lblTimer.isHidden = false
                }else{
                    cell.lblTimer.isHidden = true
                }
            }
            
            if let location = objData.adLocation.address {
                cell.lblLocation.text = location
            }
            if let price = objData.adPrice.price {
                cell.lblPrice.text = price
            }
            cell.btnFullAction = { () in
                self.delegate?.goToAddDetail(ad_id: objData.adId)
            }
            if objData.adTimer.isShow {
                cell.futureDate = objData.adTimer.timer
                cell.lblTimer.isHidden = false
                
            }else{
                cell.lblTimer.isHidden = true
            }
        }
        
        return cell
    }
    func validateIFSC(code : String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Za-z]{4}0.{6}$")
        return regex.numberOfMatches(in: code, range: NSRange(code.startIndex..., in: code)) == 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if featuredAdLayout == "vertical" {
            return CGSize(width:collectionView.frame.width/2 , height:210)
        }else if featuredAdLayout == "horizental" {
            return CGSize(width:collectionView.frame.width , height: 122)
        }
        else{
            return CGSize(width: 170, height: 210)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
                self.collectionView.decelerationRate = 0.5
                
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
