//
//  FooterMenuData.swift
//  AdForest
//
//  Created by Charlie on 06/10/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation

struct FooterMenuData {
var home : String!
var advSearch: String!
var adPost: String!
var profile: String!
var settings: String!

    init(fromDictionary dictionary: [String:Any]){
        home = dictionary["home"] as? String
        advSearch = dictionary["adv_search"] as? String
        adPost = dictionary["ad_post"] as? String
        profile = dictionary["profile"] as? String
        settings = dictionary["settings"] as? String
        
    }
}
