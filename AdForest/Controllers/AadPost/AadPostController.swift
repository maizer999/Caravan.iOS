//
//  AadPostController.swift
//  AdForest
//
//  Created by apple on 4/25/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import Photos
import Alamofire
import OpalImagePicker
import UITextField_Shake
import JGProgressHUD
import TextFieldEffects
import UIKit
import MapKit
import TextFieldEffects
import DropDown
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
import NVActivityIndicatorView
import JGProgressHUD

class AadPostController: UIViewController, NVActivityIndicatorViewable, UITableViewDelegate, UITableViewDataSource,textFieldValueDelegate,PopupValueChangeDelegate,OpalImagePickerControllerDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate,imagesCount {
   
    //MARK:- Outlets
    @IBOutlet weak var tableViewAAA: UITableView! {
        didSet {
            tableViewAAA.delegate = self
            tableViewAAA.dataSource = self
            tableViewAAA.tableFooterView = UIView()
            tableViewAAA.separatorStyle = .singleLine
            tableViewAAA.separatorColor = UIColor.black
            tableViewAAA.showsVerticalScrollIndicator = false
            tableViewAAA.register(UINib(nibName: "AdPostURLCell", bundle: nil), forCellReuseIdentifier: "AdPostURLCell")
            tableViewAAA.register(UINib(nibName: "CalendarCell", bundle: nil), forCellReuseIdentifier: "CalendarCell")
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
    
    func changePopupValue(selectedKey: String, fieldTitle: String, selectedText: String,isBidSelected:Bool,IsPaySelected:Bool,isImageSelected:Bool,isShow:Bool,hasSubCategory:Bool) {
        print(selectedKey, fieldTitle, selectedText,isBidSelected,IsPaySelected,isImageSelected )
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
                        isFirstTime = true
                        tableViewAAA.reloadData()

                           
                        
                        if fieldTitle == self.dataArrayAAA[index].fieldTypeName {
                            self.dataArrayAAA[index].fieldVal = selectedText
                            cell.oltPopup.setTitle(selectedText, for: .normal)
                        }
                        if hasSubCategory{
                            
                        } else{
                            onForwardButtonClciked()
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
//                    let postVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostImagesController") as! AdPostImagesController
                    if AddsHandler.sharedInstance.isCategoeyTempelateOn {
                        self.refreshArrayAAA = dataArrayAAA
                        self.refreshArrayAAA.insert(contentsOf: AddsHandler.sharedInstance.objAdPostData, at: 2)
                        print(AddsHandler.sharedInstance.objAdPostData)
                        fieldsArray = self.refreshArrayAAA
                        
                        objArray = data
                        isfromEditAd = self.isFromEditAdAAA
                    }
                    else {
                        objArray = data
                        fieldsArray = self.dataArrayAAA
                        isfromEditAd = self.isFromEditAdAAA
                        
                    }
                    imageArray = self.imagesArrayAAA
                    imageIDArray = self.imageIDArrayAAA
                    isBid = self.isBiddingAAA
                    isImg = self.isImageAAA
                    secondViewHandle()
//                    self.navigationController?.pushViewController(postVC, animated: true)
                }
            }
            
            else {
//                let postVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostImagesController") as! AdPostImagesController
                if AddsHandler.sharedInstance.isCategoeyTempelateOn {
                    self.refreshArrayAAA = dataArrayAAA
                    self.refreshArrayAAA.insert(contentsOf: AddsHandler.sharedInstance.objAdPostData, at: 2)
                    print(AddsHandler.sharedInstance.objAdPostData)
                    fieldsArray = self.refreshArrayAAA
                    
                    objArray = data
                    isfromEditAd = self.isFromEditAdAAA
                }
                else {
                    objArray = data
                    print(data)
                    fieldsArray = self.dataArrayAAA
                    isfromEditAd = self.isFromEditAdAAA
//                    priceHide = self.priceHide
                    
                }
                imageArray = self.imagesArrayAAA
                imageIDArray = self.imageIDArrayAAA
                isBid = self.isBiddingAAA
                isImg = self.isImageAAA
                secondViewHandle()
//                self.navigationController?.pushViewController(postVC, animated: true)
            }
            
        }
        else{
//            if self.adTitle == "" {
//
//            }
//            else {
//                let postVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostImagesController") as! AdPostImagesController
                if AddsHandler.sharedInstance.isCategoeyTempelateOn {
                    self.refreshArrayAAA = dataArrayAAA
                    self.refreshArrayAAA.insert(contentsOf: AddsHandler.sharedInstance.objAdPostData, at: 2)
                    fieldsArray = self.refreshArrayAAA
                    objArray = data
                    isfromEditAd = self.isFromEditAdAAA
                }
                else {
                    objArray = data
                    print(data)
                    fieldsArray = self.dataArrayAAA
                    isfromEditAd = self.isFromEditAdAAA
                    print(self.priceHide)
//                    priceHide = self.priceHide
                   
                }
                imageArray = self.imagesArrayAAA
                imageIDArray = self.imageIDArrayAAA
                isBid = self.isBiddingAAA
                isImg = self.isImageAAA
            secondViewHandle()
//                self.navigationController?.pushViewController(postVC, animated: true)
        }
        
//
        
//        }
    }
    
