//
//  MarvelHomeViewController.swift
//  AdForest
//
//  Created by Charlie on 27/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Firebase
import FirebaseMessaging
import UserNotifications
import FirebaseCore
import FirebaseInstanceID
import GoogleMobileAds
class MarvelHomeViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NVActivityIndicatorViewable, MarvelCategoryDetailDelegate,MarvelAddDetailDelegate,MarvelRelatedAddDetailDelegate,MarvelLatestAddDetailDelegate,AddDetailDelegate,LocationCategoryDelegate,BlogDetailDelegate,MarvelLocationCategoryDelegate,NearBySearchDelegate,MarvelDefVerAddDetailDelegate {
    
    
    
    
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.separatorStyle = .none
            tableView.register(UINib(nibName: "MarvelSearchSectionTableViewCell", bundle: nil), forCellReuseIdentifier: "MarvelSearchSectionTableViewCell")
            tableView.addSubview(refreshControl)
            
        }
    }
    
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    @IBOutlet weak var btnAddPost: UIButton!{
        didSet{
            btnAddPost.circularButton()
            if let bgColor = defaults.string(forKey: "mainColor") {
                btnAddPost.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
            
        }
        
    }
    
    
    
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
    //    var inters : GADInterstitial!
    
    var isAdvanceSearch:Bool = false
    var latColHeight: Double = 0
    var fetColHeight: Double = 0
    var SliderColHeight: Double = 0
    var nearByColHeight: Double = 0


    var featuredAdLayout: String = UserDefaults.standard.string(forKey: "featuredAdsLayout")!
    var latestAdLayout: String = UserDefaults.standard.string(forKey: "latestAdsLayout")!
    var nearbyAdLayout: String = UserDefaults.standard.string(forKey: "nearByAdsLayout")!
    var sliderAdsLayout: String = UserDefaults.standard.string(forKey: "sliderAdsLayout")!
    var catSectionTitle: String = UserDefaults.standard.string(forKey: "catSectionTitle")!
    var locationSectionStyle: String = UserDefaults.standard.string(forKey: "locationSectionStyle")!
    var adDetailStyle: String = UserDefaults.standard.string(forKey: "adDetailStyle")!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.adForest_homeData()
        self.showLoader()
        self.addLeftBarButtonWithImage()
        self.adForest_homeData()
        self.adForest_sendFCMToken()

    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK:- refresh Table View
    @objc func refreshTableView() {
        self.adForest_homeData()
        //        self.perform(#selector(self.nokri_showNavController1), with: nil, afterDelay: 0.5)
                  tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    
    //MARK:- go to category detail
    func goToCategoryDetail(id: Int) {
        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
        categoryVC.categoryID = id
        self.navigationController?.pushViewController(categoryVC, animated: true)
    }
    //MARK:- go to subcat screen
    func goToSubCategoryDetail(id: Int , hasChild: Bool) {
        
        let categoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailController") as! CategoryDetailController
        categoryDetailVC.termId = id
        categoryDetailVC.objDataChild = hasChild
        self.navigationController?.pushViewController(categoryDetailVC, animated: true)

        
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
            //        let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
            addDetailVC.ad_id = ad_id
            self.navigationController?.pushViewController(addDetailVC, animated: true)
            
        }
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
    
  
    //MARK:- Delegate Methods
    func numberOfSections(in tableView: UITableView) -> Int {
        if isAdPositionSort {
            return addPosition.count
        }
        return 4
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
                    height = 150
                } else {
                    height = 0
                }
            }
            else if position == "cat_icons" {
                if Constants.isiPadDevice {
                    height = 230
                } else {
                    height = 184
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
                    if nearbyAdLayout == "default"{
                        height = 270
                    }
                    else {
                        height = CGFloat(nearByColHeight) + 70
                    }
                } else {
                    height = 0
                }
            } else if position == "sliders" {
                if dataArray.isEmpty {
                    height = 0
                }
                if  sliderAdsLayout == "default"{
                    height = CGFloat(290 + heightConstraintTitlead)
                    
                }
                else {
                    height = CGFloat(SliderColHeight) + 70
                }
            } else if position == "blogNews"{
                if self.isShowBlog {
                    height = 270
                } else {
                    height = 0
                }
            }
            else if position == "featured_ads" {
                if self.isShowFeature {
                    if featuredArray.isEmpty {
                        height = 0
                    }
                    else if featuredAdLayout == "default"{
                        height = 270
                    }
                    else {
                        height = CGFloat(fetColHeight) + 70
                        
                    }
                } else {
                    height = 0
                }
            }
            else if position ==  "latest_ads" {
                if self.isShowLatest {
                    print(latColHeight)
                    if latestAdLayout == "default"{
                        height = 270
                    }
                    else {
                        height = CGFloat(latColHeight) + 70
                        
                    }
                } else {
                    
                    height = 0
                }
            }
            
        }
        else {
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
                    //                    height = 470
                    height = CGFloat(fetColHeight) + 70
                    
                    
                }
                else if section == 2 {
                    if Constants.isiPadDevice {
                        height = 220
                    }
                    else {
                        height = 240
                        //                        if numberOfColumns == 3 {
                        //                            let itemHeight = CollectionViewSettings.getItemWidth(boundWidth: tableView.bounds.size.width)
                        //                            let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewSettings.column)
                        //                            let totalTopBottomOffSet = CollectionViewSettings.offset + CollectionViewSettings.offset
                        //                            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewSettings.minLineSpacing
                        //                            if Constants.isiPhone5 {
                        //                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 80)
                        //                            } else {
                        //                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 60)
                        //                            }
                        //                            height =  totalHeight
                        //                        } else if numberOfColumns == 4 {
                        //                            let itemHeight = CollectionViewForuCell.getItemWidth(boundWidth: tableView.bounds.size.width)
                        //                            let totalRow = ceil(CGFloat(categoryArray.count) / CollectionViewForuCell.column)
                        //                            let totalTopBottomOffSet = CollectionViewForuCell.offset + CollectionViewForuCell.offset
                        //                            let totalSpacing = CGFloat(totalRow - 1) * CollectionViewForuCell.minLineSpacing
                        //                            if Constants.isiPhone5 {
                        //                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 170)
                        //                            } else {
                        //                                totalHeight = ((itemHeight * CGFloat(totalRow)) + totalTopBottomOffSet + totalSpacing + 140)
                        //                            }
                        //                            height =  totalHeight
                        //                        }
                    }
                }
                else if section == 3 {
                    //                    height = 270
                    height = CGFloat(fetColHeight) + 70
                    
                    
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
                    //                    height = 270
                    height = CGFloat(fetColHeight) + 70
                    
                    
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
                    //                    height = 270
                    height = CGFloat(fetColHeight) + 70
                    
                }
                else if section == 3 {
                    height = 270
                    
                }
            }
        }
        return height
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
                let cell: MarvelSearchSectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelSearchSectionTableViewCell", for: indexPath) as! MarvelSearchSectionTableViewCell
                let objData = searchSectionArray[indexPath.row]
                
                
                if objData.isShow {
                    
                    if let title = objData.mainTitle {
                        cell.lblHeading.text = title
                    }
                    if let subTitle = objData.subTitle {
                        cell.lblSubHeading.text = subTitle
                    }
                    if let placeHolder = objData.placeholder {
                        cell.txtFieldSearch.placeholder = placeHolder
                    }
                    
                    if UserDefaults.standard.bool(forKey: "isRtl") {
                        cell.lblHeading.textAlignment = .right
                        cell.lblSubHeading.textAlignment = .right
                    } else {
                        cell.lblHeading.textAlignment = .left
                        cell.lblSubHeading.textAlignment = .left
                    }
                    
                    
                    
                }
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
                    cell.containerView.backgroundColor = UIColor.groupTableViewBackground
                    cell.contentView.backgroundColor = UIColor.groupTableViewBackground
                    cell.collectionView.backgroundColor = UIColor.groupTableViewBackground
                    cell.dataArray = (objData?.blogs)!
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    
                    return cell
                }
            case "cat_icons":
                
                let cell: MarvelCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelCategoryTableViewCell", for: indexPath) as! MarvelCategoryTableViewCell
                let data = AddsHandler.sharedInstance.objHomeData
                        if self.isShowCategoryButton == true {
                    cell.btnViewAllCats.isHidden = false
                    if let viewAllText = data?.catIconsColumnBtn.text {
                        cell.btnViewAllCats.setTitle(viewAllText, for: .normal)
                    }
                            cell.lblCatsHeading.text = catSectionTitle
                            
                    cell.btnViewAll = { () in
                        let categoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailController") as! CategoryDetailController
                        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
                    }
                } else {
                    cell.btnViewAllCats.isHidden = true
                }
                //                cell.numberOfColums = self.numberOfColumns
                cell.categoryArray  = self.categoryArray
                cell.delegate = self
                cell.collectionView.reloadData()
                return cell
            case "featured_ads":
                if featuredAdLayout == "vertical"  {
                    if isShowFeature {
                        let cell: MarvelFeatureVerticalTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelFeatureVerticalTableViewCell", for: indexPath) as! MarvelFeatureVerticalTableViewCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblSectionTitle.text = sectionTitle
                        }
                        cell.heightConstraintCollectionView.constant = CGFloat(Double(cell.collectionView.contentSize.height))

                        fetColHeight = Double(cell.heightConstraintCollectionView.constant)
                        
                        cell.dataArray = featuredArray
                        cell.delegate = self
                        cell.collectionView.reloadData()
                        return cell
                        
                        
                    }
                }
                else if featuredAdLayout == "default"{
                    if isShowFeature {
                        
                        let cell: MarvelHomeFeatureDefaultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelHomeFeatureDefaultTableViewCell", for: indexPath) as! MarvelHomeFeatureDefaultTableViewCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        cell.fromMarvelHome = true
                        if cell.fromMarvelHome == true {
                            cell.containerView.backgroundColor = UIColor.groupTableViewBackground
                            cell.contentView.backgroundColor = UIColor.groupTableViewBackground
                            cell.collectionView.backgroundColor = UIColor.groupTableViewBackground
                        }
                        cell.fromMarvelDefault = true
                        cell.dataArray = featuredArray
                        cell.delegate = self
                        fetColHeight = Double(cell.collectionView.contentSize.height)
                        print(latColHeight)
                        if featuredAdLayout == "horizental" {
                            fetColHeight = Double(cell.collectionView.contentSize.height)
                        }
                        cell.collectionView.reloadData()
                        return cell
                    }
                }
                else if featuredAdLayout == "horizental"{

                if isShowFeature {
                    
                    let cell: MarvelHomeFeatureAddCell = tableView.dequeueReusableCell(withIdentifier: "MarvelHomeFeatureAddCell", for: indexPath) as! MarvelHomeFeatureAddCell
                    let data = AddsHandler.sharedInstance.objHomeData
                    if let sectionTitle = data?.featuredAds.text {
                        cell.lblTitle.text = sectionTitle
                    }
                    fetColHeight = Double(cell.collectionView.contentSize.height)
                    
                    cell.dataArray = featuredArray
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    return cell
                    
                    }
                    
                }
            case "latest_ads":
                if latestAdLayout == "vertical"  {
                    if isShowLatest{
                        let cell: MarvelHomeLatestVerticalDefaultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelHomeLatestVerticalDefaultTableViewCell", for: indexPath) as! MarvelHomeLatestVerticalDefaultTableViewCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        let objData = AddsHandler.sharedInstance.objLatestAds
                        if let sectionTitle = objData?.text {
                                                cell.lblSectionTitle.text = sectionTitle
                                            }
                                            if let viewAllText = data?.viewAll {
                                                cell.OltViewAll.setTitle(viewAllText, for: .normal)
                                            }
                                            cell.btnViewAll = { () in
                                                let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                                                self.navigationController?.pushViewController(categoryVC, animated: true)
                                            }
                                            cell.delegate = self
                                            cell.dataArray = self.latestAdsArray
                                            print(cell.dataArray.count)
                                            cell.heightConstraintCollectionView.constant = CGFloat(Double(cell.collectionView.contentSize.height))
                                            latColHeight = Double(cell.heightConstraintCollectionView.constant)
                                              print(latColHeight)

                                            cell.collectionView.reloadData()
                                            return cell
                    }
                }
               else if  latestAdLayout == "default"{
                    if isShowLatest{
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
                        cell.fromMarvelDefault = true
                        cell.fromMarvelHome = true
                        if cell.fromMarvelHome == true {
                            cell.containerView.backgroundColor = UIColor.groupTableViewBackground
                            cell.contentView.backgroundColor = UIColor.groupTableViewBackground
                            cell.collectionView.backgroundColor = UIColor.groupTableViewBackground
                        }
                        heightConstraintTitleLatestad = Int(cell.heightConstraintTitle.constant)
                        latColHeight = Double(cell.collectionView.contentSize.height)
                        print(latColHeight)
                        if latestAdLayout == "horizental" {
                            latColHeight = Double(cell.collectionView.contentSize.height)
                        }
                        cell.collectionView.reloadData()
                        return cell
                    }
                }
                else if latestAdLayout == "horizental"{
                    if isShowLatest {
                        let cell: MarvelHomeLatestAddTableCell  = tableView.dequeueReusableCell(withIdentifier: "MarvelHomeLatestAddTableCell", for: indexPath) as! MarvelHomeLatestAddTableCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        let objData = AddsHandler.sharedInstance.objLatestAds
                        
                        if let sectionTitle = objData?.text {
                            cell.lblSectionTitle.text = sectionTitle
                        }
                        if let viewAllText = data?.viewAll {
                            cell.OltViewAll.setTitle(viewAllText, for: .normal)
                        }
                        cell.btnViewAll = { () in
                            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                            self.navigationController?.pushViewController(categoryVC, animated: true)
                        }
                        cell.delegate = self
                        cell.dataArray = self.latestAdsArray
                        //                                    heightConstraintTitleLatestad = Int(cell.heightConstraintTitle.constant)
                        //                    latColHeight = Double(cell.collectionView.contentSize.height)
                        //                    print(latColHeight)
                        //
                        //                    cell.height = CGFloat(latColHeight)
                        //                    latColHeight = Double(self.latestAdsArray.)
                        print(cell.dataArray.count)
                        
                        //                    latColHeight = Double(cell.dataArray.count)
                        //latColHeight = Double(cell.collectionView.contentSize.height)
                        cell.heightConstraintCollectionView.constant = CGFloat(Double(cell.collectionView.contentSize.height))
                        latColHeight = Double(cell.heightConstraintCollectionView.constant)
                        print(latColHeight)
                        
                        cell.collectionView.reloadData()
                        return cell
                    }
                }
            case "cat_locations":
                if locationSectionStyle == "style1" {
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
                }else if locationSectionStyle == "style2" {
                    let cell: MarvelHomeLocationTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelHomeLocationTableViewCell", for: indexPath) as! MarvelHomeLocationTableViewCell
                    let data = AddsHandler.sharedInstance.objHomeData
                    
                    if self.isShowLocationButton {
                        cell.btnViewLocAds.isHidden = false
                        if let viewAllText = data?.catLocationsBtn.text {
                            cell.btnViewLocAds.setTitle(viewAllText, for: .normal)
                        }
                        cell.btnViewAction = { () in
                            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "LocationDetailController") as! LocationDetailController
                            self.navigationController?.pushViewController(detailVC, animated: true)
                        }
                    } else {
                        cell.btnViewLocAds.isHidden = true
                    }
                    cell.fromMulti = true
