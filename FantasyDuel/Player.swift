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
    
    private var _name: String!
    private var _creatureType: CreatureType!
    private var _attackPower: Int!
    private var _armorRating: Int!
    private var _hitPoints = 50
    
    
    // MARK: Properties - public
    
    var name: String {
        get {
            return _name
        }
    }
    
    var creatureType: CreatureType {
        get {
            return _creatureType
        }
    }
    
    var attackPower: Int {
        get {
            return _attackPower
        }
    }
    
    var armorRating: Int {
        get {
            return _armorRating
        }
    }
    
    var hitPoints: Int {
        get {
            return _hitPoints
        }
    }
    
    
    // MARK: - Init
    
    init(name: String, creatureType: CreatureType) {
        _name = name
        _creatureType = creatureType
        _attackPower = getRandomAttackPower()
        _armorRating = getRandomArmorRating()
    }
    
    
    // MARK: - Methods - private
    
    private func getRandomAttackPower() -> Int {
        // Generate a random number from 6 - 10 for the base attack power once per game.
        var attackPower = 0
        
        while attackPower < 6 {
            attackPower = Int(arc4random_uniform(10) + 1)
        }
        
        var attackBonus = 0
        
        if self._creatureType == CreatureType.Goblin {
            attackBonus = 2
        }

        return attackPower + attackBonus
    }
    
    private func getRandomArmorRating() -> Int {
        // Generate a random number from 1 - 5 for the base armor rating once per game.
        // The armor rating is used to absorb damage; for example,
        // if the player is hit with 7 attack power, and their armor
        // rating is 3, then the player will only be damaged for 4 hit points.
        var armorBonus = 0
        
        if self._creatureType == CreatureType.Human {
            armorBonus = 3
        }
        
        return Int(arc4random_uniform(5) + 1) + armorBonus
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
}

