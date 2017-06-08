//
//  Type.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

enum Type : CustomStringConvertible {
    case normal
    case earth
    case fire
    case wind
    case water
    case lightMagic
    case darkMagic
    
    var description: String {
        switch self {
        case .normal: return "Normal"
        case .earth: return "Earth"
        case .fire: return "Fire"
        case .wind: return "Wind"
        case .water: return "Water"
        case .lightMagic: return "Light Magic"
        case .darkMagic: return "Dark Magic"
        }
    }
}