//                    if cell.fromMulti == false{
                        cell.containerView.backgroundColor = UIColor.groupTableViewBackground
                        cell.contentView.backgroundColor = UIColor.groupTableViewBackground
//                    }else{
//                        cell.containerView.backgroundColor = UIColor.clear
//                        cell.contentView.backgroundColor = UIColor.clear
//
//                    }
//
                    cell.lblSectionTitle.text = catLocationTitle
                    cell.dataArray = catLocationsArray
                    cell.delegate = self
                    print(catLocationsArray)
                    cell.pagerView.reloadData()
                    
                    return cell
                }
            case "sliders":
                if sliderAdsLayout == "vertical"  {
                    print(sliderAdsLayout)
                    let cell: MarvelVerticalSLiderAdsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelVerticalSLiderAdsTableViewCell", for: indexPath) as! MarvelVerticalSLiderAdsTableViewCell
                    let objData = dataArray[indexPath.row]
                    let data = AddsHandler.sharedInstance.objHomeData
                    if let sectionTitle = objData.name {
                        cell.lblSectionTitle.text = sectionTitle
                    }
                    if let viewAllText = data?.viewAll {
                        cell.OltViewAll.setTitle(viewAllText, for: .normal)
                    }
                    
                    cell.btnViewAll = { () in
                        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                        categoryVC.categoryID = objData.catId
                        self.navigationController?.pushViewController(categoryVC, animated: true)
                    }
                    cell.dataArray = objData.data
                    cell.heightConstaraintCollectionView.constant = CGFloat(Double(cell.collectionView.contentSize.height))
                    
                    SliderColHeight = Double(cell.heightConstaraintCollectionView.constant)
                    print(SliderColHeight)
                    
                    cell.delegate = self
                    cell.reloadData()
                
                    return cell
                }
                else if  sliderAdsLayout == "default"{
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
                    cell.fromMarvelDefault = true
                    cell.fromMarvelHome = true
                    if cell.fromMarvelHome == true {
                        cell.containerView.backgroundColor = UIColor.groupTableViewBackground
                        cell.contentView.backgroundColor = UIColor.groupTableViewBackground
                        cell.collectionView.backgroundColor = UIColor.groupTableViewBackground
                    }
                SliderColHeight = Double(cell.collectionView.contentSize.height)
                
                print(SliderColHeight)
                cell.dataArray = objData.data
                cell.delegate = self
                
                heightConstraintTitlead = Int(cell.heightConstraintTitle.constant)
                
                cell.reloadData()
                return cell
                
                
                }
                else if sliderAdsLayout == "horizental"{

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
                    categoryVC.categoryID = objData.catId
                    self.navigationController?.pushViewController(categoryVC, animated: true)
                }
                cell.dataArray = objData.data
                
                cell.heightContraintCollectionView.constant = CGFloat(Double(cell.collectionView.contentSize.height))
                SliderColHeight = Double(cell.heightContraintCollectionView.constant)
                print(SliderColHeight)
                
                cell.delegate = self
                
