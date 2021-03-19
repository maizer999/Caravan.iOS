//
//  NSObject.swift
//  AdForest
//
//  Created by Apple on 9/11/19.
//  Copyright © 2019 apple. All rights reserved.
//

import Foundation

extension NSObject {
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
}
