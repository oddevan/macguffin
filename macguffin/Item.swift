//
//  Item.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

enum ItemAffectedStat {
    case attack
    case defense
    case magic
    case accuracy
    case speed
    case hp
    case mp
    case status
}

struct ItemQuantity {
    let item: Item
    var quantity: Int
    
    init(item: Item) {
        self.item = item
        self.quantity = 0
    }
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
    
    func use(_ target:Character) -> Bool {
        switch self.affectedStat {
            
        case .hp where target.hp != target.maxHP :
            target.hp += amountAffected;
            return true
            
        case .mp where target.mp != target.maxMP :
            target.mp += amountAffected;
            return true
            
        case .status where target.status != Status.normal :
            if let futureStatus = Status(rawValue: amountAffected) {
                target.status = futureStatus
                return true
            } else {
                print("ERROR: Item.amountAffected does not correspond to known Status")
                print(self)
                print("--------")
            }
            
        default :
            return false
        }
        
        return false
    }
}
