//
//  MultiLatestAdTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 13/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MultiLatestAdTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var heightconstraintLatestAd: NSLayoutConstraint!
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
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.clear
            
        }
    }
    
    //MARK:- Properties
    var delegate : MarvelLatestAddDetailDelegate?
    var dataArray = [HomeAdd]()
    var btnViewAll: (()->())?
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var serverTime = ""
    var isEndTime = ""
    
    var height : CGFloat = 0.0
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MultiLatestAdCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiLatestAdCollectionViewCell", for: indexPath) as! MultiLatestAdCollectionViewCell
        let objData = dataArray[indexPath.row]
        for item in objData.adImages {
            if let imgUrl = URL(string: item.thumb.encodeUrl()) {
                cell.imgAD.sd_setShowActivityIndicatorView(true)
                cell.imgAD.sd_setIndicatorStyle(.gray)
                cell.imgAD.sd_setImage(with: imgUrl, completed: nil)
                
            }
        }
        
        if let name = objData.adTitle {
            cell.lblTitle.text = name
            
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
        
        if let location = objData.adLocation.address {
            cell.lblLocation.text = location
        }
        if let price = objData.adPrice.price {
            cell.lblprice.text = price
        }
        if let priceType = objData.adPrice.priceType {
            cell.lblPriceType.text = priceType
        }
        if let adCatName = objData.adCatsName{
            cell.lblCatName.text = adCatName
        }
        cell.btnFullAction = { () in
            self.delegate?.goToAddDetail(ad_id: objData.adId)
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:292,height: 202)
    }
    //MARK:- Actions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }

}
