//
//  SettingsShopMenu.swift
//  AdForest
//
//  Created by Apple on 10/15/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct SettingsShopMenu {
    
    var title : String!
    var url : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        title = dictionary["title"] as? String
        url = dictionary["url"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if title != nil{
            dictionary["title"] = title
        }
        if url != nil{
            dictionary["url"] = url
        }
        return dictionary
    }
    
}
