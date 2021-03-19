//
//  RegisterViewController.swift
//  Adforest
//
//  Created by apple on 1/2/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import NVActivityIndicatorView
import AuthenticationServices
//import LinkedinSwift

class RegisterViewController: UIViewController,UITextFieldDelegate, UIScrollViewDelegate, NVActivityIndicatorViewable,GIDSignInDelegate,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    //MARK:- Outlets
    
    
    @IBOutlet weak var collectionView: UICollectionView!{
        didSet{
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.isScrollEnabled = false
            let layout = UICollectionViewFlowLayout()
            layout.minimumLineSpacing = 0.5
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0)
            collectionView.setCollectionViewLayout(layout, animated: true)
            
            
        }
    }
    @IBOutlet weak var topConstraintBtnFb: NSLayoutConstraint!
    @IBOutlet weak var topConstraintBtnGoogle2: NSLayoutConstraint!
    @IBOutlet weak var topConstraintBtnGoogle: NSLayoutConstraint!
    @IBOutlet weak var topConstraintBtnApple: NSLayoutConstraint!
    @IBOutlet weak var scrollBar: UIScrollView! {
        didSet {
            scrollBar.isScrollEnabled = true
        }
    }
    @IBOutlet weak var topConstraintBtnLinkedIn: NSLayoutConstraint!
    @IBOutlet weak var lblregisterWithUs: UILabel!
    @IBOutlet weak var txtName: UITextField! {
        didSet {
            txtName.delegate = self
        }
    }
    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var txtEmail: UITextField! {
        didSet {
            txtEmail.delegate = self
        }
    }
    @IBOutlet weak var imgMsg: UIImageView!
    @IBOutlet weak var imgPhone: UIImageView!
    @IBOutlet weak var txtPhone: UITextField! {
        didSet {
            txtPhone.delegate = self
        }
    }
    @IBOutlet weak var imgPassword: UIImageView!
    @IBOutlet weak var txtPassword: UITextField! {
        didSet {
            txtPassword.delegate = self
        }
    }
    @IBOutlet weak var buttonAgreeWithTermsConditions: UIButton! {
        didSet {
            buttonAgreeWithTermsConditions.contentHorizontalAlignment = .left
        }
    }
    @IBOutlet weak var btnCheckBoxSubscriber: UIButton!
    @IBOutlet weak var btnTextSubscriber: UIButton! {
        didSet{
            btnTextSubscriber.contentHorizontalAlignment = .left
            
        }
    }
    @IBOutlet weak var buttonCheckBox: UIButton!
    @IBOutlet weak var buttonRegister: UIButton! {
        didSet {
            buttonRegister.roundCorners()
            buttonRegister.layer.borderWidth = 1
        }
    }
    @IBOutlet weak var lblOr: UILabel!
    
    @IBOutlet weak var btnApple: UIButton!
    @IBOutlet weak var btnLinkedin: UIButton!{
        didSet{
            btnLinkedin.roundCornors()
            btnLinkedin.layer.borderWidth = 1
        }
    }
    //    @IBOutlet weak var buttonFB: FBLoginButton!
    @IBOutlet weak var btnFb: UIButton!
    @IBOutlet weak var heightConstraintSocial: NSLayoutConstraint!
    
    
    @IBOutlet weak var topGoogle: NSLayoutConstraint!
    @IBOutlet weak var topGoogleNew: NSLayoutConstraint!
    
    
    //    @IBOutlet weak var buttonFB: UIButton! {
    //        didSet {
    //            buttonFB.roundCorners()
    //            buttonFB.isHidden = true
    //        }
    //    }
    //
    
    
    //    @IBOutlet weak var btnGoogle: GIDSignInButton!
    @IBOutlet weak var buttonGoogle: GIDSignInButton!
    {
        didSet {
            buttonGoogle.roundCorners()
            buttonGoogle.isHidden = true
        }
    }
    
    // @IBOutlet weak var btnGoogleLog: GIDSignInButton!
    
    @IBOutlet weak var buttonAlreadyhaveAccount: UIButton! {
        didSet {
            buttonAlreadyhaveAccount.layer.borderWidth = 0.4
            buttonAlreadyhaveAccount.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    @IBOutlet weak var containerViewSocialButton: UIView!
    
    //MARK:- Properties
    var isAgreeSubscriber = false
    var isAgreeTerms = false
    var page_id = ""
    var defaults = UserDefaults.standard
    var isVerifivation = false
    var isVerifyOn = false
    let loginManager = LoginManager()
    var linkedInId = ""
    var linkedInFirstName = ""
    var linkedInLastName = ""
    var linkedInEmail = ""
    var linkedInProfilePicURL = ""
    var linkedInAccessToken = ""
    var subscriberPostValue = ""
    var SubscribertExt = ""
    var facebookString = "facebook"
    var googleString = "google"
    var appleString = "apple"
    var linkedinString = "linkedin"
    var arraySocialLogin = [String]()
    var homeStyle: String = UserDefaults.standard.string(forKey: "homeStyles")!
    var checkBoxselectedBtn = false
    //MARK:- Application Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        GIDSignIn.sharedInstance()?.presentingViewController = self
        //        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        self.adForest_registerData()
        txtFieldsWithRtl()
        btnApple.isHidden = true
        //        btnLinkedin.isHidden = true
        btnApple.layer.cornerRadius = 10
        btnApple.layer.borderWidth = 1
        btnApple.layer.borderColor = UIColor.black.cgColor
        setUpSignInAppleButton()
        btnCheckBoxSubscriber.isHidden = true
        btnTextSubscriber.isHidden = true
        if #available(iOS 13.0, *) {
            //            self.checkStatusOfAppleSignIn()
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    func setUpSignInAppleButton() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            //authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            authorizationButton.cornerRadius = 10
            //Add button on some view or stack
            // authorizationButton.frame.size = btnApple.frame.size
            //self.btnApple.addSubview(authorizationButton)
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    
    @available(iOS 13.0, *)
    @objc func handleAppleIdRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
    
    //MARK:- Text Field Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtName {
            txtEmail.becomeFirstResponder()
        }
        else if textField == txtEmail {
            txtPhone.becomeFirstResponder()
        }
        else if textField == txtPhone {
            txtPassword.becomeFirstResponder()
        }
        else if textField == txtPassword {
            txtPassword.resignFirstResponder()
        }
        return true
    }
    
    //MARK: - Custom
    
    func txtFieldsWithRtl(){
        if UserDefaults.standard.bool(forKey: "isRtl") {
            txtEmail.textAlignment = .right
            txtPassword.textAlignment = .right
            txtName.textAlignment = .right
            txtPhone.textAlignment = .right
            
        } else {
            txtEmail.textAlignment = .left
            txtPassword.textAlignment = .left
            txtName.textAlignment = .left
            txtPhone.textAlignment = .left
        }
    }
    
    func showLoader(){
        self.startAnimating(Constants.activitySize.size, message: Constants.loaderMessages.loadingMessage.rawValue,messageFont: UIFont.systemFont(ofSize: 14), type: NVActivityIndicatorType.ballClipRotatePulse)
    }
    
    func adForest_populateData() {
        if UserHandler.sharedInstance.objregisterDetails != nil {
            let objData = UserHandler.sharedInstance.objregisterDetails
            
            if let isVerification = objData?.isVerifyOn {
                self.isVerifyOn = isVerification
            }
            
            if let bgColor = defaults.string(forKey: "mainColor") {
                self.buttonRegister.layer.borderColor = Constants.hexStringToUIColor(hex: bgColor).cgColor
                self.buttonRegister.setTitleColor(Constants.hexStringToUIColor(hex: bgColor), for: .normal)
            }
            
            if let registerText = objData?.heading {
                self.lblregisterWithUs.text = registerText
            }
            if let nameText = objData?.namePlaceholder {
                self.txtName.placeholder = nameText
            }
            if let emailText = objData?.emailPlaceholder {
                self.txtEmail.placeholder = emailText
            }
            if let phoneText = objData?.phonePlaceholder {
                self.txtPhone.placeholder = phoneText
            }
            if let passwordtext = objData?.passwordPlaceholder {
                self.txtPassword.placeholder = passwordtext
            }
            if let appleText = objData?.appleBtn{
                self.btnApple.setTitle(appleText,for: .normal)
            }
            
            if let termsText = objData?.termsText {
                self.buttonAgreeWithTermsConditions.setTitle(termsText, for: .normal)
            }
            if let registerText = objData?.formBtn {
                self.buttonRegister.setTitle(registerText, for: .normal)
            }
            if let subscriberBool = objData?.btnSubscriber {
                self.isAgreeSubscriber = subscriberBool
            }
            if let subscriberText = objData?.subscriberCheckBoxText{
                self.btnTextSubscriber.setTitle(subscriberText, for: .normal)
                self.SubscribertExt = subscriberText
            }
            if let postSubscriberVal = objData?.subscriber_CheckboxPOST{
                self.subscriberPostValue = postSubscriberVal
            }
            
            if let loginText = objData?.loginText {
                self.buttonAlreadyhaveAccount.setTitle(loginText, for: .normal)
            }
            if let isUserVerification = objData?.isVerifyOn {
                self.isVerifivation = isUserVerification
            }
            
            // Show hide guest button
            guard let settings = defaults.object(forKey: "settings") else {
                return
            }
            let  settingObject = NSKeyedUnarchiver.unarchiveObject(with: settings as! Data) as! [String : Any]
            let objSettings = SettingsRoot(fromDictionary: settingObject)
            
            // Show/hide google and facebook button
            var isShowGoogle = true
            var isShowFacebook = false
            var isShowApple = true
            var isShowLinkedin = true
            if let isGoogle = objSettings.data.registerBtnShow.google {
                isShowGoogle = isGoogle
                if isShowGoogle == true {
                    arraySocialLogin.append(googleString)
                }
            }
            
            if let isFacebook = objSettings.data.registerBtnShow.facebook{
                isShowFacebook = isFacebook
                if isShowFacebook == true {
                    arraySocialLogin.append(facebookString)
                }
            }
            if let isApple = objSettings.data.registerBtnShow.apple{
                isShowApple = isApple
            }
            if let isLinkedin = objSettings.data.registerBtnShow.linkedin{
                isShowLinkedin = isLinkedin
                if isShowLinkedin == true {
                    arraySocialLogin.append(linkedinString)
                }
            }
            
            if isShowFacebook || isShowGoogle || isShowApple {
                if let sepratorText = objData?.separator {
                    self.lblOr.text = sepratorText
                }
            }
            
            if isShowFacebook && isShowGoogle && isShowApple && isShowLinkedin {
                //                self.btnFb.isHidden = false
                //                self.buttonGoogle.isHidden = false
                self.btnApple.isHidden = false
                //                self.btnLinkedin.isHidden = false
            }
            
            else if isShowFacebook && isShowGoogle == false && isShowApple == false && isShowLinkedin {
                //                self.btnFb.isHidden = false
                //                self.buttonGoogle.isHidden = true
                self.btnApple.isHidden = true
                //                self.btnLinkedin.isHidden = false
                //                btnLinkedin.topAnchor.constraint(equalTo: self.btnFb.bottomAnchor, constant: 8).isActive = true
                
                
            }
            else if isShowFacebook && isShowGoogle == false && isShowApple && isShowLinkedin == false {
                //                self.btnFb.isHidden = false
                //                self.buttonGoogle.isHidden = true
                //                self.btnLinkedin.isHidden = true
                self.btnApple.isHidden = false
                //                btnFb.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
//                btnApple.topAnchor.constraint(equalTo: self.btnFb.bottomAnchor, constant: 8).isActive = true
                
                //                self.topConstraintBtnApple.constant -= 80
            }
            else if isShowFacebook && isShowGoogle  && isShowApple == false && isShowLinkedin == false{
                //                self.btnFb.isHidden = false
                //                self.buttonGoogle.isHidden = false
                self.btnApple.isHidden = true
                //                self.btnLinkedin.isHidden = true
                
                //                btnFb.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                //                buttonGoogle.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                
                
            }
            else if isShowFacebook == false && isShowGoogle == false && isShowApple && isShowLinkedin {
                //                self.btnFb.isHidden = true
                //                self.buttonGoogle.isHidden = true
                self.btnApple.isHidden = false
                //                self.btnLinkedin.isHidden = false
                
                //                btnLinkedin.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
//                btnApple.topAnchor.constraint(equalTo: self.btnLinkedin.bottomAnchor, constant: 8).isActive = true
                
                
            }
            else if isShowFacebook && isShowGoogle  && isShowApple == false && isShowLinkedin {
                //                self.btnFb.isHidden = false
                //                self.buttonGoogle.isHidden = false
                self.btnApple.isHidden = true
                //                self.btnLinkedin.isHidden = false
                //                btnLinkedin.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                //                btnFb.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                //                buttonGoogle.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
                
                
            }
            else if isShowFacebook == false && isShowGoogle  && isShowApple == false && isShowLinkedin {
                //                self.btnFb.isHidden = true
                //                self.buttonGoogle.isHidden = false
                self.btnApple.isHidden = true
                //                self.btnLinkedin.isHidden = false
                
                
            }
            else if isShowFacebook && isShowGoogle == false && isShowApple == false && isShowLinkedin == false {
                //                self.buttonGoogle.isHidden = true
                //                self.btnFb.isHidden = false
                self.btnApple.isHidden = true
                //                self.btnLinkedin.isHidden = true
                //                self.topConstraintBtnFb.constant -= 80
                
            }
            else if isShowFacebook == false && isShowGoogle && isShowApple && isShowLinkedin ==  false {
                //                self.btnFb.isHidden = true
                //                self.buttonGoogle.isHidden = false //New
                self.btnApple.isHidden = false
                //                self.btnLinkedin.isHidden = true
                //                buttonGoogle.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
//                btnApple.topAnchor.constraint(equalTo: self.buttonGoogle.bottomAnchor, constant: 8).isActive = true
                
            }
            
            else if isShowFacebook == false && isShowGoogle == false && isShowApple  {
                //                self.btnFb.isHidden = true
                //                self.buttonGoogle.isHidden = true
                self.btnApple.isHidden = false
                btnApple.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 18).isActive = true
                
            }
            
            else if isShowGoogle && isShowFacebook == false && isShowApple == false {
                //                self.buttonGoogle.isHidden = false
                //                self.btnFb.isHidden = true
                self.btnApple.isHidden = true
                //                 topGoogleNew.constant -= 80
                //                self.buttonGoogle.translatesAutoresizingMaskIntoConstraints = false
                //                self.heightConstraintSocial.constant -= 55
            }
            
            else if isShowFacebook == false && isShowGoogle == false && isShowApple == false && isShowLinkedin {
                self.lblOr.isHidden = true
                //                self.buttonGoogle.isHidden = true
                //                self.btnFb.isHidden = true
                self.btnApple.isHidden = true
                //                self.btnLinkedin.isHidden = false
                //                btnLinkedin.topAnchor.constraint(equalTo: self.buttonRegister.bottomAnchor, constant: 18).isActive = true
                
            }
            else if isShowFacebook == false && isShowGoogle == false && isShowApple == false && isShowLinkedin == false {
                //                self.buttonGoogle.isHidden = true
                //                self.btnFb.isHidden = true
                self.btnApple.isHidden = true
                //                self.btnLinkedin.isHidden = true
                
                
            }
            else if isShowFacebook  && isShowGoogle  && isShowApple  && isShowLinkedin == false {
                self.lblOr.isHidden = false
                //                self.buttonGoogle.isHidden = false
                //                self.btnFb.isHidden = false
                self.btnApple.isHidden = false
                //                self.btnLinkedin.isHidden = true
                
            }
            //
            //            else if isShowFacebook == false && isShowGoogle == false && isShowApple  && isShowLinkedin {
            //                self.buttonGoogleLogin.isHidden = true
            //                self.btnGoogleLog.isHidden = true // New
            //                self.buttonFBLogin.isHidden = true
            //                self.btnFb.isHidden = true
            //                self.btnApple.isHidden = false
            //                self.topConstraintBtnApple.constant -= 120
            //                self.buttonLinkedIn.isHidden = false
            //                self.topConstraintBtnLinkedIn.constant -= 90
            //            }
            //            else if isShowFacebook == false && isShowGoogle  && isShowApple  && isShowLinkedin {
            //                self.buttonGoogleLogin.isHidden = false
            //                self.btnGoogleLog.isHidden = false // New
            //                //                self.topConstraintBtnGoogle.constant -= 140
            //                //                self.topConstraintBtnGoogle2.constant -= 140
            //                self.buttonFBLogin.isHidden = true
            //                self.btnFb.isHidden = true
            //                self.btnApple.isHidden = false
            //                //                self.topConstraintBtnApple.constant -= 90
            //                self.buttonLinkedIn.isHidden = false
            //                //                self.topConstraintBtnLinkedIn.constant -= 60
            //                btnGoogleLog.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
            //                buttonGoogleLogin.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
            //                btnApple.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
            //                buttonLinkedIn.topAnchor.constraint(equalTo: self.lblOr.bottomAnchor, constant: 8).isActive = true
            //
            //            }
            //
            //            else if isShowFacebook  && isShowGoogle  && isShowApple  && isShowLinkedin {
            //                self.buttonGoogleLogin.isHidden = false
            //                self.btnGoogleLog.isHidden = false // New
            //                self.buttonFBLogin.isHidden = false
            //                self.btnFb.isHidden = false
            //                self.btnApple.isHidden = false
            //                self.buttonLinkedIn.isHidden = false
            //
            //            }
            //\
            //            if SubscribertExt != "" {
            if isAgreeSubscriber == true {
                btnCheckBoxSubscriber.isHidden = false
                btnTextSubscriber.isHidden = false
            }  else{
                btnCheckBoxSubscriber.isHidden = true
                btnTextSubscriber.isHidden = true
            }
            
            //            if SubscribertExt  == "" {
            //                 btnCheckBoxSubscriber.isHidden = true
            //                btnTextSubscriber.isHidden = true
            //            }else{
            //                btnCheckBoxSubscriber.isHidden = false
            //                btnTextSubscriber.isHidden = false
            //            }
            
            
            
        }
        collectionView
            .reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arraySocialLogin.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "SocialLoginCollectionViewCell", for: indexPath) as! SocialLoginCollectionViewCell
        let arra = arraySocialLogin[indexPath.row]
        print(arra)
        if arra == "facebook"{
            let image = UIImage(named: "regfbicon") as UIImage?
            cell.btnSocial.setImage(image, for: .normal)
            cell.btnSocial.setTitle(arra, for: .normal)
            cell.btnSocial.titleLabel?.textColor = UIColor.clear
        }
        if arra == "google"{
            let image = UIImage(named: "googleSocial") as UIImage?
            cell.btnSocial.setImage(image, for: .normal)
            cell.btnSocial.setTitle(arra, for: .normal)
            cell.btnSocial.titleLabel?.textColor = UIColor.clear
        }
        if arra == "linkedin"{
            let image = UIImage(named: "linkedin") as UIImage?
            cell.btnSocial.setImage(image, for: .normal)
            cell.btnSocial.setTitle(arra, for: .normal)
            cell.btnSocial.titleLabel?.textColor = UIColor.clear
        }
        cell.btnSocial.addTarget(self, action: #selector(socilBtnTapped), for: .touchUpInside)
        return cell
    }
    @objc func socilBtnTapped(_ sender: UIButton){
        print(sender.title(for: .normal))
        if sender.title(for: .normal) == "facebook"{
            self.btnLoginFbOk()
            
        }
        else if sender.title(for: .normal) == "google"{
            self.actionGoogle()
        }
        else if sender.title(for: .normal) == "linkedin"{
            self.actionLinkedinSubmit()
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        print(width)
        return CGSize(width: width/3, height: 120)
        
    }
    
    //    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    //        return UIEdgeInsets.zero
    //
    //    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: -IBActions
    //_ sender: Any
    @IBAction func actionLinkedinSubmit() {
        linkedInAuthVC()
    }
    
    
    
    var webView = WKWebView()
    func linkedInAuthVC() {
        // Create linkedIn Auth ViewController
        let linkedInVC = UIViewController()
        // Create WebView
        let webView = WKWebView()
        webView.navigationDelegate = self
        linkedInVC.view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: linkedInVC.view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: linkedInVC.view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: linkedInVC.view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: linkedInVC.view.trailingAnchor)
        ])
        
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        let authURLFull = Constants.LinkedInConstants.AUTHURL + "?response_type=code&client_id=" + Constants.LinkedInConstants.CLIENT_ID + "&scope=" + Constants.LinkedInConstants.SCOPE + "&state=" + state + "&redirect_uri=" + Constants.LinkedInConstants.REDIRECT_URI
        
        
        let urlRequest = URLRequest.init(url: URL.init(string: authURLFull)!)
        webView.load(urlRequest)
        
        // Create Navigation Controller
        let navController = UINavigationController(rootViewController: linkedInVC)
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelAction))
        linkedInVC.navigationItem.leftBarButtonItem = cancelButton
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.refreshAction))
        linkedInVC.navigationItem.rightBarButtonItem = refreshButton
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navController.navigationBar.titleTextAttributes = textAttributes
        linkedInVC.navigationItem.title = "linkedin.com"
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.tintColor = UIColor.white
        //        navController.navigationBar.barTintColor = UIColor.colorFromHex("#0072B1")
        navController.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        navController.modalTransitionStyle = .coverVertical
        
        self.present(navController, animated: true, completion: nil)
    }
    @objc func cancelAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func refreshAction() {
        self.webView.reload()
    }
    
    
    
    
    
    @IBAction func btnAppleClicked(_ sender: UIButton) {
        
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
        } else {
            // Fallback on earlier versions
        }
        
        
    }
    @IBAction func checkBoxSubscriber(_ sender: UIButton) {
        
        if sender.imageView?.image == #imageLiteral(resourceName: "uncheck") {
            btnCheckBoxSubscriber.setImage(#imageLiteral(resourceName: "check"), for: .normal)
            checkBoxselectedBtn = true
        }
        else{
            btnCheckBoxSubscriber.setImage( #imageLiteral(resourceName: "uncheck"), for: .normal)
            checkBoxselectedBtn = false
            
        }
        
    }
    
    @IBAction func checkBox(_ sender: UIButton) {
        
        if isAgreeTerms == false {
            buttonCheckBox.setBackgroundImage(#imageLiteral(resourceName: "check"), for: .normal)
            isAgreeTerms = true
            
        }
        else if isAgreeTerms {
            buttonCheckBox.setBackgroundImage(#imageLiteral(resourceName: "uncheck"), for: .normal)
            isAgreeTerms = false
        }
    }
    
    @IBAction func actionTermsCondition(_ sender: UIButton) {
        if self.page_id == "" {
        }
        else {
            let termsVC = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionsController") as! TermsConditionsController
            termsVC.modalTransitionStyle = .flipHorizontal
            termsVC.modalPresentationStyle = .overCurrentContext
            termsVC.page_id = self.page_id
            self.presentVC(termsVC)
        }
    }
    
    @IBAction func actionRegister(_ sender: UIButton) {
        
        guard let name = txtName.text else {
            return
        }
        guard let email = txtEmail.text else {
            return
        }
        guard let phone = txtPhone.text else {
            return
        }
        
        guard let password = txtPassword.text else {
            return
        }
        
        if name == "" {
            self.txtName.shake(6, withDelta: 10, speed: 0.06)
        }
        else if email == "" {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !email.isValidEmail {
            self.txtEmail.shake(6, withDelta: 10, speed: 0.06)
        }
        
        else if phone == "" {
            self.txtPhone.shake(6, withDelta: 10, speed: 0.06)
        }
        else if !phone.isValidPhone {
            self.txtPhone.shake(6, withDelta: 10, speed: 0.06)
        }
        else if password == "" {
            self.txtPassword.shake(6, withDelta: 10, speed: 0.06)
        }
        
        else if isAgreeTerms == false {
            let alert = Constants.showBasicAlert(message: "Please Agree with terms and conditions")
            self.presentVC(alert)
        }
        else {
            if checkBoxselectedBtn == true {
                let parameters : [String: Any] = [
                    "name": name,
                    "email": email,
                    "phone": phone,
                    "password": password,
                    subscriberPostValue: subscriberPostValue
                ]
                print(parameters)
                defaults.set(email, forKey: "email")
                defaults.set(password, forKey: "password")
                self.adForest_registerUser(param: parameters as NSDictionary)
            }
            else{
                let parameters : [String: Any] = [
                    "name": name,
                    "email": email,
                    "phone": phone,
                    "password": password
                ]
                print(parameters)
                defaults.set(email, forKey: "email")
                defaults.set(password, forKey: "password")
                self.adForest_registerUser(param: parameters as NSDictionary)
            }
            
            
        }
    }
    
    
    
    //    @IBAction func actionFacebook(_ sender: FBSDKLoginButton) {
    //
    //
    //        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
    //            if error != nil {
    //                print(error?.localizedDescription ?? "Nothing")
    //            }
    //            else if (result?.isCancelled)! {
    //                print("Cancel")
    //            }
    //            else if error == nil {
    //                self.userProfileDetails()
    //            } else {
    //            }
    //        }
    //
    //    }
    
    //    @IBAction func actionFacebook(_ sender: Any) {
    //        let loginManager = FBSDKLoginManager()
    //
    //        loginManager.logIn(withReadPermissions: ["email", "public_profile"], from: self) { (result, error) in
    //            if error != nil {
    //                print(error?.localizedDescription ?? "Nothing")
    //            }
    //            else if (result?.isCancelled)! {
    //                print("Cancel")
    //            }
    //            else if error == nil {
    //                self.userProfileDetails()
    //            } else {
    //            }
    //        }
    //    }
    //_ sender: Any
    @IBAction func actionGoogle() {
        if GoogleAuthenctication.isLooggedIn {
            GoogleAuthenctication.signOut()
        }
        else {
            GoogleAuthenctication.signIn()
        }
    }
    
    @IBAction func actionLoginHere(_ sender: Any) {
        // self.navigationController?.popViewController(animated: true)
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    
    
    //MARK:- Facebook Delegate Methods
    
    
    @IBAction func btnLoginFbOk() {
        loginManager.logIn(permissions: ["email", "public_profile"], from: self) { (result, error) in
            if error != nil {
                print(error?.localizedDescription ?? "Nothing")
            }
            else if (result?.isCancelled)! {
                print("Cancel")
            }
            else if error == nil {
                self.userProfileDetails()
            } else {
            }
        }
        
    }
    
    
    func userProfileDetails() {
        if (AccessToken.current != nil) {
            GraphRequest(graphPath: "/me", parameters: ["fields": "id, name, first_name, last_name, email, gender, picture.type(large)"]).start { (connection, result, error) in
                if error != nil {
                    print(error?.localizedDescription ?? "Nothing")
                    return
                }
                else {
                    guard let results = result as? NSDictionary else { return }
                    guard  let email = results["email"] as? String else {
                        return
                    }
                    let param: [String: Any] = [
                        "email": email,
                        "type": "social"
                    ]
                    print(param)
                    self.defaults.set(true, forKey: "isSocial")
                    self.defaults.set(email, forKey: "email")
                    self.defaults.set("1122", forKey: "password")
                    self.defaults.synchronize()
                    self.adForest_loginUser(parameters: param as NSDictionary)
                }
            }
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton!) {
        
    }
    
    func loginButtonWillLogin(_ loginButton: FBLoginButton!) -> Bool {
        return true
    }
    
    //MARK:- Google Delegate Methods
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print(error.localizedDescription)
        }
        if error == nil {
            guard let email = user.profile.email else { return }
            let param: [String: Any] = [
                "email": email,
                "type": "social"
            ]
            print(param)
            self.defaults.set(true, forKey: "isSocial")
            self.defaults.set(email, forKey: "email")
            self.defaults.set("1122", forKey: "password")
            self.defaults.synchronize()
            self.adForest_loginUser(parameters: param as NSDictionary)
        }
    }
    // Google Sign In Delegate
    func sign(_ signIn: GIDSignIn!, present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- API Calls
    //Get Details Data
    func adForest_registerData() {
        self.showLoader()
        UserHandler.registerDetails(success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                UserHandler.sharedInstance.objregisterDetails = successResponse.data
                if let pageID = successResponse.data.termPageId {
                    self.page_id = pageID
                }
                self.adForest_populateData()
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
    
    //MARK:- User Register
    func adForest_registerUser(param: NSDictionary) {
        self.showLoader()
        UserHandler.registerUser(parameter: param, success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success {
                if self.isVerifivation {
                    let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                        let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                        confirmationVC.isFromVerification = true
                        confirmationVC.user_id = successResponse.data.id
                        self.navigationController?.pushViewController(confirmationVC, animated: true)
                    })
                    self.presentVC(alert)
                }
                else {
                    self.defaults.set(true, forKey: "isLogin")
                    self.defaults.synchronize()
                    self.appDelegate.moveToHome()
                }
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
    
    // Login User With Social
    func adForest_loginUser(parameters: NSDictionary) {
        self.showLoader()
        UserHandler.loginUser(parameter: parameters , success: { (successResponse) in
            self.stopAnimating()
            if successResponse.success{
                if self.isVerifyOn && successResponse.data.isAccountConfirm == false {
                    let alert = AlertView.prepare(title: "", message: successResponse.message, okAction: {
                        let confirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
                        confirmationVC.isFromVerification = true
                        confirmationVC.user_id = successResponse.data.id
                        self.navigationController?.pushViewController(confirmationVC, animated: true)
                    })
                    self.presentVC(alert)
                }
                else {
                    self.defaults.set(true, forKey: "isLogin")
                    self.defaults.synchronize()
                    if self.homeStyle == "home1"{
                        self.appDelegate.moveToHome()
                        
                    }else if self.homeStyle == "home2"{
                        self.appDelegate.moveToMultiHome()
                    }
                    else if self.homeStyle == "home3"{
                        self.appDelegate.moveToMarvelHome()
                    }
                    
                }
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
    
}

@available(iOS 13.0, *)
extension RegisterViewController: ASAuthorizationControllerPresentationContextProviding,ASAuthorizationControllerDelegate {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
        func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization)
    {
        switch authorization.credential {
        
        case let credentials as ASAuthorizationAppleIDCredential:
            DispatchQueue.main.async {
                
                if "\(credentials.user)" != "" {
                    
                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
                }
                if credentials.email != nil {
                    
                    UserDefaults.standard.set("\(credentials.email!)", forKey: "User_Email")
                }
                if credentials.fullName!.givenName != nil {
                    
                    UserDefaults.standard.set("\(credentials.fullName!.givenName!)", forKey: "User_FirstName")
                }
                if credentials.fullName!.familyName != nil {
                    
                    UserDefaults.standard.set("\(credentials.fullName!.familyName!)", forKey: "User_LastName")
                }
                UserDefaults.standard.synchronize()
                self.setupUserInfoAndOpenView()
                
                
            }
            
        case let credentials as ASPasswordCredential:
            DispatchQueue.main.async {
                
                if "\(credentials.user)" != "" {
                    
                    UserDefaults.standard.set("\(credentials.user)", forKey: "User_AppleID")
                }
                if "\(credentials.password)" != "" {
                    
                    UserDefaults.standard.set("\(credentials.password)", forKey: "User_Password")
                }
                UserDefaults.standard.synchronize()
                self.setupUserInfoAndOpenView()
            }
            
        default :
            let alert: UIAlertController = UIAlertController(title: "Apple Sign In", message: "Something went wrong with your Apple Sign In!", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            break
        }
    }
    func checkStatusOfAppleSignIn()
    {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: "\(UserDefaults.standard.value(forKey: "User_AppleID")!)") { (credentialState, error) in
            
            switch credentialState {
            case .authorized:
                self.setupUserInfoAndOpenView()
                break
            default:
                break
            }
        }
    }
    func setupUserInfoAndOpenView()
    {
        DispatchQueue.main.async {
            
            
            if "\(UserDefaults.standard.value(forKey: "User_FirstName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_LastName")!)" != "" || "\(UserDefaults.standard.value(forKey: "User_Email")!)" != "" {
                let emApple = UserDefaults.standard.value(forKey: "User_Email")!
                if emApple != nil{
                    let param: [String: Any] = [
                        "email": emApple,
                        "type": "social"
                    ]
                    print(param)
                    self.defaults.set(true, forKey: "isSocial")
                    UserDefaults.standard.set(emApple, forKey:"email")
                    self.defaults.set("1122", forKey: "password")
                    self.defaults.synchronize()
                    UserDefaults.standard.set("true", forKey: "apple")
                    self.adForest_loginUser(parameters: param as NSDictionary)
                    
                }
                
                
                
                
                
            } else {
                let emApple = UserDefaults.standard.value(forKey: "User_AppleID")!
                if emApple != nil{
                    let param: [String: Any] = [
                        "email": emApple,
                        "type": "social"
                    ]
                    print(param)
                    self.defaults.set(true, forKey: "isSocial")
                    UserDefaults.standard.set(emApple, forKey:"email")
                    self.defaults.set("1122", forKey: "password")
                    self.defaults.synchronize()
                    UserDefaults.standard.set("true", forKey: "apple")
                    self.adForest_loginUser(parameters: param as NSDictionary)
                    
                }
                
            }
            
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error)
    {
        let alert: UIAlertController = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
extension RegisterViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        RequestForCallbackURL(request: navigationAction.request)
        
        //Close the View Controller after getting the authorization code
        if let urlStr = navigationAction.request.url?.absoluteString {
            if urlStr.contains("?code=") {
                self.dismiss(animated: true, completion: nil)
            }
        }
        decisionHandler(.allow)
    }
    
    func RequestForCallbackURL(request: URLRequest) {
        // Get the authorization code string after the '?code=' and before '&state='
        let requestURLString = (request.url?.absoluteString)! as String
        if requestURLString.hasPrefix(Constants.LinkedInConstants.REDIRECT_URI) {
            if requestURLString.contains("?code=") {
                if let range = requestURLString.range(of: "=") {
                    let linkedinCode = requestURLString[range.upperBound...]
                    if let range = linkedinCode.range(of: "&state=") {
                        let linkedinCodeFinal = linkedinCode[..<range.lowerBound]
                        handleAuth(linkedInAuthorizationCode: String(linkedinCodeFinal))
                    }
                }
            }
        }
    }
    
    func handleAuth(linkedInAuthorizationCode: String) {
        linkedinRequestForAccessToken(authCode: linkedInAuthorizationCode)
    }
    
    func linkedinRequestForAccessToken(authCode: String) {
        let grantType = "authorization_code"
        
        // Set the POST parameters.
        let postParams = "grant_type=" + grantType + "&code=" + authCode + "&redirect_uri=" + Constants.LinkedInConstants.REDIRECT_URI + "&client_id=" + Constants.LinkedInConstants.CLIENT_ID + "&client_secret=" + Constants.LinkedInConstants.CLIENT_SECRET
        let postData = postParams.data(using: String.Encoding.utf8)
        let request = NSMutableURLRequest(url: URL(string: Constants.LinkedInConstants.TOKENURL)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                let results = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [AnyHashable: Any]
                
                let accessToken = results?["access_token"] as! String
                print("accessToken is: \(accessToken)")
                
                let expiresIn = results?["expires_in"] as! Int
                print("expires in: \(expiresIn)")
                
                // Get user's id, first name, last name, profile pic url
                self.fetchLinkedInUserProfile(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    
    func fetchLinkedInUserProfile(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/me?projection=(id,firstName,lastName,profilePicture(displayImage~:playableStreams))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInProfileModel = try? JSONDecoder().decode(LinkedInProfileModel.self, from: data!)
                
                //AccessToken
                print("LinkedIn Access Token: \(accessToken)")
                self.linkedInAccessToken = accessToken
                
                // LinkedIn Id
                let linkedinId: String! = linkedInProfileModel?.id
                print("LinkedIn Id: \(linkedinId ?? "")")
                self.linkedInId = linkedinId
                
                // LinkedIn First Name
                let linkedinFirstName: String! = linkedInProfileModel?.firstName.localized.enUS
                print("LinkedIn First Name: \(linkedinFirstName ?? "")")
                self.linkedInFirstName = linkedinFirstName
                
                // LinkedIn Last Name
                let linkedinLastName: String! = linkedInProfileModel?.lastName.localized.enUS
                print("LinkedIn Last Name: \(linkedinLastName ?? "")")
                self.linkedInLastName = linkedinLastName
                
                // LinkedIn Profile Picture URL
                let linkedinProfilePic: String!
                
                /*
                 Change row of the 'elements' array to get diffrent size of the profile url
                 elements[0] = 100x100
                 elements[1] = 200x200
                 elements[2] = 400x400
                 elements[3] = 800x800
                 */
                if let pictureUrls = linkedInProfileModel?.profilePicture.displayImage.elements[2].identifiers[0].identifier {
                    linkedinProfilePic = pictureUrls
                } else {
                    linkedinProfilePic = "Not exists"
                }
                print("LinkedIn Profile Avatar URL: \(linkedinProfilePic ?? "")")
                self.linkedInProfilePicURL = linkedinProfilePic
                
                // Get user's email address
                self.fetchLinkedInEmailAddress(accessToken: accessToken)
            }
        }
        task.resume()
    }
    
    func fetchLinkedInEmailAddress(accessToken: String) {
        let tokenURLFull = "https://api.linkedin.com/v2/emailAddress?q=members&projection=(elements*(handle~))&oauth2_access_token=\(accessToken)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let verify: NSURL = NSURL(string: tokenURLFull!)!
        let request: NSMutableURLRequest = NSMutableURLRequest(url: verify as URL)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            if error == nil {
                let linkedInEmailModel = try? JSONDecoder().decode(LinkedInEmailModel.self, from: data!)
                
                // LinkedIn Email
                let linkedinEmail: String! = linkedInEmailModel?.elements[0].elementHandle.emailAddress
                print("LinkedIn Email: \(linkedinEmail ?? "")")
                self.linkedInEmail = linkedinEmail
                
                DispatchQueue.main.async {
                    let param: [String: Any] = [
                        "email": linkedinEmail!,
                        "type": "social"
                    ]
                    print(param)
                    self.defaults.set(true, forKey: "isSocial")
                    UserDefaults.standard.set(linkedinEmail, forKey:"email")
                    self.defaults.set("1122", forKey: "password")
                    self.defaults.synchronize()
                    UserDefaults.standard.set("true", forKey: "apple")
                    self.adForest_loginUser(parameters: param as NSDictionary)
                    //                    self.performSegue(withIdentifier: "detailseg", sender: self)
                }
            }
        }
        task.resume()
    }
    
    
}
