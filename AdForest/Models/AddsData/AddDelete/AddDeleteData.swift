//
//  AddDeleteData.swift
//  AdForest
//
//  Created by apple on 3/28/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct AddDeleteData {
    
    var iD : Int!
    var postStatus : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        iD = dictionary["ID"] as? Int
        postStatus = dictionary["post_status"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if iD != nil{
            dictionary["ID"] = iD
        }
        if postStatus != nil{
            dictionary["post_status"] = postStatus
        }
        return dictionary
    }
    
}
