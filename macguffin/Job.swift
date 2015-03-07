//
//  Job.swift
//  macguffin
//
//  Created by Evan Hildreth on 3/1/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

struct JobLevelData {
    let spRequired: Int
    let attack: Attack
}

class Job {
    let name: String
    let defaultAttack: Attack
    let rushAttack: Attack
    let learnedSkills: [JobLevelData]
    
    init(name: String, defaultAttack: Attack, rushAttack: Attack, learnedSkills: [JobLevelData]) {
        self.name = name
        self.defaultAttack = defaultAttack
        self.rushAttack = rushAttack
        self.learnedSkills = learnedSkills
    }
    
    
}

struct JobProgress {
    let job: Job
    var sp: Int = 0
    
    var complete: Bool {
        if let lastLevel = job.learnedSkills.last {
            return self.sp >= lastLevel.spRequired
        } else {
            return false
        }
    }
}