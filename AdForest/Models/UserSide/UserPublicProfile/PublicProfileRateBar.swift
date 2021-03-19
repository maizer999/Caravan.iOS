//
//  PublicProfileRateBar.swift
//  AdForest
//
//  Created by apple on 4/13/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct PublicProfileRateBar {
    
    var number : String!
    var text : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        number = dictionary["number"] as? String
        text = dictionary["text"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if number != nil{
            dictionary["number"] = number
        }
        if text != nil{
            dictionary["text"] = text
        }
        return dictionary
    }
    
}
