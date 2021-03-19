//
//  MultiSearchSectionCell.swift
//  AdForest
//
//  Created by Charlie on 12/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import ZGTooltipView
import DropDown

class MultiSearchSectionCell: UITableViewCell , refreshdata{
    
    @IBOutlet weak var btnFilter: UIButton!
    @IBOutlet weak var filterView: UIView!{
        didSet{
            filterView.roundCorners()
        }
    }
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var searchView: UIView!{
        didSet{
            searchView.roundCorners()
        }
    }
    @IBOutlet weak var lblSearchKeywords: UITextField!
    @IBOutlet weak var btnLocation: UIButton!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var locSearchView: UIView!{
        didSet{
            locSearchView.roundCorners()
        }
    }
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainContainer: UIView!
    
    
    //MARK:- Properties
    var tooltips: [ZGTooltipView]!
    var dataCatLoc = [CatLocation]()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var namelOC = ""
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tooltips = [
            ZGTooltipView(direction: .bottom, text: "Select Location", originView: btnLocation, removeOnDismiss: false)
        ]
//        self.showAllTooltips()
    }
    func tableRef(name: String) {
        namelOC = name
        tooltips = [
            ZGTooltipView(direction: .bottom, text: name, originView: btnLocation, removeOnDismiss: false)
        ]
        
        print(name)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
     func showAllTooltips() {
        for tooltip in tooltips {
            
            tooltip.displayTooltip()
        }
    }

    @IBAction func btnLocNcLICKED(_ sender: UIButton) {

        let loginVC = storyboard.instantiateViewController(withIdentifier: LocationHomeDetViewController.className) as! LocationHomeDetViewController
         loginVC.modalPresentationStyle = .overCurrentContext
         loginVC.modalTransitionStyle = .crossDissolve
         loginVC.modalPresentationStyle = .overFullScreen
         loginVC.dataArray = dataCatLoc
         loginVC.delegate = (self as! refreshdata)
         self.window?.rootViewController?.presentVC(loginVC)
        
    }
    //MARK:- Custom
    func categoryDetail() {
        
        guard let searchText = lblSearchKeywords.text else {return}
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoryVC = storyboard.instantiateViewController(withIdentifier: "CategoryController") as! CategoryController
        categoryVC.searchText = searchText
        categoryVC.isFromTextSearch = true
        self.viewController()?.navigationController?.pushViewController(categoryVC, animated: true)
    }
    
    //MARK:- IBActions
    @IBAction func actionSearch(_ sender: UIButton) {
        categoryDetail()
    }
    
    @IBAction func actionFilters(_ sender: UIButton) {
    
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let proVc = storyBoard.instantiateViewController(withIdentifier: "AdvancedSearchController") as! AdvancedSearchController
        self.viewController()?.navigationController?.pushViewController(proVc, animated: true)

    
    }

}


