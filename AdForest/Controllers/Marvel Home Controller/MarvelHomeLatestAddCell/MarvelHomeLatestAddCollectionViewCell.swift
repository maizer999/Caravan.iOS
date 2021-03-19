//
//  MarvelHomeLatestAddCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 01/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelHomeLatestAddCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblPrice: UILabel!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                lblPrice.textColor = Constants.hexStringToUIColor(hex: mainColor)
                
            }
        }
    }
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var locationIcon: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                locationIcon.image = locationIcon.image?.withRenderingMode(.alwaysTemplate)
                locationIcon.tintColor = UIColor(hex: mainColor)
                
                
            }
            
        }
        
    }
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
                lblTimer.featuredRoundCorners([.bottomLeft], radius: 10)

            }
        }
    }
    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.addShadowToView()
            cellView.marvelRoundCorners()
        }
    }
    
    
    @IBOutlet weak var btnViewAll: UIButton!
    var btnFullAction: (()->())?
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
            lblTitle.textAlignment = .right
            lblLocation.textAlignment = .right
            lblPrice.textAlignment = .right
        }
        else{
            lblTitle.textAlignment = .left
            lblLocation.textAlignment = .left
            lblPrice.textAlignment = .left

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
    
    
    
    
    @IBAction func actionFullButton(_ sender: Any) {
        self.btnFullAction?()
    }
    
    
    
    
    
}
extension UILabel {
    public func featuredRoundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let maskPath = UIBezierPath(roundedRect: bounds,
                                    byRoundingCorners: corners,
                                    cornerRadii: CGSize(width: radius, height: radius))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        layer.mask = shape
    }
}
