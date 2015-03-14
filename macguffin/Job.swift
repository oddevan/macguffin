//
//  Job.swift
//  macguffin
//
//  Created by Evan Hildreth on 3/1/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

struct JobUnlockable {
    let spRequired: Int
    let attack: Attack
}

class Job {
    let name: String
    let defaultAttack: Attack
    let rushAttack: Attack
    let unlockables: [JobUnlockable]
    
    init(name: String, defaultAttack: Attack, rushAttack: Attack, learnedSkills: [JobUnlockable]) {
        self.name = name
        self.defaultAttack = defaultAttack
        self.rushAttack = rushAttack
        self.unlockables = learnedSkills
    }
    
    func teach(student: Character, oldSP: Int, newSP: Int) {
        let unlocked = self.unlockables.filter({ $0.spRequired > oldSP && $0.spRequired <= newSP })
        for unlockable in unlocked {
            student.learn(unlockable.attack)
        }
    }
}

struct JobProgress {
    let job: Job
    let character: Character
    var sp: Int = 0 {
        didSet {
            job.teach(character, oldSP: oldValue, newSP: sp)
        }
    }
    
    var complete: Bool {
        if let lastLevel = job.unlockables.last {
            return self.sp >= lastLevel.spRequired
        } else {
            return false
        }
    }
}