//                heightConstraintTitlead = Int(cell.heightConstraintTitle.constant)
                
                cell.reloadData()
                    return cell
                    
                }
            case "nearby":
                if nearbyAdLayout == "horizental"{
                    
                    if self.isShowNearby {
                        let cell: MarvelAdsTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "MarvelAdsTableViewCell", for: indexPath) as! MarvelAdsTableViewCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        
                        if let viewAllText = data?.viewAll {
                            cell.oltViewAll.setTitle(viewAllText, for: .normal)
                        }
                        cell.btnViewAll = { () in
                            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                            self.navigationController?.pushViewController(categoryVC, animated: true)
                        }
                        cell.delegate = self
                        cell.lblSectionTitle.text = self.nearByTitle
                        cell.dataArray = self.nearByAddsArray
                        
                        nearByColHeight = Double(cell.collectionView.contentSize.height)
                        cell.heightContraintCollectionView.constant = CGFloat(Double(cell.collectionView.contentSize.height))
                        nearByColHeight = Double(cell.heightContraintCollectionView.constant)
                        print(nearByColHeight)
                        cell.collectionView.reloadData()
                        return cell
                        
                    }
                }
                else if nearbyAdLayout == "default"{
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
                        cell.delegate = self
                        cell.lblSectionTitle.text = self.nearByTitle
                        cell.dataArray = self.nearByAddsArray

                        cell.collectionView.reloadData()
                        return cell
                    }
                }
                else if nearbyAdLayout == "vertical"{
                    if self.isShowNearby {
                        let cell: MarvelVerticalSLiderAdsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelVerticalSLiderAdsTableViewCell", for: indexPath) as! MarvelVerticalSLiderAdsTableViewCell
                        let objData = dataArray[indexPath.row]
                        let data = AddsHandler.sharedInstance.objHomeData
                        cell.lblSectionTitle.text = self.nearByTitle

                        if let viewAllText = data?.viewAll {
                            cell.OltViewAll.setTitle(viewAllText, for: .normal)
                        }
                        
                        cell.btnViewAll = { () in
                            let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
                            categoryVC.categoryID = objData.catId
                            self.navigationController?.pushViewController(categoryVC, animated: true)
                        }
                        cell.dataArray = self.nearByAddsArray
                        cell.heightConstaraintCollectionView.constant = CGFloat(Double(cell.collectionView.contentSize.height))
                        
                        nearByColHeight = Double(cell.heightConstaraintCollectionView.constant)
                        print(nearByColHeight)
                        
                        cell.delegate = self
                        cell.reloadData()
                    
                        return cell
                        
                    }
                }
            default:
                break
            }
        }
        else {
            if featurePosition == "1" {
                if section == 0 {
                    let cell: MarvelSearchSectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelSearchSectionTableViewCell", for: indexPath) as! MarvelSearchSectionTableViewCell
                    let objData = searchSectionArray[indexPath.row]
                    if objData.isShow {
                        if let title = objData.mainTitle {
                            cell.lblHeading.text = title
                        }
                        if let subTitle = objData.subTitle {
                            cell.lblSubHeading.text = subTitle
                        }
                        if let placeHolder = objData.placeholder {
                            cell.txtFieldSearch.placeholder = placeHolder
                        }
                    }
                    return cell
                }
                else if section == 1 {
                    if isShowFeature {
                        let cell: MarvelHomeFeatureAddCell = tableView.dequeueReusableCell(withIdentifier: "MarvelHomeFeatureAddCell", for: indexPath) as! MarvelHomeFeatureAddCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        fetColHeight = Double(cell.collectionView.contentSize.height)
                        
                        cell.dataArray = featuredArray
                        cell.delegate = self
                        cell.collectionView.reloadData()
                        return cell
                    }
                }
                else if section == 2 {
                    let cell: MarvelCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelCategoryTableViewCell", for: indexPath) as! MarvelCategoryTableViewCell
                    let data = AddsHandler.sharedInstance.objHomeData
                    if let viewAllText = data?.catIconsColumnBtn.text {
                        cell.btnViewAllCats.setTitle(viewAllText, for: .normal)
                    }
                    
                    cell.btnViewAll = { () in
                        let categoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailController") as! CategoryDetailController
                        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
                    }
                    //                    cell.numberOfColums = self.numberOfColumns
                    cell.categoryArray  = self.categoryArray
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    return cell
                }
                else if section == 3 {
                    let cell: MarvelAdsTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "MarvelAdsTableViewCell", for: indexPath) as! MarvelAdsTableViewCell
                    let objData = dataArray[indexPath.row]
                    let data = AddsHandler.sharedInstance.objHomeData
                    
                    if let sectionTitle = objData.name {
                        cell.lblSectionTitle.text = sectionTitle
                    }
                    fetColHeight = Double(cell.collectionView.contentSize.height)
                    
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
                    let cell: MarvelSearchSectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelSearchSectionTableViewCell", for: indexPath) as! MarvelSearchSectionTableViewCell
                    let objData = searchSectionArray[indexPath.row]
                    if objData.isShow {
                        
                        if let title = objData.mainTitle {
                            cell.lblHeading.text = title
                        }
                        if let subTitle = objData.subTitle {
                            cell.lblSubHeading.text = subTitle
                        }
                        if let placeHolder = objData.placeholder {
                            cell.txtFieldSearch.placeholder = placeHolder
                        }
                    }
                    return cell
                }
                else  if section == 1 {
                    let cell: MarvelCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelCategoryTableViewCell", for: indexPath) as! MarvelCategoryTableViewCell
                    let data = AddsHandler.sharedInstance.objHomeData
                    if let viewAllText = data?.catIconsColumnBtn.text {
                        cell.btnViewAllCats.setTitle(viewAllText, for: .normal)
                    }
                    
                    cell.btnViewAll = { () in
                        let categoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailController") as! CategoryDetailController
                        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
                    }
                    //                    cell.numberOfColums = self.numberOfColumns
                    cell.categoryArray  = self.categoryArray
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    return cell
                }
                else if section == 2 {
                    if isShowFeature {
                        let cell: MarvelHomeFeatureAddCell = tableView.dequeueReusableCell(withIdentifier: "MarvelHomeFeatureAddCell", for: indexPath) as! MarvelHomeFeatureAddCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        fetColHeight = Double(cell.collectionView.contentSize.height)
                        
                        cell.dataArray = featuredArray
                        cell.delegate = self
                        cell.collectionView.reloadData()
                        return cell
                    }
                }
                else if section == 3 {
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
                        categoryVC.categoryID = objData.catId
                        self.navigationController?.pushViewController(categoryVC, animated: true)
                    }
                    fetColHeight = Double(cell.collectionView.contentSize.height)
                    
                    cell.dataArray = objData.data
                    cell.delegate = self
                    cell.reloadData()
                    return cell
                    
                }
            }
                
            else if featurePosition == "3" {
                if section == 0 {
                    let cell: MarvelSearchSectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelSearchSectionTableViewCell", for: indexPath) as! MarvelSearchSectionTableViewCell
                    let objData = searchSectionArray[indexPath.row]
                    if objData.isShow {
                        
                        if let title = objData.mainTitle {
                            cell.lblHeading.text = title
                        }
                        if let subTitle = objData.subTitle {
                            cell.lblSubHeading.text = subTitle
                        }
                        if let placeHolder = objData.placeholder {
                            cell.txtFieldSearch.placeholder = placeHolder
                        }
                    }
                    return cell
                } else if section == 1 {
                    let cell: MarvelCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MarvelCategoryTableViewCell", for: indexPath) as! MarvelCategoryTableViewCell
                    let data = AddsHandler.sharedInstance.objHomeData
                    if let viewAllText = data?.catIconsColumnBtn.text {
                        cell.btnViewAllCats.setTitle(viewAllText, for: .normal)
                    }
                    
                    cell.btnViewAll = { () in
                        let categoryDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryDetailController") as! CategoryDetailController
                        self.navigationController?.pushViewController(categoryDetailVC, animated: true)
                    }
                    //                    cell.numberOfColums = self.numberOfColumns
                    cell.categoryArray  = self.categoryArray
                    cell.delegate = self
                    cell.collectionView.reloadData()
                    return cell
                } else if section == 2 {
                    let cell: MarvelAdsTableViewCell  = tableView.dequeueReusableCell(withIdentifier: "MarvelAdsTableViewCell", for: indexPath) as! MarvelAdsTableViewCell
                    let objData = dataArray[indexPath.row]
                    let data = AddsHandler.sharedInstance.objHomeData
                    
                    if let sectionTitle = objData.name {
                        cell.lblSectionTitle.text = sectionTitle
                    }
                    fetColHeight = Double(cell.collectionView.contentSize.height)
                    
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
                        let cell: MarvelHomeFeatureAddCell = tableView.dequeueReusableCell(withIdentifier: "MarvelHomeFeatureAddCell", for: indexPath) as! MarvelHomeFeatureAddCell
                        let data = AddsHandler.sharedInstance.objHomeData
                        if let sectionTitle = data?.featuredAds.text {
                            cell.lblTitle.text = sectionTitle
                        }
                        fetColHeight = Double(cell.collectionView.contentSize.height)
                        
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
                tabController?.navigationItem.title = successResponse.data.pageTitle
                self.title = successResponse.data.pageTitle
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
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    @objc func nokri_showNavController1(){
        
        let scrollPoint = CGPoint(x: 0, y: 0)
        self.tableView.setContentOffset(scrollPoint, animated: true)
        
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


}
