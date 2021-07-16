//
//  AadPostController.swift
//  AdForest
//
//  Created by apple on 4/25/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class AadPostController: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource, textFieldValueDelegate, PopupValueChangeDelegate {
   
    //MARK:- Outlets
    @IBOutlet weak var tableViewAAA: UITableView! {
        didSet {
            tableViewAAA.delegate = self
            tableViewAAA.dataSource = self
            tableViewAAA.tableFooterView = UIView()
            tableViewAAA.separatorStyle = .singleLine
            tableViewAAA.separatorColor = UIColor.black
            tableViewAAA.showsVerticalScrollIndicator = false
            //tableView.register(UINib(nibName: <#T##String#>, bundle: <#T##Bundle?#>), forCellReuseIdentifier: <#T##String#>)
        }
    }
    
    @IBOutlet weak var btnNext: UIButton!
    
    //MARK:- Properties
    var isFromEditAdAAA = false
    var ad_idAAA = 0
    var catIDAAA = ""
    var dataArrayAAA = [AdPostField]()
    var newArrayAAA = [AdPostField]()
    var imagesArrayAAA = [AdPostImageArray]()
    var dynamicArrayAAA = [AdPostField]()
    var hasPageNumberAAA = ""
    var refreshArrayAAA = [AdPostField]()
    var imageIDArrayAAA = [Int]()
    var dataAAA = [AdPostField]()
    let defaults = UserDefaults.standard
    var isBiddingAAA = true
    var isPaidAAA = true
    var isImageAAA = true
    var isCatTempOnAAA = false
    //var idBiddingDefault = true
    var selectOptionAAA = ""
    var idAAA = ""
    var valueAAA = ""
    var priceHide = ""
    // Empty Fields Check
    var adTitle = ""
