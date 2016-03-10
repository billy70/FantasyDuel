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
    var playerOneCreatureType: CreatureType!
    var playerOneName = ""
    var playerOnePotionSelection: PotionType!

    var playerTwo: Player!
    var playerTwoCreatureType: CreatureType!
    var playerTwoName = ""
    var playerTwoPotionSelection: PotionType!
    
    var gamePhase: GamePhase = .CharacterSelection
    var firstPersonIsChoosingOptions = true
    var playerSetupComplete = false
    var whichPlayerIsFirst = 1
    

    // MARK: - Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        initializeGame()
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
        leftPlayerAttackButton.enabled = false
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "enableRightPlayerAttack", userInfo: nil, repeats: false)
        
        if playerOne.isAttackSuccessfulAgainst(playerTwo) {
            statusText.text = "\(playerOne.name) hit \(playerTwo.name)!"
        } else {
            statusText.text = "\(playerOne.name) missed!"
        }

        if playerTwo.isPlayerDefeated() {
            playerVictory()
        }
    }
    
    @IBAction func rightPlayerAttackButtonTapped(sender: AnyObject) {
        rightPlayerAttackButton.enabled = false
        NSTimer.scheduledTimerWithTimeInterval(1.5, target: self, selector: "enableLeftPlayerAttack", userInfo: nil, repeats: false)

        if playerTwo.isAttackSuccessfulAgainst(playerOne) {
            statusText.text = "\(playerTwo.name) hit \(playerOne.name)!"
        } else {
            statusText.text = "\(playerTwo.name) missed!"
        }
        
        if playerOne.isPlayerDefeated() {
            playerVictory()
        }
    }
    
    
    // MARK: - Methods
    
    func initializeGame() {
        statusText.text = "Select a creature type:"
        playerNameLabel.text = ""
        playerNameLabel.hidden = true
        potionStackView.hidden = true
        leftPlayerButton.hidden = false
        rightPlayerButton.hidden = false
        acceptNameButton.hidden = true
        leftPlayerAttackButton.hidden = true
        rightPlayerAttackButton.hidden = true
        playerSetupComplete = false
        firstPersonIsChoosingOptions = true
        
        whichPlayerIsFirst = Int(arc4random_uniform(2)) + 1
        
        if whichPlayerIsFirst == 1 {
            leftPlayerAttackButton.enabled = false
        } else {
            rightPlayerAttackButton.enabled = false
        }
    }
    
    func initializePlayers() {
        playerOne = Player(name: playerOneName, creatureType: playerOneCreatureType, potion: playerOnePotionSelection)
        playerTwo = Player(name: playerTwoName, creatureType: playerTwoCreatureType, potion: playerTwoPotionSelection)
    }
    
    func initializeAttackRound() {
        leftPlayerAttackButton.hidden = false
        leftPlayerButton.hidden = false
        rightPlayerAttackButton.hidden = false
        rightPlayerButton.hidden = false
    }
    
    func setPlayerCreatureType(type: CreatureType) {
        if firstPersonIsChoosingOptions {
            
            playerOneCreatureType = type
            
        } else {
            
            playerTwoCreatureType = type
        }
    }
    
    func setPlayerName() {
        if firstPersonIsChoosingOptions {
            
            playerOneName = playerNameLabel.text ?? "Player 1"

        } else {
            
            playerTwoName = playerNameLabel.text ?? "Player 2"
        }
        
        playerNameLabel.text = ""
    }
    
    func setPlayerPotionSelection(potion: PotionType) {
        if firstPersonIsChoosingOptions {
            
            playerOnePotionSelection = potion
            firstPersonIsChoosingOptions = false
            
        } else {
            
            playerTwoPotionSelection = potion
            playerSetupComplete = true
        }
    }
    
    func proceedToCharacterSelectionPhase() {
        
        if !playerSetupComplete {
            
            gamePhase = .CharacterSelection
            statusText.text = "Select a creature type:"
            potionStackView.hidden = true
            leftPlayerButton.hidden = false
            rightPlayerButton.hidden = false
            
        } else {
            
            proceedToAttackPhase()

        }
    }
    
    func proceedToCharacterNamePhase() {
        gamePhase = .CharacterName
        statusText.text = "Enter your name:"
        leftPlayerButton.hidden = true
        rightPlayerButton.hidden = true
        playerNameLabel.hidden = false
        acceptNameButton.hidden = false
    }
    
    func proceedToPotionSelectionPhase() {
        gamePhase = .PotionSelection
        statusText.text = "Select a potion:"
        playerNameLabel.hidden = true
        acceptNameButton.hidden = true
        potionStackView.hidden = false
    }
    
    func proceedToAttackPhase() {
        
        gamePhase = .AttackRound
        statusText.text = "Attack!"
        potionStackView.hidden = true
        initializePlayers()
        initializeAttackRound()
    }
    
    func enableLeftPlayerAttack() {
        leftPlayerAttackButton.enabled = true
    }
    
    func enableRightPlayerAttack() {
        rightPlayerAttackButton.enabled = true
    }
    
    func playerVictory() {
        NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "setupVictory", userInfo: nil, repeats: false)
    }
    
    func setupVictory() {
        if playerOne.isPlayerDefeated() {
            statusText.text = "\(playerTwo.name) is Victorious!"
        } else {
            statusText.text = "\(playerOne.name) is Victorious!"
        }

        NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "initializeGame", userInfo: nil, repeats: false)
    }
}

