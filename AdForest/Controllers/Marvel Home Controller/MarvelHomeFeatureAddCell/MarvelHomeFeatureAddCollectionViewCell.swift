//
//  MarvelHomeFeatureAddCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 28/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelHomeFeatureAddCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblFeatured: UILabel!
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
        
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var adImg: UIImageView!{
        didSet{
            adImg.marvelRoundCorners()
            
        }
        
    }
    
    
    @IBOutlet weak var lblTimer: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblTimer.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var btnViewAd: UIButton!
    @IBOutlet weak var locationIcon: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                locationIcon.image = locationIcon.image?.withRenderingMode(.alwaysTemplate)
                locationIcon.tintColor = UIColor(hex: mainColor)
                
                
            }
            
        }
        
    }
    
    @IBOutlet weak var featuredStarImg: UIImageView!
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            //            containerView.backgroundColor = UIColor.clear
            containerView.addShadowToView()
            containerView.marvelRoundCorners()
            
            
        }
    }
    
    var futureDate = ""
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var isEndTime = ""

    var hourStr = ""
    var minStr = ""
    var secStr = ""
    var dayStr = ""

    override func awakeFromNib() {
           super.awakeFromNib()
        if UserDefaults.standard.bool(forKey: "isRtl") {
            lblTitle.textAlignment = .right
            lblLocation.textAlignment = .right
            lblPrice.textAlignment = .right
            featuredStarImg.featuredRoundCorners(.topLeft, radius: 5)

        }
        else{
            lblTitle.textAlignment = .left
            lblLocation.textAlignment = .left
            lblPrice.textAlignment = .left
            featuredStarImg.featuredRoundCorners(.topRight, radius: 5)

        }
           Timer.every(1.second) {
               self.countDown(date: self.futureDate)
               self.lblTimer.text = "\(self.day)\(self.dayStr):\(self.hour)\(self.hourStr):\(self.minute)\(self.minStr):\(self.second)\(self.secStr)"
           }
       }
       
       //MARK:- Counter
       func countDown(date: String) {
           
           let calendar = Calendar.current
           let requestComponents = Set<Calendar.Component>([.year, .month, .day, .hour, .minute, .second, .nanosecond])
           let dateFormatter = DateFormatter()
           dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
           let timeNow = Date()
           guard let dateis = dateFormatter.date(from: date) else {
               return
           }
           let timeDifference = calendar.dateComponents(requestComponents, from: timeNow, to: dateis)
           day = timeDifference.day!
           hour = timeDifference.hour!
           minute = timeDifference.minute!
           second = timeDifference.second!
           
       }
   
    var btnFullAction: (()->())?
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
    
  
}

    
