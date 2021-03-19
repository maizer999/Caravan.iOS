//
//  MarvelAdDetailViewController.swift
//  AdForest
//
//  Created by Charlie on 28/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import ImageSlideshow
import Alamofire
import AlamofireImage
import MapKit
import SwiftyGif
import IQKeyboardManagerSwift
import WebKit
import GoogleMobileAds
class MarvelAdDetailViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable , SimilarAdsDelegate, ReportPopToHomeDelegate, moveTomessagesDelegate,UISearchBarDelegate,NearBySearchDelegate,UIGestureRecognizerDelegate{
    
    
    
    //MARK:- Outlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            
            tableView.register(UINib(nibName: MarvelShareTableViewCell.className, bundle: nil), forCellReuseIdentifier: MarvelShareTableViewCell.className)
//            tableView.register(UINib(nibName: ShareCell.className, bundle: nil), forCellReuseIdentifier: ShareCell.className)
            tableView.register(UINib(nibName: YouTubeVideoCell.className, bundle: nil), forCellReuseIdentifier: YouTubeVideoCell.className)
            
            tableView.register(UINib(nibName: MarvelAdDetailProfileCell.className, bundle: nil), forCellReuseIdentifier: MarvelAdDetailProfileCell.className)
            tableView.register(UINib(nibName: MarvelContactWithSellerCell.className, bundle: nil), forCellReuseIdentifier: MarvelContactWithSellerCell.className)
            tableView.register(UINib(nibName: AdRatingCell.className, bundle: nil), forCellReuseIdentifier: AdRatingCell.className)
            tableView.register(UINib(nibName: AddBidsCell.className, bundle: nil), forCellReuseIdentifier: AddBidsCell.className)
//            tableView.register(UINib(nibName: ReplyCell.className, bundle: nil), forCellReuseIdentifier: ReplyCell.className)
            tableView.register(UINib(nibName: CommentCell.className, bundle: nil), forCellReuseIdentifier: CommentCell.className)
            tableView.register(UINib(nibName: LoadMoreCell.className, bundle: nil), forCellReuseIdentifier: LoadMoreCell.className)
            
