//
//  MarvelAdsTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 01/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
protocol MarvelRelatedAddDetailDelegate{
    func goToAddDetail(ad_id : Int)
}
class MarvelAdsTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.groupTableViewBackground
            contentView.backgroundColor = UIColor.groupTableViewBackground
            
        }
    }
    //    @IBOutlet weak var heightConstraintTitle: NSLayoutConstraint!
    
    @IBOutlet weak var heightContraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var oltViewAll: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                oltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblSectionTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isScrollEnabled = false
            collectionView.backgroundColor = UIColor.groupTableViewBackground
            
            
        }
    }
    //MARK:- Properties
    
    var dataArray = [HomeAdd]()
    var delegate : MarvelRelatedAddDetailDelegate?
    var fromMultiHome = false
    
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
        let cell:  MarvelAdsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelAdsCollectionViewCell", for: indexPath) as! MarvelAdsCollectionViewCell
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
            cell.lblTitle.text = name
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
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width:collectionView.frame.width,height: 106)
        
    }
    
    //MARK:- Actions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
    
}
