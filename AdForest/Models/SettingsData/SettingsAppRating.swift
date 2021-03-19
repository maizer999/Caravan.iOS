//
//  SettingsAppRating.swift
//  AdForest
//
//  Created by apple on 4/14/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct SettingsAppRating{
    
    var btnCancel : String!
    var btnConfirm : String!
    var isShow : Bool!
    var title : String!
    var url : String!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        btnCancel = dictionary["btn_cancel"] as? String
        btnConfirm = dictionary["btn_confirm"] as? String
        isShow = dictionary["is_show"] as? Bool
        title = dictionary["title"] as? String
        url = dictionary["url"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if btnCancel != nil{
            dictionary["btn_cancel"] = btnCancel
        }
        if btnConfirm != nil{
            dictionary["btn_confirm"] = btnConfirm
        }
        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if title != nil{
            dictionary["title"] = title
        }
        if url != nil{
            dictionary["url"] = url
        }
        return dictionary
    }
    
}
