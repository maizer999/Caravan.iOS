//
//  Constants.swift
//  AdForest
//
//  Created by apple on 3/8/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import UIKit
import DeviceKit

class Constants {
    struct  URL {
        
        static let ipAddress =  "https://kilnkon.com/caravansite/ca/"//Enter your domain name here


        static let baseUrl =  ipAddress + "wp-json/adforest/v1/"
        
        static let homeData = "home"
        static let category = "ad_post/category"
        static let locationDetail = "terms"
        
        static let settings = "settings"
        static let logIn = "login"
        static let register = "register"
        static let forgotPassword = "forgot"
        static let userConfirmation = "login/confirm"
        static let profileGet = "profile"
        static let userProfileRating = "profile/ratting"
        static let verifyPhone = "profile/phone_number"
        static let verifyCode = "profile/phone_number/verify"
        static let changePassword = "profile/reset_pass"
        static let imageUpdate = "profile/image"
        static let userPublicProfile = "profile/public"
        static let blockedUsersList = "user/block"
        static let blockedUsersChatList = "message/chat/userblocklist"
        static let unBlockUser = "user/unblock"
        static let blockUser = "user/block"
        
        static let getMostViewedAd = "ad/most-visited"
        static let getExpAds = "ad/expire-sold"
        static let getMyAds = "ad"
        static let getInactiveAds = "ad/inactive"
        static let getFeaturedAds = "ad/featured"
        static let getFavouriteAds = "ad/favourite"
        static let rejectedAds = "ad/rejected"
        static let addDetail = "ad_post"
        static let makeAddFeature = "ad_post/featured"
        static let makeAddFavourite = "ad_post/favourite"
        static let reportAdd = "ad_post/report"
        static let addDetailRating = "ad_post/ad_rating"
        static let publicUserRating = "profile/ratting_get"
        static let postRating = "profile/ratting"
        
        static let getBidsData = "ad_post/bid"
        static let adNewReply = "ad_post/ad_rating/new"
        static let postBid = "ad_post/bid/post/"
        
        static let removeFavouriteAd = "ad/favourite/remove"
        static let deleteAdd = "ad/delete"
        static let addStatusChange = "ad/update/status"
        
        static let getBlog = "posts"
        static let blogDetail = "posts/detail"
        static let blogPostComment = "posts/comments"
        
        static let packages = "packages"
        static let paymentConfirmation = "payment"
        static let paymentSuccess = "payment/complete"
        
        static let sentOffers = "message"
        static let offerOnAds = "message/inbox"
        static let getSentOfferChatMessages = "message/chat"
        static let sendmessage = "message/chat"
        static let messageAttachment = "message/chat_media"
        static let offerOnAdsDetail = "message/offers"
        static let adDetailPopUpMsg = "message/popup"
        
        static let adPost = "post_ad/is_update"
        static let adPostDynamicField = "post_ad/dynamic_fields"
        static let adPostSubCategory = "post_ad/subcats"
        static let adPostUploadImages = "post_ad/image"
        static let adPostDeleteImage = "post_ad/image/delete"
        static let adPostSubLocations = "post_ad/sublocations"
        
        static let adPostLive = "post_ad"
        static let advanceSearch = "ad_post/search"
        static let subCategory = "ad_post/subcats"
        static let searchDynamic = "ad_post/dynamic_widget"
        static let categorySublocations = "ad_post/sublocations"
        
        static let nearByLocation = "profile/nearby"
        
        static let deleteAccount = "profile/delete/user_account"
        static let termsPage = "page"
        
        static let sellerList = "sellers"
        
        static let appSettings = "app_extra"
        static let feedback = "app_extra/feedback"
        
        static let blockUserChat = "message/chat/userblock"
        static let UnblockUserChat = "message/chat/userunblock"
        
        static let topLocation = "site-location"
        static let reactEmojis = "ad_post/ad_rating/rating_emojies"
        static let logout = "logout"
        static let cartEmpty = "cart-empty"
        static let contactSeller = "ad_post/seller_contact/"
        static let resendEmail = "login/confirm/resend/"


    }
    struct AdMob {
            static let objData = UserHandler.sharedInstance.objAdMob
        static let intersetialId = objData?.adId
            //"ca-app-pub-3940256099942544/4411468910"
        }
    
