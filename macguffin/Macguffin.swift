//
//  Macguffin.swift
//  macguffin
//
//  Created by Evan Hildreth on 3/8/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

import Foundation

class Macguffin {
    static var randomFloat: Float { return Float(arc4random()) / Float(UINT32_MAX) }
}