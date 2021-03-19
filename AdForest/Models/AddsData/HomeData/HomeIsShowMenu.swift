//
//  HomeIsShowMenu.swift
//  AdForest
//
//  Created by apple on 5/18/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct HomeIsShowMenu {
    
    var blog : Bool!
    var message : Bool!
    var packageField : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        blog = dictionary["blog"] as? Bool
        message = dictionary["message"] as? Bool
        packageField = dictionary["package"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if blog != nil{
            dictionary["blog"] = blog
        }
        if message != nil{
            dictionary["message"] = message
        }
        if packageField != nil{
            dictionary["package"] = packageField
        }
        return dictionary
    }
    
}
