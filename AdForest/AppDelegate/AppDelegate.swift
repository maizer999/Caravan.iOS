//
//  AppDelegate.swift
//  AdForest
//
//  Created by apple on 3/8/18.
//  Copyright © 2018 apple. All rights reserved.
//

import UIKit
import CoreData
import GoogleSignIn
import Firebase
import FirebaseMessaging
import UserNotifications
import FBSDKCoreKit
import SlideMenuControllerSwift
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlacePicker
import SwiftyStoreKit
import NotificationBannerSwift
import GoogleMobileAds
//import LinkedinSwift
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate, NotificationBannerDelegate {
    
    
    
    
    
    var window: UIWindow?
    
    static let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static let appsDelegate = UIApplication.shared.delegate as! AppDelegate

    let keyboardManager = IQKeyboardManager.sharedManager()
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let defaults = UserDefaults.standard
    var deviceFcmToken = "0"
    var interstitial: GADInterstitial?
    
    
    func createAndLoadInterstitial() -> GADInterstitial? {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3521346996890484/7679081330")
        guard let interstitial = interstitial else {
            return nil
        }
        let request = GADRequest()
        interstitial.load(request)
        return interstitial
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        for family: String in UIFont.familyNames
             {
                 print(family)
                 for names: String in UIFont.fontNames(forFamilyName: family)
                 {
                     print("== \(names)")
                 }
             }
        
        keyboardManager.enable = true
        self.setUpGoogleMaps()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        Messaging.messaging().shouldEstablishDirectChannel = true
        UNUserNotificationCenter.current().delegate = self
        
        if #available(iOS 11, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in
                print("Granted \(granted)")
            }
            UIApplication.shared.registerForRemoteNotifications()
        } else {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in}
            UIApplication.shared.registerForRemoteNotifications()
            application.registerForRemoteNotifications()
        }
        UIApplication.shared.registerForRemoteNotifications()

        // For Facebook and Google SignIn
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
         GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GADMobileAds.sharedInstance().start(completionHandler: nil)



        defaults.removeObject(forKey: "isGuest")
        defaults.synchronize()
        
        //For in App Purchase
//        SwiftyStoreKit.completeTransactions(atomically: true) { (purchases) in
//            for purchase in purchases {
//                switch purchase.transaction.transactionState {
//                case .purchased, .restored:
//                    if purchase.needsFinishTransaction{
//                        SwiftyStoreKit.finishTransaction(purchase.transaction)
//                    }
//                case .failed, .purchasing, .deferred:
//                    break
//                }
//            }
//        }
        
        UITextField.appearance().tintColor = .black
        UITextView.appearance().tintColor = .black
        
        return true
    }
 
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let willHandleByFacebook = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
       
        let willHandleByGoogle = GIDSignIn.sharedInstance().handle(url)
        
//        let willHandleByGoogle = GIDSignIn.sharedInstance().handle(url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        // Linkedin sdk handle redirect
//        if LinkedinSwiftHelper.shouldHandle(url) {
//            return LinkedinSwiftHelper.application(app, open: url, sourceApplication: nil, annotation: nil)
//        }
        //|| false
        
        return  willHandleByGoogle || willHandleByFacebook
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        UserDefaults.standard.set("3", forKey: "fromNotification")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        UserDefaults.standard.set("3", forKey: "fromNotification")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        Messaging.messaging().shouldEstablishDirectChannel = true
        AppEvents.activateApp()
        //To Check Deep Link
        deepLinker.checkDeepLink()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        self.saveContext()
        UserDefaults.standard.set("3", forKey: "fromNotification")
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AdForest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
extension AppDelegate {
    //MARK:- For Google Places Search
    func setUpGoogleMaps() {
        let googleMapsApiKey = Constants.googlePlacesAPIKey.placesKey
        GMSServices.provideAPIKey(googleMapsApiKey)
        GMSPlacesClient.provideAPIKey(googleMapsApiKey)
    }
}

