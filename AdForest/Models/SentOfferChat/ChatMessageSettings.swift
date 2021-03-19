//
//  ChatMessageSettings.swift
//  AdForest
//
//  Created by Apple on 01/02/2021.
//  Copyright © 2021 apple. All rights reserved.
//

import Foundation
struct ChatMessageSettings {
    var attachmentAllowed : Bool!
    var attachmentType: String!
    var imageSize: String!
    var attachmentSize: String!
    var attachmentformat:[String]!
    var headingPopUp: String!
    var imgLImitTxt: String!
    var docLimitTxt: String!
    var docTypeTxt: String!
    var uploadImageHeading: String!
    var uploadDocumentHeading: String!
    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        //        thumb = dictionary["thumb"] as? String
        attachmentAllowed = dictionary["attachment_allow"] as? Bool
        attachmentType = dictionary["attachment_type"] as? String
        imageSize = dictionary["image_size"] as? String
        attachmentSize = dictionary["attachment_size"] as? String
        attachmentformat = dictionary["attachment_format"] as? [String]
        headingPopUp = dictionary["upload_txt"] as? String
        imgLImitTxt  = dictionary["image_limit_txt"] as? String
        docLimitTxt = dictionary["doc_limit_txt"] as? String
        docTypeTxt = dictionary["doc_format_txt"] as? String
        uploadDocumentHeading = dictionary["upload_doc"] as? String
        uploadImageHeading = dictionary["upload_image"] as? String
    }
    
    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        
        return dictionary
    }
}
