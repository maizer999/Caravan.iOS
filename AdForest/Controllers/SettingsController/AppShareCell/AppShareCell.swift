//
//  AppShareCell.swift
//  AdForest
//
//  Created by Apple on 9/25/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class AppShareCell: UITableViewCell {

    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgPicture: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
}
