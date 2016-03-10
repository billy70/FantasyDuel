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
    @IBOutlet weak var leftPlayerButton: UIButton!
    @IBOutlet weak var rightPlayerButton: UIButton!
    @IBOutlet weak var acceptNameButton: UIButton!
    @IBOutlet weak var leftPlayerAttackButton: UIButton!
    @IBOutlet weak var rightPlayerAttackButton: UIButton!
    
    
    // MARK: - Properties
    
    var playerOne: Player!
    var playerOneDidSelectCharacter = false
    var playerOneCreatureType: CreatureType!
    var playerOneDidEnterName = false
    var playerOneName = ""
    var playerOneDidSelectPotion = false
    var playerOnePotionSelection: PotionType!

    var playerTwo: Player!
    var playerTwoDidSelectCharacter = false
    var playerTwoCreatureType: CreatureType!
    var playerTwoDidEnterName = false
    var playerTwoName = ""
    var playerTwoDidSelectPotion = false
    var playerTwoPotionSelection: PotionType!
    
    var gamePhase: GamePhase = .CharacterSelection
    var firstPersonIsChoosingOptions = true
    

    // MARK: - Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        statusText.text = "Select a creature type:"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Action methods
    
    @IBAction func leftPlayerButtonTapped(sender: AnyObject) {
    
        // The buttons representing the creatures is only
        // used for the player to make their creature selection.
        if gamePhase == .CharacterSelection {
            
            setPlayerCreatureType(CreatureType.Goblin)
            proceedToCharacterNamePhase()
        }
    }

    @IBAction func rightPlayerButtonTapped(sender: AnyObject) {

        // The buttons representing the creatures is only
        // used for the player to make their creature selection.
        if gamePhase == .CharacterSelection {
            
            setPlayerCreatureType(CreatureType.Human)
            proceedToCharacterNamePhase()
        }
    }

    @IBAction func acceptNameButtonTapped(sender: AnyObject) {
        if playerNameLabel.text != nil {
            setPlayerName()
            proceedToPotionSelectionPhase()
        }
    }
    
    @IBAction func healthPotionTapped(sender: AnyObject) {
        setPlayerPotionSelection(PotionType.Health)
        proceedToCharacterSelectionPhase()
    }
    
    @IBAction func armorPotionTapped(sender: AnyObject) {
        setPlayerPotionSelection(PotionType.Armor)
        proceedToCharacterSelectionPhase()
    }
    
    @IBAction func attackPotionTapped(sender: AnyObject) {
        setPlayerPotionSelection(PotionType.Attack)
        proceedToCharacterSelectionPhase()
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
    
    func setPlayerName() {
        if firstPersonIsChoosingOptions {
            
            playerOneDidEnterName = true
            playerOneName = playerNameLabel.text ?? "Player 1"

        } else {
            
            playerTwoDidEnterName = true
            playerTwoName = playerNameLabel.text ?? "Player 2"
        }
    }
    
    func setPlayerPotionSelection(potion: PotionType) {
        if firstPersonIsChoosingOptions {
            
            playerOneDidSelectPotion = true
            playerOnePotionSelection = potion
            
        } else {
            
            playerTwoDidSelectPotion = true
            playerTwoPotionSelection = potion
        }
    }
    
    func proceedToCharacterSelectionPhase() {
        gamePhase = .CharacterSelection
        statusText.text = "Select a creature type:"
        potionStackView.hidden = true
        leftPlayerButton.hidden = false
        rightPlayerButton.hidden = false
    }
    
    func proceedToCharacterNamePhase() {
        gamePhase == .CharacterName
        statusText.text = "Enter your name:"
        leftPlayerButton.hidden = true
        rightPlayerButton.hidden = true
        playerNameLabel.hidden = false
        acceptNameButton.hidden = false
    }
    
    func proceedToPotionSelectionPhase() {
        gamePhase == .PotionSelection
        statusText.text = "Select a potion:"
        playerNameLabel.hidden = true
        acceptNameButton.hidden = true
        potionStackView.hidden = false
    }
}