extension AppDelegate {
    func customizeNavigationBar(barTintColor: UIColor) {
        let appearance = UINavigationBar.appearance()
        appearance.setBackgroundImage(UIImage(), for: .default)
        appearance.shadowImage = UIImage()
        appearance.isTranslucent = false
        appearance.barTintColor = barTintColor
        //appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white, NSAttributedString.Key.font: UIFont.systemFontSize]
        appearance.barStyle = .blackTranslucent
    }
    
    func moveToHome() {
        let HomeVC = storyboard.instantiateViewController(withIdentifier: SOTabBarViewController.className) as! SOTabBarViewController
         if defaults.bool(forKey: "isRtl") {
             let rightViewController = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
             let navi: UINavigationController = UINavigationController(rootViewController: HomeVC)
             let slideMenuController = SlideMenuController(mainViewController: navi, rightMenuViewController: rightViewController)
             navi.modalPresentationStyle = .fullScreen
             self.window?.rootViewController = slideMenuController
         } else {
             let leftVC = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
             let navi : UINavigationController = UINavigationController(rootViewController: HomeVC)
             let slideMenuController = SlideMenuController(mainViewController: navi, leftMenuViewController: leftVC)
             navi.modalPresentationStyle = .fullScreen
             self.window?.rootViewController = slideMenuController
         }
         self.window?.makeKeyAndVisible()
     }
    
 func moveToMarvelHome() {
    let HomeVC = storyboard.instantiateViewController(withIdentifier: SOTabBarViewController.className) as! SOTabBarViewController
     if defaults.bool(forKey: "isRtl") {
         let rightViewController = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
         let navi: UINavigationController = UINavigationController(rootViewController: HomeVC)
         let slideMenuController = SlideMenuController(mainViewController: navi, rightMenuViewController: rightViewController)
         navi.modalPresentationStyle = .fullScreen
         self.window?.rootViewController = slideMenuController
     } else {
         let leftVC = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
         let navi : UINavigationController = UINavigationController(rootViewController: HomeVC)
         let slideMenuController = SlideMenuController(mainViewController: navi, leftMenuViewController: leftVC)
         navi.modalPresentationStyle = .fullScreen
         self.window?.rootViewController = slideMenuController
     }
     self.window?.makeKeyAndVisible()
 }
    func moveToMultiHome() {
       let HomeVC = storyboard.instantiateViewController(withIdentifier: MultiHomeViewController.className) as! MultiHomeViewController
        if defaults.bool(forKey: "isRtl") {
            let rightViewController = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
            let navi: UINavigationController = UINavigationController(rootViewController: HomeVC)
            let slideMenuController = SlideMenuController(mainViewController: navi, rightMenuViewController: rightViewController)
            navi.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = slideMenuController
        } else {
            let leftVC = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
            let navi : UINavigationController = UINavigationController(rootViewController: HomeVC)
            let slideMenuController = SlideMenuController(mainViewController: navi, leftMenuViewController: leftVC)
            navi.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = slideMenuController
        }
        self.window?.makeKeyAndVisible()
    }

    func moveToLanguageCtrl() {
        let HomeVC = storyboard.instantiateViewController(withIdentifier: LangViewController.className) as! LangViewController
        if defaults.bool(forKey: "isRtl") {
            let rightViewController = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
            let navi: UINavigationController = UINavigationController(rootViewController: HomeVC)
             navi.modalPresentationStyle = .fullScreen
            let slideMenuController = SlideMenuController(mainViewController: navi, rightMenuViewController: rightViewController)
            self.window?.rootViewController = slideMenuController
        } else {
            let leftVC = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
            let navi : UINavigationController = UINavigationController(rootViewController: HomeVC)
             navi.modalPresentationStyle = .fullScreen
            let slideMenuController = SlideMenuController(mainViewController: navi, leftMenuViewController: leftVC)
            self.window?.rootViewController = slideMenuController
        }
        self.window?.makeKeyAndVisible()
    }
 
