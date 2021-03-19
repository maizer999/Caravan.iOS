//
//  MarvelHomeLocationTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 07/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import FSPagerView
protocol MarvelLocationCategoryDelegate {
    func goToCLocationDetail(id: Int)
}

class MarvelHomeLocationTableViewCell: UITableViewCell,FSPagerViewDataSource,FSPagerViewDelegate {
    
    
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var btnViewLocAds: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                btnViewLocAds.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var lblSectionTitle: UILabel!
    //    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pagerView: FSPagerView!{
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            self.pagerView.delegate = self
            self.pagerView.dataSource = self
            self.pagerView.isInfinite = true
            self.pagerView.transformer = FSPagerViewTransformer(type: .linear)
            let transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            let screenSize = UIScreen.main.bounds
        
            let screenWidth = screenSize.width
            pagerView.itemSize = CGSize(width: screenWidth, height: 250).applying(transform)

//            self.pagerView.itemSize = self.pagerView.frame.size.applying(transform)
            self.pagerView.decelerationDistance = FSPagerView.automaticDistance
        }
    }
    let data = AddsHandler.sharedInstance.objHomeData
    //    @IBOutlet weak var containerView: UIView!
    var dataArray = [CatLocation]()
    var delegate : MarvelLocationCategoryDelegate?
    var  adsCOunt : String!
    var btnViewAction : (()->())?
    var btnFullAction: (()->())?
    var fromMulti = false
    override func awakeFromNib() {
        super.awakeFromNib()
      

        print(data?.catLocations)
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    //    // MARK:- FSPagerViewDataSource
    //MARK:- IBActions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAction?()
    }
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return (data?.catLocations.count)!
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let objData  = data?.catLocations[index]
        if let imgUrl = URL(string: (objData?.img.encodeUrl())!) {
            cell.imageView?.sd_setShowActivityIndicatorView(true)
            cell.imageView?.sd_setIndicatorStyle(.gray)
            cell.imageView?.sd_setImage(with: imgUrl, completed: nil)
            cell.imageView?.contentMode = .scaleAspectFill
            cell.imageView?.clipsToBounds = true
        }
        
        adsCOunt = objData?.count
        print(adsCOunt)
        if let locationTitle = objData?.name {
            
            cell.textLabel?.text = "\(locationTitle) \(adsCOunt!)"
        }
        cell.imageView?.tag = (objData?.catId)!

        return cell
    }
    

    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        pagerView.deselectItem(at: index, animated: true)
        pagerView.scrollToItem(at: index, animated: true)
        let idsArr = data?.catLocations[index]
        print(idsArr?.catId!)

        self.delegate?.goToCLocationDetail(id:(idsArr?.catId!)!)


        
    }
    
    
    
}
