//
//  Attack.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

//import Foundation

class Attack {
    let name: String
    let type: Type
    let power: Int
    let draw: Int
    let status: Status
    let isTeam: Bool
    
    init(name: String, type: Type, power: Int, draw: Int, status: Status, isTeam: Bool) {
        self.name = name
        self.type = type
        self.power = power
        self.draw = draw
        self.status = status
        self.isTeam = isTeam
    }
    
    func perform(attacker:Character, victim:Character) {
        //TODO: do stuff
    }
}