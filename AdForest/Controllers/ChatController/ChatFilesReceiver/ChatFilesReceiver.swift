//
//  ChatFilesReceiver.swift
//  AdForest
//
//  Created by Apple on 17/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit

class ChatFilesReceiver: UITableViewCell {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var txtMessageReceiver: UITextView!
    @IBOutlet weak var imgBgReceriver: UIImageView!
    @IBOutlet weak var imgProfileReceiver: UIImageView!{
        didSet{
            imgProfileReceiver.round()
        }
    }
    @IBOutlet weak var btnDownloadFileReceiver: UIButton!
    @IBOutlet weak var lblFIleTitleReceiver: UILabel!
    @IBOutlet weak var containerFilesReceiver: UIView!{
        didSet{
            containerFilesReceiver.layer.borderWidth = 1
            containerFilesReceiver.layer.cornerRadius = 10
            containerFilesReceiver.backgroundColor = UIColor.groupTableViewBackground
            containerFilesReceiver.layer.borderColor = UIColor.white.cgColor
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
