//
//  Potion.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

class Potion : Item {
    override init() {
        self.name = "Potion"
    }
    
    override func use(target: Character) -> Bool {
        if target.hp >= target.maxHP {
            return false
        }
        
        target.hp += 30
        return true
    }
}