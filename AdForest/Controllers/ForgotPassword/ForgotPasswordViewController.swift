//
//  ForgotPasswordViewController.swift
//  Adforest
//
//  Created by apple on 1/2/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ForgotPasswordViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    //MARK:- Outlets
    @IBOutlet weak var btnResenEmail: UIButton!
    @IBOutlet weak var lblResendEmail: UILabel!
    @IBOutlet weak var viewResendEmail: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerImage: UIImageView!
    @IBOutlet weak var lblEnterEmail: UILabel!
    @IBOutlet weak var emailIcon: UIImageView!
    @IBOutlet weak var emailField: UITextField! {
        didSet {
            emailField.delegate = self
        }
    }
    @IBOutlet weak var backButton: UIButton! {
        didSet {
            backButton.contentHorizontalAlignment = .left
        }
    }
    @IBOutlet weak var submitButton: UIButton! {
        didSet {
            submitButton.contentHorizontalAlignment = .right
        }
    }
    
    //MARK:- Properties
    var defaults = UserDefaults.standard
    var isFromVerification = false
    var user_id = 0
    var bgColor = UserDefaults.standard.string(forKey: "mainColor")
    var contactAdmin = ""
    var contactPageTitle = ""
    var contactPageUrl = ""
    let storyboard2 = UIStoryboard(name: "Main2", bundle: nil)
    
    
    
    //MARK:- Application Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        viewResendEmail.isHidden = true
        lblResendEmail.isHidden = true
        btnResenEmail.isHidden = true
        if isFromVerification {
            self.userConfirmation()
        }
        else{
            self.adForest_ForgotData()
        }
        txtFieldsWithRtl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Text Field Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            emailField.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Custom
    
    func txtFieldsWithRtl(){
        if UserDefaults.standard.bool(forKey: "isRtl") {
            emailField.textAlignment = .right
        } else {
            emailField.textAlignment = .left
        }
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func adForest_populateData() {
        if UserHandler.sharedInstance.objForgotDetails != nil {
            let objData = UserHandler.sharedInstance.objForgotDetails
            
            if let bgColor = defaults.string(forKey: "mainColor") {
                self.headerView.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
            
            if let imgUrl = URL(string: (objData?.logo)!) {
                headerImage.sd_setShowActivityIndicatorView(true)
                headerImage.sd_setIndicatorStyle(.gray)
                headerImage.sd_setImage(with: imgUrl, completed: nil)
            }
            
            if let headingText = objData?.heading {
                self.lblEnterEmail.text = headingText
            }
            
            if let emailTxt = objData?.text {
                self.emailField.placeholder = emailTxt
            }
            
            if let submitText = objData?.submitText {
                self.submitButton.setTitle(submitText, for: .normal)
            }
            if let backText = objData?.backText {
                self.backButton.setTitle(backText, for: .normal)
            }
            
        }
        else {
            
        }
    }
    
    func adForest_populateUserConfirmationData() {
        if UserHandler.sharedInstance.userConfirmationData != nil {
            let objData =  UserHandler.sharedInstance.userConfirmationData
            
            if let bgColor = defaults.string(forKey: "mainColor") {
                self.headerView.backgroundColor = Constants.hexStringToUIColor(hex: bgColor)
            }
            
            if let imgUrl = URL(string: (objData?.logo)!) {
                headerImage.sd_setImage(with: imgUrl, completed: nil)
                headerImage.sd_setShowActivityIndicatorView(true)
                headerImage.sd_setIndicatorStyle(.gray)
            }
            if let headingText = objData?.heading {
                self.lblEnterEmail.text = headingText
            }
            if let confirmText = objData?.text {
                self.emailField.placeholder = confirmText
            }
            if let submitText = objData?.submitText {
                self.submitButton.setTitle(submitText, for: .normal)
            }
            if let backText = objData?.backText {
                self.backButton.setTitle(backText, for: .normal)
            }
            if let lblText = objData?.confirmationText{
                self.lblResendEmail.text = lblText
            }
            if let btnHead = objData?.confirmationResend{
                
                self.btnResenEmail.setTitleColor(Constants.hexStringToUIColor(hex: bgColor!), for: .normal)
                self.btnResenEmail.setTitle(btnHead, for: .normal)
            }
            contactAdmin = (objData?.confirmationContactAdmin)!
            contactPageTitle = (objData?.contactPageTitle)!
            contactPageUrl = (objData?.contactPageUrl)!
            print(contactPageUrl)
        }
        else {
            
        }
    }
    
    //MARK:- API Call
    func adForest_submitContactSeller(param: NSDictionary) {
        self.showLoader()
        UserHandler.resendEmail(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                    self.dismissVC(completion: nil)
                })
                self.presentVC(alert)
                self.btnResenEmail.setTitle(self.contactAdmin, for: .normal)
                
                
            } else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
                self.btnResenEmail.setTitle(self.contactAdmin, for: .normal)
                
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    //MARK:- IBActions
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    //MARK:- IBActions
    @IBAction func resendButtonPressed(_ sender: UIButton) {
        if sender.tag == 0 {
            let param: [String: Any] = ["user_id": user_id]
            print(param)
            adForest_submitContactSeller(param: param as NSDictionary)
            sender.tag = 1
        }
        else{
            let contactWithAdmin = self.storyboard2.instantiateViewController(withIdentifier: "ContactWithAdminViewController") as! ContactWithAdminViewController
            contactWithAdmin.pageTitle = contactPageTitle
            contactWithAdmin.pageUrl = contactPageUrl
            self.navigationController?.pushViewController(contactWithAdmin, animated: true)
            print(sender.tag)
        }
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        guard let email = emailField.text else {
            return
        }
        if email == "" {
            self.emailField.shake(6, withDelta: 10, speed: 0.06)
        }
        else {
            if isFromVerification {
                let param: [String: Any] = ["user_id": user_id, "confirm_code": email]
                print(param)
                self.adForest_userConfirmed(parameter: param as NSDictionary)
            }
            else {
                let param: [String: Any] = ["email": email]
                print(param)
                self.adForest_userForgot(param: param as NSDictionary)
            }
        }
    }
    
    //MARK:- API Call
    
    func adForest_ForgotData() {
        self.showLoader()
        UserHandler.forgotDetails(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success == true {
                UserHandler.sharedInstance.objForgotDetails = successResponse.data
                self.adForest_populateData()
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
            
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    // User Forgot Password
    
    func adForest_userForgot(param: NSDictionary) {
        self.showLoader()
        UserHandler.forgotUser(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success == true {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
            else {
                let alert = Constants.showBasicAlert(message: successResponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
    
    
    // User Confirmation Data
    func userConfirmation() {
        self.showLoader()
        UserHandler.userConfirmation(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                UserHandler.sharedInstance.userConfirmationData = successResponse.data
                self.viewResendEmail.isHidden = false
                self.lblResendEmail.isHidden = false
                self.btnResenEmail.isHidden = false
                self.adForest_populateUserConfirmationData()
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
    
    //User Confirmation Post
    func adForest_userConfirmed(parameter: NSDictionary) {
        self.showLoader()
        UserHandler.userConfirmationPost(parameter: parameter, success: { (successresponse) in
            self.stopAnimating()
            if successresponse.success {
                let alert = AlertView.prepare(title: "", message: successresponse.message, okAction: {
                    self.appDelegate.moveToLogin()
                })
                self.presentVC(alert)
            } else{
                let alert = Constants.showBasicAlert(message: successresponse.message)
                self.presentVC(alert)
            }
        }) { (error) in
            self.stopAnimating()
            let alert = Constants.showBasicAlert(message: error.message)
            self.presentVC(alert)
        }
    }
}
