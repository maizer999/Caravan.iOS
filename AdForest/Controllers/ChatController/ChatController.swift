//
//  ChatController.swift
//  AdForest
//
//  Created by apple on 3/9/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import IQKeyboardManagerSwift

class ChatController: UIViewController, UITableViewDelegate, UITableViewDataSource, NVActivityIndicatorViewable, UITextViewDelegate,OpenChatControllerDelegate {
    
    //MARK:- Outlets
    @IBOutlet weak var containerAttachments: UIView!
    @IBOutlet var btnAttachment: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var oltName: UIButton!{
        didSet {
            oltName.contentHorizontalAlignment = .left
            if let mainColor = UserDefaults.standard.string(forKey: "mainColor") {
                oltName.setTitleColor(Constants.hexStringToUIColor(hex: mainColor), for: .normal)
            }
        }
    }
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var btnBlock: UIButton!
    
    @IBOutlet weak var containerViewTop: UIView! {
        didSet {
            containerViewTop.addShadowToView()
        }
    }
    
    @IBOutlet weak var imgSent: UIImageView! {
        didSet {
            imgSent.tintImageColor(color: UIColor.white)
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = UIView()
            tableView.showsVerticalScrollIndicator = false
            tableView.addSubview(refreshControl)
        }
    }
    
