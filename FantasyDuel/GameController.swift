//
//  GameController.swift
//  FantasyDuel
//
//  Created by William L. Marr III on 3/16/16.
//  Copyright © 2016 William L. Marr III. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

// MARK: - Game phases enumeration

enum GamePhase {
    case CharacterSelection
    case CharacterName
    case PotionSelection
    case AttackRound
    case Victory
}


// MARK: - GameController class

class GameController: NSObject {
    
    // MARK: - Properties
    
    var viewController: ViewController!
    
    var leftPlayer: Player!
    var leftPlayerCreatureType: CreatureType!
    var leftPlayerName = "Left player"
    var leftPlayerPotionSelection: PotionType!
    var leftPlayerRoundsWon = 0
    
    var rightPlayer: Player!
    var rightPlayerCreatureType: CreatureType!
    var rightPlayerName = "Right player"
    var rightPlayerPotionSelection: PotionType!
    var rightPlayerRoundsWon = 0
    
    var gamePhase: GamePhase = .CharacterSelection
    var leftPlayerIsChoosingOptions = true
    var playerSetupComplete = false
    var whichPlayerHasInitiative = "left"
    var roundNumber = 1
    
    var audioBattleMusic: AVAudioPlayer!
    var audioFanfare: AVAudioPlayer!
    var audioFight: AVAudioPlayer!
    var audioGoblinDeath: AVAudioPlayer!
    var audioHumanDeath: AVAudioPlayer!
    var audioPlayerSetupMusic: AVAudioPlayer!
    var audioPotionEffect: AVAudioPlayer!
    var audioSwordAttack: AVAudioPlayer!
    var audioAttackMissed: AVAudioPlayer!
    var audioVictoryCry: AVAudioPlayer!
    
    var audioDictionary: [String: String] = [
        "audioBattleMusic": "snd_duels_music",
        "audioFanfare": "snd_fanfare",
        "audioFight": "snd_fight",
        "audioGoblinDeath": "snd_goblin_death",
        "audioHumanDeath": "snd_human_death",
        "audioPlayerSetupMusic": "snd_player_setup",
        "audioPotionEffect": "snd_potion-effect",
        "audioSwordAttack": "snd_sword_attack",
        "audioAttackMissed": "snd_missed",
        "audioVictoryCry": "snd_victory_cry"
    ]
    
    
    // MARK: - Methods
    
    init(viewController: ViewController) {
        self.viewController = viewController
        
    }
    
    func initializeGame() {
        gamePhase = .CharacterSelection
        
        viewController.playerNameLabel.delegate = viewController
        viewController.statusText.text = "Left player - Select a creature type:"
        viewController.playerNameLabel.text = ""
        viewController.playerNameLabel.hidden = true
        viewController.potionStackView.hidden = true
        viewController.leftPlayerButton.hidden = false
        viewController.rightPlayerButton.hidden = false
        viewController.acceptNameButton.hidden = true
        viewController.leftPlayerAttackButton.hidden = true
        viewController.rightPlayerAttackButton.hidden = true
        viewController.leftStackViewStats.hidden = true
        viewController.leftParchment.hidden = true
        viewController.rightStackViewStats.hidden = true
        viewController.rightParchment.hidden = true
        viewController.leftPlayerButton.setImage(UIImage(named: "goblin.png"), forState: UIControlState.Normal)
        viewController.rightPlayerButton.setImage(UIImage(named: "human.png"), forState: UIControlState.Normal)
        
        playerSetupComplete = false
        leftPlayerIsChoosingOptions = true
        leftPlayerRoundsWon = 0
        rightPlayerRoundsWon = 0
        roundNumber = 1
        
        whichPlayerHasInitiative = determineInitiative()
        
        setupAudioPlayers()
        
        // Loop the "setup background" music indefinitely until explicitly stopped.
        audioPlayerSetupMusic.numberOfLoops = -1
        audioPlayerSetupMusic.play()
    }
    
