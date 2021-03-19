//
//  AdTimerStrings.swift
//  AdForest
//
//  Created by Charlie on 14/09/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation
struct AdTimerStrings {
    
    var days: String!
    var hours: String!
    var minutes: String!
    var seconds: String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    
    init(fromDictionary dictionary: [String:Any]){
        days = dictionary["days"]as? String
        hours = dictionary["hurs"]as? String
        minutes = dictionary["mins"]as? String
        seconds = dictionary["secs"]as? String
        
        
    }
    func toDictionary() -> [String:Any]{
     var dictionary = [String:Any]()

        if days != nil{
            dictionary["days"] = days
        }
        if hours != nil{
            dictionary["hurs"] = hours
        }
        if minutes != nil{
            dictionary["mins"] = minutes
        }
        if seconds != nil{
            dictionary["secs"] = seconds
        }
        return dictionary
        
        
    }
}
