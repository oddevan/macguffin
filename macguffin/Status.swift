//
//  Status.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

enum Status : Int, CustomStringConvertible {
    case normal = 0
    case sleep = 1
    case poisoned = 2
    
    var description: String {
        switch self {
        case .normal: return "Normal"
        case .sleep: return "Sleep"
        case .poisoned: return "Poisoned"
        }
    }
}