    ////////////////////////////////// second view controller code
    private lazy var uploadingProgressBar: JGProgressHUD = {
        let progressBar = JGProgressHUD(style: .dark)
        progressBar.indicatorView = JGProgressHUDRingIndicatorView()
        progressBar.textLabel.text = "Uploading"
        return progressBar
    }()
    var isFirstTime: Bool = true
    var isMapViewAdd:Bool = false
    var isDragAdpost : Bool = false
    var UiImagesArrAdpost = [UIImage]()
    var imageUrl:URL?
    var imgIdDrag = [Int]()
    var photoArray = [UIImage]()
   
    var imageArray = [AdPostImageArray]()
    var imgCtrlCount = 0
    
    var fieldsArray = [AdPostField]()
    var adPostValue = [AdPostValue]()
    var data = [AdPostImageArray]()
    var adID = 0
    var imageIDArray = [Int]()
    //this array get data from previous controller
    var objArray = [AdPostField]()
    var customArray = [AdPostField]()
    var haspageNumber = ""
    var localArray = AddsHandler.sharedInstance.objAdPostData
    var dataArray = [AdPostField]()
    var valueArray = [String]()
    var maximumImagesAllowed = 0
    var localVariable = ""
    var localDictionary = [String: Any]()
    var isfromEditAd = false
    
    var isFromAddData = ""
    var popUpTitle = ""
    var selectedIndex = 0
    
    var isValidUrl = false
    var isBid = true
    var isImg = true
    var isReqired = false
    var imagesMsg = ""
    var isShowPrice = true
    var isImagesRequired = "true"
    var isEditStart  = false
    var calledFromViewDidLoad = false;
    func secondViewHandle(){
        for ite in objArray {
            print(ite.fieldTypeName, ite.fieldName, ite.fieldVal, ite.fieldType)
        }
        self.dataArray = fieldsArray
        let valuesArray = ["ad_title","ad_cats1" ,"ad_price_type", "ad_price", "ad_currency", "ad_condition", "ad_warranty", "ad_type", "ad_yvideo", "checkbox"]
        let valueToremove = ["ad_title","ad_cats1"]
        let priceValuesToRemove = ["ad_currency","ad_price"]
        
        for item in dataArray {
            if AddsHandler.sharedInstance.isCategoeyTempelateOn ==  false {
                if valuesArray.contains(item.fieldTypeName) {
                    let value = item.fieldTypeName
                    let index = dataArray.index{ $0.fieldTypeName ==  value}
                    if let index = index {
                        dataArray.remove(at: index)
                    }
                }
            }
            else {
                if valueToremove.contains(item.fieldTypeName) {
                    let value = item.fieldTypeName
                    let index = dataArray.index{ $0.fieldTypeName ==  value}
                    if let index = index {
                        dataArray.remove(at: index)
                    }
                }
            }

            if priceHide == "no_price" || priceHide == "on_call" || priceHide == "free"{
                
                if priceValuesToRemove.contains(item.fieldTypeName){
                    let value = item.fieldTypeName
                    let index = dataArray.index{ $0.fieldTypeName ==  value}
                    if let index  = index {
                        dataArray.remove(at: index)
                    }
                }
            }
        }
        print(dataArray)
            
            
        
        fieldsArray = dataArray

        print(fieldsArray)
        
        
        
        
        for ob in fieldsArray{
            if ob.fieldType == "checkbox"{
                adPostValue.append( contentsOf: ob.values)
            }
        }
        
        
        self.adForest_populateData()
        self.isFirstTime = false
        self.isMapViewAdd = false
        self.tableViewAAA.reloadData()
        
    }
    
    func adForest_populateData() {
        if  AddsHandler.sharedInstance.objAdPost != nil {
            let objData = AddsHandler.sharedInstance.objAdPost
            if let titleText = objData?.data.title {
                self.title = titleText
            }
            if let id = objData?.data.adId {
                self.adID = id
            }
            if let maximumImages = objData?.data.images.numbers {
                self.maximumImagesAllowed = maximumImages
            }
            
        }
    }
    
