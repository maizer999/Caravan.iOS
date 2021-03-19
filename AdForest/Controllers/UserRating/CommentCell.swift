//
//  CommentCell.swift
//  AdForest
//
//  Created by apple on 4/10/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    //MARK:- Outlets
    
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.addShadowToView()
        }
    }
    
    @IBOutlet weak var imgPicture: UIImageView! {
        didSet {
            imgPicture.round()
        }
    }
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgDate: UIImageView!
    @IBOutlet weak var lblReply: UILabel!
    
    //MARK:- Properties
    
    
    
    //MARK:- View Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
       selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
