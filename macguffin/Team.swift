//
//  Team.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/17/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

class Team {
    var active: [Character] = []
    var bench: [Character] = []
    var inventory: [ItemQuantity] = []
    
    func enroll(newbie: Character) {
        if active.count >= Utility.Team.MaxActiveCharacters {
            bench.append(newbie)
        } else {
            active.append(newbie)
        }
        newbie.team = self
    }
}