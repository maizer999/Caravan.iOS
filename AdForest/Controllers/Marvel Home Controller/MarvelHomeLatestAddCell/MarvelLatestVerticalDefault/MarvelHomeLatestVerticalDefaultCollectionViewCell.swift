//
//  MarvelHomeLatestVerticalDefaultCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 11/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
protocol MarvelDefVerAddDetailDelegate{
    func goToAddDetail(ad_id : Int)
}
class MarvelHomeLatestVerticalDefaultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.marveladdShadowToView()
        }
    }
    
    @IBOutlet weak var adImg: UIImageView!{
        didSet{
            adImg.marvelRoundCorners()
            adImg.clipsToBounds = true
            
        }
    }
    
    @IBOutlet weak var adTitle: UILabel!
    
    @IBOutlet weak var lbllocation: UILabel!
    
    @IBOutlet weak var imglocation: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                imglocation.image = imglocation.image?.withRenderingMode(.alwaysTemplate)
                imglocation.tintColor = UIColor(hex: mainColor)
            }
        }
    }
    
    
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    
    @IBOutlet weak var lblTimer: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                lblTimer.textColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var btnViewAll: UIButton!
    
    
    var futureDate = ""
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var isEndTime = ""
    
    var dayStr = ""
    var hourStr = ""
    var minStr = ""
    var secStr = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UserDefaults.standard.bool(forKey: "isRtl") {
            lblPrice.textAlignment = .right
            lbllocation.textAlignment = .right
            adTitle.textAlignment = .right

        } else {
            lblPrice.textAlignment = .left
            lbllocation.textAlignment = .left
            adTitle.textAlignment = .left

            
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
