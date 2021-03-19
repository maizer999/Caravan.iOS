//
//  MultiAdsTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 13/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MultiAdsTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {

    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            
            
        }
    }
    @IBOutlet weak var oltViewAll: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var heightConstraintMultiSliderAds: NSLayoutConstraint!
    @IBOutlet weak var lblSectionTitle: UILabel!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.clear
            
        }
    }
    //MARK:- Properties
    
    var dataArray = [HomeAdd]()
    var delegate : MarvelRelatedAddDetailDelegate?
    
    
    var btnViewAll :(()->())?
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //        self.setupViews()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
   
    
   
    
    //MARK:- Custom
    
    func reloadData() {
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  MultiAdsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiAdsCollectionViewCell", for: indexPath) as! MultiAdsCollectionViewCell
        let objData = dataArray[indexPath.row]
        for item in objData.adImages {
            if let imgUrl = URL(string: item.thumb.encodeUrl()) {
                cell.imgAd.sd_setShowActivityIndicatorView(true)
                cell.imgAd.sd_setIndicatorStyle(.gray)
                cell.imgAd.sd_setImage(with: imgUrl, completed: nil)
                
            }
        }
        if objData.adTimer.isShow {
            cell.futureDate = objData.adTimer.timer
            cell.dayStr = objData.adTimer.timerStrings.days
            cell.hourStr = objData.adTimer.timerStrings.hours
            cell.minStr = objData.adTimer.timerStrings.minutes
            cell.secStr = objData.adTimer.timerStrings.seconds
            cell.lblTimer.isHidden = false
        }else{
            cell.lblTimer.isHidden = true
        }
        if let name = objData.adTitle {
            cell.lblTitle.text = name
        }
        if let location = objData.adLocation.address {
            cell.lblLocation.text = location
        }
        if let priceType = objData.adPrice.priceType {
            cell.lblPriceType.text = priceType
        }
        if let price = objData.adPrice.price {
            cell.lblPrice.text = price
        }
        if let adCatName = objData.adCatsName {
            cell.lblCatName.text = adCatName
        }
        cell.btnFullAction = { () in
            self.delegate?.goToAddDetail(ad_id: objData.adId)
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:292,height: 210)
        
    }
    
    //MARK:- Actions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
    
}
