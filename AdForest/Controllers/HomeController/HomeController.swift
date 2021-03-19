//
//  HomeController.swift
//  AdForest
//
//  Created by apple on 3/8/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
import NVActivityIndicatorView
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseCore
import FirebaseInstanceID
import GoogleMobileAds
import IQKeyboardManagerSwift

var admobDelegate = AdMobDelegate()
var currentVc: UIViewController!

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, AddDetailDelegate, CategoryDetailDelegate, UISearchBarDelegate, MessagingDelegate,UNUserNotificationCenterDelegate, NearBySearchDelegate, BlogDetailDelegate , LocationCategoryDelegate, SwiftyAdDelegate , GADInterstitialDelegate, UIGestureRecognizerDelegate,MarvelRelatedAddDetailDelegate,MarvelAddDetailDelegate{
    
    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "SearchSectionCell", bundle: nil), forCellReuseIdentifier: "SearchSectionCell")
            tableView.addSubview(refreshControl)
        }
    }
    @IBOutlet weak var oltAddPost: UIButton! {
        didSet {
            oltAddPost.circularButton()
            if let bgColor = defaults.string(forKey: "mainColor") {
                oltAddPost.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
        }
        
    }
    
    let keyboardManager = IQKeyboardManager.sharedManager()
    
    //MARK:- Properties
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    var defaults = UserDefaults.standard
    var dataArray = [HomeSlider]()
    var categoryArray = [CatIcon]()
    var featuredArray = [HomeAdd]()
    var latestAdsArray = [HomeAdd]()
    var blogObj : HomeLatestBlog?
    var catLocationsArray = [CatLocation]()
    var nearByAddsArray = [HomeAdd]()
    var searchSectionArray = [HomeSearchSection]()
    
    var isAdPositionSort = false
    var isShowLatest = false
    var isShowBlog = false
    var isShowNearby = false
    var isShowFeature = false
    var isShowLocationButton = false
    var isShowCategoryButton = false
    
    var featurePosition = ""
    var animalSectionTitle = ""
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    var addPosition = ["search_Cell"]
    var barButtonItems = [UIBarButtonItem]()
    
    var viewAllText = ""
    var catLocationTitle = ""
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    //var homeTitle = ""
    var numberOfColumns:CGFloat = 0
    var heightConstraintTitleLatestad = 0
    var heightConstraintTitlead = 0
    var inters : GADInterstitial!
    
    var isAdvanceSearch:Bool = false
    var latColHeight: Double = 0
    var fetColHeight: Double = 0
    var SliderColHeight: Double = 0
    var showVertical:Bool = false
    var showVerticalAds: String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var latestHorizontalSingleAd:String = UserDefaults.standard.string(forKey: "homescreenLayout")!
    var adDetailStyle: String = UserDefaults.standard.string(forKey: "adDetailStyle")!
    
    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // self.navigationController?.isNavigationBarHidden = false
        inters = GADInterstitial(adUnitID:"ca-app-pub-2596107136418753/4126592208")
        let request = GADRequest()
        // request.testDevices = [(kGADSimulatorID as! String),"79e5cafdc063cca47a7b4158f482669ad5a74c2b"]
        inters.load(request)
        self.hideKeyboard()
        self.googleAnalytics(controllerName: "Home Controller")
        self.adForest_sendFCMToken()
        self.subscribeToTopicMessage()
        self.showLoader()
        self.adForest_homeData()
        self.addLeftBarButtonWithImage()
        self.navigationButtons()
        self.adForest_homeData()
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
            self.oltAddPost.isHidden = false
        }
        currentVc = self
        //self.adForest_homeData()
        
    }
    
    @objc func refreshTableView() {
        self.adForest_homeData()
        //        self.perform(#selector(self.nokri_showNavController1), with: nil, afterDelay: 0.5)
        tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    
    
    
    //MARK:- Topic Message
    func subscribeToTopicMessage() {
        if defaults.bool(forKey: "isLogin") {
            Messaging.messaging().shouldEstablishDirectChannel = true
            Messaging.messaging().subscribe(toTopic: "global")
            
        }
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    //MARK:- go to add detail controller
    func goToAddDetail(ad_id: Int) {
        if adDetailStyle == "style1"{
            let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
            addDetailVC.ad_id = ad_id
            self.navigationController?.pushViewController(addDetailVC, animated: true)
            
        }
        else{
            let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MarvelAdDetailViewController") as! MarvelAdDetailViewController
            addDetailVC.ad_id = ad_id
            self.navigationController?.pushViewController(addDetailVC, animated: true)
            
        }
    }
    
    //MARK:- go to category detail
    func goToCategoryDetail(id: Int) {
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
        categoryVC.categoryID = id
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- Go to Location detail
    func goToCLocationDetail(id: Int) {
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
        categoryVC.categoryID = id
        categoryVC.isFromLocation = true
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- Go to blog detail
    func blogPostID(ID: Int) {
        let blogDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "BlogDetailController") as! BlogDetailController
        blogDetailVC.post_id = ID
        self.navigationController?.pushViewController(blogDetailVC, animated: true)
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
        let HomeButton = UIButton(type: .custom)
        let ho = UIImage(named: "home")?.withRenderingMode(.alwaysTemplate)
        HomeButton.setBackgroundImage(ho, for: .normal)
        HomeButton.tintColor = UIColor.white
        HomeButton.setImage(ho, for: .normal)
        //        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
        //            HomeButton.isHidden = true
        //        }
        if #available(iOS 11, *) {
            searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
            searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            HomeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        HomeButton.addTarget(self, action: #selector(actionHome), for: .touchUpInside)
        let homeItem = UIBarButtonItem(customView: HomeButton)
        if defaults.bool(forKey: "showHome") {
            barButtonItems.append(homeItem)
            //self.barButtonItems.append(homeItem)
        }
        
        //Location Search
        let locationButton = UIButton(type: .custom)
        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
            locationButton.isHidden = true
        }
        
        if #available(iOS 11, *) {
            locationButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
            locationButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else {
            locationButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        let image = UIImage(named: "location")?.withRenderingMode(.alwaysTemplate)
        locationButton.setBackgroundImage(image, for: .normal)
        locationButton.tintColor = UIColor.white
        locationButton.addTarget(self, action: #selector(onClicklocationButton), for: .touchUpInside)
        let barButtonLocation = UIBarButtonItem(customView: locationButton)
        if defaults.bool(forKey: "showNearBy") {
            self.barButtonItems.append(barButtonLocation)
        }
        //Search Button
        let searchButton = UIButton(type: .custom)
        //       if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
        //           searchButton.isHidden = true
        //       }
        if defaults.bool(forKey: "advanceSearch") == true{
            let con = UIImage(named: "controls")?.withRenderingMode(.alwaysTemplate)
            searchButton.setBackgroundImage(con, for: .normal)
            searchButton.tintColor = UIColor.white
            searchButton.setImage(con, for: .normal)
        }else{
            let con = UIImage(named: "search")?.withRenderingMode(.alwaysTemplate)
            searchButton.setBackgroundImage(con, for: .normal)
            searchButton.tintColor = UIColor.white
            searchButton.setImage(con, for: .normal)
        }
        
        if #available(iOS 11, *) {
            searchBarNavigation.widthAnchor.constraint(equalToConstant: 30).isActive = true
            searchBarNavigation.heightAnchor.constraint(equalToConstant: 30).isActive = true
        } else {
            searchButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        }
        searchButton.addTarget(self, action: #selector(actionSearch), for: .touchUpInside)
        let searchItem = UIBarButtonItem(customView: searchButton)
        if defaults.bool(forKey: "showSearch") {
            barButtonItems.append(searchItem)
            //self.barButtonItems.append(searchItem)
        }
        
        self.navigationItem.rightBarButtonItems = barButtonItems
        
    }
    
    @objc func actionHome() {
        appDelegate.moveToHome()
    }
    
    @objc func onClicklocationButton() {
        let locationVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationSearch") as! LocationSearch
        locationVC.delegate = self
        view.transform = CGAffineTransform(scaleX: 0.8, y: 1.2)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = .identity
        }) { (success) in
            self.navigationController?.pushViewController(locationVC, animated: true)
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
    
    //MARK:- AdMob Delegate Methods
    
    func swiftyAdDidOpen(_ swiftyAd: SwiftyAd) {
        print("Open")
    }
    
    func swiftyAdDidClose(_ swiftyAd: SwiftyAd) {
        print("Close")
    }
    
    func swiftyAd(_ swiftyAd: SwiftyAd, didRewardUserWithAmount rewardAmount: Int) {
        print(rewardAmount)
    }
    
    
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isAdPositionSort {
            return addPosition.count
        }
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var value = 0
        if isAdPositionSort {
            
            let position = addPosition[section]
            if position == "sliders" {
                value = dataArray.count
            }
            else {
                value = 1
            }
        }
        // Else Condition of Second Type
        else {
            if featurePosition == "1" {
                if section == 0 {
                    value = 1
                } else if section == 1 {
                    if isShowFeature {
                        value = 1
                    } else {
                        value = 0
                    }
                } else if section == 2 {
                    value = 1
                } else if section == 3 {
                    value = dataArray.count
                }
            } else if featurePosition == "2" {
                if section == 0 {
                    value = 1
                } else if section == 1 {
                    value = 1
                } else if section == 2 {
                    if isShowFeature {
                        value = 1
                    } else {
                        value = 0
                    }
                } else if section == 3 {
                    value = dataArray.count
                }
            } else if featurePosition == "3" {
                if section == 0 {
                    value = 1
                } else if section == 1 {
                    value = 1
                } else if section == 2 {
                    value = dataArray.count
                } else if section == 3 {
                    if isShowFeature {
                        value = 1
                    } else {
                        value = 0
                    }
                }
            }
        }
        return value
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        if isAdPositionSort {
            let position = addPosition[section]
            switch position {
            case "search_Cell":
                let cell: SearchSectionCell = tableView.dequeueReusableCell(withIdentifier: "SearchSectionCell", for: indexPath) as! SearchSectionCell
                let objData = searchSectionArray[indexPath.row]
                
                let dataCat = AddsHandler.sharedInstance.objHomeData
                cell.dataCatLoc = (dataCat?.catLocations)!
                
                if objData.isShow {
                    if let imgUrl = URL(string: objData.image) {
                        cell.imgPicture.sd_setShowActivityIndicatorView(true)
                        cell.imgPicture.sd_setIndicatorStyle(.gray)
                        cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                    }
                    if let title = objData.mainTitle {
                        cell.lblTitle.text = title
                    }
                    if let subTitle = objData.subTitle {
                        cell.lblSubTitle.text = subTitle
                    }
                    if let placeHolder = objData.placeholder {
                        cell.txtSearch.placeholder = placeHolder
                    }
                    
                    if UserDefaults.standard.bool(forKey: "isRtl") {
                        cell.lblTitle.textAlignment = .right
                        cell.lblSubTitle.textAlignment = .right
                    } else {
                        cell.lblTitle.textAlignment = .left
                        cell.lblSubTitle.textAlignment = .left
                    }
                    
                    if objData.isShowLocation == false{
                        cell.viewLoc.isHidden = true
                        cell.topConstraintSearch.constant =  -40
                    }
                    
                }
                cell.txtFielLoc.text = ""
                UserDefaults.standard.set(0, forKey: "locId")
                return cell
            case "blogNews":
                if self.isShowBlog {
                    let cell: HomeBlogCell = tableView.dequeueReusableCell(withIdentifier: "HomeBlogCell", for: indexPath) as! HomeBlogCell
                    let objData = blogObj
                    if let name = objData?.text {
                        cell.lblName.text = name
                    }
                    cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    cell.btnViewAll = { () in
                        let blogVC = self.storyboard?.instantiateViewController(withIdentifier: "BlogController") as! BlogController
                        blogVC.isFromHomeBlog = true
                        self.navigationController?.pushViewController(blogVC, animated: true)
                    }
                    cell.dataArray = (objData?.blogs)!
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    
                    return cell
                }
            case "cat_icons":
                let cell: CategoriesTableCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath) as! CategoriesTableCell
                let data = AddsHandler.sharedInstance.objHomeData
                
                
                if self.isShowCategoryButton == true {
                    cell.oltViewAll.isHidden = false
                    if let viewAllText = data?.catIconsColumnBtn.text {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    cell.btnViewAll = { () in
                        let categoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailController") as! CategoryDetailController
                        categoryDetailVC.newHome = false
                        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
                    }
                } else {
                    cell.oltViewAll.isHidden = true
                }
                cell.numberOfColums = self.numberOfColumns
                cell.categoryArray  = self.categoryArray
                cell.delegate = self
                cell.collectionView.reloadData()
                return cell
            case "featured_ads":
                if isShowFeature {
                    if latestHorizontalSingleAd == "horizental"{
                        
                        
                        let cell: MarvelHomeFeatureAddCell = tableView.dequeueReusableCell(withIdentifier: "MarvelHomeFeatureAddCell", for: indexPath) as! MarvelHomeFeatureAddCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        fetColHeight = Double(cell.collectionView.contentSize.height)
                        cell.collectionView.backgroundColor = UIColor.clear
                        cell.contentView.backgroundColor = UIColor.clear
                        cell.containerView.backgroundColor = UIColor.clear
                        cell.dataArray = featuredArray
                        cell.delegate = self
                        cell.calledFrom = "home1"
                        cell.collectionView.reloadData()
                        return cell
                    }
                    else{
                        let cell: HomeFeatureAddCell = tableView.dequeueReusableCell(withIdentifier: "HomeFeatureAddCell", for: indexPath) as! HomeFeatureAddCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        cell.dataArray = featuredArray
                        cell.delegate = self
                        fetColHeight = Double(cell.collectionView.contentSize.height)
                        print(latColHeight)
                        if latestHorizontalSingleAd == "horizental" {
                            fetColHeight = Double(cell.collectionView.contentSize.height)
                        }
                       

                        cell.collectionView.reloadData()
                        return cell
                    }
                }
            case "latest_ads":
                if isShowLatest {
                    if latestHorizontalSingleAd == "horizental"{
                        let cell: MarvelAdsTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "MarvelAdsTableViewCell", for: indexPath) as! MarvelAdsTableViewCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        let objData = AddsHandler.sharedInstance.objLatestAds
                        if let sectionTitle = objData?.text {
                            cell.lblSectionTitle.text = sectionTitle
                        }
                        if let viewAllText = data?.viewAll {
                            cell.oltViewAll.setTitle(viewAllText, for: .normal)
                        }
                        
                        cell.btnViewAll = { () in
                            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                            self.navigationController?.pushViewController(categoryVC, animated: true)
                        }
                        cell.dataArray = latestAdsArray
                        latColHeight = Double(cell.collectionView.contentSize.height)
                        print(latColHeight)
                        if latestHorizontalSingleAd == "horizental" {
                            latColHeight = Double(cell.collectionView.contentSize.height)
                        }

                        cell.collectionView.backgroundColor = UIColor.clear
                        cell.contentView.backgroundColor = UIColor.clear
                        cell.containerView.backgroundColor = UIColor.clear
                        cell.delegate = self
                        
                        
                        cell.reloadData()
                            return cell
                    }
                    else{
                        let cell: LatestAddsCell  = tableView.dequeueReusableCell(withIdentifier: "LatestAddsCell", for: indexPath) as! LatestAddsCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        let objData = AddsHandler.sharedInstance.objLatestAds
                        
                        if let sectionTitle = objData?.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        if let viewAllText = data?.viewAll {
                            cell.oltViewAll.setTitle(viewAllText, for: .normal)
                        }
                        cell.btnViewAll = { () in
                            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                            self.navigationController?.pushViewController(categoryVC, animated: true)
                        }
                        cell.delegate = self
                        cell.dataArray = self.latestAdsArray
                        heightConstraintTitleLatestad = Int(cell.heightConstraintTitle.constant)
                        latColHeight = Double(cell.collectionView.contentSize.height)
                        print(latColHeight)
                        if latestHorizontalSingleAd == "horizental" {
                            latColHeight = Double(cell.collectionView.contentSize.height)
                        }
                        cell.collectionView.reloadData()
                        return cell

                    }
                   
                }
            case "cat_locations":
                let cell: HomeNearAdsCell = tableView.dequeueReusableCell(withIdentifier: "HomeNearAdsCell", for: indexPath) as! HomeNearAdsCell
                let data = AddsHandler.sharedInstance.objHomeData
                
                if self.isShowLocationButton {
                    cell.oltViewAll.isHidden = false
                    if let viewAllText = data?.catLocationsBtn.text {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    cell.btnViewAction = { () in
                        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDetailController") as! LocationDetailController
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                } else {
                    cell.oltViewAll.isHidden = true
                }
                cell.lblTitle.text = catLocationTitle
                cell.dataArray = catLocationsArray
                cell.delegate = self
                cell.collectionView.reloadData()
                return cell
            case "sliders":
                if latestHorizontalSingleAd == "horizental"{
                    let cell: MarvelAdsTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "MarvelAdsTableViewCell", for: indexPath) as! MarvelAdsTableViewCell
                    let objData = dataArray[indexPath.row]
                    let data = AddsHandler.sharedInstance.objHomeData
                    
                    if let sectionTitle = objData.name {
                        cell.lblSectionTitle.text = sectionTitle
                    }
                    if let viewAllText = data?.viewAll {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    cell.btnViewAll = { () in
                        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                        self.navigationController?.pushViewController(categoryVC, animated: true)
                    }
                    if latestHorizontalSingleAd == "horizental" {
                        SliderColHeight = Double(cell.collectionView.contentSize.height)
                    }
                    cell.collectionView.backgroundColor = UIColor.clear
                    cell.contentView.backgroundColor = UIColor.clear
                    cell.containerView.backgroundColor = UIColor.clear
                    cell.dataArray = objData.data
                    cell.delegate = self
                    cell.reloadData()
                    return cell
                }else{
                    let cell: AddsTableCell  = tableView.dequeueReusableCell(withIdentifier: "AddsTableCell", for: indexPath) as! AddsTableCell
                    let objData = dataArray[indexPath.row]
                    let data = AddsHandler.sharedInstance.objHomeData
                    
                    if let sectionTitle = objData.name {
                        cell.lblSectionTitle.text = sectionTitle
                    }
                    if let viewAllText = data?.viewAll {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    
                    cell.btnViewAll = { () in
                        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                        categoryVC.categoryID = objData.catId
                        self.navigationController?.pushViewController(categoryVC, animated: true)
                    }
                    SliderColHeight = Double(cell.collectionView.contentSize.height)
                    
                    print(SliderColHeight)
                    if latestHorizontalSingleAd == "horizental" {
                        SliderColHeight = Double(cell.collectionView.contentSize.height)
                    }
                    cell.dataArray = objData.data
                    cell.delegate = self
                    
                    heightConstraintTitlead = Int(cell.heightConstraintTitle.constant)
                    
                    cell.reloadData()
                    return cell
                }
                
            case "nearby":
                if self.isShowNearby {
                    let cell: AddsTableCell = tableView.dequeueReusableCell(withIdentifier: "AddsTableCell", for: indexPath) as! AddsTableCell
                    let data = AddsHandler.sharedInstance.objHomeData
                    
                    if let viewAllText = data?.viewAll {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    cell.btnViewAll = { () in
                        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                        self.navigationController?.pushViewController(categoryVC, animated: true)
                    }
                    SliderColHeight = Double(cell.collectionView.contentSize.height)
                    
                    print(SliderColHeight)
                    if latestHorizontalSingleAd == "horizental" {
                        SliderColHeight = Double(cell.collectionView.contentSize.height)
                    }
                    
                    cell.delegate = self
                    cell.lblSectionTitle.text = self.nearByTitle
                    cell.dataArray = self.nearByAddsArray
                    cell.collectionView.reloadData()
                    return cell
                }
            default:
                break
            }
        }
        else {
            if featurePosition == "1" {
                if section == 0 {
                    let cell: SearchSectionCell = tableView.dequeueReusableCell(withIdentifier: "SearchSectionCell", for: indexPath) as! SearchSectionCell
                    let objData = searchSectionArray[indexPath.row]
                    if objData.isShow {
                        if let imgUrl = URL(string: objData.image) {
                            cell.imgPicture.sd_setShowActivityIndicatorView(true)
                            cell.imgPicture.sd_setIndicatorStyle(.gray)
                            cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                        }
                        if let title = objData.mainTitle {
                            cell.lblTitle.text = title
                        }
                        if let subTitle = objData.subTitle {
                            cell.lblSubTitle.text = subTitle
                        }
                        if let placeHolder = objData.placeholder {
                            cell.txtSearch.placeholder = placeHolder
                        }
                    }
                    return cell
                }
                else if section == 1 {
                    if isShowFeature {
                        let cell: HomeFeatureAddCell = tableView.dequeueReusableCell(withIdentifier: "HomeFeatureAddCell", for: indexPath) as! HomeFeatureAddCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        cell.dataArray = featuredArray
                        cell.delegate = self
                        cell.collectionView.reloadData()
                        return cell
                    }
                }
                else if section == 2 {
                    let cell: CategoriesTableCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath) as! CategoriesTableCell
                    let data = AddsHandler.sharedInstance.objHomeData
                    if let viewAllText = data?.catIconsColumnBtn.text {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    cell.btnViewAll = { () in
                        let categoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailController") as! CategoryDetailController
                        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
                    }
                    cell.numberOfColums = self.numberOfColumns
                    cell.categoryArray  = self.categoryArray
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    return cell
                }
                else if section == 3 {
                    let cell: AddsTableCell  = tableView.dequeueReusableCell(withIdentifier: "AddsTableCell", for: indexPath) as! AddsTableCell
                    let objData = dataArray[indexPath.row]
                    let data = AddsHandler.sharedInstance.objHomeData
                    
                    if let sectionTitle = objData.name {
                        cell.lblSectionTitle.text = sectionTitle
                    }
                    if let viewAllText = data?.viewAll {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    cell.btnViewAll = { () in
                        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                        categoryVC.categoryID = objData.catId
                        self.navigationController?.pushViewController(categoryVC, animated: true)
                    }
                    cell.dataArray = objData.data
                    cell.delegate = self
                    cell.reloadData()
                    return cell
                }
            }
            else if featurePosition == "2" {
                if section == 0 {
                    let cell: SearchSectionCell = tableView.dequeueReusableCell(withIdentifier: "SearchSectionCell", for: indexPath) as! SearchSectionCell
                    let objData = searchSectionArray[indexPath.row]
                    if objData.isShow {
                        if let imgUrl = URL(string: objData.image) {
                            cell.imgPicture.sd_setShowActivityIndicatorView(true)
                            cell.imgPicture.sd_setIndicatorStyle(.gray)
                            cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                        }
                        if let title = objData.mainTitle {
                            cell.lblTitle.text = title
                        }
                        if let subTitle = objData.subTitle {
                            cell.lblSubTitle.text = subTitle
                        }
                        if let placeHolder = objData.placeholder {
                            cell.txtSearch.placeholder = placeHolder
                        }
                    }
                    return cell
                }
                else  if section == 1 {
                    let cell: CategoriesTableCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath) as! CategoriesTableCell
                    let data = AddsHandler.sharedInstance.objHomeData
                    if let viewAllText = data?.catIconsColumnBtn.text {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    cell.btnViewAll = { () in
                        let categoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailController") as! CategoryDetailController
                        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
                    }
                    cell.numberOfColums = self.numberOfColumns
                    cell.categoryArray  = self.categoryArray
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    return cell
                }
                else if section == 2 {
                    if isShowFeature {
                        let cell: HomeFeatureAddCell = tableView.dequeueReusableCell(withIdentifier: "HomeFeatureAddCell", for: indexPath) as! HomeFeatureAddCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        cell.dataArray = featuredArray
                        cell.delegate = self
                        cell.collectionView.reloadData()
                        return cell
                    }
                }
                else if section == 3 {
                    let cell: AddsTableCell  = tableView.dequeueReusableCell(withIdentifier: "AddsTableCell", for: indexPath) as! AddsTableCell
                    let objData = dataArray[indexPath.row]
                    let data = AddsHandler.sharedInstance.objHomeData
                    
                    if let sectionTitle = objData.name {
                        cell.lblSectionTitle.text = sectionTitle
                    }
                    if let viewAllText = data?.viewAll {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    
                    cell.btnViewAll = { () in
                        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                        categoryVC.categoryID = objData.catId
                        self.navigationController?.pushViewController(categoryVC, animated: true)
                    }
                    cell.dataArray = objData.data
                    cell.delegate = self
                    cell.reloadData()
                    return cell
                }
            }
            
            else if featurePosition == "3" {
                if section == 0 {
                    let cell: SearchSectionCell = tableView.dequeueReusableCell(withIdentifier: "SearchSectionCell", for: indexPath) as! SearchSectionCell
                    let objData = searchSectionArray[indexPath.row]
                    if objData.isShow {
                        if let imgUrl = URL(string: objData.image) {
                            cell.imgPicture.sd_setShowActivityIndicatorView(true)
                            cell.imgPicture.sd_setIndicatorStyle(.gray)
                            cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
                        }
                        if let title = objData.mainTitle {
                            cell.lblTitle.text = title
                        }
                        if let subTitle = objData.subTitle {
                            cell.lblSubTitle.text = subTitle
                        }
                        if let placeHolder = objData.placeholder {
                            cell.txtSearch.placeholder = placeHolder
                        }
                    }
                    return cell
                } else if section == 1 {
                    let cell: CategoriesTableCell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell", for: indexPath) as! CategoriesTableCell
                    let data = AddsHandler.sharedInstance.objHomeData
                    if let viewAllText = data?.catIconsColumnBtn.text {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    cell.btnViewAll = { () in
                        let categoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailController") as! CategoryDetailController
                        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
                    }
                    cell.numberOfColums = self.numberOfColumns
                    cell.categoryArray  = self.categoryArray
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    return cell
                } else if section == 2 {
                    let cell: AddsTableCell  = tableView.dequeueReusableCell(withIdentifier: "AddsTableCell", for: indexPath) as! AddsTableCell
                    let objData = dataArray[indexPath.row]
                    let data = AddsHandler.sharedInstance.objHomeData
                    
                    if let sectionTitle = objData.name {
                        cell.lblSectionTitle.text = sectionTitle
                    }
                    if let viewAllText = data?.viewAll {
                        cell.oltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    
                    cell.btnViewAll = { () in
                        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                        categoryVC.categoryID = objData.catId
                        self.navigationController?.pushViewController(categoryVC, animated: true)
                    }
                    cell.dataArray = objData.data
                    cell.delegate = self
                    cell.reloadData()
                    return cell
                } else if section == 3 {
                    if isShowFeature {
                        let cell: HomeFeatureAddCell = tableView.dequeueReusableCell(withIdentifier: "HomeFeatureAddCell", for: indexPath) as! HomeFeatureAddCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        cell.dataArray = featuredArray
                        cell.delegate = self
                        cell.collectionView.reloadData()
                        return cell
                    }
                }
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        var totalHeight : CGFloat = 0
        var height: CGFloat = 0
        if isAdPositionSort {
            let position = addPosition[section]
            if position == "search_Cell" {
                let objData = searchSectionArray[indexPath.row]
                if objData.isShow {
                    height = 60
                } else {
                    height = 0
                }
            }
            else if position == "cat_icons" {
                if Constants.isiPadDevice {
                    height = 230
                } else {
                    if numberOfColumns == 3 {
                        let itemHeight = CollectionViewSettings.getItemWidth(boundWidth: tableView.bounds.size.width)
                        // maizer
                        let totalRow = ceil(CGFloat(categoryArray.count) / 2 )
                        let totalTopBottomOffSet = CollectionViewSettings.offset + CollectionViewSettings.offset
                        let totalSpacing = CGFloat(totalRow ) * CollectionViewSettings.minLineSpacing
                        // maizer
//                        if Constants.isiPhone5 {
//                            totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 170)
//                        } else {
//                            totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 140)
//                        }
                        
                        if Constants.isiPhone5 {
                            totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 170)
                        } else {
                            totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 140)
                        }
                        
                        height =  totalHeight
                    } else if numberOfColumns == 4 {
                        let itemHeight = CollectionViewForuCell.getItemWidth(boundWidth: tableView.bounds.size.width)
                        let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewForuCell.column)
                        let totalTopBottomOffSet = CollectionViewForuCell.offset + CollectionViewForuCell.offset
                        let totalSpacing = CGFloat(totalRow - 1) * CollectionViewForuCell.minLineSpacing
                        if Constants.isiPhone5 {
                            totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 120)
                        } else {
                            totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 210)
                        }
                        height =  totalHeight
                    }
                }
            }
            else if position == "cat_locations"  {
                if categoryArray.isEmpty {
                    height = 0
                } else {
                    if self.isShowLocationButton {
                        height = 250
                    } else {
                        height = 225
                    }
                }
            } else if position == "nearby" {
                if isShowNearby {
                    if showVerticalAds == "vertical" {
                        height = CGFloat(SliderColHeight) + 70
                    } else if latestHorizontalSingleAd == "horizental"{
                        height = CGFloat(SliderColHeight) + 70
                        
                    }else{
                        height = 270
                        
                    }
                } else {
                    height = 0
                }
            } else if position == "sliders" {
                if dataArray.isEmpty {
                    height = 0
                }
                else if showVerticalAds == "vertical" {
                    height = CGFloat(SliderColHeight) + 70
                } else if latestHorizontalSingleAd == "horizental"{
                    height = CGFloat(SliderColHeight) + 70
                    
                }
                else {
                    height = CGFloat(290 + heightConstraintTitlead)
                }
            } else if position == "blogNews"{
                if self.isShowBlog {
                    height = 270
                } else {
                    height = 0
                }
            } else if position == "featured_ads" {
                if self.isShowFeature {
                    if featuredArray.isEmpty {
                        height = 0
                    }
                    else {
                        height = 270
                    }
                    if showVerticalAds == "vertical" {
                        height = CGFloat(fetColHeight) + 70
                    } else if latestHorizontalSingleAd == "horizental" {
                        height = CGFloat(fetColHeight) + 70
                    }
                } else {
                    height = 0
                }
            } else if position ==  "latest_ads" {
                if self.isShowLatest {
                    
                    if showVerticalAds == "vertical" {
                        height = CGFloat(latColHeight) + 70
                        
                    }else if latestHorizontalSingleAd == "horizental" {
                        height = CGFloat(latColHeight) + 70
                    }
                    else{
                        height = CGFloat(290 + heightConstraintTitleLatestad)
                    }
                } else {
                    height = 0
                }
            } else {
                height = 0
            }
        } else {
            if featurePosition == "1" {
                if section == 0 {
                    let objData = searchSectionArray[indexPath.row]
                    if objData.isShow {
                        height = 250
                    } else {
                        height = 0
                    }
                }
                else if section == 1 {
                    height = 270
                }
                else if section == 2 {
                    if Constants.isiPadDevice {
                        height = 220
                    }
                    else {
                        if numberOfColumns == 3 {
                            let itemHeight = CollectionViewSettings.getItemWidth(boundWidth: tableView.bounds.size.width)
                            let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewSettings.column)
                            let totalTopBottomOffSet = CollectionViewSettings.offset + CollectionViewSettings.offset
                            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewSettings.minLineSpacing
                            if Constants.isiPhone5 {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 80)
                            } else {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 60)
                            }
                            height =  totalHeight
                        } else if numberOfColumns == 4 {
                            let itemHeight = CollectionViewForuCell.getItemWidth(boundWidth: tableView.bounds.size.width)
                            let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewForuCell.column)
                            let totalTopBottomOffSet = CollectionViewForuCell.offset + CollectionViewForuCell.offset
                            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewForuCell.minLineSpacing
                            if Constants.isiPhone5 {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 170)
                            } else {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 140)
                            }
                            height =  totalHeight
                        }
                    }
                }
                else if section == 3 {
                    height = 270
                }
            }
            else if featurePosition == "2" {
                if section == 0 {
                    let objData = searchSectionArray[indexPath.row]
                    if objData.isShow {
                        height = 250
                    } else {
                        height = 0
                    }
                }
                else if section == 1 {
                    if Constants.isiPadDevice {
                        height = 220
                    } else {
                        if numberOfColumns == 3 {
                            let itemHeight = CollectionViewSettings.getItemWidth(boundWidth: tableView.bounds.size.width)
                            let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewSettings.column)
                            let totalTopBottomOffSet = CollectionViewSettings.offset + CollectionViewSettings.offset
                            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewSettings.minLineSpacing
                            if Constants.isiPhone5 {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 80)
                            } else {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 60)
                            }
                            height =  totalHeight
                        } else if numberOfColumns == 4 {
                            let itemHeight = CollectionViewForuCell.getItemWidth(boundWidth: tableView.bounds.size.width)
                            let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewForuCell.column)
                            let totalTopBottomOffSet = CollectionViewForuCell.offset + CollectionViewForuCell.offset
                            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewForuCell.minLineSpacing
                            if Constants.isiPhone5 {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 170)
                            } else {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 140)
                            }
                            height =  totalHeight
                        }
                    }
                }
                else if section ==  2 {
                    height = 270
                }
                else if section == 3 {
                    height = 270
                }
            }
            else if featurePosition == "3" {
                if section == 0 {
                    let objData = searchSectionArray[indexPath.row]
                    if objData.isShow {
                        height = 250
                    } else {
                        height = 0
                    }
                } else if section == 1 {
                    if Constants.isiPadDevice {
                        height = 220
                    }
                    else {
                        if numberOfColumns == 3 {
                            let itemHeight = CollectionViewSettings.getItemWidth(boundWidth: tableView.bounds.size.width)
                            let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewSettings.column)
                            let totalTopBottomOffSet = CollectionViewSettings.offset + CollectionViewSettings.offset
                            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewSettings.minLineSpacing
                            if Constants.isiPhone5 {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 80)
                            } else {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 60)
                            }
                            height =  totalHeight
                        } else if numberOfColumns == 4 {
                            let itemHeight = CollectionViewForuCell.getItemWidth(boundWidth: tableView.bounds.size.width)
                            let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewForuCell.column)
                            let totalTopBottomOffSet = CollectionViewForuCell.offset + CollectionViewForuCell.offset
                            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewForuCell.minLineSpacing
                            if Constants.isiPhone5 {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 170)
                            } else {
                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 140)
                            }
                            height =  totalHeight
                        }
                    }
                }
                else if section == 2 {
                    height = 270
                }
                else if section == 3 {
                    height = 270
                }
            }
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    
    
    //    private var finishedLoadingInitialTableCells = false
    //     func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    //
    //        var lastInitialDisplayableCell = false
    //
    //        //change flag as soon as last displayable cell is being loaded (which will mean table has initially loaded)
    ////        if favorites.itemes.count > 0 && !finishedLoadingInitialTableCells {
    //            if let indexPathsForVisibleRows = tableView.indexPathsForVisibleRows,
    //                let lastIndexPath = indexPathsForVisibleRows.last, lastIndexPath.row == indexPath.row {
    //                lastInitialDisplayableCell = true
    //            }
    ////        }
    //
    //        if !finishedLoadingInitialTableCells {
    //
    //            if lastInitialDisplayableCell {
    //                finishedLoadingInitialTableCells = true
    //            }
    //
    //            //animates the cell as it is being displayed for the first time
    //            do {
    //                let startFromHeight = tableView.frame.height
    //                cell.layer.transform = CATransform3DMakeTranslation(0, startFromHeight, 0)
    //                let delay = Double(indexPath.row) * 0.2
    //
    //                UIView.animate(withDuration: 0.2, delay: delay, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
    //                    do {
    //                        cell.layer.transform = CATransform3DIdentity
    //                    }
    //                }) { (success:Bool) in
    //
    //                }
    //            }
    //        }
    //    }
    
    
    
    //MARK:- IBActions
    @IBAction func actionAddPost(_ sender: UIButton) {
        
        let notVerifyMsg = UserDefaults.standard.string(forKey: "not_Verified")
        let can = UserDefaults.standard.bool(forKey: "can")
        
        if defaults.bool(forKey: "isGuest") || defaults.bool(forKey: "isLogin") == false {
            
            var msgLogin = ""
            
            if let msg = self.defaults.string(forKey: "notLogin") {
                msgLogin = msg
            }
            
            let alert = Constants.showBasicAlert(message: msgLogin)
            self.presentVC(alert)
            
        }else if can == false{
            
            
            var buttonOk = ""
            var buttonCancel = ""
            if let settingsInfo = defaults.object(forKey: "settings") {
                let  settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                let model = SettingsRoot(fromDictionary: settingObject)
                
                if let okTitle = model.data.internetDialog.okBtn {
                    buttonOk = okTitle
                }
                if let cancelTitle = model.data.internetDialog.cancelBtn {
                    buttonCancel = cancelTitle
                }
                
                let alertController = UIAlertController(title: "Alert", message: notVerifyMsg, preferredStyle: .alert)
                let okBtn = UIAlertAction(title: buttonOk, style: .default) { (ok) in
                    self.appDelegate.moveToProfile()
                }
                let cancelBtn = UIAlertAction(title: buttonCancel, style: .cancel, handler: nil)
                alertController.addAction(okBtn)
                alertController.addAction(cancelBtn)
                self.presentVC(alertController)
                
            }
            
        }
        else{
            let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AadPostController") as! AadPostController
            self.navigationController?.pushViewController(adPostVC, animated: true)
        }
        
        
    }
    
    //MARK:- API Call
    
    //get home data
    func adForest_homeData() {
        
        dataArray.removeAll()
        categoryArray.removeAll()
        featuredArray.removeAll()
        latestAdsArray.removeAll()
        
        catLocationsArray.removeAll()
        nearByAddsArray.removeAll()
        searchSectionArray.removeAll()
        addPosition.removeAll()
        
        AddsHandler.homeData(success: { (successResponse) in
            self.stopAnimating()
            
            if successResponse.success {
                
                let tabController = self.parent as? UITabBarController
//                tabController?.navigationItem.title = successResponse.data.pageTitle
//                self.title = successResponse.data.pageTitle
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 39, height: 39))
                imageView.contentMode = .scaleAspectFit
                let image = UIImage(named: "dlogo")
                imageView.image = image
                tabController?.navigationItem.titleView = imageView
                
                
                if let column = successResponse.data.catIconsColumn {
                    let columns = Int(column)
                    self.numberOfColumns = CGFloat(columns!)
                }
                //To Show Title After Search Bar Hidden
                self.viewAllText = successResponse.data.viewAll
                
                //Get value of show/hide buttons of location and categories
                if successResponse.data.catIconsColumnBtn != nil {
                    self.isShowCategoryButton = successResponse.data.catIconsColumnBtn.isShow
                    print(self.isShowCategoryButton)
                }
                if successResponse.data.catLocationsBtn != nil {
                    self.isShowLocationButton = successResponse.data.catLocationsBtn.isShow
                }
                UserDefaults.standard.set(successResponse.data.ad_post.can_post, forKey: "can")
                //UserDefaults.standard.set(true, forKey: "can")
                if let feature = successResponse.data.isShowFeatured {
                    self.isShowFeature = feature
                }
                if let feature = successResponse.data.featuredPosition {
                    self.featurePosition = feature
                }
                self.categoryArray = successResponse.data.catIcons
                self.dataArray = successResponse.data.sliders
                
                //Check Feature Ads is on or off and set add Position Sorter
                if self.isShowFeature {
                    self.featuredArray = successResponse.data.featuredAds.ads
                }
                if let isSort = successResponse.data.adsPositionSorter {
                    self.isAdPositionSort = isSort
                }
                self.addPosition = ["search_Cell"]
                if self.isAdPositionSort {
                    self.addPosition += successResponse.data.adsPosition
                    if let latest = successResponse.data.isShowLatest {
                        self.isShowLatest = latest
                    }
                    if self.isShowLatest {
                        self.latestAdsArray = successResponse.data.latestAds.ads
                    }
                    
                    if let showBlog = successResponse.data.isShowBlog {
                        self.isShowBlog = showBlog
                    }
                    if self.isShowBlog {
                        self.blogObj = successResponse.data.latestBlog
                    }
                    
                    if let showNearAds = successResponse.data.isShowNearby {
                        self.isShowNearby = showNearAds
                    }
                    if self.isShowNearby {
                        self.nearByTitle = successResponse.data.nearbyAds.text
                        if successResponse.data.nearbyAds.ads.isEmpty == false {
                            self.nearByAddsArray = successResponse.data.nearbyAds.ads
                        }
                    }
                    if successResponse.data.catLocations.isEmpty == false {
                        self.catLocationsArray = successResponse.data.catLocations
                        if let locationTitle = successResponse.data.catLocationsTitle {
                            self.catLocationTitle = locationTitle
                        }
                    }
                }
                AddsHandler.sharedInstance.objHomeData = successResponse.data
                AddsHandler.sharedInstance.objLatestAds = successResponse.data.latestAds
                AddsHandler.sharedInstance.topLocationArray = successResponse.data.appTopLocationList
                // Set Up AdMob Banner & Intersitial ID's
                UserHandler.sharedInstance.objAdMob = successResponse.settings.ads
                var isShowAd = false
                if let adShow = successResponse.settings.ads.show {
                    isShowAd = adShow
                }
                //                    if isShowAd {
                //                        SwiftyAd.shared.delegate = self
                //                        var isShowBanner = false
                //                        var isShowInterstital = false
                //
                //                        if let banner = successResponse.settings.ads.isShowBanner {
                //                            isShowBanner = banner
                //                        }
                //                        if let intersitial = successResponse.settings.ads.isShowInitial {
                //                            isShowInterstital = intersitial
                //                        }
                //                        if isShowBanner {
                //                            SwiftyAd.shared.setup(withBannerID: successResponse.settings.ads.bannerId, interstitialID: "", rewardedVideoID: "")
                //
                //                            print(successResponse.settings.ads.bannerId)
                //
                //                            self.tableView.translatesAutoresizingMaskIntoConstraints = false
                //                            if successResponse.settings.ads.position == "top" {
                //                                self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 45).isActive = true
                //                                SwiftyAd.shared.showBanner(from: self, at: .top)
                //                            } else {
                //                                self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 30).isActive = true
                //                                SwiftyAd.shared.showBanner(from: self, at: .bottom)
                //                            }
                //                        }
                //                        //ca-app-pub-6905547279452514/6461881125
                //                        if isShowInterstital {
                //                            //                        SwiftyAd.shared.setup(withBannerID: "", interstitialID: successResponse.settings.ads.interstitalId, rewardedVideoID: "")
                //                            //                        SwiftyAd.shared.showInterstitial(from: self, withInterval: 1)
                //
                //
                //                            self.showAd()
                //
                //                            //self.perform(#selector(self.showAd), with: nil, afterDelay: Double(successResponse.settings.ads.timeInitial)!)
                //                            //self.perform(#selector(self.showAd2), with: nil, afterDelay: Double(successResponse.settings.ads.time)!)
                //
                //                            self.perform(#selector(self.showAd), with: nil, afterDelay: Double(30))
                //                            self.perform(#selector(self.showAd2), with: nil, afterDelay: Double(30))
                //
                //
                //                        }
                //                    }
                // Here I set the Google Analytics Key
                var isShowAnalytic = false
                if let isShow = successResponse.settings.analytics.show {
                    isShowAnalytic = isShow
                }
                if isShowAnalytic {
                    if let analyticKey = successResponse.settings.analytics.id {
                        guard let gai = GAI.sharedInstance() else {
                            assert(false, "Google Analytics not configured correctly")
                            return
                        }
                        gai.tracker(withTrackingId: analyticKey)
                        gai.trackUncaughtExceptions = true
                    }
                }
                
                UserDefaults.standard.set(successResponse.data.ad_post.verMsg, forKey: "not_Verified")
                
                //Search Section Data
                self.searchSectionArray = [successResponse.data.searchSection]
                
                self.tableView.reloadData()
                
                //                let scrollPoint = CGPoint(x: 0, y: self.tableView.contentSize.height + self.tableView.contentSize.height + self.tableView.contentSize.height + self.tableView.contentSize.height + self.tableView.contentSize.height)
                //                self.tableView.setContentOffset(scrollPoint, animated: true)
                //                self.perform(#selector(self.nokri_showNavController1), with: nil, afterDelay: 0.5)
                
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
    
    @objc func nokri_showNavController1(){
        
        let scrollPoint = CGPoint(x: 0, y: 0)
        self.tableView.setContentOffset(scrollPoint, animated: true)
        
    }
    
    @objc func showAd(){
        currentVc = self
        admobDelegate.showAd()
    }
    
    @objc func showAd2(){
        currentVc = self
        admobDelegate.showAd()
    }
    
    //MARK:- Send fcm token to server
    func adForest_sendFCMToken() {
        var fcmToken = ""
        if let token = defaults.value(forKey: "fcmToken") as? String {
            fcmToken = token
        } else {
            fcmToken = appDelegate.deviceFcmToken
        }
        let param: [String: Any] = ["firebase_id": fcmToken]
        print(param)
        AddsHandler.sendFirebaseToken(parameter: param as NSDictionary, success: { (successResponse) in
            self.stopAnimating()
            print(successResponse)
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
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

extension UIViewController {
    func setupNavigationBar(title: String) {
        // back button without title
        self.navigationController?.navigationBar.topItem?.title = ""
        
        //set titile
        self.navigationItem.title = title
        
        let rightButton = UIBarButtonItem(image: UIImage(named: "home"), style: .plain, target: nil, action: nil)
        
        //show the Edit button item
        self.navigationItem.rightBarButtonItem = rightButton
    }
}

