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
    let keyboard = FileHandle.withStandardInput
    let inputData = keyboard.availableData
    return NSString(data: inputData, encoding:String.Encoding.utf8)!.trimmingCharacters(in: CharacterSet(charactersIn: "\n"))
}

class IntelDemo: Intelligence {
    // From Intelligence
    
    func characterNeedsDecision(_ character: Character, forBattle: Battle) {
        var victimIndex: Int
        var attackToUse: Attack
        
        print(">>> \(character.name)'s turn")
        print(">>>")
        
        if character.specialAttacks.isEmpty {
            attackToUse = character.standardAttack
        } else {
            print(">>> What will \(character.name) do?")
            print(">>> 0: Attack")
            print(">>> 1: Special")
            
            let menuChoice = input()
            if let tempMenuIndex = Int(menuChoice) {
                switch tempMenuIndex {
                case 0:
                    attackToUse = character.standardAttack
                case 1:
                    print(">>> Which of \(character.name)'s attacks?")
                    for (k in 0 ..< character.specialAttacks.count += 1) {
                        print(">>> \(k): \(character.specialAttacks[k].name)")
                    }
                    
                    let attackChoice = input()
                    if let tempAttackIndex = Int(attackChoice) {
                        attackToUse = character.specialAttacks[tempAttackIndex]
                    } else {
                        print(">>> Invalid input: '\(attackChoice)'")
                        characterNeedsDecision(character, forBattle: forBattle)
                        return
                    }
                    
                default:
                    print(">>> Invalid input: '\(tempMenuIndex)'")
                    characterNeedsDecision(character, forBattle: forBattle)
                    return
                }
                print(">>>")
            } else {
                print(">>> Invalid input: '\(menuChoice)'")
                characterNeedsDecision(character, forBattle: forBattle)
                return
            }
        }
        
        print(">>> Attacking with \(attackToUse.name)")
        print(">>> Who to attack?")
        
        for (k in 0 ..< forBattle.battleQueue.count += 1) {
            print(">>> \(k): \(forBattle.battleQueue[k].name)")
        }
        
        let victimChoice = input()
        if let tempVictimIndex = Int(victimChoice) {
            victimIndex = tempVictimIndex
        } else {
            print(">>> Invalid input: '\(victimChoice)'")
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
        
        sonic.defaultAttack = Attack(name: "Spindash", type: .normal, power: 6, draw: 0, status: .normal, isTeam: false)
        mewtwo.defaultAttack = Attack(name: "Concussion", type: .normal, power: 5, draw: 0, status: .normal, isTeam: false)
        battleBot.defaultAttack = Attack(name: "Punch", type: Type.normal, power: 5, draw: 0, status: Status.normal, isTeam: false)
        
        twilight.learn(Attack(name: "Fireworks", type: .lightMagic, power: 5, draw: 5, status: .normal, isTeam: false))
        mewtwo.learn(Attack(name: "Aura Sphere", type: .darkMagic, power: 7, draw: 5, status: .normal, isTeam: false))
        
        let catalog = Attack(name: "Catalog", type: .lightMagic, power: 4, draw: 2, status: .normal, isTeam: false)
        let purge = Attack(name: "451", type: .fire, power: 4, draw: 5, status: .normal, isTeam: true)
        let bookbag = Attack(name: "Book Bag", type: .normal, power: 4, draw: 0, status: .normal, isTeam: false)
        let overdue = Attack(name: "Overdue", type: .darkMagic, power: 7, draw: 0, status: .normal, isTeam: false)
        
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
    
    func battleCompleted(_ sender: Battle, protagonistsWon: Bool) {
        if protagonistsWon {
            print("The chaos of friendship cannot be defeated!")
            self.twilight.spUp(5)
        } else {
            print("Oof! Go get yourselves cleaned up, heros!")
        }
        print("----------")
        print("Thank you for playing. Until next time!")
        exit(EXIT_SUCCESS)
    }
    
    func battleInvalidState(_ sender: Battle) {
        print("WTF battle just crashed?")
        exit(EXIT_FAILURE)
    }
    
    // From BattleMonitor
    
    func battleBegun(_ sender: Battle) {
        print("----------")
        print("New battle!")
        print("----------")
        
        for char in sender.proTeam.active {
            print("    " + char.name)
        }
        print("> VERSUS <")
        for char in sender.antTeam.active {
            print("    " + char.name)
        }
        print("----------")
    }
    
    func battle(_ sender: Battle, activeCharacter: Character, performedAttack: Attack, againstCharacter: Character, withResult: AttackResult) {
        print("# \(activeCharacter.name) attacked \(againstCharacter.name) with \(performedAttack.name)")
        
        if withResult.missed {
            print("# Attack missed!")
        } else {
            if withResult.critical {
                print("# Critical hit!")
            }
            if withResult.damage > 0 {
                print("# \(againstCharacter.name) took \(withResult.damage) damage.")
            } else {
                print("# No effect!")
            }
        }
    }
    
    func battle(_ sender: Battle, activeCharacter: Character, usedItem: Item, againstCharacter: Character, forDamage: Int?, forStatus: Status?) {
            print("# \(activeCharacter.name) used \(usedItem.name) on \(againstCharacter.name)")
            
            var anyEffect = false
            if let damage = forDamage {
                print("# \(againstCharacter.name) gained \(-1*damage) HP.")
                anyEffect = true
            }
            if let status = forStatus {
                print("# \(againstCharacter.name) status: \(status)")
                anyEffect = true
            }
            
            if !anyEffect {
                print("# No effect!")
            }
    }
    
    func battle(_ sender: Battle, characterDied: Character) {
        print("# " + characterDied.name + " fell.")
    }
    
    func battleEnded(_ sender: Battle) {
        print("----------")
        print("Battle completed!")
    }
    
    // From CharacterMonitor
    
    func character(_ sender: Character, levelChangedTo: Int) {
        print("%% \(sender.name) grew to level \(levelChangedTo)")
    }
    
    func character(_ sender: Character, hpChangedBy: Int) {
        if hpChangedBy == 0 { return }
        
        var output = "%% \(sender.name) "
        
        if hpChangedBy > 0 {
            output += "gained \(hpChangedBy) HP"
        } else {
            output += "lost \(-1 * hpChangedBy) HP"
        }
        
        print("\(output): \(sender.hp)/\(sender.maxHP)")
    }
    
    func character(_ sender: Character, mpChangedBy: Int) {
        if mpChangedBy == 0 { return }
        
        var output = "%% \(sender.name) "
        
        if mpChangedBy > 0 {
            output += "gained \(mpChangedBy) MP"
        } else {
            output += "lost \(-1 * mpChangedBy) MP"
        }
        
        print(output)
    }
    
    func character(_ sender: Character, statusChangedTo: Status) {
        var output = "%% \(sender.name) "
        
        switch statusChangedTo {
        case .normal: output += "is back to normal!"
        case .poisoned: output += "is now poisoned."
        case .sleep: output += "fell asleep"
        }
        
        print(output)
    }
    
    func character(_ sender: Character, learnedAttack: Attack) {
        print("%% \(sender.name) learned \(learnedAttack.name)")
    }
    
    func character(_ sender: Character, expChangedBy: Int) {
        print("%% \(sender.name) gained \(expChangedBy) EXP")
    }
}


print("Alright guys, time's up, let's do this thing.")

let demo = BattleDemo()
demo.go()