    //MARK:- Table View Delegate Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if isFirstTime{
            return 1
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        if isFirstTime{
            if hasPageNumberAAA == "1" {
                returnValue = dataArrayAAA.count
            }
            returnValue = dataArrayAAA.count
        } else{
            
            if section == 0{
                if hasPageNumberAAA == "1" {
                    returnValue = dataArrayAAA.count
                }
                returnValue = dataArrayAAA.count
            }
            else if section == 1 {
                returnValue =  1
            }
            else if section == 2 {
                returnValue =  1
            }
            else if section == 3 {
                returnValue = fieldsArray.count
            }else if section == 4{
                returnValue = 1
            }
        }
      return returnValue
        
    }
    
    func addpostCell(indexPath: IndexPath, tableView: UITableView)->UITableViewCell{
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
            if objData.values != nil{
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
            }
            
            cell.btnPopUpAction = { () in
                cell.dropDownKeysArray = []
                cell.dropDownValuesArray = []
                cell.hasCatTemplateArray = []
                cell.hasTempelateArray = []
                cell.hasSubArray = []
                if objData.values != nil{
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
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isFirstTime{
            return addpostCell(indexPath: indexPath, tableView: tableView)
        } else {
            let section = indexPath.section
            if section == 0{
                return addpostCell(indexPath: indexPath, tableView: tableView)
            }
            
            
            
            //var isB = UserDefaults.standard.bool(forKey: "isBid")
            
            if section == 1 {
                let cell: UploadImageCell = tableView.dequeueReusableCell(withIdentifier: "UploadImageCell", for: indexPath) as! UploadImageCell

                
    //            if isImg == false{
    //                cell.isHidden = true
    //            }else{
    //                cell.isHidden = false
    //            }
                

                let objData = AddsHandler.sharedInstance.objAdPost
            
                if let imagesTitle = objData?.extra.imageText {
                    cell.lblSelectImages.text = imagesTitle
                }
                
                cell.lblPicNumber.text = String(imgCtrlCount)
    //            print(imgCtrlCount)
                cell.btnUploadImage = { () in
                
                    if self.maximumImagesAllowed == 0{
                        let msgImg = UserDefaults.standard.string(forKey: "imgMsg")
                        let alert = Constants.showBasicAlert(message: msgImg!)
                        self.presentVC(alert)
                    }
                    else{
                        let select = UserDefaults.standard.string(forKey: "select")
                        let camera = UserDefaults.standard.string(forKey: "camera")
                        let cameraNotAvailable = UserDefaults.standard.string(forKey: "cameraNotAvavilable")
                        
                        let actionSheet = UIAlertController(title: select, message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
                                       actionSheet.addAction(UIAlertAction(title:camera, style: .default, handler: { (action) -> Void in
                                           let imagePickerConroller = UIImagePickerController()
                                           imagePickerConroller.delegate = self
                                           if UIImagePickerController.isSourceTypeAvailable(.camera){
                                               imagePickerConroller.sourceType = .camera
                                           }else{
                                            let al = UserDefaults.standard.string(forKey: "aler")
                                                let ok = UserDefaults.standard.string(forKey: "okbtnNew")
                                               let alert = UIAlertController(title: al, message: cameraNotAvailable, preferredStyle: UIAlertControllerStyle.alert)
                                               let OkAction = UIAlertAction(title: ok, style: UIAlertActionStyle.cancel, handler: nil)
                                               alert.addAction(OkAction)
                                               self.present(alert, animated: true, completion: nil)
                                           }
                                           self.present(imagePickerConroller,animated:true, completion:nil)
                                       }))
                                       let gallery = UserDefaults.standard.string(forKey: "gallery")
                                       actionSheet.addAction(UIAlertAction(title: gallery, style: .default, handler: { (action) -> Void in
                                         
                                           let imagePicker = OpalImagePickerController()
                                           imagePicker.navigationBar.tintColor = UIColor.white
                                           imagePicker.maximumSelectionsAllowed = self.maximumImagesAllowed
                                            print(self.maximumImagesAllowed)
                                           imagePicker.allowedMediaTypes = Set([PHAssetMediaType.image])
                                           // maximum message
                                           let configuration = OpalImagePickerConfiguration()
                                           configuration.maximumSelectionsAllowedMessage = NSLocalizedString((objData?.data.images.message)!, comment: "")
                                           imagePicker.configuration = configuration
                                           imagePicker.imagePickerDelegate = self
                                           self.present(imagePicker, animated: true, completion: nil)
                                       
                                       }))
                                       let cancel = UserDefaults.standard.string(forKey: "cancelBtn")
                                       actionSheet.addAction(UIAlertAction(title: cancel, style: .destructive, handler: { (action) -> Void in
                                       }))
                                       if Constants.isiPadDevice {
                                           actionSheet.popoverPresentationController?.sourceView = cell.containerView
                                           actionSheet.popoverPresentationController?.sourceRect = cell.containerView.bounds
                                           self.present(actionSheet, animated: true, completion: nil)
                                       }else{
                                           self.present(actionSheet, animated: true, completion: nil)
                                       }
                    }
                   
                }
                return cell
            }
                
            else if section == 2 {
                let cell: CollectionImageCell = tableView.dequeueReusableCell(withIdentifier: "CollectionImageCell", for: indexPath) as! CollectionImageCell
            
                let objData = AddsHandler.sharedInstance.objAdPost
               
                if let sortMsg = objData?.extra.sortImageMsg {
                    cell.lblArrangeImage.text = sortMsg
                }
                if let adID = objData?.data.adId {
                    cell.ad_id = adID
                }
                if cell.isDrag == false{
                    cell.dataArray = self.imageArray
                }else{
                    isDragAdpost = true
                    imgIdDrag = cell.imageIdArrAd
                }
                print(UiImagesArrAdpost)
                imgCtrlCount = self.imageArray.count
                cell.delegate = self
                cell.collectionView.reloadData()
                return cell
            }
                
            else if section == 3 {
                let objData = fieldsArray[indexPath.row]
           
                if objData.fieldType == "textfield"  {
                    let cell: TextFieldCell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
                    
                    if objData.fieldTypeName == "ad_bidding_time"{
                      
                        print(isBid)
                        
                        if isBid == false{
                            cell.isHidden = true
                        }else{
                            cell.isHidden = false
                        }
                    }
        
                    if let title = objData.title {
                        cell.txtType.placeholder = title
                    }
                   
                    if let value = objData.fieldVal {
                        cell.txtType.text = value
                    }
                    cell.fieldName = objData.fieldTypeName
                    cell.inde = indexPath.row
                    cell.section = 2
                   // cell.selectedIndex = indexPath.row
                    cell.delegate = self
                    
                    if objData.fieldTypeName == "ad_price" {
                        if objData.fieldVal != nil{
                            textVal(value: objData.fieldVal, indexPath: indexPath.row, fieldType: "textfield", section: 2, fieldNam: objData.fieldTypeName)
                        }
                    }
                    
                    if objData.fieldTypeName == "ad_price_type"{
                        if isShowPrice == false{
                            cell.isHidden = true
                        }
                    }
                    
                    
                    
                    return cell
                }
                    
                else if objData.fieldType == "select"  {
                   
                    let cell: DropDownCell = tableView.dequeueReusableCell(withIdentifier: "DropDownCell", for: indexPath) as! DropDownCell
                    if objData.fieldTypeName == "ad_bidding"{
                        if isBid == false{
                            cell.isHidden = true
                        }else{
                            cell.isHidden = false
                        }
                    }
                    if let title = objData.title {
                        cell.lblName.text = title
                    }
                    
                    var i = 1
                    if objData.values != nil{
                        for item in objData.values {
                            
                            if item.id == "" {
                                continue
                            }
                            //                    if (defaults.string(forKey: "value") != nil) {
                            //                        if indexPath.row == selectedIndex {
                            //                            let name = UserDefaults.standard.string(forKey: "value")
                            //                            cell.oltPopup.setTitle(name, for: .normal)
                            //                        }
                            //                    }
                            if isEditStart == true {
                                if i == 1 {
                                    print(cell.selectedValue)
                                    if isfromEditAd {
                                        cell.oltPopup.setTitle(item.name, for: .normal)
                                        cell.selectedKey = String(item.id)
                                    }else{
                                        if cell.selectedValue == ""{
                                            cell.oltPopup.setTitle(objData.values[0].name, for: .normal)
                                            cell.selectedKey = String(item.id)
                                        }else{
                                            cell.oltPopup.setTitle(objData.fieldVal, for: .normal)
                                            cell.selectedKey = String(item.id)
                                        }
                                    }
                                    //  cell.oltPopup.setTitle(item.name, for: .normal)
                                    //  cell.selectedKey = String(item.id)
                                }
                                i = i + 1
                            }else{
                                
                                //                        if isfromEditAd == false{
                                //                            cell.oltPopup.setTitle(objData.values[0].name, for: .normal)
                                //                            cell.selectedKey = String(item.id)
                                //                        }else{
                                //
                                //                        }
                                //
                                
                                cell.oltPopup.setTitle(objData.values[0].name, for: .normal)
                                cell.selectedKey = String(item.id)
                            }
                            
                        }
                    }
                    cell.btnPopUpAction = { () in
                        cell.dropDownKeysArray = []
                        cell.dropDownValuesArray = []
                        cell.fieldTypeNameArray = []
                        if objData.values != nil{
                            for item in objData.values {
                                if item.id == "" {
                                    continue
                                }
                                cell.dropDownKeysArray.append(String(item.id))
                                cell.dropDownValuesArray.append(item.name)
                                cell.hasFieldsArr.append(item.hasTemplate)
                                cell.fieldTypeNameArray.append(objData.fieldTypeName)
                                //                        cell.isShowArr.append(item.isShow)
                                
                            }
                        }
                        cell.accountDropDown()
                        cell.valueDropDown.show()
                    }
                    cell.param = objData.fieldTypeName
                    cell.selectedIndex = indexPath.row
                    cell.indexP = indexPath.row
                    cell.section = 3
                    cell.fieldNam = objData.fieldTypeName
                    cell.delegate = self
                    
                    return cell
                }
                
                else if objData.fieldType == "textarea" && objData.hasPageNumber == "2"  {
                    let cell: DescriptionTableCell = tableView.dequeueReusableCell(withIdentifier: "DescriptionTableCell", for: indexPath) as! DescriptionTableCell
                    
                    if let title = objData.title {
                        cell.lblDescription.text = title
                    }
                    if let value = objData.fieldVal {
                        //cell.richEditorView.html = value
                        cell.txtDescription.text = value
                        //cell.textLabel?.text = value
                    }
                    cell.fieldName = objData.fieldTypeName
                    //cell.delegate = self
                    cell.delegateDes = self
                    cell.index = indexPath.row
                    cell.section = 3
                    return cell
                }
                    
                else if objData.fieldType == "checkbox" {
                    let cell: CheckBoxCell = tableView.dequeueReusableCell(withIdentifier: "CheckBoxCell", for: indexPath) as! CheckBoxCell
                    
                    if let title = objData.title {
                        cell.lblName.text = title
                    }
                    cell.dataArray = objData.values
                    cell.fieldName = objData.fieldTypeName
                    cell.fieldType = objData.fieldType
                    cell.indexPath = indexPath.row
                    cell.delegate = self
                    cell.tableView.reloadData()
                    return cell
                }
                    
                else if objData.fieldType == "textfield_url" {
                    let cell: AdPostURLCell = tableView.dequeueReusableCell(withIdentifier: "AdPostURLCell", for: indexPath) as! AdPostURLCell
                    
                    if let placeHolder = objData.title {
                        cell.txtUrl.placeholder = placeHolder
                    }
                    cell.fieldName = objData.fieldTypeName
                    return cell
                }
                
                else if objData.fieldType == "textfield_date" {
                    let cell: CalenderSingleTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CalenderSingleTableViewCell", for: indexPath) as! CalenderSingleTableViewCell
                    if let title = objData.fieldVal {
                        //cell.oltDate.setTitle(title, for: .normal)
                        cell.txtDate.text = title
                    }
                    if let title = objData.title {
                        cell.txtDate.placeholder = title
                    }
                    cell.indexP = indexPath.row
                    cell.section = 3
                    cell.fieldName = objData.fieldTypeName
                    cell.delegate = self
                    
                    return cell
                }
                    
                else if objData.fieldType == "radio" {

                    let cell: AdpostRadioTableViewCell = tableView.dequeueReusableCell(withIdentifier: "AdpostRadioTableViewCell", for: indexPath) as! AdpostRadioTableViewCell

                    if let title = objData.title {
                        cell.lblTitle.text = title
                    }
                    cell.dataArray = objData.values
                    cell.isSelected = objData.tempIsSelected
                    cell.index = indexPath.row
                    cell.section = 3
                    cell.delegate = self
                    radVal(rVal: objData.fieldVal, fieldType: "radio", indexPath: indexPath.row, isSelected: objData.tempIsSelected, fieldNam: objData.fieldTypeName)
                    cell.fieldName = objData.fieldTypeName
                    cell.tableView.reloadData()
                    
                    return cell

                }
                
                else if objData.fieldType == "radio_color" {
                    
                    
                    let cell: RadioColorAdTableViewCell = tableView.dequeueReusableCell(withIdentifier: "RadioColorAdTableViewCell", for: indexPath) as! RadioColorAdTableViewCell

                    if let title = objData.title {
                        cell.lblTitle.text = title
                        cell.title = title
                    }
                    cell.fieldName = objData.fieldTypeName
                    cell.dataArray = objData.values
                    cell.index = indexPath.row
                    cell.delegate = self as! ColorRadioDelegateAdpost
    //                cell.collectionView.reloadData()
                    return cell
                }
                
                else if objData.fieldType == "textfield_number" {
                    let cell: NumericRangeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NumericRangeTableViewCell", for: indexPath) as! NumericRangeTableViewCell
                    
                    if let title = objData.title {
                        cell.lblTitle.text = title
                        cell.txtMinPrice.placeholder = title
                    }
                    cell.txtMinPrice.text = objData.fieldVal
                    cell.delegate = self
                    numberRange(index: indexPath.row, fieldName: objData.fieldTypeName, fieldVal: objData.fieldVal, fieldType: "textfield_number")
                    cell.fieldType = objData.fieldType
                    cell.fieldName = objData.fieldTypeName
                    cell.txtMinPrice.keyboardType = .numberPad
                    return cell
                }
                

            } else if section == 4 {
                if !isMapViewAdd{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MapviewShowButtonCell", for: indexPath)
                    return cell
                } else{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MapViewCell", for: indexPath) as! MapViewCell
                    cell.txtAddress.delegate = self
                    self.mapViewCell = cell
                    self.adForest_populateData1()
                    
                    map.isMyLocationEnabled = true
                    map.settings.myLocationButton = true
                    addMapTrackingButton()
                    return cell
                }
            }
        }
        return UITableViewCell()
    }
    func returnHeightAddpostCell(indexPath: IndexPath)-> CGFloat{
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFirstTime{
            return returnHeightAddpostCell(indexPath: indexPath)
        } else{
            let section = indexPath.section
            var height : CGFloat = 0
            if section == 0{
                height = returnHeightAddpostCell(indexPath: indexPath)
            }
             else if section == 1 {
                
                  height = 100

            } else if section == 2 {
                if imageArray.isEmpty {
                    height = 0
                } else {
                    height = 140
                }
            
            } else if section == 3 {
                let objData = fieldsArray[indexPath.row]
                if objData.fieldType == "textarea" {
                    height = 250
                } else if objData.fieldType == "select" {
                    height = 80
                } else if objData.fieldType == "textfield" {
                    height = 80
                } else if objData.fieldType == "checkbox" {
                    height = 230
                } else if objData.fieldType == "textfield_url" {
                    height = 80
                } else if objData.fieldType == "textfield_date" {
                    height = 80
                }
                else if objData.fieldType == "radio_color" {
                    height = 80
                }
                else if objData.fieldType == "textfield_number" {
                    height = 110
                }
                else if objData.fieldType == "radio" {
                    return 130
                }
                 
            }else if section == 4{
                if !isMapViewAdd{
                   return UITableViewAutomaticDimension
                }else {
                    return 805
                }
            }
            return height
        }
    }
    
    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingImages images: [UIImage]) {

        if images.isEmpty {
        }
        else {
            self.photoArray = images
            let param: [String: Any] = [ "ad_id": String(adID)]
            print(param)
            self.adForest_uploadImages(param: param as NSDictionary, images: self.photoArray)
        }
            presentedViewController?.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        self.dismissVC(completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if (info[UIImagePickerControllerOriginalImage] as? UIImage) != nil {
            if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
    
                self.photoArray = [pickedImage]
                let param: [String: Any] = [ "ad_id": String(adID)]
                print(param)
                self.adForest_uploadImages(param: param as NSDictionary, images: self.photoArray)
                
            }
            dismiss(animated: true, completion: nil)
           
        }
    }
    
    func imgeCount(count: Int) {
        imgCtrlCount = count
//        self.tableView.reloadData()
     }
    //MARK:- API Call
    
    //post images
    
    func adForest_uploadImages(param: NSDictionary, images: [UIImage]) {
        //self.showLoader()
        uploadingProgressBar.progress = 0.0
        uploadingProgressBar.detailTextLabel.text = "0% Completed"
        uploadingProgressBar.show(in: view)
        
        adPostUploadImages(parameter: param, imagesArray: images, fileName: "File", uploadProgress: { (uploadProgress) in

        }, success: { (successResponse) in
            self.uploadingProgressBar.dismiss(animated: true)
            //self.stopAnimating()
            if successResponse.success {
                self.imageArray = successResponse.data.adImages
                self.imgCtrlCount = successResponse.data.adImages.count
                //add image id to array to send to next View Controller and hit to server
                for item in self.imageArray {
                    self.imageIDArray.append(item.imgId)
                }
                self.maximumImagesAllowed = successResponse.data.images.numbers
                self.imagesMsg = successResponse.data.images.message
                
                UserDefaults.standard.set( self.imagesMsg, forKey: "imgMsg")
                self.tableViewAAA.reloadData()
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            self.uploadingProgressBar.dismiss(animated: true)
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
     func adPostUploadImages(parameter: NSDictionary , imagesArray: [UIImage], fileName: String, uploadProgress: @escaping(Int)-> Void, success: @escaping(AdPostImagesRoot)-> Void, failure: @escaping(NetworkError)-> Void) {
        
        let url = Constants.URL.baseUrl+Constants.URL.adPostUploadImages
        print(url)
        NetworkHandler.uploadImageArray(url: url, imagesArray: imagesArray, fileName: "File", params: parameter as? Parameters, uploadProgress: { (uploadProgress) in
            print(uploadProgress)
            let currentProgress = Float(uploadProgress)/100
            self.uploadingProgressBar.detailTextLabel.text = "\(uploadProgress)% Completed"
            self.uploadingProgressBar.setProgress(currentProgress, animated: true)
        }, success: { (successResponse) in
            let dictionary = successResponse as! [String: Any]
            let objImg = AdPostImagesRoot(fromDictionary: dictionary)
            success(objImg)
        }) { (error) in
            failure(NetworkError(status: Constants.NetworkError.generic, message: error.message))
        }
    }
    
    //MARK:- IBActions
    
    @IBAction func actionShowPassword(_ sender: Any) {
        onForwardButtonClciked()
        
    }
    
    @IBAction func onForwardButtonClcikedSecond(_ sener: UIButton) {
//        var sectionRequired = 0
//        var indexRequired = 0
        var requiredCheck = false
        localVariable = ""
        print(fieldsArray)
        for index in  0..<fieldsArray.count {
            if let objData = fieldsArray[index] as? AdPostField {
                if objData.fieldType == "select"  {
                    if let cell = tableViewAAA.cellForRow(at: IndexPath(row: index, section: 3)) as? DropDownCell {
                        var obj = AdPostField()
                        obj.fieldType = "select"
                        obj.fieldTypeName = cell.param
                        
                        print(cell.param)
                        obj.fieldVal = cell.selectedKey
                        objArray.append(obj)
                        customArray.append(obj)
                    }
                }
                 if objData.fieldType == "textfield"  {
                    if let cell = tableViewAAA.cellForRow(at: IndexPath(row: index, section: 3)) as? TextFieldCell {
                            var obj = AdPostField()
                            obj.fieldType = "textfield"
                            obj.fieldVal = cell.txtType.text
                            obj.fieldTypeName = cell.fieldName
                    
                            objArray.append(obj)
                            customArray.append(obj)
                    }
                }
                else if objData.fieldType == "textarea" {
                    if let cell = tableViewAAA.cellForRow(at: IndexPath(row: index, section: 3)) as? DescriptionTableCell {
                        var obj = AdPostField()
                        obj.fieldType = "textarea"
                        obj.fieldVal = cell.txtDescription.text!
                        print(cell.txtDescription.text!)
                        obj.fieldTypeName = "ad_description"
                        objArray.append(obj)
                        //dataArray.app
                        customArray.append(obj)
                    }
                }
                    
//                else if objData.fieldType == "checkbox" {
//                    if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? CheckBoxCell {
//                        var obj = AdPostField()
//                        obj.fieldTypeName = cell.fieldName
//                        cell.fieldName = obj.fieldTypeName
//                        objArray.append(obj)
//                        customArray.append(obj)
////                        localVariable = ""
////                        for item in cell.valueArray {
////                            localVariable += item + ","
////                        }
////                        self.localDictionary[cell.fieldName] = localVariable
//                    }
//                }
                else if objData.fieldType == "textfield_url" {
                    if let cell: AdPostURLCell = tableViewAAA.cellForRow(at: IndexPath(row: index, section: 3)) as? AdPostURLCell {
                        var obj = AdPostField()
                        obj.fieldTypeName = cell.fieldName
                        guard let txtUrl = cell.txtUrl.text else {return}
                        if txtUrl.isValidURL {
                            obj.fieldVal = txtUrl
                            self.isValidUrl = true
                        } else {
                            cell.txtUrl.shake(6, withDelta: 10, speed: 0.06)
                            self.isValidUrl = false
                        }
                       

                        objArray.append(obj)
                        customArray.append(obj)
                    }
                }
//                else if objData.fieldType == "textfield_date" {
//                    if let cell: CalenderSingleTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? CalenderSingleTableViewCell {
//                        var obj = AdPostField()
//                        obj.fieldTypeName = "date_input" //cell.fieldName
//                        obj.fieldVal = "\(cell.currentDate)"
//                        objArray.append(obj)
//                        customArray.append(obj)
//                    }
//                }
//                else if objData.fieldType == "radio_color" {
//                    if let cell: RadioColorAdTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as? RadioColorAdTableViewCell {
//                        var obj = AdPostField()
//                        obj.fieldTypeName = "select_colors" //cell.fieldName
//                        print(cell.selectedColor)
//                        obj.fieldVal = cell.selectedColor
//                        objArray.append(obj)
//                        customArray.append(obj)
//                    }
//                }
//                else if objData.fieldType == "textfield_number" {
//                    if let cell: NumericRangeTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as?  NumericRangeTableViewCell{
//                        var obj = AdPostField()
//                        obj.fieldTypeName = "number_range" //cell.fieldName
//                        obj.fieldVal = cell.txtMinPrice.text
//                        print(cell.txtMinPrice.text!)
//                        objArray.append(obj)
//                        customArray.append(obj)
//                    }
//                }
                
//                else if objData.fieldType == "radio" {
//                    if let cell: AdpostRadioTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as?  AdpostRadioTableViewCell{
//                        var obj = AdPostField()
//                        obj.fieldTypeName = "radio" //cell.fieldName
//                        obj.fieldVal = cell.seletedRad
//                        print( cell.seletedRad)
//                        objArray.append(obj)
//                        customArray.append(obj)
//                    }
//                }
                    
                    
//                else if objData.fieldType == "textfield_number" {
//                    if let cell: NumericRangeTableViewCell = tableView.cellForRow(at: IndexPath(row: index, section: 2)) as?  NumericRangeTableViewCell{
//                        var obj = AdPostField()
//                        obj.fieldTypeName = "number_range" //cell.fieldName
//                        obj.fieldVal = cell.txtMinPrice.text
//
//
//                        objArray.append(obj)
//                        customArray.append(obj)
//                    }
//                }
            }
        }
//        let adPostVC = self.storyboard?.instantiateViewController(withIdentifier: "AdPostMapController") as! AdPostMapController
//        if imageIDArray.isEmpty {
//            let alert = Constants.showBasicAlert(message: "Images Required")
//            self.presentVC(alert)
//        }
//        else if isValidUrl == false {
//
//        }
       // else {
        if isDragAdpost == true{
            imageIdArray = imgIdDrag
        }else{
            imageIdArray = imageIDArray
        }
//            adPostVC.imageIdArray = imageIDArray
            objArray1 = objArray
        print(objArray1)
            customArray1 = self.customArray
            print(self.customArray)
            
            localVariable1 = self.localVariable
            valueArray1 = self.valueArray
            localDictionary1 = self.localDictionary
        if isfromEditAd{
            isfromEditAd1 = self.isfromEditAd
        }
        let objData = AddsHandler.sharedInstance.objAdPost
        if self.isImagesRequired == objData?.data.images.isRequired{

            let msgImg = UserDefaults.standard.string(forKey: "ImgReqMessage")
            if imgCtrlCount == 0{
                let alert = Constants.showBasicAlert(message: msgImg!)
                self.presentVC(alert)
            }
        else{
                thirdViewDidLoad()

            }

        }
       
        else{
            thirdViewDidLoad()

        }
        
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

    
    //////////////////////////thirdViewController code ///////////////////////////
    
    
    
    
    //MARK:- Properties
    let locationDropDown = DropDown()
    lazy var dropDowns : [DropDown] = {
        return [
            self.locationDropDown
        ]
    }()
    
    var popUpArray = [String]()
    var hasSubArray = [Bool]()
    var locationIdArray = [String]()
    
    var hasSub = false
    var selectedID = ""
    
    var popUpTitle1 = ""
    var popUpConfirm = ""
    var popUpCancel = ""
    var popUpText = ""
    
    let map = GMSMapView()
    var locationManager = CLLocationManager()
    let newPin = MKPointAnnotation()
    let regionRadius: CLLocationDistance = 1000
    var initialLocation = CLLocation(latitude: 25.276987, longitude: 55.296249)
    
    var latitude = ""
    var longitude = ""
    // var objFieldData = [AdPostField]()
    var valueArray1 = [String]()
    
    var localVariable1 = ""
    var isSimpleAddress = true
    var isfromEditAd1 = false


    
    
    //this array get data from previous controller
    var objArray1 = [AdPostField]()
    
    
    var imageIdArray = [Int]()
    var descriptionText = ""
    
    var addInfoDictionary = [String: Any]()
    var customDictionary = [String: Any]()
    var customArray1 = [AdPostField]()
    var imageArray1 = AddsHandler.sharedInstance.adPostImagesArray
    // get values in populate data and send it with parameters
    var phone_number = ""
    var address = ""
    
    var isFeature = "false"
    var isBump = false
    var localDictionary1 = [String: Any]()
    var selectedCountry = ""
    var isTermCond = false
    var termCondURL = ""
//    let defaults = UserDefaults.standard
    
    var mapBoxLat = ""
    var mapBoxLong = ""
    var mapBoxPlace = ""
    var fromAdDetail = false;
    var adDetailStyle: String = UserDefaults.standard.string(forKey: "adDetailStyle")!
    var mapViewCell: MapViewCell?
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
extension AadPostController:textValDelegate,textValDescDelegate,textValDateDelegate,textSelectDropDown,ColorRadioDelegateAdpost,radioDelegateAdpost,checkBoxProtocol,numberrangeProtocol{
    func numberRange(index: Int, fieldName: String, fieldVal: String,fieldType : String) {
        if fieldType == "textfield_number"{
            var obj = AdPostField()
            obj.fieldType = "textfield_number"
            obj.fieldVal = fieldVal
            obj.fieldTypeName = fieldName
//            self.fieldsArray[index].tempIsSelected = isSelected
//            self.fieldsArray[index].isRequired = false
            print(adPostValue)
//            self.adPostValue[index].isChecked = isSelected
            self.dataArray.append(obj)
            isEditStart = true
            self.fieldsArray.append(obj)
            objArray.append(obj)
            customArray.append(obj)
        }
    }
    
    func checkBoxesChecked(checkBoxID: String, fieldType: String, indexPath: Int, isSelected: Bool, fieldNam: String) {
        if fieldType == "checkbox"{
            var obj = AdPostField()
            obj.fieldType = "checkbox"
            obj.fieldVal = checkBoxID
            obj.fieldTypeName = fieldNam
            self.fieldsArray[indexPath].tempIsSelected = isSelected
            self.fieldsArray[indexPath].isRequired = false
            print(adPostValue)
            self.adPostValue[indexPath].isChecked = isSelected
            self.dataArray.append(obj)
            isEditStart = true
            self.fieldsArray.append(obj)
            objArray.append(obj)
            customArray.append(obj)
        }
    }
    
   

    func radVal(rVal: String, fieldType: String, indexPath: Int, isSelected: Bool,fieldNam:String) {
        if fieldType == "radio"{
            var obj = AdPostField()
            obj.fieldType = "radio"
            obj.fieldVal = rVal
            obj.fieldTypeName = fieldNam //"radio"
            self.fieldsArray[indexPath].tempIsSelected = isSelected
            self.fieldsArray[indexPath].isRequired = false
            self.dataArray.append(obj)
            isEditStart = true
            self.fieldsArray.append(obj)
            objArray.append(obj)
            customArray.append(obj)
        }
    }

    func colorVal(colorCode: String, fieldType: String, indexPath: Int, isSelected: Bool,fieldNam:String) {
        if fieldType == "radio_color"{
            var obj = AdPostField()
            obj.fieldType = "radio_color"
            obj.fieldVal = colorCode
            obj.fieldTypeName = fieldNam //"select_colors"
            self.fieldsArray[indexPath].tempIsSelected = isSelected
            self.fieldsArray[indexPath].isRequired = false
            self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            isEditStart = true

            objArray.append(obj)
            customArray.append(obj)
        }
    }

    func textValSelecrDrop(value: String, indexPath: Int, fieldType: String, section: Int,fieldName:String,isShow:Bool,valueName:String) {
        if fieldType == "select"{
            var obj = AdPostField()
            obj.fieldType = "select"
            obj.fieldVal = value
            obj.fieldTypeName = fieldName
            isShowPrice = isShow
//            self.fieldsArray[indexPath].isRequired = false
            self.fieldsArray[indexPath].fieldVal = valueName
            self.dataArray[indexPath].fieldVal = valueName
            self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            objArray.append(obj)
            customArray.append(obj)
            isEditStart = true
            //tableView.reloadData()
        }
    }
    
    func textValDate(value: String, indexPath: Int, fieldType: String, section: Int,fieldNam:String) {
        if fieldType == "textfield_date"{
            var obj = AdPostField()
            obj.fieldType = "textfield_date"
            obj.fieldVal = value
            obj.fieldTypeName = fieldNam //"date_input"
            self.fieldsArray[indexPath].fieldVal = value
            self.fieldsArray[indexPath].isRequired = false
            self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            isEditStart = true
            objArray.append(obj)
            customArray.append(obj)
        }
    }
    
    func textValDesc(value: String, indexPath: Int, fieldType: String, section: Int,fieldNam:String) {
//        if fieldType == "textarea"{
//            var obj = AdPostField()
//            obj.fieldType = "textarea"
//            obj.fieldVal = value
//            obj.fieldTypeName = fieldNam  //"ad_description"
//            print(value)
//            self.fieldsArray[indexPath].fieldVal = value
//            self.fieldsArray[indexPath].isRequired = false
//            //self.dataArray.append(obj)
//            self.fieldsArray.append(obj)
//            objArray.append(obj)
//            isEditStart = true
//
//            //customArray.append(obj)
//        }
    }
    
    func textVal(value: String, indexPath: Int,fieldType:String,section:Int,fieldNam:String) {
        if fieldType == "textfield"{
            var obj = AdPostField()
            obj.fieldType = "textfield"
            obj.fieldVal = value
            obj.fieldTypeName = fieldNam //fieldType
            
            
            
            self.fieldsArray[indexPath].fieldVal = value
            self.fieldsArray[indexPath].isRequired = false
            self.dataArray.append(obj)
            self.fieldsArray.append(obj)
            isEditStart = true

            objArray.append(obj)
            customArray.append(obj)
            
        }
    }
    
}
