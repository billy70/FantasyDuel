//
//  Player.swift
//  FantasyDuel
//
//  Created by William L. Marr III on 3/9/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation


// MARK: - Player class
//
// The player's attack power and armor rating are generated randomly
// at the start of each game, where the attack power will be in the
// range of 6 through 10, and the armor rating will be 1 through 5.
// Note that the generator methods are private to this class.
//
class Player {

    // MARK: - Properties - private
    
    private var _name = "Player"
    private var _creatureType: CreatureType = .Human
    private var _attackPower = 2
    private var _armorRating = 1
    private var _hitPoints = 50
    private var _potion: PotionType = .None
    
    
    // MARK: Properties - public
    
    var name: String {
        get {
            return _name
        }
        set {
            self._name = name
        }
    }
    
    var creatureType: CreatureType {
        get {
            return _creatureType
        }
        set {
            self._creatureType = creatureType
        }
    }
    
    var attackPower: Int {
        get {
            return _attackPower
        }
        set(newAttackPower) {
            // Attack power can only be mutated externally
            // by using an attack power potion, never directly!
            if potion == .Attack {
               _attackPower = newAttackPower
            }
        }
    }
    
    var armorRating: Int {
        get {
            return _armorRating
        }
        set (newArmorRating) {
            // Armor rating can only be mutated externally
            // by using an armor rating potion, never directly!
            if potion == .Armor {
                _armorRating = newArmorRating
            }
        }
    }
    
    var hitPoints: Int {
        get {
            return _hitPoints
        }
        set (newHitPoints) {
            // Hit points can only be mutated externally
            // by using a health potion, never directly!
            if potion == .Health {
                _hitPoints = newHitPoints
            }
        }
    }
    
    var potion: PotionType {
        get {
            return _potion
        }
    }
    
    
    // MARK: - Init
    
    init(name: String, creatureType: CreatureType, potion: PotionType) {
        _name = name
        _creatureType = creatureType
        _attackPower = getRandomAttackPower()
        _armorRating = getRandomArmorRating()
        _potion = potion
    }
    
    
    // MARK: - Methods - private
    
    private func getRandomAttackPower() -> Int {
        var attackPower = 0
        var attackBonus = 0

        // The goblin's attack power ranges from 13-17,
        // with a creature type bonus of 6; therefore,
        // goblins ultimately have an attack range of 19-23.
        if self._creatureType == CreatureType.Goblin {

            while attackPower < 13 {
                attackPower = Int(arc4random_uniform(17)) + 1
            }
        
            attackBonus = 6
        }
        
        // The human's attack power ranges from 16-19,
        // but does not get an attack bonus; therefore,
        // humans ultimately have an attack range of 16-19.
        if self._creatureType == CreatureType.Human {
            
            while attackPower < 16 {
                attackPower = Int(arc4random_uniform(19)) + 1
            }
        }

        return attackPower + attackBonus
    }
    
    private func getRandomArmorRating() -> Int {
        // The armor rating is used to absorb damage; for example,
        // if the player is hit with 18 attack power, and their armor
        // rating is 12, then the player will only be damaged for 6 hit points.
        var armorRating = 0
        var armorBonus = 0
        
        // The human's armor rating ranges from 1-6,
        // with a creature type bonus of 6; therfore,
        // humans ultimately have an armor rating of 7-12.
        if self._creatureType == CreatureType.Human {

            while armorRating < 1 {
                armorRating = Int(arc4random_uniform(6)) + 1
            }
            
            armorBonus = 6
        }
        
        // The goblin's armor rating ranges from 3-7,
        // but does not get an armor rating bonus; therefore,
        // goblins ultimately have an armor rating of 3-7.
        if self._creatureType == CreatureType.Goblin {
            
            while armorRating < 3 {
                armorRating = Int(arc4random_uniform(7)) + 1
            }
        }
        
        return armorRating + armorBonus
    }
    
    private func takeDamage(attackPower: Int) {
        
        // Make sure attack power is actually greater that the armor rating
        // so that the damage amount is always a non-negative value.
        if attackPower > self._armorRating {
            let damage = attackPower - self._armorRating
            self._hitPoints -= damage
        }
    }
    
    
    // MARK: Methods - public
    
    func isPlayerDefeated() -> Bool {

        if _hitPoints <= 0 {
            return true
        }
        
        return false
    }
    
    func isAttackSuccessfulAgainst(defender: Player) -> Bool {
        
        // Make sure an object cannot attack itself.
        if self === defender {
            return false
        }
        
        // The attack should hit most of the time, but there
        // is a one in six chance that the attack will miss;
        // simulate a six-sided die roll, where a result of
        // one is a miss.
        let chance = Int(arc4random_uniform(6) + 1)
        if chance == 1 {
            return false
        }

        if self._attackPower > defender.armorRating {
            defender.takeDamage(self._attackPower)
            return true
        }
        
        return false
    }
    
    func usePotion() {
        switch potion {
        case .None:
            break
        case .Health:
            hitPoints += 15
        case .Armor:
            armorRating += 3
        case .Attack:
            attackPower += 3
        }
        
        // The player no longer has a potion to use.
        _potion = .None
    }
}

