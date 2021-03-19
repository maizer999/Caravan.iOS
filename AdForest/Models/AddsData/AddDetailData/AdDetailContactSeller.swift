//
//  AdDetailContactSeller.swift
//  AdForest
//
//  Created by Glixen on 20/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct AdDetailContactSeller {
    var isShow: Bool!
    var btnCancel : String!
    var btnSend : String!
    var titleContactSeller : String!
    var subtitleContactSeller : String!
    var popupName : ContactSellerPopupName!
    var popupEmail : ContactSellerPopupEmail!
    var popupPhone : ContactSellerPopupPhone!
    var popupMessage : ContactSellerPopupMessage!
    
    
    
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        btnCancel = dictionary["popup_cancel"] as? String
        btnSend = dictionary["popup_confirm"] as? String
        titleContactSeller = dictionary["title"] as? String
        subtitleContactSeller = dictionary["subtitle"] as? String
        if let popupNameData = dictionary["popup_name"] as? [String:Any]{
            popupName = ContactSellerPopupName(fromDictionary: popupNameData)
        }
        
        if let popupEmailData = dictionary["popup_email"] as? [String:Any]{
            popupEmail = ContactSellerPopupEmail(fromDictionary: popupEmailData)
        }
        
        if let popupPhoneData = dictionary["popup_phone"] as? [String:Any]{
            popupPhone = ContactSellerPopupPhone(fromDictionary: popupPhoneData)
        }
        
        if let popupMessageData = dictionary["popup_message"] as? [String:Any]{
            popupMessage = ContactSellerPopupMessage(fromDictionary: popupMessageData)
        }
        
    }
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if btnCancel != nil{
            dictionary["popup_cancel"] = btnCancel
        }
        if btnSend != nil{
            dictionary["popup_send"] = btnSend
        }
        if titleContactSeller != nil{
            dictionary["title"] = titleContactSeller
        }
        if subtitleContactSeller != nil{
            dictionary["subtitle"] = subtitleContactSeller
        }
        //        if popupName != nil{
        //            dictionary["popup_name"] = popupName
        //        }
        //        if popupEmail != nil{
        //            dictionary["popup_email"] = popupEmail
        //        }
        //        if popupPhone != nil{
        //            dictionary["popup_phone"] = popupPhone
        //        }
//        if popupMessage != nil{
//            dictionary["popup_message"] = popupMessage
//        }
        return dictionary
    }
    
    
    
}
