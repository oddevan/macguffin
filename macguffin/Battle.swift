//
//  Battle.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/25/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

protocol BattleDelegate {
    func battleCompleted(_ sender: Battle, protagonistsWon: Bool)
    func battleInvalidState(_ sender: Battle)
}

// All of these should be optional, but I don't feel like dealing with
// a crapton of @objc crap in this crapfest.
protocol BattleMonitor {
    func battleBegun(_ sender: Battle)
    
    func battle(  _ sender: Battle,
         activeCharacter: Character,
         performedAttack: Attack,
        againstCharacter: Character,
        withResult: AttackResult)
    
    func battle(_ sender: Battle,
        activeCharacter: Character,
        usedItem: Item,
        againstCharacter: Character,
        forDamage: Int?,
        forStatus: Status?)
    
    func battle(_ sender: Battle, characterDied: Character)
    
    func battleEnded(_ sender: Battle)
}

class Battle {
    let proTeam: Team
    let antTeam: Team
    let delegate: BattleDelegate
    
    var proTeamQueuedExp: Int = 0
    var antTeamQueuedExp: Int = 0
    
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
        self.battleQueue.sort(by: { $0.spd < $1.spd })
        
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
    
    func characterPerformAction(_ performer: Character, targeting: Character, withAttack: Attack) {
        //let prevHP = targeting.hp
        
        let attackResult = withAttack.perform(performer, victim: targeting)
        
        monitor?.battle(self, activeCharacter: performer, performedAttack: withAttack, againstCharacter: targeting, withResult: attackResult)
        
        performer.exp += (attackResult.damage / 2)
        if let attackingTeam = performer.team {
            if attackingTeam === proTeam {
                proTeamQueuedExp += (attackResult.damage / 3)
            } else {
                antTeamQueuedExp += (attackResult.damage / 3)
            }
        }
        
        if !targeting.isAlive {
            monitor?.battle(self, characterDied: targeting)
        }
        
        endTurn()
    }
    
    func characterPerformAction(_ performer: Character, targeting: Character, withItem: Item) {
        let prevHP = targeting.hp
        
        if withItem.use(targeting) {
            monitor?.battle(self, activeCharacter: performer, usedItem: withItem, againstCharacter: targeting, forDamage: prevHP - targeting.hp, forStatus: nil)
            
            if !targeting.isAlive {
                monitor?.battle(self, characterDied: targeting)
            }
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
            endBattle(isTeamAlive(proTeam))
        }
    }
    
    func endBattle(_ protagonistsWon: Bool) {
        if protagonistsWon {
            for member in proTeam.active + proTeam.bench {
                member.exp += proTeamQueuedExp
            }
        } else {
            for member in antTeam.active + antTeam.bench {
                member.exp += antTeamQueuedExp
            }
        }
        
        monitor?.battleEnded(self)
        delegate.battleCompleted(self, protagonistsWon: protagonistsWon)
    }
    
    
    // This function checks for anyone alive in the team's 'active' array
    // To override with other conditions, override this function.
    func isTeamAlive(_ checkMe: Team) -> Bool {
        for char in checkMe.active {
            if char.isAlive {
                return true
            }
        }
        return false
    }
    
    func sortQueue() {
        self.battleQueue.sort(by: {
            if $0.wait == $1.wait {
                return $0.spd > $1.spd
            } else {
                return $0.wait > $1.wait
            }
        })
    }
}
