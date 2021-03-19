//
//  AppSettingSection.swift
//  AdForest
//
//  Created by Apple on 9/25/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct AppSettingSection {
    
    var about : String!
    var general : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        about = dictionary["About"] as? String
        general = dictionary["general"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if about != nil{
            dictionary["About"] = about
        }
        if general != nil{
            dictionary["general"] = general
        }
        return dictionary
    }
    
}
