//
//  Macguffin.swift
//  macguffin
//
//  Created by Evan Hildreth on 3/8/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

import Foundation

struct Utility {
    static var randomFloat: Float { return Float(arc4random()) / Float(UINT32_MAX) }
    static func randomInt(upToButNotIncluding: Int) -> Int { return Int(arc4random_uniform(UInt32(upToButNotIncluding))) }
    
    struct Character {
        static let StatBumpPerLevel: Double = 0.1
    }
    
    struct Attack {
        static let ChanceOfCriticalHit: Double = 0.1
    }
}