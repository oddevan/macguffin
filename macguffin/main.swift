//
//  main.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

import Foundation

// via http://stackoverflow.com/questions/24004776/input-from-the-keyboard-in-command-line-application?lq=1
func input() -> String {
    var keyboard = NSFileHandle.fileHandleWithStandardInput()
    var inputData = keyboard.availableData
    return NSString(data: inputData, encoding:NSUTF8StringEncoding)!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\n"))
}

class IntelDemo: Intelligence {
    // From Intelligence
    
    func characterNeedsDecision(character: Character, forBattle: Battle) {
        var victimIndex: Int
        var attackToUse: Attack
        
        println(">>> \(character.name)'s turn")
        println(">>>")
        
        if character.specialAttacks.isEmpty {
            attackToUse = character.standardAttack
        } else {
            println(">>> What will \(character.name) do?")
            println(">>> 0: Attack")
            println(">>> 1: Special")
            
            let menuChoice = input()
            if let tempMenuIndex = menuChoice.toInt() {
                switch tempMenuIndex {
                case 0:
                    attackToUse = character.standardAttack
                case 1:
                    println(">>> Which of \(character.name)'s attacks?")
                    for (var k = 0; k < character.specialAttacks.count; ++k) {
                        println(">>> \(k): \(character.specialAttacks[k].name)")
                    }
                    
                    let attackChoice = input()
                    if let tempAttackIndex = attackChoice.toInt() {
                        attackToUse = character.specialAttacks[tempAttackIndex]
                    } else {
                        println(">>> Invalid input: '\(attackChoice)'")
                        characterNeedsDecision(character, forBattle: forBattle)
                        return
                    }
                    
                default:
                    println(">>> Invalid input: '\(tempMenuIndex)'")
                    characterNeedsDecision(character, forBattle: forBattle)
                    return
                }
                println(">>>")
            } else {
                println(">>> Invalid input: '\(menuChoice)'")
                characterNeedsDecision(character, forBattle: forBattle)
                return
            }
        }
        
        println(">>> Attacking with \(attackToUse.name)")
        println(">>> Who to attack?")
        
        for (var k = 0; k < forBattle.battleQueue.count; ++k) {
            println(">>> \(k): \(forBattle.battleQueue[k].name)")
        }
        
        let victimChoice = input()
        if let tempVictimIndex = victimChoice.toInt() {
            victimIndex = tempVictimIndex
        } else {
            println(">>> Invalid input: '\(victimChoice)'")
            characterNeedsDecision(character, forBattle: forBattle)
            return
        }
        
        forBattle.characterPerformAction(character, targeting: forBattle.battleQueue[victimIndex], withAttack: attackToUse)
    }
    
}

class BattleDemo: BattleMonitor, CharacterMonitor, BattleDelegate {
    let intel = IntelDemo()
    
    let team1: Team
    
    let sonic: Character
    let twilight: Character
    let mewtwo: Character
    
    let team2: Team
    
    let battleBot: Character
    
    var battle: Battle?
    
