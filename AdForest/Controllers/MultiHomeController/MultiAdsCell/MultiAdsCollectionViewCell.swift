//
//  MultiAdsCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 13/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MultiAdsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblPriceType: UILabel!
    @IBOutlet weak var lblCatName: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblCatName.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var imgLocation: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                imgLocation.image = imgLocation.image?.withRenderingMode(.alwaysTemplate)
                imgLocation.tintColor = UIColor(hex: mainColor)
                
                
            }
        }
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTimer: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblTimer.textColor = UIColor.white
                    //Constants.hexStringToUIColor(hex: mainColor)

            }
        }
    }
    @IBOutlet weak var imgAd: UIImageView!{
        didSet{
            imgAd.marvelRoundCorners()
            imgAd.clipsToBounds = true
        }
    }
    @IBOutlet weak var containerView: UIView!{
        didSet{
            containerView.addShadowToView()
            containerView.marvelRoundCorners()
        }
    }
    @IBOutlet weak var btnViewAll: UIButton!
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
    var btnFullAction: (()->())?
    
    
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDefaults.standard.bool(forKey: "isRtl") {
            lblTitle.textAlignment = .right
            lblLocation.textAlignment = .right
            lblTimer.featuredRoundCorners([.bottomRight], radius: 10)
            lblCatName.textAlignment = .right
        }
        else{
            lblTitle.textAlignment = .left
            lblTimer.featuredRoundCorners([.bottomLeft], radius: 10)
            lblLocation.textAlignment = .left
            lblCatName.textAlignment = .left

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
}