    struct customCodes {
        
        static let purchaseCode = "b8e4c0ec-2b63-4c11-816f-bed0c69fb6c9"
        static let securityCode = "co!Q@W#E$"
    }
    
    
    struct LinkedInConstants {
            
        static let CLIENT_ID = "Enter Your LINKEDIN_CLIENT_ID here";//Enter Your LINKEDIN_CLIENT_ID here
        static let CLIENT_SECRET = "Enter Your LINKEDIN_CLIENT_SECRET here";//Enter Your LINKEDIN_CLIENT_SECRET here
        static let REDIRECT_URI = "Enter Your LINKEDIN_REDIRECT_URL here";//Enter Your LINKEDIN_REDIRECT_URL here
        static let SCOPE = "r_liteprofile%20r_emailaddress" //Get lite profile info and e-mail address
        
        static let AUTHURL = "https://www.linkedin.com/oauth/v2/authorization"
        static let TOKENURL = "https://www.linkedin.com/oauth/v2/accessToken"    }
    
    
    
    struct googlePlacesAPIKey {
        
        static let placesKey = "placeskey "

        
    }
    struct MapboxAccessToken {
        
        static let MapboxAccessToken =  "pk.eyJ1IjoiZ2xpeGVuIiwiYSI6ImNrMmFkNXdjbjJpeHgzbG16bW5kZ3R5OGkifQ.sUMfX4HRKF9l3YorJ4a02A"

        
    }

    
    struct AppColor {
        static let greenColor = "#24a740"
        static let redColor = "#F25E5E"
        static let ratingColor = "#ffcc00"
        static let orangeColor = "#f58936"
        static let messageCellColor = "fffcf6"
        static let brownColor = "#90000000"
        static let expired = "#d9534f"
        static let active = "#4caf50"
        static let sold = "#3498db"
        static let featureAdd = "#d9534f"
        static let phoneVerified = "#8ac249"
        static let phoneNotVerified = "#F25E5E"
    }
    
    
    struct NotificationName {
        static let updateUserProfile = "updateProfile"
        static let updateAddDetails = "updateAds"
        static let updateBidsStats = "bidsStats"
        static let adPostImageDelete = "updateMainData"
        static let searchDynamicData = "UpdateDynamicData"
        static let updateAdPostDynamicData = "UpdateAdPostDynamicData"
    }
    
    struct NetworkError {
        static let timeOutInterval: TimeInterval = 20
        
        static let error = "Error"
        static let internetNotAvailable = "Internet Not Available"
        static let pleaseTryAgain = "Please Try Again"
        
        static let generic = 4000
        static let genericError = "Please Try Again."
        
        static let serverErrorCode = 5000
        static let serverNotAvailable = "Server Not Available"
        static let serverError = "Server Not Availabe, Please Try Later."
        
        static let timout = 4001
        static let timoutError = "Network Time Out, Please Try Again."
        
        static let login = 4003
        static let loginMessage = "Unable To Login"
        static let loginError = "Please Try Again."
        
        static let internet = 4004
        static let internetError = "Internet Not Available"
    }
    
    struct NetworkSuccess {
        static let statusOK = 200
    }
    
    struct activitySize {
        static let size = CGSize(width: 40, height: 40)
    }
    
    enum loaderMessages : String {
        case loadingMessage = ""
    }
    
    static func showBasicAlert (message: String) -> UIAlertController{
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        return alert
    }
    
    //Convert data to json string
    static func json(from object:Any) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
    
