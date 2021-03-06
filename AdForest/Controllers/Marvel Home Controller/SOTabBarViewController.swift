//
//  SOTabBarViewController.swift
//  AdForest
//
//  Created by Charlie on 03/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class SOTabBarViewController: UITabBarController ,NearBySearchDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,NVActivityIndicatorViewable{
    
    var defaults = UserDefaults.standard
    var tabBarAppearence = UITabBar.appearance()
    let button =  UIButton.init(type: .custom)
    var footerAdpostS = UserDefaults.standard.string(forKey: "footerAdPost")
    var titlesApi = [FooterMenuData]()
    var isNavSearchBarShowing = false
    let searchBarNavigation = UISearchBar()
    var backgroundView = UIView()
    var addPosition = ["search_Cell"]
    var barButtonItems = [UIBarButtonItem]()
    var nearByTitle = ""
    var latitude: Double = 0
    var longitude: Double = 0
    var searchDistance:CGFloat = 0
    let keyboardManager = IQKeyboardManager.sharedManager()
    var homeStyle: String = UserDefaults.standard.string(forKey: "homeStyles")!
    
    // maizer navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        //        self.addLeftBarButtonWithImage()
        //        self.navigationButtons()
//        tabBarAppearence.barStyle = .black
//        tabBarController?.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.clear], for: .normal)
        if let bgColor = defaults.string(forKey: "mainColor") {
            UITabBar.appearance().tintColor = Constants.hexStringToUIColor(hex: bgColor)
            tabBar.unselectedItemTintColor = .lightGray
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 44.0/255.0, green: 19/255.0, blue: 57.0/255.0, alpha: 1.0)
        
            
            
