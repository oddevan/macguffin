//
//  DumbArtificialIntelligence.swift
//  macguffin
//
//  Created by Evan Hildreth on 3/10/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

class DumbArtificialIntelligence: Intelligence {
    func characterNeedsDecision(_ character: Character, forBattle: Battle) {
        var victimIndex: Int
        
        if let myTeam = character.team {
            repeat {
                victimIndex = Utility.randomInt(forBattle.battleQueue.count)
            } while forBattle.battleQueue[victimIndex].team === myTeam
        } else {
            repeat {
                victimIndex = Utility.randomInt(forBattle.battleQueue.count)
            } while forBattle.battleQueue[victimIndex] === character
        }
        
        forBattle.characterPerformAction(character, targeting: forBattle.battleQueue[victimIndex], withAttack: character.standardAttack)
    }
}