var calledFrom = ""
    var homeStyles: String = UserDefaults.standard.string(forKey: "homeStyles")!

    //MARK:- View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if  defaults.bool(forKey: "isLogin") == true{
            if calledFrom == "home2"{
                self.addBackButton()
            }else{
                self.showBackButton()
            }
    //        self.forwardButton()
            self.googleAnalytics(controllerName: "Add Post Controller")
            if homeStyles == "home3"{
                btnNext.isHidden = false
            }else{
                btnNext.isHidden = true
            }
            if defaults.bool(forKey: "isRtl") {
    
                btnNext.setImage(#imageLiteral(resourceName: "bckrtl"), for: .normal)
                btnNext.semanticContentAttribute = .forceRightToLeft

            }
            else{
                btnNext.setImage(#imageLiteral(resourceName: "Arrow"), for: .normal)
    
            }

            UserDefaults.standard.set(true, forKey: "isBid")
            UserDefaults.standard.set("0", forKey: "is")
            if isFromEditAdAAA {
                let param: [String: Any] = ["is_update": ad_idAAA]
                print(param)
                self.adForest_adPost(param: param as NSDictionary)
            }
            else {
                let param: [String: Any] = ["is_update": ""]
                print(param)
                self.adForest_adPost(param: param as NSDictionary)
            }
        }else{
            self.appDelegate.moveToLogin()
            print("Not Login")
            tableViewHelper()
            btnNext.isHidden = true
            btnNext.isUserInteractionEnabled = false
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       

    }
    // MARK:- Go toHOmepage from adpost
    func addBackButton() {
        self.hideBackButton()
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        if UserDefaults.standard.bool(forKey: "isRtl") {
            backButton.setBackgroundImage(#imageLiteral(resourceName: "arabicBackButton"), for: .normal)
        } else {
            backButton.setBackgroundImage(#imageLiteral(resourceName: "backbutton"), for: .normal)
        }
        backButton.addTarget(self, action: #selector(onBackButtonClciked), for: .touchUpInside)
        let backBarButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = backBarButton
        
    }
    @objc override func onBackButtonClciked() {
        if homeStyles == "home1"{
            let tabBarVC = self.storyboard?.instantiateViewController(withIdentifier: "SOTabBarViewController") as! SOTabBarViewController
            self.navigationController?.pushViewController(tabBarVC, animated: true)

//            navigationController?.popViewController(animated: true)
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
    //MARK: - Custom
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func forwardButton() {
        let button = UIButton(type: .custom)
        if #available(iOS 11, *) {
            button.widthAnchor.constraint(equalToConstant: 30).isActive = true
            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }
        else {
            button.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        }
        if defaults.bool(forKey: "isRtl") {
            button.setBackgroundImage(#imageLiteral(resourceName: "backbutton"), for: .normal)
        } else {
                button.setBackgroundImage(#imageLiteral(resourceName: "forwardButton"), for: .normal)
        }
        button.addTarget(self, action: #selector(onForwardButtonClciked), for: .touchUpInside)
        let forwardBarButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = forwardBarButton
    }
    
    func changeText(value: String, fieldTitle: String) {
        for index in 0..<dataArrayAAA.count {
            if let objData = dataArrayAAA[index] as? AdPostField {
                if objData.fieldType == "textfield" {
                    if let cell  = tableViewAAA.cellForRow(at: IndexPath(row: index, section: 0)) as? AdPostCell {
                        var obj = AdPostField()
                        obj.fieldVal = value
                        obj.fieldTypeName = cell.fieldName
                        obj.fieldType = "textfield"
                        dataAAA.append(obj)
                        if fieldTitle == self.dataArrayAAA[index].fieldTypeName {
                             self.dataArrayAAA[index].fieldVal = value
                        }
                    }
                }
            }
        }
    }
    
    func changePopupValue(selectedKey: String, fieldTitle: String, selectedText: String,isBidSelected:Bool,IsPaySelected:Bool,isImageSelected:Bool,isShow:Bool) {
        print(selectedKey, fieldTitle, selectedText,isBidSelected,IsPaySelected,isImageSelected)
        isBiddingAAA = isBidSelected
        isPaidAAA = IsPaySelected
        isImageAAA = isImageSelected
        idAAA = selectedKey
        for index in 0..<dataArrayAAA.count {
            if let objData = dataArrayAAA[index] as? AdPostField {
                if objData.fieldType == "select" {
                    if let cell  = tableViewAAA.cellForRow(at: IndexPath(row: index, section: 0)) as? AdPostPopupCell {
                        var obj = AdPostField()
                        obj.fieldVal = selectedKey
                        obj.fieldTypeName = fieldTitle
                        obj.fieldType = "select"
                        dataAAA.append(obj)
                        
                        if obj.fieldTypeName == "ad_price_type" {
                            priceHide = selectedKey
                        }
                        tableViewAAA.reloadData()

                           
                        
                        if fieldTitle == self.dataArrayAAA[index].fieldTypeName {
                            self.dataArrayAAA[index].fieldVal = selectedText
                            cell.oltPopup.setTitle(selectedText, for: .normal)
                        }
                    }
                }
                
                
 
            }
        }
    }
  
    @objc func onForwardButtonClciked() {
        
        var option = ""
        
        var data = [AdPostField]()
        for index in  0..<dataArrayAAA.count {
            if let objData = dataArrayAAA[index] as? AdPostField {
                if objData.fieldType == "textfield" {
                    if let cell  = tableViewAAA.cellForRow(at: IndexPath(row: index, section: 0)) as? AdPostCell {
                        var obj = AdPostField()
                        obj.fieldVal = cell.txtType.text
                        obj.fieldTypeName = cell.fieldName
                        obj.fieldType = "textfield"
                        data.append(obj)
                        guard let txtTitle = cell.txtType.text else {return}
                        if cell.fieldName == "ad_title" {
                            if txtTitle == "" {
                                cell.txtType.shake(6, withDelta: 10, speed: 0.06)
                            }else {
                                self.adTitle = txtTitle
                            }
                        }
                        if cell.fieldName == "ad_price" {
                            if txtTitle == "" {
                                cell.txtType.shake(6, withDelta: 10, speed: 0.06)
                            }else {
                                self.adTitle = txtTitle
                            }
                        }
                    }
                }
                else if objData.fieldType == "select" {
                    if let cell = tableViewAAA.cellForRow(at: IndexPath(row: index, section: 0)) as? AdPostPopupCell {
                        var obj = AdPostField()
                        if isFromEditAdAAA{
                            obj.fieldVal = cell.selectedKey
                        }
                        else{
                            obj.fieldVal = cell.selectedKey

                        }
                        obj.fieldTypeName = cell.fieldName
                        obj.fieldType = "select"
                        valueAAA = cell.selectedKey
                        obj.isRequired = dataArrayAAA[index].isRequired
                        print(obj.fieldVal, obj.fieldTypeName, obj.fieldType, obj.isRequired)
                        data.append(obj)
                        print(selectOptionAAA)
                        option = valueAAA
                            //obj.fieldVal
                       if obj.fieldTypeName == "ad_type" {
                           //index == 7 &&
                           if option == "" {
                               valueAAA = cell.oltPopup.currentTitle!
                               cell.oltPopup.titleLabel?.textColor = UIColor.red
                               cell.oltPopup.shake(duration: 0.5, values: [-12.0, 12.0, -12.0, 12.0, -6.0, 6.0, -3.0, 3.0, 0.0])

                           }
                       }
//                        if id == ""{
//                            print("No..")
//                            value = cell.oltPopup.currentTitle!
//                            cell.oltPopup.titleLabel?.textColor = UIColor.red
//
//                        }else{
//                            print("Yes..")
//                            cell.oltPopup.titleLabel?.textColor = UIColor.gray
//                        }
                        
                    }
                }
            }
        }
        
        if isFromEditAdAAA == false{
            if isCatTempOnAAA == true {
                if self.adTitle == "" ||  idAAA == ""{
                    print("empty page cat Temp")
                }
                else {
                    let postVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostImagesController") as! AdPostImagesController
                    if AddsHandler.sharedInstance.isCategoeyTempelateOn {
                        self.refreshArrayAAA = dataArrayAAA
                        self.refreshArrayAAA.insert(contentsOf: AddsHandler.sharedInstance.objAdPostData, at: 2)
                        print(AddsHandler.sharedInstance.objAdPostData)
                        postVC.fieldsArray = self.refreshArrayAAA
                        
                        postVC.objArray = data
                        postVC.isfromEditAd = self.isFromEditAdAAA
                    }
                    else {
                        postVC.objArray = data
                        postVC.fieldsArray = self.dataArrayAAA
                        postVC.isfromEditAd = self.isFromEditAdAAA
                        postVC.priceHide = self.priceHide
                        
                    }
                    postVC.imageArray = self.imagesArrayAAA
                    postVC.imageIDArray = self.imageIDArrayAAA
                    postVC.isBid = self.isBiddingAAA
                    postVC.isImg = self.isImageAAA
                    
                    self.navigationController?.pushViewController(postVC, animated: true)
                }
            }
            
            else {
                let postVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostImagesController") as! AdPostImagesController
                if AddsHandler.sharedInstance.isCategoeyTempelateOn {
                    self.refreshArrayAAA = dataArrayAAA
                    self.refreshArrayAAA.insert(contentsOf: AddsHandler.sharedInstance.objAdPostData, at: 2)
                    print(AddsHandler.sharedInstance.objAdPostData)
                    postVC.fieldsArray = self.refreshArrayAAA
                    
                    postVC.objArray = data
                    postVC.isfromEditAd = self.isFromEditAdAAA
                }
                else {
                    postVC.objArray = data
                    print(data)
                    postVC.fieldsArray = self.dataArrayAAA
                    postVC.isfromEditAd = self.isFromEditAdAAA
                    postVC.priceHide = self.priceHide
                    
                }
                postVC.imageArray = self.imagesArrayAAA
                postVC.imageIDArray = self.imageIDArrayAAA
                postVC.isBid = self.isBiddingAAA
                postVC.isImg = self.isImageAAA
                
                self.navigationController?.pushViewController(postVC, animated: true)
            }
            
        }
        else{
//            if self.adTitle == "" {
//
//            }
//            else {
                let postVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostImagesController") as! AdPostImagesController
                if AddsHandler.sharedInstance.isCategoeyTempelateOn {
                    self.refreshArrayAAA = dataArrayAAA
                    self.refreshArrayAAA.insert(contentsOf: AddsHandler.sharedInstance.objAdPostData, at: 2)
                    postVC.fieldsArray = self.refreshArrayAAA
                    postVC.objArray = data
                    postVC.isfromEditAd = self.isFromEditAdAAA
                }
                else {
                    postVC.objArray = data
                    print(data)
                    postVC.fieldsArray = self.dataArrayAAA
                    postVC.isfromEditAd = self.isFromEditAdAAA
                    print(self.priceHide)
                    postVC.priceHide = self.priceHide
                   
                }
                postVC.imageArray = self.imagesArrayAAA
                postVC.imageIDArray = self.imageIDArrayAAA
                postVC.isBid = self.isBiddingAAA
                postVC.isImg = self.isImageAAA
                
                self.navigationController?.pushViewController(postVC, animated: true)
        }
        
//
        
//        }
    }
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasPageNumberAAA == "1" {
            return dataArrayAAA.count
        }
        return dataArrayAAA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objData = dataArrayAAA[indexPath.row]
        
        if objData.fieldType == "textfield"  && objData.hasPageNumber == "1" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AdPostCell", for: indexPath) as! AdPostCell
            if let title = objData.title  {
                cell.txtType.placeholder = title
            }
            if let fieldValue = objData.fieldVal {
                cell.txtType.text = fieldValue
            }
            cell.fieldName = objData.fieldTypeName
            
            cell.delegateText = self
            return cell
        }
        else if objData.fieldType == "select" && objData.hasPageNumber == "1"  {
            let cell: AdPostPopupCell = tableView.dequeueReusableCell(withIdentifier: "AdPostPopupCell", for: indexPath) as! AdPostPopupCell
            
            if let title = objData.title {
                cell.lblType.text = title
            }
            
//            if let fieldValue = objData.fieldVal {
//                cell.oltPopup.setTitle(fieldValue, for: .normal)
//            }
            var i = 1
            for item in objData.values {
                if item.id == "" {
                    continue
                    
                }
                if i == 1 {
                    if cell.selectedValue == ""{
                        cell.oltPopup.setTitle(objData.values[0].name, for: .normal)
                        cell.selectedKey = String(item.id)
                        if objData.values[0].name == nil{
                            valueAAA = objData.values[1].name

                        }
                        else{
                        valueAAA = objData.values[0].name
                        }
                    }else{
                        cell.oltPopup.setTitle(cell.selectedValue, for: .normal)
                        //cell.oltPopup.setTitle(item.name, for: .normal)
                        if isCatTempOnAAA {
//                            cell.selectedKey = String(item.id)
                        }else{
//                            cell.selectedKey = String(item.id)
     
                        }
                        if isFromEditAdAAA{
//                         cell.selectedKey = String(item.id)
                        }
//                         cell.selectedKey = String(item.id)
                        if objData.values[0].name != nil{
                            valueAAA = objData.values[0].name

                        }
//                        else{
//                            value = objData.values[0].name
//
//                        }
                        
                    }
//                    id = objData.values[0].id
                   // cell.oltPopup.setTitle(item.name, for: .normal)
                   // cell.selectedKey = String(item.id)
                }
                i = i + 1
            }
            
            cell.btnPopUpAction = { () in
                cell.dropDownKeysArray = []
                cell.dropDownValuesArray = []
                cell.hasCatTemplateArray = []
                cell.hasTempelateArray = []
                cell.hasSubArray = []
                for items in objData.values {
                    if items.id == "" {
                        continue
                    }
                    cell.dropDownKeysArray.append(String(items.id))
                    cell.dropDownValuesArray.append(items.name)
                    cell.hasCatTemplateArray.append(objData.hasCatTemplate)
                    cell.hasTempelateArray.append(items.hasTemplate)
                    cell.hasSubArray.append(items.hasSub)
                    self.idAAA = items.id

                    if objData.fieldTypeName == "ad_cats1"{
                        cell.isBiddingArray.append(items.isBid)
                        cell.isPayArray.append(items.isPay)
                        cell.isImageArray.append(items.isImg)
                        cell.fieldTypeName = objData.fieldTypeName
                    }
                    
                     cell.isShowArr.append(items.isShow)
                   
                }
                cell.popupShow()
                cell.selectionDropdown.show()
            }
            cell.fieldName = objData.fieldTypeName
            cell.delegatePopup = self
            
            return cell
        }
        return UITableViewCell()
    }
  
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        let objData = dataArrayAAA[indexPath.row]
        if objData.fieldType == "textfield" {
            
            if priceHide == "no_price" || priceHide == "on_call" || priceHide == "free"{
                if indexPath.row == 3 {
                    height = 0
                }else{
                    height = 60
                }
            }else{
                height = 60
            }
        }
          
        else if objData.fieldType == "select" {
            if priceHide == "no_price" || priceHide == "on_call" || priceHide == "free"{
                if indexPath.row == 4 {
                    height = 0
                }else{
                    height = 80
                }
            }else{
                height = 80
            }
        }
        return height
    }
    //MARK:- IBActions
    
    @IBAction func actionShowPassword(_ sender: Any) {
        onForwardButtonClciked()
        
    }
    //MARK:- API Calls
    func adForest_adPost(param: NSDictionary) {
        print(param)
        self.showLoader()
        AddsHandler.adPost(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let tabController = self.parent as? UITabBarController
                tabController?.navigationItem.title = successResponse.data.title
                self.title = successResponse.data.title
                self.isCatTempOnAAA = successResponse.data.catTemplateOn
                AddsHandler.sharedInstance.isCategoeyTempelateOn = successResponse.data.catTemplateOn
                //this ad id send in parameter in 3rd step
                AddsHandler.sharedInstance.adPostAdId = successResponse.data.adId
                AddsHandler.sharedInstance.objAdPost = successResponse
                //Fields
                self.dataArrayAAA = successResponse.data.fields
                self.newArrayAAA = successResponse.data.fields
                self.imagesArrayAAA = successResponse.data.adImages
                self.forwardButton()

                for imageId in self.imagesArrayAAA {
                    if imageId.imgId == nil {
                        continue
                    }
                    self.imageIDArrayAAA.append(imageId.imgId)
                }
                for item in successResponse.data.fields {
                    if item.hasPageNumber == "1" {
                        self.hasPageNumberAAA = item.hasPageNumber
                    }
                }
                
                //get category id to get dynamic fields
                if let cat_id = successResponse.data.adCatId {
                    self.catIDAAA = String(cat_id)
                }
                if self.isCatTempOnAAA == true{
                    if successResponse.data.adCatId != nil {
                        let param: [String: Any] = ["cat_id": self.catIDAAA,
                                                    "ad_id": self.ad_idAAA
                        ]
                        print(param)
                        self.adForest_dynamicFields(param: param as NSDictionary)
                    }
                }else{
                    print("Not Called...")
                }
                UserDefaults.standard.set(successResponse.extra.dialgCancel, forKey: "dialgCancel")
                UserDefaults.standard.set(successResponse.extra.dialogSend, forKey: "dialogSend")
                
                self.tableViewAAA.reloadData()
            } else {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                  self.navigationController?.popViewController(animated: true)
                })
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    // Dynamic Fields
    func adForest_dynamicFields(param: NSDictionary) {
       self.showLoader()
        AddsHandler.adPostDynamicFields(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                AddsHandler.sharedInstance.objAdPostData = successResponse.data.fields
                AddsHandler.sharedInstance.adPostImagesArray = successResponse.data.adImages
                //self.isBidding = successResponse.isBid
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
             //self.isBidding = successResponse.isBid
            
//            if successResponse.isBid == true{
//                 UserDefaults.standard.set(true, forKey: "isBid")
//            }else{
//                UserDefaults.standard.set(false, forKey: "isBid")
//            }
            
             //UserDefaults.standard.set(successResponse.isBid, forKey: "isBid")
            
            
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    func tableViewHelper(){
        
        var msgLogin = ""
        if let msg = self.defaults.string(forKey: "notLogin") {
            msgLogin = msg
        }
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.tableViewAAA.bounds.size.width, height: self.tableViewAAA.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.text =  msgLogin
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 20)
        messageLabel.sizeToFit()
        tableViewAAA.backgroundView = messageLabel
    }

}

extension UIView {

    // Using CAMediaTimingFunction
    func shake(duration: TimeInterval = 0.5, values: [CGFloat]) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")

        // Swift 4.2 and above
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)

        // Swift 4.1 and below
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)


        animation.duration = duration // You can set fix duration
        animation.values = values  // You can set fix values here also
        self.layer.add(animation, forKey: "shake")
    }


    // Using SpringWithDamping
    func shake(duration: TimeInterval = 0.5, xValue: CGFloat = 12, yValue: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: xValue, y: yValue)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)

    }


    // Using CABasicAnimation
    func shake(duration: TimeInterval = 0.05, shakeCount: Float = 6, xValue: CGFloat = 12, yValue: CGFloat = 0){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = duration
        animation.repeatCount = shakeCount
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - xValue, y: self.center.y - yValue))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + xValue, y: self.center.y - yValue))
        self.layer.add(animation, forKey: "shake")
    }

}
