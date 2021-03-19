
//
//  BlogDetailRoot.swift
//  AdForest
//
//  Created by apple on 3/29/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct BlogDetailRoot{ 
    
    var data : BlogDetailData!
    var extra : BlogDetailExtra!
    var message : String!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        if let dataData = dictionary["data"] as? [String:Any]{
            data = BlogDetailData(fromDictionary: dataData)
        }
        if let extraData = dictionary["extra"] as? [String:Any]{
            extra = BlogDetailExtra(fromDictionary: extraData)
        }
        message = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if data != nil{
            dictionary["data"] = data.toDictionary()
        }
        if extra != nil{
            dictionary["extra"] = extra.toDictionary()
        }
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
    
}
