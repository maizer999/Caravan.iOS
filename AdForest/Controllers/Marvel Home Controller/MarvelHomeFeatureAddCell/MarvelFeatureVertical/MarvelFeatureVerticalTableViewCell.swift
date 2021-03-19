//
//  MarvelFeatureVerticalTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 12/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelFeatureVerticalTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var lblSectionTitle: UILabel!
    
    @IBOutlet weak var heightConstraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isScrollEnabled = false
            collectionView.backgroundColor = UIColor.groupTableViewBackground
            
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.groupTableViewBackground
            contentView.backgroundColor = UIColor.groupTableViewBackground
            containerView.roundCorners()
            
        }
    }
    
    
    
    
       //MARK:- Properties
       var delegate: MarvelAddDetailDelegate?
       var dataArray = [HomeAdd]()
       var fromMultiHome = false
       var day: Int = 0
       var hour: Int = 0
       var minute: Int = 0
       var second: Int = 0
       var serverTime = ""
       var isEndTime = ""
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.width/2 , height:210)
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
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  MarvelFeatureVerticalCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelFeatureVerticalCollectionViewCell", for: indexPath) as! MarvelFeatureVerticalCollectionViewCell
        let objData = dataArray[indexPath.row]
        for item in objData.adImages {
            if let imgUrl = URL(string: item.thumb.encodeUrl()) {
                cell.adImg.sd_setShowActivityIndicatorView(true)
                cell.adImg.sd_setIndicatorStyle(.gray)
                cell.adImg.sd_setImage(with: imgUrl, completed: nil)
                
            }
        }
        if objData.adTimer.isShow {
            cell.futureDate = objData.adTimer.timer
            cell.dayStr = objData.adTimer.timerStrings.days
            cell.hourStr = objData.adTimer.timerStrings.hours
            cell.minStr = objData.adTimer.timerStrings.minutes
            cell.secStr = objData.adTimer.timerStrings.seconds
            cell.lblTimer.isHidden = false
            cell.lblTimer.backgroundColor = UIColor.groupTableViewBackground

        }else{
            cell.lblTimer.isHidden = true
        }
        if let name = objData.adTitle {
            cell.adTitle.text = name

            
        }
        if let location = objData.adLocation.address {
            cell.lblLocation.text = location
        }
        if let price = objData.adPrice.price {
            cell.lblPrice.text = price
        }
        if UserDefaults.standard.bool(forKey: "isRtl") {
            cell.featuredImg.image = UIImage(named: "featured_stars_rtl_round")
        }else{
            cell.featuredImg.image = UIImage(named: "featured_stars_round")
        }

        cell.btnFullAction = { () in
            self.delegate?.goToAddDetail(ad_id: objData.adId)
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
             if collectionView.isDragging {
   
                 cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
                 UIView.animate(withDuration: 0.3, animations: {
                     cell.transform = CGAffineTransform.identity
                 })
             }
         }
    
    
    
    
    
    

}
