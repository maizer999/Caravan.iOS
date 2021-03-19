//
//  MultiCategoriesTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 12/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MultiCategoriesTableViewCell: UITableViewCell,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    

    @IBOutlet weak var lblCatsSectionHeading: UILabel!
    @IBOutlet weak var btnViewAllCats: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor"){
                btnViewAllCats.backgroundColor = UIColor.clear
                    //Constants.hexStringToUIColor(hex: mainColor)
                btnViewAllCats.setTitleColor(Constants.hexStringToUIColor(hex: mainColor), for: .normal)
            }
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            if Constants.isiPadDevice {
                collectionView.isScrollEnabled = true
                collectionView.showsHorizontalScrollIndicator = false
            }else {
                collectionView.showsHorizontalScrollIndicator = false
                collectionView.isScrollEnabled = true
            }
            if Constants.isiPadDevice {
                if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout{
                    layout.scrollDirection = .horizontal
                }
            }
        }
    }
    @IBOutlet weak var containerView: UIView!
    
    
    
    //MARK:- Properties
    var categoryArray = [CatIcon]()
    var delegate : MarvelCategoryDetailDelegate?
    var btnViewAll: (()->())?
    
    
    
    //MARK:- Properties
    var dataArray = [LocationDetailTerm]()
    var currentPage = 0
    var maximumPage = 0
    var searchController = UISearchController(searchResultsController: nil)
    var filteredArray = [LocationDetailTerm]()
    var shouldShowSearchResults = false
    var termId = 0
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        if UserDefaults.standard.bool(forKey: "isRtl") {
            lblCatsSectionHeading.textAlignment = .right
        }else{
            lblCatsSectionHeading.textAlignment = .left
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    //MARK:- Delegate Methods CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArray.count

    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MultiCategoriesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MultiCategoriesCollectionViewCell", for: indexPath) as! MultiCategoriesCollectionViewCell
        let objData = categoryArray[indexPath.row]
        
        if let name = objData.name {
            cell.lblCatName.text = name
        }
        if let imgUrl = URL(string: objData.img.encodeUrl()) {
            cell.imgCat.sd_setShowActivityIndicatorView(true)
            cell.imgCat.sd_setIndicatorStyle(.gray)
            cell.imgCat.sd_setImage(with: imgUrl, completed: nil)
        }
        cell.btnFullAction = { () in
            if objData.hasSub == true {
                self.delegate?.goToSubCategoryDetail(id: objData.catId, hasChild: objData.hasSub)

            }
            else{
                self.delegate?.goToCategoryDetail(id:objData.catId)

            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView.isDragging {
            cell.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
            UIView.animate(withDuration: 0.3, animations: {
                cell.transform = CGAffineTransform.identity
            })
        }
    }
    //MARK:- IBActions
    @IBAction func actionViewAll(_ sender: Any) {
        self.btnViewAll?()
    }


    
}

