//
//  Type.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

enum Type : Printable {
    case Normal
    case Earth
    case Fire
    case Wind
    case Water
    case LightMagic
    case DarkMagic
    
    var description: String {
        switch self {
        case .Normal: return "Normal"
        case .Earth: return "Earth"
        case .Fire: return "Fire"
        case .Wind: return "Wind"
        case .Water: return "Water"
        case .LightMagic: return "Light Magic"
        case .DarkMagic: return "Dark Magic"
        }
    }
}