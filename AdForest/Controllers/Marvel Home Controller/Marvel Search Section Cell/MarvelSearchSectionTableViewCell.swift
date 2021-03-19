//
//  MarvelSearchSectionTableViewCell.swift
//  AdForest
//
//  Created by Charlie on 27/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelSearchSectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnSearchView: UIView!{
        didSet {
            btnSearchView.roundCorners()
           
        }
    }

    @IBOutlet weak var btnSearch: UIButton!{
        didSet{
        if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
            btnSearch.tintColor = Constants.hexStringToUIColor(hex: mainColor)
        }
      }
    }
    @IBOutlet weak var txtFieldSearch: UITextField!
    @IBOutlet weak var searchFieldView: UIView!{
        didSet {
            searchFieldView.roundCorners()
        }
    }
    @IBOutlet weak var viewSeperator: UIView!
    @IBOutlet weak var lblSubHeading: UILabel!
    @IBOutlet weak var lblHeading: UILabel!
    @IBOutlet weak var containerView: UIView!{
        didSet{
            //09182d
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                containerView.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
        }
        }
        
    }

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if UserDefaults.standard.bool(forKey: "isRtl") {
                lblHeading.textAlignment = .right
                lblSubHeading.textAlignment = .right
                txtFieldSearch.textAlignment = .right
            } else {
                lblHeading.textAlignment = .left
                lblSubHeading.textAlignment = .left
                txtFieldSearch.textAlignment = .left
            }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK:- TextField Deletage
       func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           if textField == txtFieldSearch {
               txtFieldSearch.resignFirstResponder()
               categoryDetail()
           }
           return true
       }
    //MARK:- Custom
    func categoryDetail() {
        
        guard let searchText = txtFieldSearch.text else {return}
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
    
    
    
}
