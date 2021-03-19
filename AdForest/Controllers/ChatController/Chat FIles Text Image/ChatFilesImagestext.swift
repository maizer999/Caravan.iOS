//
//  ChatFilesImagestext.swift
//  AdForest
//
//  Created by Apple on 17/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import CollageView
class ChatFilesImagestext: UITableViewCell,CollageViewDataSource,CollageViewDelegate {

    @IBOutlet weak var collageViewImages: CollageView!{
        didSet{
            collageViewImages.delegate    = self
            collageViewImages.dataSource  = self

        }
    }
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerViewImages: UIView!{
        didSet{
            containerViewImages.layer.cornerRadius = 5
            containerViewImages.layer.borderColor = UIColor.systemGreen.cgColor
            containerViewImages.layer.borderWidth = 5

        }
    }
    @IBOutlet weak var txtViewMessage: UITextView!
    @IBOutlet weak var imgbgTxt: UIImageView!
    @IBOutlet weak var imgProfileUser: UIImageView!{
        didSet{
            imgProfileUser.round()
        }
    }
    @IBOutlet weak var btnDownloadDocuments: UIButton!
    @IBOutlet weak var lblFileTitle: UILabel!
    @IBOutlet weak var containerFiles: UIView!{
        didSet{
            containerFiles.layer.borderWidth = 1
            containerFiles.layer.cornerRadius = 10
            containerFiles.backgroundColor = UIColor.groupTableViewBackground
            containerFiles.layer.borderColor = UIColor.white.cgColor

        }
    }
    
    
    
    
    //MARK:-Properties
    var btnDownloadDocsAction: (() -> Void)?

    var displayImagesCount = 4
    var chatImgs: [String] = []
    fileprivate var shownImagesCount = 4

    fileprivate var moreImagesCount: Int {
        return chatImgs.count - shownImagesCount
    }

    var layoutDirection: CollageViewLayoutDirection = .horizontal
    var layoutNumberOfColomn: Int = 2
    
    var ImagesCount: Int {
        return chatImgs.count - displayImagesCount
    }
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)

    
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
    
    
    //MARK:- Collage view methods
    
    
    func collageView(_ collageView: CollageView, configure itemView: CollageItemView, at index: Int) {
        itemView.contentMode = .scaleAspectFill

        itemView.layer.borderWidth = 3
        let array = chatImgs
        let isIndexValid = array.indices.contains(index)
        if isIndexValid {
            if let url = NSURL(string: array[index]) {
               
                itemView.imageView.sd_setShowActivityIndicatorView(true)
                itemView.imageView.sd_setIndicatorStyle(.gray)
                itemView.imageView.sd_setImage(with: url as URL, completed: nil)
            }
        } else {
        }
    }
    func collageView(_ collageView: CollageView, didSelect itemView: CollageItemView, at index: Int) {
        let categoryVC = storyboard.instantiateViewController(withIdentifier: "ViewAttachmentViewController") as! ViewAttachmentViewController
        print(chatImgs)
        categoryVC.imageAttachment = chatImgs
        UIApplication.shared.keyWindow?.rootViewController?.present(categoryVC, animated: true)
    }
    func collageViewNumberOfTotalItem(_ collageView: CollageView) -> Int {
        return shownImagesCount
    }

    func collageViewNumberOfRowOrColoumn(_ collageView: CollageView) -> Int {
        return layoutNumberOfColomn
    }

    func collageViewLayoutDirection(_ collageView: CollageView) -> CollageViewLayoutDirection {
        return layoutDirection
    }
}