    @IBOutlet weak var heightConstraintTxtView: NSLayoutConstraint!
    @IBOutlet weak var heightContraintViewBottom: NSLayoutConstraint!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var btnClose: UIButton!
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        UserDefaults.standard.set("3", forKey: "fromNotification")
        if homeStyles == "home1"{
            appDelegate.moveToHome()
        }
        else if homeStyles == "home2"{
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "MultiHomeViewController") as! MultiHomeViewController
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
        else if homeStyles == "home3"{
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SOTabBarViewController") as! SOTabBarViewController
            self.navigationController?.pushViewController(tabBarVC, animated: true)
        }
        
    }
    @IBOutlet weak var containerViewSendMessage: UIView! {
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor") {
                containerViewSendMessage.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var buttonSendMessage: UIButton!{
        didSet {
            if let mainColor = defaults.string(forKey: "mainColor") {
                buttonSendMessage.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var imgMessage: UIImageView!
    
    @IBOutlet weak var containerViewBottom: UIView! {
        didSet {
            containerViewBottom.layer.borderWidth = 0.5
            containerViewBottom.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var txtMessage: UITextView!{
        didSet {
            txtMessage.layer.borderWidth = 0.5
            txtMessage.layer.borderColor = UIColor.lightGray.cgColor
            txtMessage.delegate = self
        }
    }
    
    
    
    //MARK:- Properties
    
    var settingObject = [String: Any]()
    let keyboardManager = IQKeyboardManager.sharedManager()
    let defaults = UserDefaults.standard
    var ad_id = ""
    var sender_id = ""
    var receiver_id = ""
    var messageType = ""
    var isBlocked :String?
    var blockMessage = ""
    var btn_text = ""
    var fileNameLabel = ""
    var currentPage = 0
    var maximumPage = 0
    let textViewMaxHeight: CGFloat = 100
    var textHeightConstraint: NSLayoutConstraint!
    var images = true

    var dataArray = [SentOfferChat]()
    var reverseArray = [SentOfferChat]()
    
    var userBlocked = false
    var adDetailStyle: String = UserDefaults.standard.string(forKey: "adDetailStyle")!
    var homeStyles: String = UserDefaults.standard.string(forKey: "homeStyles")!
    let documentInteractionController = UIDocumentInteractionController()
    var attachmentAllow = false
    var attachmentType = ""
    var chatImageSize = ""
    var chatDocSize = ""
    var attachmentFormat : [String]!
    var headingPopUp = ""
    var imgLImitTxt = ""
    var docLimitTxt = ""
    var docTypeTxt = ""
    var uploadImageHeading = ""
    var uploadDocumentHeading = ""
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
                                    #selector(refreshTableView),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        self.showBackButton()
        self.refreshButton()
        self.googleAnalytics(controllerName: "Chat Controller")
        documentInteractionController.delegate = self

        tableView.estimatedRowHeight = 70
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib(nibName: "ChatImages", bundle: nil), forCellReuseIdentifier: "ChatImages")
        tableView.register(UINib(nibName: "ChatFiles", bundle: nil), forCellReuseIdentifier: "ChatFiles")
        tableView.register(UINib(nibName: "ChatFilesImagestext", bundle: nil), forCellReuseIdentifier: "ChatFilesImagestext")
        tableView.register(UINib(nibName: "ChatFilesReceiver", bundle: nil), forCellReuseIdentifier: "ChatFilesReceiver")
        tableView.register(UINib(nibName: "ChatImagesReceiver", bundle: nil), forCellReuseIdentifier: "ChatImagesReceiver")
        tableView.register(UINib(nibName: "ChatFIlesTextImageReceiver", bundle: nil), forCellReuseIdentifier: "ChatFIlesTextImageReceiver")

    


        txtMessage.delegate = self
        if UserDefaults.standard.string(forKey: "fromNotification") == "1"{
            btnClose.isHidden = false
            topConstraint.constant += 10
            UserDefaults.standard.set("3", forKey: "fromNotification")

        }else{
            topConstraint.constant -= 30
            btnClose.isHidden = true
            UserDefaults.standard.set("3", forKey: "fromNotification")
        }
        
        self.textHeightConstraint = txtMessage.heightAnchor.constraint(equalToConstant: 40)
        self.textHeightConstraint.isActive = true
        self.adjustTextViewHeight()
        
        
        
        btnBlock.backgroundColor  = UIColor(hex: defaults.string(forKey: "mainColor")!)
        btnBlock.roundCornors()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //                let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
        //                print(parameter)
        //                self.adForest_getChatData(parameter: parameter as NSDictionary)
        //                self.showLoader()
        if messageType == "sent"{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        else{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id , "receiver_id": receiver_id , "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        
        
        keyboardHandling()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //if Constants.isIphoneX == true{
        NotificationCenter.default.removeObserver(self)
        keyboardManager.enable = true
        keyboardManager.enableAutoToolbar = true
        //}else{
        //keyboardManager.enable = true
        //keyboardManager.enableAutoToolbar = true
        //}
    }
    
    //    func textViewDidChange(_ textView: UITextView) {
    //        let fixedWidth = textView.frame.size.width
    //        textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //        let newSize = textView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
    //        var newFrame = textView.frame
    //        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
    //        textView.frame = newFrame
    //    }
    
    func adjustTextViewHeight() {
        let fixedWidth = txtMessage.frame.size.width
        let newSize = txtMessage.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        
        if newSize.height == 100 || newSize.height > 100{
            heightConstraintTxtView.constant = 100
            heightContraintViewBottom.constant = 100
            txtMessage.isScrollEnabled = true
        }else{
            self.textHeightConstraint.constant = newSize.height
            heightConstraintTxtView.constant = newSize.height
            heightContraintViewBottom.constant = newSize.height
        }
        self.view.layoutIfNeeded()
    }
    
    func textViewDidChange(_ textView: UITextView)
    {
        
        self.adjustTextViewHeight()
        //        print(textView.contentSize.height)
        //        if textView.contentSize.height >= self.textViewMaxHeight
        //        {
        //            textView.isScrollEnabled = true
        //        }
        //        else
        //        {
        //
        //
        //            heightConstraintTxtView.constant = textView.contentSize.height
        //            heightContraintViewBottom.constant = textView.contentSize.height
        //                textView.isScrollEnabled = false
        //
        //        }
    }
    
    //MARK: - Custom
    
    @IBAction func ActionOpenAttachment(_ sender: Any) {
        showMiracle()
    }

    @objc func showMiracle() {
        let slideVC = OverlayView()
        slideVC.modalPresentationStyle = .custom
        slideVC.transitioningDelegate = self
        slideVC.adID = ad_id
        slideVC.senderID = sender_id
        slideVC.receiverID = receiver_id
        slideVC.msgType = messageType
        slideVC.delegate = self
        slideVC.chatAttachmentAllowed = attachmentAllow
        slideVC.chatAttachmentType = attachmentType
        slideVC.chatImageSize = chatImageSize
        slideVC.chatDocSize = chatDocSize
        slideVC.chatAttachmentFormat = attachmentFormat
        slideVC.headingPopUp = headingPopUp
        slideVC.imgLImitTxt = imgLImitTxt
        slideVC.docLimitTxt = docLimitTxt
        slideVC.docTypeTxt = docTypeTxt
        slideVC.uploadImageHeading = uploadImageHeading
        slideVC.uploadDocumentHeading = uploadDocumentHeading
        present(slideVC, animated: true, completion: nil)
    }
    func openChatFromAttachment() {
        refreshTableView()
    }
    func keyboardHandling(){
        
        //if Constants.isIphoneX == true  {
        NotificationCenter.default.addObserver(self, selector: #selector(ChatController.showKeyboard(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        keyboardManager.enable = false
        keyboardManager.enableAutoToolbar = false
        // }else{
        //keyboardManager.enable = true
        //keyboardManager.enableAutoToolbar = true
        //}
        
    }
    
    @objc func showKeyboard(notification: Notification) {
        if let frame = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let height = frame.cgRectValue.height
            self.tableView.contentInset.bottom = height
            self.tableView.scrollIndicatorInsets.bottom = height
            if self.dataArray.count > 0 {
                self.tableView.scrollToRow(at: IndexPath.init(row: self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
            }
        }
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            self.bottomConstraint.constant = keyboardHeight
        }
    }
    
    func textViewDidBeginEditing(_ textField: UITextView) {
        //bottomConstraint.constant = 8
        // animateViewMoving(up: true, moveValue: 8)
    }
    
    func textViewDidEndEditing(_ textField: UITextView) {
        // animateViewMoving(up: false, moveValue: 8)
        self.bottomConstraint.constant = 0
        //        if self.dataArray.count > 0 {
        //            self.tableView.scrollToRow(at: IndexPath.init(row:  self.dataArray.count - 1, section: 0), at: .bottom, animated: true)
        //        }
        self.txtMessage.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextView) -> Bool {
        self.bottomConstraint.constant = 0
        self.txtMessage.resignFirstResponder()
        return true
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: self.dataArray.count-1, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    @objc func refreshTableView() {
        //                let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
        //        let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": receiver_id, "receiver_id": sender_id, "type": messageType, "message": ""]
        //
        //                print(parameter)
        //                self.adForest_getChatData(parameter: parameter as NSDictionary)
        //
        if messageType == "sent"{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        else{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id , "receiver_id": receiver_id , "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        
    }
    
    func adForest_populateData() {
        if UserHandler.sharedInstance.objSentOfferChatData != nil {
            let objData = UserHandler.sharedInstance.objSentOfferChatData
            
            if let addtitle = objData?.adTitle {
                self.oltName.setTitle(addtitle, for: .normal)
                oltName.underline()
            }
            if let price = objData?.adPrice.price {
                self.lblPrice.text = price
            }
            if let date = objData?.adDate {
                self.lblDate.text = date
            }
            
        }
    }
    
    func refreshButton() {
        let button = UIButton(type: .custom)
        button.setBackgroundImage(#imageLiteral(resourceName: "refresh"), for: .normal)
        if #available(iOS 11, *) {
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
        }
        else {
            button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        }
        button.addTarget(self, action: #selector(onClickRefreshButton), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
    
    @objc func onClickRefreshButton() {
        if messageType == "sent"{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        else{
            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id , "receiver_id": receiver_id , "type": messageType, "message": ""]
            print(parameter)
            self.showLoader()
            self.adForest_getChatData(parameter: parameter as NSDictionary)
        }
        
    }
    
    @IBAction func btnBlockClicked(_ sender: UIButton) {
        //        if isBlocked == "true"{
        //            let parameter : [String: Any] = ["sender_id": sender_id, "recv_id": receiver_id]
        //            print(parameter)
        //            adForest_UnblockUserChat(parameters: parameter as NSDictionary)
        //        }else{
        //            let parameter : [String: Any] = ["sender_id": sender_id, "recv_id": receiver_id]
        //            print(parameter)
        //            adForest_blockUserChat(parameters: parameter as NSDictionary)
        //        }
        if isBlocked == "true" {
            if messageType == "receive"{
                let parameter : [String: Any] = ["sender_id": receiver_id  , "recv_id": sender_id ]
                
                print(parameter)
                adForest_UnblockUserChat(parameters: parameter as NSDictionary)
                
            }
            else{
                
                let parameter : [String: Any] = ["sender_id": sender_id , "recv_id": receiver_id]
                print(parameter)
                adForest_UnblockUserChat(parameters: parameter as NSDictionary)
            }
            
        }
        else{
            if messageType == "receive"{
                let parameter : [String: Any] = ["sender_id": receiver_id  , "recv_id": sender_id ]
                print(parameter)
                adForest_blockUserChat(parameters: parameter as NSDictionary)
            }else{
                let parameter : [String: Any] = ["sender_id": sender_id , "recv_id": receiver_id]
                print(parameter)
                adForest_blockUserChat(parameters: parameter as NSDictionary)
            }
            
        }
        
    }
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objData = dataArray[indexPath.row]

        if objData.type == "reply" {
            
            let cell: SenderCell = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                        cell.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

            if userBlocked == true{
                cell.isHidden = true
            }
            
            var cellImg = cellFor(message: dataArray, at: indexPath, in: tableView)
            return cellImg
            
            if let imgUrl = URL(string: objData.img) {
                cell.imgProfile.sd_setShowActivityIndicatorView(true)
                cell.imgProfile.sd_setIndicatorStyle(.gray)
                cell.imgProfile.sd_setImage(with: imgUrl, completed: nil)
            }
            return cell
        }
        else {
            tableView.rowHeight = 45
            tableView.estimatedRowHeight = UITableViewAutomaticDimension

            let cell: ReceiverCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
                        cell.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

            if userBlocked == true{
                cell.isHidden = true
            }
            
            var cellReceiver = cellFor(message: dataArray, at: indexPath, in: tableView)
            return cellReceiver

//            if UserDefaults.standard.bool(forKey: "isRtl") {
//                if let message = objData.text {
//                    let image = UIImage(named: "bubble_sent")
//                    cell.imgBackground.image = image!
//                        .resizableImage(withCapInsets:
//                                            UIEdgeInsetsMake(17, 21, 17, 21),
//                                        resizingMode: .stretch)
//                        .withRenderingMode(.alwaysTemplate)
//                    cell.txtMessage.text = message
//                    //let height = cell.heightConstraint.constant + 20
//                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
//
//                }
//            }else{
//                if let message = objData.text {
//                    let image = UIImage(named: "bubble_se")
//                    cell.imgBackground.image = image!
//                        .resizableImage(withCapInsets:
//                                            UIEdgeInsetsMake(17, 21, 17, 21),
//                                        resizingMode: .stretch)
//                        .withRenderingMode(.alwaysTemplate)
//                    cell.txtMessage.text = message
//                    //let height = cell.heightConstraint.constant + 20
//                    cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
//
//                }
//            }
            
            if let imgUrl = URL(string: objData.img) {
                cell.imgIcon.sd_setShowActivityIndicatorView(true)
                cell.imgIcon.sd_setIndicatorStyle(.gray)
                cell.imgIcon.sd_setImage(with: imgUrl, completed: nil)
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataArray.count && currentPage < maximumPage {
            currentPage = currentPage + 1
            let param: [String: Any] = ["page_number": currentPage]
            print(param)
            self.showLoader()
            self.adForest_loadMoreChat(parameter: param as NSDictionary)
        }
    }
    
    func cellFor(message: [SentOfferChat], at indexPath: IndexPath, in tableView: UITableView) -> UITableViewCell  {
        let objdta =  dataArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatImages", for: indexPath) as! ChatImages
        cell.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

        if objdta.type == "reply" {
            //            let objdta =  dataArray[indexPath.row]
            if objdta.hasFiles == true && objdta.hasImages == true && objdta.text != nil {
                
                let cell3 = tableView.dequeueReusableCell(withIdentifier: "ChatFilesImagestext", for: indexPath) as! ChatFilesImagestext
                cell3.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

                cell3.chatImgs = objdta.chatImages
                cell3.collageViewImages.reload()
                if let imgUrl = URL(string: objdta.img) {
                    cell3.imgProfileUser?.sd_setShowActivityIndicatorView(true)
                    cell3.imgProfileUser?.sd_setIndicatorStyle(.gray)
                    cell3.imgProfileUser?.sd_setImage(with: imgUrl, completed: nil)
                }
                if let theFileName = objdta.chatFiles{
                    for item in theFileName{
                        let fileUrl = URL(string: item)
                        let paths = fileUrl?.pathComponents
                        fileNameLabel = (paths?.last)!
                    }
                    cell3.lblFileTitle.text =  fileNameLabel
                }
                
                cell3.btnDownloadDocsAction = { () in
                    let fileUrls = objdta.chatFiles
                    for files in fileUrls!{
                        /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
                        self.storeAndShare(withURLString: files)
                        
                    }
                    
                }
                
                if let message = objdta.text {
                    cell3.txtViewMessage.text = message
                    //cell.label.text = message
                    if UserDefaults.standard.bool(forKey: "isRtl") {
                        let image = UIImage(named: "bubble_se")
                        cell3.imgbgTxt.image = image!
                            .resizableImage(withCapInsets:
                                                UIEdgeInsetsMake(17, 21, 17, 21),
                                            resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cell3.imgbgTxt.image = cell3.imgbgTxt.image?.withRenderingMode(.alwaysTemplate)
                        cell3.imgbgTxt.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                        cell3.txtViewMessage.text = message
                        //let height = cell.heightConstraint.constant + 20
                        cell3.bgImageHeightConstraint.constant += cell3.heightConstraint.constant
                    }else{
                        let image = UIImage(named: "bubble_sent")
                        cell3.imgbgTxt.image = image!
                            .resizableImage(withCapInsets:
                                                UIEdgeInsetsMake(17, 21, 17, 21),
                                            resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cell3.imgbgTxt.image = cell3.imgbgTxt.image?.withRenderingMode(.alwaysTemplate)
                        cell3.imgbgTxt.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                        cell3.txtViewMessage.text = message
                        //let height = cell.heightConstraint.constant + 20
                        cell3.bgImageHeightConstraint.constant += cell3.heightConstraint.constant
                    }
                    //                    tableView.estimatedRowHeight = 80
                    print(cell3.heightConstraint.constant)
                    
                    tableView.rowHeight = UITableViewAutomaticDimension
                    //+ ChatFile.bgImageHeightConstraint.constant
                    //ChatFile.bgImageHeightConstraint.constant + ChatFile.heightConstraint.constant
                    //UITableViewAutomaticDimension + 220
                    
                    
                }
                
                return cell3
            }
            
            else if (objdta.hasImages == true && objdta.text != nil ){
                cell.chatImgs = objdta.chatImages
                cell.collageViewImages.reload()
                
                tableView.rowHeight = 220
                if let imgUrl = URL(string: objdta.img) {
                    cell.imgProfileChatImages?.sd_setShowActivityIndicatorView(true)
                    cell.imgProfileChatImages?.sd_setIndicatorStyle(.gray)
                    cell.imgProfileChatImages?.sd_setImage(with: imgUrl, completed: nil)
                }
                
                if !(objdta.text.isEmpty) {
                    if let message = objdta.text {
                        cell.txtSenderMessage.text = message
                        //cell.label.text = message
                        if UserDefaults.standard.bool(forKey: "isRtl") {
                            let image = UIImage(named: "bubble_se")
                            cell.imgBg.image = image!
                                .resizableImage(withCapInsets:
                                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                                resizingMode: .stretch)
                                .withRenderingMode(.alwaysTemplate)
                            cell.imgBg.image = cell.imgBg.image?.withRenderingMode(.alwaysTemplate)
                            cell.imgBg.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                            cell.txtSenderMessage.text = message
                            //let height = cell.heightConstraint.constant + 20
                            cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                        }else{
                            let image = UIImage(named: "bubble_sent")
                            cell.imgBg.image = image!
                                .resizableImage(withCapInsets:
                                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                                resizingMode: .stretch)
                                .withRenderingMode(.alwaysTemplate)
                            cell.imgBg.image = cell.imgBg.image?.withRenderingMode(.alwaysTemplate)
                            cell.imgBg.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                            cell.txtSenderMessage.text = message
                            //let height = cell.heightConstraint.constant + 20
                            cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                        }
                        
                        tableView.rowHeight = UITableViewAutomaticDimension
                        
                    }
                    
                }
                else{
                    cell.imgBg.isHidden = true
                    cell.txtSenderMessage.isHidden = true
                    tableView.rowHeight = UITableViewAutomaticDimension
                }
                return cell
            }
            else if objdta.hasFiles == true && objdta.text != nil{
                let ChatFile =  tableView.dequeueReusableCell(withIdentifier: "ChatFiles", for: indexPath) as! ChatFiles
                ChatFile.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

                if let theFileName = objdta.chatFiles{
                    for item in theFileName{
                        let fileUrl = URL(string: item)
                        let paths = fileUrl?.pathComponents
                        fileNameLabel = (paths?.last)!
                    }
                    ChatFile.lblFileTitle.text =  fileNameLabel
                }
                
                ChatFile.btnDownloadDocsAction = { () in
                    let fileUrls = objdta.chatFiles
                    for files in fileUrls!{
                        /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
                        self.storeAndShare(withURLString: files)
                        
                    }
                    
                }
                if let imgUrl = URL(string: objdta.img) {
                    ChatFile.imgProfileFiles?.sd_setShowActivityIndicatorView(true)
                    ChatFile.imgProfileFiles?.sd_setIndicatorStyle(.gray)
                    ChatFile.imgProfileFiles?.sd_setImage(with: imgUrl, completed: nil)
                }
                
                if !(objdta.text.isEmpty) {
                    if let message = objdta.text {
                        ChatFile.txtMessageFiles.text = message
                        //cell.label.text = message
                        if UserDefaults.standard.bool(forKey: "isRtl") {
                            let image = UIImage(named: "bubble_se")
                            ChatFile.imgIconBg.image = image!
                                .resizableImage(withCapInsets:
                                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                                resizingMode: .stretch)
                                .withRenderingMode(.alwaysTemplate)
                            ChatFile.imgIconBg.image = ChatFile.imgIconBg.image?.withRenderingMode(.alwaysTemplate)
                            ChatFile.imgIconBg.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                            ChatFile.txtMessageFiles.text = message
                            //let height = cell.heightConstraint.constant + 20
                            ChatFile.bgImageHeightConstraint.constant += ChatFile.heightConstraint.constant
                        }else{
                            let image = UIImage(named: "bubble_sent")
                            ChatFile.imgIconBg.image = image!
                                .resizableImage(withCapInsets:
                                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                                resizingMode: .stretch)
                                .withRenderingMode(.alwaysTemplate)
                            ChatFile.imgIconBg.image = ChatFile.imgIconBg.image?.withRenderingMode(.alwaysTemplate)
                            ChatFile.imgIconBg.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                            ChatFile.txtMessageFiles.text = message
                            //let height = cell.heightConstraint.constant + 20
                            ChatFile.bgImageHeightConstraint.constant += ChatFile.heightConstraint.constant
                        }
                        tableView.rowHeight = UITableViewAutomaticDimension
                    }
                    
                }
                else{
                    ChatFile.imgIconBg.isHidden = true
                    ChatFile.txtMessageFiles.isHidden = true
                    tableView.rowHeight = 80
                }
                
                return ChatFile
            }
            else if objdta.text != nil {
                let cellw = tableView.dequeueReusableCell(withIdentifier: "SenderCell", for: indexPath) as! SenderCell
                cellw.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

                if let message = objdta.text {
                    cellw.txtMessage.text = message
                    //cell.label.text = message
                    if UserDefaults.standard.bool(forKey: "isRtl") {
                        let image = UIImage(named: "bubble_se")
                        cellw.imgPicture.image = image!
                            .resizableImage(withCapInsets:
                                                UIEdgeInsetsMake(17, 21, 17, 21),
                                            resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cellw.imgPicture.image = cellw.imgPicture.image?.withRenderingMode(.alwaysTemplate)
                        cellw.imgPicture.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                        cellw.txtMessage.text = message
                        //let height = cell.heightConstraint.constant + 20
                        cellw.bgImageHeightConstraint.constant += cellw.heightConstraint.constant
                    }else{
                        let image = UIImage(named: "bubble_sent")
                        cellw.imgPicture.image = image!
                            .resizableImage(withCapInsets:
                                                UIEdgeInsetsMake(17, 21, 17, 21),
                                            resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cellw.imgPicture.image = cellw.imgPicture.image?.withRenderingMode(.alwaysTemplate)
                        cellw.imgPicture.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                        cellw.txtMessage.text = message
                        //let height = cell.heightConstraint.constant + 20
                        cellw.bgImageHeightConstraint.constant += cellw.heightConstraint.constant
                    }
                    tableView.rowHeight = UITableViewAutomaticDimension
                    //45
                    
                }
                if let imgUrl = URL(string: objdta.img) {
                    cellw.imgProfile.sd_setShowActivityIndicatorView(true)
                    cellw.imgProfile.sd_setIndicatorStyle(.gray)
                    cellw.imgProfile.sd_setImage(with: imgUrl, completed: nil)
                }
                return cellw
                
            }
        }else{
            if objdta.hasFiles == true && objdta.hasImages == true && objdta.text != nil {
                let ChatThreeItemsReceiver =  tableView.dequeueReusableCell(withIdentifier: "ChatFIlesTextImageReceiver", for: indexPath) as! ChatFIlesTextImageReceiver
                ChatThreeItemsReceiver.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

                ChatThreeItemsReceiver.chatImgs = objdta.chatImages
                ChatThreeItemsReceiver.collageViewreceiver.reload()
                if let imgUrl = URL(string: objdta.img) {
                    ChatThreeItemsReceiver.imgProfileReceiver?.sd_setShowActivityIndicatorView(true)
                    ChatThreeItemsReceiver.imgProfileReceiver?.sd_setIndicatorStyle(.gray)
                    ChatThreeItemsReceiver.imgProfileReceiver?.sd_setImage(with: imgUrl, completed: nil)
                }
                if let theFileName = objdta.chatFiles{
                    for item in theFileName{
                        let fileUrl = URL(string: item)
                        let paths = fileUrl?.pathComponents
                        fileNameLabel = (paths?.last)!
                    }
                    ChatThreeItemsReceiver.lblFileTitle.text = fileNameLabel
                }
                
                ChatThreeItemsReceiver.btnDownloadDocsAction = { () in
                    let fileUrls = objdta.chatFiles
                    for files in fileUrls!{
                        /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
                        self.storeAndShare(withURLString: files)
                        
                    }
                    
                }
                
                if let message = objdta.text {
                    ChatThreeItemsReceiver.txtMessageReceiver.text = message
                    //cell.label.text = message
                    if UserDefaults.standard.bool(forKey: "isRtl") {
                        let image = UIImage(named: "bubble_sent")
                        ChatThreeItemsReceiver.imgBgReceiver.image = image!
                            .resizableImage(withCapInsets:
                                                UIEdgeInsetsMake(17, 21, 17, 21),
                                            resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        ChatThreeItemsReceiver.imgBgReceiver.image = ChatThreeItemsReceiver.imgBgReceiver.image?.withRenderingMode(.alwaysTemplate)
                        ChatThreeItemsReceiver.imgBgReceiver.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                        ChatThreeItemsReceiver.txtMessageReceiver.text = message
                        //let height = cell.heightConstraint.constant + 20
                        ChatThreeItemsReceiver.bgImageHeightConstraint.constant += ChatThreeItemsReceiver.heightConstraint.constant
                    }else{
                        let image = UIImage(named: "bubble_se")
                        ChatThreeItemsReceiver.imgBgReceiver.image = image!
                            .resizableImage(withCapInsets:
                                                UIEdgeInsetsMake(17, 21, 17, 21),
                                            resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        ChatThreeItemsReceiver.imgBgReceiver.image = ChatThreeItemsReceiver.imgBgReceiver.image?.withRenderingMode(.alwaysTemplate)
                        ChatThreeItemsReceiver.imgBgReceiver.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                        ChatThreeItemsReceiver.txtMessageReceiver.text = message
                        //let height = cell.heightConstraint.constant + 20
                        ChatThreeItemsReceiver.bgImageHeightConstraint.constant += ChatThreeItemsReceiver.heightConstraint.constant
                    }
                    //                    tableView.estimatedRowHeight = 80
                    print(ChatThreeItemsReceiver.heightConstraint.constant)
                    
                    tableView.rowHeight = UITableViewAutomaticDimension
                    //+ ChatFile.bgImageHeightConstraint.constant
                    //ChatFile.bgImageHeightConstraint.constant + ChatFile.heightConstraint.constant
                    //UITableViewAutomaticDimension + 220
                    
                    
                }
                tableView.rowHeight = UITableViewAutomaticDimension

                return ChatThreeItemsReceiver

            }
            else  if objdta.hasFiles == true && objdta.text != nil{
                let ChatFileReceiver =  tableView.dequeueReusableCell(withIdentifier: "ChatFilesReceiver", for: indexPath) as! ChatFilesReceiver
                ChatFileReceiver.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

                if let theFileName = objdta.chatFiles{
                    for item in theFileName{
                        let fileUrl = URL(string: item)
                        let paths = fileUrl?.pathComponents
                        fileNameLabel = (paths?.last)!
                    }
                    ChatFileReceiver.lblFIleTitleReceiver.text =  fileNameLabel
                }
                

                ChatFileReceiver.btnDownloadDocsAction = { () in
                    let fileUrls = objdta.chatFiles
                    for files in fileUrls!{
                        /// Passing the remote URL of the file, to be stored and then opted with mutliple actions for the user to perform
                        self.storeAndShare(withURLString: files)
                        
                    }
                    
                }
                if let imgUrl = URL(string: objdta.img) {
                    ChatFileReceiver.imgProfileReceiver?.sd_setShowActivityIndicatorView(true)
                    ChatFileReceiver.imgProfileReceiver?.sd_setIndicatorStyle(.gray)
                    ChatFileReceiver.imgProfileReceiver?.sd_setImage(with: imgUrl, completed: nil)
                }
                
                if !(objdta.text.isEmpty) {
                    if let message = objdta.text {
                        ChatFileReceiver.txtMessageReceiver.text = message
                        //cell.label.text = message
                        if UserDefaults.standard.bool(forKey: "isRtl") {
                            let image = UIImage(named: "bubble_sent")
                            ChatFileReceiver.imgBgReceriver.image = image!
                                .resizableImage(withCapInsets:
                                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                                resizingMode: .stretch)
                                .withRenderingMode(.alwaysTemplate)
                            ChatFileReceiver.imgBgReceriver.image = ChatFileReceiver.imgBgReceriver.image?.withRenderingMode(.alwaysTemplate)
                            ChatFileReceiver.imgBgReceriver.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                            ChatFileReceiver.txtMessageReceiver.text = message
                            //let height = cell.heightConstraint.constant + 20
                           
                            ChatFileReceiver.bgImageHeightConstraint.constant += ChatFileReceiver.heightConstraint.constant
                        }else{
                            let image = UIImage(named: "bubble_se")
                            ChatFileReceiver.imgBgReceriver.image = image!
                                .resizableImage(withCapInsets:
                                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                                resizingMode: .stretch)
                                .withRenderingMode(.alwaysTemplate)
                            ChatFileReceiver.imgBgReceriver.image = ChatFileReceiver.imgBgReceriver.image?.withRenderingMode(.alwaysTemplate)
                            ChatFileReceiver.imgBgReceriver.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                            ChatFileReceiver.txtMessageReceiver.text = message
                            //let height = cell.heightConstraint.constant + 20
                            ChatFileReceiver.bgImageHeightConstraint.constant += ChatFileReceiver.heightConstraint.constant
                        }
                        tableView.rowHeight = UITableViewAutomaticDimension
                    }
                    
                }
                else{
                    ChatFileReceiver.imgBgReceriver.isHidden = true
                    ChatFileReceiver.txtMessageReceiver.isHidden = true
                    tableView.rowHeight = 80
                }
                
                return ChatFileReceiver
             }
             else if objdta.hasImages == true && objdta.text != nil{
                
                let ChatImageReceiver = tableView.dequeueReusableCell(withIdentifier: "ChatImagesReceiver", for: indexPath) as! ChatImagesReceiver
                ChatImageReceiver.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

                ChatImageReceiver.chatImgs = objdta.chatImages
                ChatImageReceiver.collageViewReceiver.reload()
                
                tableView.rowHeight = 220
                if let imgUrl = URL(string: objdta.img) {
                    ChatImageReceiver.imgProfileUserReceiver?.sd_setShowActivityIndicatorView(true)
                    ChatImageReceiver.imgProfileUserReceiver?.sd_setIndicatorStyle(.gray)
                    ChatImageReceiver.imgProfileUserReceiver?.sd_setImage(with: imgUrl, completed: nil)
                }
                
                if !(objdta.text.isEmpty) {
                    if let message = objdta.text {
                        ChatImageReceiver.txtMessageReceiver.text = message
                        //cell.label.text = message
                        if UserDefaults.standard.bool(forKey: "isRtl") {
                            let image = UIImage(named: "bubble_sent")
                            ChatImageReceiver.imgbgreceiver.image = image!
                                .resizableImage(withCapInsets:
                                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                                resizingMode: .stretch)
                                .withRenderingMode(.alwaysTemplate)
                            ChatImageReceiver.imgbgreceiver.image = ChatImageReceiver.imgbgreceiver.image?.withRenderingMode(.alwaysTemplate)
                            ChatImageReceiver.imgbgreceiver.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                            ChatImageReceiver.txtMessageReceiver.text = message
                            //let height = cell.heightConstraint.constant + 20
                            ChatImageReceiver.bgImageHeightConstraint.constant += ChatImageReceiver.heightConstraint.constant
                        }else{
                            let image = UIImage(named: "bubble_se")
                            ChatImageReceiver.imgbgreceiver.image = image!
                                .resizableImage(withCapInsets:
                                                    UIEdgeInsetsMake(17, 21, 17, 21),
                                                resizingMode: .stretch)
                                .withRenderingMode(.alwaysTemplate)
                            ChatImageReceiver.imgbgreceiver.image = ChatImageReceiver.imgbgreceiver.image?.withRenderingMode(.alwaysTemplate)
                            ChatImageReceiver.imgbgreceiver.tintColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)   //(hex:"D4FB79")
                            ChatImageReceiver.txtMessageReceiver.text = message
                            //let height = cell.heightConstraint.constant + 20
                            ChatImageReceiver.bgImageHeightConstraint.constant += ChatImageReceiver.heightConstraint.constant
                        }
                        
                        tableView.rowHeight = UITableViewAutomaticDimension
                        
                    }
                    
                }
                else{
                    ChatImageReceiver.imgbgreceiver.isHidden = true
                    ChatImageReceiver.txtMessageReceiver.isHidden = true
                    tableView.rowHeight = UITableViewAutomaticDimension
                }
                
                return ChatImageReceiver
                
                
             }
             else if objdta.text != nil {
                let cell: ReceiverCell = tableView.dequeueReusableCell(withIdentifier: "ReceiverCell", for: indexPath) as! ReceiverCell
                cell.backgroundView = UIImageView(image: UIImage(named: "background.jpg")!)

                if UserDefaults.standard.bool(forKey: "isRtl") {
                    if let message = objdta.text {
                        let image = UIImage(named: "bubble_sent")
                        cell.imgBackground.image = image!
                            .resizableImage(withCapInsets:
                                                UIEdgeInsetsMake(17, 21, 17, 21),
                                            resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cell.txtMessage.text = message
                        //let height = cell.heightConstraint.constant + 20
                        cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                        
                    }
                }else{
                    if let message = objdta.text {
                        let image = UIImage(named: "bubble_se")
                        cell.imgBackground.image = image!
                            .resizableImage(withCapInsets:
                                                UIEdgeInsetsMake(17, 21, 17, 21),
                                            resizingMode: .stretch)
                            .withRenderingMode(.alwaysTemplate)
                        cell.txtMessage.text = message
                        //let height = cell.heightConstraint.constant + 20
                        cell.bgImageHeightConstraint.constant += cell.heightConstraint.constant
                        
                    }
                    tableView.rowHeight  = UITableViewAutomaticDimension
                }
                if let imgUrl = URL(string: objdta.img) {
                    cell.imgIcon.sd_setShowActivityIndicatorView(true)
                    cell.imgIcon.sd_setIndicatorStyle(.gray)
                    cell.imgIcon.sd_setImage(with: imgUrl, completed: nil)
                }
                return cell
             }
        }
        
        return cell
    }

    
    
    //MARK:- IBActions
    @IBAction func actionSendMessage(_ sender: UIButton) {
        
        //        if isBlocked == "true"{
        //            print(blockMessage)
        //            let alert = Constants.showBasicAlert(message: blockMessage)
        //            self.presentVC(alert)
        //        }else{
        //            print("Not Blocked..")
        
        guard let messageField = txtMessage.text else {
            return
        }
//        if messageField == "" {
//
//        } else {
//            let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": receiver_id, "receiver_id": sender_id, "type": messageType, "message": messageField]
//            print(parameter)
//            self.adForest_sendMessage(param: parameter as NSDictionary)
//            self.showLoader()
//        }
        
                if messageField == "" {
        
                } else {
                    if messageType == "sent"{
                        let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": messageField]
        
                        print(parameter)
                        self.adForest_sendMessage(param: parameter as NSDictionary)
                        self.showLoader()
                    }
                    else{
                        let parameter : [String: Any] = ["ad_id": ad_id, "sender_id": sender_id, "receiver_id": receiver_id, "type": messageType, "message": messageField]
                        print(parameter)
                        self.adForest_sendMessage(param: parameter as NSDictionary)
                        self.showLoader()
                        }
        
                }
    }
    
    @IBAction func actionNotificationName(_ sender: UIButton) {
        if adDetailStyle == "style1"{
        let addDetailVc = self.storyboard?.instantiateViewController(withIdentifier: "AddDetailController") as! AddDetailController
        addDetailVc.ad_id = Int(ad_id)!
        self.navigationController?.pushViewController(addDetailVc, animated: true)
            
        }
        else{
            let addDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MarvelAdDetailViewController") as! MarvelAdDetailViewController
            addDetailVC.ad_id = Int(ad_id)!
            self.navigationController?.pushViewController(addDetailVC, animated: true)
            
        }
        
    }
    
    //MARK:- API Call
    
    func adForest_getChatData(parameter: NSDictionary) {
        UserHandler.getSentOfferMessages(parameter: parameter, success: { successResponse in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.title = successResponse.data.pageTitle
                self.currentPage = successResponse.data.pagination.currentPage
                self.maximumPage = successResponse.data.pagination.maxNumPages
                UserHandler.sharedInstance.objSentOfferChatData = successResponse.data
                self.reverseArray = successResponse.data.chat
                print(successResponse.data.isBlock)
                self.isBlocked = String(successResponse.data.isBlock)
                print(self.isBlocked)
                self.btn_text = successResponse.data.btnText
                self.dataArray = self.reverseArray.reversed()
            
                self.attachmentAllow = successResponse.data.messageSettings.attachmentAllowed
                self.attachmentType = successResponse.data.messageSettings.attachmentType
                self.chatImageSize = successResponse.data.messageSettings.imageSize
                self.chatDocSize = successResponse.data.messageSettings.attachmentSize
                self.attachmentFormat = successResponse.data.messageSettings.attachmentformat
                self.headingPopUp = successResponse.data.messageSettings.headingPopUp
                self.imgLImitTxt = successResponse.data.messageSettings.imgLImitTxt
                self.docLimitTxt = successResponse.data.messageSettings.docLimitTxt
                self.docTypeTxt = successResponse.data.messageSettings.docTypeTxt
                self.uploadImageHeading = successResponse.data.messageSettings.uploadImageHeading
                self.uploadDocumentHeading = successResponse.data.messageSettings.uploadDocumentHeading
                if self.attachmentAllow == false{
                    self.containerAttachments.isHidden = true
                }
                else{
                    self.containerAttachments.isHidden = false
                }
                self.adForest_populateData()
                self.tableView.reloadData()
                self.scrollToBottom()
                self.tableView.setEmptyMessage("")
                self.btnBlock.setTitle(self.btn_text, for: .normal)
            } else {
                // let alert = Constants.showBasicAlert(message: successResponse.message)
                // self.presentVC(alert)
                self.tableView.reloadData()
                self.isBlocked = String(successResponse.data.isBlock)
                print(self.isBlocked)
                // self.tableView.backgroundView?.isHidden = true
                self.btn_text = successResponse.data.btnText
                self.btnBlock.setTitle(self.btn_text, for: .normal)
                self.tableView.setEmptyMessage(successResponse.message)
            }

        }) { error in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }

    //Load More Chat
    func adForest_loadMoreChat(parameter: NSDictionary) {
        UserHandler.getSentOfferMessages(parameter: parameter, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            print(successResponse)
            if successResponse.success {
                UserHandler.sharedInstance.objSentOfferChatData = successResponse.data
                self.reverseArray = successResponse.data.chat
                
                self.dataArray.append(contentsOf: self.reverseArray.reversed())
                self.tableView.reloadData()
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //send message
    func adForest_sendMessage(param: NSDictionary) {
        UserHandler.sendMessage(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            self.refreshControl.endRefreshing()
            if successResponse.success {
                self.txtMessage.text = ""
                UserHandler.sharedInstance.objSentOfferChatData = successResponse.data
                self.reverseArray = successResponse.data.chat
                
                self.dataArray = self.reverseArray.reversed()
                self.tableView.reloadData()
                self.scrollToBottom()
                self.heightConstraintTxtView.constant = 40
                self.heightContraintViewBottom.constant = 40
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func adForest_blockUserChat(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.blockUserChat(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                // let alert = Constants.showBasicAlert(message: successResponse.message)
                // self.presentVC(alert)
                
                var ok = ""
                
                if let settingsInfo = self.defaults.object(forKey: "settings") {
                    self.settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                    let model = SettingsRoot(fromDictionary: self.settingObject)
                    
                    if let confirmText = model.data.dialog.confirmation.btnOk {
                        ok = confirmText
                    }
                }
                
                let al = UIAlertController(title: self.btn_text, message: "", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: ok, style: .default) { (ok) in
                    
                    //                    let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                    //                                         print(parameter)
                    //                        self.userBlocked = true
                    //                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                    
                    if self.messageType == "sent"{
                        
                        
                        let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.receiver_id , "receiver_id": self.sender_id , "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = true
                        
                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                        
                    }
                    else{
                        
                        
                        let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = true
                        
                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                    }
                    
                }
                al.addAction(btnOk)
                self.presentVC(al)
                
                //self.btnBlock.setTitle("UnBlock", for: .normal)
                self.isBlocked = "true"
                
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    
    func adForest_UnblockUserChat(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.UnblockUserChat(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                //let alert = Constants.showBasicAlert(message: successResponse.message)
                //self.presentVC(alert)
                
                var ok = ""
                
                if let settingsInfo = self.defaults.object(forKey: "settings") {
                    self.settingObject = NSKeyedUnarchiver.unarchiveObject(with: settingsInfo as! Data) as! [String : Any]
                    let model = SettingsRoot(fromDictionary: self.settingObject)
                    
                    if let confirmText = model.data.dialog.confirmation.btnOk {
                        ok = confirmText
                    }
                }
                
                let al = UIAlertController(title: self.btn_text, message: "", preferredStyle: .alert)
                let btnOk = UIAlertAction(title: ok, style: .default) { (ok) in
                    
                    
                    
                    //                    let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id, "receiver_id": self.receiver_id, "type": self.messageType, "message": ""]
                    //                    print(parameter)
                    
                    if self.messageType == "sent"{
                        
                        
                        let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.sender_id , "receiver_id": self.receiver_id , "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = false
                        
                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                        
                    }
                    else{
                        
                        
                        let parameter : [String: Any] = ["ad_id": self.ad_id, "sender_id": self.receiver_id, "receiver_id": self.sender_id, "type": self.messageType, "message": ""]
                        print(parameter)
                        self.showLoader()
                        self.userBlocked = false
                        
                        self.adForest_getChatData(parameter: parameter as NSDictionary)
                    }
                    //                    self.adForest_getChatData(parameter: parameter as NSDictionary)
                }
                al.addAction(btnOk)
                self.presentVC(al)
                
                // self.btnBlock.setTitle("Block", for: .normal)
                self.isBlocked = "false"
                
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
extension ChatController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting)
    }
}


extension ChatController {
    /// This function will set all the required properties, and then provide a preview for the document
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        //        documentInteractionController.presentPreview(animated: true)
        documentInteractionController.presentOptionsMenu(from: view.frame, in: view, animated: true)
    }
    
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "fileName.png")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.share(url: tmpURL)
            }
        }.resume()
    }
}
extension ChatController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = navigationController else {
            return self
        }
        return navVC
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}

class SenderCell: UITableViewCell {
    
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewBg: UIView!
    let label =  UILabel()
    @IBOutlet weak var imgPicture: UIImageView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var imgProfile: UIImageView! {
        didSet {
            imgProfile.round()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        self.txtMessage.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //self.imgPicture.layer.cornerRadius = 15
        self.imgPicture.clipsToBounds = true
        //imgPicture.backgroundColor = UIColor(red: 216/255, green: 238/255, blue: 160/255, alpha: 1)
        
        //showIncomingMessage()
    }
    
}

class ReceiverCell: UITableViewCell {
    
    @IBOutlet weak var bgImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imgBackground: UIImageView!
    @IBOutlet weak var txtMessage: UITextView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var imgIcon: UIImageView!{
        didSet{
            imgIcon.round()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        self.txtMessage.textContainerInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        //self.imgBackground.layer.cornerRadius = 15
        self.imgBackground.clipsToBounds = true
    }
    
}

public extension UIColor {
    convenience init(hex: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        var hex:   String = hex
        
        if hex.hasPrefix("#") {
            let index = hex.index(hex.startIndex, offsetBy: 1)
            hex         = hex.substring(from: index)
        }
        
        let scanner = Scanner(string: hex)
        var hexValue: CUnsignedLongLong = 0
        if scanner.scanHexInt64(&hexValue) {
            switch (hex.characters.count) {
            case 3:
                red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                blue  = CGFloat(hexValue & 0x00F)              / 15.0
            case 4:
                red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                alpha = CGFloat(hexValue & 0x000F)             / 15.0
            case 6:
                red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
            case 8:
                red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
            default:
                print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
            }
        } else {
            print("Scan hex error")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
