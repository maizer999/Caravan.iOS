//
//  LoadMoreCell.swift
//  AdForest
//
//  Created by Apple on 8/15/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class LoadMoreCell: UITableViewCell {

    @IBOutlet weak var oltLoadMore: UIButton!{
        didSet{
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltLoadMore.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
            oltLoadMore.roundCornors()
        }
    }
    
    
    var btnLoadMore: (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func actionLoadMore(_ sender: UIButton) {
        self.btnLoadMore?()
    }
}