    func determineInitiative() -> String {
        let random = Int(arc4random_uniform(2)) + 1
        
        if random == 1 {
            return "left"
        } else {
            return "right"
        }
    }
    
    func setupAudioPlayers() {
        
        for (player, file) in audioDictionary {
            
            let path = NSBundle.mainBundle().pathForResource(file, ofType: ".wav")
            let soundURL = NSURL(fileURLWithPath: path!)
            
            do {
                
                let sound = try AVAudioPlayer(contentsOfURL: soundURL)
                sound.prepareToPlay()
                
                switch player {
                case "audioBattleMusic": audioBattleMusic = sound
                case "audioFanfare": audioFanfare = sound
                case "audioFight": audioFight = sound
                case "audioGoblinDeath": audioGoblinDeath = sound
                case "audioHumanDeath": audioHumanDeath = sound
                case "audioPlayerSetupMusic": audioPlayerSetupMusic = sound
                case "audioPotionEffect": audioPotionEffect = sound
                case "audioSwordAttack": audioSwordAttack = sound
                case "audioAttackMissed": audioAttackMissed = sound
                case "audioVictoryCry": audioVictoryCry = sound
                default: break
                }
                
            } catch let error as NSError {
                print(error.debugDescription)
            }
        }
    }
    
    func textFieldShouldReturn(userText: UITextField) -> Bool {
        userText.resignFirstResponder()
        return true;
    }
    
