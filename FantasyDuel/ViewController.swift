//
//  ViewController.swift
//  FantasyDuel
//
//  Created by William L. Marr III on 3/9/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import UIKit
import AVFoundation


// MARK: - ViewController class

class ViewController: UIViewController, UITextFieldDelegate {

    
    // MARK: - Outlets
    
    @IBOutlet weak var statusText: UILabel!
    @IBOutlet weak var playerNameLabel: UITextField!
    @IBOutlet weak var potionStackView: UIStackView!
    @IBOutlet weak var leftPlayerButton: UIButton!
    @IBOutlet weak var rightPlayerButton: UIButton!
    @IBOutlet weak var acceptNameButton: UIButton!
    @IBOutlet weak var leftPlayerAttackButton: UIButton!
    @IBOutlet weak var rightPlayerAttackButton: UIButton!
    @IBOutlet weak var leftParchment: UIImageView!
    @IBOutlet weak var leftStackViewStats: UIStackView!
    @IBOutlet weak var leftPlayerHPStat: UILabel!
    @IBOutlet weak var leftPlayerATKStat: UILabel!
    @IBOutlet weak var leftPlayerDEFStat: UILabel!
    @IBOutlet weak var leftPlayerPotion: UIButton!
    @IBOutlet weak var rightParchment: UIImageView!
    @IBOutlet weak var rightStackViewStats: UIStackView!
    @IBOutlet weak var rightPlayerHPStat: UILabel!
    @IBOutlet weak var rightPlayerATKStat: UILabel!
    @IBOutlet weak var rightPlayerDEFStat: UILabel!
    @IBOutlet weak var rightPlayerPotion: UIButton!
    
    // MARK: - Properties

    var gameController: GameController!

    // MARK: - Overrides
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        gameController = GameController(viewController: self)
        gameController.initializeGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Action methods
    
    @IBAction func leftPlayerButtonTapped(sender: AnyObject) {
    
        // The buttons representing the creatures is only
        // used for the player to make their creature selection.
        if gameController.gamePhase == .CharacterSelection {
            
            gameController.setPlayerCreatureType(CreatureType.Goblin)
            gameController.proceedToCharacterNamePhase()
        }
    }

    @IBAction func rightPlayerButtonTapped(sender: AnyObject) {

        // The buttons representing the creatures is only
        // used for the player to make their creature selection.
        if gameController.gamePhase == .CharacterSelection {
            
            gameController.setPlayerCreatureType(CreatureType.Human)
            gameController.proceedToCharacterNamePhase()
        }
    }

    @IBAction func acceptNameButtonTapped(sender: AnyObject) {
        if playerNameLabel.text != nil {
            gameController.setPlayerName()
            gameController.proceedToPotionSelectionPhase()
        }
    }
    
    @IBAction func healthPotionTapped(sender: AnyObject) {
        gameController.setPlayerPotionSelection(PotionType.Health)
        
        gameController.leftPlayerIsChoosingOptions = false
        
        // Players get to select a new potion in between rounds,
        // so, if this is still the first round, the players
        // are still in the player setup phase at the start
        // of a 3-round game.
        if !gameController.playerSetupComplete && gameController.roundNumber == 1 {
            
            if gameController.leftPlayerIsChoosingOptions == false {
                gameController.proceedToCharacterSelectionPhase()
            }
            
        } else {
            
            if gameController.rightPlayerPotionSelection == PotionType.None {
                gameController.proceedToPotionSelectionPhase()
            } else {
                gameController.proceedToAttackPhase()
            }
        }
    }
    
    @IBAction func armorPotionTapped(sender: AnyObject) {
        gameController.setPlayerPotionSelection(PotionType.Armor)

        gameController.leftPlayerIsChoosingOptions = false
        
        // Players get to select a new potion in between rounds,
        // so, if this is still the first round, the players
        // are still in the player setup phase at the start
        // of a 3-round game.
        if !gameController.playerSetupComplete && gameController.roundNumber == 1 {
            
            if gameController.leftPlayerIsChoosingOptions == false {
                gameController.proceedToCharacterSelectionPhase()
            }
            
        } else {
            
            if gameController.rightPlayerPotionSelection == PotionType.None {
                gameController.proceedToPotionSelectionPhase()
            } else {
                gameController.proceedToAttackPhase()
            }
        }
    }
    
