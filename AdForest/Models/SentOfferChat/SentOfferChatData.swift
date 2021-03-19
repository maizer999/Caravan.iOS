//
//  SentOfferChatData.swift
//  AdForest
//
//  Created by apple on 4/15/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct SentOfferChatData{
    
    var adDate : String!
    var adImg : [SentOfferChatAdImage]!
    var adPrice : SentOfferChatAdPrice!
    var adTitle : String!
    var chat : [SentOfferChat]!
    var pageTitle : String!
    var pagination : SentOfferChatPagination!
    var btnText : String!
    var isBlock : Bool!
    var messageSettings: ChatMessageSettings!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adDate = dictionary["ad_date"] as? String
        adImg = [SentOfferChatAdImage]()
        if let adImgArray = dictionary["ad_img"] as? [[String:Any]]{
            for dic in adImgArray{
                let value = SentOfferChatAdImage(fromDictionary: dic)
                adImg.append(value)
            }
        }
        if let adPriceData = dictionary["ad_price"] as? [String:Any]{
            adPrice = SentOfferChatAdPrice(fromDictionary: adPriceData)
        }
        adTitle = dictionary["ad_title"] as? String
        chat = [SentOfferChat]()
        if let chatArray = dictionary["chat"] as? [[String:Any]]{
            for dic in chatArray{
                let value = SentOfferChat(fromDictionary: dic)
                chat.append(value)
            }
        }
        btnText = dictionary["btn_text"] as? String
        isBlock = dictionary["is_block"] as? Bool
        pageTitle = dictionary["page_title"] as? String
        if let paginationData = dictionary["pagination"] as? [String:Any]{
            pagination = SentOfferChatPagination(fromDictionary: paginationData)
        }
        
        if let messageData = dictionary["message_setting"] as? [String:Any]{
            messageSettings = ChatMessageSettings(fromDictionary: messageData)
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if adDate != nil{
            dictionary["ad_date"] = adDate
        }
        if adImg != nil{
            var dictionaryElements = [[String:Any]]()
            for adImgElement in adImg {
                dictionaryElements.append(adImgElement.toDictionary())
            }
            dictionary["ad_img"] = dictionaryElements
        }
        if adPrice != nil{
            dictionary["ad_price"] = adPrice.toDictionary()
        }
        if adTitle != nil{
            dictionary["ad_title"] = adTitle
        }
       
        if chat != nil{
            var dictionaryElements = [[String:Any]]()
            for chatElement in chat {
                dictionaryElements.append(chatElement.toDictionary())
            }
            dictionary["chat"] = dictionaryElements
        }
        if pageTitle != nil{
            dictionary["page_title"] = pageTitle
        }
        if pagination != nil{
            dictionary["pagination"] = pagination.toDictionary()
        }

        return dictionary
    }
    
}
