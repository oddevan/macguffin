//
//  Ether.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

class Ether : Item {
    override init() {
        self.name = "Ether"
    }
    
    override func use(target: Character) -> Bool {
        if target.mp >= target.maxMP {
            return false
        }
        
        target.mp += 30
        return true
    }
}