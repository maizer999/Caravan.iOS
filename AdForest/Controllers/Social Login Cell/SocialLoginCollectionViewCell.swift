//
//  SocialLoginCollectionViewCell.swift
//  AdForest
//
//  Created by Charlie on 25/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

class SocialLoginCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var btnSocial: UIButton!
    var  objData = UserHandler.sharedInstance.objregisterDetails

    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    
}
