//
//  CategoriesTableCell.swift
//  AdForest
//
//  Created by apple on 4/17/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

protocol CategoryDetailDelegate {
    func goToCategoryDetail(id: Int)
}

class CategoriesTableCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
       //     containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            if Constants.isiPadDevice {
                collectionView.isScrollEnabled = true
                collectionView.showsHorizontalScrollIndicator = false
            }else {
                 collectionView.isScrollEnabled = false
            }
            if Constants.isiPadDevice {
                if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
                    layout.scrollDirection = .horizontal
                }
            }
        }
    }
    @IBOutlet weak var oltViewAll: UIButton! {
        didSet{
            oltViewAll.roundCornors(radius: 5)
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltViewAll.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    
    //MARK:- Properties
    var categoryArray = [CatIcon]()
    var delegate : CategoryDetailDelegate?
    var btnViewAll: (()->())?
    
    var numberOfColums: CGFloat = 0
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    //MARK:- Collection View Delegate Methods
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CategoriesCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCollectionCell", for: indexPath) as! CategoriesCollectionCell
        let objData = categoryArray[indexPath.row]
    
        if let name = objData.name {
            cell.lblName.text = "  " + name + "  "
            
        }
        cell.imgContainer.layer.cornerRadius = 10
        cell.imgContainer.layer.borderWidth = 0.1
        cell.imgContainer.layer.borderColor = UIColor.lightGray.cgColor
        
        if let imgUrl = URL(string: objData.img.encodeUrl()) {
            cell.imgPicture.sd_setShowActivityIndicatorView(true)
//            cell.imgPicture.sd_setIndicatorStyle(.gray)
            cell.imgPicture.sd_setImage(with: imgUrl, completed: nil)
        }
        cell.btnFullAction = { () in
            self.delegate?.goToCategoryDetail(id: objData.catId)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if numberOfColums == 3 {
            if Constants.isiPadDevice {
                return CGSize(width: self.frame.width / 5 - 5, height: 170)
            }
            // maizer change
            else if Constants.isIphonePlus {
                let itemWidth = CollectionViewSettings.getItemWidth(boundWidth: collectionView.bounds.size.width)
//                return CGSize(width: itemWidth - 10, height: itemWidth)
                return CGSize(width: 175, height: 200)
            }
            else {
                let itemWidth = CollectionViewSettings.getItemWidth(boundWidth: collectionView.bounds.size.width)
                return CGSize(width: 175, height: 200)
//                return CGSize(width: itemWidth, height: itemWidth + 10)
            }
        } else {
            if Constants.isiPadDevice {
                return CGSize(width: self.frame.width / 5 - 5, height: 170)
            } else if Constants.isiPhone5 {
                let itemWidth = CollectionViewForuCell.getItemWidth(boundWidth: collectionView.bounds.size.width)
                return CGSize(width: itemWidth, height: itemWidth + 40)
            }
            else if Constants.isIphonePlus {
                let itemWidth = CollectionViewForuCell.getItemWidth(boundWidth: collectionView.bounds.size.width)
                return CGSize(width: itemWidth, height: itemWidth + 30)
            }
            else {
                let itemWidth = CollectionViewForuCell.getItemWidth(boundWidth: collectionView.bounds.size.width)
                return CGSize(width: itemWidth, height: itemWidth + 30)
            }
        }
    }
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    

  
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    //MARK:- IBActions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }
}
