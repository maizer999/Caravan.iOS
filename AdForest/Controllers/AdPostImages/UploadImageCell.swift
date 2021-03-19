//
//  UploadImageCell.swift
//  AdForest
//
//  Created by apple on 4/26/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class UploadImageCell: UITableViewCell {

    //MARK:- Outlets
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    @IBOutlet weak var containerViewActivity: UIView! {
        didSet {
            containerViewActivity.layer.borderWidth = 0.5
            containerViewActivity.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    @IBOutlet weak var lblPicNumber: UILabel!
    @IBOutlet weak var imgCamera: UIImageView!
    @IBOutlet weak var lblSelectImages: UILabel!
    
    
    //MARK:- Properties
    var btnUploadImage : (()->())?
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func actionUploadImages(_ sender: Any) {
        self.btnUploadImage?()
    }
}
