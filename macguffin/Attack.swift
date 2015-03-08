//
//  Attack.swift
//  macguffin
//
//  Created by Evan Hildreth on 2/5/15.
//  Copyright (c) 2015 Evan Hildreth. All rights reserved.
//

//import Foundation

class Attack {
    let name: String
    let type: Type
    let power: Int
    let draw: Int
    let status: Status
    let isTeam: Bool
    
    init(name: String, type: Type, power: Int, draw: Int, status: Status, isTeam: Bool) {
        self.name = name
        self.type = type
        self.power = power
        self.draw = draw
        self.status = status
        self.isTeam = isTeam
    }
    
    func perform(attacker:Character, victim:Character) {
        victim.hp -= attacker.atk * self.power / victim.def
    }
}

/*
attacking->MPDown(attack.Draw);
if (attack.IsTeam) return NormalTeam(attacking, defending->Team(), battle, attack);

double hitProb = double(attacking->Acc()) / double(defending->Spd());
if (DGRandomDouble() >= hitProb)
{
cout << "Attack missed!" << endl;
return 0;
}

int atkPow, defPow, totDamage, hpBefore;
bool isNegDamage;

atkPow = attacking->Level() * attacking->NormalAtkPow(attack.Type, attack.Pow);
defPow = defending->DefPow(attack.Type);
hpBefore = defending->HP();

if (atkPow > 0)
{
isNegDamage = (defPow < 0);
if (DGRandomDouble() <= CHANCE_OF_CRIT_HIT)
{
defPow = 0;
cout << "Critical hit!" << endl;
}
totDamage = atkPow - defPow;
if (isNegDamage)
{
defending->HPUp(totDamage);
cout << defending->Name() << " gained " << (defending->HP() - hpBefore) << " HP." << endl;
}
else
{
defending->HPDown(totDamage);
cout << defending->Name() << " took " << (hpBefore - defending->HP()) << " damage." << endl;
}
}

if (attack.Status != 'n')
{
if (DGRandomDouble() <= CHANCE_OF_STAT_CHANGE)
{
defending->ChangeStatus(attack.Status);
switch (attack.Status)
{
case 'p':
cout << defending->Name() << " was poisoned." << endl;
break;
case 's':
cout << defending->Name() << " fell asleep." << endl;
break;
default:
break;
}
}
}
return (hpBefore - defending->HP());
*/