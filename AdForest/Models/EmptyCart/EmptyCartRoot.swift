//
//  EmptyCartRoot.swift
//  AdForest
//
//  Created by Glixen on 1/28/20.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct EmptyCartRoot{
    
   
//    var data : String!
    var message : String!
    var success : Bool!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
//        if let dataData = dictionary["data"] as? [String:Any]{
//            data = LoginData(fromDictionary: dataData)
//        }
        message = dictionary["message"] as? String
//         data = dictionary["message"] as? String
        success = dictionary["success"] as? Bool
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        if message != nil{
            dictionary["message"] = message
        }
        if success != nil{
            dictionary["success"] = success
        }
        return dictionary
    }
    
}
