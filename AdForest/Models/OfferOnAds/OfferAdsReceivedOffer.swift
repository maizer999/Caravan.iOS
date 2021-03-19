//
//  OfferAdsReceivedOffer.swift
//  AdForest
//
//  Created by apple on 4/14/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

struct OfferAdsReceivedOffer {
    
    var items : [OfferAdsItem]!
    
    
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        items = [OfferAdsItem]()
        if let itemsArray = dictionary["items"] as? [[String:Any]]{
            for dic in itemsArray{
                let value = OfferAdsItem(fromDictionary: dic)
                items.append(value)
            }
        }
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if items != nil{
            var dictionaryElements = [[String:Any]]()
            for itemsElement in items {
                dictionaryElements.append(itemsElement.toDictionary())
            }
            dictionary["items"] = dictionaryElements
        }
        return dictionary
    }
    
}
