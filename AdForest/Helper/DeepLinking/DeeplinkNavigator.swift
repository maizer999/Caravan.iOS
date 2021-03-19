//
//  DeeplinkNavigator.swift
//  AdForest
//
//  Created by Apple on 11/19/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

class DeepLinkNavigator {
    static let shared = DeepLinkNavigator()
    private init() {}
    
    func proceedTodeepLink(_ type: DeepLinkType) {
        switch type {
        case .broadcast:
            print("BroadCast")
        case .chat:
            print("Chat")
        default:
            break
        }
    }
}
