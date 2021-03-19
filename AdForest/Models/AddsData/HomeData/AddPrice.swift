//
//  AddPrice.swift
//  AdForest
//
//  Created by apple on 4/18/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct AddPrice{
    
    var price : String!
    var priceType : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        price = dictionary["price"] as? String
        priceType = dictionary["price_type"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if price != nil{
            dictionary["price"] = price
        }
        if priceType != nil{
            dictionary["price_type"] = priceType
        }
        return dictionary
    }
    
}
