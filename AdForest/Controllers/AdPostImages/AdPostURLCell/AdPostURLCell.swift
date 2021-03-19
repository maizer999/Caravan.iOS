//
//  AdPostURLCell.swift
//  AdForest
//
//  Created by Apple on 8/28/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class AdPostURLCell: UITableViewCell {
    
    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet{
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var txtUrl: UITextField!
    
    
    //MARK:- Properties
    var fieldName = ""
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

}
