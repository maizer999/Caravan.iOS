//
//  AboutAppCell.swift
//  AdForest
//
//  Created by Apple on 9/25/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class AboutAppCell: UITableViewCell {

    
    @IBOutlet weak var lblAbout: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    
}
