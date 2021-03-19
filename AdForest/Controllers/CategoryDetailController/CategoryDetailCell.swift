//
//  CategoryDetailCell.swift
//  AdForest
//
//  Created by Apple on 9/12/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class CategoryDetailCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
