//
//  DeeplinkParser.swift
//  AdForest
//
//  Created by Apple on 11/19/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation

class DeepLinkParser {
    static let shared = DeepLinkParser()
    private init() {
    }
    
    @discardableResult
    func handleDeeplink(url: URL)-> Void {
        
    }
    
    
//    func parseDeepLink(_ url: URL) -> DeepLinkType? {
//        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
//            let host = components.host else {
//                return nil
//        }
//
//        var pathComponents = components.path.components(separatedBy: "/")
//        pathComponents.removeFirst()
//
//
//    }

}

