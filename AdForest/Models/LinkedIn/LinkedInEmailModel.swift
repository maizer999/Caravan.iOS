//
//  LinkedInEmailModel.swift
//  AdForest
//
//  Created by Glixen on 07/05/2020.
//  Copyright © 2020 apple. All rights reserved.
//

import Foundation



// MARK: - LinkedInEmailModel
struct LinkedInEmailModel: Codable {
    let elements: [Element]
}

// MARK: - Element
struct Element: Codable {
    let elementHandle: Handle
    let handle: String

    enum CodingKeys: String, CodingKey {
        case elementHandle = "handle~"
        case handle
    }
}

// MARK: - Handle
struct Handle: Codable {
    let emailAddress: String
}
