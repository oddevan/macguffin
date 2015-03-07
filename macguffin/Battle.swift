//
//  Battle.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/25/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

protocol BattleDelegate {
    func battleCompleted(sender: Battle, protagonistsWon: Bool)
    func battleInvalidState(sender: Battle)
}

// All of these should be optional, but I don't feel like dealing with
// a crapton of @objc crap in this crapfest.
protocol BattleMonitor {
    func battleBegun(sender: Battle)
    
    func battle(  sender: Battle,
         activeCharacter: Character,
         performedAttack: Attack,
        againstCharacter: Character,
               forDamage: Int?,
               forStatus: Status?)
    
    func battle(sender: Battle,
        activeCharacter: Character,
        usedItem: Item,
        againstCharacter: Character,
        forDamage: Int?,
        forStatus: Status?)
    
    func battle(sender: Battle, characterDied: Character)
    
    func battleEnded(sender: Battle)
}

class Battle {
    let proTeam: Team
    let antTeam: Team
    let delegate: BattleDelegate
    
    var battleQueue: [Character]
    let waitValue: Int
    var currentAttacker: Character?
    var currentDefender: Character?
    
    var monitor: BattleMonitor?
    
    init(proTeam: Team, antTeam: Team, delegate: BattleDelegate) {
        self.proTeam = proTeam
        self.antTeam = antTeam
        self.delegate = delegate
        
        self.battleQueue = proTeam.active + antTeam.active
        self.battleQueue.sort({ $0.spd < $1.spd })
        
        if let slowest = battleQueue.first {
            self.waitValue = slowest.spd
        } else {
            self.waitValue = 0
        }
    }
    
    func startBattle() {
        // First, check for a valid state
        if waitValue <= 0 ||
           proTeam.active.isEmpty ||
           antTeam.active.isEmpty ||
           !isTeamAlive(proTeam) ||
           !isTeamAlive(antTeam) {
            delegate.battleInvalidState(self)
            return
        }
        
        currentAttacker = nil
        currentDefender = nil
        
        monitor?.battleBegun(self)
        
        nextTurn()
    }
    
    func nextTurn() {
        sortQueue()
        if let next = battleQueue.first {
            if next.wait < waitValue {
                for char in battleQueue {
                    char.wait += char.spd
                }
                nextTurn()
            } else {
                currentAttacker = next
                next.intelligence.characterNeedsDecision(next, forBattle: self)
            }
        } else {
            // battleQueue.first is nil? It's empty, which is no good
            delegate.battleInvalidState(self)
        }
    }
    
    func characterPerformAction(performer: Character, targeting: Character, withAttack: Attack) {
        let prevHP = targeting.hp
        
        withAttack.perform(performer, victim: targeting)
        
        monitor?.battle(self, activeCharacter: performer, performedAttack: withAttack, againstCharacter: targeting, forDamage: prevHP - targeting.hp, forStatus: nil)
        
        endTurn()
    }
    
    func characterPerformAction(performer: Character, targeting: Character, withItem: Item) {
        let prevHP = targeting.hp
        
        withItem.use(targeting)
        
        monitor?.battle(self, activeCharacter: performer, usedItem: withItem, againstCharacter: targeting, forDamage: prevHP - targeting.hp, forStatus: nil)
        
        if !targeting.isAlive {
            monitor?.battle(self, characterDied: targeting)
        }
        
        endTurn()
    }
    
    func endTurn() {
        if let current = currentAttacker {
            current.wait -= waitValue
        } //not the end of the world if currentAttacker is nil, so just keep going
        
        currentAttacker = nil
        currentDefender = nil
        
        //clear out the KO'd from the queue
        battleQueue = battleQueue.filter({$0.isAlive})
        
        if isTeamAlive(proTeam) && isTeamAlive(antTeam) {
            nextTurn()
        } else {
            monitor?.battleEnded(self)
            delegate.battleCompleted(self, protagonistsWon: isTeamAlive(proTeam))
        }
    }
    
    
    // This function checks for anyone alive in the team's 'active' array
    // To override with other conditions, override this function.
    func isTeamAlive(checkMe: Team) -> Bool {
        for char in checkMe.active {
            if char.isAlive {
                return true
            }
        }
        return false
    }
    
    func sortQueue() {
        self.battleQueue.sort({
            if $0.wait == $1.wait {
                return $0.spd > $1.spd
            } else {
                return $0.wait > $1.wait
            }
        })
    }
}