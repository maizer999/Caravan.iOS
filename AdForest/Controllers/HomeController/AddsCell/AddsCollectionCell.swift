//
//  AddsCollectionCell.swift
//  AdForest
//
//  Created by apple on 4/17/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class AddsCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var lblTimer: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPrice: UILabel! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    //MARK:- Properties
    var btnFullAction: (()->())?
//    var sliderAdsLayout: String = UserDefaults.standard.string(forKey: "sliderAdsLayout")!
//    var nearbyAdLayout: String = UserDefaults.standard.string(forKey: "nearByAdsLayout")!
    var latestHorizontalSingleAd: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var  imageView: UIImageView!
    var  imageViewLoc: UIImageView!
    var lblTitle: UILabel!
    var lblLocs: UILabel!
    var lblPriceHori: UILabel!
    var lblBidTimer: UILabel!
    //MARK:- IBActions
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDefaults.standard.bool(forKey: "isRtl") {
            lblName.textAlignment = .right
        } else {
            lblName.textAlignment = .left
        }
        if latestHorizontalSingleAd  == "horizental" {
            //            containerView.backgroundColor = UIColor.systemRed
            imgPicture.isHidden = true
            lblName.isHidden = true
            lblLocation.isHidden = true
            lblPrice.isHidden = true
            lblTimer.isHidden = true
            let imageName = "appLogo"
            let image = UIImage(named: imageName)
            imageView = UIImageView(image: image!)
            imageView.frame = CGRect(x: 2, y: 5, width: 110, height: 110)
            contentView.addSubview(imageView)
            lblBidTimer = UILabel(frame: CGRect(x: 2, y: 5, width: 100, height: 28))
            lblBidTimer.textAlignment = .center
            lblBidTimer.textColor = UIColor.white
            //            lblBidTimer.text = "Bid Timer"
            lblBidTimer.backgroundColor = Constants.hexStringToUIColor(hex: "#575757")
            //bottomalign label
            //            lblBidTimer.frame.origin.x = 0
            lblBidTimer.frame.origin.y = 59 + lblBidTimer.frame.height
            //
            //            lblBidTimer.frame.origin.x = imageView.frame.width + 18
            //            lblBidTimer.frame.origin.y = -8 + lblBidTimer.frame.height
            
            
            lblBidTimer.font = UIFont(name:"HelveticaNeue-Bold", size: 13.0)
            
            contentView.addSubview(lblBidTimer)
            lblTitle = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 28))
            lblTitle.textAlignment = .left
            lblTitle.textColor = UIColor.black
            lblTitle.text = "Ad Title"
            
            //bottomalign label
            lblTitle.frame.origin.x = imageView.frame.width + 18
            lblTitle.frame.origin.y = -8 + lblTitle.frame.height
            lblTitle.font = UIFont(name:"HelveticaNeue-Bold", size: 15.0)
            
            //imageView.frame.height
            //top right with x = 0
            //            label.frame.origin.y = 30
            //            label.frame.origin.x = imageView.frame.width - label.frame.width
            contentView.addSubview(lblTitle)
            let imageNameLoc = "location"
            let imageLoc = UIImage(named: imageNameLoc)
            imageViewLoc = UIImageView(image: imageLoc!)
            imageViewLoc.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            imageViewLoc.frame.origin.y = 58
            imageViewLoc.frame.origin.x = lblLocation.frame.width + (imageViewLoc.frame.width)
            contentView.addSubview(imageViewLoc)
            lblLocs = UILabel(frame: CGRect(x: 0, y: 0, width: 210, height: 28))
            lblLocs.textAlignment = .left
            //                        lblLocation.backgroundColor = UIColor.blue
            lblLocs.textColor = UIColor.lightGray
            lblLocs.font = lblLocs.font.withSize(15)
            lblLocs.center.x = lblTitle.center.x - 3
            lblLocs.numberOfLines = 2
            lblLocs.frame.origin.y = lblTitle.frame.origin.y + (lblLocs.frame.height) + 6
            lblLocs.text = "Model Town Link Road Lahore Punjab Pakistan"
            contentView.addSubview(lblLocs)
            
            lblPriceHori = UILabel(frame: CGRect(x: 0, y: 0, width: 250, height: 28))
            lblPriceHori.textAlignment = .left
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblPriceHori.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
            
            lblPriceHori.center.x = lblTitle.center.x - 3
            lblPriceHori.frame.origin.y = imageViewLoc.frame.origin.y + (lblPriceHori.frame.height) - 10
            lblPriceHori.text = "$-223"
            contentView.addSubview(lblPriceHori)
            
            
        }
        
        
        
        
    }
    
}
