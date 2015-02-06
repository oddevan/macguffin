//
//  Character.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/4/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

//import Foundation

protocol CharacterMonitor {
    func characterStateChanged(sender:Character)
}

class Character {
    var name:String
    
    let baseAttack:Int
    let baseDefense:Int
    let baseMagic:Int
    let baseSpeed:Int
    let baseAccuracy:Int
    
    var atk:Int { get { return baseAttack } }
    var def:Int { get { return baseDefense } }
    var mag:Int { get { return baseMagic } }
    var spd:Int { get { return baseSpeed } }
    var acc:Int { get { return baseAccuracy } }
    
    init(name:String, baseAttack:Int, baseDefense:Int, baseMagic:Int, baseSpeed:Int, baseAccuracy:Int) {
        self.name = name
        
        self.baseAccuracy = baseAccuracy
        self.baseAttack = baseAttack
        self.baseDefense = baseDefense
        self.baseMagic = baseMagic
        self.baseSpeed = baseSpeed
    }
}