            tableView.register(UINib(nibName: ReplyReactionCell.className, bundle: nil), forCellReuseIdentifier: ReplyReactionCell.className)
        }
    }
    
    @IBOutlet weak var containerViewbutton: UIView!
    
    @IBOutlet weak var buttonSendMessage: UIButton! {
        didSet {
            buttonSendMessage.isHidden = true
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                buttonSendMessage.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var buttonCallNow: UIButton! {
        didSet {
            buttonCallNow.isHidden = true
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                buttonCallNow.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var imgMessage: UIImageView! {
        didSet{
            imgMessage.isHidden = true
            imgMessage.image = imgMessage.image?.withRenderingMode(.alwaysTemplate)
            imgMessage.tintColor = .white
        }
    }
    @IBOutlet weak var imgCall: UIImageView! {
        didSet {
            imgCall.isHidden = true
            imgCall.image = imgCall.image?.withRenderingMode(.alwaysTemplate)
            imgCall.tintColor = .white
        }
    }
    //MARK:- Properties
     let mainColor = UserDefaults.standard.string(forKey: "mainColor")

    let defaults = UserDefaults.standard
    var ad_id = 0

    var isFromRejectedAd = false
    var sendMsgbuttonType = ""
    var similarAdsTitle = ""
    var ratingReviewTitle = ""
    var buttonText = ""
    var isShowAdTime = false
    var isRatingSectionShow = false
    var isRatingReactionShow = false
    let gifManager = SwiftyGifManager(memoryLimit: 100)
    
    var day: Int = 0
    var hour: Int = 0
    var minute: Int = 0
    var second: Int = 0
    var serverTime = ""
    var isEndTime = ""
    
    var relatedAdsArray = [AddDetailRelatedAd]()
    var dataArray = [AddDetailData]()
    var fieldsArray = [AddDetailFieldsData]()
    var addVideoArray = [AddDetailAdVideo]()
    var bidsArray = [AddDetailAddBid]()
    var addRatingArray = [AddDetailRating]()
    var addReplyArray = [AddDetailReply]()
    var mutableString = NSMutableAttributedString()
    
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    let keyboardManager = IQKeyboardManager.sharedManager()
    var barButtonItems = [UIBarButtonItem]()
    var isShowContactSeller : Bool!
    var interstitial: GADInterstitial!
    var shareTextArray : [Any] = []
    var reportMsg: String!
    var reportPopUP: AddDetailReportPopup!
    var cantReportText : String!
    var homeStyles: String = UserDefaults.standard.string(forKey: "homeStyles")!
    var adDetailStyle: String = UserDefaults.standard.string(forKey: "adDetailStyle")!

var fromAdDetail = false
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.showBackButton()
        if fromAdDetail == true{
            self.showBackButton()
        }else{
            self.addBackButton()

        }
        self.hideKeyboard()
//        self.adMob()
        self.createAndLoadInterstitial()

        self.googleAnalytics(controllerName: "Add Detail Controller")
        NotificationCenter.default.addObserver(forName: NSNotification.Name(Constants.NotificationName.updateAddDetails), object: nil, queue: nil) {[unowned self] (notification) in
            if self.isFromRejectedAd {
                let parameter: [String: Any] = ["ad_id": self.ad_id, "is_rejected": true]
                self.adForest_addDetail(param: parameter as NSDictionary)
            } else {
                let parameter: [String: Any] = ["ad_id": self.ad_id]
                print(parameter)
                self.adForest_addDetail(param: parameter as NSDictionary)
            }
        }
        if isFromRejectedAd {
            let parameter: [String: Any] = ["ad_id": ad_id, "is_rejected": true]
            self.adForest_addDetail(param: parameter as NSDictionary)
        } else {
            let parameter: [String: Any] = ["ad_id": ad_id]
            print(parameter)
            self.adForest_addDetail(param: parameter as NSDictionary)
        }
        
        navigationButtons()
    }
    // MARK:- Go toHOmepage from addetail
    func addBackButton() {
        self.hideBackButton()
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if UserDefaults.standard.bool(forKey: "isRtl") {
            backButton.setBackgroundImage(#imageLiteral(resourceName: "arabicBackButton"), for: .normal)
        } else {
            backButton.setBackgroundImage(#imageLiteral(resourceName: "backbutton"), for: .normal)
        }
        backButton.addTarget(self, action: #selector(onBackButtonClciked), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
        
    }
    @objc override func onBackButtonClciked() {
        if homeStyles == "home1"{
            navigationController?.popViewController(animated: true)
        }
        else if homeStyles == "home2"{
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "MultiHomeViewController") as! MultiHomeViewController
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
        else if homeStyles == "home3"{
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SOTabBarViewController") as! SOTabBarViewController
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
    }
    //MARK: - Custom
    
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    //MARK:- After Message Sent, Move to messages Screen
    func isMoveMessages(isMove: Bool) {
        let messagesVC = self.storyboard?.instantiateViewController(withIdentifier: MessagesController.className) as! MessagesController
        messagesVC.isFromAdDetail = true
        self.navigationController?.pushViewController(messagesVC, animated: true)
    }
    
    //MARK:- Similar Ads Delegate Move Forward From collection View
    func goToDetailAd(id: Int) {
        if adDetailStyle == "style1"{
            let detailAdVC = self.storyboard?.instantiateViewController(withIdentifier: AddDetailController.className) as! AddDetailController
            detailAdVC.ad_id = id
            self.navigationController?.pushViewController(detailAdVC, animated: true)
        }
        else{
            let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MarvelAdDetailViewController") as! MarvelAdDetailViewController
            addDetailVC.ad_id = id
            self.navigationController?.pushViewController(addDetailVC, animated: true)
            
        }
//        let detailAdVC = self.storyboard?.instantiateViewController(withIdentifier: AddDetailController.className) as! AddDetailController
//        detailAdVC.ad_id = id
//        self.navigationController?.pushViewController(detailAdVC, animated: true)
       
    }
    
    //MARK:- after report add  move to home screen
    func moveToHome(isMove: Bool) {
        if isMove {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func adForest_populateData() {
        if AddsHandler.sharedInstance.objAddDetails != nil {
            let objData = AddsHandler.sharedInstance.objAddDetails
            
            if let msgButtonTitle = objData?.staticText.sendMsgBtn {
                self.buttonSendMessage.setTitle(msgButtonTitle, for: .normal)
            }
            if let callButtonTitle = objData?.staticText.callNowBtn {
                self.buttonCallNow.setTitle(callButtonTitle, for: .normal)
            }
            
            if let msgButtonType = objData?.staticText.sendMsgBtnType {
                self.sendMsgbuttonType = msgButtonType
            }
            
            guard let isShowCallButton = objData?.staticText.showCallBtn else {return}
            guard let isShowMsgButton = objData?.staticText.showMegsBtn else {return}
            
            if isShowMsgButton && isShowCallButton == false {
                imgCall.isHidden = true
                imgMessage.isHidden = false
                buttonCallNow.isHidden = true
                buttonSendMessage.isHidden = false
                buttonSendMessage.translatesAutoresizingMaskIntoConstraints = false
                buttonSendMessage.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                buttonSendMessage.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
            } else if isShowMsgButton == false && isShowCallButton {
                imgCall.isHidden = false
                imgMessage.isHidden = true
                buttonSendMessage.isHidden = true
                buttonCallNow.isHidden = false
                buttonCallNow.translatesAutoresizingMaskIntoConstraints = false
                buttonCallNow.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
                buttonCallNow.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
                
                imgCall.translatesAutoresizingMaskIntoConstraints = false
                imgCall.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 8).isActive = true
            } else if isShowMsgButton && isShowCallButton {
                buttonSendMessage.isHidden = false
                buttonCallNow.isHidden = false
                imgCall.isHidden = false
                imgMessage.isHidden = false
            }
        }
    }
    
    func adMob() {
        if UserHandler.sharedInstance.objAdMob != nil {
            let objData = UserHandler.sharedInstance.objAdMob
            var isShowAd = false
            if let adShow = objData?.show {
                isShowAd = adShow
            }
            if isShowAd {
                var isShowBanner = false
                var isShowInterstital = false
                if let banner = objData?.isShowBanner {
                    isShowBanner = banner
                }
                if let intersitial = objData?.isShowInitial {
                    isShowInterstital = intersitial
                }
                if isShowBanner {
                    SwiftyAd.shared.setup(withBannerID: (objData?.bannerId)!, interstitialID: "", rewardedVideoID: "")
                    self.tableView.translatesAutoresizingMaskIntoConstraints = false
                    if objData?.position == "top" {
                        self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 50).isActive = true
                        SwiftyAd.shared.showBanner(from: self, at: .top)
                    } else {
                        self.containerViewbutton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 60).isActive = true
                        SwiftyAd.shared.showBanner(from: self, at: .bottom)
                    }
                }
                if isShowInterstital {
//                    SwiftyAd.shared.setup(withBannerID: "", interstitialID: (objData?.interstitalId)!, rewardedVideoID: "")
//                    SwiftyAd.shared.showInterstitial(from: self)
//                    self.showAd()
//                    self.perform(#selector(self.showAd), with: nil, afterDelay: Double(objData!.timeInitial)!)
//                    self.perform(#selector(self.showAd2), with: nil, afterDelay: Double(objData!.time)!)
                }
            }
        }
    }
    fileprivate func createAndLoadInterstitial() {
      interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
      let request = GADRequest()
      // Request test ads on devices you specify. Your test device ID is printed to the console when
      // an ad request is made.
      request.testDevices = [kGADSimulatorID as! String, "2077ef9a63d2b398840261c8221a0c9a"]
      interstitial.load(request)
        if self.interstitial.isReady {
          self.interstitial.present(fromRootViewController: self)
        } else {
          print("Ad wasn't ready")
        }
    }

    
//    @objc func showAd(){
//        currentVc = self
//        admobDelegate.showAd()
//    }
    
//    @objc func showAd2(){
//        currentVc = self
////        admobDelegate.showAd()
//    }
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
        day  = timeDifference.day!
        hour = timeDifference.hour!
        minute = timeDifference.minute!
        second = timeDifference.second!
    }
    
    
    
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            return 1
        }
        else if section == 3 {
            if addRatingArray.isEmpty {
                return 0
            }
            else {
                return addRatingArray.count
            }
        }
        else if section == 4 {
            return addReplyArray.count
        }
        else if section == 5 {
            return 1
        }
            else if section == 8 {
            return dataArray.count
        }
            
        else if section == 9 {
            if addVideoArray.isEmpty {
                return 0
            }
            else {
                return addVideoArray.count
            }
        }
            
        else if section == 10 {
            if bidsArray.isEmpty {
                return 0
            }
            else {
                return bidsArray.count
            }
        }
        else if section == 10 {
            return 1
        }
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MarvelAddDetailCell.className, for: indexPath) as! MarvelAddDetailCell
            let objData = dataArray[indexPath.row]
            
            if objData.notification == "" {
                cell.viewAddApproval.isHidden = true
                cell.viewFeaturedAdd.translatesAutoresizingMaskIntoConstraints = false
                cell.viewFeaturedAdd.topAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 0).isActive = true
            }
            else {
                cell.viewAddApproval.isHidden = false
                if let approvalText = objData.notification {
                    cell.lblAddApproval.text = approvalText
                }
            }
            
            var isShowFeatured = false
            if let isFeature = objData.isFeatured.isShow {
                isShowFeatured = isFeature
            }
            
            if isShowFeatured {
                if let featureText = objData.isFeatured.notification.text {
                    cell.lblFeaturedAdd.text = featureText
                }
                if let buttonFeatureText = objData.isFeatured.notification.btn {
                    cell.buttonFeatured.setTitle(buttonFeatureText, for: .normal)
                }
            }
            else {
                cell.viewFeaturedAdd.isHidden = true
                cell.slideshow.translatesAutoresizingMaskIntoConstraints = false
                cell.slideshow.topAnchor.constraint(equalTo: self.tableView.topAnchor, constant: 0).isActive = true
            }
            var isFeature = false
            if let featureBool = objData.adDetail.isFeature {
                isFeature = featureBool
            }
            if isFeature {
                if let featureText = objData.adDetail.isFeatureText {
                    cell.lblFeatured.backgroundColor = Constants.hexStringToUIColor(hex: "#E52D27")
                    cell.lblFeatured.text = featureText
                }
            }
            else {
                cell.lblFeatured.isHidden = true
            }
            if let sliderImage = objData.adDetail.images {
                var imgArr = [String]()
                //objData.adDetail.images
                for ob in objData.adDetail.sliderImages{
                    imgArr.append(ob)
                }
                cell.localImages = []
                cell.localImages = imgArr
                cell.imageSliderSetting()
            }
            cell.btnMakeFeature = { () in
                let param: [String: Any] = ["ad_id": objData.adDetail.adId]
                self.adForest_makeAddFeature(Parameter: param as NSDictionary)
            }
            if let directionButtonTitle = objData.staticText.getDirection {
//                cell.oltRoundDirection.setTitle(directionButtonTitle, for: .normal)
            }
            cell.oltRoundDirection.backgroundColor = UIColor.white
                //Constants.hexStringToUIColor(hex: Constants.AppColor.brownColor)
            var isShowAdType = false
            if let isShow = objData.adDetail.adTypeBar.isShow {
                isShowAdType = isShow
            }
            if isShowAdType {
                if let saleType = objData.adDetail.adTypeBar.text {
                    
                    cell.containerViewAdType.backgroundColor = Constants.hexStringToUIColor(hex: mainColor!)
                    cell.containerViewAdType.isHidden = false
                    cell.lblAdType.text = saleType
                    cell.lblAdType.font = UIFont.systemFont(ofSize: 14)
                }
            } else {
                cell.containerViewAdType.isHidden = true
            }

            var latitude = ""
            var longitude = ""
            
            if let lat = objData.adDetail.location.lat {
                latitude = lat
            }
            if let long = objData.adDetail.location.longField {
                longitude = long
            }
            if latitude == "" && longitude == "" {
                cell.oltRoundDirection.isHidden = true
            } else {
                cell.oltRoundDirection.isHidden = false
                cell.btnDirectionAction = { () in
                    let lat = CLLocationDegrees(latitude)
                    let long = CLLocationDegrees(longitude)
                    
                    let regionDistance: CLLocationDistance = 1000
                    let coordinates = CLLocationCoordinate2DMake(lat!, long!)
                    
                    let regionSpan = MKCoordinateRegionMakeWithDistance(coordinates, regionDistance, regionDistance)
                    
                    let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan:  regionSpan.span)]
                    
                    let placeMark = MKPlacemark(coordinate: coordinates)
                    let mapItem = MKMapItem(placemark: placeMark)
                    mapItem.name = objData.adDetail.locationTop
                    mapItem.openInMaps(launchOptions: options)
                }
            }
