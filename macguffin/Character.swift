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
    
    func character(sender: Character, levelChangedTo: Int)
    func character(sender: Character, hpChangedBy: Int)
    func character(sender: Character, mpChangedBy: Int)
    func character(sender: Character, statusChangedTo: Status)
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
    
    var level: Int = 1 {
        didSet {
            if level < 1 { level = 1 }
            else if level > 100 { level = 100 }
            
            monitor?.character(self, levelChangedTo: level)
        }
    }
    
    var atk: Int { return Int(Double(baseAttack) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var def: Int { return Int(Double(baseDefense) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var mag: Int { return Int(Double(baseMagic) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var spd: Int { return Int(Double(baseSpeed) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var acc: Int { return Int(Double(baseAccuracy) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var maxHP: Int { return Int(Double(baseMaxHP) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var maxMP: Int { return Int(Double(baseMaxMP) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    
    var hp: Int { didSet { monitor?.character(self, hpChangedBy: self.hp - oldValue) } }
    var mp: Int { didSet { monitor?.character(self, mpChangedBy: self.mp - oldValue) } }
    var status: Status { didSet { monitor?.character(self, statusChangedTo: self.status) } }
    
    var isAlive: Bool { return hp > 0 }
    
    var wait: Int = 0 //Temp value for battle timing
    
    let defaultAttack = Attack(name: "Punch", type: Type.Normal, power: 5, draw: 0, status: Status.Normal, isTeam: false)
    
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