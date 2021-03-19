//
//  SearchNowButtonCell.swift
//  AdForest
//
//  Created by Apple on 9/17/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class SearchNowButtonCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var oltSearchNow: UIButton! {
        didSet {
            oltSearchNow.isHidden = true
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltSearchNow.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    //MARK:- Properties
    var btnSearchNow: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    //MARK:- IBActions
    @IBAction func actionSearchNow(_ sender: Any) {
        self.btnSearchNow?()
    }
}
