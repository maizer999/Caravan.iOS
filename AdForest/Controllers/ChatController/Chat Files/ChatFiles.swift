//
//  ChatFiles.swift
//  AdForest
//
//  Created by Apple on 15/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class ChatFiles: UITableViewCell {
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lblFileTitle: UILabel!
    @IBOutlet weak var btnDownlaodDocuments: UIButton!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgIconBg: UIImageView!
    @IBOutlet weak var txtMessageFiles: UITextView!
    @IBOutlet weak var containerFiles: UIView!{
        didSet{
            containerFiles.layer.borderWidth = 1
            containerFiles.layer.cornerRadius = 10
            containerFiles.backgroundColor = UIColor.groupTableViewBackground
            containerFiles.layer.borderColor = UIColor.white.cgColor
        }
    }
    @IBOutlet weak var imgProfileFiles: UIImageView!{
        didSet{
            imgProfileFiles.round()
        }
    }
    var btnDownloadDocsAction: (() -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func BtnDownloadDocsAction(_ sender: Any) {
        print("Download Docs")
        btnDownloadDocsAction?()
    }

}
