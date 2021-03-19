//
//  YouTubeVideoCell.swift
//  AdForest
//
//  Created by apple on 4/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
//import YouTubePlayer
import YoutubePlayer_in_WKWebView
class YouTubeVideoCell: UITableViewCell {

    @IBOutlet weak var playerView: WKYTPlayerView!
    
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