    func initializePlayers() {
        var potion: String
        var creatureName: String
        var creatureImage: UIImage
        
        // Setup the left player.
        leftPlayer = Player(name: leftPlayerName, creatureType: leftPlayerCreatureType, potion: leftPlayerPotionSelection)
        
        switch leftPlayer.potion {
        case .None: potion = ""
        case .Health: potion = "potion_health.png"
        case .Attack: potion = "potion_attack.png"
        case .Armor: potion = "potion_armor.png"
        }
        
        updateLeftPlayerStats()
        
        if viewController.leftPlayerPotion == .None {
            viewController.leftPlayerPotion.hidden = true
        } else {
            viewController.leftPlayerPotion.setImage(UIImage(named: potion), forState: UIControlState.Normal)
        }
        
        switch leftPlayerCreatureType! {
        case CreatureType.Human: creatureName = "human.png"
        case CreatureType.Goblin: creatureName = "goblin.png"
        }
        
        creatureImage = UIImage(named: creatureName)!
        if leftPlayerCreatureType! == CreatureType.Human {
            creatureImage = UIImage(CGImage: creatureImage.CGImage!, scale: creatureImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
        
        viewController.leftPlayerButton.setImage(creatureImage, forState: UIControlState.Normal)
        
        
        // Setup the right player.
        rightPlayer = Player(name: rightPlayerName, creatureType: rightPlayerCreatureType, potion: rightPlayerPotionSelection)
        
        switch rightPlayer.potion {
        case .None: potion = ""
        case .Health: potion = "potion_health.png"
        case .Attack: potion = "potion_attack.png"
        case .Armor: potion = "potion_armor.png"
        }
        
        updateRightPlayerStats()
        
        if viewController.rightPlayerPotion == .None {
            viewController.rightPlayerPotion.hidden = true
        } else {
            viewController.rightPlayerPotion.setImage(UIImage(named: potion), forState: UIControlState.Normal)
        }
        
        switch rightPlayerCreatureType! {
        case CreatureType.Human: creatureName = "human.png"
        case CreatureType.Goblin: creatureName = "goblin.png"
        }
        
        creatureImage = UIImage(named: creatureName)!
        if rightPlayerCreatureType! == CreatureType.Goblin {
            creatureImage = UIImage(CGImage: creatureImage.CGImage!, scale: creatureImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
        
        viewController.rightPlayerButton.setImage(creatureImage, forState: UIControlState.Normal)
    }
    
    func playHitOrMissSound(attack: String) {
        if attack == "hit" {
            
            if audioSwordAttack.playing {
                audioSwordAttack.stop()
                audioSwordAttack.prepareToPlay()
            }
            audioSwordAttack.play()
            
        } else {
            
            if audioAttackMissed.playing {
                audioAttackMissed.stop()
                audioAttackMissed.prepareToPlay()
            }
            audioAttackMissed.play()
        }
    }
    
    func initializeAttackRound() {
        
        viewController.leftParchment.hidden = false
        viewController.leftPlayerPotion.hidden = false
        viewController.leftStackViewStats.hidden = false
        
        viewController.rightParchment.hidden = false
        viewController.rightPlayerPotion.hidden = false
        viewController.rightStackViewStats.hidden = false
        
        if whichPlayerHasInitiative == "left" {
            viewController.leftPlayerAttackButton.hidden = false
            viewController.leftPlayerPotion.enabled = true
            viewController.rightPlayerPotion.enabled = false
        } else {
            viewController.rightPlayerAttackButton.hidden = false
            viewController.rightPlayerPotion.enabled = true
            viewController.leftPlayerPotion.enabled = false
        }
        
        viewController.statusText.text = "Round \(roundNumber): FIGHT!"
        audioFight.play()
    }
    
    func setPlayerCreatureType(type: CreatureType) {
        if leftPlayerIsChoosingOptions {
            
            leftPlayerCreatureType = type
            
        } else {
            
            rightPlayerCreatureType = type
        }
    }
    
    func setPlayerName() {
        if leftPlayerIsChoosingOptions {
            
            leftPlayerName = viewController.playerNameLabel.text ?? "Left"
            
        } else {
            
            rightPlayerName = viewController.playerNameLabel.text ?? "Right"
        }
        
        viewController.playerNameLabel.text = ""
    }
    
    func setPlayerPotionSelection(potion: PotionType) {
        audioPotionEffect.play()
        
        if leftPlayerIsChoosingOptions {
            
            leftPlayerPotionSelection = potion
            //            leftPlayerIsChoosingOptions = false
            
        } else {
            
            rightPlayerPotionSelection = potion
            playerSetupComplete = true
        }
    }
    
    func proceedToCharacterSelectionPhase() {
        
        if playerSetupComplete {
            
            proceedToAttackPhase()
            
        } else {
            
            gamePhase = .CharacterSelection
            
            if leftPlayerIsChoosingOptions {
                viewController.statusText.text = "Left player - Select a creature type:"
            } else {
                viewController.statusText.text = "Right player - Select a creature type:"
            }
            
            viewController.potionStackView.hidden = true
            viewController.leftPlayerButton.hidden = false
            viewController.rightPlayerButton.hidden = false
            
        }
    }
    
    func proceedToCharacterNamePhase() {
        gamePhase = .CharacterName
        
        viewController.statusText.text = "Enter your name:"
        viewController.leftPlayerButton.hidden = true
        viewController.rightPlayerButton.hidden = true
        viewController.playerNameLabel.hidden = false
        viewController.acceptNameButton.hidden = false
    }
    
    func proceedToPotionSelectionPhase() {
        gamePhase = .PotionSelection
        
        if leftPlayerIsChoosingOptions {
            viewController.statusText.text = "Select a potion, \(leftPlayerName):"
        } else {
            viewController.statusText.text = "Select a potion, \(rightPlayerName):"
            playerSetupComplete = true
        }
        
        viewController.playerNameLabel.hidden = true
        viewController.acceptNameButton.hidden = true
        viewController.potionStackView.hidden = false
    }
    
    func proceedToAttackPhase() {
        gamePhase = .AttackRound
        
        if audioPlayerSetupMusic.playing {
            audioPlayerSetupMusic.stop()
        }
        
        viewController.potionStackView.hidden = true
        viewController.leftPlayerButton.hidden = false
        viewController.rightPlayerButton.hidden = false
        
        initializePlayers()
        
        let firstPlayer = whichPlayerHasInitiative == "left" ? "\(leftPlayer.name)" : "\(rightPlayer.name)"
        viewController.statusText.text = "\(firstPlayer) has initiative."
        
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "initializeAttackRound", userInfo: nil, repeats: false)
        
        let delay: NSTimeInterval = 3.0
        let now: NSTimeInterval = audioBattleMusic.deviceCurrentTime
        audioBattleMusic.numberOfLoops = -1
        audioBattleMusic.playAtTime(NSTimeInterval(now + delay))
    }
    
    func enableLeftPlayerAttack() {
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "enableLeftPlayerAttackDelayed", userInfo: nil, repeats: false)
    }
    
    func enableLeftPlayerAttackDelayed() {
        viewController.leftPlayerAttackButton.hidden = false
        viewController.leftPlayerPotion.enabled = true
    }
    
    func enableRightPlayerAttack() {
        NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "enableRightPlayerAttackDelayed", userInfo: nil, repeats: false)
    }
    
    func enableRightPlayerAttackDelayed() {
        viewController.rightPlayerAttackButton.hidden = false
        viewController.rightPlayerPotion.enabled = true
    }
    
    func updateLeftPlayerStats() {
        viewController.leftPlayerHPStat.text = "HP:  \(leftPlayer.hitPoints)"
        viewController.leftPlayerATKStat.text = "ATK: \(leftPlayer.attackPower)"
        viewController.leftPlayerDEFStat.text = "DEF: \(leftPlayer.armorRating)"
    }
    
    func updateRightPlayerStats() {
        viewController.rightPlayerHPStat.text = "HP:  \(rightPlayer.hitPoints)"
        viewController.rightPlayerATKStat.text = "ATK: \(rightPlayer.attackPower)"
        viewController.rightPlayerDEFStat.text = "DEF: \(rightPlayer.armorRating)"
    }
    
    func playerRoundVictory() {
        
        if leftPlayer.isPlayerDefeated() {
            viewController.statusText.text = "\(rightPlayer.name) has won round \(roundNumber)."
            leftPlayerRoundsWon += 1
        } else {
            viewController.statusText.text = "\(leftPlayer.name) has won round \(roundNumber)."
            rightPlayerRoundsWon += 1
        }
        
        if leftPlayerRoundsWon < 2 && rightPlayerRoundsWon < 2 {
            NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "setupNextRound", userInfo: nil, repeats: false)
        } else {
            NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "setupGameVictory", userInfo: nil, repeats: false)
        }
    }
    
    func setupNextRound() {
        
        roundNumber += 1
        
        if roundNumber == 2 {
            if whichPlayerHasInitiative == "left" {
                whichPlayerHasInitiative = "right"
            } else {
                whichPlayerHasInitiative = "left"
            }
        }
        
        // Randomize who is first on the third round if each
        // player has won one round each so far.
        if roundNumber == 3 {
            whichPlayerHasInitiative = determineInitiative()
        }
        
        viewController.leftPlayerButton.hidden = true
        viewController.leftStackViewStats.hidden = true
        viewController.leftParchment.hidden = true
        leftPlayerPotionSelection = PotionType.None
        
        viewController.rightPlayerButton.hidden = true
        viewController.rightStackViewStats.hidden = true
        viewController.rightParchment.hidden = true
        rightPlayerPotionSelection = PotionType.None
        
        leftPlayerIsChoosingOptions = true
        proceedToPotionSelectionPhase()
    }
    
    func setupGameVictory() {
        audioVictoryCry.play()
        
        viewController.leftParchment.hidden = true
        viewController.leftStackViewStats.hidden = true
        viewController.rightParchment.hidden = true
        viewController.rightStackViewStats.hidden = true
        
        if leftPlayer.isPlayerDefeated() {
            viewController.statusText.text = "\(rightPlayer.name) is Victorious!"
        } else {
            viewController.statusText.text = "\(leftPlayer.name) is Victorious!"
        }
        
        NSTimer.scheduledTimerWithTimeInterval(7.0, target: self, selector: "initializeGame", userInfo: nil, repeats: false)
    }
}

