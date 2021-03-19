//
//  ChatImages.swift
//  AdForest
//
//  Created by Apple on 15/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import UIKit
import CollageView
import SDWebImage
class ChatImages: UITableViewCell,CollageViewDataSource,CollageViewDelegate {
   
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var collageViewImages: CollageView!{
        didSet{
            collageViewImages.delegate    = self
            collageViewImages.dataSource  = self
        }
    }
    
    @IBOutlet weak var containerImageViewAttachment: UIView! {
        didSet{
            containerImageViewAttachment.layer.cornerRadius = 5
            containerImageViewAttachment.layer.borderColor = UIColor.systemGreen.cgColor
            containerImageViewAttachment.layer.borderWidth = 5
        }
    }
//    @IBOutlet weak var imgViewAttachmentSender: UIImageView!
    @IBOutlet weak var imgProfileChatImages: UIImageView!{
        didSet{
            imgProfileChatImages.round()
        }
    }
    
    
    @IBOutlet weak var imgBg: UIImageView!
    @IBOutlet weak var txtSenderMessage: UITextView!
    //MARK:- Properties
    
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
        // Trigger click event of each image item
//        let message = "didSelect at index:  \(index), rowIndex: \(String(describing: itemView.collageItem!.rowIndex))"
//        print(message)
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
