//
//  AddTimer.swift
//  AdForest
//
//  Created by apple on 4/18/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct AddTimer{
    
    var isShow : Bool!
    var timer : String!
    var timerStrings : AdTimerStrings!
    var serverTime : String!
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        isShow = dictionary["is_show"] as? Bool
        timer = dictionary["timer_time"] as? String
        serverTime = dictionary["timer_server_time"] as? String

        if let adTimerStrings = dictionary["timer_strings"] as? [String:Any]{
            timerStrings = AdTimerStrings(fromDictionary: adTimerStrings)
        }



    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        

        if isShow != nil{
            dictionary["is_show"] = isShow
        }
        if timer != nil{
            dictionary["timer_time"] = timer
        }
                return dictionary
    }
    
}
