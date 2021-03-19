//
//  SentOfferChat.swift
//  AdForest
//
//  Created by apple on 4/15/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct SentOfferChat{
    
    var adId : String!
    var date : String!
    var id : String!
    var img : String!
    var text : String!
    var type : String!
    var imgAttachment: String!
    var chatImages: [String]!
    var chatFiles: [String]!
    var hasFiles: Bool!
    var hasImages: Bool!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        adId = dictionary["ad_id"] as? String
        date = dictionary["date"] as? String
        id = dictionary["id"] as? String
        img = dictionary["img"] as? String
        text = dictionary["text"] as? String
        type = dictionary["type"] as? String
        imgAttachment = dictionary["files"] as? String
        chatImages = dictionary["images"] as? [String]
        chatFiles = dictionary["files"] as? [String]
        hasFiles = dictionary["is_file"] as? Bool
        hasImages = dictionary["is_image"] as? Bool
       
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
       
        if adId != nil{
            dictionary["ad_id"] = adId
        }
        if date != nil{
            dictionary["date"] = date
        }
        if id != nil{
            dictionary["id"] = id
        }
        if img != nil{
            dictionary["img"] = img
        }
        if text != nil{
            dictionary["text"] = text
        }
        if type != nil{
            dictionary["type"] = type
        }
        return dictionary
    }
    
}