//            if isShowAdTime {
//                cell.lblTimer.isHidden = false
//                let obj = AddsHandler.sharedInstance.adBidTime
//                let first10 = String(obj!.timerTime)
//                print(first10)
//                cell.lblTimer.isHidden = false
//
//                if first10 != ""{
//                    let endDate = first10
//                    self.isEndTime = endDate
//                    Timer.every(1.second) {
//                        self.countDown(date: endDate)
//                        cell.lblTimer.text = "\(self.day) D: \(self.hour) H: \(self.minute) M: \(self.second) S"
//
//                    }
//                }
//            }else{
//                cell.lblTimer.isHidden = true
//            }
            //old method
            if isShowAdTime {
               // cell.lblTimer.isHidden = false
                let obj = AddsHandler.sharedInstance.adBidTime
                if let endDate = obj?.timerTime {
                    self.isEndTime = endDate
                    Timer.every(1.second) {
                        self.countDown(date: endDate)
                       // cell.lblTimer.text = "\(self.day) D: \(self.hour) H: \(self.minute) M: \(self.second) S"
                    }
                }
            } else {
               // cell.lblTimer.isHidden = true
            }
            return cell
        }
            
        else if section == 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: MarvelShareTableViewCell.className, for: indexPath) as! MarvelShareTableViewCell
                        let objData = dataArray[indexPath.row]
            shareTextArray = [objData.shareInfo.title, objData.shareInfo.link]
            reportMsg = objData.staticText.sendMsgBtnType
            reportPopUP = objData.reportPopup
            cantReportText = objData.cantReportTxt

            if let addTitleText = objData.adDetail.adTitle {
                cell.lblTitle.text = addTitleText
            }
            if let date = objData.adDetail.adDate {
                cell.lblDate.text = date
            }
            if let viewCount = objData.adDetail.adViewCount {
                cell.lblViewCount.text = viewCount
            }
            if let locationText = objData.adDetail.locationTop {
                cell.lblAddress.text = locationText
            }
            let priceType = objData.adDetail.adPrice.priceType
            let priceText = objData.adDetail.adPrice.price
            if priceType == nil{
                if let price = objData.adDetail.adPrice.price{
                    
                    cell.lblPrice.text = "\(price)(\(priceType!))"
                    
                }
                
            }
            else{
                cell.lblPrice.text = priceText
                
            }
            if isShowAdTime {
                cell.containerTimer.isHidden = false
                cell.bgContainer.isHidden = false
                cell.viewSeperator.isHidden = false
               // cell.lblTimer.isHidden = false
                let obj = AddsHandler.sharedInstance.adBidTime
                if let endDate = obj?.timerTime {
                    self.isEndTime = endDate
                    Timer.every(1.second) {
                        self.countDown(date: endDate)
                        cell.lblDaysCounter.text = "\(self.day)"
                        cell.lblHourCounter.text = "\(self.hour)"
                        cell.lblMinCounter.text = "\(self.minute)"
                        cell.lblSecCounter.text = "\(self.second)"
                        cell.lblSecCounter.fadeTransition(0.4)

                    }
                }
            } else {
                cell.containerTimer.isHidden = true
                cell.bgContainer.isHidden = true
                cell.viewSeperator.isHidden = true
            }
            cell.btnBids = { [self] () in
                let bidsVC = self.storyboard?.instantiateViewController(withIdentifier: BidsController.className) as! BidsController
                bidsVC.adID = (self.ad_id)
                AddsHandler.sharedInstance.adIdBidStat = (self.ad_id)
                self.navigationController?.pushViewController(bidsVC, animated: true)
            }
            if let editText = objData.editTxt {
                cell.btnEditAD.setTitle(editText, for: .normal)
            }
            if objData.staticText.sendMsgBtnType == "receive" {
                if self.defaults.bool(forKey: "isLogin") == false {
                    cell.containerViewEdit.isHidden = true
                } else {
                    cell.containerViewEdit.isHidden = false

                    cell.btnEdit = { () in
                        let editAdVC = self.storyboard?.instantiateViewController(withIdentifier: AadPostController.className) as! AadPostController
                        editAdVC.isFromEditAd = true
                        editAdVC.ad_id = self.ad_id
                        self.navigationController?.pushViewController(editAdVC, animated: true)
                    }
                }
            } else {
                cell.containerViewEdit.isHidden = true
            }

            return cell
        }
            
        else if section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddDetailDescriptionCell.className, for: indexPath) as! AddDetailDescriptionCell
            let objData = AddsHandler.sharedInstance.objAddDetails
            
            if let descriptionText = objData?.staticText.descriptionTitle {
                cell.lblDescription.text = descriptionText
            }
            
