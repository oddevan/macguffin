//
//  Cure.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

class Cure : Item {
    override init() {
        self.name = "Cure"
    }
    
    override func use(target: Character) -> Bool {
        if target.status == Status.Normal {
            return false
        }
        
        target.status = Status.Normal
        return true
    }
}