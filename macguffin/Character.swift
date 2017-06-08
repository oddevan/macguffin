//
//  Character.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/4/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

//import Foundation

protocol CharacterMonitor {
    func character(_ sender: Character, levelChangedTo: Int)
    func character(_ sender: Character, expChangedBy: Int)
    func character(_ sender: Character, hpChangedBy: Int)
    func character(_ sender: Character, mpChangedBy: Int)
    func character(_ sender: Character, statusChangedTo: Status)
    func character(_ sender: Character, learnedAttack: Attack)
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
    
    var exp: Int = 0 {
        didSet {
            if exp < 0 { exp = 0 }
            
            monitor?.character(self, expChangedBy: exp - oldValue)
            
            while level < 100 && exp >= 50 * (level * level + level) { // 50(x^2 + x)
                level += 1
            }
        }
    }
    
    var hp: Int = 0 {
        didSet {
            if hp < 0 { hp = 0 }
            else if hp > maxHP { hp = maxHP }
            
            monitor?.character(self, hpChangedBy: self.hp - oldValue)
        }
    }
    
    var mp: Int = 0 {
        didSet {
            if mp < 0 { mp = 0 }
            else if mp > maxMP { mp = maxMP }
            
            monitor?.character(self, mpChangedBy: self.mp - oldValue)
        }
    }
    
    var status: Status = Status.normal { didSet { monitor?.character(self, statusChangedTo: self.status) } }
    
    var wait: Int = 0 //Temp value for battle timing
    
    var intelligence: Intelligence
    var monitor: CharacterMonitor?
    
    var atk: Int { return Int(Double(baseAttack) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var def: Int { return Int(Double(baseDefense) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var mag: Int { return Int(Double(baseMagic) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var spd: Int { return Int(Double(baseSpeed) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var acc: Int { return Int(Double(baseAccuracy) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var maxHP: Int { return Int(Double(baseMaxHP) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    var maxMP: Int { return Int(Double(baseMaxMP) * (1 + Utility.Character.StatBumpPerLevel * Double(level))) }
    
    var isAlive: Bool { return hp > 0 }
    
    var defaultAttack: Attack?
    var specialAttacks: [Attack] = []
    
    var standardAttack: Attack {
        if currentJob > -1 {
            return jobs[currentJob].job.defaultAttack
        } else if let defatk = self.defaultAttack {
            return defatk
        } else {
            return Attack(name: "Hit", type: Type.normal, power: 1, draw: 0, status: Status.normal, isTeam: false)
        }
    }
    
    var jobs: [JobProgress] = [] {
        didSet {
            if currentJob == -1 {
                currentJob = 0
            }
            if jobs.isEmpty {
                currentJob = -1
            }
        }
    }
    var currentJob: Int = -1
    
    var team: Team?
    
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
        
        self.hp = self.maxHP
        self.mp = self.maxMP
    }
    
    func spUp(_ amount: Int) {
        if currentJob >= 0 && currentJob < jobs.count {
            jobs[currentJob].sp += amount
        }
    }
    
    func learn(_ newSkill: Attack) {
        specialAttacks.append(newSkill)
        monitor?.character(self, learnedAttack: newSkill)
    }
}
