//
//  Status.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

enum Status : Int, CustomStringConvertible {
    case Normal = 0
    case Sleep = 1
    case Poisoned = 2
    
    var description: String {
        switch self {
        case .Normal: return "Normal"
        case .Sleep: return "Sleep"
        case .Poisoned: return "Poisoned"
        }
    }
}