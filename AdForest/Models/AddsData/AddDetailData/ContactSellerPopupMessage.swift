//
//  ContactSellerPopupMessage.swift
//  AdForest
//
//  Created by Glixen on 20/08/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct  ContactSellerPopupMessage {
    var title : String!
    var key : String!
    var isRequired : Bool!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        title = dictionary["title"] as? String
        key = dictionary["key"] as? String
        isRequired = dictionary["is_required"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        //        if name != nil{
        //            dictionary["name"] = name
        //        }
        //        if value != nil{
        //            dictionary["value"] = value
        //        }
        return dictionary
    }
}
