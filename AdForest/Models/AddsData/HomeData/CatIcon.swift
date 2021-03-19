//
//  CatIcon.swift
//  AdForest
//
//  Created by apple on 4/18/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct CatIcon {
    
    var catId : Int!
    var img : String!
    var name : String!
    var hasSub: Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        catId = dictionary["cat_id"] as? Int
        img = dictionary["img"] as? String
        name = dictionary["name"] as? String
        hasSub = dictionary["has_sub"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if catId != nil{
            dictionary["cat_id"] = catId
        }
        if img != nil{
            dictionary["img"] = img
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }
    
}
