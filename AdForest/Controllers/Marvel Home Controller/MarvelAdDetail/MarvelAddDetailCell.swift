//
//  MarvelAddDetailCell.swift
//  AdForest
//
//  Created by Charlie on 28/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import Alamofire
import ImageSlideshow

class MarvelAddDetailCell: UITableViewCell {
    
    
    @IBOutlet weak var containerCurve: UIView!{
        didSet{
            containerCurve.layer.masksToBounds = true
//            containerCurve.adDetailviewRoundCorners([.topLeft, .topRight], radius: 10)
//            containerCurve.layer.maskedCorners = [.layerMaxXMinYCorner,.layerMinXMinYCorner]
            containerCurve.viewRoundCorners(cornerRadius: 10)
            containerCurve.backgroundColor = UIColor.white
//            containerCurve.layer.shadowOpacity = 0.7
        }
    }
    @IBOutlet weak var containerViewAdType: UIView!{
        didSet{
            containerViewAdType.layer.cornerRadius = 5
            containerViewAdType.layer.masksToBounds = true
        }
    }
    
    @IBOutlet weak var imgAdTYype: UIImageView!
    @IBOutlet weak var lblAdType: UILabel!
    
    @IBOutlet weak var viewAddApproval: UIView!
    @IBOutlet weak var lblAddApproval: UILabel!
    @IBOutlet weak var viewFeaturedAdd: UIView!
    @IBOutlet weak var lblFeaturedAdd: UILabel!
        
    
    @IBOutlet weak var buttonFeatured: UIButton! {
        didSet {
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                buttonFeatured.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var lblFeatured: UILabel!{
        didSet{
            lblFeatured.layer.cornerRadius = 5
            lblFeatured.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var oltRoundDirection: UIButton!{
        didSet{
            oltRoundDirection.circularButton()

        }
    }
   
    
    //MARK:- Properties
    
    var btnMakeFeature: (()->())?
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var imagesArray = [AddDetailImage]()
    var objImage : AddDetailImage?
    var isFeature = false
    var featureText = ""
    var stringValue = ""
    var btnDirectionAction: (()->())?
    var sourceImages = [InputSource]()
    var localImages = [String]()
    
    
    //MARK:- Properties
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    func imageSliderSetting() {
        for image in localImages {
            let alamofireSource = AlamofireSource(urlString: image.encodeUrl())!
            sourceImages.append(alamofireSource)
        }
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        slideshow.pageControl.pageIndicatorTintColor = UIColor.lightGray
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
        }
        
        slideshow.setImageInputs(sourceImages)
        if #available(iOS 13.0, *) {
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
            slideshow.addGestureRecognizer(recognizer)
                   sourceImages.removeAll()
        } else {
            // Fallback on earlier versions
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap12))
            slideshow.addGestureRecognizer(recognizer)
                   sourceImages.removeAll()
          
        }
        
       
    }
    
   

    @available(iOS 13.0, *)
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: viewController()!)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
//        let imageView = sender.view as! UIImageView
//        let newImageView = UIImageView(image: imageView.image)
//        newImageView.frame = UIScreen.main.bounds
//        newImageView.backgroundColor = .black
//        newImageView.contentMode = .scaleAspectFit
//        newImageView.isUserInteractionEnabled = true
////        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap))
////        newImageView.addGestureRecognizer(tap)
//        self.contentView.addSubview(newImageView)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @objc func didTap12() {
           let fullScreenController = slideshow.presentFullScreenController(from: viewController()!)
     
           fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
       }
    
    //MARK:- IBActions
    @IBAction func actionFeatured(_ sender: UIButton) {
        self.btnMakeFeature?()
    }
    
    
    @IBAction func actionDirection(_ sender: Any) {
        self.btnDirectionAction?()
    }
}
extension UIView {
   
    func viewRoundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}
