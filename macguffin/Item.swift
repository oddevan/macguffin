//
//  Item.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

class Item {
    let name:String
    
    init(name:String) {
        self.name = name
    }
    
    func use(target:Character) -> Bool {
        return false
    }
}