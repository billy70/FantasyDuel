//
//  ViewController.swift
//  FantasyDuel
//
//  Created by William L. Marr III on 3/9/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit

// MARK: - Game phases enumeration

enum GamePhase {
    case CharacterSelection
    case CharacterName
    case PotionSelection
    case AttackRound
    case Victory
}


// MARK: - ViewController class

class ViewController: UIViewController {

    
    // MARK: - Outlets
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var playerNameLabel: UITextField!
    @IBOutlet weak var potionStackView: UIStackView!
    @IBOutlet weak var playerOneButton: UIButton!
    @IBOutlet weak var playerTwoButton: UIButton!
    @IBOutlet weak var acceptNameButton: UIButton!
    @IBOutlet weak var leftPlayerAttackButton: UIButton!
    @IBOutlet weak var rightPlayerAttackButton: UIButton!
    
    
    // MARK: - Properties
    
    var playerOne: Player!
    var playerOneDidSelectCharacter = false
    var playerOneCreatureType: CreatureType!
    var playerOneDidEnterName = false
    var playerOneDidSelectPotion = false

    var playerTwo: Player!
    var playerTwoDidSelectCharacter = false
    var playerTwoCreatureType: CreatureType!
    var playerTwoDidEnterName = false
    var playerTwoDidSelectPotion = false
    
    var gamePhase: GamePhase = .CharacterSelection
    var firstPersonIsChoosingOptions = true
    

    // MARK: - Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        statusText.text = "Player 1 - select a creature:"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Action methods
    
    @IBAction func playerOneButtonTapped(sender: AnyObject) {
        
        if gamePhase == .CharacterSelection {
            
            setPlayerCreatureType(CreatureType.Goblin)
            proceedToCharacterNamePhase()

        } else if gamePhase == .AttackRound {
            
            
        }
    }

    @IBAction func playerTwoButtonTapped(sender: AnyObject) {

        if gamePhase == .CharacterSelection {
            
            setPlayerCreatureType(CreatureType.Human)
            proceedToCharacterNamePhase()

        } else if gamePhase == .AttackRound {
            
            
        }
    }

    @IBAction func acceptNameButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func healthPotionTapped(sender: AnyObject) {
    }
    
    @IBAction func armorPotionTapped(sender: AnyObject) {
    }
    
    @IBAction func attackPotionTapped(sender: AnyObject) {
    }
    
    @IBAction func leftPlayerAttackButtonTapped(sender: AnyObject) {
    }
    
    @IBAction func rightPlayerAttackButtonTapped(sender: AnyObject) {
    }
    
    
    // MARK: - Methods
    
    func setPlayerCreatureType(type: CreatureType) {
        
        if firstPersonIsChoosingOptions {
            
            playerOneDidSelectCharacter = true
            playerOneCreatureType = type
            
        } else {
            
            playerTwoDidSelectCharacter = true
            playerTwoCreatureType = type
        }
    }
    
    func proceedToCharacterNamePhase() {
        gamePhase == .CharacterName
        playerOneButton.hidden = true
        playerTwoButton.hidden = true
        playerNameLabel.hidden = false
        acceptNameButton.hidden = false
    }
}

