//
//  Character.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/4/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

import Foundation

class Character {
    var name:String
    
    let baseAttack:Int
    let baseDefense:Int
    let baseMagic:Int
    let baseSpeed:Int
    let baseAccuracy:Int
    
    var Atk:Int { get { return baseAttack } }
    var Def:Int { get { return baseDefense } }
    var Mag:Int { get { return baseMagic } }
    var Spd:Int { get { return baseSpeed } }
    var Acc:Int { get { return baseAccuracy } }
    
    init(name:String, baseAttack:Int, baseDefense:Int, baseMagic:Int, baseSpeed:Int, baseAccuracy:Int) {
        self.name = name
        
        self.baseAccuracy = baseAccuracy
        self.baseAttack = baseAttack
        self.baseDefense = baseDefense
        self.baseMagic = baseMagic
        self.baseSpeed = baseSpeed
    }
}