//
//  Character.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/4/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

//import Foundation

protocol CharacterMonitor {
    func characterStateChanged(sender: Character)
}

class Character {
    var name: String
    
    let baseAttack: Int
    let baseDefense: Int
    let baseMagic: Int
    let baseSpeed: Int
    let baseAccuracy: Int
    let baseMaxHP: Int
    let baseMaxMP: Int
    
    var level: Int = 1
    
    var atk: Int { return baseAttack }
    var def: Int { return baseDefense }
    var mag: Int { return baseMagic }
    var spd: Int { return baseSpeed }
    var acc: Int { return baseAccuracy }
    var maxHP: Int { return baseMaxHP }
    var maxMP: Int { return baseMaxMP }
    
    var hp: Int
    var mp: Int
    var status: Status
    
    var isAlive: Bool { return hp > 0 }
    
    var wait: Int = 0 //Temp value for battle timing
    
    var intelligence: Intelligence
    var monitor: CharacterMonitor?
    
    init(name: String, baseAttack: Int, baseDefense: Int, baseMagic: Int, baseSpeed: Int, baseAccuracy: Int, baseMaxHP: Int, baseMaxMP: Int, intelligence: Intelligence) {
        self.name = name
        
        self.baseAccuracy = baseAccuracy
        self.baseAttack = baseAttack
        self.baseDefense = baseDefense
        self.baseMagic = baseMagic
        self.baseSpeed = baseSpeed
        self.baseMaxHP = baseMaxHP
        self.baseMaxMP = baseMaxMP
        self.intelligence = intelligence
        
        self.hp = self.baseMaxHP
        self.mp = self.baseMaxMP
        self.status = Status.Normal
    }
}