    init() {
        self.sonic = Character(name: "Sonic", baseAttack: 5, baseDefense: 3, baseMagic: 2, baseSpeed: 7, baseAccuracy: 7, baseMaxHP: 50, baseMaxMP: 10, intelligence: self.intel)
        self.twilight = Character(name: "Twilight", baseAttack: 4, baseDefense: 7, baseMagic: 7, baseSpeed: 5, baseAccuracy: 5, baseMaxHP: 70, baseMaxMP: 30, intelligence: self.intel)
        self.mewtwo = Character(name: "Mewtwo", baseAttack: 4, baseDefense: 4, baseMagic: 8, baseSpeed: 4, baseAccuracy: 8, baseMaxHP: 50, baseMaxMP: 30, intelligence: self.intel)
        
        self.battleBot = Character(name: "Battle Bot", baseAttack: 4, baseDefense: 4, baseMagic: 4, baseSpeed: 3, baseAccuracy: 8, baseMaxHP: 50, baseMaxMP: 0, intelligence: DumbArtificialIntelligence())
        
        self.team1 = Team()
        team1.enroll(sonic)
        team1.enroll(twilight)
        team1.enroll(mewtwo)
        
        self.team2 = Team()
        team2.enroll(battleBot)
        
        sonic.defaultAttack = Attack(name: "Spindash", type: .Normal, power: 6, draw: 0, status: .Normal, isTeam: false)
        mewtwo.defaultAttack = Attack(name: "Concussion", type: .Normal, power: 5, draw: 0, status: .Normal, isTeam: false)
        battleBot.defaultAttack = Attack(name: "Punch", type: Type.Normal, power: 5, draw: 0, status: Status.Normal, isTeam: false)
        
        twilight.learn(Attack(name: "Fireworks", type: .LightMagic, power: 5, draw: 5, status: .Normal, isTeam: false))
        mewtwo.learn(Attack(name: "Aura Sphere", type: .DarkMagic, power: 7, draw: 5, status: .Normal, isTeam: false))
        
        let catalog = Attack(name: "Catalog", type: .LightMagic, power: 4, draw: 2, status: .Normal, isTeam: false)
        let purge = Attack(name: "451", type: .Fire, power: 4, draw: 5, status: .Normal, isTeam: true)
        let bookbag = Attack(name: "Book Bag", type: .Normal, power: 4, draw: 0, status: .Normal, isTeam: false)
        let overdue = Attack(name: "Overdue", type: .DarkMagic, power: 7, draw: 0, status: .Normal, isTeam: false)
        
        let jorb = Job(name: "Librarian", defaultAttack: bookbag, rushAttack: overdue, learnedSkills: [JobUnlockable(spRequired: 3, attack: catalog), JobUnlockable(spRequired: 5, attack: purge)])
        twilight.jobs.append(JobProgress(job: jorb, character: twilight, sp: 2))
        
        self.sonic.monitor = self
        self.twilight.monitor = self
        self.mewtwo.monitor = self
        
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
            self.twilight.spUp(5)
        } else {
            println("Oof! Go get yourselves cleaned up, heros!")
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
    
    func battle(sender: Battle, activeCharacter: Character, performedAttack: Attack, againstCharacter: Character, withResult: AttackResult) {
        println("# \(activeCharacter.name) attacked \(againstCharacter.name) with \(performedAttack.name)")
        
        if withResult.missed {
            println("# Attack missed!")
        } else {
            if withResult.critical {
                println("# Critical hit!")
            }
            if withResult.damage > 0 {
                println("# \(againstCharacter.name) took \(withResult.damage) damage.")
            } else {
                println("# No effect!")
            }
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
    
    func character(sender: Character, levelChangedTo: Int) {
        println("%% \(sender.name) grew to level \(levelChangedTo)")
    }
    
    func character(sender: Character, hpChangedBy: Int) {
        if hpChangedBy == 0 { return }
        
        var output = "%% \(sender.name) "
        
        if hpChangedBy > 0 {
            output += "gained \(hpChangedBy) HP"
        } else {
            output += "lost \(-1 * hpChangedBy) HP"
        }
        
        println("\(output): \(sender.hp)/\(sender.maxHP)")
    }
    
    func character(sender: Character, mpChangedBy: Int) {
        if mpChangedBy == 0 { return }
        
        var output = "%% \(sender.name) "
        
        if mpChangedBy > 0 {
            output += "gained \(mpChangedBy) MP"
        } else {
            output += "lost \(-1 * mpChangedBy) MP"
        }
        
        println(output)
    }
    
    func character(sender: Character, statusChangedTo: Status) {
        var output = "%% \(sender.name) "
        
        switch statusChangedTo {
        case .Normal: output += "is back to normal!"
        case .Poisoned: output += "is now poisoned."
        case .Sleep: output += "fell asleep"
        }
        
        println(output)
    }
    
    func character(sender: Character, learnedAttack: Attack) {
        println("%% \(sender.name) learned \(learnedAttack.name)")
    }
    
    func character(sender: Character, expChangedBy: Int) {
        println("%% \(sender.name) gained \(expChangedBy) EXP")
    }
}


println("Alright guys, time's up, let's do this thing.")

let demo = BattleDemo()
demo.go()
