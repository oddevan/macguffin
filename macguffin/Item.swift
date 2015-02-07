//
//  Item.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

enum ItemAffectedStat {
    case Attack
    case Defense
    case Magic
    case Accuracy
    case Speed
    case HP
    case MP
    case Status
}

class Item {
    let name: String
    
    let affectedStat: ItemAffectedStat
    let amountAffected: Int
    
    init(name: String, affectedStat: ItemAffectedStat, amountAffected: Int) {
        self.name = name
        self.affectedStat = affectedStat
        self.amountAffected = amountAffected
    }
    
    func use(target:Character) -> Bool {
        switch self.affectedStat {
            
        case .HP where target.hp != target.maxHP :
            target.hp += amountAffected;
            return true
            
        case .MP where target.mp != target.maxMP :
            target.mp += amountAffected;
            return true
            
        case .Status where target.status != Status.Normal :
            if let futureStatus = Status(rawValue: amountAffected) {
                target.status = futureStatus
                return true
            } else {
                println("ERROR: Item.amountAffected does not correspond to known Status")
                println(self)
                println("--------")
            }
            
        default :
            return false
        }
        
        return false
    }
}