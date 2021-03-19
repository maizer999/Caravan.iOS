//
//  ContactWithSellerViewController.swift
//  AdForest
//
//  Created by Glixen on 17/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ContactWithSellerViewController: UIViewController ,NVActivityIndicatorViewable, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var TxtHintMessage: UITextField!
    @IBOutlet weak var TxtName: UITextField!
    @IBOutlet weak var TxtEmail: UITextField!
    @IBOutlet weak var TxtPhoneNumber: UITextField!
    @IBOutlet weak var TxtFieldMessage: UITextView!{
        didSet {
            TxtFieldMessage.delegate = self
            TxtFieldMessage.layer.borderColor = UIColor.lightGray.cgColor
            TxtFieldMessage.layer.borderWidth = 0.5
        }
    }
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var imgViewHeader: UIImageView!{
        didSet {
            imgViewHeader.makeRounded()
            
        }
    }
    
    @IBOutlet weak var btnCancel: UIButton!{
        didSet{
            if let mainColor = defaults.string(forKey: "mainColor") {
                btnCancel.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    @IBOutlet weak var btnSubmit: UIButton!{
        didSet{
            if let mainColor = defaults.string(forKey: "mainColor") {
                btnSubmit.backgroundColor = Constants.hexStringToUIColor(hex: mainColor)
            }
        }
    }
    
    @IBOutlet weak var ContainerView: UIView!{
        didSet{
            ContainerView.addShadowToView()
            ContainerView.layer.cornerRadius = 5
        }
    }
    let defaults = UserDefaults.standard
    var delegate :leftMenuProtocol?
    var ad_ID : Int = 0
    
    
    var nameTitle : String!
    var nameKey : String!
    var nameRequired : Bool!
    
    var emailTitle : String!
    var emailKey : String!
    var emailRequired : Bool!
    
    var phoneNumberTitle : String!
    var phoneNumberKey : String!
    var phoneNumberRequired : Bool!
    
    var messageTitle :String!
    var messageKey : String!
    var messageRequired : Bool!
    
    var btnSubmitText : String!
    var btnCancelText : String!
    var imageError = UIImageView()
    
    var correctFormat : Bool!
    
    
    private let errorMessage = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TxtEmail.delegate = self                  //set delegate to textfile
        TxtName.delegate = self                  //set delegate to textfile
        TxtPhoneNumber.delegate = self                  //set delegate to textfile
        TxtFieldMessage.delegate = self                  //set delegate to textView
        
        TxtName.placeholder = nameTitle
        TxtEmail.placeholder = emailTitle
        TxtPhoneNumber.placeholder = phoneNumberTitle
        TxtPhoneNumber.keyboardType = .numberPad
        TxtHintMessage.placeholder = messageTitle
        TxtHintMessage.isUserInteractionEnabled = false
        //        TxtFieldMessage.text = messageTitle
        // TxtFieldMessage.placeholder = messageTitle
        print(ad_ID)
        print(nameTitle)
        print(emailTitle)
        print(phoneNumberTitle)
        print(messageTitle)
        if UserDefaults.standard.bool(forKey: "isRtl") {
            TxtName.textAlignment = .right
            TxtEmail.textAlignment = .right
            TxtPhoneNumber.textAlignment = .right
            TxtHintMessage.textAlignment = .right
            TxtFieldMessage.textAlignment = .right

        }else{
            TxtName.textAlignment = .left
            TxtEmail.textAlignment = .left
            TxtPhoneNumber.textAlignment = .left
            TxtHintMessage.textAlignment = .left
            TxtFieldMessage.textAlignment = .left
        }
        
        btnSubmit.setTitle(btnSubmitText, for: .normal)
        btnCancel.setTitle(btnCancelText, for: .normal)
        self.addBackButtonToNavigationBar()
        
        
        //        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        //        UINavigationBar.appearance().barTintColor = UIColor.white
        //        UINavigationBar.appearance().tintColor = UIColor.orange
        
        // Do any additional setup after loading the view.
    }
    
    func addBackButtonToNavigationBar() {
        let leftButton = UIBarButtonItem(image: #imageLiteral(resourceName: "backbutton"), style: .done, target: self, action: #selector(moveToParentController))
        leftButton.tintColor = UIColor.white
        self.navigationItem.leftBarButtonItem = leftButton
    }
    @objc func moveToParentController() {
        self.navigationController?.popViewController(animated: true)
        //        self.delegate?.changeViewController(.main)
    }
    
    func errorTxtEmailField(_ sender: UITextField) {
        let imageName = "close"
        let image = UIImage(named: imageName)
        imageError = UIImageView(image: image!)
        //        imageError.frame.origin.x = TxtEmail.frame.width - 10
        //        imageError.frame.origin.y = 305 + TxtEmail.frame.height
        imageError.frame =  CGRect(x: 360, y: 350, width: 20, height: 20)
        view.addSubview(imageError)
        
    }
    func errorTxtNameField(_ sender: UITextField) {
        let imageName = "close"
        let image = UIImage(named: imageName)
        imageError = UIImageView(image: image!)
        imageError.frame = CGRect(x: 360, y: 400, width: 20, height: 20)
        //        imageError.frame.origin.x = TxtName.frame.width - 10
        //        imageError.frame.origin.y = TxtName.frame.origin.y  + (TxtName.frame.height) + 60
        view.addSubview(imageError)
        
    }
    func errorTxtPhoneNumberField(_ sender: UITextField) {
        let imageName = "close"
        let image = UIImage(named: imageName)
        imageError = UIImageView(image: image!)
        imageError.frame = CGRect(x: 360, y: 440, width: 20, height: 20)
        view.addSubview(imageError)
        
    }
    func errorTxtMessageField(_ sender: UITextView) {
        let imageName = "close"
        let image = UIImage(named: imageName)
        imageError = UIImageView(image: image!)
        imageError.frame = CGRect(x: 360, y: 500, width: 20, height: 20)
        view.addSubview(imageError)
        
    }
    // MARK: - Delegate method
    
    // UITextField Delegates
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("TextField did begin editing method called")
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("TextField did end editing method called\(textField.text!)")
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        print("TextField should end editing method called")
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        imageError.isHidden = true
        //For mobile number validation
        if textField == TxtPhoneNumber {
            let allowedCharacters = CharacterSet(charactersIn:"+0123456789 ")//Here change this characters based on your requirement
            let characterSet = CharacterSet(charactersIn: string)
            return allowedCharacters.isSuperset(of: characterSet)
            
        }
        
        
        print("While entering the characters this method gets called")
        return true;
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    // UITextField Delegates
    
    func textViewDidBeginEditing(_ textView: UITextView) {
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("shouldInteractWith")
        return true
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("textViewShouldEndEditing")
        return true
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        print("Should Begin Editing")
        return true
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        imageError.isHidden = true
        if textView == TxtFieldMessage{
            TxtHintMessage.isHidden = true
        }
        print("textViewDidChange")
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.characters.count > 0 {
            print(textView.text)

        }
        else{
            TxtHintMessage.isHidden = false
            print("ended TextView")

        }
        //           if textView == yourTxtView {
        //               txtNote.text = "Note:"
        //               txtNote.textColor = .gray
        //           }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    //MARK:- IBActions
    @IBAction func actionSubmit(_ sender: Any) {
        guard let email = TxtEmail.text else {return}
        guard let name = TxtName.text else {return}
        guard let phoneNumber = TxtPhoneNumber.text else {return}
        
        guard let description = TxtFieldMessage.text else {return}
        
        if email == "" && emailRequired == true {
//            self.errorTxtEmailField(TxtEmail)
            TxtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !email.isValidEmail {
//            self.errorTxtEmailField(TxtEmail)
            TxtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if name == "" && nameRequired == true {
//            self.errorTxtNameField(TxtName)
            TxtName.shake(6, withDelta: 10, speed: 0.06)
        }
        else if phoneNumber == "" && phoneNumberRequired ==  true {
//            self.errorTxtPhoneNumberField(TxtPhoneNumber)
            TxtPhoneNumber.shake()
            
        }
        else if description == "" && messageRequired ==  true {
//            self.errorTxtMessageField(TxtFieldMessage)
            TxtFieldMessage.shake()
            
        }
        else {
            let param : [String: Any] = ["ad_id": ad_ID , nameKey: name, emailKey: email, phoneNumberKey: phoneNumber,messageKey: description]
            print(param)
            self.adForest_submitContactSeller(param: param as NSDictionary)
            //            self.adForest_submit(param: param as NSDictionary)
        }
    }
    func showLoader() {
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (success) in
            self.dismissVC(completion: nil)
        }
    }
    
    
    //MARK:- API Call
    func adForest_submitContactSeller(param: NSDictionary) {
        self.showLoader()
        UserHandler.contactSeller(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.dismissVC(completion: nil)
                })
                self.presentVC(alert)
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
    
    
    
    
}


/// Extend UITextView and implemented UITextViewDelegate to listen for changes
extension UITextView: UITextViewDelegate {
    
    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?
            
            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }
            
            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    //    public func textViewDidChange(_ textView: UITextView) {
    //        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
    //            placeholderLabel.isHidden = !self.text.isEmpty
    //        }
    //    }
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String) {
        let placeholderLabel = UILabel()
        
        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        
        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        self.resizePlaceholder()
        self.delegate = self
    }
    
}
