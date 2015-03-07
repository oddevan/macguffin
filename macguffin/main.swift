//
//  main.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

import Foundation

func input() -> String {
    var keyboard = NSFileHandle.fileHandleWithStandardInput()
    var inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\n"))
}

class IntelDemo: Intelligence {
    let standardAttack = Attack(name: "Punch", type: Type.Normal, power: 2, draw: 0, status: Status.Normal, isTeam: false)
    
    // From Intelligence
    
    func characterNeedsDecision(character: Character, forBattle: Battle) {
        println(">>> \(character.name)'s turn")
        println(">>>")
        println(">>> Who to attack?")
        
        for (var k = 0; k < forBattle.battleQueue.count; ++k) {
            println(">>> \(k): \(forBattle.battleQueue[k].name)")
        }
        
        let choice = input()
        if let victimIndex = choice.toInt() {
            forBattle.characterPerformAction(character, targeting: forBattle.battleQueue[victimIndex], withAttack: standardAttack)
        } else {
            println(">>> Invalid input: '\(choice)'")
            characterNeedsDecision(character, forBattle: forBattle)
        }
        
    }
    
}

class BattleDemo: BattleMonitor, CharacterMonitor, BattleDelegate {
    let intel = IntelDemo()
    
    let team1: Team
    
    let sonic: Character
    let twilight: Character
    
    let team2: Team
    
    let mewtwo: Character
    
    var battle: Battle?
    
    init() {
        self.sonic = Character(name: "Sonic", baseAttack: 5, baseDefense: 3, baseMagic: 2, baseSpeed: 7, baseAccuracy: 7, baseMaxHP: 50, baseMaxMP: 10, intelligence: self.intel)
        self.twilight = Character(name: "Twilight", baseAttack: 4, baseDefense: 7, baseMagic: 7, baseSpeed: 5, baseAccuracy: 5, baseMaxHP: 70, baseMaxMP: 30, intelligence: self.intel)
        self.mewtwo = Character(name: "Mewtwo", baseAttack: 4, baseDefense: 4, baseMagic: 8, baseSpeed: 3, baseAccuracy: 8, baseMaxHP: 70, baseMaxMP: 30, intelligence: self.intel)
        
        self.team1 = Team()
        team1.active.append(sonic)
        team1.active.append(twilight)
        
        self.team2 = Team()
        team2.active.append(mewtwo)
        
        self.sonic.monitor = self
        self.twilight.monitor = self
        //self.mewtwo.monitor = self
        
        self.battle = Battle(proTeam: team1, antTeam: team2, delegate: self)
        self.battle!.monitor = self
    }
    
    func go() {
        battle!.startBattle()
    }
    
    // From BattleDelegate
    
    func battleCompleted(sender: Battle, protagonistsWon: Bool) {
        if protagonistsWon {
            println("The chaos of friendship cannot be defeated!")
        } else {
            println("And Mewtwo's ego gets slightly larger...")
        }
        println("----------")
        println("Thank you for playing. Until next time!")
        exit(EXIT_SUCCESS)
    }
    
    func battleInvalidState(sender: Battle) {
        println("WTF battle just crashed?")
        exit(EXIT_FAILURE)
    }
    
    // From BattleMonitor
    
    func battleBegun(sender: Battle) {
        println("----------")
        println("New battle!")
        println("----------")
        
        for char in sender.proTeam.active {
            println("    " + char.name)
        }
        println("> VERSUS <")
        for char in sender.antTeam.active {
            println("    " + char.name)
        }
        println("----------")
    }
    
    func battle(sender: Battle, activeCharacter: Character, performedAttack: Attack, againstCharacter: Character, forDamage: Int?, forStatus: Status?) {
        println("# \(activeCharacter.name) attacked \(againstCharacter.name) with \(performedAttack.name)")
        
        var anyEffect = false
        if let damage = forDamage {
            println("# \(againstCharacter.name) took \(damage) damage.")
            anyEffect = true
        }
        if let status = forStatus {
            println("# \(againstCharacter.name) status: \(status)")
            anyEffect = true
        }
        
        if !anyEffect {
            println("# No effect!")
        }
    }
    
    func battle(sender: Battle, activeCharacter: Character, usedItem: Item, againstCharacter: Character, forDamage: Int?, forStatus: Status?) {
            println("# \(activeCharacter.name) used \(usedItem.name) on \(againstCharacter.name)")
            
            var anyEffect = false
            if let damage = forDamage {
                println("# \(againstCharacter.name) gained \(-1*damage) HP.")
                anyEffect = true
            }
            if let status = forStatus {
                println("# \(againstCharacter.name) status: \(status)")
                anyEffect = true
            }
            
            if !anyEffect {
                println("# No effect!")
            }
    }
    
    func battle(sender: Battle, characterDied: Character) {
        println("# " + characterDied.name + " fell.")
    }
    
    func battleEnded(sender: Battle) {
        println("----------")
        println("Battle completed!")
    }
    
    // From CharacterMonitor
    
    func characterStateChanged(sender: Character) {
        println("% \(sender.name): HP\(sender.hp)/\(sender.maxHP) MP\(sender.mp)/\(sender.maxMP) \(sender.status)")
    }
}


println("Alright guys, time's up, let's do this thing.")

let demo = BattleDemo()
demo.go()
