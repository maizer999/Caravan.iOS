//
//  MarvelHomeLatestAddTableCell.swift
//  AdForest
//
//  Created by Charlie on 01/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
protocol MarvelLatestAddDetailDelegate{
    func goToAddDetail(ad_id : Int)
}


class MarvelHomeLatestAddTableCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    
    @IBOutlet weak var heightConstraintCollectionView: NSLayoutConstraint!
    @IBOutlet weak var OltViewAll: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                OltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.backgroundColor = UIColor.groupTableViewBackground
            contentView.backgroundColor = UIColor.groupTableViewBackground
            containerView.marvelRoundCorners()
            
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
    var delegate : MarvelLatestAddDetailDelegate?
    var dataArray = [HomeAdd]()
    var btnViewAll: (()->())?
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var serverTime = ""
    var isEndTime = ""
    var latestVertical = "vertical"
        //String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var latestHorizontalSingleAd = "horizental"
        //String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    
    var height : CGFloat = 0.0
    var fromMultiHome = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MarvelHomeLatestAddCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MarvelHomeLatestAddCollectionViewCell", for: indexPath) as! MarvelHomeLatestAddCollectionViewCell
        let objData = dataArray[indexPath.row]
        for item in objData.adImages {
            if let imgUrl = URL(string: item.thumb.encodeUrl()) {
                cell.adImg.sd_setShowActivityIndicatorView(true)
                cell.adImg.sd_setIndicatorStyle(.gray)
                cell.adImg.sd_setImage(with: imgUrl, completed: nil)
                
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

            cell.lblTimer.backgroundColor = UIColor.groupTableViewBackground

            cell.lblTimer.isHidden = false
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width,height: 110)
    }
    //MARK:- Actions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
}
