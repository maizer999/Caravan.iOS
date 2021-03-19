//
//  SetLocationCell.swift
//  AdForest
//
//  Created by Apple on 9/16/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class SetLocationCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lblName: UILabel!
    
    
    //MARK:- life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .default
    }
}
