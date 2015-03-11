//
//  DumbArtificialIntelligence.swift
//  macguffin
//
//  Created by Evan Hildreth on 3/10/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

class DumbArtificialIntelligence: Intelligence {
    func characterNeedsDecision(character: Character, forBattle: Battle) {
        var victimIndex: Int
        do {
            victimIndex = Utility.randomInt(forBattle.battleQueue.count)
        } while forBattle.battleQueue[victimIndex] === character
        
        forBattle.characterPerformAction(character, targeting: forBattle.battleQueue[victimIndex], withAttack: character.defaultAttack)
    }
}