//            if let fielddata = objData?.fieldsDataColumn{
//
//            }
//            if let Weblink = UserDefaults.standard.string(forKey: "webUrl"){
//                cell.lblWebUrl.text == Weblink
//
//            }
            if let htmlText = objData?.adDetail.adDesc {
//                cell.lblHtmlText.attributedText = htmlText.html2AttributedString
//
//                let strokeTextAttributes: [NSAttributedString.Key: Any] = [
//                    .foregroundColor : UIColor.gray,
//                    .font : UIFont.systemFont(ofSize: 15)
//                ]
//                let data = htmlText.data(using: String.Encoding.unicode)!
//                let attrStr = try? NSAttributedString(
//                    data: data,
//                    options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html],
//                    documentAttributes: nil)
//
//                cell.lblHtmlText.attributedText = NSMutableAttributedString(string: (attrStr?.string)!, attributes: strokeTextAttributes)

                cell.wkWebView.loadHTMLStringWithMagic(content:htmlText, baseURL: nil)
                cell.heightConstraintWebView.constant = cell.wkWebView.scrollView.contentSize.height
            
               // self.view.layoutIfNeeded()
                
            }
        
            
            if let tagTitle = objData?.adDetail.adTagsShow.name {
                if let addTags = objData?.adDetail.adTagsShow.value {
                    if addTags != ""{
                        let tags = ":  \(addTags)"
                        let attributes = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 12)]
                        let attributedString = NSMutableAttributedString(string: tagTitle, attributes: attributes)
                        
                        let normalString = NSMutableAttributedString(string: tags)
                        attributedString.append(normalString)
                        cell.lblTagTitle.attributedText = attributedString
                    }
                   
                }
            }
            
            if let locationText = objData?.adDetail.location.title {
                cell.locationTitle.text = locationText
            }
            if let locationValue = objData?.adDetail.location.address {
                cell.locationValue.text = locationValue
            }
            
            if let clickUrl = objData?.self.clickHereText{
                UserDefaults.standard.set(clickUrl, forKey: "webUrl")
                print(clickUrl)
                           }
            cell.fieldsArray = self.fieldsArray
            cell.frame = tableView.bounds
            cell.adForest_reload()
            cell.layoutIfNeeded()
            return cell
        }
            
        else if section == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: ReplyReactionCell.className, for: indexPath) as! ReplyReactionCell
            let objData = addRatingArray[indexPath.row]
            
            if let imgUrl = URL(string: objData.ratingAuthorImage) {
                cell.imgProfile.setImage(from: imgUrl)
            }
            if let name = objData.ratingAuthorName {
                cell.lblName.text = name
            }
            if let replyText = objData.ratingText {
                cell.lblReply.text = replyText
            }
            if let date = objData.ratingDate {
                cell.lblDate.text = date
            }
            print(objData.ratingStars)
            if objData.ratingStars != "" {
            if let ratingBar = objData.ratingStars {
                cell.ratingBar.settings.updateOnTouch = false
                cell.ratingBar.settings.fillMode = .precise
                cell.ratingBar.settings.filledColor = Constants.hexStringToUIColor(hex: Constants.AppColor.ratingColor)
                cell.ratingBar.rating = Double(ratingBar)!
             }
            }
            if let replyButtontext = objData.replyText {
                cell.oltReply.setTitle(replyButtontext, for: .normal)
            }
            print(isRatingReactionShow)
            if isRatingReactionShow == false {
//                cell.imgThumb.isHidden = true
//                cell.imgHeart.isHidden = true
//                cell.imgWow.isHidden = true
//                cell.imgAndry.isHidden = true
//                cell.lblThumb.isHidden = true
//                cell.lblHeart.isHidden = true
//                cell.lblWow.isHidden = true
//                cell.lblSad.isHidden = true
                cell.containerViewReactions.isHidden = true

//                isHidden = true
//                cell.btnThumb.isHidden = true
//                cell.btnSad.isHidden = true
//                cell.btnWow.isHidden = true

                
            }else{
                cell.containerViewReactions.isHidden = false
//                cell.imgThumb.isHidden = false
//                cell.imgHeart.isHidden = false
//                cell.imgWow.isHidden = false
//                cell.imgAndry.isHidden = false
//                cell.lblThumb.isHidden = false
//                cell.lblHeart.isHidden = false
//                cell.lblWow.isHidden = false
//                cell.lblSad.isHidden = false
////                cell.btnLove.
//                isHidden = false
//                cell.btnThumb.isHidden = false
//                cell.btnSad.isHidden = false
//                cell.btnWow.isHidden = false
            }
            cell.imgThumb.setGifImage(UIImage(gifName: "thumb"), manager: gifManager, loopCount: -1)
            cell.imgHeart.setGifImage(UIImage(gifName: "heart"), manager: gifManager, loopCount: -1)
            cell.imgWow.setGifImage(UIImage(gifName: "wow"), manager: gifManager, loopCount: -1)
            cell.imgAndry.setGifImage(UIImage(gifName: "sad"), manager: gifManager, loopCount: -1)
            
            if let like = objData.adReactions.like {
                cell.lblThumb.text = "\(like)"
            }
            
            if let love = objData.adReactions.love {
                cell.lblHeart.text = "\(love)"
            }
            
            if let wow = objData.adReactions.wow {
                cell.lblWow.text = "\(wow)"
            }
            
            if let sad = objData.adReactions.angry {
                cell.lblSad.text = "\(sad)"
            }
            
            cell.btnThumb = { () in
                if let rate_id = objData.ratingId {
                    let param: [String:Any] = [
                        "r_id": 1,
                        "c_id" : rate_id
                    ]
                    self.reactEmojis(parameter: param)
                }
            }
            
            cell.btnLove = { () in
                if let rate_id = objData.ratingId {
                    let param: [String:Any] = [
                        "r_id": 2,
                        "c_id" : rate_id
                    ]
                    self.reactEmojis(parameter: param)
                }
            }
            
            cell.btnWow = { () in
                if let rate_id = objData.ratingId {
                    let param: [String:Any] = [
                        "r_id": 3,
                        "c_id" : rate_id
                    ]
                    self.reactEmojis(parameter: param)
                }
            }
            
            cell.btnSad = { () in
                if let rate_id = objData.ratingId {
                    let param: [String:Any] = [
                        "r_id": 4,
                        "c_id" : rate_id
                    ]
                    self.reactEmojis(parameter: param)
                }
            }
            
            if objData.canReply {
                cell.oltReply.isHidden = false
                cell.btnReplyAction = { () in
                    let commentVC = self.storyboard?.instantiateViewController(withIdentifier: ReplyCommentController.className) as! ReplyCommentController
                    commentVC.modalPresentationStyle = .overCurrentContext
                    commentVC.modalTransitionStyle = .crossDissolve
                    commentVC.isFromAddDetailReply = true
                    commentVC.objAddDetail = AddsHandler.sharedInstance.objAddDetails?.adRatting.rplyDialog
                    commentVC.comment_id = objData.ratingId
                    commentVC.ad_id = self.ad_id
                    self.presentVC(commentVC)
                }
            }
            else {
                cell.oltReply.isHidden = true
            }
            return cell
        }
        else if section == 4 {
            //reply cell
            let cell : CommentCell = tableView.dequeueReusableCell(withIdentifier: CommentCell.className, for: indexPath) as! CommentCell
            let objData = addReplyArray[indexPath.row]
            
            if let imgUrl = URL(string: objData.ratingAuthorImage) {
                cell.imgPicture.setImage(from: imgUrl)
            }
            if let name = objData.ratingAuthorName {
                cell.lblName.text = name
            }
            if let date = objData.ratingDate {
                cell.lblDate.text = date
            }
            if let replyText = objData.ratingText {
                cell.lblReply.text = replyText
            }
            return cell
        }
        else if section == 5 {
            let objData = AddsHandler.sharedInstance.objAddDetails
            var hasNextPage = false
            if let hasPage = objData?.adRatting.pagination.hasNextPage {
                hasNextPage = hasPage
            }
            if hasNextPage {
                let cell: LoadMoreCell =  tableView.dequeueReusableCell(withIdentifier: LoadMoreCell.className, for: indexPath) as! LoadMoreCell
                let objData = AddsHandler.sharedInstance.objAddDetails
                if let loadMoreButton = objData?.adRatting.loadmoreBtn {
                    cell.oltLoadMore.setTitle(loadMoreButton, for: .normal)
                }
                cell.btnLoadMore = { () in
                    let ratingVC = self.storyboard?.instantiateViewController(withIdentifier: RatingReviewsController.className) as! RatingReviewsController
                    ratingVC.adID = self.ad_id
                    self.navigationController?.pushViewController(ratingVC, animated: true)
                }
                return cell
            }
        }
        else if section == 6 {
            let cell: AdRatingCell = tableView.dequeueReusableCell(withIdentifier: AdRatingCell.className, for: indexPath) as! AdRatingCell
            let objData = dataArray[indexPath.row]
            
            if let receiverText = objData.staticText.sendMsgBtnType {
                buttonText = receiverText
            }
            
            if isRatingSectionShow == false{
                cell.lblNotEdit.isHidden = true
                cell.txtComment.isHidden = true
                cell.oltSubmitRating.isHidden = true
                cell.ratingBar.isHidden = true
            } else {
                
                if objData.adRatting.canRate && buttonText != "receive" {
                    if let title = objData.adRatting.title {
                        cell.lblTitle.text = title
                    }
                    if let txtSectionHeading = objData.adRatting.sectionTitle {
                        cell.lblSectionTitle.text = txtSectionHeading
                        
                    }
//                    if let txtSectiontagline = objData.adRatting.tagline {
//                        cell.lblSectionTagline.text = txtSectiontagline
//                    }
                    if let txtPlaceholder = objData.adRatting.textareaText {
                        cell.txtComment.placeholder = txtPlaceholder
                    }
                    let isShowEditLbl = objData.adRatting.isEditable
                    if isShowEditLbl! {
                        cell.lblSectionTagline.isHidden = true
                    }
                    else {
                        if let notEditLblText = objData.adRatting.tagline {
                            cell.lblSectionTagline.text = notEditLblText
                        }
                    }
                    if let submitButtonText = objData.adRatting.btn {
                        cell.oltSubmitRating.setTitle(submitButtonText, for: .normal)
                    }
                    cell.btnSubmitAction = { () in
                        guard let comment = cell.txtComment.text else {return}
                        if comment == "" {
                            cell.txtComment.shake(6, withDelta: 10, speed: 0.06)
                        } else {
                            let param: [String: Any] = ["ad_id": self.ad_id, "rating": cell.rating, "rating_comments": comment]
                            print(param)
                            self.adForest_addRating(param: param as NSDictionary)
                        }
                    }
                }
            else {
                if let noRatingText = objData.adRatting.canRateMsg {
                    cell.lblTitle.text = noRatingText
                    cell.lblTitle.textAlignment = .center
                }
                cell.lblNotEdit.isHidden = true
                cell.txtComment.isHidden = true
                cell.oltSubmitRating.isHidden = true
                cell.ratingBar.isHidden = true
                }
                
            }
            
            return cell
        }
        else if section == 7 {
            let cell: MarvelAdDetailProfileCell = tableView.dequeueReusableCell(withIdentifier: MarvelAdDetailProfileCell.className, for: indexPath) as! MarvelAdDetailProfileCell
    
            let objData = dataArray[indexPath.row]
            if let imgUrl = URL(string: objData.profileDetail.profileImg) {
                cell.imgUser.sd_setShowActivityIndicatorView(true)
                cell.imgUser.sd_setIndicatorStyle(.gray)
                cell.imgUser.sd_setImage(with: imgUrl, completed: nil)
            }
            if let name = objData.profileDetail.displayName {
                cell.lblName.text = name
            }
            
            if let verifyButtonText = objData.profileDetail.verifyButon.text {
                cell.lblVerified.text = verifyButtonText
            }
            if let buttonColor = objData.profileDetail.verifyButon.color {
                cell.lblVerified.backgroundColor = Constants.hexStringToUIColor(hex: buttonColor)
            }
            if let loginTime = objData.profileDetail.lastLogin {
                cell.lblLastLoginTime.text = loginTime
            }
            if let ratingBar = objData.profileDetail.rateBar.number {
                cell.cosmosView.settings.updateOnTouch = false
                cell.cosmosView.settings.fillMode = .precise
                cell.cosmosView.settings.filledColor = Constants.hexStringToUIColor(hex: Constants.AppColor.ratingColor)
                cell.cosmosView.rating = Double(ratingBar)!
            }
            
            if let avgRating = objData.profileDetail.rateBar.text {
                cell.cosmosView.text = avgRating
            }
            //cell did select action handle in button
            cell.btnCoverAction = { () in
                let publicProfileVC = self.storyboard?.instantiateViewController(withIdentifier: UserPublicProfile.className) as! UserPublicProfile
                publicProfileVC.userID = objData.adDetail.authorId
                self.navigationController?.pushViewController(publicProfileVC, animated: true)
            }
            
            var isShowBlockButton = false
            if let isShowBtn = objData.staticText.blockUser.isShow {
                isShowBlockButton = isShowBtn
            }
            if isShowBlockButton {
                cell.btnBlockUser.isHidden = false
                if let btnTitle = objData.staticText.blockUser.text {
                    cell.btnBlockUser.setTitle(btnTitle, for: .normal)
                }
                var popUpTitle = ""
                var popUpText = ""
                var cancelText = ""
                var confirmText = ""
                var user_id = ""
                
                if let popTitle = objData.staticText.blockUser.text {
                    popUpTitle = popTitle
                }
                if let popText = objData.staticText.blockUser.popupText {
                    popUpText = popText
                }
                if let cancel = objData.staticText.blockUser.popupCancel {
                    cancelText = cancel
                }
                
                if let confirm = objData.staticText.blockUser.popupConfirm {
                    confirmText = confirm
                }
                
                if let id = objData.adDetail.adAuthorId {
                    user_id = id
                }
                
                cell.btnBlock = { [self] () in
                    if defaults.bool(forKey: "isLogin") == true {

                    let alert = UIAlertController(title: popUpTitle, message: popUpText, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: confirmText , style: .default, handler: { (action) in
                        let param: [String: Any] = ["user_id": user_id]
                        print(param)
                        self.adForest_blockUser(param: param as NSDictionary)
                    })
                    let cancelAction = UIAlertAction(title: cancelText, style: .default, handler: nil)

                    alert.addAction(cancelAction)
                    alert.addAction(okAction)
                    self.presentVC(alert)
                    }else{
                        var msgLogin = ""
                        if let msg = self.defaults.string(forKey: "notLogin") {
                            msgLogin = msg
                        }
                        let alert = Constants.showBasicAlert(message: msgLogin)
                        self.presentVC(alert)
                    }
                }
            }
            else {
                cell.btnBlockUser.isHidden = true
            }
            cell.btnUserProfileAction = { () in
                if self.defaults.bool(forKey: "isLogin") == false {
                    if let msg = self.defaults.string(forKey: "notLogin") {
                        self.showToast(message: msg)
                    }
                } else {
                    guard let id = objData.adDetail.adAuthorId else {return}
                    let ratingVC = self.storyboard?.instantiateViewController(withIdentifier: PublicUserRatingController.className) as! PublicUserRatingController
                    ratingVC.adAuthorID = id
                    self.navigationController?.pushViewController(ratingVC, animated: true)
                }
            }
            return cell
        }
        else if section == 8 {
            let cell: MarvelContactWithSellerCell = tableView.dequeueReusableCell(withIdentifier: MarvelContactWithSellerCell.className, for: indexPath) as! MarvelContactWithSellerCell
            let objData = dataArray[indexPath.row]
            cell.lblMainHeading.text = objData.sellerContact.titleContactSeller
            cell.lblSubHeading.text = objData.sellerContact.subtitleContactSeller
            cell.btnClickNow.setTitle(objData.btnCLickText, for: .normal)
           
            isShowContactSeller = objData.sellerContact.isShow
            
            
            
            cell.ContactSeller = { () in
                let contactSellerVC = self.storyboard?.instantiateViewController(withIdentifier: ContactWithSellerViewController.className) as! ContactWithSellerViewController
                contactSellerVC.ad_ID = objData.adDetail.adId
                contactSellerVC.nameTitle = objData.sellerContact.popupName.title
                contactSellerVC.nameKey = objData.sellerContact.popupName.key
                contactSellerVC.nameRequired = objData.sellerContact.popupName.isRequired
                
                
                
                contactSellerVC.emailTitle = objData.sellerContact.popupEmail.title
                contactSellerVC.emailKey = objData.sellerContact.popupEmail.key
                contactSellerVC.emailRequired = objData.sellerContact.popupEmail.isRequired
                
                contactSellerVC.phoneNumberTitle = objData.sellerContact.popupPhone.title
                contactSellerVC.phoneNumberKey = objData.sellerContact.popupPhone.key
                contactSellerVC.phoneNumberRequired = objData.sellerContact.popupPhone.isRequired
                
                contactSellerVC.messageTitle = objData.sellerContact.popupMessage.title
                contactSellerVC.messageKey = objData.sellerContact.popupMessage.key
                contactSellerVC.messageRequired = objData.sellerContact.popupMessage.isRequired
                
                contactSellerVC.btnSubmitText = objData.sellerContact.btnSend
                contactSellerVC.btnCancelText = objData.sellerContact.btnCancel
                
                contactSellerVC.modalPresentationStyle = .overCurrentContext
                self.presentVC(contactSellerVC)
                
            }
            return cell
        }
        else if section == 9 {
            let cell: YouTubeVideoCell = tableView.dequeueReusableCell(withIdentifier: YouTubeVideoCell.className, for: indexPath) as! YouTubeVideoCell
            let objData = addVideoArray[indexPath.row]
            
            if let videoUrl = objData.videoId {
                cell.playerView.load(withVideoId: videoUrl)
//                loadVideoID(videoUrl)
            }
            return cell
        }
            
        else if section == 10 {
            let cell: AddBidsCell = tableView.dequeueReusableCell(withIdentifier: AddBidsCell.className, for: indexPath) as! AddBidsCell
            let objData = bidsArray[indexPath.row]
            let data = AddsHandler.sharedInstance.objAddDetails
            if (data?.staticText.adBidsEnable)! {
                if let totalText = objData.totalText {
                    cell.lblTotal.text = totalText
                }
                if let totalValue = objData.total {
                    cell.lblTotalValue.text = String(totalValue)
                }
                if let hightText = objData.maxText {
                    cell.lblHighest.text = hightText
                }
                if let highValue = objData.max.price {
                    cell.lblhighestValue.text = highValue
                }
                if let lowText = objData.minText {
                    cell.lblLowest.text = lowText
                }
                if let lowValue = objData.min.price {
                    cell.lblLowestValue.text = lowValue
                }
                
                if let bidText = data?.staticText.bidNowBtn {
                    cell.oltBids.setTitle(bidText, for: .normal)
                }
                if let statText = data?.staticText.bidStatsBtn {
                    cell.oltStats.setTitle(statText, for: .normal)
                }
                cell.btnBids = { () in
                    let bidsVC = self.storyboard?.instantiateViewController(withIdentifier: BidsController.className) as! BidsController
                    bidsVC.adID = (data?.adDetail.adId)!
                    AddsHandler.sharedInstance.adIdBidStat = (data?.adDetail.adId)!
                    self.navigationController?.pushViewController(bidsVC, animated: true)
                }
                
                cell.btnStats = { () in
                    let bidsVC = self.storyboard?.instantiateViewController(withIdentifier: BidsController.className) as! BidsController
                    bidsVC.adID = (data?.adDetail.adId)!
                    AddsHandler.sharedInstance.adIdBidStat = (data?.adDetail.adId)!
                    self.navigationController?.pushViewController(bidsVC, animated: true)
                }
            }
            else {
                cell.containerView.isHidden = true
            }
            return cell
        }
            
        else if section == 11 {
            let cell : SimilarAdsTableCell = tableView.dequeueReusableCell(withIdentifier: SimilarAdsTableCell.className, for: indexPath) as! SimilarAdsTableCell
            
            cell.relatedAddsArray = self.relatedAdsArray
            cell.delegate = self
            cell.collectionView.reloadData()
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var height: CGFloat = 0
        
        if section == 0 {
            let objData = dataArray[indexPath.row]
            let isFeatured = objData.isFeatured.isShow
            if isFeatured! {
                height = 300
            }
            else if isFeatured == false {
                height = 290
            }
        }
        else if section == 1 {
            if isShowAdTime == false{
            height = 130
            
            }else{
            height = 210
                //210
            }
        }
            
        else if section == 2 {
            height = UITableViewAutomaticDimension
        }
            
        else if section == 3 {
            if addRatingArray.count == 0 {
                height = 30
            }
            else {
                height = UITableViewAutomaticDimension
            }
        }
        else if section == 4 {
            height = UITableViewAutomaticDimension
        }
        else if section == 5 {
            let objData = AddsHandler.sharedInstance.objAddDetails
            var hasNextPage = false
            if let hasPage = objData?.adRatting.pagination.hasNextPage {
                hasNextPage = hasPage
            }
            if hasNextPage {
                height = 50
            } else {
                height = 0
            }
        }
        else if section == 6 {
            let objData = dataArray[indexPath.row]
            
            if isRatingSectionShow == false{
                height = 0
            }else{
                
                if objData.adRatting.canRate && buttonText != "receive"  {
                    height = 270
                } else {
                    height = 90
                }
            }
        }
            
        else if section == 7 {
            height = 285
                //105
        }
            
        else if section == 8 {
            let objData = dataArray[indexPath.row]
           isShowContactSeller = objData.sellerContact.isShow
            if isShowContactSeller == false {
                height = 0
            }
            else{
                height = 110
            }
            
        }
            else if section == 9 {
                let objdata = addVideoArray[indexPath.row]
                if objdata.videoId == "" {
                    height = 0
                }
                else {
                    height = 230
                }
            }

        else if section == 10 {
            let isBidEnable = AddsHandler.sharedInstance.objAddDetails?.staticText.adBidsEnable
            if isBidEnable! {
                height = 120
            }
            else {
                height = 0
            }
        }
            
        else if section == 11 {
            height = 230
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0.0
        
        if section == 3 {
            if isRatingSectionShow == false{
                height = 0.0
            }else{
                height = 20
            }
        }
        else if section == 10 {
            height = 20
        }
      
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
//        let titleLabel = UILabel(frame: CGRect(x: 15, y: 0, width: self.view.frame.width - 20, height: 20))
    
//        if section == 3 {
//            titleLabel.text = ratingReviewTitle
//            titleLabel.textAlignment = .center
//        }
//
//        else if section == 10 {
//            titleLabel.text = similarAdsTitle
//            titleLabel.textAlignment = .left
//        }
//        headerView.addSubview(titleLabel)
        return headerView
    }
    
    //MARK:- IBActions
    @IBAction func actionSendMessage(_ sender: Any) {
        if defaults.bool(forKey: "isLogin") == false {
            if let msg = defaults.string(forKey: "notLogin") {
                let alert = Constants.showBasicAlert(message: msg)
                presentVC(alert)
            }
        } else {
            if sendMsgbuttonType == "receive" {
                let msgVC = self.storyboard?.instantiateViewController(withIdentifier: "MessagesController") as! MessagesController
                msgVC.isFromAdDetail = true
                self.navigationController?.pushViewController(msgVC, animated: true)
            } else {
                let sendMsgVC = storyboard?.instantiateViewController(withIdentifier: ReplyCommentController.className) as! ReplyCommentController
                sendMsgVC.modalPresentationStyle = .overCurrentContext
                sendMsgVC.modalTransitionStyle = .flipHorizontal
                sendMsgVC.isFromMsg = true
                sendMsgVC.objAddDetailData = AddsHandler.sharedInstance.objAddDetails
                sendMsgVC.delegate = self
                present(sendMsgVC, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func actionCallNow(_ sender: UIButton) {
        if (AddsHandler.sharedInstance.objAddDetails?.showPhoneToLogin)! && defaults.bool(forKey: "isAppOpen") {
            if let notLoginMessage = defaults.string(forKey: "notLogin") {
                self.showToast(message: notLoginMessage)
            }
        } else {
            let sendMsgVC = self.storyboard?.instantiateViewController(withIdentifier: ReplyCommentController.className) as! ReplyCommentController
            sendMsgVC.modalPresentationStyle = .overCurrentContext
            sendMsgVC.modalTransitionStyle = .coverVertical
            sendMsgVC.isFromCall = true
            sendMsgVC.objAddDetailData = AddsHandler.sharedInstance.objAddDetails
            self.presentVC(sendMsgVC)
        }
    }
    
    //MARK:- API Call
    func adForest_addDetail(param: NSDictionary) {
        self.showLoader()
        AddsHandler.addDetails(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                AddsHandler.sharedInstance.descTitle = successResponse.data.staticText.descriptionTitle
                AddsHandler.sharedInstance.htmlText = successResponse.data.adDetail.adDesc
                self.similarAdsTitle = successResponse.data.staticText.relatedPostsTitle
                
                // set bid & stat title to show in bidding XLPager title
                AddsHandler.sharedInstance.bidTitle = successResponse.data.staticText.bidTabs.bid
                AddsHandler.sharedInstance.statTitle = successResponse.data.staticText.bidTabs.stats
                
                self.addRatingArray = successResponse.data.adRatting.ratings
                //set rating section title
                if self.addRatingArray.count == 0 {
                    self.ratingReviewTitle = successResponse.data.adRatting.noRatingMessage
                }
                else {
                    self.ratingReviewTitle = successResponse.data.adRatting.sectionTitle
                }
                
                for replys in successResponse.data.adRatting.ratings {
                    self.addReplyArray = replys.reply
                }
                if let adTime = successResponse.data.adDetail.adTimer.isShow {
                    self.isShowAdTime = adTime
                }
                if self.isShowAdTime {
                    AddsHandler.sharedInstance.adBidTime = successResponse.data.adDetail.adTimer
                    self.serverTime = successResponse.data.adDetail.adTimer.timerServerTime
                }
                AddsHandler.sharedInstance.objAddDetails = successResponse.data
                self.bidsArray = [successResponse.data.staticText.adBids]
                self.addVideoArray = [successResponse.data.adDetail.adVideo]
                self.dataArray = [successResponse.data]
                self.isRatingSectionShow = successResponse.data.adRatting.ratingShow
                self.isRatingReactionShow = successResponse.data.adRatting.adRatingEmojies
                self.fieldsArray = successResponse.data.adDetail.fieldsData
                self.relatedAdsArray = successResponse.data.adDetail.relatedAds
                AddsHandler.sharedInstance.ratingsAdds = successResponse.data.adRatting
                self.adForest_populateData()
                self.tableView.reloadData()
                self.perform(#selector(self.reloadTable), with: nil, afterDelay: 1.5)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
            
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    @objc func reloadTable(){
        self.tableView.reloadData()
    }
    
    //MARK:- Make Add Feature
    func adForest_makeAddFeature(Parameter: NSDictionary) {
        self.showLoader()
        AddsHandler.makeAddFeature(parameter: Parameter, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    let parameter: [String: Any] = ["ad_id": self.ad_id]
                    self.adForest_addDetail(param: parameter as NSDictionary)
                })
                self.presentVC(alert)
            }
            else {

                self.showToast(message: successResponse.message)
                self.perform(#selector(self.nokri_showNavController1), with: nil, afterDelay: 1.5)

              

//                let alert = Constants.showBasicAlert(message: successResponse.message)
//                self.presentVC(alert)
            }
            
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    @objc func nokri_showNavController1(){
        
        let packageView = self.storyboard?.instantiateViewController(withIdentifier: PackagesController.className) as! PackagesController
        self.navigationController?.pushViewController(packageView, animated: true)
        
    }
    
    //MARK:- Make Add Favourite
    func adForest_makeAddFavourite(param: NSDictionary) {
        self.showLoader()
        AddsHandler.makeAddFavourite(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = Constants.showBasicAlert(message: successResponse.message)

                self.presentVC(alert)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //MARK:- Block user
    func adForest_blockUser(param: NSDictionary) {
        self.showLoader()
        UserHandler.blockUser(parameter: param, success: {[unowned self] (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.navigationController?.popViewController(animated: true)
                })
                self.presentVC(alert)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) {[unowned self] (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //MARK:- Add Rating
    func adForest_addRating(param: NSDictionary) {
        self.showLoader()
        AddsHandler.ratingToAdd(parameter: param, success: {[unowned self] (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    let parameter: [String: Any] = ["ad_id": self.ad_id]
                    self.adForest_addDetail(param: parameter as NSDictionary)
                })
                self.presentVC(alert)
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) {[unowned self] (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //MARK:- React Emojis
    func reactEmojis(parameter: [String: Any]) {
        showLoader()
        AddsHandler.reactEmojis(parameter: parameter, success: {[unowned self] (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let parameter: [String: Any] = ["ad_id": self.ad_id]
                self.adForest_addDetail(param: parameter as NSDictionary)
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) {[unowned self] (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    
    //MARK:- Near by search Delaget method
    func nearbySearchParams(lat: Double, long: Double, searchDistance: CGFloat, isSearch: Bool) {
        self.latitude = lat
        self.longitude = long
        self.searchDistance = searchDistance
        if isSearch {
            let param: [String: Any] = ["nearby_latitude": lat, "nearby_longitude": long, "nearby_distance": searchDistance]
            print(param)
            self.adForest_nearBySearch(param: param as NSDictionary)
        } else {
            let param: [String: Any] = ["nearby_latitude": 0.0, "nearby_longitude": 0.0, "nearby_distance": searchDistance]
            print(param)
            self.adForest_nearBySearch(param: param as NSDictionary)
        }
    }
    
    
    func navigationButtons() {
        
        //Home Button
        let favButton = UIButton(type: .custom)
        let ho = UIImage(named: "favourite")?.withRenderingMode(.alwaysTemplate)
        favButton.setBackgroundImage(ho, for: .normal)
        favButton.tintColor = UIColor.white
        favButton.setImage(ho, for: .normal)
        if #available(iOS 11, *) {
            searchBarNavigation.widthAnchor.constraint(equalToConstant: 20).isActive = true
            searchBarNavigation.heightAnchor.constraint(equalToConstant: 20).isActive = true
        } else {
            favButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        favButton.addTarget(self, action: #selector(actionFavourite), for: .touchUpInside)
        let favItem = UIBarButtonItem(customView: favButton)
//        if defaults.bool(forKey: "showHome") {
            barButtonItems.append(favItem)
            //self.barButtonItems.append(homeItem)
//        }
        
        //Location Search
        let shareButton = UIButton(type: .custom)
        if #available(iOS 11, *) {
            shareButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            shareButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else {
            shareButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        let image = UIImage(named: "share")?.withRenderingMode(.alwaysTemplate)
        shareButton.setBackgroundImage(image, for: .normal)
        shareButton.tintColor = UIColor.white
        shareButton.addTarget(self, action: #selector(onClickShareButton), for: .touchUpInside)
        let barButtonShare = UIBarButtonItem(customView: shareButton)
//        if defaults.bool(forKey: "showNearBy") {
            self.barButtonItems.append(barButtonShare)
        //Location Search
        let reportButton = UIButton(type: .custom)
        if #available(iOS 11, *) {
            reportButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            reportButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else {
            reportButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        let imageReport = UIImage(named: "report")?.withRenderingMode(.alwaysTemplate)
        reportButton.setBackgroundImage(imageReport, for: .normal)
        reportButton.tintColor = UIColor.white
        reportButton.addTarget(self, action: #selector(onReportBtn), for: .touchUpInside)
        let barButtonReport = UIBarButtonItem(customView: reportButton)
//        if defaults.bool(forKey: "showNearBy") {
            self.barButtonItems.append(barButtonReport)
//        }
        //Search Button
//        let searchButton = UIButton(type: .custom)
//        if defaults.bool(forKey: "advanceSearch") == true{
//            let con = UIImage(named: "controls")?.withRenderingMode(.alwaysTemplate)
//            searchButton.setBackgroundImage(con, for: .normal)
//            searchButton.tintColor = UIColor.white
//            searchButton.setImage(con, for: .normal)
//        }else{
//            let con = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
//            searchButton.setBackgroundImage(con, for: .normal)
//            searchButton.tintColor = UIColor.white
//            searchButton.setImage(con, for: .normal)
//        }
//        if #available(iOS 11, *) {
//            searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
//            searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        } else {
//            searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        }
//        searchButton.addTarget(self, action: #selector(actionSearch), for: .touchUpInside)
//        let searchItem = UIBarButtonItem(customView: searchButton)
//        if defaults.bool(forKey: "showSearch") {
//            barButtonItems.append(searchItem)
//            //self.barButtonItems.append(searchItem)
//        }
        
        self.navigationItem.rightBarButtonItems = barButtonItems
        
    }
    
    @objc func actionFavourite() {
        if self.defaults.bool(forKey: "isLogin") == false {
            if let msg = self.defaults.string(forKey: "notLogin") {
                self.showToast(message: msg)
            }
        }
        else {
            let parameter: [String: Any] = ["ad_id": ad_id]
            self.adForest_makeAddFavourite(param: parameter as NSDictionary)
        }
    }
    
    @objc func onClickShareButton() {
        
         //shareTextArray = [objData.shareInfo.title, objData.shareInfo.link]
        let activityVC = UIActivityViewController(activityItems: shareTextArray as [Any], applicationActivities: nil)

            if  Constants.isiPadDevice {
//                if let popup = activityVC.popoverPresentationController {
//                    popup.sourceView = cell.buttonShare
////                            popOver.sourceRect = self.tableView.frame
//                    popup.sourceRect = cell.buttonShare.frame
////                                CGRect(x: self.view.frame.size.width / 0, y: self.view.frame.size.height / 900, width: 500, height: 450)
//                }
            } else{
                
        }

            self.present(activityVC, animated: true, completion: nil)

    }
   @objc func onReportBtn(){
        if self.defaults.bool(forKey: "isLogin") == false {
            if let msg = self.defaults.string(forKey: "notLogin"){
                self.showToast(message: msg)
            }
        } else if reportMsg == "receive" {
            if let reportText = cantReportText {
                self.showToast(message: reportText)
            }
        } else {
            let reportVC = self.storyboard?.instantiateViewController(withIdentifier: ReportController.className) as! ReportController
            reportVC.modalPresentationStyle = .overCurrentContext
            reportVC.modalTransitionStyle = .crossDissolve
            AddsHandler.sharedInstance.objReportPopUp = reportPopUP
            reportVC.adID = ad_id
            reportVC.delegate = self
            self.presentVC(reportVC)
        }
    }
    
    //MARK:- Search Controller
    
    @objc func actionSearch(_ sender: Any) {
        
        if defaults.bool(forKey: "advanceSearch") == true{
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let proVc = storyBoard.instantiateViewController(withIdentifier: "AdvancedSearchController") as! AdvancedSearchController
            self.pushVC(proVc, completion: nil)
        }else{
            
            //setupNavigationBar(title: "okk...")
            
            keyboardManager.enable = true
            if isNavSearchBarShowing {
                navigationItem.titleView = nil
                self.searchBarNavigation.text = ""
                self.backgroundView.removeFromSuperview()
                self.addTitleView()
                
            } else {
                self.backgroundView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
                self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.backgroundView.isOpaque = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
                tap.delegate = self
                self.backgroundView.addGestureRecognizer(tap)
                self.backgroundView.isUserInteractionEnabled = true
                self.view.addSubview(self.backgroundView)
                self.adNavSearchBar()
            }
        }
        
    }
    
    @objc func handleTap(_ gestureRocognizer: UITapGestureRecognizer) {
        self.actionSearch("")
    }
    
    func adNavSearchBar() {
        searchBarNavigation.placeholder = "Search Ads"
        searchBarNavigation.barStyle = .default
        searchBarNavigation.isTranslucent = false
        searchBarNavigation.barTintColor = UIColor.groupTableViewBackground
        searchBarNavigation.backgroundImage = UIImage()
        searchBarNavigation.sizeToFit()
        searchBarNavigation.delegate = self
        self.isNavSearchBarShowing = true
        searchBarNavigation.isHidden = false
        navigationItem.titleView = searchBarNavigation
        searchBarNavigation.becomeFirstResponder()
    }
    
    func addTitleView() {
        self.searchBarNavigation.endEditing(true)
        self.isNavSearchBarShowing = false
        self.searchBarNavigation.isHidden = true
        self.view.isUserInteractionEnabled = true
    }
    
    //MARK:- Search Bar Delegates
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        //self.searchBarNavigation.endEditing(true)
        searchBar.endEditing(true)
        self.view.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.searchBarNavigation.endEditing(true)
        guard let searchText = searchBar.text else {return}
        if searchText == "" {
            
        } else {
            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
            categoryVC.searchText = searchText
            categoryVC.isFromTextSearch = true
            self.navigationController?.pushViewController(categoryVC, animated: true)
        }
    }
    
    
    
    //MARK:- Near By Search
    func adForest_nearBySearch(param: NSDictionary) {
        self.showLoader()
        AddsHandler.nearbyAddsSearch(params: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                categoryVC.latitude = self.latitude
                categoryVC.longitude = self.longitude
                categoryVC.nearByDistance = self.searchDistance
                categoryVC.isFromNearBySearch = true
                self.navigationController?.pushViewController(categoryVC, animated: true)
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    
}

//MARK:-  EXtensionFlip timer
extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
//        func pushTransition(_ duration:CFTimeInterval) {
//              let animation:CATransition = CATransition()
//              animation.timingFunction = CAMediaTimingFunction(name:
//                  kCAMediaTimingFunctionEaseInEaseOut)
//              animation.type = kCATransitionPush
//              animation.subtype = kCATransitionFromTop
//              animation.duration = duration
//              layer.add(animation, forKey: kCATransitionPush)
////          }
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFromTop
        animation.duration = duration
        layer.add(animation, forKey: kCATransitionFromTop)
    }
}
