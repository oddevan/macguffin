//
//  Attack.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

//import Foundation

struct AttackResult {
    let missed: Bool
    let critical: Bool
    let cost: Int
    let damage: Int
}

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
    
    func perform(_ attacker:Character, victim:Character) -> AttackResult {
        attacker.mp -= self.draw
        
        let hitProbability = Float(attacker.acc) / Float(victim.spd)
        
        if Utility.randomFloat() <= hitProbability {
            if Utility.randomFloat() <= Utility.Attack.ChanceOfCriticalHit {
                let damage = attacker.atk * self.power / victim.level
                victim.hp -= damage
                
                return AttackResult(missed: false, critical: true, cost: self.draw, damage: damage)
            } else {
                let damage = attacker.atk * self.power / victim.def
                victim.hp -= damage
                
                return AttackResult(missed: false, critical: false, cost: self.draw, damage: damage)
            }
        } else {
            return AttackResult(missed: true, critical: false, cost: self.draw, damage: 0)
        }
    }
}
