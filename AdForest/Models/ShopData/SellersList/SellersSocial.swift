//
//  SellersSocial.swift
//  AdForest
//
//  Created by Apple on 9/6/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct SellersSocial {
    
    var isShowSocial : Bool!
    var socialIcons : [SellersSocialIcon]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShowSocial = dictionary["is_show_social"] as? Bool
        socialIcons = [SellersSocialIcon]()
        if let socialIconsArray = dictionary["social_icons"] as? [[String:Any]]{
            for dic in socialIconsArray{
                let value = SellersSocialIcon(fromDictionary: dic)
                if value.key != "Google+"{
                     socialIcons.append(value)
                }
               
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if isShowSocial != nil{
            dictionary["is_show_social"] = isShowSocial
        }
        if socialIcons != nil{
            var dictionaryElements = [[String:Any]]()
            for socialIconsElement in socialIcons {
                dictionaryElements.append(socialIconsElement.toDictionary())
            }
            dictionary["social_icons"] = dictionaryElements
        }
        return dictionary
    }
    
}