//            UIColor(rgb: 0x713091, a: 1.0)
//        UIColor.purple
//
//        713091
        setNavigationBar()
        
    }
    
    func setNavigationBar() {
        //        let screenSize: CGRect = UIScreen.main.bounds
        //        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        //        let navItem = UINavigationItem(title: "")
        //        let doneItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: nil, action: #selector(actionHome))
        //        navItem.rightBarButtonItem = doneItem
        //        navBar.setItems([navItem], animated: false)
        //        self.view.addSubview(navBar)
        
        let notificationButton = UIButton(type: .custom)
        notificationButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        
        // maizer header logo
        
        var img = UIImageView()
        img.frame = notificationButton.frame
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.image = UIImage(named: "not_lc")
        notificationButton.addSubview(img)
        notificationButton.addTarget(self, action: #selector(actionHome), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: notificationButton)
        
        // maizer more_lc
        
        let moreButton = UIButton(type: .custom)
        moreButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        img = UIImageView()
        img.frame = moreButton.frame
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.image = UIImage(named: "more_lc")
        moreButton.addSubview(img)
        
        moreButton.frame = CGRect(x: 0, y: 0, width: 10, height: 30)
        moreButton.addTarget(self, action: #selector(callAction), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: moreButton)

        
        
        
        
//        self.navigationItem.setLeftBarButtonItems([item2,item1], animated: true)
        self.navigationItem.setRightBarButtonItems([item2,item1], animated: true)

        
        let panel = UIImageView()
        panel.bounds = CGRect(x: 0, y: 0, width: 80, height: 50)
//        btnBack.addTarget(self, action: #selector(self.backButtonAction(sender:)), for: .touchUpInside)
//        panel.setImage(#imageLiteral(resourceName: "logo-icon"), for: .normal)
        panel.image = UIImage(named:"logo-icon")
        panel.contentMode = .scaleAspectFill
        let leftBarButton = UIBarButtonItem(customView: panel)
        self.navigationItem.setLeftBarButton(leftBarButton, animated: true)
    
        
//        let logo = UIButton()
//        logo.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
//        //        logo.setImage(UIImage(named: "hlogo"), for: .normal)
//        img = UIImageView()
//        img.frame = moreButton.frame
//        img.contentMode = .scaleAspectFit
//        img.clipsToBounds = true
//        img.image = UIImage(named: "hlogo")
//        logo.addSubview(img)
        
        
        //        let barButton = UIBarButtonItem()
        //        barButton.customView = logo
        //        moreButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        //        moreButton.addTarget(self, action: #selector(actionHome), for: .touchUpInside)
        //
        //
        //        let item3 = UIBarButtonItem(customView: moreButton)
        ////        let item3 = UIBarButtonItem(customView: barButton)
        //        self.navigationItem.setRightBarButton(item3, animated: true)
        
        //        self.navigationItem.leftBarButtonItem  = barButton
        
//        let nav = self.navigationController?.navigationBar
//
//        // 2
//        nav?.barStyle = UIBarStyle.black
//        nav?.tintColor = UIColor.yellow
//
//        // 3
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//        imageView.contentMode = .scaleAspectFit
//
//        // 4
//        let image = UIImage(named: "panel")
//        imageView.image = image
        
        // 5
        //                navigationItem.titleView = imageView
        //        nav?.addSubview(imageView)
    }
    
    func removeTabbarItemsText() {
        
        if let items = tabBarController?.tabBar.items {
            for item in items {
         //       item.title = ""
         //       item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
            }
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
            let con = UIImage(named: "search1")?.withRenderingMode(.alwaysTemplate)
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
    
    @objc func callAction() {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)

            let cancelActionButton = UIAlertAction(title: "إلغاء", style: .cancel) { _ in
                print("إلغاء")
            }
            actionSheetControllerIOS8.addAction(cancelActionButton)

            let saveActionButton = UIAlertAction(title: "اتصل بنا", style: .default)
                { _ in
                   print("اتصل بنا")
                if let phoneCallURL = URL(string: "tel://\(0962770887766)"), UIApplication.shared.canOpenURL(phoneCallURL)
                {
                    UIApplication.shared.open(phoneCallURL, options: [:], completionHandler: nil)
                }
                
            }
            actionSheetControllerIOS8.addAction(saveActionButton)

            self.present(actionSheetControllerIOS8, animated: true, completion: nil)

    }
    
    @objc func actionHome() {
        
        if homeStyle == "home1"{
            self.appDelegate.moveToHome()
            
        }else if homeStyle == "home2"{
            self.appDelegate.moveToMultiHome()
        }
        else if homeStyle == "home3"{
            self.appDelegate.moveToMarvelHome()
        }
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
                //                self.adNavSearchBar()
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
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
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
    
    // maizer tabbar
    
    // TabBarButton – Setup Middle Button
    func setupMiddleButton() {
        let button = UIButton(type: .custom)
        let toMakeButtonUp = 40
        button.frame = CGRect(x: 0.0, y: 0.0, width: 64, height: 64)
        //        button.setBackgroundImage("blackplus", for: .normal)
        //        button.setBackgroundImage("blackplus", for: .highlighted)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 32
        
        let heightDifference: CGFloat = CGFloat(toMakeButtonUp)
        if heightDifference < 0 {
            button.center = tabBar.center
        } else {
            var center: CGPoint = tabBar.center
            center.y = center.y - heightDifference/3
            button.center = center
        }
        button.addTarget(self, action: #selector(menuButtonAction), for:.touchUpInside)
        view.addSubview(button)
        //        button.setTitle(footerAdpostS, for: .normal)
        //        button.setTitleColor(.black, for: .normal)
        //        button.setTitleColor(.yellow, for: .highlighted)
        //
        //        button.backgroundColor = .orange
        //        button.layer.cornerRadius = 32
        //        button.layer.borderWidth = 4
        //        button.layer.borderColor = UIColor.yellow.cgColor
        //        self.view.insertSubview(button, aboveSubview: self.tabBar)
        
    }
    
    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 2
        // console print to verify the button works
        print("Middle Button was just pressed!")
    }
    
    
    
}

