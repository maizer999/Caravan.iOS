//
//  MultiHomeFeatureAddTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 12/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MultiHomeFeatureAddTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
        }
    }
    @IBOutlet weak var lblSectionTitle: UILabel!
    
    @IBOutlet weak var containerView: UIView!{
        didSet {
            containerView.backgroundColor = UIColor.clear
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
    var latestVertical = "vertical"
        //String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var latestHorizontalSingleAd = "horizental"
        //String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    let featureTime = UserDefaults.standard.string(forKey: "featuredTime")
    let featureLoop = UserDefaults.standard.string(forKey: "featuredLoop")
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.startTimer()
        
    }
    
    //MARK:- Custom
    func startTimer() {
        let myInt1 = Double(featureLoop!)
        print(myInt1!)
        Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
    @objc func scrollToNextCell() {
        let cellSize = CGSize(width: frame.width, height: frame.height)
        let contentOffset = collectionView.contentOffset
        collectionView.scrollRectToVisible(CGRect(x: contentOffset.x + cellSize.width, y: contentOffset.y, width: cellSize.width, height: cellSize.height), animated: true)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:  MultiHomeFeatureAddCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiHomeFeatureAddCollectionViewCell", for: indexPath) as! MultiHomeFeatureAddCollectionViewCell
        let objData = dataArray[indexPath.row]
        for images in objData.adImages {
            if let imgUrl = URL(string: images.thumb.encodeUrl()) {
                cell.imgAd.sd_setShowActivityIndicatorView(true)
                cell.imgAd.sd_setIndicatorStyle(.gray)
                cell.imgAd.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        if let name = objData.adTitle {
            cell.lblTitle.text = name
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
        if let priceType = objData.adPrice.priceType {
            cell.lblPriceType.text = priceType
        }
        if let adCatsName = objData.adCatsName {
            cell.lblAdCatName.text = adCatsName
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
        
        
        return cell
    }
    func validateIFSC(code : String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Za-z]{4}0.{6}$")
        return regex.numberOfMatches(in: code, range: NSRange(code.startIndex..., in: code)) == 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 292, height: 210)
        
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
