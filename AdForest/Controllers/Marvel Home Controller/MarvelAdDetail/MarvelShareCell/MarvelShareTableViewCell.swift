//
//  MarvelShareTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 29/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelShareTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var containerMainCurved: UIView!
//    {
//        didSet{
//            containerMainCurved.layer.cornerRadius = 10
//            containerMainCurved.layer.borderWidth = 2
//            containerMainCurved.layer.masksToBounds = true
//        }
//        
//    }
    
    @IBOutlet weak var imgEdit: UIImageView!{
        didSet{
            imgEdit.tintImageColor(color: UIColor.white)
        }
    }
    @IBOutlet weak var btnEditAD: UIButton!{
        didSet {
//            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                btnEditAD.setTitleColor(UIColor.white, for: .normal)
//            }
        }
    }
    @IBOutlet weak var containerViewEdit: UIView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
            containerViewEdit.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
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
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var imgLocation: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                imgLocation.image = imgLocation.image?.withRenderingMode(.alwaysTemplate)
                imgLocation.tintColor = UIColor(hex: mainColor)
                
            }
        }
    }
    @IBOutlet weak var lblAddress: UILabel!
    
    @IBOutlet weak var imgCalender: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                imgCalender.image = imgCalender.image?.withRenderingMode(.alwaysTemplate)
                imgCalender.tintColor = UIColor(hex: mainColor)
                
            }
        }
    }
    
    @IBOutlet weak var lblViewCount: UILabel!
    @IBOutlet weak var imgViews: UIImageView!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                imgViews.image = imgViews.image?.withRenderingMode(.alwaysTemplate)
                imgViews.tintColor = UIColor(hex: mainColor)
                
            }
        }
    }
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var bgContainer: UIView!{
        didSet{
            bgContainer.layer.cornerRadius = 5
            bgContainer.layer.borderWidth = 2
            bgContainer.layer.masksToBounds = true
            bgContainer.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var containerTimer: UIView!{
        didSet{
            containerTimer.backgroundColor = UIColor.clear
        }
    }
    @IBOutlet weak var lblDaysCounter: UILabel!{
        didSet{
            lblDaysCounter.layer.cornerRadius = 5
            lblDaysCounter.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblDaysText: UILabel!
    @IBOutlet weak var lblHourCounter: UILabel!{
        didSet{
            lblHourCounter.layer.cornerRadius = 5
            lblHourCounter.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblHourText: UILabel!
    @IBOutlet weak var lblMinCounter: UILabel!{
        didSet{
            lblMinCounter.layer.cornerRadius = 5
            lblMinCounter.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var lblMInText: UILabel!
    @IBOutlet weak var lblSecText: UILabel!
    @IBOutlet weak var lblSecCounter: UILabel!{
        didSet{
            lblSecCounter.layer.cornerRadius = 5
            lblSecCounter.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var btnBIds: UIButton!
    @IBOutlet weak var viewSeperator: UIView!
    
    //MARK:-Properties
    var btnEdit: (()->())?
    var btnBids:(()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    @IBAction func actionEdit(_ sender: UIButton) {
        self.btnEdit?()
    }
    @IBAction func actionBids(_ sender: UIButton) {
        self.btnBids?()
    }
}
