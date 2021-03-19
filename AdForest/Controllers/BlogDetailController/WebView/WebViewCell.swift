//
//  WebViewCell.swift
//  AdForest
//
//  Created by apple on 3/14/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import WebKit
class WebViewCell: UITableViewCell {

    @IBOutlet weak var heightWebView: NSLayoutConstraint!
    
    @IBOutlet weak var wkWebView: WKWebView!{
        didSet {
                   wkWebView.isOpaque = false
                   wkWebView.backgroundColor = UIColor.white

               }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    


    
}
