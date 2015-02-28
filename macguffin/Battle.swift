//
//  Battle.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/25/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

class Battle {
    let proTeam: Team
    let antTeam: Team
    
    init(proTeam: Team, antTeam: Team) {
        self.proTeam = proTeam
        self.antTeam = antTeam
    }
    
    func go() -> Bool {
        var battleQueue = proTeam.active + antTeam.active
        battleQueue.sort({ $0.spd < $1.spd })
        
        let waitValue = battleQueue.first!.spd
        
        battleQueue.sort({ $0.wait > $1.wait })
        
        do {
            battleQueue.sort({ $0.wait > $1.wait })
            
            if battleQueue.first!.wait < waitValue {
                for char in battleQueue {
                    char.wait += char.spd
                }
                battleQueue.sort({ $0.wait > $1.wait })
            }
            
            let currentCharacter = battleQueue.first!
            
            //character do action
            
            currentCharacter.wait -= waitValue
            
        } while (isTeamAlive(proTeam) && isTeamAlive(antTeam))
        
        return isTeamAlive(proTeam)
    }
    
    
    // This function checks for anyone alive in the team's 'active' array
    // To override with other conditions, override this function.
    func isTeamAlive(checkMe: Team) -> Bool {
        for char in checkMe.active {
            if char.hp > 0 {
                return true
            }
        }
        return false
    }
}