    @IBAction func attackPotionTapped(sender: AnyObject) {
        gameController.setPlayerPotionSelection(PotionType.Attack)

        gameController.leftPlayerIsChoosingOptions = false
        
        // Players get to select a new potion in between rounds,
        // so, if this is still the first round, the players
        // are still in the player setup phase at the start
        // of a 3-round game.
        if !gameController.playerSetupComplete && gameController.roundNumber == 1 {
            
            if gameController.leftPlayerIsChoosingOptions == false {
                gameController.proceedToCharacterSelectionPhase()
            }
            
        } else {
            
            if gameController.rightPlayerPotionSelection == PotionType.None {
                gameController.proceedToPotionSelectionPhase()
            } else {
                gameController.proceedToAttackPhase()
            }
        }
    }
    
    @IBAction func leftPlayerAttackButtonTapped(sender: AnyObject) {
        leftPlayerAttackButton.hidden = true
        leftPlayerPotion.enabled = false
        
        if gameController.leftPlayer.isAttackSuccessfulAgainst(gameController.rightPlayer) {
            let damage = gameController.leftPlayer.attackPower - gameController.rightPlayer.armorRating
            let pointText = (damage == 1 ? "point" : "points")
            statusText.text = "\(gameController.leftPlayer.name) hit for \(damage) \(pointText)!"
            
            gameController.playHitOrMissSound("hit")
            gameController.updateRightPlayerStats()

        } else {
            statusText.text = "\(gameController.leftPlayer.name) missed!"

            gameController.playHitOrMissSound("miss")
        }

        if gameController.rightPlayer.isPlayerDefeated() {
            
            if gameController.rightPlayer.creatureType == CreatureType.Human {
                gameController.audioHumanDeath.play()
            } else {
                gameController.audioGoblinDeath.play()
            }
            
            rightPlayerButton.hidden = true
            
            gameController.playerRoundVictory()
        } else {
            gameController.enableRightPlayerAttack()
        }
    }
    
    @IBAction func rightPlayerAttackButtonTapped(sender: AnyObject) {
        rightPlayerAttackButton.hidden = true
        rightPlayerPotion.enabled = false

        if gameController.rightPlayer.isAttackSuccessfulAgainst(gameController.leftPlayer) {
            let damage = gameController.rightPlayer.attackPower - gameController.leftPlayer.armorRating
            let pointText = (damage == 1 ? "point" : "points")
            statusText.text = "\(gameController.rightPlayer.name) hit for \(damage) \(pointText)!"
            
            gameController.playHitOrMissSound("hit")
            gameController.updateLeftPlayerStats()
            
        } else {
            statusText.text = "\(gameController.rightPlayer.name) missed!"
            
            gameController.playHitOrMissSound("miss")
        }
        
        if gameController.leftPlayer.isPlayerDefeated() {

            if gameController.leftPlayer.creatureType == CreatureType.Human {
                gameController.audioHumanDeath.play()
            } else {
                gameController.audioGoblinDeath.play()
            }
            
            leftPlayerButton.hidden = true
            
            gameController.playerRoundVictory()
        } else {
            gameController.enableLeftPlayerAttack()
        }
    }
    
    @IBAction func leftPlayerPotionTapped(sender: AnyObject) {
        let potion: String
        switch gameController.leftPlayer.potion {
        case .None: potion = ""
        case .Health: potion = "a health"
        case .Attack: potion = "an attack"
        case .Armor: potion = "an armor"
        }
        
        if leftPlayerPotion != .None {
            statusText.text = "\(gameController.leftPlayer.name) drank \(potion) potion."
        }
        
        // You forfeit your attack if you use your potion.
        gameController.leftPlayer.usePotion()
        gameController.audioPotionEffect.play()
        leftPlayerAttackButton.hidden = true
        leftPlayerPotion.hidden = true
        gameController.updateLeftPlayerStats()
        gameController.enableRightPlayerAttack()
    }
    
    @IBAction func rightPlayerPotionTapped(sender: AnyObject) {
        let potion: String
        switch gameController.rightPlayer.potion {
        case .None: potion = ""
        case .Health: potion = "a health"
        case .Attack: potion = "an attack"
        case .Armor: potion = "an armor"
        }
        
        if rightPlayerPotion != .None {
            statusText.text = "\(gameController.rightPlayer.name) drank \(potion) potion."
        }
        
        // You forfeit your attack if you use your potion.
        gameController.rightPlayer.usePotion()
        gameController.audioPotionEffect.play()
        rightPlayerAttackButton.hidden = true
        rightPlayerPotion.hidden = true
        gameController.updateRightPlayerStats()
        gameController.enableLeftPlayerAttack()
    }
}

