//
//  OffersOnAdsController.swift
//  AdForest
//
//  Created by apple on 3/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import NVActivityIndicatorView

class OffersOnAdsController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable {

    //MARK:- Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.separatorStyle = .none
            tableView.addSubview(refreshControl)
            tableView.showsVerticalScrollIndicator = false
            tableView.register(UINib(nibName: "MessagesCell", bundle: nil), forCellReuseIdentifier: "MessagesCell")
        }
    }
    
    //MARK:- Properties
    var defaults = UserDefaults.standard
    var dataArray = [OfferAdsItem]()
    var currentPage = 0
    var maximumPage = 0
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        if let mainColor = defaults.string(forKey: "mainColor") {
            refreshControl.tintColor = Constants.hexStringToUIColor(hex: mainColor)
        }
        return refreshControl
    }()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.googleAnalytics(controllerName: "Offer on Ads")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.adForest_getOffersData()
        self.showLoader()
    }
    
    //MARK: - Custom
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    @objc func refreshTableView() {
        self.refreshControl.beginRefreshing()
        self.adForest_getOffersData()
    }
    
    //MARK:- table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessagesCell = tableView.dequeueReusableCell(withIdentifier: "MessagesCell", for: indexPath) as! MessagesCell
        let objData = dataArray[indexPath.row]
        
        
    
        for item in objData.messageAdImg {
            if let imgUrl = URL(string: item.thumb) {
                cell.imgPicture.sd_setShowActivityIndicatorView(true)
                cell.imgPicture.sd_setIndicatorStyle(.gray)
                cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
            }
        }
        if let name = objData.messageAdTitle {
            cell.lblName.text = name
        }
        if objData.messageReadStatus == true {
            cell.imgBell.image = UIImage(named: "bell")
        } else {
            let image = UIImage(named: "bell")
            let tintImage = image?.tint(with: UIColor.red)
            cell.imgBell.image = tintImage
            cell.backgroundColor = Constants.hexStringToUIColor(hex: Constants.AppColor.messageCellColor)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objdata = dataArray[indexPath.row]
        let offerDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "OffersonAdsDetailController") as! OffersonAdsDetailController
        offerDetailVC.ad_id = objdata.adId
      
        self.navigationController?.pushViewController(offerDetailVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
        if indexPath.row == dataArray.count - 1 && currentPage < maximumPage {
            currentPage += 1
            let param: [String: Any] = ["page_number": currentPage]
            print(param)
            self.adForest_moreOffersData(param: param as NSDictionary)
            self.showLoader()
        }
    }
    
    //MARK:- API Call
    func adForest_getOffersData() {
        UserHandler.offerOnAds(success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                self.dataArray = successResponse.data.receivedOffers.items
                
                if self.dataArray.count == 0 {
                                   self.tableView.setEmptyMessage(successResponse.message)
                               }else{
                                   self.tableView.setEmptyMessage("")
                               }
                
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
    
    // Load More Data
    func adForest_moreOffersData(param: NSDictionary) {
        UserHandler.moreOfferAdsData(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.dataArray.append(contentsOf: successResponse.data.receivedOffers.items)
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
}

extension OffersOnAdsController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        var pageTitle = ""
        if let title = self.defaults.string(forKey: "receiveOffers") {
            pageTitle =  title
        }
        return IndicatorInfo(title: pageTitle)
    }
}
