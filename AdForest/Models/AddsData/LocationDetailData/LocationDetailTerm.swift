//
//  LocationDetailTerm.swift
//  AdForest
//
//  Created by Apple on 9/12/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct LocationDetailTerm {
    
    var count : Int!
    var hasChildren : Bool!
    var name : String!
    var parent : Int!
    var termId : Int!
    var termImg : String!
    var catCount : String!

    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        count = dictionary["count"] as? Int
        catCount = dictionary["count"] as? String
        hasChildren = dictionary["has_children"] as? Bool
        name = dictionary["name"] as? String
        parent = dictionary["parent"] as? Int
        termId = dictionary["term_id"] as? Int
        termImg = dictionary["term_img"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if count != nil{
            dictionary["count"] = count
        }
        if catCount != nil{
            dictionary["count"] = catCount
        }
        if hasChildren != nil{
            dictionary["has_children"] = hasChildren
        }
        if name != nil{
            dictionary["name"] = name
        }
        if parent != nil{
            dictionary["parent"] = parent
        }
        if termId != nil{
            dictionary["term_id"] = termId
        }
        if termImg != nil{
            dictionary["term_img"] = termImg
        }
        return dictionary
    }
    
}
