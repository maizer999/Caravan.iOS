//
//  CollectionViewSettings.swift
//  AdForest
//
//  Created by apple on 5/29/18.
//  Copyright © 2018 apple. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewSettings {
    
    static let totalItem: CGFloat = 9
    static let column: CGFloat = 3
    static let minLineSpacing: CGFloat = 1.0
    static let minItemSpacing: CGFloat = 1.0
    
     static let offset: CGFloat = 1.0
    
    static func getItemWidth(boundWidth: CGFloat) -> CGFloat {
        let totalWidth = boundWidth - (offset + offset) - ((column - 1) * minItemSpacing)
        return totalWidth / column
    }
}


class CollectionViewForuCell {
    
    static let totalItem: CGFloat = 9
    static let column: CGFloat = 4
    static let minLineSpacing: CGFloat = 1.0
    static let minItemSpacing: CGFloat = 1.0
    
    static let offset: CGFloat = 1.0
    
    static func getItemWidth(boundWidth: CGFloat) -> CGFloat {
        let totalWidth = boundWidth - (offset + offset) - ((column - 1) * minItemSpacing)
        return totalWidth / column
    }
}
