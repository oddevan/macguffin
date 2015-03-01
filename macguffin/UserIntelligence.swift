//
//  UserIntelligence.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/28/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

class CommandLineUserIntelligence: Intelligence {
    func characterNeedsDecision(character: Character, forBattle: Battle) {
        println("----------")
        println(character.name + " is up!")
        println("----------")
    }
}