    static func dateFormatter(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")! as TimeZone
        let date = dateFormatter.date(from: date)
        // change to a readable time format and change to local time zone
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = NSTimeZone.local
        let timeStamp = dateFormatter.string(from: date!)
        return timeStamp
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    static func crossString (titleStr : String) -> NSMutableAttributedString {
        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: titleStr)
        attributeString.addAttribute(NSAttributedStringKey.baselineOffset, value: 1, range: NSMakeRange(0, attributeString.length ))
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length  ))
        attributeString.addAttribute(NSAttributedStringKey.strikethroughColor, value: UIColor.black, range:  NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    static func attributedString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize),
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    static func labelString(from string: String, nonBoldRange: NSRange?) -> NSAttributedString {
        let fontSize = UIFont.systemFontSize
        let attrs = [
            NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: fontSize),
            NSAttributedStringKey.foregroundColor: UIColor.black
        ]
        let nonBoldAttribute = [
            NSAttributedStringKey.font: UIFont.systemFont(ofSize: fontSize),
        ]
        let attrStr = NSMutableAttributedString(string: string, attributes: attrs)
        if let range = nonBoldRange {
            attrStr.setAttributes(nonBoldAttribute, range: range)
        }
        return attrStr
    }
    
    public static var isiPadDevice: Bool {
        
        let device = Device()
        
        if device.isPad {
            return true
        }
        switch device {
        case .simulator(.iPad2), .simulator(.iPad3), .simulator(.iPad4), .simulator(.iPad5), .simulator(.iPadAir), .simulator(.iPadAir2), .simulator(.iPadMini), .simulator(.iPadMini2), .simulator(.iPadMini3), .simulator(.iPadMini4), .simulator(.iPadPro9Inch), .simulator(.iPadPro10Inch), .simulator(.iPadPro12Inch), .simulator(.iPadPro12Inch2), .iPadAir, .iPad5, .iPad4, .iPad3, .iPad2, .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4:
            return true
            
        default:
            return false
        }
    }
    
    public static var isiPhone5 : Bool {
        
        let device = Device()
        
        switch device {
            
        case .simulator(.iPhone4), .simulator(.iPhone4s), .simulator(.iPhone5), .simulator(.iPhone5s), . simulator(.iPhone5c), .simulator(.iPhoneSE):
            return true
            
        case .iPhone4, .iPhone4s, .iPhone5, .iPhone5s, .iPhone5c, .iPhoneSE:
            return true
            
        default:
            return false
        }
    }
    
    public static var isIphone6 : Bool {
        let device = Device()
        switch device {
        case .iPhone6 , .simulator(.iPhone6), .iPhone6s , .simulator(.iPhone6s) , .iPhone7, .simulator(.iPhone7), .iPhone8, .simulator(.iPhone8):
            return true
        default:
            return false
        }
    }
    
    public static var isIphonePlus : Bool {
        let device = Device()
        switch device {
        case .iPhone6Plus, .simulator(.iPhone6Plus)  ,.iPhone7Plus, .simulator(.iPhone7Plus),.iPhone8Plus, .simulator(.iPhone8Plus):
            return true
        default:
            return false
        }
    }
    
    public static var isIphoneX : Bool {
        
        let device = Device()
        
        switch device {
        case .iPhoneX, .simulator(.iPhoneX) :
            return true
        default:
            return false
        }
    }
    
    public static var isIphoneXR : Bool {
        
        let device = Device()
        
        switch device {
        case .iPhoneX, .simulator(.iPhoneX) :
            return true
        default:
            return false
        }
    }
    
    public static var isSimulator: Bool {
        
        let device = Device()
        
        if device.isSimulator {
            return true
        }
        else {
            return false
        }
    }
    
    
    static func setFontSize (size : Int) -> UIFont {
        let device = Device()
        
        switch device {
        case .iPad2, .iPad3, .iPad4 , .iPad5 , .iPadAir, .iPadAir2, .iPadMini, .iPadMini2, .iPadMini3, .iPadMini4, .iPadPro9Inch, .iPadPro10Inch, .iPadPro12Inch, .iPadPro12Inch2:
            return UIFont(name: "System-Thin", size: CGFloat(size + 2))!
        case .iPhone4, .iPhone4s , .iPhone5, .iPhone5c, .iPhone5s:
            return UIFont (name: "System-Thin", size: CGFloat(size - 2))!
        default:
            return UIFont (name: "System-Thin", size: CGFloat(size))!
        }
    }
}
