//
//  AdPostImages.swift
//  AdForest
//
//  Created by apple on 4/27/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct AdPostImages {
    
    var isShow : Bool!
    var message : String!
    var numbers : Int!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        message = dictionary["message"] as? String
        numbers = dictionary["numbers"] as? Int
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
        if message != nil{
            dictionary["message"] = message
        }
        if numbers != nil{
            dictionary["numbers"] = numbers
        }
        return dictionary
    }
    
}
