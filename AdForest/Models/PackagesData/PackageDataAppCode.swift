//
//  PackageDataAppCode.swift
//  AdForest
//
//  Created by apple on 6/25/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct PackageDataAppCode {
    
    var android : String!
    var ios : String!
    var message : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        android = dictionary["android"] as? String
        ios = dictionary["ios"] as? String
        message = dictionary["message"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if android != nil{
            dictionary["android"] = android
        }
        if ios != nil{
            dictionary["ios"] = ios
        }
        if message != nil{
            dictionary["message"] = message
        }
        return dictionary
    }
    
}
