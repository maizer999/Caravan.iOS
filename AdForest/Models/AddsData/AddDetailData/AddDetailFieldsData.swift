//
//  AddDetailFieldsData.swift
//  AdForest
//
//  Created by apple on 4/7/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct AddDetailFieldsData {
    
    var key : String!
    var type : String!
    var value : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        key = dictionary["key"] as? String
        type = dictionary["type"] as? String
        value = dictionary["value"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if key != nil{
            dictionary["key"] = key
        }
        if type != nil{
            dictionary["type"] = type
        }
        if value != nil{
            dictionary["value"] = value
        }
        return dictionary
    }
    
}
