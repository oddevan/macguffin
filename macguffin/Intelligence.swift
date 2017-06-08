//
//  Intelligence.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/28/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

protocol Intelligence {
    func characterNeedsDecision(_ character: Character, forBattle: Battle)
}
