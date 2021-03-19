//
//  MarvelCategoryDetailCell.swift
//  AdForest
//
//  Created by Charlie on 09/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class MarvelCategoryDetailCell: UITableViewCell {

    @IBOutlet weak var lblCatCount: UILabel!
    @IBOutlet weak var lblCat: UILabel!
    @IBOutlet weak var imgCat: UIImageView!
    @IBOutlet weak var topSeperator: UIView!
    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var containerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