    func moveToLanguage() {
        let langVC = storyboard.instantiateViewController(withIdentifier: LangViewController.className) as! LangViewController
        let nav: UINavigationController = UINavigationController(rootViewController: langVC)
         nav.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
    
    func moveToLogin() {
        let loginVC = storyboard.instantiateViewController(withIdentifier: LoginViewController.className) as! LoginViewController
        let nav: UINavigationController = UINavigationController(rootViewController: loginVC)
         nav.modalPresentationStyle = .fullScreen
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
    }
   
    
    func moveToProfile() {
        let proVc = storyboard.instantiateViewController(withIdentifier: ProfileController.className) as! ProfileController
        if defaults.bool(forKey: "isRtl") {
            let rightViewController = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
            let navi: UINavigationController = UINavigationController(rootViewController: proVc)
            let slideMenuController = SlideMenuController(mainViewController: navi, rightMenuViewController: rightViewController)
             navi.modalPresentationStyle = .fullScreen
            self.window?.rootViewController = slideMenuController
        } else {
            let leftVC = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
            let navi : UINavigationController = UINavigationController(rootViewController: proVc)
             navi.modalPresentationStyle = .fullScreen
            let slideMenuController = SlideMenuController(mainViewController: navi, leftMenuViewController: leftVC)
            self.window?.rootViewController = slideMenuController
        }
        self.window?.makeKeyAndVisible()
    }
    
    func moveToAdvanceSearch() {
        let proVc = storyboard.instantiateViewController(withIdentifier: AdvancedSearchController.className) as! AdvancedSearchController
        if defaults.bool(forKey: "isRtl") {
            let rightViewController = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
            let navi: UINavigationController = UINavigationController(rootViewController: proVc)
             navi.modalPresentationStyle = .fullScreen
            let slideMenuController = SlideMenuController(mainViewController: navi, rightMenuViewController: rightViewController)
            self.window?.rootViewController = slideMenuController
        } else {
            let leftVC = storyboard.instantiateViewController(withIdentifier: LeftController.className) as! LeftController
            let navi : UINavigationController = UINavigationController(rootViewController: proVc)
             navi.modalPresentationStyle = .fullScreen
            let slideMenuController = SlideMenuController(mainViewController: navi, leftMenuViewController: leftVC)
            self.window?.rootViewController = slideMenuController
        }
        self.window?.makeKeyAndVisible()
    }
    
    
    
    func presentController(ShowVC: UIViewController) {
        self.window?.rootViewController?.presentVC(ShowVC)
    }
    
    func dissmissController() {
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func popController() {
        self.window?.rootViewController?.navigationController?.popViewController(animated: true)
    }
    
    func pushController(controller: UIViewController) {
        self.window?.rootViewController?.navigationController?.pushViewController(controller, animated: true)
    }
}

extension AppDelegate  {
    // MARK: UNUserNotificationCenter Delegate
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //  let content = notification.request.content
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        switch response.actionIdentifier {
//        case UNNotificationDefaultActionIdentifier:
//            print(response.notification.request.content.body)
//            print(response.notification.request.content.userInfo)
//
//            print("Open App")
//        case "chat":
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let obj = storyboard.instantiateViewController(withIdentifier: "ChatController") as! ChatController
//
//            window?.rootViewController = obj
//            window?.makeKeyAndVisible()
//            completionHandler()
//        default:
//            break
//        }
        print("Received data message: \(response.notification.request.content)")
                let topic = response.notification.request.content.userInfo[AnyHashable("topic")] as? String
                let userinf = response.notification.request.content.userInfo
                print(topic)
                
                
                if topic == "broadcast"{
                    let Notititle = userinf[AnyHashable("title")] as? String
                    let Notimessage = userinf[AnyHashable("message")] as? String
                    let NotiImage = userinf[AnyHashable("image_full")] as? String
                    UserDefaults.standard.set(Notititle, forKey: "Notititle")
                    UserDefaults.standard.set(Notimessage, forKey: "Notimessage")
                    UserDefaults.standard.set(NotiImage, forKey: "NotiImage")
//                    let HomeVC = storyboard.instantiateViewController(withIdentifier: HomeController.className) as! HomeController
//                    let nav: UINavigationController = UINavigationController(rootViewController: HomeVC)
//                    HomeVC.NTitle = Notititle!
//                    HomeVC.NMessage = Notimessage!
//                    HomeVC.NImage = NotiImage!
//                    self.window?.rootViewController = nav
//                    UserDefaults.standard.set("1", forKey: "fromNotification")
//                    self.window?.makeKeyAndVisible()

                     self.moveToHome()
                }else{
                    let adId = userinf[AnyHashable("adId")] as? String
                    let message = userinf[AnyHashable("message")] as? String
                    let senderId = userinf[AnyHashable("senderId")] as? String
                    let recieverId = userinf[AnyHashable("recieverId")] as? String
                    let type = userinf[AnyHashable("type")] as? String
                    let chatVC = self.storyboard.instantiateViewController(withIdentifier: "ChatController") as! ChatController
                    let nav: UINavigationController = UINavigationController(rootViewController: chatVC)
                    chatVC.ad_id = adId!
                    chatVC.sender_id = senderId!
                    chatVC.receiver_id = recieverId!
                    chatVC.messageType = type!
                    self.window?.rootViewController = nav
                    UserDefaults.standard.set("1", forKey: "fromNotification")
                    self.window?.makeKeyAndVisible()
                }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        #if PROD_BUILD
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #endif
        
        Messaging.messaging().apnsToken = deviceToken
//        var token = ""
//        for i in 0..<deviceToken.count {
//            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
//        }
//        //        print("Notification token = \(token)")
        let tokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("this will return '32 bytes' in iOS 13+ rather than the token \(tokenString)")
        self.deviceFcmToken = tokenString
                let defaults =  UserDefaults.standard
                defaults.setValue(deviceToken, forKey: "fcmToken")
                defaults.synchronize()

//        InstanceID.instanceID().instanceID { (result, error) in
//            if let error = error {
//                print("Error fetching remote instange ID: \(error)")
//            } else if let result = result {
//                print("Remote instance ID token: \(result.token)")
//                self.deviceFcmToken = result.token
//                let defaults =  UserDefaults.standard
//                defaults.setValue(deviceToken, forKey: "fcmToken")
//                defaults.synchronize()
//            }
//        }
        

        
        
//        if let refreshedToken = InstanceID.instanceID().token(withAuthorizedEntity: nil, scope: nil, handler: <#InstanceIDTokenHandler#>) {
//            print("Firebase: InstanceID token: \(refreshedToken)")
//            self.deviceFcmToken = refreshedToken
//            let defaults =  UserDefaults.standard
//            defaults.setValue(deviceToken, forKey: "fcmToken")
//            defaults.synchronize()
//        }else{
//            
//        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("failed to register for remote notifications with with error: \(error)")
    }
    
    
    func application(_ application: UIApplication, didrequestAuthorizationRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        #if PROD_BUILD
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        #else
        Messaging.messaging().setAPNSToken(deviceToken, type: .sandbox)
        #endif
        
        Messaging.messaging().apnsToken = deviceToken
        
        let token = deviceToken.base64EncodedString()
        
        let fcmToken = Messaging.messaging().fcmToken
        print("Firebase: FCM token: \(fcmToken ?? "")")
        
        print("Firebase: found token \(token)")
        
        print("Firebase: found token \(deviceToken)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        switch application.applicationState {
        case .active: break
            
        case .background: break
            
        case .inactive: break
    
        default:
            break
        }
        
        print("Firebase: user info \(userInfo)")
        switch application.applicationState {
        case .active:
            break
        case .background, .inactive:
            break
        }
        let gcmMessageIDKey = "gcm.message_id"
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("mtech Message ID: \(messageID)")
        }
        Messaging.messaging().appDidReceiveMessage(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        let fcmToken = Messaging.messaging().fcmToken
        let defaults = UserDefaults.standard
        defaults.set(fcmToken, forKey: "fcmToken")
        defaults.synchronize()
    }
    
    
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("received remote notification")
//    }
    
  
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
        print("Received data message: \(remoteMessage.appData)")
        
        guard let topic = remoteMessage.appData[AnyHashable("topic")] as? String else {
            return
        }
        
        if topic == "chat"{
            
            guard let adID = remoteMessage.appData[AnyHashable("adId")]as? String else  {
                return
            }
            guard let textFrom = remoteMessage.appData[AnyHashable("from")] as? String else {
                return
            }
            guard let textTitle = remoteMessage.appData[AnyHashable("title")] as? String else  {
                return
            }
            guard let userMessage = remoteMessage.appData[AnyHashable("message")] as? String else {
                return
            }
            guard let senderID = remoteMessage.appData[AnyHashable("senderId")] as? String else {
                return
            }
            guard let receiverID = remoteMessage.appData[AnyHashable("recieverId")] as? String else {
                return
            }
            guard let type = remoteMessage.appData[AnyHashable("type")] as? String else {
                return
            }
            
            
            let state = UIApplication.shared.applicationState
            
            if state == .background {
                
            }
                
            else if state == .inactive {
                
            }
                
            else if state == .active {
                
            }
            
            let  banner = NotificationBanner(title: textTitle, subtitle: userMessage, style: .success)
            banner.autoDismiss = true
            banner.delegate = self
            banner.show()
            banner.onTap = {
                if topic == "broadcast" {
                    banner.dismiss()
                    self.moveToHome()
                }
                if topic == "chat" {
                    banner.dismiss()
                    
                    let chatVC = self.storyboard.instantiateViewController(withIdentifier: "ChatController") as! ChatController
                    let nav: UINavigationController = UINavigationController(rootViewController: chatVC)
                    chatVC.ad_id = adID
                    chatVC.sender_id = senderID
                    chatVC.receiver_id = receiverID
                    chatVC.messageType = type
                    self.window?.rootViewController = nav
                    UserDefaults.standard.set("1", forKey: "fromNotification")
                    self.window?.makeKeyAndVisible()
                }
            }
            banner.onSwipeUp = {
                banner.dismiss()
            }
            
        }else{
            
            guard let data = remoteMessage.appData[AnyHashable("data")]as? String else  {
                return
            }
            
            
            let dict = convertToDictionary(text: data)
            print("Dictionary is: \(dict!)")
            let title = dict!["title"] as! String
            let message = dict!["message"] as! String
            
            
            let  banner = NotificationBanner(title: title, subtitle:message, style: .success)
            banner.autoDismiss = true
            banner.delegate = self
            banner.show()
            banner.onTap = {
                if topic == "broadcast" {
                    banner.dismiss()
                    self.moveToHome()
                }
                if topic == "chat" {
                    banner.dismiss()
                    
                    let chatVC = self.storyboard.instantiateViewController(withIdentifier: "ChatController") as! ChatController
                    let nav: UINavigationController = UINavigationController(rootViewController: chatVC)
                    //                chatVC.ad_id = adID
                    //                chatVC.sender_id = senderID
                    //                chatVC.receiver_id = receiverID
                    //                chatVC.messageType = type
                    self.window?.rootViewController = nav
                    UserDefaults.standard.set("1", forKey: "fromNotification")
                    self.window?.makeKeyAndVisible()
                }
            }
            banner.onSwipeUp = {
                banner.dismiss()
            }
            
        }
        
        
    }

    
    
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
}
