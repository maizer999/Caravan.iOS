//
//  MarvelVerticalSLiderAdsTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 14/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelVerticalSLiderAdsTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    @IBOutlet weak var OltViewAll: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                OltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblSectionTitle: UILabel!
    @IBOutlet weak var heightConstaraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isScrollEnabled = false
            collectionView.backgroundColor = UIColor.groupTableViewBackground
            
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.backgroundColor = UIColor.groupTableViewBackground
            contentView.backgroundColor = UIColor.groupTableViewBackground
            
        }
    }
    
    //MARK:- Properties
    
    var dataArray = [HomeAdd]()
    var delegate : MarvelRelatedAddDetailDelegate?
    var btnViewAll :(()->())?
    var fromMultiHome = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func reloadData() {
        collectionView.reloadData()
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: MarvelVerticalSLiderAdsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelVerticalSLiderAdsCollectionViewCell", for: indexPath) as! MarvelVerticalSLiderAdsCollectionViewCell
        let objData = dataArray[indexPath.row]
        for item in objData.adImages {
            if let imgUrl = URL(string: item.thumb.encodeUrl()) {
                cell.adImg.sd_setShowActivityIndicatorView(true)
                cell.adImg.sd_setIndicatorStyle(.gray)
                cell.adImg.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        
        if let name = objData.adTitle {
            cell.adTitle.text = name
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
    func validateIFSC(code : String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Za-z]{4}0.{6}$")
        return regex.numberOfMatches(in: code, range: NSRange(code.startIndex..., in: code)) == 1
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
                
            })
        }
    }
    
    
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
}
